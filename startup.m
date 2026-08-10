function startup
%STARTUP Add HyNaPT source, workflow, example, and configuration paths.

repoRoot = fileparts(mfilename('fullpath'));
addpath(genpath(fullfile(repoRoot, 'src')));
addpath(fullfile(repoRoot, 'workflows'));
addpath(fullfile(repoRoot, 'examples'));
addpath(fullfile(repoRoot, 'config'));
end
