clc;clear all;
 warning('off')
 participantnumber = 0941;

%% load the raw MT data collected in PsychoPy
folderBase     = 'Your Path';
DataFolder     = fullfile(folderBase,'data',filesep);
keystring    = {num2str(participantnumber),'csv'};
filename     = find_filename(keystring, DataFolder);
disp(filename);
fname        = [DataFolder filename];
data_py      = readtable(fname);
% delete the blank (e.g., first and last) rows 
data_py(isnan(data_py.images_thisN),:) = [];


%% xtraj, ytraj, ttraj
item = data_py.item;
option_left = data_py.option_left;
option_right = data_py.option_right; 
% xtrajs = data_py.xTrajectory;
% ytrajs = data_py.yTrajectory;
% ttrajs = data_py.tTrajectory;
% 
% xtrajs = cellfun(@str2num,xtrajs,'UniformOutput',false);
% ytrajs = cellfun(@str2num,ytrajs,'UniformOutput',false);
% ttrajs = cellfun(@str2num,ttrajs,'UniformOutput',false);

[H,~] = size(item);
k = 0;
m = 0;
n = 0;
for i = 1:H
    itemI = item{i};
    option_leftI  = option_left{i};
    option_rightI  = option_right{i};
    
    % 1、If item contains the "HA" character and option_left or option_right contains the "FE" character
    flag1 = contains(itemI, 'HA');
    flag2 = contains(option_leftI, 'FE');
    flag3 = contains(option_rightI, 'FE');
    if flag1 && (flag2 || flag3)
        k = k + 1;
%         xtrajs_HA_AN{k} = xtrajs{i};     
%         ytrajs_HA_AN{k} = ytrajs{i}; 
%         ttrajs_HA_AN{k} = ttrajs{i}; 
        indexK(k) =  i;
    end
    
    % 2、If item contains the "FE" character and option_left or option_right contains the "HA" character
    flag4 = contains(itemI, 'FE');
    flag5 = contains(option_leftI, 'HA');
    flag6 = contains(option_rightI, 'HA');
    if flag4 && (flag5 || flag6)
        m = m + 1;
%         xtrajs_HA_FE{m} = xtrajs{i};   
%         ytrajs_HA_FE{m} = ytrajs{i}; 
%         ttrajs_HA_FE{m} = ttrajs{i}; 
        indexM(m) =  i;
    end
end

%%% Reassembles the data for a particular row into a new table
data__HA_FE = data_py(indexK, :);
data__FE_HA = data_py(indexM, :);
data__HAFE = union(data__FE_HA, data__HA_FE,'stable');

writetable(data__HAFE, 'data__HAFE.csv');


%% xtraj, ytraj, ttraj HA FE
item = data__HAFE.item;
option_left = data__HAFE.option_left;
option_right = data__HAFE.option_right; 
xtrajs = data__HAFE.xTrajectory;
ytrajs = data__HAFE.yTrajectory;
ttrajs = data__HAFE.tTrajectory;

xtrajs = cellfun(@str2num,xtrajs,'UniformOutput',false);
ytrajs = cellfun(@str2num,ytrajs,'UniformOutput',false);
ttrajs = cellfun(@str2num,ttrajs,'UniformOutput',false);

% for HA FE 
%% space and time normalization
ntrial = length(xtrajs);
x_norm_s= cell(ntrial,1);
y_norm_s   = cell(ntrial,1);
x_norm_s_t = zeros(ntrial,101);
y_norm_s_t = zeros(ntrial,101);

figure;
plotarg = 0;
data_mt = [];
t_intps = [];
for ii = 1:ntrial
    xtraj  = xtrajs{ii};
    ytraj  = ytrajs{ii};
    ttraj  = ttrajs{ii};
    %% space normalization of the x, y coordinates
    % the original rectangle has the coordinates of x (-380, 380), y (-355, 310)
    % to normalize the coordinates to a rectangle of x (-1, 1), y (0, 1.5)
    x_ratio     = 760./2;
    y_ratio     = 665./1.5;
    xtraj_norm  = xtraj./x_ratio;
    ytraj_norm  = (ytraj+355)./y_ratio; % (0,-250) is the starting position.
    x_norm_s{ii} = xtraj_norm;
    y_norm_s{ii} = ytraj_norm;
    %% time normalization with linear interpolation 
    t_intp = linspace(ttraj(1),ttraj(end),101);
    x_intp = interp1(ttraj,xtraj_norm,t_intp,'linear');
    y_intp = interp1(ttraj,ytraj_norm,t_intp,'linear');
    t_intps= [t_intps;t_intp];
    if plotarg
        subplot(sqrt(ntrial),sqrt(ntrial),ii);  plot(xtraj_norm,ytraj_norm,':b*',x_intp,y_intp,'-ro', 'MarkerSize',8,'LineWidth',2);
        title(['s + t normalization of trial #' num2str(ii)]);
        xlim([-1.5 1.5]);
        ylim([0 1.8]);
    else
        close
    end
    x_norm_s_t(ii,:) = x_intp;
    y_norm_s_t(ii,:) = y_intp;
    
    % extract other information 
    subjID = num2str(participantnumber);
