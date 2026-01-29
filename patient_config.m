function cfg = patient_config(name)

switch name
    case 'lhs_07'
        cfg.FileName = '...lihongsen_cut07_Gamma.mat';
        cfg.R_zone = [0.1;0.1;0.3;0.3;0.6; ... ];
        cfg.savePath = '.../lhs_07/P_all.mat';
end

cfg.winLength = 1024;
cfg.winNum = 3;
end
