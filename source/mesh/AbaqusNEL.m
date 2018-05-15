function nel = AbaqusNEL(Etype,ndm)
% Tim Truster
% 09/12/2014
%
% Determine number of nodes on element.
if ndm == 3
    if strcmp(Etype,'C3D4') || strcmp(Etype,'C3D4H')
        nel = 4;
    elseif strcmp(Etype,'C3D6') || strcmp(Etype,'C3D6H') || strcmp(Etype,'C3D6R') ...
        || strcmp(Etype,'COH3D6')
        nel = 6;
    elseif strcmp(Etype,'C3D8') || strcmp(Etype,'C3D8H') || strcmp(Etype,'C3D8I') ... 
        || strcmp(Etype,'C3D8IH') || strcmp(Etype,'C3D8R') || strcmp(Etype,'C3D8RH') ...
        || strcmp(Etype,'COH3D8')
        nel = 8;
    elseif strcmp(Etype,'C3D10') || strcmp(Etype,'C3D10H') || strcmp(Etype,'C3D10M') ...
        || strcmp(Etype,'C3D10MH')
        nel = 10;
    elseif strcmp(Etype,'COH3D12')
        nel = 12;
    elseif strcmp(Etype,'C3D20') || strcmp(Etype,'C3D20H') || strcmp(Etype,'C3D20R') ...
        || strcmp(Etype,'C3D20RH')
        nel = 20;
    end
elseif ndm == 2
    if strcmp(Etype,'CPE3') || strcmp(Etype,'CPE3H') || strcmp(Etype,'CPS3')
        nel = 3;
    elseif strcmp(Etype,'CPE4') || strcmp(Etype,'CPE4H') || strcmp(Etype,'CPE4I') ... 
        || strcmp(Etype,'CPE4IH') || strcmp(Etype,'CPE4R') || strcmp(Etype,'CPE4RH') ... 
        || strcmp(Etype,'CPS4') || strcmp(Etype,'CPS4I') || strcmp(Etype,'CPS4R') ... 
        || strcmp(Etype,'COH2D4')
        nel = 4;
    elseif strcmp(Etype,'CPE6') || strcmp(Etype,'CPE6H') || strcmp(Etype,'CPE6M') ...
        || strcmp(Etype,'CPE6MH') || strcmp(Etype,'CPS6') || strcmp(Etype,'CPS6M')
        nel = 6;
    elseif strcmp(Etype,'CPE8') || strcmp(Etype,'CPE8H') || strcmp(Etype,'CPE8R') ...
        || strcmp(Etype,'CPE8RH') || strcmp(Etype,'CPS8') || strcmp(Etype,'CPS8R')
        nel = 8;
    end
end

end