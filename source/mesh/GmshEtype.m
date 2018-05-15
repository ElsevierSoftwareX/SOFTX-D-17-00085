function Etype = GmshEtype(nel,ndm)
% Tim Truster
% 05/07/2018
%
% Determine number of nodes on element and spatial dimension.
if ndm == 0
    if nel == 1
        Etype = 15;
    else
        error('only nel=0 for ndm=0')
    end
elseif ndm == 1
    if nel == 2
        Etype = 1;
    elseif nel == 3
        Etype = 8;
    else
        error('invalid nel for ndm=1')
    end
elseif ndm == 2
    switch nel
        case 3 % 3-node triangle
            Etype = 2;
        case 4 % 4-node quadrangle
            Etype = 3;
        case 6 % 6-node second order triangle
            Etype = 9;
        case 9 % 9-node second order quadrangle
            Etype = 10;
        case 8 % 8-node second order quadrangle
            Etype = 216;
        otherwise
            error('invalid nel for ndm=2')
    end
elseif ndm == 3
    switch nel
        case 4 % 4-node tetrahedron
            Etype = 4;
        case 8 % 8-node hexahedron
            Etype = 5;
        case 6 % 6-node prism
            Etype = 6;
        case 5 % 5-node pyramid
            Etype = 7;
        case 10 % 10-node second order tetrahedron
            Etype = 11;
        case 27 % 27-node second order hexahedron
            Etype = 12;
        case 18 % 18-node second order prism
            Etype = 13;
        case 14 % 14-node second order pyramid
            Etype = 14;
        case 20 % 20-node second order hexahedron
            Etype = 17;
        case 15 % 15-node second order prism
            Etype = 18;
        case 13 % 13-node second order pyramid
            Etype = 19;
        otherwise
            error('invalid nel for ndm=3')
    end
else
    error('only 0<=ndm<=3 is allowed')
end