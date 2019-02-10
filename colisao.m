clear all;
clc; 
close (figure);

%Box
Xmin=0;
Ymin=0;
L=10;
H=10;
ang=0:0.1:2*pi;

%Dados dos objetos

Nb=10;                                          % Número de bolas em cada aresta

%Coordenadas dos vértices
posicao{1,1}=[3.2 2.5;4.2 2.5;4.2 1.0;3.2 1.0];
posicao{2,1}=[4.4  1.5;5.4 1.5; 5.4 0.5;4.4 0.5];


%Dados da dinâmica

Dados.velocidade=[40 0;-40 0];                %Velocidade tangencial

Ne=length(posicao);                             %Número de corpos

Dados.forcaext=zeros(Ne,2);
Dados.forcacont=zeros(Ne,2);
Dados.torqueext=zeros(Ne,1);
Dados.torquecont=zeros(Ne,1);
Dados.W=zeros(Ne,1);

alfa=zeros(Ne,1);
bolas=cell(Ne,2);                               %Célula com as coordenadas das bolas 

raio=cell(Ne,1);                                %Usar para descrever os pontos em coordenadas polares
teta=cell(Ne,1);                                %Usar para descrever os pontos em coordenadas polares
radius=cell(Ne,1);                              %Usar para descrever os centros das bolas em coordenadas polares
angle=cell(Ne,1);                               %Usar para descrever os centros das bolas em coordenadas polares
                
%Dados da mola
Cn=0;                                           %Constante de amortecimento (Normal)
Kn=1000000;                                     %Constante da mola (Normal)


%Cria bolas e faz seu mapeamento
[Raio,bolas,campo,N,M,dx]=criabolas(posicao,Xmin,Ymin,L,H,Ne,Nb);



for d=1:1:Ne
   
    %Determinação do centro de massa, momento de inércia e massa
  [Cm(d,1),Cm(d,2),I(d,1),Dados.massa(d,1)]=centromassa(posicao{d,1});
  %Cm=[0.7 1;1.9 1.5];
  %Dados.massa=[1;1];
  %I=[0.1667;0.1667];
  
    %Descrição dos pontos em coordenadas polares 
    %posicao--(raio,teta)
    %Bolas---(radius,angle)
    %NP=size(posicao{d,1});
    Np=length(posicao{d,1});
   [raio,teta,radius,angle]=polares(d,posicao,Cm,bolas,raio,teta,radius,angle,Np,Nb);
       
end
   
%determincação do dt
m=max(Dados.massa);
tc=2*sqrt(m/Kn);
e=0.005;
dt=e*tc;
times = 0 : dt : 0.01;

set(gca,'nextplot','replacechildren'); 
v = VideoWriter('simulacao.avi');
open(v);

%Deslocamento com o tempo
for t=1:1:length(times)
 Eelas(t)=0;
 Ek(t)=0;
 Ecr(t)=0;
 
%Plot
figure (1)
figura(bolas,Raio,posicao,Ne,Nb,L,H);   %Plota a figura

%Determinação de contatos
 for c=1:1:Ne
    [Dados,Ee]=contato(Dados,campo,Ne,c,Xmin,Ymin,dx,Cn,Kn,bolas,posicao,Raio,Cm,radius,angle,L,H,Nb);
    Eelas(t)=Eelas(t)+Ee;
 end
  
%Cálculo de forças 

forca_res=Dados.forcaext+Dados.forcacont;

Acx=forca_res(:,1)./Dados.massa;
Acy=forca_res(:,2)./Dados.massa;
aceleracao=[Acx Acy];

%Translação do centro de massa

K1=Dados.velocidade;
K2=(Dados.velocidade+(aceleracao)*dt);

Dados.velocidade(:,1)=Dados.velocidade(:,1)+Acx*dt;
Dados.velocidade(:,2)=Dados.velocidade(:,2)+Acy*dt;
Cm=Cm+dt*0.5*(K1+K2);

