% Demonstration of Abaqus reader for 3d tetrahedral mesh.
% Generated using Neper program: http://neper.sourceforge.net/.
% Polycrystalline domain consisting of 32 grains; 8 sets of macro-grains
% exist with 4 inside of each. DG couplers are inserted between each
% macro-grain, as well as between sub-grains of macro-grains 1 and 4. These
% designations may be changed by the user in the list IntraGrainList.
% Uses higher-level functions for coupler insertion
% Domain: 1x1x1 block
%
% Last revision: 10/28/2017 TJT

clear
% clc

% Read in the .inp file
Abaqfile = 'NeperModel.inp';
ndm = 3;
AbaqusInputReader

% Assign grain ID to the elements in the grain; grains are listed as
% "polyX", after the first two data blocks
nummat = 32;
nummatG = nummat/4;
nummatA = nummat;
for grain = 1:32
    elset = Data{2+grain,1};
    RegionOnElement(elset) = grain; %#ok<SAGROW>
end

% BCs -  for patch test
nodexm = find(abs(Coordinates(:,1)-0)<1e-8);
nodexp = find(abs(Coordinates(:,1)-1)<1e-8);
nodeym = find(abs(Coordinates(:,2)-0)<1e-8);
nodezm = find(abs(Coordinates(:,3)-0)<1e-8);
NodeBC = [nodexm 1*ones(length(nodexm),1) 0*ones(length(nodexm),1)
          nodexp 1*ones(length(nodexp),1) .1*ones(length(nodexp),1)
          nodeym 2*ones(length(nodeym),1) 0*ones(length(nodeym),1)
          nodezm 3*ones(length(nodezm),1) 0*ones(length(nodezm),1)];
numBC = length(NodeBC);

MateT = ones(nummat,1)*[100 .25 1]; % GPa
MatTypeTable = [1:nummat
                ones(1,nummat)];

% Designate which interfaces are to have couplers inserted
% Set up material properties of couplers; example property is either (a)
% the product of macro-grain ID or (b) negative product of region ID for
% sub-grains
numnpCG = numnp;
nenCG = nen;
InterTypes = zeros(nummat);
InterTypes2 = zeros(nummat);
CZprop = cell(GetRegionsInt(nummat,nummat),1);
% Level 1 macro-grains
for grain1 = 1:nummatG
    for sub1 = 1:4
        mat1 = 4*(grain1-1)+sub1;
        for grain2 = 1:grain1-1
            for sub2 = 1:4
                mat2 = 4*(grain2-1)+sub2;
                InterTypes(mat1,mat2) = 1;
                matI = GetRegionsInt(mat2,mat1);
                CZprop{matI} = grain1*grain2;
                InterTypes2(mat1,mat2) = grain1*grain2;
            end
        end
    end
end
% Level 2 sub-grains
IntraGrainList = [1 4]; %can be any numbers 1 to 8
for grain = 1:length(IntraGrainList)
    grain1 = IntraGrainList(grain);
    for sub1 = 2:4
        mat1 = 4*(grain1-1)+sub1;
        grain2 = grain1;
            for sub2 = 1:sub1-1
                mat2 = 4*(grain2-1)+sub2;
                InterTypes(mat1,mat2) = 1;
                matI = GetRegionsInt(mat2,mat1);
                CZprop{matI} = - mat1*mat2;
                InterTypes2(mat1,mat2) = - mat1*mat2;
            end
    end
end


% Generate CZM interface: pairs of elements and faces, duplicate the nodes,
% update the connectivities
[NodesOnElement,RegionOnElement,Coordinates,numnp,Output_data] ...
    = DEIPFunction(InterTypes,NodesOnElement,RegionOnElement,Coordinates,numnp,numel,nummat,nen,ndm);

% Update boundary conditions
NodeBCCG = NodeBC;
numBCCG = numBC;
[NodeBC,numBC] = UpdateNodeSetFunction(0,RegionOnElement,Output_data,NodeBCCG,numBCCG);

% Insert DG couplers
[NodesOnElement,RegionOnElement,Coordinates,numnp,nen,numel,nummat,RegionsOnInterface,MateT,MatTypeTable...
] = InterFunction(2,InterTypes,NodesOnElement,RegionOnElement,Coordinates,numnp,numel,nummat,nen,ndm,...
                  Output_data,8,CZprop,MateT,MatTypeTable);

ProbType = [numnp numel nummat 3 3 nen];

stepmax = 1;

% % Find which couplers are between regions 10 and 24: [77,10,24,286,3854,3857]
% [matID,reg1,reg2,regI,coup1,coup2] = GetCouplersIntRegions(10,24,RegionsOnInterface);
% % Check that regions 3 and 25 are not connected: values return 0
% [matID,reg1,reg2,regI,coup1,coup2] = GetCouplersIntRegions(3,25,RegionsOnInterface);

% After analysis, compare the displacement at a duplicated node on the
% interior of the domain:
% NodeTable([4366,7090],:)
% ans =
%    0.857559489266000   0.036174547925000   0.137010822411000
%    0.857559489266000   0.036174547925000   0.137010822411000
% Node_U_V([4366,7090],:)
% ans =
%    0.085755948926601  -0.000904363698125  -0.003425270560275
%    0.085755948926601  -0.000904363698125  -0.003425270560275
