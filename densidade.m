function [M,m]=densidade(M,xo,yo,nx,ny,dx,dy,Xp,Yp)
m=0;
for i=1:1:nx
  for j=1:1:ny
    pos_x=xo+(i-1)*dx;
    pos_y=yo+(j-1)*dy;
    [ni]=pontointerno(pos_x,pos_y,Xp,Yp);
    if mod(ni,2)==0                 %se o ponto for externo
      M(i,j)=0;
      end
      m=m+M(i,j);                   %massa total do polígono
     end
   end   
m=dx*dy*m;
