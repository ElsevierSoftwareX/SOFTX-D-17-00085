function helem = plot3DLagransurf(P, nel, knots, numu, gridlin, ID, facecolor, elem, helem)
% Tim Truster
% 11/28/2013
%
% Plot face of 3-D element

SPL2D = zeros(numu,numu,2);

%Generate list of curve points
ind = 0;
for j = 1:numu
    for i = 1:numu
        ind = ind + 1;
        r = knots(ind,1);
        s = knots(ind,2);
        SurPoint = LagrSurfacePoint3(P,nel,r,s,3);
        for dir = 1:3
            SPL2D(i,j,dir) = SurPoint(dir);
        end
    end
end

%Plot the list of curve points, control points, and knots
hold on
surf(SPL2D(:,:,1),SPL2D(:,:,2),SPL2D(:,:,3),'EdgeColor',gridlin,'FaceColor',facecolor)
uinc = round((numu-1)/2)+1;
vinc = round((numu-1)/2)+1;
if ID > 0
helem(elem) = text(SPL2D(uinc,vinc,1),SPL2D(uinc,vinc,2),SPL2D(uinc,vinc,3),num2str(ID),'HorizontalAlignment','center');
end
hold off