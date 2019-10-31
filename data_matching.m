%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% IDEAL matching data
%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; 
files = dir('data_M/*.txt');
outfile1 = fopen('M_data.txt', 'w');

for q = 1:size(files, 1)
    [subjectno cat trial corr view im2size im1 im2 resp gradedres rt] = textread (['data_M/' char(files(q).name)], '%u %u %u %s %s %s %s %s %s %u %f'); 

    ntrialsS = 180;
    ntrialsD = 180;
    ntrialsRT = 0;
    hit = 0;
    fa = 0;
    sumrt = 0;
    timeout = 0;
    
    for k = 1:size(subjectno, 1)
        
        %remove time out trials
        if strcmp(resp{k}, 'timeout')
            timeout = timeout + 1;
            if strcmp(corr{k}, 'same')
                ntrialsS = ntrialsS - 1;
            elseif strcmp(corr{k}, 'diff')
                ntrialsD = ntrialsD - 1;
            end
        end
            
        if strcmp(corr{k}, 'same')
            if gradedres(k) == 1
                hit = hit + 1;
                sumrt = sumrt + rt(k);
                ntrialsRT = ntrialsRT + 1;
            end
        elseif strcmp(corr{k}, 'diff')
            if gradedres(k) == 0
                fa = fa + 1;
            elseif gradedres(k) == 1
                sumrt = sumrt + rt(k);
                ntrialsRT = ntrialsRT + 1;
            end
        end
                
    end
    
    %calculate d'
    dprime = (norminv(hit/ntrialsS))-(norminv(fa/ntrialsD));
    
    %calculate correct RT
    mean_rt = sumrt/ntrialsRT;
    
    fprintf(outfile1, '%i\t%i\t%f\t%f\t%i\n', subjectno(1), cat(1), dprime, mean_rt, timeout);
end
