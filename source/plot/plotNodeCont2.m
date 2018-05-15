function plotNodeCont2(Coordinates, Contour, NodesOnElement, PlotID, elemlist, MNE_ID, zcont3D, nelPn, varargin)
% Tim Truster
% 11/26/2013
% 
% Plot contour of nodal finite element field from a 2-D mesh
% Optional arguments are in {}, defaults are in ().
%
% Default usage (for copy/paste):
% plotNodeCont2(Coordinates,Contour,NodesOnElement,1,(1:size(NodesOnElement,1)),[1 0 0],0,[3 4 6 9 0])
%
% Inputs:
%  Coordinates = nodal coordinates [x y]
%  Contour = nodal solution field [c]
%  NodesOnElement = element connectivity [n1 n2 ... nnen]
%  {PlotID} = [ModelID {clfyn subp numsubp}]
%      ModelID = figure ID for plot window (1)
%      clfyn = 1 for clearing figure before plot, retain otherwise (1)
%      subp = subplot ID for current contour plot (1)
%      numsubp = number of subplots for figure window (1)
%  {elemlist} = list of specific elements to plot [e1 e2 ... en]' (1:numel)
%  {MNE_ID} = [meshyn nodeyn elemyn] (1 0 0)
%      meshyn = 1 for plotting mesh lines, no mesh lines otherwise
%      nodeyn = 1 for plotting node ID on figure, no ID on plot otherwise
%      elemyn = 1 for plotting elem ID on figure, no ID on plot otherwise
%  {zcont3D} = 1 for using Contour as the z-coordinate for the plot,
%              creates a flat contour plot otherwise (0)
%  {nelPn} = [nelP3 nelP4 nelP6 nelP9 contP]
%      nelP3 = number of nodes with pressure dofs for T3 elements (3)
%      nelP4 = number of nodes with pressure dofs for Q4 elements (4)
%      nelP6 = number of nodes with pressure dofs for T6 elements (6)
%      nelP9 = number of nodes with pressure dofs for Q9 elements (9)
%      contP = 1 if solution field is pressure (uses lower-order shape 
%              functions to plot), uses default shape functions otherwise
%              (0)
%  {varargin} = {types},{props1},{props2},...,{propsn} 
%               pairs of commands for figure, axes, etc.
%      types = {'fig','node','mesh','cb','xlab','axes',...} is a list of
%              all types of property pairs that follow, in the correct
%              order
%      props1 = {{'PropertyName1',PropertyValue1,'PropertyName2',... is a
%              of all properties assigned to a given type
%      Examples: varargin = {'cb'},{'FontSize',16}
%                varargin = {'title'},{'String','Make a visible title'}
%                varargin = {'axes'},{'CLim',[-10 10]} % resets caxis
%                varargin = {'node'},{'FontSize',32} % sets node ID font
%                varargin = {'line'},{'LineWidth',2} % changes mesh lines
%                varargin = {'xlab'},{'FontSize',18} % changes xlabel
%                varargin = {'xlab','node'},{'FontSize',32},{'FontSize',18}
%                varargin = 'xlab','FontSize',32 % one type doesn't need {}


% Default arguments
switch nargin
    case {1,2}
        error('Must supply Coordinates, Contour, and NodesOnElement')
    case 3
        ModelID = 1;
        clfyn = 1;
        subp = 1;
        numsubp = 1;
        numel = size(NodesOnElement,1);
        elemlist = (1:numel)';
        meshyn = 1;
        nodeyn = 0;
        elemyn = 0;
        zcont3D = 0;
        nelPn = [3 4 6 9 0];
    case 4
        ModelID = PlotID(1);
        if length(PlotID) == 4
            clfyn = PlotID(2);
            subp = PlotID(3);
            numsubp = PlotID(4);
        else
            clfyn = 1;
            subp = 1;
            numsubp = 1;
        end
        numel = size(NodesOnElement,1);
        elemlist = (1:numel)';
        meshyn = 1;
        nodeyn = 0;
        elemyn = 0;
        zcont3D = 0;
        nelPn = [3 4 6 9 0];
    case 5
        ModelID = PlotID(1);
        if length(PlotID) == 4
            clfyn = PlotID(2);
            subp = PlotID(3);
            numsubp = PlotID(4);
        else
            clfyn = 1;
            subp = 1;
            numsubp = 1;
        end
        meshyn = 1;
        nodeyn = 0;
        elemyn = 0;
        zcont3D = 0;
        nelPn = [3 4 6 9 0];
    case 6
        ModelID = PlotID(1);
        if length(PlotID) == 4
            clfyn = PlotID(2);
            subp = PlotID(3);
            numsubp = PlotID(4);
        else
            clfyn = 1;
            subp = 1;
            numsubp = 1;
        end
        if length(MNE_ID) >= 3
            meshyn = MNE_ID(1);
            nodeyn = MNE_ID(2);
            elemyn = MNE_ID(3);
        else
            meshyn = 1;
            nodeyn = 0;
            elemyn = 0;
        end
        zcont3D = 0;
        nelPn = [3 4 6 9 0];
    case 7
        ModelID = PlotID(1);
        if length(PlotID) == 4
            clfyn = PlotID(2);
            subp = PlotID(3);
            numsubp = PlotID(4);
        else
            clfyn = 1;
            subp = 1;
            numsubp = 1;
        end
        if length(MNE_ID) >= 3
            meshyn = MNE_ID(1);
            nodeyn = MNE_ID(2);
            elemyn = MNE_ID(3);
        else
            meshyn = 1;
            nodeyn = 0;
            elemyn = 0;
        end
        nelPn = [3 4 6 9 0];
    otherwise
        ModelID = PlotID(1);
        if length(PlotID) == 4
            clfyn = PlotID(2);
            subp = PlotID(3);
            numsubp = PlotID(4);
        else
            clfyn = 1;
            subp = 1;
            numsubp = 1;
        end
        if length(MNE_ID) >= 3
            meshyn = MNE_ID(1);
            nodeyn = MNE_ID(2);
            elemyn = MNE_ID(3);
        else
            meshyn = 1;
            nodeyn = 0;
            elemyn = 0;
        end
end

%Select and clear figure
figure(ModelID);
% set(ModelID,'Position',[360   425   560   273])
% set(ModelID,'Position',[360   278   560   420]) %old HP
set(ModelID,'Position',[403   246   560   420])
if clfyn
clf(ModelID)
end

% Set nen = maximum number of nodes per element
nen = size(NodesOnElement,2);
        
% Open subplot
subplot(numsubp,1,subp)

colormap jet

% Set nodal flags for pressure field plots with reduced number of nodes per
% element
nelP3 = nelPn(1);
nelP4 = nelPn(2);
nelP6 = nelPn(3);
nelP9 = nelPn(4);
contP = nelPn(5);

% Set up arrays for node and element handles
if elemyn
    helem = zeros(length(elemlist),1);
else
    helem = 0;
end
if nodeyn
    hnode = zeros(length(elemlist)*nen,1);
    hnode_count = 0; % counter for nodes, since they are plotted multiple times
else
    hnode = 0;
    hnode_count = 0;
end
    
for elemp = 1:length(elemlist)
    
    elem = elemlist(elemp);
    
    %Determine patch size parameters
    nel = nnz(NodesOnElement(elem,1:nen));

    if nel == 3
        nelP = nelP3;
    elseif nel == 4
        nelP = nelP4;
    elseif nel == 6
        nelP = nelP6;
    elseif nel == 9
        nelP = nelP9;
    end
    if contP == 1
        nel = nelP;
    end

	% Extract element nodal coordinates and contour values
    PatchPoints = Coordinates(NodesOnElement(elem,1:nel),:);
    ContourValues = Contour(NodesOnElement(elem,1:nel),1);
            
    % Plot element contour
    if nel == 3 || nel == 6

%             len = 3;
%             knots = [0 0.50 1.0 0 2/2/4 1/2 0 0 0
%                      0 0 0 0.5  0.5  0.5 1.0  1.0  1.0]';
        len = 5;
        knots = [0 0.25 0.50 0.75 1.0 0 3/4/4 6/4/4 9/4/4 12/4/4 0 1/2/4 2/2/4 3/2/4 1/2 0 1/4/4 2/4/4 3/4/4 1/4 0 0 0 0 0
                 0 0 0 0 0 0.25 0.25 0.25 0.25 0.25 0.5  0.5  0.5  0.5  0.5 0.75 0.75 0.75 0.75 0.75 1.0  1.0  1.0  1.0  1.0]';
        if elemyn
            elemID = elem;
        else
            elemID = 0;
        end
        helem = plot2DLagransurfcont(PatchPoints, ContourValues, nel, knots, len, 'none', elemID,zcont3D, elemp, helem);

        % Plot mesh outline
        if meshyn
            hold on
            plot([PatchPoints(1,1) PatchPoints(2,1)],[PatchPoints(1,2) PatchPoints(2,2)],'k','LineWidth',1)
            plot([PatchPoints(2,1) PatchPoints(3,1)],[PatchPoints(2,2) PatchPoints(3,2)],'k','LineWidth',1)
            plot([PatchPoints(3,1) PatchPoints(1,1)],[PatchPoints(3,2) PatchPoints(1,2)],'k','LineWidth',1)
            hold off
        end
        
        % Plot node IDs
        if nodeyn
            for j = 1:nel
                node = NodesOnElement(elem,j);
                tx = PatchPoints(j,1);
                ty = PatchPoints(j,2);
                if zcont3D
                    tz = ContourValues(j);
                else
                    tz = 0;
                end
                hnode_count = hnode_count + 1;
                hnode(hnode_count) = text(tx,ty,tz,num2str(node));
            end
        end
        
    elseif nel == 4 || nel == 9
        
        len = 5;
        knots = [-1.0 -0.5  0.0  0.5  1.0 -1.0 -0.5  0.0  0.5  1.0 -1.0 -0.5  0.0  0.5  1.0 -1.0 -0.5  0.0  0.5  1.0 -1.0 -0.5  0.0  0.5  1.0
                 -1.0 -1.0 -1.0 -1.0 -1.0 -0.5 -0.5 -0.5 -0.5 -0.5 -0.0 -0.0 -0.0 -0.0 -0.0  0.5  0.5  0.5  0.5  0.5  1.0  1.0  1.0  1.0  1.0]';
             
        if elemyn
            elemID = elem;
        else
            elemID = 0;
        end
        helem = plot2DLagransurfcont(PatchPoints, ContourValues, nel, knots, len, 'none', elemID,zcont3D, elemp, helem);

        if meshyn
            hold on
            plot([PatchPoints(1,1) PatchPoints(2,1)],[PatchPoints(1,2) PatchPoints(2,2)],'k','LineWidth',1)
            plot([PatchPoints(2,1) PatchPoints(3,1)],[PatchPoints(2,2) PatchPoints(3,2)],'k','LineWidth',1)
            plot([PatchPoints(3,1) PatchPoints(4,1)],[PatchPoints(3,2) PatchPoints(4,2)],'k','LineWidth',1)
            plot([PatchPoints(4,1) PatchPoints(1,1)],[PatchPoints(4,2) PatchPoints(1,2)],'k','LineWidth',1)
            hold off
        end
        
        % Plot node IDs
        if nodeyn
            for j = 1:nel
                node = NodesOnElement(elem,j);
                tx = PatchPoints(j,1);
                ty = PatchPoints(j,2);
                if zcont3D
                    tz = ContourValues(j);
                else
                    tz = 0;
                end
                hnode_count = hnode_count + 1;
                hnode(hnode_count) = text(tx,ty,tz,num2str(node),'HorizontalAlignment','center');
            end
        end
    end

end

% Final properties
shading interp
hx = xlabel('x');
hy = ylabel('y');
hz = zlabel('');
ht = title('');

axis equal
% axis([0 10 -3 3])
% axis off

hcb = colorbar('EastOutside','FontSize',13,'FontName','Arial','LineWidth',1);
% colorbar('EastOutside','FontSize',13,'FontName','Arial','LineWidth',1,'YTick',1e4*[-5 -2.5 0 2.5 5],'YTickLabel',[-5 -2.5 0 2.5 5])

% Set additional figure properties
if ~isempty(varargin)
if iscell(varargin{1,1}) % Multiple types of objects specified
    
    ObjTypes = varargin{1,1}; % header with list of object property types
    numObj = min(length(ObjTypes),length(varargin)-1);
    
    for obj = 1:numObj
        
        objtype = ObjTypes{1,obj}; % get title of object type
        switch objtype
            case {'fig','Fig','Figure','figure'}
                figstuff = varargin{1,1+obj}; % get list of figure properties
                set(gcf,figstuff{:}) % set figure properties
            case {'mesh','Mesh','line','Line','Lines','lin','lines'}
                linestuff = varargin{1,1+obj}; % get list of line properties
                set(findobj(gca,'Type','line'),linestuff{:}) % set line properties
            case {'axes'}
                axesstuff = varargin{1,1+obj}; % get list of axes properties
                set(gca,axesstuff{:}) % set axes properties
            case {'node','Node','nodes','Nodes','nodetext','NodeText'}
                if nodeyn
                nodestuff = varargin{1,1+obj}; % get list of node text properties
                set(hnode(1:hnode_count),nodestuff{:}) % set node text properties
                end
            case {'elem','Elem','elems','Elems','elements','Elements','elemtext','ElemText'}
                if elemyn
                elemstuff = varargin{1,1+obj}; % get list of elem text properties
                set(helem,elemstuff{:}) % set elem text properties
                end
            case {'xlabel','Xlabel','XLabel','xlab','Xlab'}
                xlabstuff = varargin{1,1+obj}; % get list of xlabel properties
                set(hx,xlabstuff{:}) % set xlabel properties
            case {'ylabel','Ylabel','YLabel','ylab','Ylab'}
                ylabstuff = varargin{1,1+obj}; % get list of ylabel properties
                set(hy,ylabstuff{:}) % set ylabel properties
            case {'zlabel','Zlabel','ZLabel','zlab','Zlab'}
                zlabstuff = varargin{1,1+obj}; % get list of zlabel properties
                set(hz,zlabstuff{:}) % set xlabel properties
            case {'title','Title'}
                titlestuff = varargin{1,1+obj}; % get list of title properties
                set(ht,titlestuff{:}) % set title properties
            case {'colorbar','CB','Colorbar','ColorBar','cb'}
                cbstuff = varargin{1,1+obj}; % get list of title properties
                set(hcb,cbstuff{:}) % set title properties
        end
        
    end
    
else % Single object only
        
        objtype = varargin{1,1}; % get title of object type
        switch objtype
            case {'fig','Fig','Figure','figure'}
                figstuff = varargin(1,2:end); % get list of figure properties
                set(gcf,figstuff{:}) % set figure properties
            case {'mesh','Mesh','line','Line','Lines','lin','lines'}
                linestuff = varargin(1,2:end); % get list of line properties
                set(findobj(gca,'Type','line'),linestuff{:}) % set line properties
            case {'axes'}
                axesstuff = varargin(1,2:end); % get list of axes properties
                set(gca,axesstuff{:}) % set axes properties
            case {'node','Node','nodes','Nodes','nodetext','NodeText'}
                if nodeyn
                nodestuff = varargin(1,2:end); % get list of node text properties
                set(hnode(1:hnode_count),nodestuff{:}) % set node text properties
                end
            case {'elem','Elem','elems','Elems','elements','Elements','elemtext','ElemText'}
                if elemyn
                elemstuff = varargin(1,2:end); % get list of elem text properties
                set(helem,elemstuff{:}) % set elem text properties
                end
            case {'xlabel','Xlabel','XLabel','xlab','Xlab'}
                xlabstuff = varargin(1,2:end); % get list of xlabel properties
                set(hx,xlabstuff{:}) % set xlabel properties
            case {'ylabel','Ylabel','YLabel','ylab','Ylab'}
                ylabstuff = varargin(1,2:end); % get list of ylabel properties
                set(hy,ylabstuff{:}) % set ylabel properties
            case {'zlabel','Zlabel','ZLabel','zlab','Zlab'}
                zlabstuff = varargin(1,2:end); % get list of zlabel properties
                set(hz,zlabstuff{:}) % set xlabel properties
            case {'title','Title'}
                titlestuff = varargin(1,2:end); % get list of title properties
                set(ht,titlestuff{:}) % set title properties
            case {'colorbar','CB','Colorbar','ColorBar','cb'}
                cbstuff = varargin(1,2:end); % get list of title properties
                set(hcb,cbstuff{:}) % set title properties
        end
    
end
end

if exist('OCTAVE_VERSION', 'builtin')
    MatOct = 1;
else
    MatOct = 0;
end
% In case many numbers appear on colorbar legend:
if ~MatOct
set(ModelID, 'renderer', 'zbuffer');
end
