function plotElemCont3(Coordinates, Contour, NodesOnElement, PlotID, ...
                       elemlist, nodelist, MNE_ID, varargin)
% Tim Truster
% 11/26/2013
% 
% Plot contour of elemental finite element field from a 3-D mesh
% Optional arguments are in {}, defaults are in ().
%
% Default usage (for copy/paste):
% plotElemCont3(Coordinates,Contour,NodesOnElement,1,(1:size(NodesOnElement,1)),(1:size(Coordinates,1)),[1 0 0],varargin)
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
%  {nodelist} = list of nodes on boundary of mesh (1:size(Coordinates,1))
%  {MNE_ID} = [meshyn nodeyn elemyn] (1 0 0)
%      meshyn = 1 for plotting mesh lines, no mesh lines otherwise
%      nodeyn = 1 for plotting node ID on figure, no ID on plot otherwise
%      elemyn = 1 for plotting elem ID on figure, no ID on plot otherwise
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
        nodelist = (1:length(Coordinates))';
        meshyn = 1;
        nodeyn = 0;
        elemyn = 0;
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
        nodelist = (1:length(Coordinates))';
        meshyn = 1;
        nodeyn = 0;
        elemyn = 0;
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
        nodelist = (1:length(Coordinates))';
        meshyn = 1;
        nodeyn = 0;
        elemyn = 0;
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
        meshyn = 1;
        nodeyn = 0;
        elemyn = 0;
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

len = length(nodelist);
if len == length(Coordinates)
    ifflag = 0; % do not search over nodes since all are included
else
    ifflag = 1;
end
    
