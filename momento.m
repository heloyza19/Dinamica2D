function [I]=momento(Xc,Yc,M,xo,yo,nx,ny,dx,dy)
Iy=0;
Ix=0;
A=dx*dy;
for i=1:1:nx  
  x(i)=xo+(i-1)*dx;
  for j=1:1:ny
    Iy=Iy+((x(i)-Xc)^2)*M(i,j);
  end
end
for k=1:1:ny
  y(k)=yo+(k-1)*dy;
  for l=1:1:nx
    Ix=Ix+((y(k)-Yc)^2)*M(l,k);
  end
end

I=Ix*A+Iy*A;