% 06/30/2013
% Tim Truster

% Read major problem size parameters and solution options

numnp = ProbType(1);
numel = ProbType(2);
nummat = ProbType(3);
ndm = ProbType(4);
ndf = ProbType(5);
nen = ProbType(6);

% Set warning flag for Octave
if exist('OCTAVE_VERSION', 'builtin')
warning ('off', 'Octave:divide-by-zero');
end

if exist('OptFlag','var')
    Compt = OptFlag(1);
    IHist = OptFlag(2);
    DHist = OptFlag(3);
    VHist = OptFlag(4);
    AHist = OptFlag(5);
    FHist = OptFlag(6);
    SHist = OptFlag(7);
    if length(OptFlag)>=8
        if numel == 1
        PHist = OptFlag(8);
        else
        PHist = 0;
        end
        if length(OptFlag)>=9
            EHist = OptFlag(9);
        else
            EHist = 0;
        end
    else
        if ~exist('PHist','var')
        PHist = 0;
        end
        if ~exist('EHist','var')
        EHist = 0;
        end
    end
    if ~exist('SEHist','var')
    SEHist = 0;
    end
else % Pull options from individual flags
    if ~exist('Compt','var')
    Compt = 0;
    end
    if ~exist('IHist','var')
    IHist = 1;
    end
    if ~exist('DHist','var')
    DHist = 1;
    end
    if ~exist('VHist','var')
    VHist = 0;
    end
    if ~exist('AHist','var')
    AHist = 0;
    end
    if ~exist('FHist','var')
    FHist = 0;
    end
    if ~exist('SHist','var')
    SHist = 0;
    end
    if ~exist('PHist','var')
    PHist = 0;
    end
    if ~exist('EHist','var')
    EHist = 0;
    end
    if ~exist('SEHist','var')
    SEHist = 0;
    end
end
if ~exist('LieHist','var')
LieHist = 0;
end
if ~exist('PDHist','var')
PDHist = 0;
end

if ~exist('SSHist','var')
SSHist = 0;
end
if ~exist('JHist','var') % J-integrals
JHist = 0;
else
    if ~exist('JDImax','var')
    JDImax = 3;
    end
end
% Interface quantities
if ~exist('IFHist','var') && ~exist('numSI','var')
IFHist = 0;
elseif ~exist('numSI','var') || numSI == 0
IFHist = 0;
elseif ~exist('IFHist','var') && numSI > 0
IFHist = 0;
end
