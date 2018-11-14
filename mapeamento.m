function [i,j]=mapeamento(x,y,X0,Y0,dx)
i=floor((x-X0)/dx)+1;
j=floor((y-Y0)/dx)+1;
end