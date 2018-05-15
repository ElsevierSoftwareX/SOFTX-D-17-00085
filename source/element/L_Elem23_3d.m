% 02/11/2017
%
% -Linear periodic boundary condition element using Lagrange multipliers
% -In isw=1 case, the element turns off all dofs that exceed ndm because
%  they are not used for pure-displacement.
%     Purpose: Nodal constraint element using Lagrange multipliers:
%              u_1 - u_2 = u_3 - u_4 for i = 1,...,ndf

switch isw %Task Switch
    
    case 1
        
        if ndf > ndm
            
            for i = ndm+1:ndf
                lie(i,1) = 0;
            end
            
        end

    case {3,21}
         
        ElemK = zeros(nst);
%         ElemF = zeros(nst,1);
        one = 1.0;

        for i = 1:ndf

          ElemK(4*ndf+i + (      i-1)*nst) = one;
          ElemK(4*ndf+i + (  ndf+i-1)*nst) = -one;
          ElemK(4*ndf+i + (2*ndf+i-1)*nst) = -one;
          ElemK(4*ndf+i + (3*ndf+i-1)*nst) = one;
          ElemK(      i + (4*ndf+i-1)*nst) = one;
          ElemK(  ndf+i + (4*ndf+i-1)*nst) = -one;
          ElemK(2*ndf+i + (4*ndf+i-1)*nst) = -one;
          ElemK(3*ndf+i + (4*ndf+i-1)*nst) = one;
% 
%           ElemF(      i) = -ul(4*ndf+i);
%           ElemF(  ndf+i) = ul(4*ndf+i);
%           ElemF(2*ndf+i) = ul(4*ndf+i);
%           ElemF(3*ndf+i) = -ul(4*ndf+i);

        end
        ElemF = -ElemK*reshape(ul,nst,1);
ElemK;
        
end %Task Switch
