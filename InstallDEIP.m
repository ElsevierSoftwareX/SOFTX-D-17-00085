% Install the DEIProgram, by loading the path of the source files
% provide the specific path for the files
% Must be run prior to performing any analyses
if ispc
addpath(genpath([pwd '\source']))
elseif isunix
addpath(genpath([pwd '/source']))
end

% Turning on immediate display of fprintf statements from within scripts,
% which is off by default in Octave; see https://ubuntuforums.org/showthread.php?t=676792
if exist('OCTAVE_VERSION', 'builtin')
    page_screen_output(0);
    page_output_immediately(1);
end