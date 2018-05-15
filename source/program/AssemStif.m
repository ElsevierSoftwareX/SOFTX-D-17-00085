% Assemble Element Stiffness into Model Stiffness
%
% Tim Truster
% 10/2009
% UIUC

% Assembles assuming constraints are present
% if numComp > 0
    
    [EGDOFTac, EGDOFTam, EGDOFTan] = unique(EGDOFTa,'first');
    [EGDOFTic, EGDOFTim, EGDOFTin] = unique(EGDOFTi,'first');
    lEGDOFTac = length(EGDOFTac);
    lEGDOFTic = length(EGDOFTic);
    lEGDOFTa  = length(EGDOFTa );
    lEGDOFTi  = length(EGDOFTi );
    
    ElemKTemp1 = zeros(lEGDOFTa ,lEGDOFTac);
    ElemKTemp2 = zeros(lEGDOFTac,lEGDOFTac);
    for i = 1:lEGDOFTa
        ElemKTemp1(:,EGDOFTan(i)) = ElemKTemp1(:,EGDOFTan(i)) + ElemK(ELDOFTa,ELDOFTa(i));
    end
    for i = 1:lEGDOFTa
        ElemKTemp2(EGDOFTan(i),:) = ElemKTemp2(EGDOFTan(i),:) + ElemKTemp1(i,:);
    end
    Kdd11(EGDOFTac,EGDOFTac) = Kdd11(EGDOFTac,EGDOFTac) + ElemKTemp2;
    
    ElemKTemp1 = zeros(lEGDOFTa ,lEGDOFTic);
    ElemKTemp2 = zeros(lEGDOFTac,lEGDOFTic);
    for i = 1:lEGDOFTi
        ElemKTemp1(:,EGDOFTin(i)) = ElemKTemp1(:,EGDOFTin(i)) + ElemK(ELDOFTa,ELDOFTi(i));
    end
    for i = 1:lEGDOFTa
        ElemKTemp2(EGDOFTan(i),:) = ElemKTemp2(EGDOFTan(i),:) + ElemKTemp1(i,:);
    end
    Kdf1(EGDOFTac,EGDOFTic) = Kdf1(EGDOFTac,EGDOFTic) + ElemKTemp2;
    
    ElemKTemp1 = zeros(lEGDOFTi ,lEGDOFTac);
    ElemKTemp2 = zeros(lEGDOFTic,lEGDOFTac);
    for i = 1:lEGDOFTa
        ElemKTemp1(:,EGDOFTan(i)) = ElemKTemp1(:,EGDOFTan(i)) + ElemK(ELDOFTi,ELDOFTa(i));
    end
    for i = 1:lEGDOFTi
        ElemKTemp2(EGDOFTin(i),:) = ElemKTemp2(EGDOFTin(i),:) + ElemKTemp1(i,:);
    end
    Kfd(EGDOFTic,EGDOFTac) = Kfd(EGDOFTic,EGDOFTac) + ElemKTemp2;
    
    ElemKTemp1 = zeros(lEGDOFTi ,lEGDOFTic);
    ElemKTemp2 = zeros(lEGDOFTic,lEGDOFTic);
    for i = 1:lEGDOFTi
        ElemKTemp1(:,EGDOFTin(i)) = ElemKTemp1(:,EGDOFTin(i)) + ElemK(ELDOFTi,ELDOFTi(i));
    end
    for i = 1:lEGDOFTi
        ElemKTemp2(EGDOFTin(i),:) = ElemKTemp2(EGDOFTin(i),:) + ElemKTemp1(i,:);
    end
    Kff(EGDOFTic,EGDOFTic) = Kff(EGDOFTic,EGDOFTic) + ElemKTemp2;
    
% else
%     
%     Kdd11(EGDOFTa,EGDOFTa) = Kdd11(EGDOFTa,EGDOFTa) + ElemK(ELDOFTa,ELDOFTa);
%     Kdf1(EGDOFTa,EGDOFTi) = Kdf1(EGDOFTa,EGDOFTi) + ElemK(ELDOFTa,ELDOFTi);
%     Kfd(EGDOFTi,EGDOFTa) = Kfd(EGDOFTi,EGDOFTa) + ElemK(ELDOFTi,ELDOFTa);
%     Kff(EGDOFTi,EGDOFTi) = Kff(EGDOFTi,EGDOFTi) + ElemK(ELDOFTi,ELDOFTi);
% 
% end
