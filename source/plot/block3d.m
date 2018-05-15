function [x,ix,RonE,numnp,numel] = block3d(type,rinc,sinc,tinc,node1,elmt1,mat,btype,xl,nen,x,ix,RonE,x0)

% NOTE: for cylindrical/spherical coordinate entry, x0 is the coordinates of the axis of
% revolution (i.e. the center of the coordinate system). You may input x
% and ix as 0,0 to act as placeholders.

% if strcmp(type,'cart') == 1

    if nargin < 10 || nargin == 11
        error('At least 10 arguments are required')
    elseif nargin == 10
        x = zeros(0,0);
        ix = zeros(0,0);
        x0 = zeros(3,1);
    elseif nargin == 13
        ix = [ix; RonE'];
        %x znd ix are given
        x0 = zeros(3,1);
    end
    
    xll = zeros(2,27);
    ixl = zeros(27,1);
    for i = 1:length(xl)
        ind = xl(i,1);
        ixl(ind) = ind;
        xll(1,ind) = xl(i,2);
        xll(2,ind) = xl(i,3);
        xll(3,ind) = xl(i,4);
    end
    nr = rinc;
    ns = sinc;
    nt = tinc;

    ni = node1;
    ne = elmt1;
    ma = mat;
    ntyp = btype;
    ndm = 3;
    nen1 = nen+1;

    dr = 2/nr;
    ds = 2/ns;
    dt = 2/nt;
    
    if(ntyp==10)     % Linear    hexahedron
      nf = ne + nr*ns*nt - 1;
    elseif(ntyp==11) % Linear    tetrahedron
      nf = ne + 6*nr*ns*nt - 1;
    elseif(ntyp==12) % Quadratic hexahedron
      nf = ne + (nr*ns*nt)/8 - 1;
    elseif(ntyp==13) % Quadratic tetrahedron
      nf = ne + 6*(nr*ns*nt)/8 - 1;
    end
    numel = nf;
    nr = nr + 1;
    ns = ns + 1;
    nt = nt + 1;
    ng = nr*ns*nt + ni -1;
    numnp = ng;

% c       Compute node locations

        x = vblkn(nr,ns,nt,xll,x,ixl,dr,ds,dt,ni,ndm,type,numnp,x0);

% c       Compute element connections

        if(ne>0)
          ix = vblke(nr,ns,nt,ix,ni,ne,nen1,ma,ntyp,numel);
        end

    RonE = ix(nen1,:)';
    ix = ix(1:nen1-1,:);
    
% end