
clear
close all

%% Make sure that the repositories in this section are yours/correct

addpath(genpath('/home/dorien/git_rep/BasicCode_ECoG_DvB/'))
% addpath(genpath('/home/dorien/git_rep/jsonlab/'))
% cfg.fieldtrip_folder  = '/home/dorien/git_rep/fieldtrip/';
% % copy the private folder in fieldtrip to somewhere else
% cfg.fieldtrip_private = '/home/dorien/git_rep/fieldtrip_private/'; 
%%add those later to path to avoid errors with function 'dist'
% addpath(cfg.fieldtrip_folder) 
% addpath(cfg.fieldtrip_private)
% ft_defaults


%% set patient properties
cfg.sub_labels = ['sub-' input('Patient number (RESPXXXX/REC2StimXX): ','s')];
cfg.ses_label = input('Session number (ses-X): ','s');
cfg.hemisphere = input('Hemisphere with implanted electrodes [l/r]: ','s');

cfg.view_atlas = 'yes';
% cfg.view_atlas = 'no';
cfg.v_dirs = [90,40];%[90 60];

%% set folders

if contains(cfg.sub_labels,'REC2Stim')
    cfg.home_directory = '/Fridge/REC2Stimstudy/';
elseif    contains(cfg.sub_labels,'RESP')
    cfg.home_directory = '/Fridge/chronic_ECoG/';
end
cfg.freesurfer_directory = sprintf('%sderivatives/freesurfer/%s/%s/',cfg.home_directory,cfg.sub_labels,cfg.ses_label);

dataBase.sub_label = cfg.sub_labels;
dataBase.ses_label = cfg.ses_label;

%%

visualizeMRI_ECoG(dataBase,cfg)
