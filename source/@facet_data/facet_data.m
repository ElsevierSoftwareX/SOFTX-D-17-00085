classdef facet_data < handle
% Data structure for DEIP, additional topological arrays
	properties
        numEonB = [];
        numEonF = [];
        ElementsOnBoundary = [];
        numSI = 0;
        ElementsOnFacet = [];
        ElementsOnNode = [];
        ElementsOnNodeDup = [];
        ElementsOnNodeNum = [];
        numfac = 0;
        ElementsOnNodeNum2 = [];
        numinttype = 0;
        FacetsOnElement = [];
        FacetsOnElementInt = [];
        FacetsOnInterface = [];
        FacetsOnInterfaceNum = [];
        FacetsOnNode = [];
        FacetsOnNodeCut = [];
        FacetsOnNodeInt = [];
        FacetsOnNodeNum = [];
        NodeCGDG = [];
        NodeReg = [];
        NodesOnElementCG = [];
        NodesOnElementDG = [];
        NodesOnInterface = [];
        NodesOnInterfaceNum = [];
        numCL = 0;
        % arrays for multi-point constraints
        NodesOnPBC = [];
        NodesOnPBCnum = [];
        NodesOnLink = [];
        NodesOnLinknum = [];
        numEonPBC = [];
        FacetsOnPBC = [];
        FacetsOnPBCNum = [];
        FacetsOnIntMinusPBC = [];
        FacetsOnIntMinusPBCNum = [];
      end %type
   
%    methods
%       function do_something
%       end
%    end % methods

end % classdef