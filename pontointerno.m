function [ni]=pontointerno(X,Y,Xp,Yp)
np=size(Xp,1);
Yp(np+1)=Yp(1);
Xp(np+1)=Xp(1);
ni=0;
ordem_X=sort(Xp);
ordem_Y=sort(Yp);
Xmax=max(Xp);
Xmin=min(Xp);
Ymax=max(Yp);
Ymin=min(Yp);

if X<=Xmax & X>=Xmin & Y>=Ymin & Y<=Ymax
   
    for i=1:1:np
      if Yp(i)~=Yp(i+1)                                   %Se a reta não for horizontal
        
        if Xp(i)~=Xp(i+1)&&(min(Yp(i),Yp(i+1)))<Y && Y<=(max(Yp(i),Yp(i+1)))  %Se o Y do ponto pertencer ao intervalo y do segmento de reta
            
          a=(Yp(i)-Yp(i+1))/(Xp(i)-Xp(i+1));      
          Xr=Xp(i)+(Y-Yp(i))/a;                          %X da reta para o y do ponto

          if X<Xr                 %se o ponto estiver a esquerda do segmento de reta 
            ni=ni+1;
      
            end
        elseif Xp(i)==Xp(i+1)&&(min(Yp(i),Yp(i+1)))<Y && Y<=(max(Yp(i),Yp(i+1)));     %se o segmento de reta for vertical
           Xr=(Xp(i));

          if X<Xr                 %se o ponto estiver a esquerda do segmento de reta
            ni=ni+1;
            

            end
           end
          end
    end
end
