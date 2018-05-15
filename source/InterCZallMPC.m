% Program: InterCZallMPC
% Tim Truster
% 04/06/2017
%
% Coupler insertion, standard script
% Coupler type: CZ couplers on all interfaces and intrafaces defined in
% InterTypes array
% Also adds MPC links along periodic surfaces, updates the list of links,
% adds master nodes for applying BC, and adds the Lagrange multiplier
% elements into NodesOnElements
% MPC surfaces DO get CZ couplers REGARDLESS of InterTypes = 1
%
% Input: ndm = spatial dimension
%        CZprop = interface CZ stiffness;
%        pencoeff = stiffness for MPC spring;
%        CornerXYZ = [coordinates of first master node
%                     2nd node
%                     third node];
%        remainder of arrays from DEIProgram
%
% Output: all necessary arrays for FEA_Program
%         Extra arrays:
%        -Interface region information: [materialID in MateT; mat1; mat2; regI; first coupler number; last coupler number]
%         RegionsOnInterface = zeros(nummat*(nummat+1)/2,6);
%        -Node number for each group of nodes: solid, masterPBC, and Lagrange multipliers
%         NodeTypeNum = [1 numnp+1 numnp+2*ndm+1 numnp+2*ndm+numMPC+1]';
%        -Updated MPCList accounting for node duplications and coupler
%         insertion

if iscell(CZprop)
    CZpropall = CZprop;
    usemany = 1;
else
    usemany = 0;
end
nummatCG = nummat;
numSI = numCL;
numelCG = numel;
nen_bulk = nen;
SurfacesI = zeros(0,8);
numSI = 0;
% Arrays for new MPC links being formed
MPCListNew = zeros(0,2+ndm);
numMPCnew = 0;
CouplerNodes = zeros(0,1); % extra nodes for MPC-CZ
NodesOnLinkNew = zeros(4,numnp);
NodesOnLinknumNew = zeros(numnp,1);
% Interface region information: [materialID in MateT; mat1; mat2; regI; first coupler number; last coupler number]
RegionsOnInterface = zeros(nummat*(nummat+1)/2,6);

