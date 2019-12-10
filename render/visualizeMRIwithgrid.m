
clear

%% set patient properties
cfg.sub_labels = ['sub-' input('Patient number (RESPXXXX): ','s')];
cfg.ses_label = input('Session number (ses-X): ','s');
cfg.hemisphere = input('Hemisphere with implanted electrodes [l/r]: ','s');

cfg.view_atlas = 'yes';

%% set folders
cfg.home_directory = '/Fridge/chronic_ECoG/';
cfg.freesurfer_directory = sprintf('%sderivatives/freesurfer/%s/%s/',cfg.home_directory,cfg.sub_labels,cfg.ses_label);

dataBase.sub_label = cfg.sub_labels;
dataBase.ses_label = cfg.ses_label;

%%

visualizeMRI_ECoG(dataBase,cfg)