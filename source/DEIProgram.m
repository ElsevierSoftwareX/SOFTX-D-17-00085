% Program: DEIProgram2
% Tim Truster
% 08/15/2014
%
% Script to convert CG mesh (e.g. from block program output) into DG mesh
% Addition of modules to insert interfaces selectively between materials
% 
% Input: matrix InterTypes(nummat,nummat) for listing the interface
% material types to assign; only lower triangle is accessed; value 0 means
% interface is not inserted between those materials (including diagonal).
%
% Numbering of interface types (matI) is like:
% 1
% 2 3
% 4 5 6 ...
%
% Output:
% Actual list of used interfaces is SurfacesI and numCL, new BC arrays and
% load arrays
% Total list of interfaces is in numIfac and Interfac, although there is
% no designation on whether the interfaces are active or not. These are
% useful for assigning different DG element types to different interfaces.

if ~exist('ndm','var')
    error('ndm not defined')
elseif ndm == 2
    DEIProgram2
elseif ndm == 3
    DEIProgram3
else
    error('invalid value for ndm')
end
    
    