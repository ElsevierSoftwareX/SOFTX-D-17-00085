function face = AbaqusFaces(nel,Stype,ndm)
% Tim Truster
% 09/12/2014
%
% Determine face number for NL_FEA_Program convention based on Abaqus
% surface numbering.
% All surfaces that are listed have been verified to be correctly labeled.

if ndm == 3
    switch nel
        case {4,10}
            if strcmp(Stype,' S1')
                face = 4;
            elseif strcmp(Stype,' S2')
                face = 3;
            elseif strcmp(Stype,' S3')
                face = 1;
            elseif strcmp(Stype,' S4')
                face = 2;
            end
        case {8,20}
            if strcmp(Stype,' S1')
                face = 1;
            elseif strcmp(Stype,' S2')
                face = 6;
            elseif strcmp(Stype,' S3')
                face = 3;
            elseif strcmp(Stype,' S4')
                face = 2;
            elseif strcmp(Stype,' S5')
                face = 4;
            elseif strcmp(Stype,' S6')
                face = 1;
            end
    end
elseif ndm == 2
    switch nel
        case {3,6}
            if strcmp(Stype,' S1')
                face = 1;
            elseif strcmp(Stype,' S2')
                face = 2;
            elseif strcmp(Stype,' S3')
                face = 3;
            end
        case {4,8}
            if strcmp(Stype,' S1')
                face = 1;
            elseif strcmp(Stype,' S2')
                face = 2;
            elseif strcmp(Stype,' S3')
                face = 3;
            elseif strcmp(Stype,' S4')
                face = 4;
            end
    end
end

end