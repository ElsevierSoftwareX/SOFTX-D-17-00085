function [b,db] = facebubbleT(ss,nel)
% Tim Truster
% 02/29/2012
% Edge bubble function for stabilized DG 3D
% 04/21/2014 - Corrected wrong T4 bubble function

db = zeros(3,1);

r = ss(1);
s = ss(2);
t = ss(3);
twnty7 = 27.d0;
one = 1.d0;

u = one-r-s-t;
% v = one-r-s;
% w = 1-t;
    
if nel == 10
    % gives the smallest tau, and bubble has the largest curvature
b = (1-(2*r-1)^4)*(1-(2*s-1)^4)*(1-(2*u-1)^4);
db(1) = - 8*(2*r - 1)^3*((2*r + 2*s + 2*t - 1)^4 - 1)*((2*s - 1)^4 - 1) - 8*((2*r - 1)^4 - 1)*((2*s - 1)^4 - 1)*(2*r + 2*s + 2*t - 1)^3;
db(2) = - 8*(2*s - 1)^3*((2*r + 2*s + 2*t - 1)^4 - 1)*((2*r - 1)^4 - 1) - 8*((2*r - 1)^4 - 1)*((2*s - 1)^4 - 1)*(2*r + 2*s + 2*t - 1)^3;
db(3) = -8*((2*r - 1)^4 - 1)*((2*s - 1)^4 - 1)*(2*r + 2*s + 2*t - 1)^3;
% % a better bubble function than the first guess
% b = twnty7*twnty7*r*(1-r)*s*(1-s)*u*(1-u);
% db(1) = twnty7*twnty7*((1-r)*s*(1-s)*u*(1-u) - r*s*(1-s)*u*(1-u) - r*(1-r)*s*(1-s)*(1-u) + r*(1-r)*s*(1-s)*u);
% db(2) = twnty7*twnty7*(r*(1-r)*(1-s)*u*(1-u) - r*(1-r)*s*u*(1-u) - r*(1-r)*s*(1-s)*(1-u) + r*(1-r)*s*(1-s)*u);
% db(3) =-twnty7*twnty7*(r*(1-r)*s*(1-s)*(1-u) - r*(1-r)*s*(1-s)*u);
% % a bad function because the integrals of the function are smaller than
% % the bubble for the linear tetrahedral element 
% b = twnty7*twnty7*r^2*s^2*u^2;
% db(1) = twnty7*twnty7*(2*r*s^2*u^2 - 2*r^2*s^2*u);
% db(2) = twnty7*twnty7*(2*r^2*s*u^2 - 2*r^2*s^2*u);
% db(3) =-twnty7*twnty7*2*r^2*s^2*u;
% % another simple guess at a function
% b = twnty7*twnty7*r^2*s^2*u*(1-t);
% db(1) = twnty7*twnty7*(r^2*s^2*(t - 1) + 2*r*s^2*(t - 1)*(r + s + t - 1));
% db(2) = twnty7*twnty7*(r^2*s^2*(t - 1) + 2*r^2*s*(t - 1)*(r + s + t - 1));
% db(3) = twnty7*twnty7*(r^2*s^2*(r + s + t - 1) + r^2*s^2*(t - 1));
else
b = twnty7*r*s*u;
db(1) = twnty7*(s*u - r*s);
db(2) = twnty7*(r*u - r*s);
db(3) =-twnty7*r*s;
end