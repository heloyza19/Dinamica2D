function  [Dados,Ee]=contato(Dados,campo,ne,c,Xmin,Ymin,dx,Cn,Kn,bolas,posicao,Raio,Cm,radius,angle,L,H) 
Ee=0;
Np=length(posicao{c,1});    %Número de lados       
for j=1:1:Np                %Para cada aresta
Nb=length(bolas{c,1});
for k=1:1:Nb                %Para cada bola da aresta  
    
Xa=bolas{c,1}(j,k);
Ya=bolas{c,2}(j,k);
[P1,P2]=mapeamento(Xa,Ya,Xmin,Ymin,dx);

 Tr=Raio{c,1}(j,1);
 T1=bolas{c,1}(j,k);            %Coodenada x da bola
 T2=bolas{c,2}(j,k);            %coordenada y da bola
  if (T1 <= Tr)        %colisão lateral
      N=[1 0];
      D=bolas{c,1}(j,k);
      Fn=Fnormal(N,Cn,Kn,Dados.velocidade(c,1),Dados.velocidade(c,2),0,0,Raio{c,1}(j,1),0,D);
       Dados.forcacont(c,1)=Dados.forcacont(c,1)+Fn(1);
       Dados.forcacont(c,2)=Dados.forcacont(c,2)+Fn(2);
       
       Ee=Ee+(0.5*Kn*(Raio{c,1}(j,1)-D)^2);

  elseif (T1 >= (L-Tr))
      N=[-1 0];
      D=(L-bolas{c,1}(j,k));
      Fn=Fnormal(N,Cn,Kn,Dados.velocidade(c,1),Dados.velocidade(c,2),0,0,Raio{c,1}(j,1),0,D);
      Dados.forcacont(c,1)=Dados.forcacont(c,1)+Fn(1);
      Dados.forcacont(c,2)=Dados.forcacont(c,2)+Fn(2);
      Ee=Ee+(0.5*Kn*(Raio{c,1}(j,1)-D)^2);
      
  elseif (T2 <= Tr) 
      N=[0 1];
      D=bolas{c,2}(j,k);
      Fn=Fnormal(N,Cn,Kn,Dados.velocidade(c,1),Dados.velocidade(c,2),0,0,Raio{c,1}(j,1),0,D);
      Dados.forcacont(c,1)=Dados.forcacont(c,1)+Fn(1);
      Dados.forcacont(c,2)=Dados.forcacont(c,2)+Fn(2);
      Ee=Ee+(0.5*Kn*(Raio{c,1}(j,1)-D)^2);
      
  elseif (T2 >= (H-Tr))
      N=[0 -1];
      D=(H-bolas{c,2}(j,k));
      Fn=Fnormal(N,Cn,Kn,Dados.velocidade(c,1),Dados.velocidade(c,2),0,0,Raio{c,1}(j,1),0,D);
      Dados.forcacont(c,1)=Dados.forcacont(c,1)+Fn(1);
      Dados.forcacont(c,2)=Dados.forcacont(c,2)+Fn(2);
      Ee=Ee+(0.5*Kn*(Raio{c,1}(j,1)-D)^2);
       
  else
    c1=-1;
    c2=1;
    C1=-1;
    C2=1;
    if P1==1
        c1=0;
    elseif P1==10
        c2=0;
    end
    if P2==1
      C1=0;
    elseif P2==10
      C2=0;
    end

    %Percorre as células vizinhas
     for ca=c1:1:c2                       %Verifica nas células vizinhas   (x-1,x+0,x+1)
        for cb=C1:1:C2                                                    %(Y-1,y+0,Y+1) 

          Tcv=size(campo{P1+ca,P2+cb});               %Tamanho da célula 
          Tc=Tcv(1);
               if (Tc)>0                               %Se a célula vizinha não for vazia, verifica o contato
                 for cc=1:1:Tc                         %Cada elemento da célula

                    p=(campo{P1+ca,P2+cb}(cc,1));                      %Verifica os elementos da célula

                    if (campo{P1+ca,P2+cb}(cc,2))<c     %(campo{P1,P2}(c,2)) %Se a bola for de um elemento diferente

                        B=campo{P1+ca,P2+cb}(cc,1);      %N bola
                        E=campo{P1+ca,P2+cb}(cc,2);      %N Elemento

                        Na=ceil(B/Nb);                  %N da aresta
                        Nba=mod(B,Nb);                 %N da bola na aresta

                        if Nba==0
                           Nba=Nb; 
                        end

                        Xb=bolas{E,1}(Na,Nba);      
                        Yb=bolas{E,2}(Na,Nba);



                        D=norm([Xb-Xa Yb-Ya]);

                        if D<(Raio{E,1}(Na,1)+Raio{c,1}(j,1))

                            N=[(Xa-Xb)/D (Ya-Yb)/D];
                            Fn=Fnormal(N,Cn,Kn,Dados.velocidade(c,1),Dados.velocidade(c,2),Dados.velocidade(E,1),Dados.velocidade(E,2),Raio{c,1}(j,1),Raio{E,1}(Na,1),D);

                            %Calculo de torque
                            F1=Fn;
                            R1=[Xa-Cm(c,1)  Ya-Cm(c,2)];
                            ang1=acos((dot(F1,R1))/(norm(R1)*norm(F1)));
                            torque1=norm(F1)*norm(R1)*sin(ang1); 
                            
                            Dados.torquecont(c,1)=Dados.torquecont(c,1)+torque1;     
                            
                            F2=-Fn;
                            R2=[Xb-Cm(E,1)  Yb-Cm(E,2)];
                            ang2=acos((dot(F2,R2))/(norm(R2)*norm(F2)));
                            torque2=norm(F1)*norm(R1)*sin(ang1); 
                            
                            Dados.torquecont(E,1)=Dados.torquecont(E,1)+torque2;

                            Dados.forcacont(c,1)=Dados.forcacont(c,1)+Fn(1);
                            Dados.forcacont(c,2)=Dados.forcacont(c,2)+Fn(2);

                            Dados.forcacont(E,1)=Dados.forcacont(E,1)-Fn(1);
                            Dados.forcacont(E,2)=Dados.forcacont(E,2)-Fn(2);

                            Ee=Ee+(0.5*Kn*(Raio{c,1}(j,1)+Raio{E,1}(Na,1)-D)^2); 
                            
                         end
                     end
                   end
                end       
            end
     end
  end
      end
    end
end
