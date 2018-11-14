function [Fn]=Fnormal(N,Cn,Kn,Vax,Vay,Vbx,Vby,ra,rb,d)
    Va=[Vax Vay];
    Vb=[Vbx Vby];
    Fne=Kn*((ra+rb)-d);
    V=Va-Vb;
 
    Vrn=dot(N,V);
    Fnd=Cn*(Vrn);
    Fn=N*(Fne+Fnd);
   
end