% Assemble Element Force into Model Force, prescribed loads
%
% Tim Truster
% 4/30/2013
% UIUC

% Assembles assuming constraints are present
if numComp > 0
    
    [EGDOFTac, EGDOFTam, EGDOFTan] = unique(EGDOFTa,'first');
    lEGDOFTac = length(EGDOFTac);
    lEGDOFTa  = length(EGDOFTa );

    ElemFTemp = zeros(lEGDOFTac,1);
    for i = 1:lEGDOFTa
        ElemFTemp(EGDOFTan(i)) = ElemFTemp(EGDOFTan(i)) + ElemF(ELDOFTa(i));
    end
    Fc1(EGDOFTac) = Fc1(EGDOFTac) + ElemFTemp;
    
else
    
    Fc1(EGDOFTa) = Fc1(EGDOFTa) + ElemF(ELDOFTa);

end

% locind1 = 0;
% for ie1 = 1:nel
%     for l1 = 1:ndf
%         locind1 = locind1 + 1;
%         grow = EDOFT(locind1);
%         if grow > 0
%         if grow <= neq1
%             Fc1(grow) = Fc1(grow) + ElemF(locind1); %#ok<AGROW>
%         elseif grow <= neq
%             grow = grow - neq1;
%             Fc2(grow) = Fc2(grow) + ElemF(locind1); %#ok<AGROW>
%         end
%         end
%     end 
% end %ie1