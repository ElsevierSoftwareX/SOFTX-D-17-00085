function helem = plot3DLagransurfcontI(P, Cont, nel, knots, numu, gridlin, ID, elem, helem)
%(P, Cont, unum, vnum, numelU, numelV, pU, pV, numu, numv, Ulist, Vlist, gridlin, ID)
% plot3DNURBSsurf(Pw, U, V, nU, nV, pU, pV, numu, numv, facecol, gridlin)
%
% Tim Truster
% CEE Graduate Student
% UIUC
% 06/22/2009
%
%

SPL2D = zeros(numu,numu,2);
CPL2D = zeros(numu,numu);

%Generate list of curve points
ind = 0;
for j = 1:numu
    for i = 1:numu
        ind = ind + 1;
        r = knots(ind,1);
        s = knots(ind,2);
        CPL2D(i,j) = Cont;
        SurPoint = LagrSurfacePointCont3(P,P,nel,r,s,3);
        for dir = 1:3
            SPL2D(i,j,dir) = SurPoint(dir);
        end
    end
end

%Plot the list of curve points, control points, and knots
hold on
surf(SPL2D(:,:,1),SPL2D(:,:,2),SPL2D(:,:,3),CPL2D,'EdgeColor',gridlin)
uinc = round((numu-1)/2)+1;
vinc = round((numu-1)/2)+1;
if ID > 0
helem(elem) = text(SPL2D(uinc,vinc,1),SPL2D(uinc,vinc,2),SPL2D(uinc,vinc,3),num2str(ID),'HorizontalAlignment','center');
end
hold off