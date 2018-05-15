function S_u_v = LagrSurfacePoint3(P,nel,r,s,dim)

%     -------------------------------------------------------------------

%   Compute Surface Point

    if nel == 4
      shp = shlt(r,s,3,3,0,0);
    elseif nel == 8
      shp = shlq(r,s,4,4,0,0);
    elseif nel == 10
      shp = shlt(r,s,6,6,0,0);
    elseif nel == 27
      shp = shlq(r,s,9,9,0,0);
    end
    
    S_u_v = P*shp;