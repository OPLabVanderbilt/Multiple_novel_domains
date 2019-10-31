
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Making Trials for OPL online
% Matching task
% same trial order for all Ss (diff for each cat)
% modified by Mackenzie Oct 2017 so it runs 180 trials of mixed cats
% modified by Rankin Feb 2019 so it saves files for ASD - Layers project
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%The limit attribute is the amount of time the image is displayed before it disappears. 
%The isi is the amount of time you want the next image to wait after the current image disappears. 
%For example, the trial_4_sections-1-isi-500_limit-300 would appear on the screen for 300 milliseconds, disappear, and trial_5 would appear after 500ms after that.

%DESIGN
%slides 1 - 3: instruction
%slides 4 - 23: practice
%slide 24: break before exp trials

%slides 25 - 152: exp trials blk 1
%slides 153: break

%slides 154 - 281: exp trials blk 2
%slides 282: break

%slides 283 - 410: exp trials blk 3
%slides 411: break

%slides 412 - 539: exp trials blk 4
%slides 540: break

%slides 541 - 668: exp trials blk 5
%slides 669: break

%slides 670 - 798: exp trials blk 6
%slides 799: end


clear all;
tarAssign = 'Match_NovelObjects_TrialStructure.txt';

F.Data = 'OPLonline_TRIALS/NovelObjects';
if (~exist(F.Data,'dir'))
    mkdir(F.Data);
end
cd(F.Data);

stimfolder = '../../stimuli/';


%% make masks
mask_0 = imread([stimfolder 'mask_0.jpg']);
mask_1 = imread([stimfolder 'mask_1.jpg']);
mask_2 = imread([stimfolder 'mask_2.jpg']);
mask_3 = imread([stimfolder 'mask_3.jpg']);
mask_4 = imread([stimfolder 'mask_4.jpg']);

mask_0 = imresize(mask_0, [256 256],'bicubic');
mask_1 = imresize(mask_1, [256 256],'bicubic');
mask_2 = imresize(mask_2, [256 256],'bicubic');
mask_3 = imresize(mask_3, [256 256],'bicubic');
mask_4 = imresize(mask_4, [256 256],'bicubic');

%% make fixation
fixation = imread([stimfolder 'fixation.jpg']);
fixation = imresize(fixation, [256 256],'bicubic');

%% make response slide
% subresponse = imread([stimfolder 'response.jpg']);
% subresponse = imresize(subresponse, .5 * [125 125],'bicubic');

%% make blank space
blankspace = imread([stimfolder 'blankspace.jpg']);
blankspace = imresize(blankspace, [256 256]);

%% RUN FOR 5 PRACTICE TRIALS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Practice trials
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[cat trial samediff viewpoint size S1_name S2_name] = textread('../../trials_practice_RM.txt', '%u %u %s %s %s %s %s');

countStart = 3; %trial counter MINUS 1, exclude 3 intruction pages: we want to start at trial nb 4 so set this to =3

ntrials = 5;  % 5 trials, each has 4 slides (fix S1 mask S2)
for i = 1:ntrials
    
    if i == 1
    startTrialNo = countStart+0;
    elseif i == 2
    startTrialNo = countStart+4;
    elseif i == 3
    startTrialNo = countStart+8;
    elseif i == 4
    startTrialNo = countStart+12;
    elseif i == 5
    startTrialNo = countStart+16;
    end
    
    
    %fixation 500ms    
    %%% fix_1_sections-1_isi-500.jpg
    fixdisp = [fixation; blankspace];
    imwrite(fixdisp,['trial_' num2str(startTrialNo + 1) '_sections-1_limit-500.jpg'],'jpeg');

    
    %S1 300ms
    S1 = imread([stimfolder char(S1_name(i))]);
    S1 = imresize(S1, [256 256]);
    
    S1disp = [S1; blankspace];
    %%% fix_1_sections-3_isi-1000.jpg
    imwrite(S1disp,['trial_' num2str(startTrialNo + 2) '_sections-1_limit-300.jpg'],'jpeg');

        
    %mask 500ms
    if cat(i) == 0
        mask = mask_0;
    elseif cat(i) == 1
        mask = mask_1;
    elseif cat(i) == 2
        mask = mask_2;
    elseif cat(i) == 3
        mask = mask_3;
    elseif cat(i) == 4
        mask = mask_4;
    end
    maskdisp = [mask; blankspace];
    imwrite(maskdisp,['trial_' num2str(startTrialNo + 3) '_sections-1_limit-500.jpg'],'jpeg');

    
    %S2 until response (max 4 s)
    S2 = imread([stimfolder char(S2_name(i))]);
    subresp = imread([stimfolder 'response.jpg']); 
    if strcmp(size{i}, 'same')
        S2 = imresize(S2, [256 256],'bicubic');
        subresp = imresize(subresp, [256 256],'bicubic');
    else
        S2 = imresize(S2, .75 * [256 256],'bicubic');
        subresp = imresize(subresp, .75 * [256 256],'bicubic');
    end
    S2disp = [S2; subresp];
    
    if strcmp(samediff{i}, 'same')
        corrresp = 1;
    elseif strcmp(samediff{i}, 'diff')
        corrresp = 2;
    end

    imwrite(S2disp,['trial_' num2str(startTrialNo + 4) '_sections-2_correct-' num2str(corrresp) '_limit-4000_feedback-1000.jpg'],'jpeg');
    
