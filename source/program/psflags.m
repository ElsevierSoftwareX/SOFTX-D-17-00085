% Tim Truster
% 12/09/2013
%
% Set values for nels, other flags
% moved from initializeFE.m so that the flags can be set in one place

ndf1 = ndf;
nneq = ndf*numnp;
iter = 0;
step = 0;
if ndm == 2
nelP3 = 3;
nelP4 = 4;
nelP6 = 6;
nelP9 = 9;
nelS3 = 3;
nelS4 = 4;
nelS6 = 3;
nelS9 = 4;
lintt3 = 3;1;
lintq4 = 4;16;
lintt6 = 7;
lintq9 = 9;25;
elseif ndm == 3
nelP3 = 4;
nelP4 = 8;
nelP6 = 10;
nelP9 = 27;
nelS3 = 4;
nelS4 = 8;
nelS6 = 4;
nelS9 = 8;
lintt3 = 13;
lintq4 = 16;
lintt6 = 13;19;
lintq9 = 25;16;
elseif ndm == 1
nelP3 = 2;
nelP4 = 3;
nelP6 = 4;
nelP9 = 5;
nelS3 = 2;
nelS4 = 3;
nelS6 = 4;
nelS9 = 5;
lintt3 = 1;
lintq4 = 2;
lintt6 = 3;
lintq9 = 4;
else
    error('ndm < 1 or ndm > 3 not supported')
end
tcont3 = 1;
tconq4 = 1;
tcont6 = 1;
tconq9 = 1;