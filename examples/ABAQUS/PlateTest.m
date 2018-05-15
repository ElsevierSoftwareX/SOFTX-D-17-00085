% Tim Truster
% 04/9/2016
%
% Conversion file for Abaqus input for cracked plate problem
%
% Just loads the quadrilateral mesh

clear
% clc
NCR = 1;

%% Read in the .inp file
ndm = 2;
Abaqfile = 'PlateTest.inp';
AbaqusInputReader


%% Commands to run in FEA_Program
NodeBC = [NodeBCholder{1}; NodeBCholder{2}; NodeBCholder{3}; NodeBCholder{4}; NodeBCholder{5}];
numBC = size(NodeBC,1);
MateT = zeros(3,3);
MateT(1,:) = [29000., 0.3 1];
MateT(2,:) = [29000., 0.3 1];
MateT(3,:) = [29000., 0.3 1];
ProbType = [numnp numel nummat 2 2 nen];
% Output quantity flags
DHist = 1;
FHist = 1;
SHist = 1;
SEHist = 1;
