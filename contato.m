function  [Dados,Ee]=contato(Dados,campo,ne,Nobj,Xmin,Ymin,dx,Cn,Kn,bolas,posicao,Raio,Cm,radius,angle,L,H,Nb) 
Ee=0;
Np=length(posicao{Nobj,1});    %N�mero de lados       
for A=1:1:Np                %Para cada aresta
for B=1:1:Nb                %Para cada bola da aresta  
    
Xa=bolas{Nobj,1}(A,B);
Ya=bolas{Nobj,2}(A,B);
[P1,P2]=mapeamento(Xa,Ya,Xmin,Ymin,dx);

 Tr=Raio{Nobj,1}(A,1);
 T1=bolas{Nobj,1}(A,B);            %Coodenada x da bola
 T2=bolas{Nobj,2}(A,B);            %coordenada y da bola
 
 %Colis�o com as paredes
 
  %colis�o lateral
  if (T1 <= Tr)       
      N=[1 0];
      D=bolas{Nobj,1}(A,B);
      Fn=Fnormal(N,Cn,Kn,Dados.velocidade(Nobj,1),Dados.velocidade(Nobj,2),0,0,Raio{Nobj,1}(A,1),0,D);
       Dados.forcacont(Nobj,1)=Dados.forcacont(Nobj,1)+Fn(1);
       Dados.forcacont(Nobj,2)=Dados.forcacont(Nobj,2)+Fn(2);
       
       Ee=Ee+(0.5*Kn*(Raio{Nobj,1}(A,1)-D)^2);

  elseif (T1 >= (L-Tr))
      N=[-1 0];
      D=(L-bolas{Nobj,1}(A,B));
      Fn=Fnormal(N,Cn,Kn,Dados.velocidade(Nobj,1),Dados.velocidade(Nobj,2),0,0,Raio{Nobj,1}(A,1),0,D);
      Dados.forcacont(Nobj,1)=Dados.forcacont(Nobj,1)+Fn(1);
      Dados.forcacont(Nobj,2)=Dados.forcacont(Nobj,2)+Fn(2);
      Ee=Ee+(0.5*Kn*(Raio{Nobj,1}(A,1)-D)^2);
  end
  
  %Colis�o superior/inferior
  if (T2 <= Tr) 
      N=[0 1];
      D=bolas{Nobj,2}(A,B);
      Fn=Fnormal(N,Cn,Kn,Dados.velocidade(Nobj,1),Dados.velocidade(Nobj,2),0,0,Raio{Nobj,1}(A,1),0,D);
      Dados.forcacont(Nobj,1)=Dados.forcacont(Nobj,1)+Fn(1);
      Dados.forcacont(Nobj,2)=Dados.forcacont(Nobj,2)+Fn(2);
      Ee=Ee+(0.5*Kn*(Raio{Nobj,1}(A,1)-D)^2);
      
  elseif (T2 >= (H-Tr))
      N=[0 -1];
      D=(H-bolas{Nobj,2}(A,B));
      Fn=Fnormal(N,Cn,Kn,Dados.velocidade(Nobj,1),Dados.velocidade(Nobj,2),0,0,Raio{Nobj,1}(A,1),0,D);
      Dados.forcacont(Nobj,1)=Dados.forcacont(Nobj,1)+Fn(1);
      Dados.forcacont(Nobj,2)=Dados.forcacont(Nobj,2)+Fn(2);
      Ee=Ee+(0.5*Kn*(Raio{Nobj,1}(A,1)-D)^2);
  end
    
  %Colis�o entre objetos 
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

    %Percorre as c�lulas vizinhas
     for ca=c1:1:c2                       %Verifica nas c�lulas vizinhas   (x-1,x+0,x+1)
        for cb=C1:1:C2                                                    %(Y-1,y+0,Y+1) 

          Tcv=size(campo{P1+ca,P2+cb});               %Tamanho da c�lula 
          Tc=Tcv(1);
          
               if (Tc)>0                               %Se a c�lula vizinha n�o for vazia, verifica o contato
                 for cc=1:1:Tc                         %Cada elemento da c�lula
                     
                    %p=(campo{P1+ca,P2+cb}(cc,1));                      %Verifica os elementos da c�lula
                    if (campo{P1+ca,P2+cb}(cc,2))>Nobj     %(campo{P1,P2}(c,2)) %Se a bola for de um elemento diferente
                        %disp(campo{P1+ca,P2+cb})
                        Nba=campo{P1+ca,P2+cb}(cc,1);      %N bola
                        E=campo{P1+ca,P2+cb}(cc,2);        %N Elemento
                        Na=campo{P1+ca,P2+cb}(cc,3);       %Numero da aresta
                                 

                        Xb=bolas{E,1}(Na,Nba);      
                        Yb=bolas{E,2}(Na,Nba);

                        D=norm([Xb-Xa Yb-Ya]);
                      
                        if D<(Raio{E,1}(Na,1)+Raio{Nobj,1}(A,1))
                            
                            N=[(Xa-Xb) (Ya-Yb)]*(1/D);
                            Fn=Fnormal(N,Cn,Kn,Dados.velocidade(Nobj,1),Dados.velocidade(Nobj,2),Dados.velocidade(E,1),Dados.velocidade(E,2),Raio{Nobj,1}(A,1),Raio{E,1}(Na,1),D);

                            %Calculo de torque
                                   
                            F1x=[Fn(1)  0];
                            R1=[(Xa-Cm(Nobj,1))  (Ya-Cm(Nobj,2))];
                            if F1x(1)==0
                                torque1x=0;
                            else
                            ang1x=acos((dot(F1x,R1))/(norm(R1)*norm(F1x)));
                            torque1x=norm(F1x)*norm(R1)*sin(ang1x);
                                if (F1x(1)>0 & Ya>Cm(Nobj,2))
                                    torque1x=-torque1x;
                                elseif (F1x(1)<0 & Ya<Cm(Nobj,2))
                                    torque1x=-torque1x;
                                end
                            end
                            
                            F1y=[0  Fn(2)];
                            if F1y(2)==0
                                torque1y=0;
                            else
                                ang1y=acos((dot(F1y,R1))/(norm(R1)*norm(F1y)));
                                torque1y=norm(F1y)*norm(R1)*sin(ang1y);
                                if (F1y(2)>0 & Xa<Cm(Nobj,1))
                                    torque1y=-torque1y;
                                elseif (F1y(2)<0 &  Xa>Cm(Nobj,1))
                                    torque1y=-torque1y;
                                end
                            torque1=torque1x+torque1y;
                            Dados.torquecont(Nobj,1)=Dados.torquecont(Nobj,1)+torque1;  
                            
                            F2x=[-Fn(1)  0];
                            R2=[(Xb-Cm(E,1))  (Yb-Cm(E,2))];
                            if F2x(1)==0
                                torque2x=0;
                            else  
                            ang2x=acos((dot(F2x,R2))/(norm(R2)*norm(F2x)));
                            torque2x=norm(F2x)*norm(R2)*sin(ang2x);
                                if (F2x(1)>0 & Yb>Cm(E,2))
                                   torque2x=-torque2x;
                                elseif (F2x(1)<0 & Yb<Cm(E,2))
                                    torque2x=-torque2x;
                                end
                            end
                            
                            
                            F2y=[0  -Fn(2)];
                            
                            if F2y(2)==0
                                torque2y=0;
                            else
                              ang2y=acos((dot(F2y,R2))/(norm(R2)*norm(F2y)));
                              torque2y=norm(F2y)*norm(R2)*sin(ang2y);  
                                if (F2y(2)>0 &  Xb<Cm(E,1))
                                   torque2y=-torque2y;
                                elseif (F2y(2)<0 & Xb>Cm(E,1))
                                   torque2y=-torque2y;
                                end
                            end
                            
                            torque2=torque2x+torque2y;
                            Dados.torquecont(E,1)=Dados.torquecont(E,1)+torque2;

                            
                            
                            Dados.forcacont(Nobj,1)=Dados.forcacont(Nobj,1)+Fn(1);
                            Dados.forcacont(Nobj,2)=Dados.forcacont(Nobj,2)+Fn(2);

                            Dados.forcacont(E,1)=Dados.forcacont(E,1)-Fn(1);
                            Dados.forcacont(E,2)=Dados.forcacont(E,2)-Fn(2);
                            
                            %Energia el�stica
                            Ee=Ee+(0.5*Kn*(Raio{Nobj,1}(A,1)+Raio{E,1}(Na,1)-D)^2); 
                            
                         end
                     end
                   end
                end       
            end
     end
  end
      end
end
