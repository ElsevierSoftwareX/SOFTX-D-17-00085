function regI = GetRegionsInt(reg1,reg2)
%
% Tim Truster
% 04/06/2017
%
% given interface region type and number of solid regions, output the ID of
% the regions on the left and right of the interface

if reg1 > reg2
    temp = reg2;
    reg2 = reg1;
    reg1 = temp;
end
regI = reg2*(reg2-1)/2 + reg1;
