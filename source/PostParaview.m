% Program: PostParaview
% Tim Truster
% 10/16/2015
%
% Function to output time history to vtk files for Paraview viewing

% README:
% 0. Specify in the variable "userdefaultdir" the path to the root directory
%    that you plan to put all of your output folders
% 1. Execute file with F5 or play button
% 2. A window opens to specify the output folder for the current VTK files;
%    to create a new folder within the "userdefaultdir" directory quickly,
%    follow the steps below
% 3. Click the "Make New Folder" button in the window, which will create a
%    new directory in the current folder (currently "userdefaultdir")
% 4. Press "Enter" key to confirm folder name
% 5. Press "Enter" key to select the new folder
% 6. Script then executes and writes the VTK files


%%%%%%%%%%%%%%%%%%%%%%%%%%%% BEGIN CONTROL BOX %%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Steps to output: starting step, increment to step, and last step
stepstart = 1;
stepinc = 1;
stepstop = 1;

startp = stepstart; % first step # for VTK file
incp = 1; % first step # for VTK file
stopp = stepstop/1; % first step # for VTK file

% Nodes to output
nodestart = 1;
nodeend = numnp;

% Elements to output
elemstart = 1;
elemend = numel-numSI;

% Number of nodes per element; assumed constant for all elements elemstart 
% to elemend
nenPV = nen/2; % nen to use for Paraview file

% Couplers to output
coupstart = numel-numSI+1;
coupend = numel;

strflag = 0; % flag for stress postprocessing
st2flag = 0; % flag for stress vectors/scalars
serflag = 0; % flag for elemental stress postprocessing
se2flag = 0; % flag for elemental stress vectors/scalars
disflag = 1; % flag for displacement
mflag = 1; % flag for printing region colors
cflag = 0; % flag for couplers
cseflag = 0; % flag for coupler element stresses

dfoldername = 'ParaOut'; %default name of folder for files to be placed
userdefaultdir = pwd; %list your default output root directory here
foldername = uigetdir(userdefaultdir,'Select folder to write VTK files');
filename = 'out'; %prefNodesOnElement filename (e.g. 'out' -> out01.vtk)
header = 'Elasticity'; %text at top of VTK files

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% END CONTROL BOX %%%%%%%%%%%%%%%%%%%%%%%%%%%%%


numnpe = nodeend - nodestart + 1;
numele = elemend - elemstart + 1;
numcoup = coupend - coupstart + 1;

% check if foldername is a number, meaning the user canceled and didn't
% pick a folder
if isnumeric(foldername)
    foldername = dfoldername;
end
% create the folder if it does not exist
if exist(foldername,'dir') == 0
    mkdir(foldername);
end

% ensure that the output step requested does not exceed the existing
% analysis output
if exist('stepmax','var')
    stepstop = min(stepstop,stepmax);
end

