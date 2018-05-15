% Program: Linear Finite Element Analysis Program
% 
% Last revision: 10/24/2015 TJT
%
% Format of input:
%
%   numnp:           = number of nodes in the mesh (length(Coordinates))
%
%   numel:           = number of elements in the mesh (length(NodesOnElements))
%
%   nummat:          = number of materials (length(MateT))
%
%   ndm:             = number of spatial dimensions
%
%   ndf:             = number of degrees of freedom per node
%
%   nen:             = maximum number of nodes per element
%
%   PSPS:            = flag for plane stress ('s') or plane strain ('n')
%
%   Coordinates:     = table of mesh nodal coordinates defining the
%                      geometry of the mesh; format of the table is as
%                      follows:
%                          Nodes  |              x-coord  y-coord
%                          n1     | Coordinates = [x1     y1
%                          n2     |                x2     y2
%                          ...    |                ..     ..
%                          nnumnp |                xnumnp ynumnp];
%
%   NodesOnElement:  = table of mesh connectivity information, specifying
%                      how nodes are attached to elements and how materials
%                      are assigned to elements; entries in the first nen
%                      columns correspond to the rows of Coordinates
%                      representing the nodes attached to element e;
%                      entries in the last nen+1 column are rows from MateT
%                      signifying the material properties assigned to
%                      element e; format of the table is as follows:
%                          Elements  |         n1    n2    n3    n4   mat
%                          e1        | NonE = [e1n1  e1n2  e1n3  e1n4 e1mat
%                          e2        |         e2n1  e2n2  e2n3  e2n4 e2mat
%                          ...       |          ..    ..    ..    ..   ..
%                          enumel    |         values for element numel   ];
%
%   MateT:           = table of mesh material properties for each distinct
%                      set of material properties; these sets are
%                      referenced by element e by setting the value of
%                      RegionOnElement(e) to the row number of the desired
%                      material set; format of the table is as follows:
%                          Materials  |           E   v   t
%                          mat1       |  MateT = [E1  v1  t1
%                          mat2       |           E2  v2  t2
%                          ...        |           ..  ..  ..];
%
%   MatTypeTable:    = [a b ]
%                      b element subroutine number
%
%   NodeBC:          = table of prescribed nodal displacement boundary
%                      conditions; it contains lists of nodes, the
%                      direction of the displacement prescribed (x=1, y=2),
%                      and the value of the displacement (set 0 for fixed
%                      boundary); the length of the table must match numBC,
%                      otherwise an error will result;  format of the 
%                      table is as follows:
%                          BCs  |            nodes direction value
%                          bc1  |  NodeBC = [bc1n   bc1dir   bc1u
%                          bc2  |            bc2n   bc2dir   bc2u
%                          ...  |             ..     ..       .. ];
%
%   NodeLoad:        = table of prescribed nodal forces; it contains lists 
%                      of nodes, the direction of the force prescribed 
%                      (x=1, y=2), and the value of the force; the length 
%                      of the table must match numNodalF, 
%                      otherwise an error will result; format of the table 
%                      is as follows:
%                          Loads  |              nodes direction value
%                          P1     |  NodeLoad = [ P1n    P1dir    P1P
%                          P2     |               P2n    P2dir    P2P
%                          ...    |               ..     ..       .. ];
%
%   numSI:           = number of interface couplers
%

format compact

if (~exist('batchinter','var'))
    batchinter = 'inter';
end
addpath(genpath([pwd '\FEsource']))

%% Launch Program: Select Either new analysis, Continuation, or Restart

if strcmp(batchinter,'batch') % batch mode
    

        if exist('batchname','var')
            if strcmp(batchname(end-1:end),'.m')
                batchname = batchname(1:end-2);
            end
            run(batchname);
        else
            error('batchname file does not exist')
        end

        batchinter = 'batch';
        
        % Read major problem size parameters and solution options
        pstart
        
        % Initialize default parameters
        pdefault
    
