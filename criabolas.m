function [Raio,bolas,campo,N,M,dx]=criabolas(posicao,Xmin,Ymin,L,H,Ne,Nb)
bolas=cell(Ne,2);
for a=1:1:Ne
    Np=length(posicao{a,1});
    X=posicao{a,1}(:,1);               
    Y=posicao{a,1}(:,2);
    
    X(Np+1)=X(1);
    Y(Np+1)=Y(1);
    [Raio{a,1},bolas]=ball(X,Y,Np,Nb,bolas,a);
    X(Np+1)=[];
    Y(Np+1)=[];
    
    Rm(a)=max(max(Raio{a,1}));
   
end

dx=max(Rm);
dy=dx;
N=ceil((L)/dx);
M=ceil((H)/dy);
campo=cell(N,M); 


for b=1:1:Ne
    
    %Mapeamento das bolas
    for d=1:1:Np
        for e=1:1:Nb
            [i,j]=mapeamento(bolas{b,1}(d,e),bolas{b,2}(d,e),Xmin,Ymin,dx);
            T=size(campo{i,j});
            l=T(1);
            campo{i,j}(l+1,1)=e;  %Número da bola
            campo{i,j}(l+1,2)=b;  %Número do elemento
        end
        
    end
end