%% Print results to VTK file: loop over steps
paravsteps = startp:incp:stopp;
stept = 0;
for stepi = stepstart:stepinc:stepstop
    
    stept = stept+1;
    stepp = paravsteps(stept);
    
    if stepstop < 10000
        if stepi < 10
            parfilename = strcat(foldername,'/',filename,'000',num2str(stepp));
        elseif stepi < 100
            parfilename = strcat(foldername,'/',filename,'00',num2str(stepp));
        elseif stepi < 1000
            parfilename = strcat(foldername,'/',filename,'0',num2str(stepp));
        else
            parfilename = strcat(foldername,'/',filename,num2str(stepp));
        end
    end
    

    % Set cell-type and number of nodes on elements
    switch nenPV

        case 3
            celltype = 5;
            nen2 = nenPV;
            elemtext = ' %i %i %i %i\n';
            intertype = 3;
            nenI = 2;
            couptext = ' %i %i %i\n';
            couporder = [1 2];
        case 4
            if ndm == 2
                celltype = 9;
                intertype = 3;
                nenI = 2;
                couptext = ' %i %i %i\n';
                couporder = [1 2];
            elseif ndm == 3
                celltype = 10;
                intertype = 5;
                nenI = 3;
                couptext = ' %i %i %i %i\n';
                couporder = [1 2 3];
            end
            nen2 = nenPV;
            elemtext = ' %i %i %i %i %i\n';
        case 6
            celltype = 22;
            nen2 = nenPV;
            elemtext = ' %i %i %i %i %i %i %i\n';
            intertype = 21;
            nenI = 3;
            couptext = ' %i %i %i %i\n';
            couporder = [1 2 4];
        case 8
            if ndm == 3
                celltype = 11;
                intertype = 9;
                nenI = 4;
                couptext = ' %i %i %i %i %i\n';
                couporder = [1 2 3 4];
            elseif ndm == 2
                celltype = 23;
                intertype = 21;
                nenI = 3;
                couptext = ' %i %i %i %i\n';
                couporder = [1 2 5];
            end
            nen2 = nenPV;
            elemtext = ' %i %i %i %i %i %i %i %i %i\n';
        case 9
            celltype = 23;
            nen2 = 8;
            elemtext = ' %i %i %i %i %i %i %i %i %i\n';
            intertype = 21;
            nenI = 3;
            couptext = ' %i %i %i %i\n';
            couporder = [1 2 5];
        case 10
            celltype = 24;
            nen2 = nenPV;
            elemtext = ' %i %i %i %i %i %i %i %i %i %i %i\n';
            intertype = 22;
            nenI = 6;
            couptext = ' %i %i %i %i %i %i %i\n';
            couporder = [1 2 3 5 6 7];
        case 20
            celltype = 25;
            nen2 = nenPV;
            elemtext = ' %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i\n';
            intertype = 23;
            nenI = 8;
            couptext = ' %i %i %i %i %i %i %i %i %i\n';
            couporder = [1 2 3 4 9 10 11 12];
        case 27
            celltype = 25;
            nen2 = 20;
            elemtext = ' %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i %i\n';
            intertype = 23;
            nenI = 8;
            couptext = ' %i %i %i %i %i %i %i %i %i\n';
            couporder = [1 2 3 4 9 10 11 12];

    end

    fid = fopen(strcat(parfilename,'.vtk'),'wt');

    fprintf(fid,'# vtk DataFile Version 1.0\n');
    fprintf(fid,'%s \n',header);
    fprintf(fid,'ASCII\n');
    fprintf(fid,'\n');

    fprintf(fid,'DATASET UNSTRUCTURED_GRID\n');
    fprintf(fid,'POINTS   %i float\n',numnpe);
