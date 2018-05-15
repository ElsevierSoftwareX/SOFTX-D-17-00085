function plot2DLagransurf(P, nel, knots, numu, gridlin, facecolor)
% Tim Truster
% 11/28/2013
%
% Plot face of 2-D element

SPL2D = zeros(numu,numu,2);

%Generate list of curve points
ind = 0;
for j = 1:numu
    for i = 1:numu
        ind = ind + 1;
        r = knots(ind,1);
        s = knots(ind,2);
        SurPoint = LagrSurfacePoint(P,nel,r,s,2);
        for dir = 1:2
            SPL2D(i,j,dir) = SurPoint(dir);
        end
    end
end

%Plot the list of curve points, control points, and knots
hold on
surf(SPL2D(:,:,1),SPL2D(:,:,2),zeros(numu,numu),'EdgeColor',gridlin,'FaceColor',facecolor)
hold off