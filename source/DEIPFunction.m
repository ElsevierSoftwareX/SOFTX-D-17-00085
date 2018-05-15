function [NodesOnElement,RegionOnElement,Coordinates,numnp,Output_data,MPCList,numMPC] = DEIPFunction(InterTypes,NodesOnElement,RegionOnElement,Coordinates,numnp,numel,nummat,nen,ndm,usePBC,numMPC,MPCList)
%
switch nargin
    case {1,2,3,4,5,6,7,8}
        error('Must supply nine arguments')
    case 9
        usePBC = 0;
        numMPC = 0;
        MPCList = [];
    case {10,11}
        error('Must supply twelve arguments')
    otherwise
end

if ~exist('ndm','var')
    error('ndm not defined')
elseif ndm == 2
    DEIProgram2
elseif ndm == 3
    DEIProgram3
else
    error('invalid value for ndm')
end

if exist('OCTAVE_VERSION', 'builtin')
    MatOct = 1;
else
    MatOct = 0;
end
if MatOct == 0 % data structures seem to only work with later Octave versions
    Output_data = facet_data;
end

Output_data.numEonB = numEonB;
Output_data.numEonF = numEonF;
Output_data.ElementsOnBoundary = ElementsOnBoundary;
Output_data.numSI = numSI;
Output_data.ElementsOnFacet = ElementsOnFacet;
Output_data.ElementsOnNode = ElementsOnNode;
Output_data.ElementsOnNodeDup = ElementsOnNodeDup;
Output_data.ElementsOnNodeNum = ElementsOnNodeNum;
Output_data.numfac = numfac;
Output_data.ElementsOnNodeNum2 = ElementsOnNodeNum2;
Output_data.numinttype = numinttype;
Output_data.FacetsOnElement = FacetsOnElement;
Output_data.FacetsOnElementInt = FacetsOnElementInt;
Output_data.FacetsOnInterface = FacetsOnInterface;
Output_data.FacetsOnInterfaceNum = FacetsOnInterfaceNum;
Output_data.FacetsOnNode = FacetsOnNode;
Output_data.FacetsOnNodeCut = FacetsOnNodeCut;
Output_data.FacetsOnNodeInt = FacetsOnNodeInt;
Output_data.FacetsOnNodeNum = FacetsOnNodeNum;
Output_data.NodeCGDG = NodeCGDG;
Output_data.NodeReg = NodeReg;
Output_data.NodesOnElementCG = NodesOnElementCG;
Output_data.NodesOnElementDG = NodesOnElementDG;
Output_data.NodesOnInterface = NodesOnInterface;
Output_data.NodesOnInterfaceNum = NodesOnInterfaceNum;
Output_data.numCL = numCL;
% arrays for multi-point constraints
if usePBC
Output_data.NodesOnPBC = NodesOnPBC;
Output_data.NodesOnPBCnum = NodesOnPBCnum;
Output_data.NodesOnLink = NodesOnLink;
Output_data.NodesOnLinknum = NodesOnLinknum;
Output_data.numEonPBC = numEonPBC;
Output_data.FacetsOnPBC = FacetsOnPBC;
Output_data.FacetsOnPBCNum = FacetsOnPBCNum;
Output_data.FacetsOnIntMinusPBC = FacetsOnIntMinusPBC;
Output_data.FacetsOnIntMinusPBCNum = FacetsOnIntMinusPBCNum;
end