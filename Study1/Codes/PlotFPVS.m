clc;clear all;
cfg = [];
participantnumber = 8;

if ~isfield(cfg, 'foi'),              cfg.foi            = [0.3 30];     end; foi           = cfg.foi;
if ~isfield(cfg, 'basetype'),         cfg.basetype       = 'HA';         end; basetype      = cfg.basetype;
if ~isfield(cfg, 'oddtype'),          cfg.oddtype        = 'FE';         end; oddtype       = cfg.oddtype;
if ~isfield(cfg, 'icapruning'),       cfg.icapruning     = 0;            end; icapruning    = cfg.icapruning;
if ~isfield(cfg, 'metrics'),          cfg.metrics        = 'snr';    end; metrics       = cfg.metrics;
if ~isfield(cfg, 'sex');              cfg.sex            = 'both';       end; sex           = cfg.sex;
if ~isfield(cfg, 'targetoddbins')     cfg.targetoddbins  = [1.2 2.4 3.6 4.8 7.2];end; targetoddbins = cfg.targetoddbins;
if ~isfield(cfg, 'targetbsbins')      cfg.targetbsbins   = [6 12 18 24];    end; targetbsbins  = cfg.targetbsbins;
if ~isfield(cfg, 'seglength')         cfg.seglength   = 10;    end; seglength  = cfg.seglength;
global EEG_FT
%%
% Please run the following codes to lunch eeglab and fieldtrip's default paths at the first time you run this program:
% eeglab;close; ft_defaults;

%% load ssvep data;
folderBase          = 'Yourpath';
SegmentAverageFiles = fullfile(folderBase,'preprocessing',filesep);
filename = ['Expt 6 Participantnumber ' num2str(participantnumber) ' SSVEP_' 'BS_' basetype '_ODD_' oddtype '_emotion_' 'ica' num2str(icapruning) '.mat'];
if ~exist([SegmentAverageFiles filename])
    filename = ['Expt 6 Participantnumber ' num2str(participantnumber) ' SSVEP_' 'BS_' oddtype '_ODD_' basetype '_emotion_' 'ica' num2str(icapruning) '.mat'];
end
disp(filename);
load([SegmentAverageFiles filename],'EEG_FT');
%For each subject's base response for each trial, we set up a mat file. If
%the subject's base response on a trial is less than 3.09, it is
%eliminated.
% position = find(Info.participantnumber == participantnumber);
% participantnumbers = Info.participantnumber;
% load([SegmentAverageFiles filename],'EEG_FT');
% if length(EEG_FT.trialinfo.bepoch)>1
%     if Info.z_score_all(position,1) > 3.09 & Info.z_score_all(position,2) > 3.09
%         EEG_FT.trial = EEG_FT.trial;
%         EEG_FT.time = EEG_FT.time;
%         EEG_FT.trialinfo =  EEG_FT.trialinfo;
%     end
%     if Info.z_score_all(position,1) > 3.09 & Info.z_score_all(position,2) < 3.09
%         EEG_FT.trial = EEG_FT.trial(:,1);
%         EEG_FT.time = EEG_FT.time(:,1);
%         EEG_FT.trialinfo =  EEG_FT.trialinfo(:,1);
%     end
%     if Info.z_score_all(position,1) < 3.09 & Info.z_score_all(position,2) > 3.09
%         EEG_FT.trial = EEG_FT.trial(:,2);
%         EEG_FT.time = EEG_FT.time(:,2);
%         EEG_FT.trialinfo =  EEG_FT.trialinfo(:,2);
%     end
% else
%     if Info.z_score_all(position,1) > 3.09
%         EEG_FT.trial = EEG_FT.trial;
%         EEG_FT.time = EEG_FT.time;
%         EEG_FT.trialinfo =  EEG_FT.trialinfo;
%     end
%     %             if Info.z_score_all(position,1) < 3.09
%     %                 break
%     %             end
% end
%         EEG_FT_backup = EEG_FT;
% ntrial = length(EEG_FT.trial);

%     switch sex
%         case 'both'
%         otherwise
%             trials2select = find(EEG_FT.trialinfo.sexinfo == sex);
%             cfg                = [];
%             cfg.trials         = trials2select;
%             EEG_FT             = ft_selectdata(cfg,EEG_FT);
%     end
%% Power analyses ;
if seglength ~= 30
    cfg         = [];
    cfg.trials  = 'all';
    cfg.length  = seglength; % 10s is divided into a segment
    cfg.overlap = 0.5; % Value of overlap(0,1). For example, 0.5 indicates the overlap of 0.5 times of cut-off time (4s*0.5 = 2s)
    EEG_FT_seg  = ft_redefinetrial(cfg,EEG_FT);
    EEG_FT_seg.time(1,:) = EEG_FT_seg.time(1,1);
