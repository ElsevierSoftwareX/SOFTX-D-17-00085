function [r,Xnorm] = VecNormalize(X)

r = 0;
Xnorm = zeros(1,3);

for i = 1:3
    r = r + X(i)^2;
end
r = sqrt(r);
if r < 10^-12
    r = 0;
    %Xnorm = 0;
else
    for i = 1:3
        Xnorm(i) =  X(i)/r;
    end
end