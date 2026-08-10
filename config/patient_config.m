function cfg = patient_config(dataFile, zonePrior, outputDirectory)
%PATIENT_CONFIG Create a path-independent patient analysis configuration.
% Do not commit identifiable patient paths or raw clinical data.

arguments
    dataFile (1,:) char
    zonePrior double
    outputDirectory (1,:) char = fullfile(pwd, 'results')
end

cfg.dataFile = dataFile;
cfg.zonePrior = zonePrior(:);
cfg.outputDirectory = outputDirectory;
cfg.sampleRate = 1024;
cfg.windowSeconds = 3;
cfg.stepSeconds = 1;
end
