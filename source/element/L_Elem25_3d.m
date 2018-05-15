% 03/11/2017
%
% -Penalty/spring element, to help with assigning master loads to a
% periodic unit cell

switch isw %Task Switch
    
    case 1
        
        if ndf > ndm
            
            error('ndf must equal ndm')
            
        end

    case {3,21}
        
        one = eye(ndm);
        ElemK = mateprop(1)*[one -one
                            -one  one];

        ElemF = -ElemK*reshape(ul(1:ndm,1:2),2*ndm,1);
ElemK;
        
end %Task Switch
