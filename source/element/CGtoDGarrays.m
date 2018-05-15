% 04/19/2013
% Extract Left/Right arrays from coupled array

maL = mateprop(1);
maR = mateprop(2);
nelL = mateprop(3);
nelR = mateprop(4);
nstL = nelL*ndf;
nstR = nelR*ndf;
ElemFlagL = ElemFlag(1:nelL);
ElemFlagR = ElemFlag(nelL+1:nelL+nelR);
xlL = xl(1:ndm,1:nelL);
xlR = xl(1:ndm,nelL+1:nelL+nelR);
if isw > 1
ulL = ul(1:ndf,1:nelL);
ulR = ul(1:ndf,nelL+1:nelL+nelR);
end
matepropL = MateT(maL,:);
matepropR = MateT(maR,:);