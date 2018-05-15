% Default parameter values
% Tim Truster
% 10/06/2013

%% Default values for solution algorithm parameters

% BC/IC/Load input counters, NCR=1, and error checks
if ~exist('numComp','var')
    numComp = 0; % Tying node commands
elseif numComp > 0 && ~exist('NodeComp','var')
    error('NodeComp is not defined')
elseif numComp > 0 && numComp < size(NodeComp,1)
    disp('Warning, node tying: numComp < size(NodeComp,1)')
    disp('Paused: press any key to continue')
end

if ~exist('numBC','var')
    numBC = 0; % Boundary condition, scaled by lamda
elseif numBC > 0 && ~exist('NodeBC','var')
    error('NodeBC is not defined')
elseif numBC > 0 && numBC < size(NodeBC,1)
    disp('Warning, node BC: numBC < size(NodeBC,1)')
    disp('Paused: press any key to continue')
end

if ~exist('numNodalF','var')
    numNodalF = 0; % Nodal loads, scaled by lamda
elseif numNodalF > 0 && ~exist('NodeLoad','var')
    error('NodeLoad is not defined')
elseif numNodalF > 0 && numNodalF < size(NodeLoad,1)
    disp('Warning, node loads: numNodalF < size(NodeLoad,1)')
    disp('Paused: press any key to continue')
end

if ~exist('numSL','var')
    numSL = 0; % Surface loads, scaled by lamda, isw=-1
elseif numSL > 0 && ~exist('SurfacesL','var')
    error('SurfacesL is not defined')
elseif numSL > 0 && numSL < size(SurfacesL,1)
    disp('Warning, surface loads: numSL < size(SurfacesL,1)')
    disp('Paused: press any key to continue')
end

if ~exist('intfl','var')
    intfl = 0; % T/F flag to include body forces
elseif ~exist('numBF','var')
    numBF = 0; % Number of material sets with body forces
elseif numBF > 0 && ~exist('BodyForce','var')
    error('BodyForce is not defined')
elseif numBF > 0 && numBF < size(BodyForce,1)
    disp('Warning, body forces: numBF < size(BodyForce,1)')
    disp('Paused: press any key to continue')
end

if ~exist('numSI','var')
    numSI = 0; % Interface elements
% elseif numSI > 0 && ~exist('SurfacesI','var')
%     error('SurfacesI is not defined')
% elseif numSI > 0 && numSI < size(SurfacesI,1)
%     disp('Warning, interfaces: numSI < size(SurfacesI,1)')
%     disp('Paused: press any key to continue')
end