end


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%Experimental Trials
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% [cat trial samediff viewpoint size S1_name S2_name] = textread('../../trials_exp_block6_RM.txt', '%u %u %s %s %s %s %s');
% 
% 
% countStart = 24; %set to MINUS 1 of the nb wanted
% 
% %32 trials * 4 slides/trial = 128 slides
% 
% ntrials = length(trial); %should get the number of trials = 32; each has 4 slides (fix S1 mask S2)
% for i = 1:ntrials
%     
%     if i == 1; startTrialNo = countStart+0;
%     elseif i == 2; startTrialNo = countStart+4;
%     elseif i == 3; startTrialNo = countStart+8;
%     elseif i == 4; startTrialNo = countStart+12;
%     elseif i == 5; startTrialNo = countStart+16;
%     elseif i == 6; startTrialNo = countStart+20;
%     elseif i == 7; startTrialNo = countStart+24;
%     elseif i == 8; startTrialNo = countStart+28;
%     elseif i == 9; startTrialNo = countStart+32;
%     elseif i == 10; startTrialNo = countStart+36;
%     elseif i == 11; startTrialNo = countStart+40;
%     elseif i == 12; startTrialNo = countStart+44;
%     elseif i == 13; startTrialNo = countStart+48;
%     elseif i == 14; startTrialNo = countStart+52;
%     elseif i == 15; startTrialNo = countStart+56;
%     elseif i == 16; startTrialNo = countStart+60;
%     elseif i == 17; startTrialNo = countStart+64;
%     elseif i == 18; startTrialNo = countStart+68;
%     elseif i == 19; startTrialNo = countStart+72;
%     elseif i == 20; startTrialNo = countStart+76;
%     elseif i == 21; startTrialNo = countStart+80;
%     elseif i == 22; startTrialNo = countStart+84;
%     elseif i == 23; startTrialNo = countStart+88;
%     elseif i == 24; startTrialNo = countStart+92;
%     elseif i == 25; startTrialNo = countStart+96;
%     elseif i == 26; startTrialNo = countStart+100;
%     elseif i == 27; startTrialNo = countStart+104;
%     elseif i == 28; startTrialNo = countStart+108;
%     elseif i == 29; startTrialNo = countStart+112;
%     elseif i == 30; startTrialNo = countStart+116;
%     elseif i == 31; startTrialNo = countStart+120;
%     elseif i == 32; startTrialNo = countStart+124;
%     end
%         
%     %fixation 500ms    
%     %%% fix_1_sections-1_isi-500.jpg
%     fixdisp = [fixation; blankspace];
%     imwrite(fixdisp,['trial_' num2str(startTrialNo + 1) '_sections-1_limit-500.jpg'],'jpeg');
% 
%     %S1 300ms
%     S1 = imread([stimfolder char(S1_name(i))]);
%     S1 = imresize(S1, [256 256]);
%     
%     S1disp = [S1; blankspace];
%     %%% trial_1_sections-3_isi-300.jpg
%     imwrite(S1disp,['trial_' num2str(startTrialNo + 2) '_sections-1_limit-300.jpg'],'jpeg');
% 
%     %mask 500ms
%     if cat(i) == 0
%         mask = mask_0;
%     elseif cat(i) == 1
%         mask = mask_1;
%     elseif cat(i) == 2
%         mask = mask_2;
%     elseif cat(i) == 3
%         mask = mask_3;
%     elseif cat(i) == 4
%         mask = mask_4;
%     end
%     maskdisp = [mask; blankspace];
%     imwrite(maskdisp,['trial_' num2str(startTrialNo + 3) '_sections-1_limit-500.jpg'],'jpeg');
% 
%     %S2 until response (max 4 s)
%     S2 = imread([stimfolder char(S2_name(i))]);
%     subresp = imread([stimfolder 'response.jpg']); 
%     if strcmp(size{i}, 'same')
%         S2 = imresize(S2, [256 256],'bicubic');
%         subresp = imresize(subresp, [256 256],'bicubic');
%     else
%         S2 = imresize(S2, .75 * [256 256],'bicubic');
%         subresp = imresize(subresp, .75 * [256 256],'bicubic');
%     end
%     S2disp = [S2; subresp];
%     
%     if strcmp(samediff{i}, 'same')
%         corrresp = 1;
%     elseif strcmp(samediff{i}, 'diff')
%         corrresp = 2;
%     end
% 
%     imwrite(S2disp,['trial_' num2str(startTrialNo + 4) '_sections-2_correct-' num2str(corrresp) '_limit-4000.jpg'],'jpeg');
%     
% end
% 
% 
    
    
    

