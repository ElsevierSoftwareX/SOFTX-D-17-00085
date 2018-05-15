function [b,db] = edgebubbleQ(r,s,nel)
% Tim Truster
% 08/31/2012
% Edge bubble function for stabilized DG on quadrilaterals

db = zeros(2,1);
b = 0;

pt5    = 0.5d0;
one    = 1.0d0;

if nel == 4
    
onems = one - s;
onemrsq = one - r*r;
% onemrsq = one - r*r*r*r; %Darcy

db(1) =-r*onems;
db(2) =-onemrsq*pt5;
b = onemrsq*onems*pt5;
% b = 1;onemrsq*onems^4*pt5; %Darcy

else
    %%%%%%%%%%%%% Update derivatives
    
diff_fact = 1;

% % Quadratic in s
% onems = one - s;
% onemrsq = one - r*r*r*r; %Darcy
% 
% db(1) =-diff_fact*4*r^3*onems^2*pt5;
% db(2) =-diff_fact*2*onemrsq*onems*pt5;
% b = diff_fact*onemrsq*onems^2*pt5; %Darcy

% % Linear in s
% onems = one - s;
% onemrsq = one - r*r*r*r; %Darcy
% 
% db(1) =-diff_fact*4*r^3*onems*pt5;
% db(2) =-diff_fact*onemrsq*pt5;
% b = diff_fact*onemrsq*onems*pt5; %Darcy

% Hermite in s
onems = one - s;
onemrsq = one - r*r*r*r; %Darcy

db(1) =-diff_fact*4*r^3*1/4*onems^2*(2+s);
db(2) =diff_fact*onemrsq*1/4*(-2*onems*(2+s)+onems^2);
b = diff_fact*onemrsq*1/4*onems^2*(2+s); %Darcy
    
%added 3/1/13 to improve the performance for bi-material Poisson
diff_fact = 0;
onems = one - s;
onemrsq = one - r*r;
% onemrsq = one - r*r*r*r; %Darcy

db(1) =-diff_fact*r*onems + db(1);
db(2) =-diff_fact*onemrsq*pt5 + db(2);
b = diff_fact*onemrsq*onems*pt5 + b;

end