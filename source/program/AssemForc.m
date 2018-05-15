% Assemble Element Force into Model Force
%
% Tim Truster
% 7/2009
% UIUC

% Assembles assuming constraints are present
% if numComp > 0
    
    [EGDOFTac, EGDOFTam, EGDOFTan] = unique(EGDOFTa,'first');
    [EGDOFTic, EGDOFTim, EGDOFTin] = unique(EGDOFTi,'first');
    lEGDOFTac = length(EGDOFTac);
    lEGDOFTic = length(EGDOFTic);
    lEGDOFTa  = length(EGDOFTa );
    lEGDOFTi  = length(EGDOFTi );

    ElemFTemp = zeros(lEGDOFTac,1);
    for i = 1:lEGDOFTa
        ElemFTemp(EGDOFTan(i)) = ElemFTemp(EGDOFTan(i)) + ElemF(ELDOFTa(i));
    end
    Fd1(EGDOFTac) = Fd1(EGDOFTac) + ElemFTemp;

    ElemFTemp = zeros(lEGDOFTic,1);
    for i = 1:lEGDOFTi
        ElemFTemp(EGDOFTin(i)) = ElemFTemp(EGDOFTin(i)) + ElemF(ELDOFTi(i));
    end
    Fd3(EGDOFTic') = Fd3(EGDOFTic') + ElemFTemp;
    
% else
%     
%     Fd1(EGDOFTa) = Fd1(EGDOFTa) + ElemF(ELDOFTa);
%     if size(ELDOFTi,2) > 0
%     Fd3(EGDOFTi) = Fd3(EGDOFTi) + ElemF(ELDOFTi);
%     end
% 
% end

% for locind1 = 1:nst
%     grow = EDOFT(locind1);
%     if grow <= neq1 && grow > 0
%         Fd1(grow) = Fd1(grow) + ElemF(locind1); %#ok<*SAGROW>
%     elseif grow <= neq && grow > 0
%         Fd2(grow) = Fd2(grow) + ElemF(locind1);
%     elseif grow > neq
%         Fd3(grow-neq) = Fd3(grow-neq) + ElemF(locind1);
%     end %if grow
% end %l1