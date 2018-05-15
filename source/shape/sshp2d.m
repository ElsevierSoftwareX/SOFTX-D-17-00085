function shp = sshp2d(r,s,nel)

shp = zeros(nel,1);

if nel == 1
    
    shp = 1;
    
elseif nel == 3
    
    one    = 1.0d0;

    c3 = one - r - s;

    shp(1) = c3; % N1=t=1-r-s
    shp(2) = r; % N2=r
    shp(3) = s; % N3=s
   
elseif nel == 4
    
    pt25   = 0.25d0;
    one    = 1.0d0;

    onepr = one + r;
    onemr = one - r;
    oneps = one + s;
    onems = one - s;

    shp(1) = onemr*onems*pt25;
    shp(2) = onepr*onems*pt25;
    shp(3) = onepr*oneps*pt25;
    shp(4) = onemr*oneps*pt25;
    
elseif nel == 9
    pt25   = 0.25d0;
    pt5 = 0.5d0;
    one    = 1.0d0;
onepr = one + r;
onemr = one - r;
oneps = one + s;
onems = one - s;
% c
shl = zeros(9,1);
shl(1,1) = onemr*onems*pt25;
% c
shl(2,1) = onepr*onems*pt25;
% c
shl(3,1) = onepr*oneps*pt25;
% c
shl(4,1) = onemr*oneps*pt25;
% c
  onemrsq = one - r*r;
  onemssq = one - s*s;
% c
  shl(5,1) = onemrsq*onems*pt5;
% c
  shl(6,1) = onemssq*onepr*pt5;
% c
  shl(7,1) = onemrsq*oneps*pt5;
% c
  shl(8,1) = onemssq*onemr*pt5;
% c
% c       interior node (lagrangian)
% c       --------------------------
  shl(9,1) = onemrsq*onemssq;
% c
% c       correct midside nodes for interior node (lagrangian)
% c       ----------------------------------------------------
  shl(5:8,1)=shl(5:8,1)-pt5*ones(4,1)*shl(9,1);
% c
% c       correct corner nodes
% c       --------------------
    shl(1,1) = shl(1,1) - pt5*(shl(5,1)+shl(8,1)) - pt25*shl(9,1);
    shl(2,1) = shl(2,1) - pt5*(shl(6,1)+shl(5,1)) - pt25*shl(9,1);
    shl(3,1) = shl(3,1) - pt5*(shl(7,1)+shl(6,1)) - pt25*shl(9,1);
    shl(4,1) = shl(4,1) - pt5*(shl(8,1)+shl(7,1)) - pt25*shl(9,1);
    % Reorder for integration point (tensor-product) ordering
    shp = shl;%([1 5 2 8 9 6 4 7 3]);
end
    