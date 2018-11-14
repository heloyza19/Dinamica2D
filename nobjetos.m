clear all;
clc; close (figure);
%Box
L=10;
h=10;
teta=0:0.1:2*pi;

%Tempo
dt=0.001;
times=0:dt:1;

%Dados dos objetos
Nb=10;                                           % Número de bolas em cada aresta
posicao{1,1}=[0 0;10 0];
%posicao{1,1}=[0 2; 1 1; 2 1; 3 2; 2 3; 1 3];    %Coodernadas dos vértices 
posicao{2,1}=[ 3 3; 4 3; 4 4; 3 4];             %Objeto 2
%NC=size(posicao);                               %Número de corpos
Nc=length(posicao);
velocidade=[0 0];
aceleracao=zeros(Nc,2);
bolas=cell(Nc,1);                              %Célula com as coordenadas das bolas 
chao=[0 0;5 0];


for a=1:1:Nc
   
    Pt=posicao{a,1};         %Matriz com as coodenadas dos vértices do polígono 
    Np=length(Pt);           %Número de vértices
    X=Pt(:,1);               
    Y=Pt(:,2);
    X(Np+1)=X(1);
    Y(Np+1)=Y(1);
    [Raio,bolas]=ball(X,Y,Np,Nb,bolas,a);
    X(Np+1)=[];
    Y(Np+1)=[];
   
    
end

for t=1:1:length(times)
%%%Plot%%%%
 for b=1:1:Nc   
    Xb=bolas{b,1};   
    Yb=bolas{b,2}; 
for c=1:1:Np
    for d=1:1:Nb
    hold on;    
    Xe=Xb(c,d)+Raio(c)*cos(teta);
    Ye=Yb(c,d)+Raio(c)*sin(teta);
    plot(Xe,Ye);
    hold off;
    
    end
end

Pt=posicao{b,1};
X=Pt(:,1);
Y=Pt(:,2);
hold on
plot(X,Y,'r');fill(X,Y,'w')
axis([-0.1,L+0.1,-0.1,L+0.1]); 
xlabel('Coordenada x (m)');
ylabel('Coordenada y (m)');

hold off
 end
 
 
 
 
 
 
 
 
 
  frame=getframe(gcf);
  writeVideo(v,frame);
end
close(v);



%Atualiza a posicao
%%

%end

