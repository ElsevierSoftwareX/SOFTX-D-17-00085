% Simple example of insertion of couplers using DEIProgram2. Corresponds to
% Figure 1 in "Discontinuous Element Insertion Algorithm" manuscript
% Does NOT include complete input required for FEA_Program for analysis
% Domain: 2x2 square, 8 triangular elements
%
% Last revision: 12/16/2015 TJT

clear
% clc

% Geometry
Coordinates = [0 2
             1 2
             2 2
             0 1
             1 1
             2 1
             0 0
             1 0
             2 0];
NodesOnElement = [1 4 5
      1 5 2 
      5 3 2 
      5 6 3 
      5 9 6 
      8 9 5 
      7 8 5 
      7 5 4 ];
RegionOnElement = [1
      2
      3
      2
      4
      4
      5
      1];
numnp = 9;
numel = 8;
nummat = 5;
ndm = 2;
nen = 3;

%% Plot the mesh

% plotElemCont2(Coordinates,RegionOnElement,NodesOnElement,1, 1:8, [1 0 1],{'elem'},{'FontSize',16})
% caxis([0.5 5.5]) % makes colors look nicer
% h=colorbar;
% set(get(h,'title'),'string','Region','FontSize',14);
% set(h,'FontSize',14);

%% Insert interface elements
% Generate CZM interface: pairs of elements and faces, duplicate the nodes,
% update the connectivities
InterTypes = [1 0 0 0 0
              1 0 0 0 0
              1 0 0 0 0
              1 1 0 0 0
              1 0 0 0 0];
DEIProgram2

nen_bulk = 3;
maxreg = 6;
for reg2 = 1:nummat
    for reg1 = 1:reg2
        
        regI = reg2*(reg2-1)/2 + reg1; % ID for material pair (row=reg2, col=reg1)
        if InterTypes(reg2,reg1) > 0
        numSIi = numEonF(regI);
        locF = FacetsOnInterfaceNum(regI):(FacetsOnInterfaceNum(regI+1)-1);
        facs = FacetsOnInterface(locF);
        SurfacesIi = ElementsOnFacet(facs,:);
        [NodesOnElement,RegionOnElement,nen,numel,nummat] = ...
         FormDG(SurfacesIi,NodesOnElement,RegionOnElement,Coordinates,numSIi,...
                nen_bulk,ndm,numel,nummat,maxreg);
        end
    end
end

% % Plot regions
% plotElemCont2(Coordinates,RegionOnElement,NodesOnElement,1,(1:8),[1 0 1])
% colorbar off
