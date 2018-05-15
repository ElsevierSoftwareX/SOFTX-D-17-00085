function [nel,ndm] = GmshNEL(Etype)
% Tim Truster
% 05/07/2018
%
% Determine number of nodes on element and spatial dimension.
switch Etype
    case 1 % 2-node line
        nel = 2;
        ndm = 1;
    case 2 % 3-node triangle
        nel = 3;
        ndm = 2;
    case 3 % 4-node quadrangle
        nel = 4;
        ndm = 2;
    case 4 % 4-node tetrahedron
        nel = 4;
        ndm = 3;
    case 5 % 8-node hexahedron
        nel = 8;
        ndm = 3;
    case 6 % 6-node prism
        nel = 6;
        ndm = 3;
    case 7 % 5-node pyramid
        nel = 15;
        ndm = 3;
    case 8 % 3-node second order line
        nel = 3;
        ndm = 1;
    case 9 % 6-node second order triangle
        nel = 6;
        ndm = 2;
    case 10 % 9-node second order quadrangle
        nel = 9;
        ndm = 2;
    case 11 % 10-node second order tetrahedron
        nel = 10;
        ndm = 3;
    case 12 % 27-node second order hexahedron
        nel = 27;
        ndm = 3;
    case 13 % 18-node second order prism
        nel = 18;
        ndm = 3;
    case 14 % 14-node second order pyramid
        nel = 14;
        ndm = 3;
    case 15 % 1-node point
        nel = 1;
        ndm = 0;
    case 16 % 8-node second order quadrangle
        nel = 8;
        ndm = 2;
    case 17 % 20-node second order hexahedron
        nel = 20;
        ndm = 3;
    case 18 % 15-node second order prism
        nel = 15;
        ndm = 3;
    case 19 % 13-node second order pyramid
        nel = 13;
        ndm = 3;
    otherwise
        error('Gmsh element type not found, check $Element list')
end