%     stim   = conditiontrail_FE{i};
    order  = num2str(ii);
%     switch stim (1:2)
%         case 'AN'
%             condition = 'anger';
%         case 'FE'
%             condition = 'fear';
%         case 'HA'
%             condition = 'happy';
%     end
    resp_1 = [data__HAFE.option_left{ii}(1:2)];
    resp_2 = [data__HAFE.option_right{ii}(1:2)]; 
    mouse_clicked_name = data__HAFE.mouse_clicked_name{ii};
    switch mouse_clicked_name
        case 'rect_left'
            response = resp_1;
            resp_num = num2str(1);
        case 'rect_right'
            response = resp_2;
            resp_num = num2str(2);
    end
    item{ii} = item{ii}(1:2);
    if strcmp('HA',response) && strcmp('HA',item{ii})||strcmp('FE',response) && strcmp('FE',item{ii})
        error = num2str(0);
    else
        error = num2str(1);
    end
   % RT       = round((data_py.mouse_time(i) - data_py.ready_mouse_started(i))*1000);
    RT        = round(data__HAFE.mouse_time(ii)*1000);
    RT        = num2str(RT);
    init_time = round((data__HAFE.ready_mouse_started(ii) + data__HAFE.mouse_started(ii))*1000);
    init_time = num2str(init_time);
    
    % save all these variables to a sturcture
    data_mt.subjID{ii}      = subjID;
%     data_mt1.stim{i}        = stim;
    data_mt.order{ii}       = order;
%     data_mt1.condition{i}   = condition;
    data_mt.resp_1{ii}      = resp_1;
    data_mt.resp_2{ii}      = resp_2;
    data_mt.response{ii}    = response;
    data_mt.error{ii}       = error;
    data_mt.resp_num{ii}    = resp_num;
    data_mt.RT{ii}          = RT;
    data_mt.init_time{ii}   = init_time;
    data_mt.mouse_clicked_name{ii} = mouse_clicked_name;
end
%% plot the average trajectory by condition
trajs =[];  
% anger_idx    = cellfun(@(c)strcmp(c,'anger'),data_mt1.condition);
% fear_idx   = cellfun(@(c)strcmp(c,'fear'),data_mt1.condition);
% happy_idx     = cellfun(@(c)strcmp(c,'happy'),data_mt1.condition);
noerror_idx = cellfun(@(c)strcmp(c,'0'),data_mt.error);
left_idx    = cellfun(@(c)strcmp(c,'rect_left'),data_mt.mouse_clicked_name);

x_norm_s_t(left_idx,:) = x_norm_s_t(left_idx,:)*(-1);

trajs.x_norm_s_t  = x_norm_s_t(noerror_idx,:);
trajs.y_norm_s_t  = y_norm_s_t(noerror_idx,:);
trajs.t_norm     = t_intps(noerror_idx,:);

xtraj_avg  = mean(trajs.x_norm_s_t,1);
ytraj_avg  = mean(trajs.y_norm_s_t,1);
ttraj_avg  = mean(trajs.t_norm,1);
d = [xtraj_avg; ytraj_avg];


%% calculate MD and AUC and mean RT with MatMouse
data_mm_norm_happyfear.t = ttraj_avg';
data_mm_norm_happyfear.x = xtraj_avg';
data_mm_norm_happyfear.y = ytraj_avg';
% figure
%  plot(xtraj_avg',ytraj_avg','-ro', 'MarkerSize',8,'LineWidth',1);

% MD is dstat.max; AUC is charea. See calc_metrics for more details
[react_b,len_b,tstat_b,lineq_b,dstat_b,charea_b,curv_b]=calc_metrics(data_mm_norm_happyfear);
errornum = cellfun(@str2num,data_mt.error);
rightnum = sum(errornum(:)==0);
MD_error = (dstat_b.max*rightnum + 8-rightnum)/8;% We specify the MD of the error trial as 1


