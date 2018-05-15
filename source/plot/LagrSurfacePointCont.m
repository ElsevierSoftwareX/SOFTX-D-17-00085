function [S_u_v,C_u_v] = LagrSurfacePointCont(P,C,nel,r,s,dim)

%     -------------------------------------------------------------------

%   Compute Surface Point
    
%     S_u_v = zeros(dim,1);
%     C_u_v = 0;

    if nel == 3 || nel == 6
        shp = shlt(r,s,nel,nel,0,0);
    elseif nel == 4 || nel == 9
        shp = shlq(r,s,nel,nel,0,0);
    end
    
    S_u_v = P(1:nel,:)'*shp;
    C_u_v = C'*shp;
%     for dir = 1:dim
%         for l = 1:nel
%             S_u_v(dir) = S_u_v(dir) + shp(l)*P(l,dir);
%         end
%     end
%     for l = 1:nel
%         C_u_v = C_u_v + shp(l)*C(l);
%     end