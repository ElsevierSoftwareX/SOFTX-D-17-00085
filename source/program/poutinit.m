
    % Initialize lists for processing stresses/errors
    if SHist
        StreList = zeros(npstr,numnp,1);
        % start with first step that the user desires quantities
        stepS = 1;
    end
    if SEHist
        StreListE = zeros(nestr,numel,1);
        % start with first step that the user desires quantities
        stepSE = 1;
    end
    