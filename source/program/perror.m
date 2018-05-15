% Tim Truster
% 04/08/2014

% Error checks for mesh arrays

% Nodes
if numnp < size(NodeTable,1)
    disp('Warning, number of nodes: numnp < size(Coordinates,1)')
    disp('Paused: press any key to continue')
elseif numnp > size(NodeTable,1)
    error('Error, number of nodes: numnp > size(Coordinates,1)')
end

% Elements
if numel < size(ix,1)
    disp('Warning, number of elements: numel < size(NodesOnElement,1)')
    disp('Paused: press any key to continue')
elseif numel > size(ix,1)
    error('Error, number of nodes: numel > size(NodesOnElement,1)')
end

% Materials
if size(MateT,1) > size(MatTypeTable,2)
    error('Error, incorrect size of material arrays: size(MateT,1) > size(MatTypeTable,2)')
elseif nummat < size(MateT,1)
    disp('Warning, number of materials: nummat < size(MateT,1)')
    disp('Paused: press any key to continue')
    pause
elseif nummat > size(MateT,1)
    error('Error, number of materials: nummat > size(MateT,1)')
end

if size(ix,2) ~= nen1
    disp('Error, connectivity: size of NodesOnElement does not match parameter nen: size(NodesOnElement,2) ~= nen')
    error('Note that FEA_Program does not use the element ID as column 1 of the array')
end

if size(NodeTable,2) ~= ndm
    disp('Warning, spatial dimensions: size of Coordinates does not match parameter ndm: size(Coordinates,2) ~= ndm')
    disp('Note that FEA_Program does not use the node ID as column 1 of the array')
    disp('Paused: press any key to continue')
end

if max(ix(1:numel,1:nen)) > numnp
    error('Error, connectivity: a node in NodesOnElement exceeds the number of nodes: max(NodesOnElement(1:numel,1:nen)) > numnp')
end

if max(ix(1:numel,nen1)) > nummat
    error('Error, element-materials: an element has a undefined material type: max(RegionOnElement(1:numel)) > nummat')
end

if max(ix(1:numel,nen1)) > max(MatTypeTable(1,1:nummat))
    error('Error, element-materials: an element has a undefined global material type: max(RegionOnElement(1:numel)) > max(MatTypeTable(1,1:nummat))')
end