%% Coordinates
    if ndm == 2
        fprintf(fid,'%16.7E %16.7E %16.7E\n',[Coordinates(nodestart:nodeend,1:2)'; zeros(1,numnpe)]);
    else
        fprintf(fid,'%16.7E %16.7E %16.7E\n',Coordinates(nodestart:nodeend,:)');
    end
%% Elements
    fprintf(fid,'\n');
    fprintf(fid,'CELLS %1$i %2$i\n',numele,(nen2+1)*numele);

    fprintf(fid,elemtext,[nen2*ones(numele,1) (NodesOnElement(elemstart:elemend,1:nen2)-(nodestart)*ones(numele,nen2))]');

    fprintf(fid,'\n');
    fprintf(fid,'CELL_TYPES %1$i\n',numele);

    fprintf(fid,'%i\n',celltype*ones(numele,1));

    fprintf(fid,'\n');
    fprintf(fid,'POINT_DATA   %i\n',numnpe);

%% Displacement
if disflag
    
    NodeDispPV = squeeze(DispList(:,:,stepi));
    
    fprintf(fid,'\n');
    fprintf(fid,'VECTORS Displacement float\n');

    if ndm == 1
        fprintf(fid,'%16.7E %16.7E %16.7E\n',[NodeDispPV(1,nodestart:nodeend); zeros(2,numnpe)]);
    elseif ndm == 2
        fprintf(fid,'%16.7E %16.7E %16.7E\n',[NodeDispPV(1:2,nodestart:nodeend); zeros(1,numnpe)]);
    else
        fprintf(fid,'%16.7E %16.7E %16.7E\n',NodeDispPV(1:3,nodestart:nodeend));
    end
end
%% Stresses (xx,yy,xy)
    if strflag == 1
    
        if(exist('StreList','var')==0)
            disp('warning, StreList is not defined from analysis; zeros are used')
            StreList3 = zeros(npstr,numnpe);
        else
            if stepi > 0
                StreList3 = squeeze(StreList(1:npstr,:,stepi));
            else
                StreList3 = zeros(npstr,numnpe);
            end
        end
        
        if ndm == 3
        
            
        if st2flag
            
            if npstr > 6
    fprintf(fid,'\n');
%     fprintf(fid,'POINT_DATA   %i\n',numnp);
    fprintf(fid,'SCALARS VonMises float\n');
    fprintf(fid,'LOOKUP_TABLE default\n');

        fprintf(fid,'%16.7E\n',StreList3(7,nodestart:nodeend));
        
            if npstr > 7
        fprintf(fid,'\n');
        fprintf(fid,'VECTORS StressVec float\n');

            fprintf(fid,'%16.7E %16.7E %16.7E\n',StreList3(8:10,nodestart:nodeend));
            
            if npstr > 10
    fprintf(fid,'\n');
%     fprintf(fid,'POINT_DATA   %i\n',numnp);
    fprintf(fid,'SCALARS Hydro float\n');
    fprintf(fid,'LOOKUP_TABLE default\n');

        fprintf(fid,'%16.7E\n',StreList3(11,nodestart:nodeend));
            end; end; end
        
        end

        fprintf(fid,'\n');
        fprintf(fid,'TENSORS Stress float\n');

        fprintf(fid,'%16.7E %16.7E %16.7E\n %16.7E %16.7E %16.7E\n %16.7E %16.7E %16.7E\n \n',StreList3([1 4 6 4 2 5 6 5 3],:));
        
        
        elseif ndm == 2
        
            
        if st2flag
            if npstr > 3
    fprintf(fid,'\n');
%     fprintf(fid,'POINT_DATA   %i\n',numnp);
    fprintf(fid,'SCALARS VonMises float\n');
    fprintf(fid,'LOOKUP_TABLE default\n');

        fprintf(fid,'%16.7E\n',StreList3(4,nodestart:nodeend));
            if npstr > 4
        fprintf(fid,'\n');
        fprintf(fid,'VECTORS StressVec float\n');

            fprintf(fid,'%16.7E %16.7E 0.0000000E+000\n',StreList3(5:6,nodestart:nodeend));
            if npstr > 6
    fprintf(fid,'\n');
%     fprintf(fid,'POINT_DATA   %i\n',numnp);
    fprintf(fid,'SCALARS Hydro float\n');
    fprintf(fid,'LOOKUP_TABLE default\n');

        fprintf(fid,'%16.7E\n',StreList3(7,nodestart:nodeend));
            
            end; end; end
        end

        fprintf(fid,'\n');
        fprintf(fid,'TENSORS Stress float\n');

        fprintf(fid,'%16.7E %16.7E 0.0000000E+000\n %16.7E %16.7E 0.0000000E+000\n 0.0000000E+000 0.0000000E+000 0.0000000E+000\n \n',StreList3([1 3 3 2],:));
        
        
        elseif ndm == 1

            
        fprintf(fid,'\n');
        fprintf(fid,'SCALARS Stress float\n');
        fprintf(fid,'LOOKUP_TABLE default\n');

        fprintf(fid,'%16.7E\n',StreList3(1,:));
            
        
        end
    end
    
        fprintf(fid,'\n');
        fprintf(fid,'CELL_DATA   %i\n',numele);
        
%% Elemental Stresses
    if serflag == 1
        
        if(exist('StreListE','var')==0)
            disp('warning, StreListE is not defined from analysis; zeros are used')
            StreList4 = zeros(nestr,numele);
        else
            if stepi > 0
                StreList4 = squeeze(StreListE(1:nestr,:,stepi));
            else
                StreList4 = zeros(nestr,numele);
            end
        end
        
        if ndm == 3
        
            
        if st2flag
            
            if nestr > 6
    fprintf(fid,'\n');
    fprintf(fid,'SCALARS EVonMises float\n');
    fprintf(fid,'LOOKUP_TABLE default\n');

        fprintf(fid,'%16.7E\n',StreList4(7,elemstart:elemend));
        
            if nestr > 7
        fprintf(fid,'\n');
        fprintf(fid,'VECTORS StressVec float\n');

            fprintf(fid,'%16.7E %16.7E %16.7E\n',StreList4(8:10,elemstart:elemend));
            
            if nestr > 10
    fprintf(fid,'\n');
    fprintf(fid,'SCALARS EHydro float\n');
    fprintf(fid,'LOOKUP_TABLE default\n');

        fprintf(fid,'%16.7E\n',StreList4(11,elemstart:elemend));
            end; end; end
        
        end

        fprintf(fid,'\n');
        fprintf(fid,'TENSORS EStress float\n');

        fprintf(fid,'%16.7E %16.7E %16.7E\n %16.7E %16.7E %16.7E\n %16.7E %16.7E %16.7E\n \n',StreList4([1 4 6 4 2 5 6 5 3],:));
        
        
        elseif ndm == 2
        
            
        if st2flag
            if nestr > 3
    fprintf(fid,'\n');
    fprintf(fid,'SCALARS EVonMises float\n');
    fprintf(fid,'LOOKUP_TABLE default\n');

        fprintf(fid,'%16.7E\n',StreList4(4,elemstart:elemend));
            if nestr > 4
        fprintf(fid,'\n');
        fprintf(fid,'VECTORS EStressVec float\n');

            fprintf(fid,'%16.7E %16.7E 0.0000000E+000\n',StreList4(5:6,elemstart:elemend));
            if nestr > 6
    fprintf(fid,'\n');
    fprintf(fid,'SCALARS EHydro float\n');
    fprintf(fid,'LOOKUP_TABLE default\n');

        fprintf(fid,'%16.7E\n',StreList4(7,elemstart:elemend));
            
            end; end; end
        end

        fprintf(fid,'\n');
        fprintf(fid,'TENSORS EStress float\n');

        fprintf(fid,'%16.7E %16.7E 0.0000000E+000\n %16.7E %16.7E 0.0000000E+000\n 0.0000000E+000 0.0000000E+000 0.0000000E+000\n \n',StreList4([1 3 3 2],elemstart:elemend));
        
        
        elseif ndm == 1

            
        fprintf(fid,'\n');
        fprintf(fid,'SCALARS EStress float\n');
        fprintf(fid,'LOOKUP_TABLE default\n');

        fprintf(fid,'%16.7E\n',StreList4(1,:));
            
        
        end
    end

%% Colors for material flag identifier
    if mflag == 1

        fprintf(fid,'\n');
        fprintf(fid,'SCALARS Region float\n');
        fprintf(fid,'LOOKUP_TABLE default\n');

        fprintf(fid,'%16.7E\n',RegionOnElement(elemstart:elemend)');
    end

    fclose(fid);

%% Couplers
    if cflag
        
    if stepstop < 10000
        if stepi < 10
            parfilename = strcat(foldername,'/','c',filename,'000',num2str(stepp));
        elseif stepi < 100
            parfilename = strcat(foldername,'/','c',filename,'00',num2str(stepp));
        elseif stepi < 1000
            parfilename = strcat(foldername,'/','c',filename,'0',num2str(stepp));
        else
            parfilename = strcat(foldername,'/','c',filename,num2str(stepp));
        end
    end
    fid = fopen(strcat(parfilename,'.vtk'),'wt');

    fprintf(fid,'# vtk DataFile Version 1.0\n');
    fprintf(fid,'%s \n',header);
    fprintf(fid,'ASCII\n');
    fprintf(fid,'\n');

    fprintf(fid,'DATASET UNSTRUCTURED_GRID\n');
    fprintf(fid,'POINTS   %i float\n',numnpe);
%% Coordinates
    if ndm == 2
        fprintf(fid,'%16.7E %16.7E %16.7E\n',[Coordinates(nodestart:nodeend,1:2)'; zeros(1,numnpe)]);
    else
        fprintf(fid,'%16.7E %16.7E %16.7E\n',Coordinates(nodestart:nodeend,:)');
    end
%% Couplers
    fprintf(fid,'\n');
    fprintf(fid,'CELLS %1$i %2$i\n',numcoup,(nenI+1)*numcoup);

    fprintf(fid,couptext,[nenI*ones(numcoup,1) (NodesOnElement(coupstart:coupend,couporder)-(nodestart)*ones(numcoup,nenI))]');

    fprintf(fid,'\n');
    fprintf(fid,'CELL_TYPES %1$i\n',numcoup);

    fprintf(fid,'%i\n',intertype*ones(numcoup,1));

    fprintf(fid,'\n');
    fprintf(fid,'CELL_DATA   %i\n',numcoup);

%% Colors for material flag identifier
    fprintf(fid,'\n');
    fprintf(fid,'SCALARS IRegion float\n');
    fprintf(fid,'LOOKUP_TABLE default\n');

    fprintf(fid,'%16.7E\n',RegionOnElement(coupstart:coupend)');
    
%% Coupler Stresses
    if cseflag == 1
        
        if(exist('StreListE','var')==0)
            disp('warning, StreListE is not defined from analysis; zeros are used')
            StreList4 = zeros(nestr,numcoup);
        else
            StreList4 = squeeze(StreListE(1:nestr,:,stepi));
        end
        
            
        fprintf(fid,'\n');
        fprintf(fid,'SCALARS EStress float\n');
        fprintf(fid,'LOOKUP_TABLE default\n');

        fprintf(fid,'%16.7E\n',StreList4(1,:));
            
    end
        
    fclose(fid);

    end
    
end
