function [xc,yc,I,m]=centromassa(pt)

Xp=pt(:,1);
Yp=pt(:,2);

Mx=0;       %contador
My=0;       %contador
Ix=0;       %contador
Iy=0;       %contador

dx=0.001;
dy=dx;      %mudar caso dy!=dx

A= dx*dy;
ordem_x=sort(Xp);
ordem_y=sort(Yp);
np=size(Xp,1);            %Número de pontos do polígono

xo=round(ordem_x(1)-1);   %ponto x inicial, localizado  uma unidade antes do primeiro ponto do polígono;
yo=round(ordem_y(1)-1);   %ponto y inicial, idem.
xn=round(ordem_x(np)+1);
yn=round(ordem_y(np)+1);

nx=ceil((xn-xo)/dx);       %número de intervalos em x
ny=ceil((yn-yo)/dy);       %idem em Y

M=ones(nx,ny);            %Matriz da massa específica
[M,m]=densidade(M,xo,yo,nx,ny,dx,dy,Xp,Yp);

for i=1:1:nx  
  x(i)=xo+(i-1)*dx;
  
  for j=1:1:ny
    My=My+x(i)*M(i,j);  
    
  end
end

for k=1:1:ny
  y(k)=yo+(k-1)*dy;
  
  for l=1:1:nx
    Mx=Mx+y(k)*M(l,k);
    
  end
end

xc=A*(My/m);    %X do centro de massa
yc=A*(Mx/m) ;   %Y do centro de massa

[I]=momento(xc,yc,M,xo,yo,nx,ny,dx,dy);
