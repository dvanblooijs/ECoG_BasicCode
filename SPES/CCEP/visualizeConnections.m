%% display connections

%% pre-allocation
clear
config_CCEP

%% load electrodes positions (xlsx/electrodes.tsv)
cfg.proj_dirinput = '/home/dorien/Desktop/bulk_respect/smb-share:server=arch11-smb-ds.arch11.gd.umcutrecht.nl,share=her$/snap/Respect-Leijten/Electrodes/';

subj = cfg.sub_labels{1}(5:end);

elec = readcell(fullfile(cfg.proj_dirinput,[subj,'_',cfg.ses_label,'_elektroden.xls']),'Sheet','matlabsjabloon');

% localize electrodes in grid
x = NaN(size(ccep.ch)); y = NaN(size(ccep.ch));elecmat = NaN(size(elec));topo=struct;
for i=1:size(elec,1)
    for j=1:size(elec,2)
        if ~ismissing(elec{i,j})
            letter = regexp(elec{i,j},'[a-z,A-Z]');
            number = regexp(elec{i,j},'[1-9]');
            test1 = elec{i,j}([letter,number:end]);
            test2 = [elec{i,j}(letter),'0',elec{i,j}(number:end)];
            if sum(strcmp(ccep.ch,test1))==1
                elecmat(i,j) = find(strcmp(ccep.ch,test1));
                y(strcmp(ccep.ch,test1),1) = i;
                x(strcmp(ccep.ch,test1),1)= j;
            elseif sum(strcmp(ccep.ch,test2))==1
                elecmat(i,j) = find(strcmp(ccep.ch,test2));
                y(strcmp(ccep.ch,test2),1) = i;
                x(strcmp(ccep.ch,test2),1)= j;
            else
                error('Electrode is not found')
            end
        end
    end
end

topo.x =x;
topo.y=y;

%% load 1 CCEP set

cfg.CCEPpath = '/Fridge/users/dorien/derivatives/CCEP/';

[file,path] = uigetfile(fullfile(cfg.CCEPpath,cfg.sub_labels{:}));

load(fullfile(path,file))

%% CCEP responses to specific stimulus

for stimp = 1:size(ccep.checked,2)
    stimnum = ccep.cc_stimsets(stimp,:);
    resp = ccep.checked(:,stimp);
    
    figure(1),
    % plot all electrodes
    plot(topo.x,topo.y,'ok','MarkerSize',15)
    hold on
    % plot stimulation pair in yellow
    for chan=1:2
        plot(topo.x(stimnum(chan)),topo.y(stimnum(chan)),'o','MarkerSize',15,...
            'MarkerFaceColor','y','MarkerEdgeColor','k')
    end
    
    % plot electrodes showing CCEPs in green
    chan = find(resp==1);
    plot(topo.x(chan),topo.y(chan),'o','MarkerSize',15,...
        'MarkerFaceColor','g','MarkerEdgeColor','k')
    hold off
    
    % add electrode names
    text(topo.x,topo.y,ccep.ch)
    
    ax = gca;
    xlim([min(topo.x)-2, max(topo.x)+2])
    ylim([min(topo.y)-2, max(topo.y)+2])
    title(sprintf('CCEP responses after stimulating %s-%s',ccep.ch{stimnum(1)},ccep.ch{stimnum(2)}))
    
    ax.YDir = 'reverse';
    ax.YTick = [];
    ax.XTick = [];
    ax.XColor = 'none';
    ax.YColor = 'none';
    ax.Units = 'normalized';
    ax.Position = [0.1 0.1 0.8 0.8];
    outlabel=sprintf('Stimpair%s-%s.jpg',...
        ccep.ch{stimnum(1)},ccep.ch{stimnum(2)});
    
    if ~exist([path,'figures/'], 'dir')
        mkdir([path,'figures/']);
    end
    
    saveas(gcf,[path,'figures/',outlabel],'jpg')
    
end