else % interactive - prompt for filename

    %% Ask for input file name and load the file
        fprintf('Provide name of input file\n');
        [filename,pathname] = uigetfile('*.m','Select the NLFEA input file');
        if isnumeric(filename)
             error('User must select a file to run')
        end
        run([pathname filename(1:end-2)])

        batchinter = 'inter';
        
        % Read major problem size parameters and solution options
        pstart
        
        % Initialize default parameters
        pdefault
    
end

%% recreate legacy arrays
NodeTable = Coordinates;
ix = [NodesOnElement RegionOnElement];
nen1 = nen + 1;

%%
perror

tic

%% FE array initialization

    lamda = 0; %time
    step = 0;
    iter = 0;
    initializeFE

    %Set up sparsity pattern, count number of lin/nonlin materials
    FormKs

    % Initialize solution vectors; compute any required initial arrays

    ModelFx = zeros(nieq,1);
    s_del_ModelDx = zeros(neq,1);
    gBC = zeros(nieq,1);
    gBC_n = gBC;
%     ModelVx = zeros(neq,1);
%     ModelAx = zeros(neq,1);
%     ModelDxn_1 = ModelDx;
%     ModelVxn_1 = ModelVx;
%     ModelAxn_1 = ModelAx;
    % dt = s_del_a;
    initia = 1; %flag to prescribe an elastic predictor step
    NDOFT2 = NDOFT';
    DOFa = find((NDOFT2<=neq)&(NDOFT2>0));
    DOFi = find(NDOFT2>neq);


    if DHist == 1
        DispList = zeros(ndf,numnp,1);
    end
    if FHist == 1
        ForcList = zeros(ndf,numnp,1);
    end


    % Initialize lists for output data
    poutinit


%% Problem Initialization
        
        step = 1;
        Fext1 = Fc1;
        gBC = ModelDc; % standard contribution
        
        %Assemble Stiffness Routine
        isw = 3;
        FormFE
        


%% Solve Kd = F

    del_ModelDx = Kdd11\Fd1;

    ModelDx = ModelDx + del_ModelDx;
    
        if DHist == 1
%         for node = 1:numnp
%         %     Node_U_V(node, 1) = node;
%             for dir = 1:ndf
%                 gDOF = NDOFT(node,dir);
%                 if gDOF <= neq && gDOF > 0
%                     DispList(dir,node,step+1) = ModelDx(gDOF);
%                 elseif gDOF > 0
%                     DispList(dir,node,step+1) = gBC(gDOF - neq);
%                 end
%             end
%         end
        DispList(DOFa) = ModelDx(NDOFT2(DOFa));
        DispList(DOFi) = gBC(NDOFT2(DOFi)-neq);
        end
    if FHist == 1
        Fext1 = zeros(neq,1);
        isw = 6;
        FormFE
        
%         for node = 1:numnp
%         %     Node_U_V(node, 1) = node;
%             for dir = 1:ndf
%                 gDOF = NDOFT(node,dir);
%                 if gDOF <= neq && gDOF > 0
%                     ForcList(dir,node,step+1) = Fd1(gDOF);
%                 elseif gDOF > 0
%                     ForcList(dir,node,step+1) = Fd3(gDOF - neq);
%                 end
%             end
%         end
        ForcList(DOFa) = Fd1(NDOFT2(DOFa));
        ForcList(DOFi) = Fd3(NDOFT2(DOFi)-neq);
    end
    if SHist == 1

        StreList2 = zeros(numnp,npstr);
        Eareas = zeros(numnp,1);

        isw = 25;
        FormS2

        for stres = 1:npstr
            StreList2(:,stres) = StreList2(:,stres)./Eareas;
        end
        StreList(1:npstr,:,1) = StreList2';

    end
    
    if SEHist == 1

        StreList2 = zeros(numel,nestr);

        isw = 26;
        FormFE

        StreListE(1:nestr,:,1) = StreList2';

    end
    


%% Perform final data processing

Node_U_V = zeros(numnp,ndf)';

Node_U_V(DOFa) = ModelDx(NDOFT2(DOFa));
Node_U_V(DOFi) = gBC(NDOFT2(DOFi)-neq);
Node_U_V = Node_U_V';
