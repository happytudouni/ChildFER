% The program eventually generates an snr_all variable containing the signal to noise ratio for each trial and participant
% Command window displays global snr_all
% Once you have the data for all children, you can decide to set a value that removes the unwanted trial(s) from the real analysis.
% This can also be judged by z-score, but the advantage of snr is that it can also be compared between subjects
clear;clc;close all;
participantnumbers = 8;
plotarg = 0; % choose whether to draw or not
cfg = [];
if ~isfield(cfg, 'foi'),              cfg.foi              = [0.3 30];     end; foi        = cfg.foi;
if ~isfield(cfg, 'basetype'),         cfg.basetype         = 'HA';         end; basetype   = cfg.basetype;
if ~isfield(cfg, 'oddtype'),          cfg.oddtype          = 'FE';         end; oddtype    = cfg.oddtype;
if ~isfield(cfg, 'icapruning'),       cfg.icapruning       = 0;            end; icapruning = cfg.icapruning;
if ~isfield(cfg, 'metrics'),          cfg.metrics          = 'z-score';    end; metrics    = cfg.metrics;
if ~isfield(cfg, 'sex');              cfg.sex              = 'both';       end; sex        = cfg.sex;
% if ~isfield(cfg, 'orientation');      cfg.orientation      = '1';       end; orientation   = cfg.orientation;
if ~isfield(cfg, 'seglength')         cfg.seglength   = 10;    end; seglength  = cfg.seglength;
global EEG_FT z_score_all
folderBase          = 'Yourpath';
SegmentAverageFiles = fullfile(folderBase,'Yourpath',filesep);

%% The program starts here
z_score_all = nan(length(participantnumbers),4); %Up to 4 trials
for ii = 1:length(participantnumbers)
    participantnumber = participantnumbers(ii);
    filename = ['Expt 6 Participantnumber ' num2str(participantnumber) ' SSVEP_' 'BS_' basetype '_ODD_' oddtype '_emotion_' 'ica' num2str(icapruning) '.mat'];
    %     if (exist(filename) ~= 0)
    %    load([SegmentAverageFiles filename],'EEG_FT');
    %     end
    load([SegmentAverageFiles filename],'EEG_FT');
    ntrial = length(EEG_FT.trial);

    for iii = 1:ntrial
        if seglength ~= 30
            cfg         = [];
            cfg.trials  = iii;
            cfg.length  = seglength; % 10s is divided into a segment
            cfg.overlap = 0.5; % Value of overlap(0,1). For example, 0.5 indicates the overlap of 0.5 times of cut-off time (4s*0.5 = 2s)
            EEG_FT_seg  = ft_redefinetrial(cfg,EEG_FT);
            EEG_FT_seg.time(1,:) = EEG_FT_seg.time(1,1);
        else
            EEG_FT_seg = EEG_FT;
        end
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
                powspctrm_snr(:,i) = powspctrm(:,i) ./ adjbins_pow;
                powspctrm_blc(:,i) = powspctrm(:,i) - adjbins_pow;
                allbins = [powspctrm_blc(:,i-(nadjbins_oneside-1):i-2), powspctrm_blc(:,i+2:i+(nadjbins_oneside-1))];
                avgbins = mean(allbins,2);
                stdbins = std(allbins')';
                powspctrm_z(:,i)   =  (powspctrm_blc(:,i) - avgbins)./stdbins;
            end
        end

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
                    threshold = 1.96;
                else
                    threshold = 2.58;
                end
            otherwise
                powmatrix = powspctrm_snr;
        end

        load(fullfile(folderBase,'Materials','hgsn2clusters_ROI.mat'),'hgsn2clusters');
        chidx = hgsn2clusters.allaverage;
        subplot_title = 'SSVEP in the ROI';
        chpow = mean(powmatrix(chidx,:),1);
        freqbins      = EEG_freq.freq;
        if plotarg
            figure;plot(chpow);title(subplot_title);
            xline(find(freqbins == 6),'-.',{'6Hz'});
            xline(find(freqbins == 12),'-.',{'12Hz'});
            xline(find(freqbins == 18),'-.',{'18Hz'});
            xline(find(freqbins == 24),'-.',{'24Hz'});
            ylim (ylims);
            freq_ticks      = [];
            label_ticks     = [];
            freq_bins       = [foi(1) 6 12 18 24];
            for ii = 1:length(freq_bins);
                freq_ticks(ii)  = find([freqbins == freq_bins(ii)]);
                label_ticks{ii} = [num2str(freq_bins(ii)) 'Hz'];
            end
            xticks(freq_ticks);
            xticklabels(label_ticks);
            ax = gca;
            % Set x and y font sizes.
            ax.XAxis.FontSize = 15;
            ax.YAxis.FontSize = 15;
        end

        %Calculation determines whether to delete a trial
        bsfreqbins   = ismember(freqbins,[6 12 18 24]);
        bsactivity   = mean(powmatrix(:,bsfreqbins),2);

        chs2mark_bs  = find(bsactivity  > threshold);

        % load eeglab channel structure
        load(fullfile(folderBase,'Materials','hgsn128chanlocs.mat'),'chanlocs');
        chanlocs = chanlocs(1:128);
        maplimits = 'minmax'; % [-20 20];
        if length(chs2mark_bs) == length(chanlocs)
            chs2mark_bs(end) = [];
        end
        if plotarg
            figure;
            topoplotMK(bsactivity,chanlocs,'plotrad',0.8,'emarker2',{chs2mark_bs,'*','k',12,1});%'maplimits',ylims
            colorbar;
        end
        % average bsactivity across the base bins
        bsactivity_occipital = mean(bsactivity(chidx));
        z_score_all(ii,iii)      = bsactivity_occipital;
    end
end

Info.z_score_all = z_score_all(:,1:2);

number_delete_trail1 = find (Info.z_score_all(:,1) < 3.09);
number_delete_trail2 = find (Info.z_score_all(:,2) < 3.09);
participantidtrail1 = [];
participantidtrail2 = [];
for j = 1:length(number_delete_trail1)
    participantid = Info.participantnumber(number_delete_trail1(j));
    participantidtrail1 = [participantidtrail1 participantid];
end

for i = 1:length(number_delete_trail2)
    participantid = Info.participantnumber(number_delete_trail2(i));
    participantidtrail2 = [participantidtrail2 participantid];
end
participantidtrail1
participantidtrail2