%Cálculo dos momentos
Mlinear=[0 0];
momento(t)=0;
Mang(t)=0;

%Rotação do objeto
for g=1:1:Ne
  
    Np=length(posicao{g,1});
    %cálculo da energia cinética
    Ek(t)=Ek(t)+ 0.5*Dados.massa(g,1)*(norm([Dados.velocidade(g,1)  Dados.velocidade(g,2)]))^2;
    Ecr(t)=Ecr(t)+0.5*I(g,1)*(Dados.W(g,1))*(Dados.W(g,1));  
    
    alfa(g,1)=Dados.torquecont(g,1)/I(g,1);
    
    c1=Dados.W(g,1);
    c2=Dados.W(g,1)+alfa(g,1)*dt;
    teta{g,1}=teta{g,1}+0.5*dt*ones(Np,1)*(c1+c2);
    Dados.W(g,1)=Dados.W(g,1)+alfa(g,1)*dt;
    
    posicao{g,1}(:,1)=ones(Np,1)*Cm(g,1)+ raio{g,1}.*cos(teta{g,1});
    posicao{g,1}(:,2)=ones(Np,1)*Cm(g,2)+ raio{g,1}.*sin(teta{g,1});
    
    Mlinear=Mlinear+Dados.massa(g,1)*[Dados.velocidade(g,1) Dados.velocidade(g,2)];
    Mang(t)=Mang(t)+I(g,1)*Dados.W(g,1);
    
    %Para as bolas
    for h=1:1:Np
       
            angle{g,1}(h,:)=angle{g,1}(h,:)+0.5*dt*ones(1,Nb)*(c1+c2);
            bolas{g,1}(h,:)=ones(1,Nb)*Cm(g,1)+(radius{g,1}(h,:)).*cos(angle{g,1}(h,:));
            bolas{g,2}(h,:)=ones(1,Nb)*Cm(g,2)+(radius{g,1}(h,:)).*sin(angle{g,1}(h,:));
       
    end
    
end

 momento(t)=norm(Mlinear);
 campo=cell(N,M);   
 Dados.forcacont=zeros(Ne,2);
 Dados.torquecont=zeros(Ne,1);
 
 for a=1:1:Ne
    for d=1:1:Np
        for e=1:1:Nb
            [i,j]=mapeamento(bolas{a,1}(d,e),bolas{a,2}(d,e),Xmin,Ymin,dx);
            T=size(campo{i,j});
            l=T(1);
            campo{i,j}(l+1,1)=e;  %Número da bola
            campo{i,j}(l+1,2)=a;  %Número do elemento
            campo{i,j}(l+1,3)=d;
        end
    end
 end
 frame=getframe(gcf);
 writeVideo(v,frame);
 
end

close(v)
Mtotal=momento+Mang;
figure(2)
plot(times,momento,'LineWidth',3);
title('Momento');
legend('Momento linear');
xlabel('Tempo');
ylabel('Momento');
box on
set(gca,'LineWidth',3);



figure (3)
box on
set(gca,'LineWidth',3);
plot(times,Ek,times,Eelas,times,Ecr, 'LineWidth',3);
%set(gca, 'YLim', [ 0 9000]);
xlabel('Tempo');
ylabel('Energia');
ax = gca;
ax.YAxis.Exponent = 2;
ax.XAxis.Exponent = -3;
legend('Energia Cinética','Energia Elástica','Energia Rotacional');
title('Energia Mecânica')
ax = gca;
ax.FontSize = 15;

Emec=Ek+Ecr+Eelas;

figure(4)
box on
set(gca,'LineWidth',3);
plot(times,Mang,'LineWidth',3);
title('Momento Angular');
legend('Momento angular');
xlabel('Tempo');
ylabel('Momento');

%figure (4)
%plot(times,Emec);
%title('Energia mecânica');
%xlabel('Times');
%ylabel('Energy');


