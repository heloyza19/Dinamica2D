function [raio,teta,radius,angle]=polares(d,posicao,Cm,bolas,raio,teta,radius,angle,Np,Nb)

for e=1:1:Np
        
    raio{d,1}(e,1)=sqrt(((posicao{d,1}(e,1))-(Cm(d,1)))^2+ ((posicao{d,1}(e,2))-(Cm(d,2)))^2);
    teta{d,1}(e,1)=atan(((posicao{d,1}(e,2))-(Cm(d,2)))/((posicao{d,1}(e,1))-(Cm(d,1))));
     
        if ((posicao{d,1}(e,1))<(Cm(d,1))) 
             teta{d,1}(e)= teta{d,1}(e)+pi;
        end
     
     for f=1:1:Nb
        radius{d,1}(e,f)=sqrt(((bolas{d,1}(e,f))-(Cm(d,1)))^2+ ((bolas{d,2}(e,f))-(Cm(d,2)))^2);
        angle{d,1}(e,f)=atan(((bolas{d,2}(e,f))-(Cm(d,2)))/((bolas{d,1}(e,f))-(Cm(d,1))));

        if ((bolas{d,1}(e,f))<(Cm(d,1)))
             angle{d,1}(e,f)= angle{d,1}(e,f)+pi;
        end
        end   
    end       