function [b,db] = edgebubble(r,s,nel)
% Tim Truster
% 02/29/2012
% Edge bubble function for stabilized DG

db = zeros(2,1);

c3 = 1-r-s;
c1 = r;
% c2 = s;
four = 4;

if nel == 3
    
b = four * c3 * c1;
db(1) = four * (c3 - c1);
db(2) =-four * c1;

else

b = four * four * c3 * (1-c3) * c1*(1-c1);
db(1) = four * four * (-(1-c3)*c1*(1-c1) + (1-c3)*c1*(1-c1) + c3*(1-c3)*(1-c1) - c3*(1-c3)*c1);
db(2) =-four * four * (-(1-c3)*c1*(1-c1) + c3*c1*(1-c1));
% b = four * c3^2 * c1^2;
% db(1) = four * (2*c3*c1^2*(-1) + 2*c1*c3^2);
% db(2) =-four * 2*c3*c1^2;
    
end