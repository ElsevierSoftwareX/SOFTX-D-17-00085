function [matID,reg1,reg2,regI,coup1,coup2] = GetCouplersIntRegions(reg1,reg2,RegionsOnInterface)
%
% Tim Truster
% 10/28/2017
%
% Determine whether any couplers exist between reg1 and reg2 in the current
% model according to the contents of the interface connectivity array,
% RegionsOnInterface.

regI = GetRegionsInt(reg1,reg2);
ind = find(RegionsOnInterface(:,4)==regI);

if ~isempty(ind)
    
    matID = RegionsOnInterface(ind,1);
    regA = RegionsOnInterface(ind,2);
    regB = RegionsOnInterface(ind,3);
    regI = RegionsOnInterface(ind,4);
    coup1 = RegionsOnInterface(ind,5);
    coup2 = RegionsOnInterface(ind,6);

    if (reg1 > reg2 && reg1~=regB && reg2~=regA) || ...
            (reg2~=regB && reg1~=regA)
        disp('Model has a problem: regions did not match')
    end
    
else
    
    matID = 0;
    regA = 0;
    regB = 0;
    regI = 0;
    coup1 = 0;
    coup2 = 0;
    
end
