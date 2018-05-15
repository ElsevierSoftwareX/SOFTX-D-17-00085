function [NodesOnElement,RegionOnElement,Coordinates,numnp,nen,numel,nummat,RegionsOnInterface,...
    MateT,MatTypeTable,... Optional output for FEM analysis
    NodeTypeNum,numMPC,MPCList] = ... Optional output for MPC/PBC models
    InterFunction(couplertype,InterTypes,NodesOnElement,RegionOnElement,Coordinates,numnp,numel,nummat,nen,ndm,Input_data,...
    ielNL,CZprop,MateT,MatTypeTable,... Optional input for FEM analysis
    usePBC,numMPC,MPCList,pencoeff,CornerXYZ) % Optional input for MPC/PBC models

% Check arguments, set default values
switch nargin
    case {1,2,3,4,5,6,7,8,9,10}
        error('Must supply 11 arguments')
    case 11
        ielNL = 0;
        MatTypeTable = [1:nummat; ones(1,nummat); zeros(1,nummat)];
        MateT = ones(nummat,1)*[100 .25 1];
        CZprop = 0;
        usePBC = 0;
        numMPC = 0;
        MPCList = [];
        pencoeff = [];
        CornerXYZ = [];
    case {12,13,14}
        error('Must supply 15 arguments')
    case 15
        usePBC = 0;
        numMPC = 0;
        MPCList = [];
        pencoeff = [];
        CornerXYZ = [];
    case {16,16,17,18,19}
        error('Must supply 20 arguments')
    otherwise
end

% Coupler type flags
if length(ielNL) == 1 && ielNL == 0 % default value
    iel=0;nonlin=0;
elseif length(ielNL) == 1
    iel=ielNL(1);nonlin=0;
else
    iel=ielNL(1);nonlin=ielNL(2);
end


%% Data structure copy
numEonB = Input_data.numEonB;
numEonF = Input_data.numEonF;
ElementsOnBoundary = Input_data.ElementsOnBoundary;
numSI = Input_data.numSI;
ElementsOnFacet = Input_data.ElementsOnFacet;
ElementsOnNode = Input_data.ElementsOnNode;
ElementsOnNodeDup = Input_data.ElementsOnNodeDup;
ElementsOnNodeNum = Input_data.ElementsOnNodeNum;
numfac = Input_data.numfac;
ElementsOnNodeNum2 = Input_data.ElementsOnNodeNum2;
numinttype = Input_data.numinttype;
FacetsOnElement = Input_data.FacetsOnElement;
FacetsOnElementInt = Input_data.FacetsOnElementInt;
FacetsOnInterface = Input_data.FacetsOnInterface;
FacetsOnInterfaceNum = Input_data.FacetsOnInterfaceNum;
FacetsOnNode = Input_data.FacetsOnNode;
FacetsOnNodeCut = Input_data.FacetsOnNodeCut;
FacetsOnNodeInt = Input_data.FacetsOnNodeInt;
FacetsOnNodeNum = Input_data.FacetsOnNodeNum;
NodeCGDG = Input_data.NodeCGDG;
NodeReg = Input_data.NodeReg;
NodesOnElementCG = Input_data.NodesOnElementCG;
NodesOnElementDG = Input_data.NodesOnElementDG;
NodesOnInterface = Input_data.NodesOnInterface;
NodesOnInterfaceNum = Input_data.NodesOnInterfaceNum;
numCL = Input_data.numCL;
% arrays for multi-point constraints
if usePBC
NodesOnPBC = Input_data.NodesOnPBC;
NodesOnPBCnum = Input_data.NodesOnPBCnum;
NodesOnLink = Input_data.NodesOnLink;
NodesOnLinknum = Input_data.NodesOnLinknum;
numEonPBC = Input_data.numEonPBC;
FacetsOnPBC = Input_data.FacetsOnPBC;
FacetsOnPBCNum = Input_data.FacetsOnPBCNum;
FacetsOnIntMinusPBC = Input_data.FacetsOnIntMinusPBC;
FacetsOnIntMinusPBCNum = Input_data.FacetsOnIntMinusPBCNum;
end


%% put a select branch here based on an integer input, to change the types
switch couplertype
    case 1 % Insert cohesive couplers everywhere possible
        if iel == 0
            iel = 7;
        elseif iel ~= 7
            disp('InterFunction: Warning: iel ~= 7 for cohesive couplers; likely a user error on coupler type')
        end
        InterCZall
        NodeTypeNum = 0;
    case 2 % Insert DG couplers everywhere possible
        if iel == 0
            iel = 8;
        elseif iel ~= 8
            disp('InterFunction: Warning: iel ~= 8 for DG couplers; likely a user error on coupler type')
        end
        InterDGall
        NodeTypeNum = 0;
    case 3 % Insert cohesive couplers and MPC everywhere possible
        if iel == 0
            iel = 7;
        elseif iel ~= 7
            disp('InterFunction: Warning: iel ~= 7 for cohesive couplers; likely a user error on coupler type')
        end
        InterCZallMPC
    case 4 % Insert cohesive couplers everywhere possible and MPC on certain boundaries
        if iel == 0
            iel = 7;
        elseif iel ~= 7
            disp('InterFunction: Warning: iel ~= 7 for cohesive couplers; likely a user error on coupler type')
        end
        InterCZallMPCsome
end