else
    EEG_FT_seg = EEG_FT;
end
%  EEG_FT.time = EEG_FT.time(1:5000); % time should be from 0 to 10s

%This part of the procedure is used to take only the 20s of each trial data
%for children aged 7-10 years.
% % 7~10 use only 20s
% if length(EEG_FT_seg.trial) > 6
%     EEG_FT_seg.trial = EEG_FT_seg.trial([1:3,6:8]);
%     EEG_FT_seg.time = EEG_FT_seg.time([1:3,6:8]);
%     EEG_FT_seg.trialinfo = EEG_FT_seg.trialinfo([1:3,6:8],:);
%     EEG_FT_seg.sampleinfo = EEG_FT_seg.sampleinfo([1:3,6:8],:);
% elseif length(EEG_FT_seg.trial) == 5
%     EEG_FT_seg.trial = EEG_FT_seg.trial(1:3);
%     EEG_FT_seg.time = EEG_FT_seg.time(1:3);
%     %     EEG_FT_seg.trialinfo = EEG_FT_seg.trialinfo(1:3,:);
%     EEG_FT_seg.sampleinfo = EEG_FT_seg.sampleinfo(1:3,:);
% elseif length(EEG_FT_seg.trial) == 6
%     EEG_FT_seg.trial = EEG_FT_seg.trial;
%     EEG_FT_seg.time = EEG_FT_seg.time;
%     EEG_FT_seg.trialinfo = EEG_FT_seg.trialinfo;
%     EEG_FT_seg.sampleinfo = EEG_FT_seg.sampleinfo;
% elseif length(EEG_FT_seg.trial) == 3
%     EEG_FT_seg.trial = EEG_FT_seg.trial;
%     EEG_FT_seg.time = EEG_FT_seg.time;
% %     EEG_FT_seg.trialinfo = EEG_FT_seg.trialinfo;
%     EEG_FT_seg.sampleinfo = EEG_FT_seg.sampleinfo;
% end

% EEG_FT_seg = EEG_FT;
% foi: Frequency of interest;
bpfreq = foi;
% average the trials
cfg    = [];
%cfg.trials = find(EEG_FT.trialinfo.bepoch == 3);
cfg.keeptrials = 'no';
EEG_FT_seg = ft_timelockanalysis(cfg,EEG_FT_seg);
% freq analysis
cfg           = [];
cfg.method    = 'mtmfft';
cfg.taper     = 'hanning';
% cfg.taper = 'dpss';
% cfg.tapsmofrq = [0.1];
% cfg.pad       = 'nextpow2';
cfg.output    = 'pow';
cfg.foilim    = bpfreq;


EEG_freq = ft_freqanalysis(cfg, EEG_FT_seg);

powspctrm     = EEG_freq.powspctrm;

% calculate the signal to noise ration (SNR) & Baseline correction % z-score;
nfreqbins     = size(powspctrm,2);
powspctrm_snr = zeros(size(powspctrm));
powspctrm_blc = powspctrm_snr;
powspctrm_z   = powspctrm_snr;

switch seglength
    case 30
        nadjbins_oneside = 12;
    case 20
        nadjbins_oneside = 10;
    case 10
        nadjbins_oneside = 8;
end

