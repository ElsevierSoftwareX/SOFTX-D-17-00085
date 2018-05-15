% Interactive example that plots solutions from tutorial DEIPex2 to compare
% CZ and DG results and demonstrate how to execute analyses in batch mode.
%
% Moderate example of insertion of couplers using DEIProgram2. Corresponds
% to Figure 5 in "Discontinuous Element Insertion Algorithm" manuscript
% Domain: 4x3 rectangle, combination of T3 and Q4 elements; insertion of CZ
% couplers on region interfaces; demonstrates separation of mesh
% Loading: Displacement of 0.1 on right edge and top edge
%
% Last revision: 05/08/2018 TJT

batchinter = 'batch';
batchname = 'DEIPex2.m';
fprintf('starting file %s\n',batchname)
FEA_Program
disp(' Plot the regions in the mesh; press any key to continue')
pause
plotElemCont2(Coordinates,RegionOnElement(:),NodesOnElement(1:320,1:5),1,(1:320),[1 0 0],{'cb'},{'FontSize',20})
% plotElemCont2(NodeT2,NodesOnElement(:),NodesOnElement(1:320,1:5),2,(1:320),[1 0 0],{'cb'},{'FontSize',32})
caxis([0.5 8.5])

disp(' Plot the stress after the solution; press any key to continue')
pause
plotNodeCont2(Coordinates,StreList(1,:,:)'/2500,NodesOnElement(1:320,1:5),2,(1:320),[1 0 0],0,[3 4 6 9 0],{'cb'},{'FontSize',20})
caxis([0.9999999 1.0000001])
set(findobj(gcf,'Type','Colorbar'),'TickLabels',{'0.9999990','0.9999995','1.0000000','1.0000005','1.0000010'})

batchname = 'DEIPex2CZM.m';
fprintf('starting file %s\n',batchname)
FEA_Program

disp(' Plot the stress contour with CZ elements; press any key to continue')
pause
plotNodeCont2(Coordinates+2*Node_U_V,StreList(1,:,:)'/2500,NodesOnElement,3,(1:size(NodesOnElement,1)),[1 0 0],0,[3 4 6 9 0],{'cb'},{'FontSize',20})
