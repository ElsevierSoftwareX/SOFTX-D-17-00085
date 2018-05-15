% Tim Truster
% 01/04/2012
% UIUC

% Master switch routine for setting which element subroutine is called
% Called by: FormFE, assign_bc_load_dataNL, FormS

if exist('nel','var') == 0
    nel = 4;
end

% Zero-out the proper elemental assembly arrays
switch isw %Task Switch
    
    case -1 % Surface Loads
        ElemF = zeros(nst,1);
    case 1 %Get Material Properties
        
    case 3 %Get Stiffness, Force
        ElemF = zeros(nst,1);
        ElemK = zeros(nst,nst);
        ElemFn = zeros(nst,1);
    case 6 %Get Force
        ElemF = zeros(nst,1);
        ElemFn = zeros(nst,1);
    case 15 %Body forces
        ElemF = zeros(nst,1);
    case 21 %Get Stiffness
        ElemK = zeros(nst,nst);
    case 25 % Stress averaging
        ElemS = zeros(nel,npstr+1);
    case 26 % Elemental stresses
        ElemS = zeros(nel,nestr);
end

switch iel
    case 1 %Small-Deformation Isotropic Elastostatics Element
        if ndm == 3
            L_Elem1_3d 
        else %ndm == 2
            L_Elem1_2d
        end
    case 7 % bi-linear cohesive zone element
        if ndm == 2
            L_Elem7_2dDG
        else % ndm == 3
            L_Elem7_3dDG
        end
    case 8 %Small-Deformation DG element, full element sectors
        if ndm == 2
            L_Elem8_2dDG
        else %ndm == 3
            L_Elem8_3dDG
        end
    case 23 %Small-Deformation periodic boundary conditions using Lagrange multipliers
        L_Elem23_3d
    case 24 %Small-Deformation multi-point constraint using Lagrange multipliers
        L_Elem24_3d
    case 25 %Penalty element
        L_Elem25_3d
    otherwise
        error('Element type not implemented')
end
        