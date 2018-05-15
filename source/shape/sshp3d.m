function shp = sshp3d(r,s,t,nel)

shp = zeros(nel,1);

if nel == 1
    
    shp = 1;
    
elseif nel == 4
    
    one    = 1.0d0;

    c4 = one - r - s - t;

    shp(4) = c4; % N4=t=1-r-s-t
    shp(1) = r; % N1=r
    shp(2) = s; % N2=s
    shp(3) = t; % N3=t
   
else
    
    pt125   = 0.125d0;
    one    = 1.0d0;

    onepr = one + r;
    onemr = one - r;
    oneps = one + s;
    onems = one - s;
    onept = one + t;
    onemt = one - t;

    %different ordering due to integration scheme
    shp(1) = onemr*onems*onemt*pt125;
    shp(2) = onepr*onems*onemt*pt125;
    shp(3) = onemr*oneps*onemt*pt125;
    shp(4) = onepr*oneps*onemt*pt125;
    shp(5) = onemr*onems*onept*pt125;
    shp(6) = onepr*onems*onept*pt125;
    shp(7) = onemr*oneps*onept*pt125;
    shp(8) = onepr*oneps*onept*pt125;
    
end
    