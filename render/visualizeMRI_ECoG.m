%% visualisation of specific electrodes

function visualizeMRI_ECoG(dataBase,cfg)

addpath('git_rep/ecogBasicCode/render/')
top_path = '/Fridge/users/jaap/ccep/dataBIDS/';

% pick a viewing angle:
v_dirs = [90 0; 270 30]; %[90 0;90 -60;270 -60;0 0;270 0; 270 60]; %zij, onder, .., voor, zij, zijboven

% gifti file name:
dataGiiName = fullfile(top_path,'derivatives','surfaces',dataBase(1).sub_label,...
    [dataBase(1).sub_label '_T1w_pial.' cfg(1).hemi_cap '.surf.gii']);
% load gifti:
g = gifti(dataGiiName);

% electrode locations name:
dataLocName = dir(fullfile(top_path,dataBase(1).sub_label,dataBase(1).ses_label,'ieeg',...
    [dataBase(1).sub_label,'_',dataBase(1).ses_label '_electrodes.tsv']));
dataLocName = fullfile(dataLocName(1).folder,dataLocName(1).name);

% load electrode locations
tb_electrodes = readtable(dataLocName,'FileType','text','Delimiter','\t','TreatAsEmpty','n/a');
log_elec_incl = ~strcmp(tb_electrodes.group,'other');
tb_electrodes = tb_electrodes(log_elec_incl,:);
elecmatrix = [tb_electrodes.x tb_electrodes.y tb_electrodes.z];

% elecmatrix = [dataBase(1).tb_electrodes.x dataBase(1).tb_electrodes.y dataBase(1).tb_electrodes.z];

%% figure with rendering for different viewing angles
for k = 1:size(v_dirs,1) % loop across viewing angles
    v_d = v_dirs(k,:);
    
    figure('units','normalized','position',[0.01 0.01 0.9 0.9],'color',[1 1 1]);
    
    subplot('position', [0.05 0.25 0.9 0.7])
    
    ecog_RenderGifti(g) % render
    ecog_ViewLight(v_d(1),v_d(2)) % change viewing angle
    
    % make sure electrodes pop out
    a_offset = .1*max(abs(elecmatrix(:,1)))*[cosd(v_d(1)-90)*cosd(v_d(2)) sind(v_d(1)-90)*cosd(v_d(2)) sind(v_d(2))];
    els = elecmatrix+repmat(a_offset,size(elecmatrix,1),1);
    
    % add electrode numbers TODO: use name of electrode instead of number
    if strcmp(cfg.show_labels,'yes')
        ecog_Label(els,tb_electrodes.name,30,12) % [electrodes, MarkerSize, FontSize]
    end
    
    % add all electrodes with black dots
    ccep_el_add(els,[0.1 0.1 0.1],20) % [electrodes, MarkerColor, MarkerSize]
    
    if strcmp(cfg(1).change_color,'yes') && strcmp(cfg(1).change_size,'yes')
        ccep_el_add_size_and_color(dataBase,els,cfg)
    elseif strcmp(cfg(1).change_color,'yes') && strcmp(cfg(1).change_size,'no')
        ccep_el_add_color(dataBase,els,cfg)
    elseif strcmp(cfg(1).change_color,'no') && strcmp(cfg(1).change_size,'yes')
        ccep_el_add_size(dataBase,els,cfg)
    end
    
    set(gcf,'PaperPositionMode','auto')
    % print('-dpng','-r300',fullfile(dataRootPath,'derivatives','render',...
    % ['subj_' subj '_v' int2str(v_d(1)) '_' int2str(v_d(2))]))
    
    % close all
end
end