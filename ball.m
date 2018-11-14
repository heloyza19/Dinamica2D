function [Raio,bolas]=ball(X,Y,Np,Nb,bolas,n)

for a=1:1:Np
    
   L(a)=norm([X(a+1)-X(a) Y(a+1)-Y(a)]);
   Raio(a,1)=0.5*(L(a)/Nb);
   S=Raio(a,1):(2*Raio(a,1)):(L(a)-Raio(a,1));
   V=[X(a+1)-X(a) Y(a+1)-Y(a)];
   
   for b=1:1:Nb 
   bolas{n,1}(a,b)= X(a)+(S(b)*(V(1)/L(a)));
   bolas{n,2}(a,b)=Y(a)+(S(b)*(V(2)/L(a)));
   end
   
end
end