% 02/11/2017
%
% -Linear MPC element using Lagrange multipliers
% -In isw=1 case, the element turns off all dofs that exceed ndm because
%  they are not used for pure-displacement.
%     Purpose: Nodal constraint element using Lagrange multipliers:
%              u_1 - u_2 - a*u_3 - b*u_4 - c*u_5 = 0 for i = 1,...,ndf
% Assumes MPC elements are last in the mesh, and numMPC says how many there
% are.

switch isw %Task Switch
    
    case 1
        
        if ndf > ndm
            
            for i = ndm+1:ndf
                lie(i,1) = 0;
            end
            
        end

    case {3,21}
         
        pbcID = elem - (numel-numMPC);
        Coeffs = sign(MPCList(pbcID,3:2+ndm)); %only care about direction, not magnitude
        ElemK = zeros(nst);
%         ElemF = zeros(nst,1);
        one = 1.0;

        if ndm == 3
        for i = 1:ndf

          ElemK(5*ndf+i + (      i-1)*nst) = one;
          ElemK(5*ndf+i + (  ndf+i-1)*nst) = -one;
          ElemK(5*ndf+i + (2*ndf+i-1)*nst) = -one*Coeffs(1);
          ElemK(5*ndf+i + (3*ndf+i-1)*nst) = -one*Coeffs(2);
          ElemK(5*ndf+i + (4*ndf+i-1)*nst) = -one*Coeffs(3);
          ElemK(      i + (5*ndf+i-1)*nst) = one;
          ElemK(  ndf+i + (5*ndf+i-1)*nst) = -one;
          ElemK(2*ndf+i + (5*ndf+i-1)*nst) = -one*Coeffs(1);
          ElemK(3*ndf+i + (5*ndf+i-1)*nst) = -one*Coeffs(2);
          ElemK(4*ndf+i + (5*ndf+i-1)*nst) = -one*Coeffs(3);
% 
%           ElemF(      i) = -ul(4*ndf+i);
%           ElemF(  ndf+i) = ul(4*ndf+i);
%           ElemF(2*ndf+i) = ul(4*ndf+i);
%           ElemF(3*ndf+i) = ul(4*ndf+i);

        end
        else
        for i = 1:ndf

          ElemK(4*ndf+i + (      i-1)*nst) = one;
          ElemK(4*ndf+i + (  ndf+i-1)*nst) = -one;
          ElemK(4*ndf+i + (2*ndf+i-1)*nst) = -one*Coeffs(1);
          ElemK(4*ndf+i + (3*ndf+i-1)*nst) = -one*Coeffs(2);
          ElemK(      i + (4*ndf+i-1)*nst) = one;
          ElemK(  ndf+i + (4*ndf+i-1)*nst) = -one;
          ElemK(2*ndf+i + (4*ndf+i-1)*nst) = -one*Coeffs(1);
          ElemK(3*ndf+i + (4*ndf+i-1)*nst) = -one*Coeffs(2);
% 
%           ElemF(      i) = -ul(4*ndf+i);
%           ElemF(  ndf+i) = ul(4*ndf+i);
%           ElemF(2*ndf+i) = ul(4*ndf+i);
%           ElemF(3*ndf+i) = ul(4*ndf+i);

        end
        end
        ElemF = -ElemK*reshape(ul,nst,1);
ElemK;
        
end %Task Switch
