% Tim Truster
% 06/01/2014
% Assemble element stresses
    
for stres = 1:nestr

    StreList2(elem, stres) = ElemS(stres); %#ok<SAGROW>

end