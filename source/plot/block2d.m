function [x,ix,RonE,numnp,numel] = block2d(type,rinc,sinc,node1,elmt1,mat,rskip,btype,xl,nen,x,ix,RonE,x0)

% Block routine to emulate behavior of FEAP meshing routine
% Handles 2D of T3, Q4, T6, and Q9 elements

% NOTE: for polar coordinate entry, x0 is the coordinates of the axis of
% revolution (i.e. the center of the coordinate system). You may input x
% and ix as 0,0 to act as placeholders.

% if strcmp(type,'cart') == 1

    if nargin < 10 || nargin == 11
        error('At least 10 arguments are required')
    elseif nargin == 10
        x = zeros(0,0);
        ix = zeros(0,0);
        x0 = zeros(2,1);
    elseif nargin == 13
        ix = [ix; RonE'];
        %x znd ix are given
        x0 = zeros(2,1);
    end
    
    xll = zeros(2,9);
    ixl = zeros(9,1);
    for i = 1:length(xl)
        ind = xl(i,1);
        ixl(ind) = ind;
        xll(1,ind) = xl(i,2);
        xll(2,ind) = xl(i,3);
    end
    nr = rinc;
    ns = sinc;

    ni = node1;
    ne = elmt1;
    ma = mat;
    nodinc = rskip;
    ntyp = btype;
    ndm = 2;
    nm = 9;
    nen1 = nen+1;

    dr = 2/nr;
    ds = 2/ns;

    nr = nr + 1;
    ns = ns + 1;

    x = sblkn(nr,ns,xll,ixl,dr,ds,ni,ndm,nodinc,nm,x,type,x0);
    numnp = length(x);
    [ix,numel] = sblke6(nr,ns,ni,ne,ndm,nen1,nodinc,ntyp,nm,ma,ix);
    RonE = ix(nen1,:)';
    ix = ix(1:nen1-1,:);
end