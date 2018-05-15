function [S_u_v,C_u_v] = LagrSurfacePointCont3(P,C,nel,r,s,dim)

%     -------------------------------------------------------------------

%   Compute Surface Point
    
    S_u_v = zeros(dim,1);
    C_u_v = 0;

    if nel == 4
      shp = shlt(r,s,3,3,0,0);
    elseif nel == 8
      shp = shlq(r,s,4,4,0,0);
    elseif nel == 10
      shp = shlt(r,s,6,6,0,0);
    elseif nel == 27
      shp = shlq(r,s,9,9,0,0);
    end
    if nel == 10 && sum(C(4:6)) == 0
      shp2 = shlt(r,s,3,6,0,0);
    elseif nel == 27 && sum(C(5:9)) == 0
      shp2 = shlq(r,s,4,9,0,0);
    else
      shp2 = shp;
    end
    
%     for dir = 1:dim
%         for l = 1:nel
%             S_u_v(dir) = S_u_v(dir) + shp(l)*P(l,dir);
%         end
%     end
    S_u_v = P*shp;
%     for l = 1:nel
%         C_u_v = C_u_v + shp2(l)*C(l);
%     end
    C_u_v = C*shp2;