for mat2 = 1:nummat
    for mat1 = 1:mat2
        
        matI = GetRegionsInt(mat1,mat2);
        numSIi = numEonPBC(matI);
        if numSIi > 0 % Create PBC pairs first
            if InterTypes(mat2,mat1) > 0% then make PBC-CZ couplers
            locF = FacetsOnPBCNum(matI):(FacetsOnPBCNum(matI+1)-1);
            facs = FacetsOnPBC(locF);
            SurfacesIi = ElementsOnFacet(facs,:);
            SurfacesIi = ReverseFacets(SurfacesIi,NodesOnElement,Coordinates,numSIi,ndm);
            ElementsOnFacet(facs,:) = SurfacesIi;
            SurfacesI(numSI+1:numSI+numSIi,5:8) = SurfacesIi;
            numel_old = numel;
            if usemany
                CZprop = CZpropall{matI};
            end
            [NodesOnElement,RegionOnElement,~,numnp,numel,nummat,MatTypeTable,MateT,Coordinates,...
                MPCListNew,numMPCnew,NodesOnLinkNew,NodesOnLinknumNew,CouplerNodes] = ...
             FormMPCCZ(MPCListNew,numMPCnew,NodesOnLinkNew,NodesOnLinknumNew,CouplerNodes,...
                    SurfacesIi,NodesOnElement,NodesOnElementCG,RegionOnElement,Coordinates,numSIi,nen_bulk,ndm,numnp,numel,nummat,6, ...
                    iel,nonlin,CZprop,MPCList,NodesOnLink,NodesOnLinknum,MatTypeTable,MateT);
            if numel > numel_old
            RegionsOnInterface(nummat-nummatCG,:) = [nummat mat1 mat2 matI numel_old+1 numel];
            end
            % Then form regular CZ couplers
            numSIi = numEonF(matI) - numSIi;
            locF = FacetsOnIntMinusPBCNum(matI):(FacetsOnIntMinusPBCNum(matI+1)-1);
            facs = FacetsOnIntMinusPBC(locF);
            SurfacesIi = ElementsOnFacet(facs,:);
            SurfacesI(numSI+1:numSI+numSIi,5:8) = SurfacesIi;
            numSI = numSI + numSIi;
            numel_old = numel;
            if usemany
                CZprop = CZpropall{matI};
            end
            [NodesOnElement,RegionOnElement,nen,numel,nummat,MatTypeTable,MateT] = ...
             FormCZ(SurfacesIi,NodesOnElement,RegionOnElement,Coordinates,numSIi,nen_bulk,ndm,numel,nummat,6, ...
                    iel,nonlin,CZprop,MatTypeTable,MateT);
            if numel > numel_old
            RegionsOnInterface(nummat-nummatCG,:) = [nummat mat1 mat2 matI numel_old+1 numel];
            end
            else % just form PBC pairs
            locF = FacetsOnPBCNum(matI):(FacetsOnPBCNum(matI+1)-1);
            facs = FacetsOnPBC(locF);
            SurfacesIi = ElementsOnFacet(facs,:);
            SurfacesIi = ReverseFacets(SurfacesIi,NodesOnElement,Coordinates,numSIi,ndm);
            ElementsOnFacet(facs,:) = SurfacesIi;
            SurfacesI(numSI+1:numSI+numSIi,5:8) = SurfacesIi;
            numel_old = numel;
            if usemany
                CZprop = CZpropall{matI};
            end
            [NodesOnElement,RegionOnElement,~,numnp,numel,nummat,MatTypeTable,MateT,Coordinates,...
                MPCListNew,numMPCnew,NodesOnLinkNew,NodesOnLinknumNew,CouplerNodes] = ...
             FormMPCCZ(MPCListNew,numMPCnew,NodesOnLinkNew,NodesOnLinknumNew,CouplerNodes,...
                    SurfacesIi,NodesOnElement,NodesOnElementCG,RegionOnElement,Coordinates,numSIi,nen_bulk,ndm,numnp,numel,nummat,6, ...
                    iel,nonlin,CZprop,MPCList,NodesOnLink,NodesOnLinknum,MatTypeTable,MateT);
            if numel > numel_old
            RegionsOnInterface(nummat-nummatCG,:) = [nummat mat1 mat2 matI numel_old+1 numel];
            end
            end
        elseif InterTypes(mat2,mat1) > 0 % just make CZ couplers
            numSIi = numEonF(matI);
            locF = FacetsOnInterfaceNum(matI):(FacetsOnInterfaceNum(matI+1)-1);
            facs = FacetsOnInterface(locF);
            SurfacesIi = ElementsOnFacet(facs,:);
            SurfacesI(numSI+1:numSI+numSIi,5:8) = SurfacesIi;
            numSI = numSI + numSIi;
            numel_old = numel;
            if usemany
                CZprop = CZpropall{matI};
            end
            [NodesOnElement,RegionOnElement,nen,numel,nummat,MatTypeTable,MateT] = ...
             FormCZ(SurfacesIi,NodesOnElement,RegionOnElement,Coordinates,numSIi,nen_bulk,ndm,numel,nummat,6, ...
                    iel,nonlin,CZprop,MatTypeTable,MateT);
            if numel > numel_old
            RegionsOnInterface(nummat-nummatCG,:) = [nummat mat1 mat2 matI numel_old+1 numel];
            end
        end
    end
end
RegionsOnInterface = RegionsOnInterface(1:nummat-nummatCG,:);

[MPCList,numMPC,CouplerNodes] = CleanMPC(MPCListNew,numMPCnew,CouplerNodes,ndm);


% Node number for each group of nodes: solid, masterPBC, and Lagrange
% multipliers
NodeTypeNum = [1 numnp+1 numnp+2*ndm+1 numnp+2*ndm+numMPC+1]';
% now actually add the Lagrange multiplier nodes
[Coordinates,NodesOnElement,RegionOnElement,MatTypeTable,MateT,numnp,numel,nummat,nen] = AddMPNodes(MPCList,pencoeff,CornerXYZ,Coordinates,NodesOnElement,RegionOnElement,MatTypeTable,MateT,numnp,numel,nummat,nen);