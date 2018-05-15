function POUxi = POU_Coord(xc,yc,xl,parogram,nel)
% Function to evaluate POU coordinates for 2D quadrilateral element in
% terms of the physical coordinates (xc,yc). If the element is a
% parallelogram, the coordinates (xi,eta) are determined explicitly;
% otherwise, the relationship between (xc,yc) and (xi,eta) is nonlinear. 

POUxi = zeros(2,1);

if nel == 3 || nel == 6
    
%     if parogram == 1 %element is a parallelogram

        x1 = xl(1,1);
        x2 = xl(1,2);
        x3 = xl(1,3);
        y1 = xl(2,1);
        y2 = xl(2,2);
        y3 = xl(2,3);

        %Determine coords using triangular element reference coordinates
        det = (x1*y2+x3*y1-x3*y2-y1*x2-y3*x1+y3*x2);
        POUxi(1) = (-y3*x1+x1*yc+x3*y1-y1*xc-x3*yc+y3*xc)/det;
        POUxi(2) = (-x1*yc-y1*x2+x2*yc+x1*y2+y1*xc-xc*y2)/det;

%         %Convert triangle coords to quadrilateral coords
%         POUxi(1) = 2*xi - 1;
%         POUxi(2) = 2*eta - 1;

%     end
    
else %quadrilateral
    
    if parogram == 1 %element is a parallelogram

        x1 = xl(1,1);
        x2 = xl(1,2);
        x3 = xl(1,4);
        y1 = xl(2,1);
        y2 = xl(2,2);
        y3 = xl(2,4);

        %Determine coords using triangular element reference coordinates
        det = (x1*y2+x3*y1-x3*y2-y1*x2-y3*x1+y3*x2);
        xi = (-y3*x1+x1*yc+x3*y1-y1*xc-x3*yc+y3*xc)/det;
        eta = (-x1*yc-y1*x2+x2*yc+x1*y2+y1*xc-xc*y2)/det;

        %Convert triangle coords to quadrilateral coords
        POUxi(1) = 2*xi - 1;
        POUxi(2) = 2*eta - 1;
        
    else %solve nonlinear system
        
        xp = [xc; yc];
        xi = zeros(2,1);
        err = 1;
        i = 0;
        
        while abs(err) > 10^-11 && i < 20
            
            i = i + 1;
            if nel == 3 || nel == 6
                [shl,shld] = shlt(xi(1),xi(2),nel,nel,0,0);
            elseif nel == 4 || nel == 9
                [shl,shld] = shlq(xi(1),xi(2),nel,nel,0,0);
            end
            x = xl(:,1:nel)*shl(1:nel);
            xs = xl(:,1:nel)*shld(1:nel,:);
%             xs = zeros(2,2);
%             for deriv = 1:2
%                 for xyz = 1:2
%     %               xs(i,j)=0;
%                     for inode = 1:nel
%                         xs(xyz,deriv)=xs(xyz,deriv)+shld(inode,deriv)*xl(xyz,inode);
%                     end % inode
%                 end % xyz
%             end %deriv
            del_xi = xs\(xp - x);
            err = norm(del_xi,inf);
            xi = xi + del_xi;
        end
        
        POUxi = xi;

    end
    
end