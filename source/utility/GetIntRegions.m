function [mat1,mat2] = GetIntRegions(regI,nummat)
%
% Tim Truster
% 04/06/2017
%
% given interface region type and number of solid regions, output the ID of
% the regions on the left and right of the interface

interreg2 = zeros(nummat,nummat);
for reg2 = 1:nummat
    for reg1 = 1:reg2
        regC = reg2*(reg2-1)/2 + reg1;
        interreg2(reg2,reg1) = regC;
    end
end
ind = find(interreg2==regI);
[mat2,mat1] = ind2sub(nummat,ind);
