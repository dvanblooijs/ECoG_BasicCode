%% pipeline_TFSPES

% author: Dorien van Blooijs
% date: Sept 2019

%% pre-allocation

config_TFSPES

%% load data

dataBase = load_ECoGdata(cfg);

%% preprocess ccep

dataBase = preprocess_ECoG_spes(dataBase,cfg);

%% make TF-SPES Event-Related - Stimulus - Perturbations

cfg.saveERSP = 'yes';

dataBase = makeTFSPES(dataBase,cfg);

%% visual check of TFSPES plots

if ~any(contains(fieldnames(dataBase),'ERSP'))
    dataBase.ERSP = load(fullfile(cfg.output,cfg.sub_label,cfg.ses_label,cfg.run_label,...
        [cfg.sub_label,'_',cfg.ses_label,'_',cfg.task_label,'_', cfg.run_label,'_ERSP.mat']));
end

stimps = 1:size(dataBase(1).cc_epoch_sorted,3);
chans = 1:size(dataBase(1).cc_epoch_sorted,1); %dataBase(1).soz;

dataBase = visualRating_tfspes(dataBase,stimps, chans);
checked = dataBase(1).ERSP.checked;

output = fullfile(cfg.TFSPESpath,dataBase(1).sub_label,dataBase(1).ses_label,dataBase(1).run_label);

filename = ['/' dataBase(1).sub_label,'_' dataBase(1).ses_label,...
                        '_', dataBase(1).task_label,'_',dataBase(1).run_label '_ERSP.mat'];     
                    
save([output,filename],'checked','-append')

