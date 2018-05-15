function [b,db] = facebubbleQ(ss,nel)
% Tim Truster
% 02/29/2012
% face bubble function for stabilized DG Q4
% Pinlei Chen
% 05/14/2013

if nel == 8
   one = 1.d0;
   two = 2.d0;
   db=zeros(3,1);
   r=ss(1);
   s=ss(2);
   t=ss(3);
   onemrsq = one-r*r;
   onemssq = one-s*s;
   bubble(1) =-two*r*onemssq*(1-t);
   bubble(2) =-two*s*onemrsq*(1-t);
   bubble(3) = -onemrsq*onemssq;
   b = onemrsq*onemssq*(1-t);
   db(1)=bubble(1);
   db(2)=bubble(2);
   db(3)=bubble(3);
else %nel == 27
    
    diff_fact = 1;
    
    % Hermite in t
    one = 1.d0;
    two = 2.d0;
    pt5 = one/two;
    r=ss(1);
    s=ss(2);
    t=ss(3);
    onemt = one - t;
    onemrsq = one - r*r*r*r;
    onemssq = one - s*s*s*s;
    
    db=zeros(3,1);

    db(1) =-diff_fact*4*r^3*pt5*onemssq*pt5*1/4*onemt^2*(2+t);
    db(2) =-diff_fact*onemrsq*pt5*4*s^3*pt5*1/4*onemt^2*(2+t);
    db(3) =diff_fact*onemrsq*pt5*onemssq*pt5*1/4*(-2*onemt*(2+t)+onemt^2);
    b = diff_fact*onemrsq*pt5*onemssq*pt5*1/4*onemt^2*(2+t);
    
end