
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% IDEAL
% Matching task
% same trial order for all Ss (diff for each cat)
% modified by Mackenzie Oct 2017 so it runs 180 trials of mixed cats
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [] = matching(subjno,subjini,age,sex,hand)
try
        %% Open Screen
        whichScreen = 0; %changed to 1 to test on laptop
        
        [w, rect] = Screen('OpenWindow', whichScreen, 255);
        xc = rect(3)/2;
        yc = rect(4)/2;
        hand = hand;
        age = age;
        sex = sex;
        category = 2; % sets category
        
        Screen(w, 'TextSize', 24);
        Screen(w, 'TextFont', 'Arial');
        Screen(w, 'TextStyle', 1);
        
        commandwindow; %get back to command window
        
        %% create files for saving data
        cd('data_M')
        fileName1 = ['M_' num2str(subjno) '_' subjini '_' num2str(category) '.txt'];
        dataFile1 = fopen(fileName1, 'w');
        cd('..')
        
        ListenChar(2);
        HideCursor;
        commandwindow;
        
        %% make masks
        mask_0 = imread('mask_0.jpg');
        mask_1 = imread('mask_1.jpg');
        mask_2 = imread('mask_2.jpg');
        mask_3 = imread('mask_3.jpg');
        mask_4 = imread('mask_4.jpg');
        
        mask_0 = imresize(mask_0, [125 125]);
        mask_1 = imresize(mask_1, [125 125]);
        mask_2 = imresize(mask_2, [125 125]);
        mask_3 = imresize(mask_3, [125 125]);
        mask_4 = imresize(mask_4, [125 125]);
        
        masktexture_0 = Screen('MakeTexture', w, mask_0);
        masktexture_1 = Screen('MakeTexture', w, mask_1);
        masktexture_2 = Screen('MakeTexture', w, mask_2);
        masktexture_3 = Screen('MakeTexture', w, mask_3);
        masktexture_4 = Screen('MakeTexture', w, mask_4);
        
        %% load instruction Screens
        instruct1 = imread('instruct1.jpg');
        instruct1_texture = Screen('MakeTexture', w, instruct1);
        
        instruct2 = imread('instruct2.jpg');
        instruct2_texture = Screen('MakeTexture', w, instruct2);
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%instructions
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        Screen('DrawTexture', w, instruct1_texture);
        Screen('Flip', w);
        while 1
            [keyIsDown,secs,keyCode]=KbCheck;
            if keyIsDown
                responsecode=find(keyCode);
                if responsecode==KbName('space')
                    break
                end
            end
        end
        Screen('Flip',w);
        while KbCheck; end
        
        Screen('DrawTexture', w, instruct2_texture);
        Screen('Flip', w);
        while 1
            [keyIsDown,secs,keyCode]=KbCheck;
            if keyIsDown
                responsecode=find(keyCode);
                if responsecode==KbName('space')
                    break
                end
            end
        end
        Screen('Flip',w);
        while KbCheck; end
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%Practice trials
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [cat trial samediff viewpoint size S1_name S2_name] = textread('Practice_trials.txt', '%u %u %s %s %s %s %s');
        
        Screen('Flip', w);
        center_text(w, 'Now you will complete a short practice block to familiarize you with the task.', 0, -100);
        center_text(w, 'Press J for if the two objects are the SAME IDENTITY.', 0, -50);
        center_text(w, 'Press K if the two objects are a DIFFERENT IDENTITY.', 0, 0);
        center_text(w, 'Try to respond as QUICKLY and ACCURATELY as possible.', 0, 50);
        center_text(w, 'Press the spacebar to start the practice block.', 0, 150);
        Screen('Flip', w);
        FlushEvents('keyDown');
        responsecode = [];
        temp = 0;
        responsecode = 0;
        while 1
            [keyIsDown, secs, keyCode] = KbCheck;
            if keyIsDown
                responsecode = find(keyCode);
                if responsecode == KbName('space')
                    break
                end
            end
        end
        while KbCheck; end
        Screen('FillRect', w, 255);
        
        ntrials = 5;
        for i = 1:ntrials
            
            %blank 500ms
            %Screen('DrawTexture', w, blanktexture);
            t = Screen('Flip', w);
            
            %fixation 500ms
            %Screen('DrawTexture', w, fixtexture);
            center_text(w, '+', 0, 0);
            t = Screen('Flip', w, t+.5);
            
            %S1 300ms or 150ms
            S1 = imread(['stimuli/' char(S1_name(i))]);
            S1 = imresize(S1, [125 125]);
            S1texture = Screen('MakeTexture', w, S1);
            Screen('DrawTexture', w, S1texture);
            t = Screen('Flip', w, t+.5);
            
            %mask 500ms
            if cat(i) == 0
                masktexture = masktexture_0;
            elseif cat(i) == 1
                masktexture = masktexture_1;
            elseif cat(i) == 2
                masktexture = masktexture_2;
            elseif cat(i) == 3
                masktexture = masktexture_3;
            elseif cat(i) == 4
                masktexture = masktexture_4;
            end
            
            Screen('DrawTexture', w, masktexture);
            if i < 181
                t = Screen('Flip', w, t+.3);
            elseif t > 180
                t = Screen('Flip', w, t+.15);
            end
            
            %S2 until response (max 3 s)
            S2 = imread(['stimuli/' char(S2_name(i))]);
            if strcmp(size{i}, 'same')
                S2 = imresize(S2, [125 125]);
            else
                S2 = imresize(S2, [95 95]);
            end
            S2texture = Screen('MakeTexture', w, S2);
            Screen('DrawTexture', w, S2texture);
            t = Screen('Flip', w, t+.5);
            
            FlushEvents('keyDown');
            temp = 0;
            rt = GetSecs;
            responsecode = 0;
            
            %record response time
            resp1 = KbName('j'); %same
            resp2 = KbName('k'); %diff
            GoOn = 0;
            keyIsDown = 0;
            while GoOn == 0;
                temp = GetSecs-rt;
                if temp > 3
                    GoOn = 1;
                end
                [keyIsDown, secs, keyCode] = KbCheck;
                if keyIsDown
                    responsecode = find(keyCode);
                    if responsecode == resp1 | responsecode == resp2
                        keyIsDown = 0;
                        GoOn = 1;
                    end
                    if responsecode == KbName('q')
                        Screen('CloseAll');
                    end
                end
            end
            
            rt = secs-rt;
            rt = rt*1000;
            
            Screen('Close', S1texture);
            Screen('Close', S2texture);
        end
        
        Screen('Flip', w);
        center_text(w, 'You have finished the practice block', 0, -100);
        center_text(w, 'If you have any questions, please go get the experimenter.', 0, -50);
        center_text(w, 'Otherwise, press the spacebar to start the experiment, which has 180 trials.', 0, 0);
        Screen('Flip', w);
        FlushEvents('keyDown');
        responsecode = [];
        temp = 0;
        responsecode = 0;
        while 1
            [keyIsDown, secs, keyCode] = KbCheck;
            if keyIsDown
                responsecode = find(keyCode);
                if responsecode == KbName('space')
                    break
                end
            end
        end
        while KbCheck; end
        Screen('FillRect', w, 255);
        
        
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%Experimental Trials
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        [cat trial samediff viewpoint size S1_name S2_name] = textread('trials.txt', '%u %u %s %s %s %s %s');
        
        ntrials = length(trial); %should get the number of trials
        for i = 1:ntrials
            
            %sets breaks
            if i>1 && mod(i-1,90)==0
                Screen('Flip',w);
                center_text(w,'You''re halfway through!', 0, 0);
                center_text(w, 'Press the spacebar when you are ready to continue',0,50);
                Screen('Flip',w);
                while 1
                    [keyIsDown,secs,keyCode]=KbCheck;
                    if keyIsDown
                        responsecode=find(keyCode);
                        if responsecode==KbName('space')
                            break
                        end
                    end
                end
            end
            while KbCheck; end;
            
            %blank 500ms
            %Screen('DrawTexture', w, blanktexture);
            t = Screen('Flip', w);
            
            %fixation 500ms
            %Screen('DrawTexture', w, fixtexture);
            center_text(w, '+', 0, 0);
            t = Screen('Flip', w, t+.5);
            
            %S1 300ms or 150ms
            S1 = imread(['stimuli/' char(S1_name(i))]);
            S1 = imresize(S1, [125 125]);
            S1texture = Screen('MakeTexture', w, S1);
            Screen('DrawTexture', w, S1texture);
            t = Screen('Flip', w, t+.5);
            
            %mask 500ms
            if cat(i) == 0
                masktexture = masktexture_0;
            elseif cat(i) == 1
                masktexture = masktexture_1;
            elseif cat(i) == 2
                masktexture = masktexture_2;
            elseif cat(i) == 3
                masktexture = masktexture_3;
            elseif cat(i) == 4
                masktexture = masktexture_4;
            end
            
            Screen('DrawTexture', w, masktexture);
            if i < 181
                t = Screen('Flip', w, t+.3);
            elseif t > 180
                t = Screen('Flip', w, t+.15);
            end
            
            %S2 until response (max 3 s)
            S2 = imread(['stimuli/' char(S2_name(i))]);
            if strcmp(size{i}, 'same')
                S2 = imresize(S2, [125 125]);
            else
                S2 = imresize(S2, [95 95]);
            end
            S2texture = Screen('MakeTexture', w, S2);
            Screen('DrawTexture', w, S2texture);
            t = Screen('Flip', w, t+.5);
            
            FlushEvents('keyDown');
            temp = 0;
            rt = GetSecs;
            responsecode = 0;
            
            %record response time
            resp1 = KbName('j'); %same
            resp2 = KbName('k'); %diff
            GoOn = 0;
            keyIsDown = 0;
            while GoOn == 0;
                temp = GetSecs-rt;
                if temp > 3
                    GoOn = 1;
                end
                [keyIsDown, secs, keyCode] = KbCheck;
                if keyIsDown
                    responsecode = find(keyCode);
                    if responsecode == resp1 | responsecode == resp2
                        keyIsDown = 0;
                        GoOn = 1;
                    end
                    if responsecode == KbName('q')
                        Screen('CloseAll');
                    end
                end
            end
            
            rt = secs-rt;
            rt = rt*1000;
            
            %set response & accuracy for output file
            if responsecode == resp1
                resp = 's';
            elseif responsecode == resp2
                resp = 'd';
            else
                resp = 'timeout';
            end
            
            if strcmp(samediff{i}, 'same')
                if responsecode == resp1
                    GradedRes = 1;
                else
                    GradedRes = 0;
                end
            elseif strcmp(samediff{i}, 'diff')
                if responsecode == resp2
                    GradedRes = 1;
                else
                    GradedRes = 0;
                end
            end
            
            %print data
            fprintf(dataFile1, '%d\t%i\t%i\t%s\t%s\t%s\t%s\t%s\t%s\t%i\t%f\n', str2double(subjno), i, cat(i), char(samediff(i)), char(viewpoint(i)), char(size(i)), char(S1_name(i)), char(S2_name(i)), char(resp), GradedRes, rt);
            Screen('Close', S1texture);
            Screen('Close', S2texture);
        end
        
        
    
    Screen('Flip', w);
    center_text(w, 'You have finished this task!', 0);
    center_text(w, 'Press the spacebar', 0, 50);
    Screen('Flip', w);
    WaitSecs(.2);
    responsecode = [];
    temp = 0;
    responsecode = 0;
    
    % Press any key to quit the program
    FlushEvents('keyDown');
    pressKey = KbWait;
    
    ShowCursor;
    ListenChar;
    
catch
    ListenChar(0);
    ShowCursor;
    %Screen('CloseAll');
    rethrow(lasterror);
end
end
