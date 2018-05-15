% Moderate example of insertion of couplers using DEIProgram2. Corresponds
% to Figure 5 in "Discontinuous Element Insertion Algorithm" manuscript
% Domain: 4x3 rectangle, combination of T3 and Q4 elements; insertion of DG
% couplers on region interfaces
% Loading: Displacement of 0.1 on right edge
%
% Last revision: 12/16/2015 TJT

% Element refinement numbers
n1 = 8;
m1 = 8;
n2 = 8;
m2 = m1;
n3 = n1 + n2;
m3 = 4;
% Geometry
L1 = 2.0;
H1 = 2.0;
L2 = 2.0;
H2 = H1;
L3 = L1 + L2;
H3 = 1.0;

%% Generate mesh
x = zeros(0,0);
NodesOnElement = zeros(0,0);
RegionOnElement = zeros(0,0);
nen = 4;

% Block 1
xl = [1 0 0
      2 L1 0
      4 0 H1
      3 L1 H1];
type = 'cart';
rinc = n1;
sinc = m1;
node1 = 1;
elmt1 = 1;
mat = 1;
rskip = n2;
btype = 5;
[x,NodesOnElement,RegionOnElement,~,numel] = block2d(type,rinc,sinc,node1,elmt1,mat,rskip,btype,xl,nen,x,NodesOnElement,RegionOnElement);

% Block 2
xl = [1 L1 0
      2 L3 0
      4 L1 H2
      3 L3 H2];
type = 'cart';
rinc = n2;
sinc = m2;
node1 = n1+1;
elmt1 = numel+1;
mat = 1;
rskip = n1;
btype = 0;
[x,NodesOnElement,RegionOnElement,~,numel] = block2d(type,rinc,sinc,node1,elmt1,mat,rskip,btype,xl,nen,x,NodesOnElement,RegionOnElement);

% Block 3
xl = [1 0 H1
      2 L3 H2
      4 0 H1+H3
      3 L3 H2+H3];
type = 'cart';
rinc = n3;
sinc = m3;
node1 = (n3+1)*(m1)+1;
elmt1 = numel+1;
mat = 1;
rskip = 0;
btype = 3;
[x,NodesOnElement,RegionOnElement,numnp,numel] = block2d(type,rinc,sinc,node1,elmt1,mat,rskip,btype,xl,nen,x,NodesOnElement,RegionOnElement);

Coordinates = x';
NodesOnElement = NodesOnElement';

%% Boundary conditions
nodexm = find(abs(Coordinates(:,1)-0)<1e-9); %rollers at x=0
nodexp = find(abs(Coordinates(:,1)-L3)<1e-9); %prescribed u_x at x=2
nodeym = find(abs(Coordinates(:,2)-0)<1e-9); %rollers at y=0
NodeBC = [nodexm 1*ones(length(nodexm),1) zeros(length(nodexm),1)
          nodexp 1*ones(length(nodexp),1) .1*ones(length(nodexp),1)
          nodeym 2*ones(length(nodeym),1) zeros(length(nodeym),1)];
numBC = length(NodeBC);

Coordinates = Coordinates - [ones(numnp,1) 0.5*ones(numnp,1)];
%% Assign materials to particular elements; can be modified
nen1 = nen + 1;
RegionOnElement(:) = 5;

% A1
RegionOnElement(114:120) = 5;
RegionOnElement(100:104) = 5;
RegionOnElement(86:88) = 5;
RegionOnElement(72) = 5;

% B
RegionOnElement(121:124) = 7;
RegionOnElement(105:108) = 7;
RegionOnElement(89:91) = 7;
RegionOnElement(73) = 7;

% A2
RegionOnElement(92:93) = 5;
RegionOnElement(74:79) = 5;

% C
RegionOnElement(57:63) = 3;
RegionOnElement(41:48) = 3;
RegionOnElement(25:32) = 3;
RegionOnElement(9:16) = 3;

% D
RegionOnElement(54:56) = 4;
RegionOnElement(38:40) = 4;
RegionOnElement(21:24) = 4;
RegionOnElement(5:8) = 4;

% E
RegionOnElement(33:35) = 2;
RegionOnElement(17:20) = 2;
RegionOnElement(1:4) = 2;

% F
RegionOnElement(113) = 6;
RegionOnElement(97:99) = 6;
RegionOnElement(81:85) = 6;
RegionOnElement(65:71) = 6;
RegionOnElement(49:55) = 6;
RegionOnElement(36:37) = 6;

% G
RegionOnElement(129:128+64) = 1;

% H
RegionOnElement(276) = 8;
RegionOnElement(244:247) = 8;
RegionOnElement(210:215) = 8;


PSPS = 's';
nummat = 8;
MatTypeTable = [1 2 3 4 5 6 7 8
                1 1 1 1 1 1 1 1];
