function plotBC(Coordinates, NodeBC, PlotID, varargin)
% Tim Truster
% 11/28/2013
% 
% Plot boundary conditions of a mesh
% Optional arguments are in {}, defaults are in ().
%
% Default usage (for copy/paste):
% plotBC(Coordinates,NodeBC,1)
%
% Inputs:
%  Coordinates = nodal coordinates [x y]
%  NodeBC = boundary condition codes [node dof value]
%  {PlotID} = [ModelID {clfyn subp numsubp}]
%      ModelID = figure ID for plot window (1)
%      clfyn = 1 for clearing figure before plot, retain otherwise (0)
%      subp = subplot ID for current contour plot (1)
%      numsubp = number of subplots for figure window (1)
%               otherwise
%  {varargin} = {types},{props1},{props2},...,{propsn} 
%               pairs of commands for figure, axes, etc.
%      types = {'fig','node','mesh','cb','xlab','axes',...} is a list of
%              all types of property pairs that follow, in the correct
%              order
%      props1 = {{'PropertyName1',PropertyValue1,'PropertyName2',... is a
%              of all properties assigned to a given type
%      Examples: varargin = {1},{'Color',[0 1 0]} % resets color of markers
%                           for dof=1 boundary conditions
%                varargin = {2},{'MarkerSize',20} % resets markersize for 
%                           dof=2 boundary conditions
%                varargin = {'title'},{'String','Make a visible title'}
%                varargin = {'axes'},{'CLim',[-10 10]} % resets caxis
%                varargin = {'xlab'},{'FontSize',18} % changes xlabel
%                varargin = {'xlab','node'},{'FontSize',32},{'FontSize',18}
%                varargin = 'xlab','FontSize',32 % one type doesn't need {}


% Default arguments
switch nargin
    case 1
        error('Must supply Coordinates and NodeBC')
    case 2
        numBC = size(NodeBC,1);
        ModelID = 1;
        clfyn = 0;
        subp = 1;
        numsubp = 1;
    otherwise
        numBC = size(NodeBC,1);
        ModelID = PlotID(1);
        if length(PlotID) == 4
            clfyn = PlotID(2);
            subp = PlotID(3);
            numsubp = PlotID(4);
        else
            clfyn = 0;
            subp = 1;
            numsubp = 1;
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

% Set marker data
markcolors = [0.8 0 0   %red     applied non-zero BC
              0 0 1];   %blue    fixed BC
markerlist  =    {'+' 'x' 'o' 'square' 'diamond' '.' 'v' '^' '>' '<' 'pentagram' 'p' 'hexagram' 'h'};
markersizes = 10*[ 1   1   1     1.2      1.2     1   1   1   1   1       1       1      1       1];

% Open subplot
subplot(numsubp,1,subp)

ndf = max(NodeBC(:,2));
ndm = min(size(Coordinates));
Coordinates = reshape(Coordinates,length(Coordinates),ndm);

% Set up arrays for handles
hbc = zeros(length(Coordinates),ndf);
hbc_count = zeros(ndf,1);


for bc = 1:numBC
    
    node = NodeBC(bc,1);
    dof = NodeBC(bc,2);
    value = NodeBC(bc,3);

	% Extract nodal coordinates
    coords = Coordinates(node,:);
    
    if value ~= 0
        markcolor = markcolors(1,:);
    else
        markcolor = markcolors(2,:);
    end
    
    hbc_count(dof) = hbc_count(dof) + 1;
    if ndm == 2
    hold on
    hbc(hbc_count(dof),dof) = plot(coords(1),coords(2),'LineStyle','none','Color',markcolor,'Marker',markerlist{dof},'MarkerSize',markersizes(dof));
    hold off
    elseif ndm == 3
    hold on
    hbc(hbc_count(dof),dof) = plot3(coords(1),coords(2),coords(3),'LineStyle','none','Color',markcolor,'Marker',markerlist{dof},'MarkerSize',markersizes(dof));
    hold off
    elseif ndm == 1
    hold on
    hbc(hbc_count(dof),dof) = plot(coords(1),0,'LineStyle','none','Color',markcolor,'Marker',markerlist{dof},'MarkerSize',markersizes(dof));
    hold off
    end
          

end

% Final properties
hx = xlabel('x');
hy = ylabel('y');
hz = zlabel('');
ht = title('');

axis equal
% axis([0 10 -3 3])
% axis off

% Add legend for BC markers
bc_used = find(hbc_count); % check for which BCs where prescribed
dofstr = num2str(bc_used);
prefix = repmat('dof',length(bc_used),1); % create list of BC identifiers
legstr = [prefix dofstr];
legend(hbc(1,bc_used),legstr,'Location','EastOutside')

% Set additional figure properties
if ~isempty(varargin)
if iscell(varargin{1,1}) % Multiple types of objects specified
    
    ObjTypes = varargin{1,1}; % header with list of object property types
    numObj = min(length(ObjTypes),length(varargin)-1);
    
    for obj = 1:numObj
        
        objtype = ObjTypes{1,obj}; % get title of object type
        switch objtype
            case isnumeric(objtype)
                dof = objtype;
                dofstuff = varargin{1,1+obj}; % get list of dof marker properties
                set(hbc(1:hbc_count(dof),dof),dofstuff{:}) % set dof marker properties
            case {'fig','Fig','Figure','figure'}
                figstuff = varargin{1,1+obj}; % get list of figure properties
                set(gcf,figstuff{:}) % set figure properties
            case {'axes'}
                axesstuff = varargin{1,1+obj}; % get list of axes properties
                set(gca,axesstuff{:}) % set axes properties
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
            case isnumeric(objtype)
                dof = objtype;
                dofstuff = varargin(1,2:end); % get list of dof marker properties
                set(hbc(1:hbc_count(dof),dof),dofstuff{:}) % set dof marker properties
            case {'fig','Fig','Figure','figure'}
                figstuff = varargin(1,2:end); % get list of figure properties
                set(gcf,figstuff{:}) % set figure properties
            case {'axes'}
                axesstuff = varargin(1,2:end); % get list of axes properties
                set(gca,axesstuff{:}) % set axes properties
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

% In case many numbers appear on colorbar legend:
set(ModelID, 'renderer', 'zbuffer');
