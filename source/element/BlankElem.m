% Tim Truster
% 08/25/2013
%
% Template user element routine

% Note: if the user wants to avoid the issues with using global memory
% access (i.e. scripts vs functions), it is recommended to use functions
% that are called within the script, e.g. [lie,nh1,nh3] = e11case1(input).


% % DG Data Load - converts single xl,ul arrays into a left (L) and right 
% % (R) side for separate treatment during calculations. Use only for DG
% % elements.
% if isw ~= 1
% CGtoDGarrays
% 
% inter = elem - (numel - numSI);
% 
% nelLP = nelL;
% nelRP = nelR;
% end


%% Global declarations
% Place here any commands that should be executed
% whenever the element routine is called.


%% Task Switch - Perform various element functions
switch isw 
%%    
    case 1 % Setup up elemental degrees of freedom (OPTIONAL)
        
% Purpose: Rearrange order of dofs on element and/or flag certain
%          dofs to be presecribed away
% Called by: pmatin.m
% Notes: Setting values of lie(i,1) zero for i = 1:ndf flags those
%        dofs on all nodes to be unused; global dofs will be
%        prescribed as zero if all elements connected to that node
%        have flagged that dof.
%        Individual dofs on each node are handled by slots lie(i,j)
%        for j=2:nen+1.
%        History variables are allocated using nh1 and nh3.
%        Dof reordering is handled in MatTypeTable in the input
%        file; see NL_Elem8_3d.m for an example.
%        See FEAP pmanual.pdf and pmatin.m for more details.
% Example: NL_Elem8_3d.m
        
        % Example
        if ndf > ndm
            
            for i = ndm+1:ndf
                lie(i,1) = 0;
            end
            
        end

        nh1 = 0; % number of time dependent history variables
        nh3 = 0; % number of time independent history variables
        istv = 0; % number of stresses per node for post-processing
        iste = 0; % number of stresses per element (total number, including all integration points)
        istee = 0; % number of error norm quantities

%%
    case 3 % Stiffness and internal force vector (REQUIRED)
        
% Purpose: Compute stiffness matrix and residual vector for element
% Called by: FormFE.m
% Notes: The ordering of dofs in the stiffness/force are as follows:
%        ElemF = [node1_dof1 node1_dof2 ... node1_dofndf node2_dof1 ...
%                 node2_dofndf node3_dof1 ... nodenen_dofndf]';
%        The internal force vector should be the negative of its proper
%        value, e.g. -B'*sigma, due to the definition that the
%        Residual = F_external - F_internal.
%        While nst = ndf*nen in general, typically the assembly process
%        only requires the values for i=1:ndf*nel, where nel is the number
%        of nodes on the current element.
%        For DG elements, the stiffness of the left and right sides may be
%        computed separately and then combined into the total stiffness
%        ElemK before exiting.
% Example: L_Elem3_2dVMS.m
        
        ElemK = zeros(nst);
        ElemF = zeros(nst,1);
        

%%        
    case -1 % Boundary tractions (RECOMMENDED)
        
% Purpose: Compute surface traction for an element
% Called by: ploadi.m
% Notes: The ordering of dofs in the external load vector are as follows:
%        ElemF = [node1_dof1 node1_dof2 ... node1_dofndf node2_dof1 ...
%                 node2_dofndf node3_dof1 ... nodenen_dofndf]';
%        Integration of the force can be handled in a standard fashion by
%        rotating the parameteric space of the current element to match a
%        template face over which integration is always performed.
% Example: L_Elem3_2dVMS.m
        
        ElemF = zeros(nst,1);
        
        % Reorder nodes for corresponding face of integration
        SurfOrientEtoS

        % Perform integration here
        
        % Reorder nodes back to the orientation of the element
        SurfOrientStoE
        ElemF(1:ndf*nel) = ElemF(ilist2);
        
        
%%
    case 6 % Internal force vector (RECOMMENDED)
        
% Purpose: Compute residual vector for element
% Called by: FormFE.m
% Notes: The ordering of dofs in the force are as follows:
%        ElemF = [node1_dof1 node1_dof2 ... node1_dofndf node2_dof1 ...
%                 node2_dofndf node3_dof1 ... nodenen_dofndf]';
%        The internal force vector should be the negative of its proper
%        value, e.g. -B'*sigma, due to the definition that the
%        Residual = F_external - F_internal.
%        While nst = ndf*nen in general, typically the assembly process
%        only requires the values for i=1:ndf*nel, where nel is the number
%        of nodes on the current element.
%        For DG elements, the force of the left and right sides may be
%        computed separately and then combined into the total stiffness
%        ElemF before exiting.
% Example: NL_Elem5_2dNSCST.m
        
        ElemF = zeros(nst,1); 


%%
    case 21 % Stiffness matrix (RECOMMENDED)
        
% Purpose: Compute stiffness matrix for element
% Called by: FormFE.m
% Notes: The ordering of dofs in the stiffness are as follows:
%        ElemF = [node1_dof1 node1_dof2 ... node1_dofndf node2_dof1 ...
%                 node2_dofndf node3_dof1 ... nodenen_dofndf]';
%        While nst = ndf*nen in general, typically the assembly process
%        only requires the values for i=1:ndf*nel, where nel is the number
%        of nodes on the current element.
%        For DG elements, the stiffness of the left and right sides may be
%        computed separately and then combined into the total stiffness
%        ElemK before exiting.
% Example: NL_Elem5_2dNSCST.m
        
        ElemK = zeros(nst);


%%
    case 25 % Stress projection to nodes (RECOMMENDED)
        
% Purpose: Projection/lumping of stresses from integration points to nodes
% Called by: FormS2.m
% Notes: Weighting can be accomplished either through elementarea or simply
%        the number of elements connected to a node.
%        Ordering of stresses for 2D is:
%        ElemS = [s_xx s_yy s_xy von_mises s_1 s_3 hydrostatic area]
%        Ordering of stresses for 3D is:
%        ElemS = [s_xx s_yy s_zz s_xy s_yz s_xz von_mises s_1 s_2 s_3 hydrostatic area]
%        Number of stresses set as npstr in pmatin
% Example: NL_Elem5_2dNSCST.m
        
        ElemS = zeros(nel,npstr+1);
        

%%        
    case 26 % Element Stress (OPTIONAL)
        
% Purpose: Compute element stresses, e.g. at integration points
% Called by: FormFE.m
% Notes: Number of stresses set as nestr in pmatin; should be e.g. number
%        of integration points times number of stresses per point
% Example: NL_Elem2_2dM.m
        
        ElemS = zeros(nestr,1);

end %Task Switch
