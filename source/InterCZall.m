% Program: InterCZallMPC
% Tim Truster
% 04/06/2017
%
% Coupler insertion, standard script
% Coupler type: DG couplers on all interfaces and intrafaces defined in
% InterTypes array
%
% Input: ndm = spatial dimension
%        remainder of arrays from DEIProgram
%
% Output: all necessary arrays for FEA_Program
%         Extra arrays:
%        -Interface region information: [materialID in MateT; mat1; mat2; regI; first coupler number; last coupler number]
%         RegionsOnInterface = zeros(nummat*(nummat+1)/2,6);

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
% Interface region information: [materialID in MateT; mat1; mat2; regI; first coupler number; last coupler number]
RegionsOnInterface = zeros(nummat*(nummat+1)/2,6);

for mat2 = 1:nummat
    for mat1 = 1:mat2
        
        matI = GetRegionsInt(mat1,mat2);
        if InterTypes(mat2,mat1) > 0
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