for i = 1:nfreqbins
    if i < nadjbins_oneside+1 || i > nfreqbins-nadjbins_oneside
    else
        adjbins_pow_raw        = [powspctrm(:,i-nadjbins_oneside:i-2), powspctrm(:,i+2:i+nadjbins_oneside)];
        adjbins_pow = zeros(size(adjbins_pow_raw,1),size(adjbins_pow_raw,2)-2);
        for j = 1:size(adjbins_pow,1)
            adjbins_pow_row  = adjbins_pow_raw(j,:);
            [maxpow,maxbins] = max(adjbins_pow_row);
            [minpow,minbins] = min(adjbins_pow_row);
            adjbins_pow_row([maxbins,minbins]) = [];
            adjbins_pow(j,:) = adjbins_pow_row;
        end
        adjbins_pow        = mean(adjbins_pow,2);
        powspctrm_blc(:,i) = powspctrm(:,i) - adjbins_pow;
        powspctrm_snr(:,i) = powspctrm(:,i) ./ adjbins_pow;
   
        allbins = [powspctrm_blc(:,i-(nadjbins_oneside-1):i-2), powspctrm_blc(:,i+2:i+(nadjbins_oneside-1))];
        avgbins = mean(allbins,2);
        stdbins = std(allbins')';
        powspctrm_z(:,i)   =  (powspctrm_blc(:,i) - avgbins)./stdbins;
    end
end
clear i

% plot
switch metrics
    case 'rawpow'
    case 'logpow'
        powmatrix = 10*log(powspctrm);
        ylims     = [-65 20];
        threshold = 3;
    case 'snr'
        powmatrix = powspctrm_snr;
        ylims     = [-0.5 10];
        threshold = 3;
    case 'blc'
        powmatrix = powspctrm_blc;
        ylims     = [-0.1 0.5];
        threshold = 3;
    case 'z-score'
        powmatrix = powspctrm_z;
        % z-scores(one-tail z-score) and p-values
        % 1.96(1.64)                     0.05
        % 2.58(2.33)                     0.01
        % 3.29(3.09)                     0.001
        % 3.89(3.72)                     0.0001
        ylims     = [0 10];
        if exist('powspctrm_all','var')
            threshold = 1.64;
        else
            threshold = 2.33;
        end
    otherwise
        powmatrix = powspctrm_snr;
end

% load(fullfile(folderBase,'Materials','hgsn2clusters.mat'),'hgsn2clusters');
load(fullfile(folderBase,'Materials for submission','hgsn2clusters_ROI.mat'),'hgsn2clusters');

figure
for i = 1:3
    switch i
        case 1
            chidx = hgsn2clusters.right_to;
            subplot_title = 'SSVEP in the right temporal-occipital region';
        case 2
            chidx = hgsn2clusters.middle_occipital;
            subplot_title = 'SSVEP in the middle occipital region';
        case 3
            chidx = hgsn2clusters.left_to;
            subplot_title = 'SSVEP in the left temporal-occipital region';
    end
% 
    chpow = mean(powmatrix(chidx,:),1);                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             freqbins      = EEG_freq.freq;
    subplot(2,3,i);plot(chpow);title(subplot_title);
    xline(find(freqbins == 1.2),'-.',{'1.2Hz'});
    xline(find(freqbins == 2.4),'-.',{'2.4Hz'});
    xline(find(freqbins == 3.6),'-.',{'3.6Hz'});
    xline(find(freqbins == 4.8),'-.',{'4.8Hz'});
    xline(find(freqbins == 7.2),'-.',{'7.2Hz'});
    xline(find(freqbins == 6),'-.',{'6Hz'});
    ylim (ylims);
    freq_ticks      = [];
    label_ticks     = [];
    freq_bins       = [foi(1) 6 12 18 24 30];
    for j = 1:length(freq_bins);
        freq_ticks(j)  = find([freqbins == freq_bins(j)]);
        label_ticks{j} = [num2str(freq_bins(j)) 'Hz'];
    end
    xticks(freq_ticks);
    xticklabels(label_ticks);
    ax = gca;
    % Set x and y font sizes.
    ax.XAxis.FontSize = 15;
    ax.YAxis.FontSize = 15;
end
% % filename = ['Expt 6 Participantnumber ' num2str(participantnumber) ' SSVEP_' 'BS_' basetype '_ODD_' oddtype '_emotion_' 'ica' num2str(icapruning) '.jpg'];
% %  saveas(gcf,filename,'jpg')
% % end
% topomap
% load eeglab channel structure
load(fullfile(folderBase,'Materials','hgsn128chanlocs.mat'),'chanlocs');
if participantnumber > 900
    oddfreqbins  = ismember(freqbins,targetoddbins);
else
    oddfreqbins  = ismember(freqbins,targetoddbins);
end
bsfreqbins   = ismember(freqbins,targetbsbins);

oddactivity  = mean(powmatrix(:,oddfreqbins),2);
bsactivity   = mean(powmatrix(:,bsfreqbins),2);

chs2mark_odd = find(oddactivity > threshold);
chs2mark_bs  = find(bsactivity  > threshold);

chanlocs = chanlocs(1:128);
figure;
topoplotMK(oddactivity,chanlocs,'plotrad',0.8,'emarker2',{chs2mark_odd,'*','k',12,1});%,'maplimits',ylims
colorbar;
% 
if length(chs2mark_bs) == length(chanlocs)
    chs2mark_bs(end) = [];
end
figure;
topoplotMK(bsactivity,chanlocs,'hcolor','none','emarker2',{chs2mark_bs,'*','k',12,1});%'maplimits',ylims
colorbar;


%% clear the memory
% clear EEGICA EEG1
%
% disp('****************** Finished ******************');