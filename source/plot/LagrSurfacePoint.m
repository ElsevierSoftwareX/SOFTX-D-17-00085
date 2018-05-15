function [S_u_v,C_u_v] = LagrSurfacePoint(P,nel,r,s,dim)

%     -------------------------------------------------------------------

%   Compute Surface Point
    
%     S_u_v = zeros(dim,1);

    if nel == 3 || nel == 6
        shp = shlt(r,s,nel,nel,0,0);
    elseif nel == 4 || nel == 9
        shp = shlq(r,s,nel,nel,0,0);
    end
    
    S_u_v = P(1:nel,:)'*shp;