MateT = ones(nummat,1)*[100e3 0.25 1];
% Output quantity flags
DHist = 1;
FHist = 1;
SHist = 1;
SEHist = 1;

%% Insert interface elements
% Generate CZM interface: pairs of elements and faces, duplicate the nodes,
% update the connectivities
numnpCG = numnp;
InterTypes = [0 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0
              1 0 0 0 0 0 0 0
              0 0 0 0 0 0 0 0
              1 0 1 0 0 0 0 0
              1 1 1 1 1 1 0 0
              0 0 0 0 1 1 0 0
              1 0 0 0 1 1 0 0]; % only put CZM between the element edges between materials 1-2
DEIProgram2

% Update boundary conditions
NodeBCCG = NodeBC;
numBCCG = numBC;
reg = 0;
[NodeBC,numBC] = UpdateNodeSet(reg,RegionOnElement,ElementsOnNodeNum,...
                               ElementsOnNode,ElementsOnNodeDup,NodeBCCG,numBCCG);

% Generate DG elements: create new elements in NodesOnElement with format expected by
% Matlab
numSI = numCL;
numelCG = numel;
nen_bulk = nen;
for mat2 = 1:8
    for mat1 = 1:mat2
        
        matI = mat2*(mat2-1)/2 + mat1; % ID for material pair (row=mat2, col=mat1)
        if InterTypes(mat2,mat1) > 0
        numSIi = numEonF(matI);
        locF = FacetsOnInterfaceNum(matI):(FacetsOnInterfaceNum(matI+1)-1);
        facs = FacetsOnInterface(locF);
        SurfacesIi = ElementsOnFacet(facs,:);
        [NodesOnElement,RegionOnElement,nen,numel,nummat,MatTypeTable,MateT] = ...
         FormDG(SurfacesIi,NodesOnElement,RegionOnElement,Coordinates,numSIi,nen_bulk,2,numel,nummat,6, ...
                8,0,[0],MatTypeTable,MateT);
        end
    end
end

%% Algorithm definitions for NL_FEA_Program
ProbType = [numnp numel nummat 2 2 nen];

% numBC = 0;
NodeT2 = Coordinates;
elemlist = find(RegionOnElement(:)==6);
ud = [0.4 0 0 0 0.0 0.0 0.0 0.2
      0.0 0 0 0 0.8 0.3 0.8 0.2];
% Perturb grain 6
for ind = 1:length(elemlist)
    elem = elemlist(ind);
    nodes = NodesOnElement(elem,1:3);
    nodexy = Coordinates(NodesOnElement(elem,1:3),:);
    aver = mean(nodexy);
    NodeT2(nodes,:) = NodeT2(nodes,:) + [ones(3,1)*ud(1,6) ones(3,1)*ud(2,6)] + 0.2*ones(3,1)*aver;%;
end
mat = 0;
% modify other grains
for grain = 1:8
    mat = mat + 1;
    nodelist = unique(NodeReg(:,mat));
    if nodelist(1) == 0
    nodelist = nodelist(2:end);
    end
    numb = length(nodelist);
%     numBC = numBC+numb;
    if grain ~= 6
    NodeT2(nodelist,:) = Coordinates(nodelist,:) + [ones(numb,1)*ud(1,grain) ones(numb,1)*ud(2,grain)];
    end
    if grain == 5
        NodeT2(265,:) = Coordinates(77,:) + [ones(1,1)*ud(1,grain) ones(1,1)*ud(2,grain)]; % element 64, node 77 info
        NodeT2(259,:) = Coordinates(73,:) + [ones(1,1)*ud(1,grain) ones(1,1)*ud(2,grain)]; % element 72, node 73 info
    end
end

% % Plot the regions in the mesh
% plotElemCont2(Coordinates,RegionOnElement(:),NodesOnElement(1:320,1:5),2,(1:320),[1 0 0],{'cb'},{'FontSize',20})
% % plotElemCont2(NodeT2,NodesOnElement(:),NodesOnElement(1:320,1:5),2,(1:320),[1 0 0],{'cb'},{'FontSize',32})
% caxis([0.5 8.5])

% % Plot the stress after the solution
% plotNodeCont2(Coordinates,StreList(1,:,:)'/2500,NodesOnElement(1:320,1:5),3,(1:320),[1 0 0],0,[3 4 6 9 0],{'cb'},{'FontSize',20})
% caxis([0.9999999 1.0000001])
% set(findobj(gcf,'Type','Colorbar'),'TickLabels',{'0.9999990','0.9999992','0.9999994','0.9999996','0.9999998','1.0000000','1.0000002','1.0000004','1.0000006','1.0000008','1.0000010'})
% set(findobj(gcf,'Type','Colorbar'),'TickLabels',{'0.9999990','0.9999995','1.0000000','1.0000005','1.0000010'})