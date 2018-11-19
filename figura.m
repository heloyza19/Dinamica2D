function figura(bolas,Raio,posicao,Ne,Nb,L,H)
ang=0:0.1:2*pi;
for b=1:1:Ne 
    
    Xb=bolas{b,1};   
    Yb=bolas{b,2}; 
    NP=size(Xb);
    Np=NP(1);
  
for c=1:1:Np  
    for d=1:1:Nb  
        
    Xe=Xb(c,d)+Raio{b,1}(c)*cos(ang);    
    Ye=Yb(c,d)+Raio{b,1}(c)*sin(ang);
    plot(Xe,Ye);
    hold on;
    
    end
  
end

X=posicao{b,1}(:,1);
Y=posicao{b,1}(:,2);

plot(X,Y,'k');fill(X,Y,'k')
plot([0 L],[0 0],'k',[0 L],[H H],'k',[0 0],[0 H],'k',[L L],[0 H],'k','LineWidth',5);
axis([-0.1,L+0.1,-0.1,L+0.1]); 
xlabel('Coordenada x (m)');
ylabel('Coordenada y (m)');

end
hold off
