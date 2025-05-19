% function [data_mt1 stats_mt1] = EmotionMatching_MTAnalysis_condition(participantnumber)

% dbclear all
% clc[1:60,62:94,96:138]
for iii = [1:60,62:94,96:152]
 warning('off')
distance_beijing(iii,:).participantid = beijingmousetracking(iii,1);
participantnumber = beijingmousetracking(iii,2);
distance_beijing(iii,:).participantnumber = participantnumber;
%% load the raw MT data collected in PsychoPy
folderBase     = '/Users/huangshuran/Documents/MATLAB/Expt1/';
MatMouseFolder = fullfile(folderBase,'Programs','MatMouse-main',filesep);
DataFolder     = fullfile(folderBase,'MT_Raw',filesep);
% keystring    = {'raw_', num2str(participantnumber),'csv'};
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
    
    % 1、如果item当中含有"HA"字符，并且option_left或者option_right当中含有“FE”字符
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
    
    % 2、如果item当中含有"FE"字符，并且option_left或者option_right当中含有"HA"字符
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
    
    % 3、如果item当中含有“HA”字符，并且option_left或者option_right当中含有“SA”字符
%     flag6 = contains(option_leftI, 'SA');
%     flag7 = contains(option_rightI, 'SA');
%     if flag1 && (flag6 || flag7)
%         n = n + 1;
%         xtrajs_HA_SA{n} = xtrajs{i};   
%         ytrajs_HA_SA{n} = ytrajs{i}; 
%         ttrajs_HA_SA{n} = ttrajs{i}; 
%         indexN(n) =  i;
%     end  
end

%%% 将特定行的数据再重新组合成新的table
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

%
x_norm_s_t(left_idx,:) = x_norm_s_t(left_idx,:)*(-1);
% 
trajs.x_norm_s_t  = x_norm_s_t(noerror_idx,:);
trajs.y_norm_s_t  = y_norm_s_t(noerror_idx,:);
trajs.t_norm     = t_intps(noerror_idx,:);
% % if calculating all the trials without delete error_trials
% 
% 
% trajs.x_norm_s_t  = x_norm_s_t;
% trajs.y_norm_s_t  = y_norm_s_t;
% trajs.t_norm     = t_intps;

% trajs_fear.y_norm_s_t = y_norm_s_t(fear_idx & noerror_idx,:);
% trajs_happy.y_norm_s_t   = y_norm_s_t(happy_idx   & noerror_idx,:);

xtraj_avg  = mean(trajs.x_norm_s_t,1);
ytraj_avg  = mean(trajs.y_norm_s_t,1);
ttraj_avg  = mean(trajs.t_norm,1);

d = [xtraj_avg; ytraj_avg];
% csvwrite('/Users/huangshuran/Documents/MATLAB/Expt1/outcome/outcomeyaoyuchen_HAFE.csv', d);

% figure
% plot(xtraj_avg1,ytraj_avg1,'-ro',xtraj_avg2,ytraj_avg2,'-.ks',xtraj_avg3,ytraj_avg3,'--md','MarkerSize',8,'LineWidth',1);
% title('s & t normalized average trajectories','FontSize',10);
% xlim([-1 1]);
% ylim([0 1.2]);
% legend({'Anger','Fear','Sad'},'FontSize',10);
% 
% 
% return

% figure
% rectangle('Position',[startpos(1) startpos(3) startpos(2) startpos(4)],'LineWidth',2,'EdgeColor','k');
% hold on
% rectangle('Position',[targ1pos(1) (targ1pos(3)-targ1pos(4)) targ1pos(2) targ1pos(4)],'LineWidth',2,'EdgeColor','b');
% hold on
% rectangle('Position',[targ2pos(1) (targ2pos(3)-targ2pos(4)) targ2pos(2) targ2pos(4)],'LineWidth',2,'EdgeColor','r');
% %axis normal
% %axis square
% axis([-1 1 0 1.5])

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
 MD_error1 = (dstat_b.max*rightnum + 8-rightnum)/8;