for elemp = 1:length(elemlist)
    
    elem = elemlist(elemp);
        
    %Determine patch size parameters
    nel = nnz(NodesOnElement(elem,1:nen));
    if nel == 4
        nelB = 4;
    elseif nel == 8
        nelB = 8;
    elseif nel == 10
        nelB = 4;
    elseif nel == 27
        nelB = 8;
    else
        nelB = 0; % Skip DG elements
    end

	% Extract element nodal coordinates and contour values
    NodeFlags = NodesOnElement(elem,1:nel);
    PatchPoints = Coordinates(NodeFlags,:)';
    ContourValues = Contour(elem);

    if nelB == 4

        lenn = 5;
        knots = [0 0.25 0.50 0.75 1.0 0 3/4/4 6/4/4 9/4/4 12/4/4 0 1/2/4 2/2/4 3/2/4 1/2 0 1/4/4 2/4/4 3/4/4 1/4 0 0 0 0 0
                 0 0 0 0 0 0.25 0.25 0.25 0.25 0.25 0.5  0.5  0.5  0.5  0.5 0.75 0.75 0.75 0.75 0.75 1.0  1.0  1.0  1.0  1.0]';

        if ifflag
        fflag = 0;
        [itemo,indo,imatch] = binsearch(NodeFlags(1),nodelist,1,len);
        fflag = fflag + imatch;
        [itemo,indo,imatch] = binsearch(NodeFlags(2),nodelist,1,len);
        fflag = fflag + imatch;
        [itemo,indo,imatch] = binsearch(NodeFlags(3),nodelist,1,len);
        fflag = fflag + imatch;
        else
        fflag = 3;
        end
        
        if fflag == 3
            
            if elemyn
                elemID = elem;
            else
                elemID = 0;
            end
            
            if nel == 4
            nlist = [1 2 3];
            helem = plot3DLagransurfcontI(PatchPoints(:,nlist), ContourValues, nel, knots, lenn, 'none', elemID, elemp, helem);
            else
            nlist = [1 2 3 5 6 7];
            helem = plot3DLagransurfcontI(PatchPoints(:,nlist), ContourValues, nel, knots, lenn, 'none', elemID, elemp, helem);
            end
            
            if meshyn
                hold on
                plot3([PatchPoints(1,1) PatchPoints(1,2)],[PatchPoints(2,1) PatchPoints(2,2)],[PatchPoints(3,1) PatchPoints(3,2)],'k','LineWidth',1)
                plot3([PatchPoints(1,2) PatchPoints(1,3)],[PatchPoints(2,2) PatchPoints(2,3)],[PatchPoints(3,2) PatchPoints(3,3)],'k','LineWidth',1)
                plot3([PatchPoints(1,3) PatchPoints(1,1)],[PatchPoints(2,3) PatchPoints(2,1)],[PatchPoints(3,3) PatchPoints(3,1)],'k','LineWidth',1)
                hold off
            end
        
            % Plot node IDs
            if nodeyn
                for j = 1:length(nlist)
                    node = NodesOnElement(elem,nlist(j));
                    tx = PatchPoints(1,nlist(j));
                    ty = PatchPoints(2,nlist(j));
                    tz = PatchPoints(3,nlist(j));
                    hnode_count = hnode_count + 1;
                    hnode(hnode_count) = text(tx,ty,tz,num2str(node),'HorizontalAlignment','center');
                end
            end
            
        end

        if ifflag
        fflag = 0;
        [itemo,indo,imatch] = binsearch(NodeFlags(2),nodelist,1,len);
        fflag = fflag + imatch;
        [itemo,indo,imatch] = binsearch(NodeFlags(3),nodelist,1,len);
        fflag = fflag + imatch;
        [itemo,indo,imatch] = binsearch(NodeFlags(4),nodelist,1,len);
        fflag = fflag + imatch;
        else
        fflag = 3;
        end
        
        if fflag == 3
            
            if elemyn
                elemID = elem;
            else
                elemID = 0;
            end
            
            if nel == 4
            nlist = [2 3 4];
            helem = plot3DLagransurfcontI(PatchPoints(:,nlist), ContourValues, nel, knots, lenn, 'none', elemID, elemp, helem);
            else
            nlist = [2 3 4 6 10 9];
            helem = plot3DLagransurfcontI(PatchPoints(:,nlist), ContourValues, nel, knots, lenn, 'none', elemID, elemp, helem);
            end
            
            if meshyn
                hold on
                plot3([PatchPoints(1,4) PatchPoints(1,2)],[PatchPoints(2,4) PatchPoints(2,2)],[PatchPoints(3,4) PatchPoints(3,2)],'k','LineWidth',1)
                plot3([PatchPoints(1,2) PatchPoints(1,3)],[PatchPoints(2,2) PatchPoints(2,3)],[PatchPoints(3,2) PatchPoints(3,3)],'k','LineWidth',1)
                plot3([PatchPoints(1,3) PatchPoints(1,4)],[PatchPoints(2,3) PatchPoints(2,4)],[PatchPoints(3,3) PatchPoints(3,4)],'k','LineWidth',1)
                hold off
            end
        
            % Plot node IDs
            if nodeyn
                for j = 1:length(nlist)
                    node = NodesOnElement(elem,nlist(j));
                    tx = PatchPoints(1,nlist(j));
                    ty = PatchPoints(2,nlist(j));
                    tz = PatchPoints(3,nlist(j));
                    hnode_count = hnode_count + 1;
                    hnode(hnode_count) = text(tx,ty,tz,num2str(node),'HorizontalAlignment','center');
                end
            end
            
        end
            
        if ifflag
        fflag = 0;
        [itemo,indo,imatch] = binsearch(NodeFlags(1),nodelist,1,len);
        fflag = fflag + imatch;
        [itemo,indo,imatch] = binsearch(NodeFlags(2),nodelist,1,len);
        fflag = fflag + imatch;
        [itemo,indo,imatch] = binsearch(NodeFlags(4),nodelist,1,len);
        fflag = fflag + imatch;
        else
        fflag = 3;
        end

        if fflag == 3
            
            if elemyn
                elemID = elem;
            else
                elemID = 0;
            end
            
            if nel == 4
            nlist = [1 2 4];
            helem = plot3DLagransurfcontI(PatchPoints(:,nlist), ContourValues, nel, knots, lenn, 'none', elemID, elemp, helem);
            else
            nlist = [1 2 4 5 9 8];
            helem = plot3DLagransurfcontI(PatchPoints(:,nlist), ContourValues, nel, knots, lenn, 'none', elemID, elemp, helem);
            end
            
            if meshyn
                hold on
                plot3([PatchPoints(1,1) PatchPoints(1,2)],[PatchPoints(2,1) PatchPoints(2,2)],[PatchPoints(3,1) PatchPoints(3,2)],'k','LineWidth',1)
                plot3([PatchPoints(1,2) PatchPoints(1,4)],[PatchPoints(2,2) PatchPoints(2,4)],[PatchPoints(3,2) PatchPoints(3,4)],'k','LineWidth',1)
                plot3([PatchPoints(1,4) PatchPoints(1,1)],[PatchPoints(2,4) PatchPoints(2,1)],[PatchPoints(3,4) PatchPoints(3,1)],'k','LineWidth',1)
                hold off
            end
        
            % Plot node IDs
            if nodeyn
                for j = 1:length(nlist)
                    node = NodesOnElement(elem,nlist(j));
                    tx = PatchPoints(1,nlist(j));
                    ty = PatchPoints(2,nlist(j));
                    tz = PatchPoints(3,nlist(j));
                    hnode_count = hnode_count + 1;
                    hnode(hnode_count) = text(tx,ty,tz,num2str(node),'HorizontalAlignment','center');
                end
            end
            
        end
            
        if ifflag
        fflag = 0;
        [itemo,indo,imatch] = binsearch(NodeFlags(1),nodelist,1,len);
        fflag = fflag + imatch;
        [itemo,indo,imatch] = binsearch(NodeFlags(3),nodelist,1,len);
        fflag = fflag + imatch;
        [itemo,indo,imatch] = binsearch(NodeFlags(4),nodelist,1,len);
        fflag = fflag + imatch;
        else
        fflag = 3;
        end
        
        if fflag == 3
            
            if elemyn
                elemID = elem;
            else
                elemID = 0;
            end
            
            if nel == 4
            nlist = [1 3 4];
            helem = plot3DLagransurfcontI(PatchPoints(:,nlist), ContourValues, nel, knots, lenn, 'none', elemID, elemp, helem);
            else
            nlist = [1 3 4 7 10 8];
            helem = plot3DLagransurfcontI(PatchPoints(:,nlist), ContourValues, nel, knots, lenn, 'none', elemID, elemp, helem);
            end
            
            if meshyn
                hold on
                plot3([PatchPoints(1,1) PatchPoints(1,3)],[PatchPoints(2,1) PatchPoints(2,3)],[PatchPoints(3,1) PatchPoints(3,3)],'k','LineWidth',1)
                plot3([PatchPoints(1,3) PatchPoints(1,4)],[PatchPoints(2,3) PatchPoints(2,4)],[PatchPoints(3,3) PatchPoints(3,4)],'k','LineWidth',1)
                plot3([PatchPoints(1,4) PatchPoints(1,1)],[PatchPoints(2,4) PatchPoints(2,1)],[PatchPoints(3,4) PatchPoints(3,1)],'k','LineWidth',1)
                hold off
            end
        
            % Plot node IDs
            if nodeyn
                for j = 1:length(nlist)
                    node = NodesOnElement(elem,nlist(j));
                    tx = PatchPoints(1,nlist(j));
                    ty = PatchPoints(2,nlist(j));
                    tz = PatchPoints(3,nlist(j));
                    hnode_count = hnode_count + 1;
                    hnode(hnode_count) = text(tx,ty,tz,num2str(node),'HorizontalAlignment','center');
                end
            end
            
        end

    elseif nelB == 8

        lenn = 5;
        knots = [-1.0 -0.5  0.0  0.5  1.0 -1.0 -0.5  0.0  0.5  1.0 -1.0 -0.5  0.0  0.5  1.0 -1.0 -0.5  0.0  0.5  1.0 -1.0 -0.5  0.0  0.5  1.0
                 -1.0 -1.0 -1.0 -1.0 -1.0 -0.5 -0.5 -0.5 -0.5 -0.5 -0.0 -0.0 -0.0 -0.0 -0.0  0.5  0.5  0.5  0.5  0.5  1.0  1.0  1.0  1.0  1.0]';

        if ifflag
        fflag = 0;
        [itemo,indo,imatch] = binsearch(NodeFlags(1),nodelist,1,len);
        fflag = fflag + imatch;
        [itemo,indo,imatch] = binsearch(NodeFlags(2),nodelist,1,len);
        fflag = fflag + imatch;
        [itemo,indo,imatch] = binsearch(NodeFlags(3),nodelist,1,len);
        fflag = fflag + imatch;
        [itemo,indo,imatch] = binsearch(NodeFlags(4),nodelist,1,len);
        fflag = fflag + imatch;
        else
        fflag = 4;
        end
        
        if fflag == 4
            
            if elemyn
                elemID = elem;
            else
                elemID = 0;
            end
            
            if nel == 8
            nlist = [1 2 3 4];
            helem = plot3DLagransurfcontI(PatchPoints(:,nlist), ContourValues, nel, knots, lenn, 'none', elemID, elemp, helem);
            else
            nlist = [1 2 3 4 9 10 11 12 21];
            helem = plot3DLagransurfcontI(PatchPoints(:,nlist), ContourValues, nel, knots, lenn, 'none', elemID, elemp, helem);
            end
            
            if meshyn
                hold on
                plot3([PatchPoints(1,1) PatchPoints(1,2)],[PatchPoints(2,1) PatchPoints(2,2)],[PatchPoints(3,1) PatchPoints(3,2)],'k','LineWidth',1)
                plot3([PatchPoints(1,2) PatchPoints(1,3)],[PatchPoints(2,2) PatchPoints(2,3)],[PatchPoints(3,2) PatchPoints(3,3)],'k','LineWidth',1)
                plot3([PatchPoints(1,3) PatchPoints(1,4)],[PatchPoints(2,3) PatchPoints(2,4)],[PatchPoints(3,3) PatchPoints(3,4)],'k','LineWidth',1)
                plot3([PatchPoints(1,4) PatchPoints(1,1)],[PatchPoints(2,4) PatchPoints(2,1)],[PatchPoints(3,4) PatchPoints(3,1)],'k','LineWidth',1)
                hold off
            end
        
            % Plot node IDs
            if nodeyn
                for j = 1:length(nlist)
                    node = NodesOnElement(elem,nlist(j));
                    tx = PatchPoints(1,nlist(j));
                    ty = PatchPoints(2,nlist(j));
                    tz = PatchPoints(3,nlist(j));
                    hnode_count = hnode_count + 1;
                    hnode(hnode_count) = text(tx,ty,tz,num2str(node),'HorizontalAlignment','center');
                end
            end
            
        end
            
        if ifflag
        fflag = 0;
        [itemo,indo,imatch] = binsearch(NodeFlags(5),nodelist,1,len);
        fflag = fflag + imatch;
        [itemo,indo,imatch] = binsearch(NodeFlags(6),nodelist,1,len);
        fflag = fflag + imatch;
        [itemo,indo,imatch] = binsearch(NodeFlags(7),nodelist,1,len);
        fflag = fflag + imatch;
        [itemo,indo,imatch] = binsearch(NodeFlags(8),nodelist,1,len);
        fflag = fflag + imatch;
        else
        fflag = 4;
        end
        
        if fflag == 4
            
            if elemyn
                elemID = elem;
            else
                elemID = 0;
            end
            
            if nel == 8
            nlist = [5 6 7 8];
            helem = plot3DLagransurfcontI(PatchPoints(:,nlist), ContourValues, nel, knots, lenn, 'none', elemID, elemp, helem);
            else
            nlist = [5 6 7 8 13 14 15 16 22];
            helem = plot3DLagransurfcontI(PatchPoints(:,nlist), ContourValues, nel, knots, lenn, 'none', elemID, elemp, helem);
            end
            
            if meshyn
                hold on
                plot3([PatchPoints(1,5) PatchPoints(1,6)],[PatchPoints(2,5) PatchPoints(2,6)],[PatchPoints(3,5) PatchPoints(3,6)],'k','LineWidth',1)
                plot3([PatchPoints(1,6) PatchPoints(1,7)],[PatchPoints(2,6) PatchPoints(2,7)],[PatchPoints(3,6) PatchPoints(3,7)],'k','LineWidth',1)
                plot3([PatchPoints(1,7) PatchPoints(1,8)],[PatchPoints(2,7) PatchPoints(2,8)],[PatchPoints(3,7) PatchPoints(3,8)],'k','LineWidth',1)
                plot3([PatchPoints(1,8) PatchPoints(1,5)],[PatchPoints(2,8) PatchPoints(2,5)],[PatchPoints(3,8) PatchPoints(3,5)],'k','LineWidth',1)
                hold off
            end
        
            % Plot node IDs
            if nodeyn
                for j = 1:length(nlist)
                    node = NodesOnElement(elem,nlist(j));
                    tx = PatchPoints(1,nlist(j));
                    ty = PatchPoints(2,nlist(j));
                    tz = PatchPoints(3,nlist(j));
                    hnode_count = hnode_count + 1;
                    hnode(hnode_count) = text(tx,ty,tz,num2str(node),'HorizontalAlignment','center');
                end
            end
            
        end
            
        if ifflag
        fflag = 0;
        [itemo,indo,imatch] = binsearch(NodeFlags(1),nodelist,1,len);
        fflag = fflag + imatch;
        [itemo,indo,imatch] = binsearch(NodeFlags(2),nodelist,1,len);
        fflag = fflag + imatch;
        [itemo,indo,imatch] = binsearch(NodeFlags(6),nodelist,1,len);
        fflag = fflag + imatch;
        [itemo,indo,imatch] = binsearch(NodeFlags(5),nodelist,1,len);
        fflag = fflag + imatch;
        else
        fflag = 4;
        end
        
        if fflag == 4
            
            if elemyn
                elemID = elem;
            else
                elemID = 0;
            end
            
            if nel == 8
            nlist = [1 2 6 5];
            helem = plot3DLagransurfcontI(PatchPoints(:,nlist), ContourValues, nel, knots, lenn, 'none', elemID, elemp, helem);
            else
            nlist = [1 2 6 5 9 18 13 17 25];
            helem = plot3DLagransurfcontI(PatchPoints(:,nlist), ContourValues, nel, knots, lenn, 'none', elemID, elemp, helem);
            end
            
            if meshyn
                hold on
                plot3([PatchPoints(1,1) PatchPoints(1,2)],[PatchPoints(2,1) PatchPoints(2,2)],[PatchPoints(3,1) PatchPoints(3,2)],'k','LineWidth',1)
                plot3([PatchPoints(1,2) PatchPoints(1,6)],[PatchPoints(2,2) PatchPoints(2,6)],[PatchPoints(3,2) PatchPoints(3,6)],'k','LineWidth',1)
                plot3([PatchPoints(1,6) PatchPoints(1,5)],[PatchPoints(2,6) PatchPoints(2,5)],[PatchPoints(3,6) PatchPoints(3,5)],'k','LineWidth',1)
                plot3([PatchPoints(1,5) PatchPoints(1,1)],[PatchPoints(2,5) PatchPoints(2,1)],[PatchPoints(3,5) PatchPoints(3,1)],'k','LineWidth',1)
                hold off
            end
        
            % Plot node IDs
            if nodeyn
                for j = 1:length(nlist)
                    node = NodesOnElement(elem,nlist(j));
                    tx = PatchPoints(1,nlist(j));
                    ty = PatchPoints(2,nlist(j));
                    tz = PatchPoints(3,nlist(j));
                    hnode_count = hnode_count + 1;
                    hnode(hnode_count) = text(tx,ty,tz,num2str(node),'HorizontalAlignment','center');
                end
            end
            
        end
            
        if ifflag
        fflag = 0;
        [itemo,indo,imatch] = binsearch(NodeFlags(2),nodelist,1,len);
        fflag = fflag + imatch;
        [itemo,indo,imatch] = binsearch(NodeFlags(3),nodelist,1,len);
        fflag = fflag + imatch;
        [itemo,indo,imatch] = binsearch(NodeFlags(7),nodelist,1,len);
        fflag = fflag + imatch;
        [itemo,indo,imatch] = binsearch(NodeFlags(6),nodelist,1,len);
        fflag = fflag + imatch;
        else
        fflag = 4;
        end
        
        if fflag == 4
            
            if elemyn
                elemID = elem;
            else
                elemID = 0;
            end
            
            if nel == 8
            nlist = [2 3 7 6];
            helem = plot3DLagransurfcontI(PatchPoints(:,nlist), ContourValues, nel, knots, lenn, 'none', elemID, elemp, helem);
            else
            nlist = [2 3 7 6 10 19 14 18 24];
            helem = plot3DLagransurfcontI(PatchPoints(:,nlist), ContourValues, nel, knots, lenn, 'none', elemID, elemp, helem);
            end
            
            if meshyn
                hold on
                plot3([PatchPoints(1,2) PatchPoints(1,3)],[PatchPoints(2,2) PatchPoints(2,3)],[PatchPoints(3,2) PatchPoints(3,3)],'k','LineWidth',1)
                plot3([PatchPoints(1,3) PatchPoints(1,7)],[PatchPoints(2,3) PatchPoints(2,7)],[PatchPoints(3,3) PatchPoints(3,7)],'k','LineWidth',1)
                plot3([PatchPoints(1,7) PatchPoints(1,6)],[PatchPoints(2,7) PatchPoints(2,6)],[PatchPoints(3,7) PatchPoints(3,6)],'k','LineWidth',1)
                plot3([PatchPoints(1,6) PatchPoints(1,2)],[PatchPoints(2,6) PatchPoints(2,2)],[PatchPoints(3,6) PatchPoints(3,2)],'k','LineWidth',1)
                hold off
            end
        
            % Plot node IDs
            if nodeyn
                for j = 1:length(nlist)
                    node = NodesOnElement(elem,nlist(j));
                    tx = PatchPoints(1,nlist(j));
                    ty = PatchPoints(2,nlist(j));
                    tz = PatchPoints(3,nlist(j));
                    hnode_count = hnode_count + 1;
                    hnode(hnode_count) = text(tx,ty,tz,num2str(node),'HorizontalAlignment','center');
                end
            end
            
        end
            
        if ifflag
        fflag = 0;
        [itemo,indo,imatch] = binsearch(NodeFlags(3),nodelist,1,len);
        fflag = fflag + imatch;
        [itemo,indo,imatch] = binsearch(NodeFlags(4),nodelist,1,len);
        fflag = fflag + imatch;
        [itemo,indo,imatch] = binsearch(NodeFlags(8),nodelist,1,len);
        fflag = fflag + imatch;
        [itemo,indo,imatch] = binsearch(NodeFlags(7),nodelist,1,len);
        fflag = fflag + imatch;
        else
        fflag = 4;
        end
        
        if fflag == 4
            
            if elemyn
                elemID = elem;
            else
                elemID = 0;
            end
            
            if nel == 8
            nlist = [3 4 8 7];
            helem = plot3DLagransurfcontI(PatchPoints(:,nlist), ContourValues, nel, knots, lenn, 'none', elemID, elemp, helem);
            else
            nlist = [3 4 8 7 11 20 15 19 26];
            helem = plot3DLagransurfcontI(PatchPoints(:,nlist), ContourValues, nel, knots, lenn, 'none', elemID, elemp, helem);
            end
            
            if meshyn
                hold on
                plot3([PatchPoints(1,3) PatchPoints(1,4)],[PatchPoints(2,3) PatchPoints(2,4)],[PatchPoints(3,3) PatchPoints(3,4)],'k','LineWidth',1)
                plot3([PatchPoints(1,4) PatchPoints(1,8)],[PatchPoints(2,4) PatchPoints(2,8)],[PatchPoints(3,4) PatchPoints(3,8)],'k','LineWidth',1)
                plot3([PatchPoints(1,8) PatchPoints(1,7)],[PatchPoints(2,8) PatchPoints(2,7)],[PatchPoints(3,8) PatchPoints(3,7)],'k','LineWidth',1)
                plot3([PatchPoints(1,7) PatchPoints(1,3)],[PatchPoints(2,7) PatchPoints(2,3)],[PatchPoints(3,7) PatchPoints(3,3)],'k','LineWidth',1)
                hold off
            end
        
            % Plot node IDs
            if nodeyn
                for j = 1:length(nlist)
                    node = NodesOnElement(elem,nlist(j));
                    tx = PatchPoints(1,nlist(j));
                    ty = PatchPoints(2,nlist(j));
                    tz = PatchPoints(3,nlist(j));
                    hnode_count = hnode_count + 1;
                    hnode(hnode_count) = text(tx,ty,tz,num2str(node),'HorizontalAlignment','center');
                end
            end
            
        end
            
        if ifflag
        fflag = 0;
        [itemo,indo,imatch] = binsearch(NodeFlags(4),nodelist,1,len);
        fflag = fflag + imatch;
        [itemo,indo,imatch] = binsearch(NodeFlags(1),nodelist,1,len);
        fflag = fflag + imatch;
        [itemo,indo,imatch] = binsearch(NodeFlags(5),nodelist,1,len);
        fflag = fflag + imatch;
        [itemo,indo,imatch] = binsearch(NodeFlags(8),nodelist,1,len);
        fflag = fflag + imatch;
        else
        fflag = 4;
        end
        
        if fflag == 4
            
            if elemyn
                elemID = elem;
            else
                elemID = 0;
            end
            
            if nel == 8
            nlist = [4 1 5 8];
            helem = plot3DLagransurfcontI(PatchPoints(:,nlist), ContourValues, nel, knots, lenn, 'none', elemID, elemp, helem);
            else
            nlist = [4 1 5 8 12 17 16 20 23];
            helem = plot3DLagransurfcontI(PatchPoints(:,nlist), ContourValues, nel, knots, lenn, 'none', elemID, elemp, helem);
            end
            
            if meshyn
                hold on
                plot3([PatchPoints(1,4) PatchPoints(1,1)],[PatchPoints(2,4) PatchPoints(2,1)],[PatchPoints(3,4) PatchPoints(3,1)],'k','LineWidth',1)
                plot3([PatchPoints(1,1) PatchPoints(1,5)],[PatchPoints(2,1) PatchPoints(2,5)],[PatchPoints(3,1) PatchPoints(3,5)],'k','LineWidth',1)
                plot3([PatchPoints(1,5) PatchPoints(1,8)],[PatchPoints(2,5) PatchPoints(2,8)],[PatchPoints(3,5) PatchPoints(3,8)],'k','LineWidth',1)
                plot3([PatchPoints(1,8) PatchPoints(1,4)],[PatchPoints(2,8) PatchPoints(2,4)],[PatchPoints(3,8) PatchPoints(3,4)],'k','LineWidth',1)
                hold off
            end
        
            % Plot node IDs
            if nodeyn
                for j = 1:length(nlist)
                    node = NodesOnElement(elem,nlist(j));
                    tx = PatchPoints(1,nlist(j));
                    ty = PatchPoints(2,nlist(j));
                    tz = PatchPoints(3,nlist(j));
                    hnode_count = hnode_count + 1;
                    hnode(hnode_count) = text(tx,ty,tz,num2str(node),'HorizontalAlignment','center');
                end
            end
            
        end
            
    end

end
shading interp
hx = xlabel('x');
hy = ylabel('y');
hz = zlabel('z');
ht = title('');

axis square
axis equal
% axis([-2 2 -2 2])
% axis off
hcb = colorbar('EastOutside','FontSize',13,'FontName','Arial','LineWidth',1);
    
% adds scientific notation to a colorbar for 3D block
% text(1.66,0,1.378,'-2','FontSize',9)
% text(1.465,0,1.370,'x 10','FontSize',13)
% cb=colorbar;
% set(cb,'yticklabel',[2 2.1 2.2 2.3 2.4 2.5 2.6 2.7])
% set(cb,'FontSize',13)

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