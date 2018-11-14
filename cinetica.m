function [Ek]=cinetica(Dados,i)
v=norm([Dados.velocidade(i,1)  Dados.velocidade(i,2)]);
Ek=Dados.massa(i)*v*v*0.5;
end