MD = dstat_b.max;
 distance_beijing(iii,:).MD = MD;
 distance_beijing(iii,:).MD_error1 = MD_error1;
 errornumsum = 8-rightnum;
distance_beijing(iii,:).errornumsum = errornumsum;
%  save distance_beijing(iii,:).mat
% disp(['The average MD for happy-fear is ' num2str(dstat_b.MD)]);
% disp(['The average AUC for happy-fear is ' num2str(charea_b)]);
% disp(['The average RT for happy-fear is ' num2str(react_b)]);
% distance_beijing(iii,:).xtraj = xtraj_avg;
% distance_beijing(iii,:).ytraj = ytraj_avg;
% save distance_beijing(iii,:).mat
end
% distance_xHAFE = (distance_beijing(1,:).xtraj + distance_beijing(2,:).xtraj + distance_beijing(3,:).xtraj+ distance_beijing(4,:).xtraj+ distance_beijing(5,:).xtraj+ distance_beijing(6,:).xtraj+ distance_beijing(7,:).xtraj+ distance_beijing(8,:).xtraj+ distance_beijing(9,:).xtraj+ distance_beijing(10,:).xtraj+ distance_beijing(11,:).xtraj+ distance_beijing(12,:).xtraj+ distance_beijing(13,:).xtraj+ distance_beijing(14,:).xtraj+ distance_beijing(15,:).xtraj+ distance_beijing(16,:).xtraj+ distance_beijing(17,:).xtraj+ distance_beijing(18,:).xtraj+ distance_beijing(19,:).xtraj+ distance_beijing(20,:).xtraj+ distance_beijing(21,:).xtraj+ distance_beijing(22,:).xtraj+ distance_beijing(23,:).xtraj+ distance_beijing(24,:).xtraj+ distance_beijing(25,:).xtraj+ distance_beijing(26,:).xtraj+ distance_beijing(27,:).xtraj+ distance_beijing(28,:).xtraj+ distance_beijing(29,:).xtraj+ distance_beijing(30,:).xtraj+ distance_beijing(31,:).xtraj+ distance_beijing(32,:).xtraj+ distance_beijing(33,:).xtraj+ distance_beijing(34,:).xtraj+ distance_beijing(35,:).xtraj+ distance_beijing(36,:).xtraj+ distance_beijing(37,:).xtraj+ distance_beijing(38,:).xtraj+ distance_beijing(39,:).xtraj+ distance_beijing(40,:).xtraj+ distance_beijing(41,:).xtraj+ distance_beijing(42,:).xtraj+ distance_beijing(43,:).xtraj+ distance_beijing(44,:).xtraj+ distance_beijing(45,:).xtraj+ distance_beijing(46,:).xtraj+ distance_beijing(47,:).xtraj+ distance_beijing(48,:).xtraj+ distance_beijing(49,:).xtraj+ distance_beijing(50,:).xtraj+ distance_beijing(51,:).xtraj+ distance_beijing(52,:).xtraj+ distance_beijing(53,:).xtraj+ distance_beijing(54,:).xtraj+ distance_beijing(55,:).xtraj+ distance_beijing(56,:).xtraj+ distance_beijing(57,:).xtraj+ distance_beijing(58,:).xtraj+ distance_beijing(59,:).xtraj+ distance_beijing(60,:).xtraj+ distance_beijing(62,:).xtraj+ distance_beijing(63,:).xtraj+ distance_beijing(64,:).xtraj+ distance_beijing(65,:).xtraj+ distance_beijing(66,:).xtraj+ distance_beijing(67,:).xtraj+ distance_beijing(68,:).xtraj+ distance_beijing(69,:).xtraj+ distance_beijing(70,:).xtraj+ distance_beijing(71,:).xtraj+ distance_beijing(72,:).xtraj+ distance_beijing(73,:).xtraj+ distance_beijing(74,:).xtraj+ distance_beijing(75,:).xtraj+ distance_beijing(76,:).xtraj+ distance_beijing(77,:).xtraj+ distance_beijing(78,:).xtraj+ distance_beijing(79,:).xtraj+ distance_beijing(80,:).xtraj+ distance_beijing(81,:).xtraj+ distance_beijing(82,:).xtraj+ distance_beijing(83,:).xtraj+ distance_beijing(84,:).xtraj+ distance_beijing(85,:).xtraj+ distance_beijing(86,:).xtraj+ distance_beijing(87,:).xtraj+ distance_beijing(88,:).xtraj+ distance_beijing(89,:).xtraj+ distance_beijing(90,:).xtraj+ distance_beijing(91,:).xtraj+ distance_beijing(92,:).xtraj+ distance_beijing(93,:).xtraj+ distance_beijing(94,:).xtraj+ distance_beijing(96,:).xtraj+ distance_beijing(97,:).xtraj+ distance_beijing(98,:).xtraj+ distance_beijing(99,:).xtraj+ distance_beijing(100,:).xtraj+ distance_beijing(101,:).xtraj+ distance_beijing(102,:).xtraj+ distance_beijing(103,:).xtraj+ distance_beijing(104,:).xtraj+ distance_beijing(105,:).xtraj+ distance_beijing(106,:).xtraj+ distance_beijing(107,:).xtraj+ distance_beijing(108,:).xtraj+ distance_beijing(109,:).xtraj+ distance_beijing(110,:).xtraj+ distance_beijing(111,:).xtraj+ distance_beijing(112,:).xtraj+ distance_beijing(113,:).xtraj+ distance_beijing(114,:).xtraj+ distance_beijing(115,:).xtraj+ distance_beijing(116,:).xtraj+ distance_beijing(117,:).xtraj+ distance_beijing(118,:).xtraj+ distance_beijing(119,:).xtraj+ distance_beijing(120,:).xtraj+ distance_beijing(121,:).xtraj+ distance_beijing(122,:).xtraj+ distance_beijing(123,:).xtraj+ distance_beijing(124,:).xtraj+ distance_beijing(125,:).xtraj+ distance_beijing(126,:).xtraj)/124;
% distance_yHAFE = (distance_beijing(1,:).ytraj + distance_beijing(2,:).ytraj + distance_beijing(3,:).ytraj+ distance_beijing(4,:).ytraj+ distance_beijing(5,:).ytraj+ distance_beijing(6,:).ytraj+ distance_beijing(7,:).ytraj+ distance_beijing(8,:).ytraj+ distance_beijing(9,:).ytraj+ distance_beijing(10,:).ytraj+ distance_beijing(11,:).ytraj+ distance_beijing(12,:).ytraj+ distance_beijing(13,:).ytraj+ distance_beijing(14,:).ytraj+ distance_beijing(15,:).ytraj+ distance_beijing(16,:).ytraj+ distance_beijing(17,:).ytraj+ distance_beijing(18,:).ytraj+ distance_beijing(19,:).ytraj+ distance_beijing(20,:).ytraj+ distance_beijing(21,:).ytraj+ distance_beijing(22,:).ytraj+ distance_beijing(23,:).ytraj+ distance_beijing(24,:).ytraj+ distance_beijing(25,:).ytraj+ distance_beijing(26,:).ytraj+ distance_beijing(27,:).ytraj+ distance_beijing(28,:).ytraj+ distance_beijing(29,:).ytraj+ distance_beijing(30,:).ytraj+ distance_beijing(31,:).ytraj+ distance_beijing(32,:).ytraj+ distance_beijing(33,:).ytraj+ distance_beijing(34,:).ytraj+ distance_beijing(35,:).ytraj+ distance_beijing(36,:).ytraj+ distance_beijing(37,:).ytraj+ distance_beijing(38,:).ytraj+ distance_beijing(39,:).ytraj+ distance_beijing(40,:).ytraj+ distance_beijing(41,:).ytraj+ distance_beijing(42,:).ytraj+ distance_beijing(43,:).ytraj+ distance_beijing(44,:).ytraj+ distance_beijing(45,:).ytraj+ distance_beijing(46,:).ytraj+ distance_beijing(47,:).ytraj+ distance_beijing(48,:).ytraj+ distance_beijing(49,:).ytraj+ distance_beijing(50,:).ytraj+ distance_beijing(51,:).ytraj+ distance_beijing(52,:).ytraj+ distance_beijing(53,:).ytraj+ distance_beijing(54,:).ytraj+ distance_beijing(55,:).ytraj+ distance_beijing(56,:).ytraj+ distance_beijing(57,:).ytraj+ distance_beijing(58,:).ytraj+ distance_beijing(59,:).ytraj+ distance_beijing(60,:).ytraj+ distance_beijing(62,:).ytraj+ distance_beijing(63,:).ytraj+ distance_beijing(64,:).ytraj+ distance_beijing(65,:).ytraj+ distance_beijing(66,:).ytraj+ distance_beijing(67,:).ytraj+ distance_beijing(68,:).ytraj+ distance_beijing(69,:).ytraj+ distance_beijing(70,:).ytraj+ distance_beijing(71,:).ytraj+ distance_beijing(72,:).ytraj+ distance_beijing(73,:).ytraj+ distance_beijing(74,:).ytraj+ distance_beijing(75,:).ytraj+ distance_beijing(76,:).ytraj+ distance_beijing(77,:).ytraj+ distance_beijing(78,:).ytraj+ distance_beijing(79,:).ytraj+ distance_beijing(80,:).ytraj+ distance_beijing(81,:).ytraj+ distance_beijing(82,:).ytraj+ distance_beijing(83,:).ytraj+ distance_beijing(84,:).ytraj+ distance_beijing(85,:).ytraj+ distance_beijing(86,:).ytraj+ distance_beijing(87,:).ytraj+ distance_beijing(88,:).ytraj+ distance_beijing(89,:).ytraj+ distance_beijing(90,:).ytraj+ distance_beijing(91,:).ytraj+ distance_beijing(92,:).ytraj+ distance_beijing(93,:).ytraj+ distance_beijing(94,:).ytraj+ distance_beijing(96,:).ytraj+ distance_beijing(97,:).ytraj+ distance_beijing(98,:).ytraj+ distance_beijing(99,:).ytraj+ distance_beijing(100,:).ytraj+ distance_beijing(101,:).ytraj+ distance_beijing(102,:).ytraj+ distance_beijing(103,:).ytraj+ distance_beijing(104,:).ytraj+ distance_beijing(105,:).ytraj+ distance_beijing(106,:).ytraj+ distance_beijing(107,:).ytraj+ distance_beijing(108,:).ytraj+ distance_beijing(109,:).ytraj+ distance_beijing(110,:).ytraj+ distance_beijing(111,:).ytraj+ distance_beijing(112,:).ytraj+ distance_beijing(113,:).ytraj+ distance_beijing(114,:).ytraj+ distance_beijing(115,:).ytraj+ distance_beijing(116,:).ytraj+ distance_beijing(117,:).ytraj+ distance_beijing(118,:).ytraj+ distance_beijing(119,:).ytraj+ distance_beijing(120,:).ytraj+ distance_beijing(121,:).ytraj+ distance_beijing(122,:).ytraj+ distance_beijing(123,:).ytraj+ distance_beijing(124,:).ytraj+ distance_beijing(125,:).ytraj+ distance_beijing(126,:).ytraj)/124;





%% analyze MD and AUC with MatMouse
% example_1_movement_track_demo
% 
% show_heatmap(Data_DemoExpMap1,'DemoExpMap1.png',32,6,'heatmap_demo_output.png', 'Heatmap_2D','Heatmap_3D');
% 
% show_visualizations(Data_DemoExpMap1,'DemoExpMap1.png','TrajectoryFig','StimulusFig','CoordinatesFig','DurationFig');
% %show_visualizations(Data_DemoExpMap1,'DemoExpMap1.png','StimulusFig','CoordinatesFig','CurvatureFig','DurationFig',1,1);
% close all
% 
% [react,len,tstat,lineq,dstat,charea,curv]=calc_metrics(Data_DemoExpMap1);
% 
% example_3_calc_metrics_demo
% 
% 
