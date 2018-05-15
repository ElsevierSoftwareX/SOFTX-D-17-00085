function plotMesh2(Coordinates, NodesOnElement, PlotID, elemlist, MNE_ID, varargin)
% Tim Truster
% 11/26/2013
% 
% Plot wire-frame of a 2-D mesh
% Optional arguments are in {}, defaults are in ().
%
% Default usage (for copy/paste):
% plotMesh2(Coordinates,NodesOnElement,1,(1:size(NodesOnElement,1)),[1 0 0 0 0])
%
% Inputs:
%  Coordinates = nodal coordinates [x y]
%  NodesOnElement = element connectivity [n1 n2 ... nnen]
%  {PlotID} = [ModelID {clfyn subp numsubp}]
%      ModelID = figure ID for plot window (1)
%      clfyn = 1 for clearing figure before plot, retain otherwise (1)
%      subp = subplot ID for current contour plot (1)
%      numsubp = number of subplots for figure window (1)
%  {elemlist} = list of specific elements to plot [e1 e2 ... en]' (1:numel)
%  {MNE_ID} = [meshyn nodeyn elemyn {faceyn ecolyn}] (1 0 0 0 0)
%      meshyn = 1 for plotting mesh lines, no mesh lines otherwise
%      nodeyn = 1 for plotting node ID on figure, no ID on plot otherwise
%      elemyn = 1 for plotting elem ID on figure, no ID on plot otherwise
%      faceyn = 1 for plotting face with color, no face plot otherwise
%      ecolyn = 1 for color-coding edges based on orientation, constant
%               otherwise
%  {varargin} = {types},{props1},{props2},...,{propsn} 
%               pairs of commands for figure, axes, etc.
%      types = {'fig','node','mesh','cb','xlab','axes',...} is a list of
%              all types of property pairs that follow, in the correct
%              order
%      props1 = {{'PropertyName1',PropertyValue1,'PropertyName2',... is a
%              of all properties assigned to a given type
%      Examples: varargin = {'title'},{'String','Make a visible title'}
%                varargin = {'axes'},{'CLim',[-10 10]} % resets caxis
%                varargin = {'surf'},{'FaceColor',[0 1 0]} % resets
%                           facecolor
%                varargin = {'node'},{'FontSize',32} % sets node ID font
%                varargin = {'line'},{'LineWidth',2} % changes mesh lines
%                varargin = {'xlab'},{'FontSize',18} % changes xlabel
%                varargin = {'xlab','node'},{'FontSize',32},{'FontSize',18}
%                varargin = 'xlab','FontSize',32 % one type doesn't need {}
%
% Default edge colors are as follows:
% Triangle:
%   coord   color   face
%   eta = 0 green   1
%   xi+eta=1 red     2
%   xi  = 0 blue    3
% Quadrilateral:
%   coord   color   face
%   eta =-1 green   1
%   xi  = 1 red     2
%   eta = 1 blue    3
%   xi  =-1 magenta 4

% Default arguments
switch nargin
    case 1
        error('Must supply Coordinates and NodesOnElement')
    case 2
        ModelID = 1;
        clfyn = 1;
        subp = 1;
        numsubp = 1;
        numel = size(NodesOnElement,1);
        elemlist = (1:numel)';
        meshyn = 1;
        nodeyn = 0;
        elemyn = 0;
        faceyn = 0;
        ecolyn = 0;
    case 3
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
        faceyn = 0;
        ecolyn = 0;
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
        meshyn = 1;
        nodeyn = 0;
        elemyn = 0;
        faceyn = 0;
        ecolyn = 0;
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
        if length(MNE_ID) >= 5
            meshyn = MNE_ID(1);
            nodeyn = MNE_ID(2);
            elemyn = MNE_ID(3);
            faceyn = MNE_ID(4);
            ecolyn = MNE_ID(5);
            if length(MNE_ID) >= 6
            curve = MNE_ID(6);
            end
        else
            meshyn = MNE_ID(1);
            nodeyn = MNE_ID(2);
            elemyn = MNE_ID(3);
            faceyn = 0;
            ecolyn = 0;
        end
        else
            meshyn = 1;
            nodeyn = 0;
            elemyn = 0;
            faceyn = 0;
            ecolyn = 0;
        end
end
if ~exist('curve','var')
    curve = 1;
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

%Set Face Colors
facecolor = [1 1 0];   %yellow

%Set Edge Colors
edgecolors = [0 0.8 0   %green   1
              0.8 0 0   %red     2
              0 0 1     %blue    3
              1 0 1];   %magenta 4

% Open subplot
subplot(numsubp,1,subp)

colormap jet

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

	% Extract element nodal coordinates and contour values
    PatchPoints = Coordinates(NodesOnElement(elem,1:nel),:);
          
    if nel == 3 || nel == 6
        
        if faceyn
        len = 5;
        knots = [0 0.25 0.50 0.75 1.0 0 3/4/4 6/4/4 9/4/4 12/4/4 0 1/2/4 2/2/4 3/2/4 1/2 0 1/4/4 2/4/4 3/4/4 1/4 0 0 0 0 0
                 0 0 0 0 0 0.25 0.25 0.25 0.25 0.25 0.5  0.5  0.5  0.5  0.5 0.75 0.75 0.75 0.75 0.75 1.0  1.0  1.0  1.0  1.0]';
        plot2DLagransurf(PatchPoints, nel, knots, len, 'none', facecolor);
        end
        
        if elemyn
            elemID = elem;
        else
            elemID = 0;
        end
        hold on
        xymid = mean(PatchPoints);
        if elemID > 0
        helem(elemp) = text(xymid(1),xymid(2),0,num2str(elemID),'HorizontalAlignment','center');
        end
        hold off

        % Plot mesh outline
        if meshyn
            if nel == 3 || ~curve
            if ecolyn
            hold on
            plot([PatchPoints(1,1) PatchPoints(2,1)],[PatchPoints(1,2) PatchPoints(2,2)],'Color',edgecolors(1,:),'LineWidth',2)
            plot([PatchPoints(2,1) PatchPoints(3,1)],[PatchPoints(2,2) PatchPoints(3,2)],'Color',edgecolors(2,:),'LineWidth',2)
            plot([PatchPoints(3,1) PatchPoints(1,1)],[PatchPoints(3,2) PatchPoints(1,2)],'Color',edgecolors(3,:),'LineWidth',2)
            hold off
            else
            hold on
            plot([PatchPoints(1,1) PatchPoints(2,1)],[PatchPoints(1,2) PatchPoints(2,2)],'k','LineWidth',1)
            plot([PatchPoints(2,1) PatchPoints(3,1)],[PatchPoints(2,2) PatchPoints(3,2)],'k','LineWidth',1)
            plot([PatchPoints(3,1) PatchPoints(1,1)],[PatchPoints(3,2) PatchPoints(1,2)],'k','LineWidth',1)
            hold off
            end
            else
            if ecolyn
            hold on
            plot([PatchPoints(1,1) PatchPoints(4,1)],[PatchPoints(1,2) PatchPoints(4,2)],'Color',edgecolors(1,:),'LineWidth',2)
            plot([PatchPoints(4,1) PatchPoints(2,1)],[PatchPoints(4,2) PatchPoints(2,2)],'Color',edgecolors(1,:),'LineWidth',2)
            plot([PatchPoints(2,1) PatchPoints(5,1)],[PatchPoints(2,2) PatchPoints(5,2)],'Color',edgecolors(2,:),'LineWidth',2)
            plot([PatchPoints(5,1) PatchPoints(3,1)],[PatchPoints(5,2) PatchPoints(3,2)],'Color',edgecolors(2,:),'LineWidth',2)
            plot([PatchPoints(3,1) PatchPoints(6,1)],[PatchPoints(3,2) PatchPoints(6,2)],'Color',edgecolors(3,:),'LineWidth',2)
            plot([PatchPoints(6,1) PatchPoints(1,1)],[PatchPoints(6,2) PatchPoints(1,2)],'Color',edgecolors(3,:),'LineWidth',2)
            hold off
            else
            hold on
            plot([PatchPoints(1,1) PatchPoints(4,1)],[PatchPoints(1,2) PatchPoints(4,2)],'k','LineWidth',1)
            plot([PatchPoints(4,1) PatchPoints(2,1)],[PatchPoints(4,2) PatchPoints(2,2)],'k','LineWidth',1)
            plot([PatchPoints(2,1) PatchPoints(5,1)],[PatchPoints(2,2) PatchPoints(5,2)],'k','LineWidth',1)
            plot([PatchPoints(5,1) PatchPoints(3,1)],[PatchPoints(5,2) PatchPoints(3,2)],'k','LineWidth',1)
            plot([PatchPoints(3,1) PatchPoints(6,1)],[PatchPoints(3,2) PatchPoints(6,2)],'k','LineWidth',1)
            plot([PatchPoints(6,1) PatchPoints(1,1)],[PatchPoints(6,2) PatchPoints(1,2)],'k','LineWidth',1)
            hold off
            end
            end
        end
        
        % Plot node IDs
        if nodeyn
            for j = 1:nel
                node = NodesOnElement(elem,j);
                tx = PatchPoints(j,1);
                ty = PatchPoints(j,2);
                tz = 0;
                hnode_count = hnode_count + 1;
                hnode(hnode_count) = text(tx,ty,tz,num2str(node),'HorizontalAlignment','center');
            end
        end
        
    else
        
        if faceyn
        len = 5;
        knots = [-1.0 -0.5  0.0  0.5  1.0 -1.0 -0.5  0.0  0.5  1.0 -1.0 -0.5  0.0  0.5  1.0 -1.0 -0.5  0.0  0.5  1.0 -1.0 -0.5  0.0  0.5  1.0
                 -1.0 -1.0 -1.0 -1.0 -1.0 -0.5 -0.5 -0.5 -0.5 -0.5 -0.0 -0.0 -0.0 -0.0 -0.0  0.5  0.5  0.5  0.5  0.5  1.0  1.0  1.0  1.0  1.0]';
        plot2DLagransurf(PatchPoints, nel, knots, len, 'none', facecolor);
        end

        if elemyn
            elemID = elem;
        else
            elemID = 0;
        end
        hold on
        xymid = mean(PatchPoints);
        if elemID > 0
        helem(elemp) = text(xymid(1),xymid(2),0,num2str(elemID),'HorizontalAlignment','center');
        end
        hold off

        % Plot mesh outline
        if meshyn
            if nel == 4 || ~curve
            if ecolyn
            hold on
            plot([PatchPoints(1,1) PatchPoints(2,1)],[PatchPoints(1,2) PatchPoints(2,2)],'Color',edgecolors(1,:),'LineWidth',2)
            plot([PatchPoints(2,1) PatchPoints(3,1)],[PatchPoints(2,2) PatchPoints(3,2)],'Color',edgecolors(2,:),'LineWidth',2)
            plot([PatchPoints(3,1) PatchPoints(4,1)],[PatchPoints(3,2) PatchPoints(4,2)],'Color',edgecolors(3,:),'LineWidth',2)
            plot([PatchPoints(4,1) PatchPoints(1,1)],[PatchPoints(4,2) PatchPoints(1,2)],'Color',edgecolors(4,:),'LineWidth',2)
            hold off
            else
            hold on
            plot([PatchPoints(1,1) PatchPoints(2,1)],[PatchPoints(1,2) PatchPoints(2,2)],'k','LineWidth',1)
            plot([PatchPoints(2,1) PatchPoints(3,1)],[PatchPoints(2,2) PatchPoints(3,2)],'k','LineWidth',1)
            plot([PatchPoints(3,1) PatchPoints(4,1)],[PatchPoints(3,2) PatchPoints(4,2)],'k','LineWidth',1)
            plot([PatchPoints(4,1) PatchPoints(1,1)],[PatchPoints(4,2) PatchPoints(1,2)],'k','LineWidth',1)
            hold off
            end
            else
            if ecolyn
            hold on
            plot([PatchPoints(1,1) PatchPoints(5,1)],[PatchPoints(1,2) PatchPoints(5,2)],'Color',edgecolors(1,:),'LineWidth',2)
            plot([PatchPoints(5,1) PatchPoints(2,1)],[PatchPoints(5,2) PatchPoints(2,2)],'Color',edgecolors(1,:),'LineWidth',2)
            plot([PatchPoints(2,1) PatchPoints(6,1)],[PatchPoints(2,2) PatchPoints(6,2)],'Color',edgecolors(2,:),'LineWidth',2)
            plot([PatchPoints(6,1) PatchPoints(3,1)],[PatchPoints(6,2) PatchPoints(3,2)],'Color',edgecolors(2,:),'LineWidth',2)
            plot([PatchPoints(3,1) PatchPoints(7,1)],[PatchPoints(3,2) PatchPoints(7,2)],'Color',edgecolors(3,:),'LineWidth',2)
            plot([PatchPoints(7,1) PatchPoints(4,1)],[PatchPoints(7,2) PatchPoints(4,2)],'Color',edgecolors(3,:),'LineWidth',2)
            plot([PatchPoints(4,1) PatchPoints(8,1)],[PatchPoints(4,2) PatchPoints(8,2)],'Color',edgecolors(4,:),'LineWidth',2)
            plot([PatchPoints(8,1) PatchPoints(1,1)],[PatchPoints(8,2) PatchPoints(1,2)],'Color',edgecolors(4,:),'LineWidth',2)
            hold off
            else
            hold on
            plot([PatchPoints(1,1) PatchPoints(5,1)],[PatchPoints(1,2) PatchPoints(5,2)],'k','LineWidth',1)
            plot([PatchPoints(5,1) PatchPoints(2,1)],[PatchPoints(5,2) PatchPoints(2,2)],'k','LineWidth',1)
            plot([PatchPoints(2,1) PatchPoints(6,1)],[PatchPoints(2,2) PatchPoints(6,2)],'k','LineWidth',1)
            plot([PatchPoints(6,1) PatchPoints(3,1)],[PatchPoints(6,2) PatchPoints(3,2)],'k','LineWidth',1)
            plot([PatchPoints(3,1) PatchPoints(7,1)],[PatchPoints(3,2) PatchPoints(7,2)],'k','LineWidth',1)
            plot([PatchPoints(7,1) PatchPoints(4,1)],[PatchPoints(7,2) PatchPoints(4,2)],'k','LineWidth',1)
            plot([PatchPoints(4,1) PatchPoints(8,1)],[PatchPoints(4,2) PatchPoints(8,2)],'k','LineWidth',1)
            plot([PatchPoints(8,1) PatchPoints(1,1)],[PatchPoints(8,2) PatchPoints(1,2)],'k','LineWidth',1)
            hold off
            end
            end
        end
        
        % Plot node IDs
        if nodeyn
            for j = 1:nel
                node = NodesOnElement(elem,j);
                tx = PatchPoints(j,1);
                ty = PatchPoints(j,2);
                tz = 0;
                hnode_count = hnode_count + 1;
                hnode(hnode_count) = text(tx,ty,tz,num2str(node),'HorizontalAlignment','center');
            end
        end
        
    end

end

% Final properties
hx = xlabel('x');
hy = ylabel('y');
hz = zlabel('');
ht = title('');

axis equal
% axis([0 10 -3 3])
axis off

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
            case {'face','Face','faces','Faces','surf','surface','surfaces','Surf','SURF'}
                if faceyn
                facestuff = varargin{1,1+obj}; % get list of line properties
                set(findobj(gca,'Type','surf'),facestuff{:}) % set line properties
                end
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
            case {'face','Face','faces','Faces','surf','surface','surfaces','Surf','SURF'}
                if faceyn
                facestuff = varargin(1,2:end); % get list of line properties
                set(findobj(gca,'Type','surf'),facestuff{:}) % set line properties
                end
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
