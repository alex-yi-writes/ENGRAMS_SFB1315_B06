%% prep: pupil windows

clc;clear; close all

path_pupil = '/Users/alex/Dropbox/paperwriting/1315/data2/pupil_cleaned/new/';
path_behav = '/Users/alex/Dropbox/paperwriting/1315/data2/';
path_encoding       = [path_behav 'emotional_ratings/encoding/'];
path_recognition    = [path_behav 'recognition_data/recognition/'];

path_retest         = [path_behav 'recognition_data/Retest_recognition/'];
path_recombi_encoding       = [path_behav 'emotional_ratings/Recombination_encoding/'];
path_recombi_recognition    = [path_behav 'recognition_data/Recombination_recognition/'];

ids = {'01';'02';'03';'04';'05';'06';'07';'08';'09';'10';'11';'12';'13';'14';'15';'16';'17';'18';'19';'20';...
    '21';'22';'23';'24';'25';'26';'27';'28';'29';'30';'31';'32';'33';'34';'35';'36';'37';'38';'39';'40';'41';'42';'43';'44'};
cond = [1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1 2 1]'; % emo=1, neu=2

%% behav: session 1

% load behav data
emotional_ratings_dat=[];
recognition_results_dat=[];
for id=1:length(ids)
    
    if cond(id)==1
        emotional_ratings_dat{id,1}=readtable([path_encoding ids{id} 'eme1.xlsx']);
        recognition_results_dat{id,1}=readtable([path_recognition ids{id} 'emr1.xlsx']);
    elseif cond(id)==2
        emotional_ratings_dat{id,1}=readtable([path_encoding ids{id} 'nme1.xlsx']);
        recognition_results_dat{id,1}=readtable([path_recognition ids{id} 'nmr1.xlsx']);
    end
    
    rating_scene_dat{id,1} = table2array(emotional_ratings_dat{id,1}(:,9));
    rating_object_dat{id,1} = table2array(emotional_ratings_dat{id,1}(:,12));
    RTrating_scene_dat{id,1} = table2array(emotional_ratings_dat{id,1}(:,10));
    RTrating_object_dat{id,1} = table2array(emotional_ratings_dat{id,1}(:,13));
    
    RTrecognition_dat{id,1} = table2array(recognition_results_dat{id,1}(:,12));
    RTconfidence_dat{id,1} = table2array(recognition_results_dat{id,1}(:,15));
    accuracies_dat{id,1} = table2array(recognition_results_dat{id,1}(:,13));
    confidences_dat{id,1} = table2array(recognition_results_dat{id,1}(:,14));
    
end


%% behav: session 2

emotional_ratings_recombi_dat=[];
recognition_results_recombi_dat=[];

for id=1:length(ids)
    
    if cond(id)==1
        emotional_ratings_recombi_dat{id,1}=readtable([path_recombi_encoding ids{id} 'ere1.xlsx']);
        recognition_results_recombi_dat{id,1}=readtable([path_recombi_recognition ids{id} 'err1.xlsx']);
        try
        recognition_origretest_results_dat{id,1}=readtable([path_retest ids{id} 'emrt1.xlsx']);
        catch
        recognition_origretest_results_dat{id,1}=readtable([path_retest ids{id} 'emrt.xlsx']);
        end
    elseif cond(id)==2
        emotional_ratings_recombi_dat{id,1}=readtable([path_recombi_encoding ids{id} 'nre1.xlsx']);
        recognition_results_recombi_dat{id,1}=readtable([path_recombi_recognition ids{id} 'nrr1.xlsx']);
        try
        recognition_origretest_results_dat{id,1}=readtable([path_retest ids{id} 'nmrt1.xlsx']);
        catch
        recognition_origretest_results_dat{id,1}=readtable([path_retest ids{id} 'nmrt.xlsx']);
        end
    end
    
    rating_scene_recombi_dat{id,1} = table2array(emotional_ratings_recombi_dat{id,1}(:,9));
    rating_object_recombi_dat{id,1} = table2array(emotional_ratings_recombi_dat{id,1}(:,12));
    RTrating_scene_recombi_dat{id,1} = table2array(emotional_ratings_recombi_dat{id,1}(:,10));
    RTrating_object_recombi_dat{id,1} = table2array(emotional_ratings_recombi_dat{id,1}(:,13));
    
    RTrecognition_recombi_dat{id,1} = table2array(recognition_results_recombi_dat{id,1}(:,12));
    RTconfidence_recombi_dat{id,1} = table2array(recognition_results_recombi_dat{id,1}(:,15));
    accuracies_recombi_dat{id,1} = table2array(recognition_results_recombi_dat{id,1}(:,13));
    confidences_recombi_dat{id,1} = table2array(recognition_results_recombi_dat{id,1}(:,14));

    RTrecognition_origretest_dat{id,1} = table2array(recognition_origretest_results_dat{id,1}(:,12));
    RTconfidence_origretest_dat{id,1} = table2array(recognition_origretest_results_dat{id,1}(:,15));
    accuracies_origretest_dat{id,1} = table2array(recognition_origretest_results_dat{id,1}(:,13));
    confidences_origretest_dat{id,1} = table2array(recognition_origretest_results_dat{id,1}(:,14));
    
end

%% pupil: session 1

for id=1:length(ids)

    pupil_enc_scene_orig{id,1}  = load([path_pupil ids{id} 'enc_scene_eyedat_cln_new.mat']);
    pupil_enc_obj_orig{id,1}    = load([path_pupil ids{id} 'enc_obj_eyedat_cln_new.mat']);
    pupil_rcg_scene_orig{id,1}  = load([path_pupil ids{id} 'rcg_scene_eyedat_cln_new.mat']);
    pupil_rcg_obj_orig{id,1}    = load([path_pupil ids{id} 'rcg_obj_eyedat_cln_new.mat']);
    pupil_rcg_both_orig{id,1}   = load([path_pupil ids{id} 'rcg_both_eyedat_cln_new.mat']);

    missing_pupil_enc_scene_orig(id,1) = nansum(pupil_enc_scene_orig{id,1}.eyeinterp.dat.trl_raus);
    missing_pupil_enc_obj_orig(id,1)   = nansum(pupil_enc_obj_orig{id,1}.eyeinterp.dat.trl_raus);

    missing_pupil_rcg_scene_orig(id,1) = nansum(pupil_rcg_scene_orig{id,1}.eyeinterp.dat.trl_raus);
    missing_pupil_rcg_obj_orig(id,1)   = nansum(pupil_rcg_obj_orig{id,1}.eyeinterp.dat.trl_raus);
    missing_pupil_rcg_both_orig(id,1)  = nansum(pupil_rcg_both_orig{id,1}.eyeinterp.dat.trl_raus);

    missing_pupil_enc_Sess1_perc(id,1)       = ((nansum(pupil_enc_scene_orig{id,1}.eyeinterp.dat.trl_raus + pupil_enc_obj_orig{id,1}.eyeinterp.dat.trl_raus)/2)/60);
    missing_pupil_rcg_Sess1_perc(id,1)       = ((nansum(pupil_rcg_scene_orig{id,1}.eyeinterp.dat.trl_raus + pupil_rcg_obj_orig{id,1}.eyeinterp.dat.trl_raus + pupil_rcg_both_orig{id,1}.eyeinterp.dat.trl_raus)/3)/60);

    % alltrials_enc_scene_orig{id,1} = pupil_enc_scene_orig{id,1}.eyeinterp.dat.datai;
    % alltrials_enc_obj_orig{id,1} = pupil_enc_obj_orig{id,1}.eyeinterp.dat.datai;
    % alltrials_rcg_scene_orig{id,1} = pupil_rcg_scene_orig{id,1}.eyeinterp.dat.datai;
    % alltrials_rcg_obj_orig{id,1} = pupil_rcg_obj_orig{id,1}.eyeinterp.dat.datai;
    % alltrials_rcg_both_orig{id,1} = pupil_rcg_both_orig{id,1}.eyeinterp.dat.datai;

end

%% pupil: session 2

for id=1:length(ids)

    pupil_enc_scene_recombi{id,1}  = load([path_pupil ids{id} 'enc_scene_eyedat_cln_new.mat']);
    pupil_enc_obj_recombi{id,1}    = load([path_pupil ids{id} 'enc_obj_eyedat_cln_new.mat']);

    pupil_rcg_scene_retest{id,1}  = load([path_pupil ids{id} 'rcg_retest_scene_eyedat_cln_new.mat']);
    pupil_rcg_obj_retest{id,1}    = load([path_pupil ids{id} 'rcg_retest_obj_eyedat_cln_new.mat']);
    pupil_rcg_both_retest{id,1}   = load([path_pupil ids{id} 'rcg_retest_both_eyedat_cln_new.mat']);

    pupil_rcg_scene_recombi{id,1}  = load([path_pupil ids{id} 'rcg_scene_eyedat_cln_new.mat']);
    pupil_rcg_obj_recombi{id,1}    = load([path_pupil ids{id} 'rcg_obj_eyedat_cln_new.mat']);
    pupil_rcg_both_recombi{id,1}   = load([path_pupil ids{id} 'rcg_both_eyedat_cln_new.mat']);


    % missing
    missing_pupil_enc_scene_recombi(id,1)=nansum(pupil_enc_scene_recombi{id,1}.eyeinterp.dat.trl_raus);
    missing_pupil_enc_obj_recombi(id,1)=nansum(pupil_enc_obj_recombi{id,1}.eyeinterp.dat.trl_raus);
    missing_pupil_rcg_scene_retest(id,1)=nansum(pupil_rcg_scene_retest{id,1}.eyeinterp.dat.trl_raus);
    missing_pupil_rcg_obj_retest(id,1)=nansum(pupil_rcg_obj_retest{id,1}.eyeinterp.dat.trl_raus);
    missing_pupil_rcg_both_retest(id,1)=nansum(pupil_rcg_both_retest{id,1}.eyeinterp.dat.trl_raus);
    missing_pupil_rcg_scene_recombi(id,1)=nansum(pupil_rcg_scene_recombi{id,1}.eyeinterp.dat.trl_raus);
    missing_pupil_rcg_obj_recombi(id,1)=nansum(pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.trl_raus);
    missing_pupil_rcg_both_recombi(id,1)=nansum(pupil_rcg_both_recombi{id,1}.eyeinterp.dat.trl_raus);

    missing_pupil_enc_recombi_Sess2_perc(id,1) = nansum((missing_pupil_enc_scene_recombi(id,1) + missing_pupil_enc_obj_recombi(id,1))/2)/60;
    missing_pupil_rcg_retest_Sess2_perc(id,1) = nansum((missing_pupil_rcg_scene_retest(id,1) + missing_pupil_rcg_obj_retest(id,1) + missing_pupil_rcg_both_retest(id,1))/3)/60;
    missing_pupil_rcg_recombi_Sess2_perc(id,1) = nansum((missing_pupil_rcg_scene_recombi(id,1) + missing_pupil_rcg_obj_recombi(id,1) + missing_pupil_rcg_both_recombi(id,1))/3)/60;

    % alltrials_enc_scene_recombi{id,1} = pupil_enc_scene_recombi{id,1}.eyeinterp.dat.datai;
    % alltrials_enc_obj_recombi{id,1} = pupil_enc_obj_recombi{id,1}.eyeinterp.dat.datai;
    % alltrials_rcg_scene_retest{id,1} = pupil_rcg_scene_retest{id,1}.eyeinterp.dat.datai;
    % alltrials_rcg_obj_retest{id,1} = pupil_rcg_obj_retest{id,1}.eyeinterp.dat.datai;
    % alltrials_rcg_both_retest{id,1} = pupil_rcg_both_retest{id,1}.eyeinterp.dat.datai;
    % alltrials_rcg_scene_recombi{id,1} = pupil_rcg_scene_recombi{id,1}.eyeinterp.dat.datai;
    % alltrials_rcg_obj_recombi{id,1} = pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.datai;
    % alltrials_rcg_both_recombi{id,1} = pupil_rcg_both_recombi{id,1}.eyeinterp.dat.datai;

end


%% process pupil data, session 1

ec=0; nc=0;

for id=1:length(ids)

    % accuracy based

    % --- scenes --- %
    
    if id==18
    meanPD_rcg_scene_correct_orig(id,1) = NaN;
    meanPD_rcg_scene_incorrect_orig(id,1) = NaN;
    meanPD_rcg_scene_FAinternal_orig(id,1) = NaN;
    meanPD_rcg_scene_FAexternal_orig(id,1) = NaN;

    Zscore_PD_rcg_scene_correct_orig{id,1} = nan(1,3701);
    Zscore_meanPD_rcg_scene_correct_orig(id,1) = NaN;
    plotdat_Zscore_meanPD_rcg_scene_correct_orig(id,:)=NaN;

    Zscore_PD_rcg_scene_incorrect_orig{id,1} = nan(1,3701);
    Zscore_meanPD_rcg_scene_incorrect_orig(id,1) = NaN;
    plotdat_Zscore_meanPD_rcg_scene_incorrect_orig(id,:)=NaN;

    Zscore_PD_rcg_scene_FAinternal_orig{id,1} = nan(1,3701);
    Zscore_meanPD_rcg_scene_FAinternal_orig(id,1) = NaN;
    plotdat_Zscore_meanPD_rcg_scene_FAinternal_orig(id,:)=NaN;

    Zscore_PD_rcg_scene_FAexternal_orig{id,1} = nan(1,3701);
    Zscore_meanPD_rcg_scene_FAexternal_orig(id,1) = NaN;
    plotdat_Zscore_meanPD_rcg_scene_FAexternal_orig(id,:) = NaN;

    else
    clear tmpacc times meandat stddat ZscoredTrials
    meandat = nanmean(pupil_rcg_scene_orig{id,1}.eyeinterp.dat.datai,1);
    stddat = nanstd(pupil_rcg_scene_orig{id,1}.eyeinterp.dat.datai,1);
    % ZscoredTrials = (pupil_rcg_scene_orig{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_rcg_scene_orig{id,1}.eyeinterp.dat.datai,1),1))...
    %     ./repmat(stddat,size(pupil_rcg_scene_orig{id,1}.eyeinterp.dat.datai,1),1);
    ZscoredTrials = zscore(pupil_rcg_scene_orig{id,1}.eyeinterp.dat.datai);%(pupil_rcg_scene_orig{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_rcg_scene_orig{id,1}.eyeinterp.dat.datai,1),1))...
        % ./repmat(stddat,size(pupil_rcg_scene_orig{id,1}.eyeinterp.dat.datai,1),1);

    ZscoredTrialsalt = (pupil_rcg_scene_orig{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_rcg_scene_orig{id,1}.eyeinterp.dat.datai,1),1))...
        ./repmat(stddat,size(pupil_rcg_scene_orig{id,1}.eyeinterp.dat.datai,1),1);

    times=2500;%length(pupil_rcg_scene_orig{id,1}.eyeinterp.time{1,1});  
    tmpacc=accuracies_dat{id};
    tmpacc(pupil_rcg_scene_orig{id,1}.eyeinterp.dat.trl_raus==1)=[];
    meanPD_rcg_scene_correct_orig(id,1) = mean(nanmean(pupil_rcg_scene_orig{id,1}.eyeinterp.dat.datai(tmpacc==1,1200:times),1));
    meanPD_rcg_scene_incorrect_orig(id,1) = mean(nanmean(pupil_rcg_scene_orig{id,1}.eyeinterp.dat.datai(tmpacc~=1,1200:times),1));
    meanPD_rcg_scene_FAinternal_orig(id,1) = mean(nanmean(pupil_rcg_scene_orig{id,1}.eyeinterp.dat.datai(tmpacc==-1,1200:times),1));
    meanPD_rcg_scene_FAexternal_orig(id,1) = mean(nanmean(pupil_rcg_scene_orig{id,1}.eyeinterp.dat.datai(tmpacc==0,1200:times),1));

    Zscore_PD_rcg_scene_correct_orig{id,1} = ZscoredTrials(tmpacc==1,1:times);
    Zscore_meanPD_rcg_scene_correct_orig(id,1) = mean(nanmean(Zscore_PD_rcg_scene_correct_orig{id,1}(:,1200:times),1));
    plotdat_Zscore_meanPD_rcg_scene_correct_orig(id,:)=nanmean(Zscore_PD_rcg_scene_correct_orig{id,1}(:,1:times),1);

    Zscore_PD_rcg_scene_incorrect_orig{id,1} = ZscoredTrials(tmpacc~=1,1:times);
    Zscore_meanPD_rcg_scene_incorrect_orig(id,1) = mean(nanmean(Zscore_PD_rcg_scene_incorrect_orig{id,1}(:,1200:times),1));
    plotdat_Zscore_meanPD_rcg_scene_incorrect_orig(id,:)=nanmean(Zscore_PD_rcg_scene_incorrect_orig{id,1}(:,1:times),1);

    Zscore_PD_rcg_scene_FAinternal_orig{id,1} = ZscoredTrials(tmpacc==-1,1:times);
    Zscore_meanPD_rcg_scene_FAinternal_orig(id,1) = mean(nanmean(Zscore_PD_rcg_scene_FAinternal_orig{id,1}(:,1200:times),1));
    plotdat_Zscore_meanPD_rcg_scene_FAinternal_orig(id,:)=nanmean(Zscore_PD_rcg_scene_FAinternal_orig{id,1}(:,1:times),1);

    Zscore_PD_rcg_scene_FAexternal_orig{id,1} = ZscoredTrials(tmpacc==0,1:times);
    Zscore_meanPD_rcg_scene_FAexternal_orig(id,1) = mean(nanmean(Zscore_PD_rcg_scene_FAexternal_orig{id,1}(:,1200:times),1));
    plotdat_Zscore_meanPD_rcg_scene_FAexternal_orig(id,:) = nanmean(Zscore_PD_rcg_scene_FAexternal_orig{id,1}(:,1:times),1);
    end


    % --- objects --- %
    clear tmpacc times meandat stddat ZscoredTrials
    meandat = nanmean(pupil_rcg_obj_orig{id,1}.eyeinterp.dat.datai,1);
    stddat = nanstd(pupil_rcg_obj_orig{id,1}.eyeinterp.dat.datai,1);
    ZscoredTrials = (pupil_rcg_obj_orig{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_rcg_obj_orig{id,1}.eyeinterp.dat.datai,1),1))...
        ./repmat(stddat,size(pupil_rcg_obj_orig{id,1}.eyeinterp.dat.datai,1),1);

    times=length(pupil_rcg_obj_orig{id,1}.eyeinterp.time{1,1});  
    tmpacc=accuracies_dat{id};
    tmpacc(pupil_rcg_obj_orig{id,1}.eyeinterp.dat.trl_raus==1)=[];
    meanPD_rcg_obj_correct_orig(id,1) = mean(nanmean(pupil_rcg_obj_orig{id,1}.eyeinterp.dat.datai(tmpacc==1,1200:times),1));
    meanPD_rcg_obj_incorrect_orig(id,1) = mean(nanmean(pupil_rcg_obj_orig{id,1}.eyeinterp.dat.datai(tmpacc~=1,1200:times),1));
    meanPD_rcg_obj_FAinternal_orig(id,1) = mean(nanmean(pupil_rcg_obj_orig{id,1}.eyeinterp.dat.datai(tmpacc==-1,1200:times),1));
    meanPD_rcg_obj_FAexternal_orig(id,1) = mean(nanmean(pupil_rcg_obj_orig{id,1}.eyeinterp.dat.datai(tmpacc==0,1200:times),1));

    Zscore_PD_rcg_obj_correct_orig{id,1} = ZscoredTrials(tmpacc==1,1:times);
    Zscore_meanPD_rcg_obj_correct_orig(id,1) = mean(nanmean(Zscore_PD_rcg_obj_correct_orig{id,1}(:,1200:times),1));
    plotdat_Zscore_meanPD_rcg_obj_correct_orig(id,:) = nanmean(Zscore_PD_rcg_obj_correct_orig{id,1}(:,1:times),1);

    Zscore_PD_rcg_obj_incorrect_orig{id,1} = ZscoredTrials(tmpacc~=1,1:times);
    Zscore_meanPD_rcg_obj_incorrect_orig(id,1) = mean(nanmean(Zscore_PD_rcg_obj_incorrect_orig{id,1}(:,1200:times),1));
    plotdat_Zscore_meanPD_rcg_obj_incorrect_orig(id,:) = nanmean(Zscore_PD_rcg_obj_incorrect_orig{id,1}(:,1:times),1);

    Zscore_PD_rcg_obj_FAinternal_orig{id,1} = ZscoredTrials(tmpacc==-1,1:times);
    Zscore_meanPD_rcg_obj_FAinternal_orig(id,1) = mean(nanmean(Zscore_PD_rcg_obj_FAinternal_orig{id,1}(:,1200:times),1));
    plotdat_Zscore_meanPD_rcg_obj_FAinternal_orig(id,:) = nanmean(Zscore_PD_rcg_obj_FAinternal_orig{id,1}(:,1:times),1);

    Zscore_PD_rcg_obj_FAexternal_orig{id,1} = ZscoredTrials(tmpacc==0,1:times);
    Zscore_meanPD_rcg_obj_FAexternal_orig(id,1) = mean(nanmean(Zscore_PD_rcg_obj_FAexternal_orig{id,1}(:,1200:times),1));
    plotdat_Zscore_meanPD_rcg_obj_FAexternal_orig(id,:) = nanmean(Zscore_PD_rcg_obj_FAexternal_orig{id,1}(:,1:times),1);

    % --- both --- %
    clear tmpacc times meandat stddat ZscoredTrials
    meandat = nanmean(pupil_rcg_both_orig{id,1}.eyeinterp.dat.datai,1);
    stddat = nanstd(pupil_rcg_both_orig{id,1}.eyeinterp.dat.datai,1);
    ZscoredTrials = (pupil_rcg_both_orig{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_rcg_both_orig{id,1}.eyeinterp.dat.datai,1),1))...
        ./repmat(stddat,size(pupil_rcg_both_orig{id,1}.eyeinterp.dat.datai,1),1);

    times=length(pupil_rcg_both_orig{id,1}.eyeinterp.time{1,1});  
    tmpacc=accuracies_dat{id};
    tmpacc(pupil_rcg_both_orig{id,1}.eyeinterp.dat.trl_raus==1)=[];
    meanPD_rcg_both_correct_orig(id,1) = mean(nanmean(pupil_rcg_both_orig{id,1}.eyeinterp.dat.datai(tmpacc==1,1200:times),1));
    meanPD_rcg_both_incorrect_orig(id,1) = mean(nanmean(pupil_rcg_both_orig{id,1}.eyeinterp.dat.datai(tmpacc~=1,1200:times),1));
    meanPD_rcg_both_FAinternal_orig(id,1) = mean(nanmean(pupil_rcg_both_orig{id,1}.eyeinterp.dat.datai(tmpacc==-1,1200:times),1));
    meanPD_rcg_both_FAexternal_orig(id,1) = mean(nanmean(pupil_rcg_both_orig{id,1}.eyeinterp.dat.datai(tmpacc==0,1200:times),1));

    Zscore_PD_rcg_both_correct_orig{id,1} = ZscoredTrials(tmpacc==1,1:times);
    Zscore_meanPD_rcg_both_correct_orig(id,1) = mean(nanmean(Zscore_PD_rcg_both_correct_orig{id,1}(:,1200:times),1));
    plotdat_Zscore_meanPD_rcg_both_correct_orig(id,:) = nanmean(Zscore_PD_rcg_both_correct_orig{id,1}(:,1:times),1);

    Zscore_PD_rcg_both_incorrect_orig{id,1} = ZscoredTrials(tmpacc~=1,1:times);
    Zscore_meanPD_rcg_both_incorrect_orig(id,1) = mean(nanmean(Zscore_PD_rcg_both_incorrect_orig{id,1}(:,1200:times),1));
    plotdat_Zscore_meanPD_rcg_both_incorrect_orig(id,:) = nanmean(Zscore_PD_rcg_both_incorrect_orig{id,1}(:,1:times),1);

    Zscore_PD_rcg_both_FAinternal_orig{id,1} = ZscoredTrials(tmpacc==-1,1:times);
    Zscore_meanPD_rcg_both_FAinternal_orig(id,:) = mean(nanmean(Zscore_PD_rcg_both_FAinternal_orig{id,1}(:,1:times),1));
    plotdat_Zscore_meanPD_rcg_both_FAinternal_orig(id,:) = nanmean(Zscore_PD_rcg_both_FAinternal_orig{id,1}(:,1:times),1);

    Zscore_PD_rcg_both_FAexternal_orig{id,1} = ZscoredTrials(tmpacc==0,1:times);
    Zscore_meanPD_rcg_both_FAexternal_orig(id,:) = mean(nanmean(Zscore_PD_rcg_both_FAexternal_orig{id,1}(:,1:times),1));
    plotdat_Zscore_meanPD_rcg_both_FAexternal_orig(id,:) = nanmean(Zscore_PD_rcg_both_FAexternal_orig{id,1}(:,1:times),1);

    
    if cond(id)==1

        ec=ec+1;

        % === first: encoding === %

        % --- scenes --- %
        clear times ZscoredTrials stddat meandat
        meandat = nanmean(pupil_enc_scene_orig{id,1}.eyeinterp.dat.datai,1);
        stddat = nanstd(pupil_enc_scene_orig{id,1}.eyeinterp.dat.datai,1);
        ZscoredTrials = (pupil_enc_scene_orig{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_enc_scene_orig{id,1}.eyeinterp.dat.datai,1),1))...
        ./repmat(stddat,size(pupil_enc_scene_orig{id,1}.eyeinterp.dat.datai,1),1);
        times=length(pupil_enc_scene_orig{id,1}.eyeinterp.time{1,1});
        meanPD_enc_scene_emo_orig(ec,1) = mean(nanmean(pupil_enc_scene_orig{id,1}.eyeinterp.dat.datai(:,1200:times),1));
        Zscore_PD_enc_scene_emo_orig{ec,1} = ZscoredTrials(:,1:times);
        Zscore_meanPD_enc_scene_emo_orig(ec,1) = mean(nanmean(ZscoredTrials(:,1200:times),1));
        plotdat_Zscore_meanPD_enc_scene_emo_orig(ec,:) = nanmean(ZscoredTrials(:,1:times),1);

        % --- objects --- %
        clear times ZscoredTrials stddat meandat
        meandat = nanmean(pupil_enc_obj_orig{id,1}.eyeinterp.dat.datai,1);
        stddat = nanstd(pupil_enc_obj_orig{id,1}.eyeinterp.dat.datai,1);
        ZscoredTrials = (pupil_enc_obj_orig{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_enc_obj_orig{id,1}.eyeinterp.dat.datai,1),1))...
        ./repmat(stddat,size(pupil_enc_obj_orig{id,1}.eyeinterp.dat.datai,1),1);
        times=length(pupil_enc_obj_orig{id,1}.eyeinterp.time{1,1});
        meanPD_enc_obj_emo_orig(ec,1) = mean(nanmean(pupil_enc_obj_orig{id,1}.eyeinterp.dat.datai(:,1200:times,:),1));
        Zscore_PD_enc_obj_emo_orig{ec,1} = ZscoredTrials(:,1:times);
        Zscore_meanPD_enc_obj_emo_orig(ec,1) = mean(nanmean(ZscoredTrials(:,1200:times),1));
        plotdat_Zscore_meanPD_enc_obj_emo_orig(ec,:) = nanmean(ZscoredTrials(:,1:times),1);

        % ========================= %


        
        % === next: recognition === %

        % --- scenes --- %
        clear times ZscoredTrials stddat meandat
        meandat = nanmean(pupil_rcg_scene_orig{id,1}.eyeinterp.dat.datai,1);
        stddat = nanstd(pupil_rcg_scene_orig{id,1}.eyeinterp.dat.datai,1);
        ZscoredTrials = (pupil_rcg_scene_orig{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_rcg_scene_orig{id,1}.eyeinterp.dat.datai,1),1))...
        ./repmat(stddat,size(pupil_rcg_scene_orig{id,1}.eyeinterp.dat.datai,1),1);
        times=length(pupil_rcg_scene_orig{id,1}.eyeinterp.time{1,1});
        meanPD_rcg_scene_emo_orig(ec,1) = mean(nanmean(pupil_rcg_scene_orig{id,1}.eyeinterp.dat.datai(:,1200:times),1));
        Zscore_PD_rcg_scene_emo_orig{ec,1} = ZscoredTrials(:,1:times);
        Zscore_meanPD_rcg_scene_emo_orig(ec,1) = mean(nanmean(ZscoredTrials(:,1200:times),1));
        plotdat_Zscore_meanPD_rcg_scene_emo_orig(ec,:) = nanmean(ZscoredTrials(:,1:times),1);

        % --- objects --- %
        clear times ZscoredTrials stddat meandat
        meandat = nanmean(pupil_rcg_obj_orig{id,1}.eyeinterp.dat.datai,1);
        stddat = nanstd(pupil_rcg_obj_orig{id,1}.eyeinterp.dat.datai,1);
        ZscoredTrials = (pupil_rcg_obj_orig{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_rcg_obj_orig{id,1}.eyeinterp.dat.datai,1),1))...
        ./repmat(stddat,size(pupil_rcg_obj_orig{id,1}.eyeinterp.dat.datai,1),1);
        times=length(pupil_rcg_obj_orig{id,1}.eyeinterp.time{1,1});
        meanPD_rcg_obj_emo_orig(ec,1) = mean(nanmean(pupil_rcg_obj_orig{id,1}.eyeinterp.dat.datai(:,1200:times,:),1));
        Zscore_PD_rcg_obj_emo_orig{ec,1} = ZscoredTrials(:,1:times);
        Zscore_meanPD_rcg_obj_emo_orig(ec,1) = mean(nanmean(ZscoredTrials(:,1200:times),1));
        plotdat_Zscore_meanPD_rcg_obj_emo_orig(ec,:) = nanmean(ZscoredTrials(:,1:times),1);

        % --- both --- %
        clear times ZscoredTrials stddat meandat
        meandat = nanmean(pupil_rcg_both_orig{id,1}.eyeinterp.dat.datai,1);
        stddat = nanstd(pupil_rcg_both_orig{id,1}.eyeinterp.dat.datai,1);
        ZscoredTrials = (pupil_rcg_both_orig{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_rcg_both_orig{id,1}.eyeinterp.dat.datai,1),1))...
        ./repmat(stddat,size(pupil_rcg_both_orig{id,1}.eyeinterp.dat.datai,1),1);
        times=length(pupil_rcg_both_orig{id,1}.eyeinterp.time{1,1});
        meanPD_rcg_both_emo_orig(ec,1) = mean(nanmean(pupil_rcg_both_orig{id,1}.eyeinterp.dat.datai(:,1200:times),1));
        Zscore_PD_rcg_both_emo_orig{ec,1} = ZscoredTrials(:,1:times);
        Zscore_meanPD_rcg_both_emo_orig(ec,1) = mean(nanmean(ZscoredTrials(:,1200:times),1));
        plotdat_Zscore_meanPD_rcg_both_emo_orig(ec,:) = nanmean(ZscoredTrials(:,1:times),1);


        % = accuracy based = %
        % --- scenes --- %
        meanPD_rcg_scene_correct_emo_orig(ec,1) = meanPD_rcg_scene_correct_orig(id,1);
        meanPD_rcg_scene_incorrect_emo_orig(ec,1) = meanPD_rcg_scene_incorrect_orig(id,1);
        meanPD_rcg_scene_FAinternal_emo_orig(ec,1) = meanPD_rcg_scene_FAinternal_orig(id,1);
        meanPD_rcg_scene_FAexternal_emo_orig(ec,1) = meanPD_rcg_scene_FAexternal_orig(id,1);

        Zscore_PD_rcg_scene_correct_emo_orig(ec,1) = Zscore_PD_rcg_scene_correct_orig(id,1);
        Zscore_PD_rcg_scene_incorrect_emo_orig(ec,1) = Zscore_PD_rcg_scene_incorrect_orig(id,1);
        Zscore_PD_rcg_scene_FAinternal_emo_orig(ec,1) = Zscore_PD_rcg_scene_FAinternal_orig(id,1);
        Zscore_PD_rcg_scene_FAexternal_emo_orig(ec,1) = Zscore_PD_rcg_scene_FAexternal_orig(id,1);

        plotdat_Zscore_meanPD_rcg_scene_correct_emo_orig(ec,:) = plotdat_Zscore_meanPD_rcg_scene_correct_orig(id,:);
        plotdat_Zscore_meanPD_rcg_scene_incorrect_emo_orig(ec,:) = plotdat_Zscore_meanPD_rcg_scene_incorrect_orig(id,:);
        plotdat_Zscore_meanPD_rcg_scene_FAinternal_emo_orig(ec,:) = plotdat_Zscore_meanPD_rcg_scene_FAinternal_orig(id,:);
        plotdat_Zscore_meanPD_rcg_scene_FAexternal_emo_orig(ec,:) = plotdat_Zscore_meanPD_rcg_scene_FAexternal_orig(id,:);

        Zscore_meanPD_rcg_scene_correct_emo_orig(ec,1) = Zscore_meanPD_rcg_scene_correct_orig(id,1);
        Zscore_meanPD_rcg_scene_incorrect_emo_orig(ec,1) = Zscore_meanPD_rcg_scene_incorrect_orig(id,1);
        Zscore_meanPD_rcg_scene_FAinternal_emo_orig(ec,1) = Zscore_meanPD_rcg_scene_FAinternal_orig(id,1);
        Zscore_meanPD_rcg_scene_FAexternal_emo_orig(ec,1) = Zscore_meanPD_rcg_scene_FAexternal_orig(id,1);

        % --- objects --- %
        meanPD_rcg_obj_correct_emo_orig(ec,1) = meanPD_rcg_obj_correct_orig(id,1);
        meanPD_rcg_obj_incorrect_emo_orig(ec,1) = meanPD_rcg_obj_incorrect_orig(id,1);
        meanPD_rcg_obj_FAinternal_emo_orig(ec,1) = meanPD_rcg_obj_FAinternal_orig(id,1);
        meanPD_rcg_obj_FAexternal_emo_orig(ec,1) = meanPD_rcg_obj_FAexternal_orig(id,1);

        Zscore_PD_rcg_obj_correct_emo_orig(ec,1) = Zscore_PD_rcg_obj_correct_orig(id,1);
        Zscore_PD_rcg_obj_incorrect_emo_orig(ec,1) = Zscore_PD_rcg_obj_incorrect_orig(id,1);
        Zscore_PD_rcg_obj_FAinternal_emo_orig(ec,1) = Zscore_PD_rcg_obj_FAinternal_orig(id,1);
        Zscore_PD_rcg_obj_FAexternal_emo_orig(ec,1) = Zscore_PD_rcg_obj_FAexternal_orig(id,1);

        plotdat_Zscore_meanPD_rcg_obj_correct_emo_orig(ec,:) = plotdat_Zscore_meanPD_rcg_obj_correct_orig(id,:);
        plotdat_Zscore_meanPD_rcg_obj_incorrect_emo_orig(ec,:) = plotdat_Zscore_meanPD_rcg_obj_incorrect_orig(id,:);
        plotdat_Zscore_meanPD_rcg_obj_FAinternal_emo_orig(ec,:) = plotdat_Zscore_meanPD_rcg_obj_FAinternal_orig(id,:);
        plotdat_Zscore_meanPD_rcg_obj_FAexternal_emo_orig(ec,:) = plotdat_Zscore_meanPD_rcg_obj_FAexternal_orig(id,:);

        Zscore_meanPD_rcg_obj_correct_emo_orig(ec,1) = Zscore_meanPD_rcg_obj_correct_orig(id,1);
        Zscore_meanPD_rcg_obj_incorrect_emo_orig(ec,1) = Zscore_meanPD_rcg_obj_incorrect_orig(id,1);
        Zscore_meanPD_rcg_obj_FAinternal_emo_orig(ec,1) = Zscore_meanPD_rcg_obj_FAinternal_orig(id,1);
        Zscore_meanPD_rcg_obj_FAexternal_emo_orig(ec,1) = Zscore_meanPD_rcg_obj_FAexternal_orig(id,1);

        % --- both --- %
        meanPD_rcg_both_correct_emo_orig(ec,1) = meanPD_rcg_both_correct_orig(id,1);
        meanPD_rcg_both_incorrect_emo_orig(ec,1) = meanPD_rcg_both_incorrect_orig(id,1);
        meanPD_rcg_both_FAinternal_emo_orig(ec,1) = meanPD_rcg_both_FAinternal_orig(id,1);
        meanPD_rcg_both_FAexternal_emo_orig(ec,1) = meanPD_rcg_both_FAexternal_orig(id,1);

        Zscore_PD_rcg_both_correct_emo_orig(ec,1) = Zscore_PD_rcg_both_correct_orig(id,1);
        Zscore_PD_rcg_both_incorrect_emo_orig(ec,1) = Zscore_PD_rcg_both_incorrect_orig(id,1);
        Zscore_PD_rcg_both_FAinternal_emo_orig(ec,1) = Zscore_PD_rcg_both_FAinternal_orig(id,1);
        Zscore_PD_rcg_both_FAexternal_emo_orig(ec,1) = Zscore_PD_rcg_both_FAexternal_orig(id,1);

        plotdat_Zscore_meanPD_rcg_both_correct_emo_orig(ec,:) = plotdat_Zscore_meanPD_rcg_both_correct_orig(id,:);
        plotdat_Zscore_meanPD_rcg_both_incorrect_emo_orig(ec,:) = plotdat_Zscore_meanPD_rcg_both_incorrect_orig(id,:);
        plotdat_Zscore_meanPD_rcg_both_FAinternal_emo_orig(ec,:) = plotdat_Zscore_meanPD_rcg_both_FAinternal_orig(id,:);
        plotdat_Zscore_meanPD_rcg_both_FAexternal_emo_orig(ec,:) = plotdat_Zscore_meanPD_rcg_both_FAexternal_orig(id,:);

        Zscore_meanPD_rcg_both_correct_emo_orig(ec,1) = Zscore_meanPD_rcg_both_correct_orig(id,1);
        Zscore_meanPD_rcg_both_incorrect_emo_orig(ec,1) = Zscore_meanPD_rcg_both_incorrect_orig(id,1);
        Zscore_meanPD_rcg_both_FAinternal_emo_orig(ec,1) = Zscore_meanPD_rcg_both_FAinternal_orig(id,1);
        Zscore_meanPD_rcg_both_FAexternal_emo_orig(ec,1) = Zscore_meanPD_rcg_both_FAexternal_orig(id,1);


    elseif cond(id)==2

        % if id==18
        % else
        nc=nc+1;
        % end

        % === first: encoding === %

        % --- scenes --- %
        if id==18
        meanPD_enc_scene_neu_orig(nc,1) = NaN;
        Zscore_PD_enc_scene_neu_orig{nc,1} = nan(1,3701);
        Zscore_meanPD_enc_scene_neu_orig(nc,1) = NaN;
        plotdat_Zscore_meanPD_enc_scene_neu_orig(nc,:) = nan(1,3701);
        else
        clear times ZscoredTrials stddat meandat
        meandat = nanmean(pupil_enc_scene_orig{id,1}.eyeinterp.dat.datai,1);
        stddat = nanstd(pupil_enc_scene_orig{id,1}.eyeinterp.dat.datai,1);
        ZscoredTrials = (pupil_enc_scene_orig{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_enc_scene_orig{id,1}.eyeinterp.dat.datai,1),1))...
        ./repmat(stddat,size(pupil_enc_scene_orig{id,1}.eyeinterp.dat.datai,1),1);
        times=length(pupil_enc_scene_orig{id,1}.eyeinterp.time{1,1});
        meanPD_enc_scene_neu_orig(nc,1) = mean(nanmean(pupil_enc_scene_orig{id,1}.eyeinterp.dat.datai(:,1200:times),1));
        Zscore_PD_enc_scene_neu_orig{nc,1} = ZscoredTrials(:,1:times);
        Zscore_meanPD_enc_scene_neu_orig(nc,1) = mean(nanmean(ZscoredTrials(:,1200:times),1));
        plotdat_Zscore_meanPD_enc_scene_neu_orig(nc,:) = nanmean(ZscoredTrials(:,1:times),1);
        end

        % --- objects --- %
        clear times ZscoredTrials stddat meandat
        meandat = nanmean(pupil_enc_obj_orig{id,1}.eyeinterp.dat.datai,1);
        stddat = nanstd(pupil_enc_obj_orig{id,1}.eyeinterp.dat.datai,1);
        ZscoredTrials = (pupil_enc_obj_orig{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_enc_obj_orig{id,1}.eyeinterp.dat.datai,1),1))...
        ./repmat(stddat,size(pupil_enc_obj_orig{id,1}.eyeinterp.dat.datai,1),1);
        times=length(pupil_enc_obj_orig{id,1}.eyeinterp.time{1,1});
        meanPD_enc_obj_neu_orig(nc,1) = mean(nanmean(pupil_enc_obj_orig{id,1}.eyeinterp.dat.datai(:,1200:times,:),1));
        Zscore_PD_enc_obj_neu_orig{nc,1} = ZscoredTrials(:,1:times);
        Zscore_meanPD_enc_obj_neu_orig(nc,1) = mean(nanmean(ZscoredTrials(:,1200:times),1));
        plotdat_Zscore_meanPD_enc_obj_neu_orig(nc,:) = nanmean(ZscoredTrials(:,1:times),1);

        % ========================= %


        
        % === next: recognition === %

        % --- scenes --- %
        clear times ZscoredTrials stddat meandat
        meandat = nanmean(pupil_rcg_scene_orig{id,1}.eyeinterp.dat.datai,1);
        stddat = nanstd(pupil_rcg_scene_orig{id,1}.eyeinterp.dat.datai,1);
        ZscoredTrials = (pupil_rcg_scene_orig{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_rcg_scene_orig{id,1}.eyeinterp.dat.datai,1),1))...
        ./repmat(stddat,size(pupil_rcg_scene_orig{id,1}.eyeinterp.dat.datai,1),1);
        times=length(pupil_rcg_scene_orig{id,1}.eyeinterp.time{1,1});
        meanPD_rcg_scene_neu_orig(nc,1) = mean(nanmean(pupil_rcg_scene_orig{id,1}.eyeinterp.dat.datai(:,1200:times),1));
        Zscore_PD_rcg_scene_neu_orig{nc,1} = ZscoredTrials(:,1:times);
        Zscore_meanPD_rcg_scene_neu_orig(nc,1) = mean(nanmean(ZscoredTrials(:,1200:times),1));
        plotdat_Zscore_meanPD_rcg_scene_neu_orig(nc,:) = nanmean(ZscoredTrials(:,1:times),1);

        % --- objects --- %
        clear times ZscoredTrials stddat meandat
        meandat = nanmean(pupil_rcg_obj_orig{id,1}.eyeinterp.dat.datai,1);
        stddat = nanstd(pupil_rcg_obj_orig{id,1}.eyeinterp.dat.datai,1);
        ZscoredTrials = (pupil_rcg_obj_orig{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_rcg_obj_orig{id,1}.eyeinterp.dat.datai,1),1))...
        ./repmat(stddat,size(pupil_rcg_obj_orig{id,1}.eyeinterp.dat.datai,1),1);
        times=length(pupil_rcg_obj_orig{id,1}.eyeinterp.time{1,1});
        meanPD_rcg_obj_neu_orig(nc,1) = mean(nanmean(pupil_rcg_obj_orig{id,1}.eyeinterp.dat.datai(:,1200:times,:),1));
        Zscore_PD_rcg_obj_neu_orig{nc,1} = ZscoredTrials(:,1:times);
        Zscore_meanPD_rcg_obj_neu_orig(nc,1) = mean(nanmean(ZscoredTrials(:,1200:times),1));
        plotdat_Zscore_meanPD_rcg_obj_neu_orig(nc,:) = nanmean(ZscoredTrials(:,1:times),1);

        % --- both --- %
        clear times ZscoredTrials stddat meandat
        meandat = nanmean(pupil_rcg_both_orig{id,1}.eyeinterp.dat.datai,1);
        stddat = nanstd(pupil_rcg_both_orig{id,1}.eyeinterp.dat.datai,1);
        ZscoredTrials = (pupil_rcg_both_orig{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_rcg_both_orig{id,1}.eyeinterp.dat.datai,1),1))...
        ./repmat(stddat,size(pupil_rcg_both_orig{id,1}.eyeinterp.dat.datai,1),1);
        times=length(pupil_rcg_both_orig{id,1}.eyeinterp.time{1,1});
        meanPD_rcg_both_neu_orig(nc,1) = mean(nanmean(pupil_rcg_both_orig{id,1}.eyeinterp.dat.datai(:,1200:times),1));
        Zscore_PD_rcg_both_neu_orig{nc,1} = ZscoredTrials(:,1:times);
        Zscore_meanPD_rcg_both_neu_orig(nc,1) = mean(nanmean(ZscoredTrials(:,1200:times),1));
        plotdat_Zscore_meanPD_rcg_both_neu_orig(nc,:) = nanmean(ZscoredTrials(:,1:times),1);

        % = accuracy based = %
        % --- scenes --- %
        meanPD_rcg_scene_correct_neu_orig(nc,1) = meanPD_rcg_scene_correct_orig(id,1);
        meanPD_rcg_scene_incorrect_neu_orig(nc,1) = meanPD_rcg_scene_incorrect_orig(id,1);
        meanPD_rcg_scene_FAinternal_neu_orig(nc,1) = meanPD_rcg_scene_FAinternal_orig(id,1);
        meanPD_rcg_scene_FAexternal_neu_orig(nc,1) = meanPD_rcg_scene_FAexternal_orig(id,1);

        Zscore_PD_rcg_scene_correct_neu_orig(nc,1) = Zscore_PD_rcg_scene_correct_orig(id,1);
        Zscore_PD_rcg_scene_incorrect_neu_orig(nc,1) = Zscore_PD_rcg_scene_incorrect_orig(id,1);
        Zscore_PD_rcg_scene_FAinternal_neu_orig(nc,1) = Zscore_PD_rcg_scene_FAinternal_orig(id,1);
        Zscore_PD_rcg_scene_FAexternal_neu_orig(nc,1) = Zscore_PD_rcg_scene_FAexternal_orig(id,1);

        plotdat_Zscore_meanPD_rcg_scene_correct_neu_orig(nc,:) = plotdat_Zscore_meanPD_rcg_scene_correct_orig(id,:);
        plotdat_Zscore_meanPD_rcg_scene_incorrect_neu_orig(nc,:) = plotdat_Zscore_meanPD_rcg_scene_incorrect_orig(id,:);
        plotdat_Zscore_meanPD_rcg_scene_FAinternal_neu_orig(nc,:) = plotdat_Zscore_meanPD_rcg_scene_FAinternal_orig(id,:);
        plotdat_Zscore_meanPD_rcg_scene_FAexternal_neu_orig(nc,:) = plotdat_Zscore_meanPD_rcg_scene_FAexternal_orig(id,:);

        Zscore_meanPD_rcg_scene_correct_neu_orig(nc,1) = Zscore_meanPD_rcg_scene_correct_orig(id,1);
        Zscore_meanPD_rcg_scene_incorrect_neu_orig(nc,1) = Zscore_meanPD_rcg_scene_incorrect_orig(id,1);
        Zscore_meanPD_rcg_scene_FAinternal_neu_orig(nc,1) = Zscore_meanPD_rcg_scene_FAinternal_orig(id,1);
        Zscore_meanPD_rcg_scene_FAexternal_neu_orig(nc,1) = Zscore_meanPD_rcg_scene_FAexternal_orig(id,1);

        % --- objects --- %
        meanPD_rcg_obj_correct_neu_orig(nc,1) = meanPD_rcg_obj_correct_orig(id,1);
        meanPD_rcg_obj_incorrect_neu_orig(nc,1) = meanPD_rcg_obj_incorrect_orig(id,1);
        meanPD_rcg_obj_FAinternal_neu_orig(nc,1) = meanPD_rcg_obj_FAinternal_orig(id,1);
        meanPD_rcg_obj_FAexternal_neu_orig(nc,1) = meanPD_rcg_obj_FAexternal_orig(id,1);

        Zscore_PD_rcg_obj_correct_neu_orig(nc,1) = Zscore_PD_rcg_obj_correct_orig(id,1);
        Zscore_PD_rcg_obj_incorrect_neu_orig(nc,1) = Zscore_PD_rcg_obj_incorrect_orig(id,1);
        Zscore_PD_rcg_obj_FAinternal_neu_orig(nc,1) = Zscore_PD_rcg_obj_FAinternal_orig(id,1);
        Zscore_PD_rcg_obj_FAexternal_neu_orig(nc,1) = Zscore_PD_rcg_obj_FAexternal_orig(id,1);

        plotdat_Zscore_meanPD_rcg_obj_correct_neu_orig(nc,:) = plotdat_Zscore_meanPD_rcg_obj_correct_orig(id,:);
        plotdat_Zscore_meanPD_rcg_obj_incorrect_neu_orig(nc,:) = plotdat_Zscore_meanPD_rcg_obj_incorrect_orig(id,:);
        plotdat_Zscore_meanPD_rcg_obj_FAinternal_neu_orig(nc,:) = plotdat_Zscore_meanPD_rcg_obj_FAinternal_orig(id,:);
        plotdat_Zscore_meanPD_rcg_obj_FAexternal_neu_orig(nc,:) = plotdat_Zscore_meanPD_rcg_obj_FAexternal_orig(id,:);

        Zscore_meanPD_rcg_obj_correct_neu_orig(nc,1) = Zscore_meanPD_rcg_obj_correct_orig(id,1);
        Zscore_meanPD_rcg_obj_incorrect_neu_orig(nc,1) = Zscore_meanPD_rcg_obj_incorrect_orig(id,1);
        Zscore_meanPD_rcg_obj_FAinternal_neu_orig(nc,1) = Zscore_meanPD_rcg_obj_FAinternal_orig(id,1);
        Zscore_meanPD_rcg_obj_FAexternal_neu_orig(nc,1) = Zscore_meanPD_rcg_obj_FAexternal_orig(id,1);

        % --- both --- %
        meanPD_rcg_both_correct_neu_orig(nc,1) = meanPD_rcg_both_correct_orig(id,1);
        meanPD_rcg_both_incorrect_neu_orig(nc,1) = meanPD_rcg_both_incorrect_orig(id,1);
        meanPD_rcg_both_FAinternal_neu_orig(nc,1) = meanPD_rcg_both_FAinternal_orig(id,1);
        meanPD_rcg_both_FAexternal_neu_orig(nc,1) = meanPD_rcg_both_FAexternal_orig(id,1);

        Zscore_PD_rcg_both_correct_neu_orig(nc,1) = Zscore_PD_rcg_both_correct_orig(id,1);
        Zscore_PD_rcg_both_incorrect_neu_orig(nc,1) = Zscore_PD_rcg_both_incorrect_orig(id,1);
        Zscore_PD_rcg_both_FAinternal_neu_orig(nc,1) = Zscore_PD_rcg_both_FAinternal_orig(id,1);
        Zscore_PD_rcg_both_FAexternal_neu_orig(nc,1) = Zscore_PD_rcg_both_FAexternal_orig(id,1);

        plotdat_Zscore_meanPD_rcg_both_correct_neu_orig(nc,:) = plotdat_Zscore_meanPD_rcg_both_correct_orig(id,:);
        plotdat_Zscore_meanPD_rcg_both_incorrect_neu_orig(nc,:) = plotdat_Zscore_meanPD_rcg_both_incorrect_orig(id,:);
        plotdat_Zscore_meanPD_rcg_both_FAinternal_neu_orig(nc,:) = plotdat_Zscore_meanPD_rcg_both_FAinternal_orig(id,:);
        plotdat_Zscore_meanPD_rcg_both_FAexternal_neu_orig(nc,:) = plotdat_Zscore_meanPD_rcg_both_FAexternal_orig(id,:);

        Zscore_meanPD_rcg_both_correct_neu_orig(nc,1) = Zscore_meanPD_rcg_both_correct_orig(id,1);
        Zscore_meanPD_rcg_both_incorrect_neu_orig(nc,1) = Zscore_meanPD_rcg_both_incorrect_orig(id,1);
        Zscore_meanPD_rcg_both_FAinternal_neu_orig(nc,1) = Zscore_meanPD_rcg_both_FAinternal_orig(id,1);
        Zscore_meanPD_rcg_both_FAexternal_neu_orig(nc,1) = Zscore_meanPD_rcg_both_FAexternal_orig(id,1);


    end
end


%% process pupil data, session 2, retest

ec=0; nc=0;

for id=1:length(ids)

    % accuracy based

    % --- scenes --- %
    clear tmpacc times meandat stddat ZscoredTrials
    meandat = nanmean(pupil_rcg_scene_retest{id,1}.eyeinterp.dat.datai,1);
    stddat = nanstd(pupil_rcg_scene_retest{id,1}.eyeinterp.dat.datai,1);
    ZscoredTrials = (pupil_rcg_scene_retest{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_rcg_scene_retest{id,1}.eyeinterp.dat.datai,1),1))...
        ./repmat(stddat,size(pupil_rcg_scene_retest{id,1}.eyeinterp.dat.datai,1),1);

    times=length(pupil_rcg_scene_retest{id,1}.eyeinterp.time{1,1});  
    tmpacc=accuracies_dat{id};
    tmpacc(pupil_rcg_scene_retest{id,1}.eyeinterp.dat.trl_raus==1)=[];
    meanPD_rcg_scene_correct_retest(id,1) = mean(nanmean(pupil_rcg_scene_retest{id,1}.eyeinterp.dat.datai(tmpacc==1,1200:times),1));
    meanPD_rcg_scene_incorrect_retest(id,1) = mean(nanmean(pupil_rcg_scene_retest{id,1}.eyeinterp.dat.datai(tmpacc~=1,1200:times),1));
    meanPD_rcg_scene_FAinternal_retest(id,1) = mean(nanmean(pupil_rcg_scene_retest{id,1}.eyeinterp.dat.datai(tmpacc==-1,1200:times),1));
    meanPD_rcg_scene_FAexternal_retest(id,1) = mean(nanmean(pupil_rcg_scene_retest{id,1}.eyeinterp.dat.datai(tmpacc==0,1200:times),1));

    Zscore_PD_rcg_scene_correct_retest{id,1} = ZscoredTrials(tmpacc==1,1:times);
    Zscore_meanPD_rcg_scene_correct_retest(id,1) = mean(nanmean(Zscore_PD_rcg_scene_correct_retest{id,1}(:,1200:times),1));
    plotdat_Zscore_meanPD_rcg_scene_correct_retest(id,:)=nanmean(Zscore_PD_rcg_scene_correct_retest{id,1}(:,1:times),1);

    Zscore_PD_rcg_scene_incorrect_retest{id,1} = ZscoredTrials(tmpacc~=1,1:times);
    Zscore_meanPD_rcg_scene_incorrect_retest(id,1) = mean(nanmean(Zscore_PD_rcg_scene_incorrect_retest{id,1}(:,1200:times),1));
    plotdat_Zscore_meanPD_rcg_scene_incorrect_retest(id,:)=nanmean(Zscore_PD_rcg_scene_incorrect_retest{id,1}(:,1:times),1);

    Zscore_PD_rcg_scene_FAinternal_retest{id,1} = ZscoredTrials(tmpacc==-1,1:times);
    Zscore_meanPD_rcg_scene_FAinternal_retest(id,1) = mean(nanmean(Zscore_PD_rcg_scene_FAinternal_retest{id,1}(:,1200:times),1));
    plotdat_Zscore_meanPD_rcg_scene_FAinternal_retest(id,:)=nanmean(Zscore_PD_rcg_scene_FAinternal_retest{id,1}(:,1:times),1);

    Zscore_PD_rcg_scene_FAexternal_retest{id,1} = ZscoredTrials(tmpacc==0,1:times);
    Zscore_meanPD_rcg_scene_FAexternal_retest(id,1) = mean(nanmean(Zscore_PD_rcg_scene_FAexternal_retest{id,1}(:,1200:times),1));
    plotdat_Zscore_meanPD_rcg_scene_FAexternal_retest(id,:) = nanmean(Zscore_PD_rcg_scene_FAexternal_retest{id,1}(:,1:times),1);


    % --- objects --- %
    clear tmpacc times meandat stddat ZscoredTrials
    meandat = nanmean(pupil_rcg_obj_retest{id,1}.eyeinterp.dat.datai,1);
    stddat = nanstd(pupil_rcg_obj_retest{id,1}.eyeinterp.dat.datai,1);
    ZscoredTrials = (pupil_rcg_obj_retest{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_rcg_obj_retest{id,1}.eyeinterp.dat.datai,1),1))...
        ./repmat(stddat,size(pupil_rcg_obj_retest{id,1}.eyeinterp.dat.datai,1),1);

    times=length(pupil_rcg_obj_retest{id,1}.eyeinterp.time{1,1});  
    tmpacc=accuracies_dat{id};
    tmpacc(pupil_rcg_obj_retest{id,1}.eyeinterp.dat.trl_raus==1)=[];
    meanPD_rcg_obj_correct_retest(id,1) = mean(nanmean(pupil_rcg_obj_retest{id,1}.eyeinterp.dat.datai(tmpacc==1,1200:times),1));
    meanPD_rcg_obj_incorrect_retest(id,1) = mean(nanmean(pupil_rcg_obj_retest{id,1}.eyeinterp.dat.datai(tmpacc~=1,1200:times),1));
    meanPD_rcg_obj_FAinternal_retest(id,1) = mean(nanmean(pupil_rcg_obj_retest{id,1}.eyeinterp.dat.datai(tmpacc==-1,1200:times),1));
    meanPD_rcg_obj_FAexternal_retest(id,1) = mean(nanmean(pupil_rcg_obj_retest{id,1}.eyeinterp.dat.datai(tmpacc==0,1200:times),1));

    Zscore_PD_rcg_obj_correct_retest{id,1} = ZscoredTrials(tmpacc==1,1:times);
    Zscore_meanPD_rcg_obj_correct_retest(id,1) = mean(nanmean(Zscore_PD_rcg_obj_correct_retest{id,1}(:,1200:times),1));
    plotdat_Zscore_meanPD_rcg_obj_correct_retest(id,:) = nanmean(Zscore_PD_rcg_obj_correct_retest{id,1}(:,1:times),1);

    Zscore_PD_rcg_obj_incorrect_retest{id,1} = ZscoredTrials(tmpacc~=1,1:times);
    Zscore_meanPD_rcg_obj_incorrect_retest(id,1) = mean(nanmean(Zscore_PD_rcg_obj_incorrect_retest{id,1}(:,1200:times),1));
    plotdat_Zscore_meanPD_rcg_obj_incorrect_retest(id,:) = nanmean(Zscore_PD_rcg_obj_incorrect_retest{id,1}(:,1:times),1);

    Zscore_PD_rcg_obj_FAinternal_retest{id,1} = ZscoredTrials(tmpacc==-1,1:times);
    Zscore_meanPD_rcg_obj_FAinternal_retest(id,1) = mean(nanmean(Zscore_PD_rcg_obj_FAinternal_retest{id,1}(:,1200:times),1));
    plotdat_Zscore_meanPD_rcg_obj_FAinternal_retest(id,:) = nanmean(Zscore_PD_rcg_obj_FAinternal_retest{id,1}(:,1:times),1);

    Zscore_PD_rcg_obj_FAexternal_retest{id,1} = ZscoredTrials(tmpacc==0,1:times);
    Zscore_meanPD_rcg_obj_FAexternal_retest(id,1) = mean(nanmean(Zscore_PD_rcg_obj_FAexternal_retest{id,1}(:,1200:times),1));
    plotdat_Zscore_meanPD_rcg_obj_FAexternal_retest(id,:) = nanmean(Zscore_PD_rcg_obj_FAexternal_retest{id,1}(:,1:times),1);

    % --- both --- %
    clear tmpacc times meandat stddat ZscoredTrials
    meandat = nanmean(pupil_rcg_both_retest{id,1}.eyeinterp.dat.datai,1);
    stddat = nanstd(pupil_rcg_both_retest{id,1}.eyeinterp.dat.datai,1);
    ZscoredTrials = (pupil_rcg_both_retest{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_rcg_both_retest{id,1}.eyeinterp.dat.datai,1),1))...
        ./repmat(stddat,size(pupil_rcg_both_retest{id,1}.eyeinterp.dat.datai,1),1);

    times=length(pupil_rcg_both_retest{id,1}.eyeinterp.time{1,1});  
    tmpacc=accuracies_dat{id};
    tmpacc(pupil_rcg_both_retest{id,1}.eyeinterp.dat.trl_raus==1)=[];
    meanPD_rcg_both_correct_retest(id,1) = mean(nanmean(pupil_rcg_both_retest{id,1}.eyeinterp.dat.datai(tmpacc==1,1200:times),1));
    meanPD_rcg_both_incorrect_retest(id,1) = mean(nanmean(pupil_rcg_both_retest{id,1}.eyeinterp.dat.datai(tmpacc~=1,1200:times),1));
    meanPD_rcg_both_FAinternal_retest(id,1) = mean(nanmean(pupil_rcg_both_retest{id,1}.eyeinterp.dat.datai(tmpacc==-1,1200:times),1));
    meanPD_rcg_both_FAexternal_retest(id,1) = mean(nanmean(pupil_rcg_both_retest{id,1}.eyeinterp.dat.datai(tmpacc==0,1200:times),1));

    Zscore_PD_rcg_both_correct_retest{id,1} = ZscoredTrials(tmpacc==1,1:times);
    Zscore_meanPD_rcg_both_correct_retest(id,1) = mean(nanmean(Zscore_PD_rcg_both_correct_retest{id,1}(:,1200:times),1));
    plotdat_Zscore_meanPD_rcg_both_correct_retest(id,:) = nanmean(Zscore_PD_rcg_both_correct_retest{id,1}(:,1:times),1);

    Zscore_PD_rcg_both_incorrect_retest{id,1} = ZscoredTrials(tmpacc~=1,1:times);
    Zscore_meanPD_rcg_both_incorrect_retest(id,1) = mean(nanmean(Zscore_PD_rcg_both_incorrect_retest{id,1}(:,1200:times),1));
    plotdat_Zscore_meanPD_rcg_both_incorrect_retest(id,:) = nanmean(Zscore_PD_rcg_both_incorrect_retest{id,1}(:,1:times),1);

    Zscore_PD_rcg_both_FAinternal_retest{id,1} = ZscoredTrials(tmpacc==-1,1:times);
    Zscore_meanPD_rcg_both_FAinternal_retest(id,:) = mean(nanmean(Zscore_PD_rcg_both_FAinternal_retest{id,1}(:,1:times),1));
    plotdat_Zscore_meanPD_rcg_both_FAinternal_retest(id,:) = nanmean(Zscore_PD_rcg_both_FAinternal_retest{id,1}(:,1:times),1);

    Zscore_PD_rcg_both_FAexternal_retest{id,1} = ZscoredTrials(tmpacc==0,1:times);
    Zscore_meanPD_rcg_both_FAexternal_retest(id,:) = mean(nanmean(Zscore_PD_rcg_both_FAexternal_retest{id,1}(:,1:times),1));
    plotdat_Zscore_meanPD_rcg_both_FAexternal_retest(id,:) = nanmean(Zscore_PD_rcg_both_FAexternal_retest{id,1}(:,1:times),1);

    
    if cond(id)==1

        ec=ec+1;

        
        % === next: recognition === %

        % --- scenes --- %
        clear times ZscoredTrials stddat meandat
        meandat = nanmean(pupil_rcg_scene_retest{id,1}.eyeinterp.dat.datai,1);
        stddat = nanstd(pupil_rcg_scene_retest{id,1}.eyeinterp.dat.datai,1);
        ZscoredTrials = (pupil_rcg_scene_retest{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_rcg_scene_retest{id,1}.eyeinterp.dat.datai,1),1))...
        ./repmat(stddat,size(pupil_rcg_scene_retest{id,1}.eyeinterp.dat.datai,1),1);
        times=length(pupil_rcg_scene_retest{id,1}.eyeinterp.time{1,1});
        meanPD_rcg_scene_emo_retest(ec,1) = mean(nanmean(pupil_rcg_scene_retest{id,1}.eyeinterp.dat.datai(:,1200:times),1));
        Zscore_PD_rcg_scene_emo_retest{ec,1} = ZscoredTrials(:,1:times);
        Zscore_meanPD_rcg_scene_emo_retest(ec,1) = mean(nanmean(ZscoredTrials(:,1200:times),1));
        plotdat_Zscore_meanPD_rcg_scene_emo_retest(ec,:) = nanmean(ZscoredTrials(:,1:times),1);

        % --- objects --- %
        clear times ZscoredTrials stddat meandat
        meandat = nanmean(pupil_rcg_obj_retest{id,1}.eyeinterp.dat.datai,1);
        stddat = nanstd(pupil_rcg_obj_retest{id,1}.eyeinterp.dat.datai,1);
        ZscoredTrials = (pupil_rcg_obj_retest{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_rcg_obj_retest{id,1}.eyeinterp.dat.datai,1),1))...
        ./repmat(stddat,size(pupil_rcg_obj_retest{id,1}.eyeinterp.dat.datai,1),1);
        times=length(pupil_rcg_obj_retest{id,1}.eyeinterp.time{1,1});
        meanPD_rcg_obj_emo_retest(ec,1) = mean(nanmean(pupil_rcg_obj_retest{id,1}.eyeinterp.dat.datai(:,1200:times,:),1));
        Zscore_PD_rcg_obj_emo_retest{ec,1} = ZscoredTrials(:,1:times);
        Zscore_meanPD_rcg_obj_emo_retest(ec,1) = mean(nanmean(ZscoredTrials(:,1200:times),1));
        plotdat_Zscore_meanPD_rcg_obj_emo_retest(ec,:) = nanmean(ZscoredTrials(:,1:times),1);

        % --- both --- %
        clear times ZscoredTrials stddat meandat
        meandat = nanmean(pupil_rcg_obj_retest{id,1}.eyeinterp.dat.datai,1);
        stddat = nanstd(pupil_rcg_obj_retest{id,1}.eyeinterp.dat.datai,1);
        ZscoredTrials = (pupil_rcg_obj_retest{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_rcg_obj_retest{id,1}.eyeinterp.dat.datai,1),1))...
        ./repmat(stddat,size(pupil_rcg_obj_retest{id,1}.eyeinterp.dat.datai,1),1);
        times=length(pupil_rcg_obj_retest{id,1}.eyeinterp.time{1,1});
        meanPD_rcg_both_emo_retest(ec,1) = mean(nanmean(pupil_rcg_both_retest{id,1}.eyeinterp.dat.datai(:,1200:times),1));
        Zscore_PD_rcg_both_emo_retest{ec,1} = ZscoredTrials(:,1:times);
        Zscore_meanPD_rcg_both_emo_retest(ec,1) = mean(nanmean(ZscoredTrials(:,1200:times),1));
        plotdat_Zscore_meanPD_rcg_both_emo_retest(ec,:) = nanmean(ZscoredTrials(:,1:times),1);


        % = accuracy based = %
        % --- scenes --- %
        meanPD_rcg_scene_correct_emo_retest(ec,1) = meanPD_rcg_scene_correct_retest(id,1);
        meanPD_rcg_scene_incorrect_emo_retest(ec,1) = meanPD_rcg_scene_incorrect_retest(id,1);
        meanPD_rcg_scene_FAinternal_emo_retest(ec,1) = meanPD_rcg_scene_FAinternal_retest(id,1);
        meanPD_rcg_scene_FAexternal_emo_retest(ec,1) = meanPD_rcg_scene_FAexternal_retest(id,1);

        Zscore_PD_rcg_scene_correct_emo_retest(ec,1) = Zscore_PD_rcg_scene_correct_retest(id,1);
        Zscore_PD_rcg_scene_incorrect_emo_retest(ec,1) = Zscore_PD_rcg_scene_incorrect_retest(id,1);
        Zscore_PD_rcg_scene_FAinternal_emo_retest(ec,1) = Zscore_PD_rcg_scene_FAinternal_retest(id,1);
        Zscore_PD_rcg_scene_FAexternal_emo_retest(ec,1) = Zscore_PD_rcg_scene_FAexternal_retest(id,1);

        plotdat_Zscore_meanPD_rcg_scene_correct_emo_retest(ec,:) = plotdat_Zscore_meanPD_rcg_scene_correct_retest(id,:);
        plotdat_Zscore_meanPD_rcg_scene_incorrect_emo_retest(ec,:) = plotdat_Zscore_meanPD_rcg_scene_incorrect_retest(id,:);
        plotdat_Zscore_meanPD_rcg_scene_FAinternal_emo_retest(ec,:) = plotdat_Zscore_meanPD_rcg_scene_FAinternal_retest(id,:);
        plotdat_Zscore_meanPD_rcg_scene_FAexternal_emo_retest(ec,:) = plotdat_Zscore_meanPD_rcg_scene_FAexternal_retest(id,:);

        Zscore_meanPD_rcg_scene_correct_emo_retest(ec,1) = Zscore_meanPD_rcg_scene_correct_retest(id,1);
        Zscore_meanPD_rcg_scene_incorrect_emo_retest(ec,1) = Zscore_meanPD_rcg_scene_incorrect_retest(id,1);
        Zscore_meanPD_rcg_scene_FAinternal_emo_retest(ec,1) = Zscore_meanPD_rcg_scene_FAinternal_retest(id,1);
        Zscore_meanPD_rcg_scene_FAexternal_emo_retest(ec,1) = Zscore_meanPD_rcg_scene_FAexternal_retest(id,1);

        % --- objects --- %
        meanPD_rcg_obj_correct_emo_retest(ec,1) = meanPD_rcg_obj_correct_retest(id,1);
        meanPD_rcg_obj_incorrect_emo_retest(ec,1) = meanPD_rcg_obj_incorrect_retest(id,1);
        meanPD_rcg_obj_FAinternal_emo_retest(ec,1) = meanPD_rcg_obj_FAinternal_retest(id,1);
        meanPD_rcg_obj_FAexternal_emo_retest(ec,1) = meanPD_rcg_obj_FAexternal_retest(id,1);

        Zscore_PD_rcg_obj_correct_emo_retest(ec,1) = Zscore_PD_rcg_obj_correct_retest(id,1);
        Zscore_PD_rcg_obj_incorrect_emo_retest(ec,1) = Zscore_PD_rcg_obj_incorrect_retest(id,1);
        Zscore_PD_rcg_obj_FAinternal_emo_retest(ec,1) = Zscore_PD_rcg_obj_FAinternal_retest(id,1);
        Zscore_PD_rcg_obj_FAexternal_emo_retest(ec,1) = Zscore_PD_rcg_obj_FAexternal_retest(id,1);

        plotdat_Zscore_meanPD_rcg_obj_correct_emo_retest(ec,:) = plotdat_Zscore_meanPD_rcg_obj_correct_retest(id,:);
        plotdat_Zscore_meanPD_rcg_obj_incorrect_emo_retest(ec,:) = plotdat_Zscore_meanPD_rcg_obj_incorrect_retest(id,:);
        plotdat_Zscore_meanPD_rcg_obj_FAinternal_emo_retest(ec,:) = plotdat_Zscore_meanPD_rcg_obj_FAinternal_retest(id,:);
        plotdat_Zscore_meanPD_rcg_obj_FAexternal_emo_retest(ec,:) = plotdat_Zscore_meanPD_rcg_obj_FAexternal_retest(id,:);

        Zscore_meanPD_rcg_obj_correct_emo_retest(ec,1) = Zscore_meanPD_rcg_obj_correct_retest(id,1);
        Zscore_meanPD_rcg_obj_incorrect_emo_retest(ec,1) = Zscore_meanPD_rcg_obj_incorrect_retest(id,1);
        Zscore_meanPD_rcg_obj_FAinternal_emo_retest(ec,1) = Zscore_meanPD_rcg_obj_FAinternal_retest(id,1);
        Zscore_meanPD_rcg_obj_FAexternal_emo_retest(ec,1) = Zscore_meanPD_rcg_obj_FAexternal_retest(id,1);

        % --- both --- %
        meanPD_rcg_both_correct_emo_retest(ec,1) = meanPD_rcg_both_correct_retest(id,1);
        meanPD_rcg_both_incorrect_emo_retest(ec,1) = meanPD_rcg_both_incorrect_retest(id,1);
        meanPD_rcg_both_FAinternal_emo_retest(ec,1) = meanPD_rcg_both_FAinternal_retest(id,1);
        meanPD_rcg_both_FAexternal_emo_retest(ec,1) = meanPD_rcg_both_FAexternal_retest(id,1);

        Zscore_PD_rcg_both_correct_emo_retest(ec,1) = Zscore_PD_rcg_both_correct_retest(id,1);
        Zscore_PD_rcg_both_incorrect_emo_retest(ec,1) = Zscore_PD_rcg_both_incorrect_retest(id,1);
        Zscore_PD_rcg_both_FAinternal_emo_retest(ec,1) = Zscore_PD_rcg_both_FAinternal_retest(id,1);
        Zscore_PD_rcg_both_FAexternal_emo_retest(ec,1) = Zscore_PD_rcg_both_FAexternal_retest(id,1);

        plotdat_Zscore_meanPD_rcg_both_correct_emo_retest(ec,:) = plotdat_Zscore_meanPD_rcg_both_correct_retest(id,:);
        plotdat_Zscore_meanPD_rcg_both_incorrect_emo_retest(ec,:) = plotdat_Zscore_meanPD_rcg_both_incorrect_retest(id,:);
        plotdat_Zscore_meanPD_rcg_both_FAinternal_emo_retest(ec,:) = plotdat_Zscore_meanPD_rcg_both_FAinternal_retest(id,:);
        plotdat_Zscore_meanPD_rcg_both_FAexternal_emo_retest(ec,:) = plotdat_Zscore_meanPD_rcg_both_FAexternal_retest(id,:);

        Zscore_meanPD_rcg_both_correct_emo_retest(ec,1) = Zscore_meanPD_rcg_both_correct_retest(id,1);
        Zscore_meanPD_rcg_both_incorrect_emo_retest(ec,1) = Zscore_meanPD_rcg_both_incorrect_retest(id,1);
        Zscore_meanPD_rcg_both_FAinternal_emo_retest(ec,1) = Zscore_meanPD_rcg_both_FAinternal_retest(id,1);
        Zscore_meanPD_rcg_both_FAexternal_emo_retest(ec,1) = Zscore_meanPD_rcg_both_FAexternal_retest(id,1);


    elseif cond(id)==2

        nc=nc+1;

        
        % === next: recognition === %

        % --- scenes --- %
        clear times ZscoredTrials stddat meandat
        meandat = nanmean(pupil_rcg_scene_retest{id,1}.eyeinterp.dat.datai,1);
        stddat = nanstd(pupil_rcg_scene_retest{id,1}.eyeinterp.dat.datai,1);
        ZscoredTrials = (pupil_rcg_scene_retest{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_rcg_scene_retest{id,1}.eyeinterp.dat.datai,1),1))...
        ./repmat(stddat,size(pupil_rcg_scene_retest{id,1}.eyeinterp.dat.datai,1),1);
        times=length(pupil_rcg_scene_retest{id,1}.eyeinterp.time{1,1});
        meanPD_rcg_scene_neu_retest(nc,1) = mean(nanmean(pupil_rcg_scene_retest{id,1}.eyeinterp.dat.datai(:,1200:times),1));
        Zscore_PD_rcg_scene_neu_retest{nc,1} = ZscoredTrials(:,1:times);
        Zscore_meanPD_rcg_scene_neu_retest(nc,1) = mean(nanmean(ZscoredTrials(:,1200:times),1));
        plotdat_Zscore_meanPD_rcg_scene_neu_retest(nc,:) = nanmean(ZscoredTrials(:,1:times),1);

        % --- objects --- %
        clear times ZscoredTrials stddat meandat
        meandat = nanmean(pupil_rcg_obj_retest{id,1}.eyeinterp.dat.datai,1);
        stddat = nanstd(pupil_rcg_obj_retest{id,1}.eyeinterp.dat.datai,1);
        ZscoredTrials = (pupil_rcg_obj_retest{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_rcg_obj_retest{id,1}.eyeinterp.dat.datai,1),1))...
        ./repmat(stddat,size(pupil_rcg_obj_retest{id,1}.eyeinterp.dat.datai,1),1);
        times=length(pupil_rcg_obj_retest{id,1}.eyeinterp.time{1,1});
        meanPD_rcg_obj_neu_retest(nc,1) = mean(nanmean(pupil_rcg_obj_retest{id,1}.eyeinterp.dat.datai(:,1200:times,:),1));
        Zscore_PD_rcg_obj_neu_retest{nc,1} = ZscoredTrials(:,1:times);
        Zscore_meanPD_rcg_obj_neu_retest(nc,1) = mean(nanmean(ZscoredTrials(:,1200:times),1));
        plotdat_Zscore_meanPD_rcg_obj_neu_retest(nc,:) = nanmean(ZscoredTrials(:,1:times),1);

        % --- both --- %
        clear times ZscoredTrials stddat meandat
        meandat = nanmean(pupil_rcg_obj_retest{id,1}.eyeinterp.dat.datai,1);
        stddat = nanstd(pupil_rcg_obj_retest{id,1}.eyeinterp.dat.datai,1);
        ZscoredTrials = (pupil_rcg_obj_retest{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_rcg_obj_retest{id,1}.eyeinterp.dat.datai,1),1))...
        ./repmat(stddat,size(pupil_rcg_obj_retest{id,1}.eyeinterp.dat.datai,1),1);
        times=length(pupil_rcg_obj_retest{id,1}.eyeinterp.time{1,1});
        meanPD_rcg_both_neu_retest(nc,1) = mean(nanmean(pupil_rcg_both_retest{id,1}.eyeinterp.dat.datai(:,1200:times),1));
        Zscore_PD_rcg_both_neu_retest{nc,1} = ZscoredTrials(:,1:times);
        Zscore_meanPD_rcg_both_neu_retest(nc,1) = mean(nanmean(ZscoredTrials(:,1200:times),1));
        plotdat_Zscore_meanPD_rcg_both_neu_retest(nc,:) = nanmean(ZscoredTrials(:,1:times),1);

        % = accuracy based = %
        % --- scenes --- %
        meanPD_rcg_scene_correct_neu_retest(nc,1) = meanPD_rcg_scene_correct_retest(id,1);
        meanPD_rcg_scene_incorrect_neu_retest(nc,1) = meanPD_rcg_scene_incorrect_retest(id,1);
        meanPD_rcg_scene_FAinternal_neu_retest(nc,1) = meanPD_rcg_scene_FAinternal_retest(id,1);
        meanPD_rcg_scene_FAexternal_neu_retest(nc,1) = meanPD_rcg_scene_FAexternal_retest(id,1);

        Zscore_PD_rcg_scene_correct_neu_retest(nc,1) = Zscore_PD_rcg_scene_correct_retest(id,1);
        Zscore_PD_rcg_scene_incorrect_neu_retest(nc,1) = Zscore_PD_rcg_scene_incorrect_retest(id,1);
        Zscore_PD_rcg_scene_FAinternal_neu_retest(nc,1) = Zscore_PD_rcg_scene_FAinternal_retest(id,1);
        Zscore_PD_rcg_scene_FAexternal_neu_retest(nc,1) = Zscore_PD_rcg_scene_FAexternal_retest(id,1);

        plotdat_Zscore_meanPD_rcg_scene_correct_neu_retest(nc,:) = plotdat_Zscore_meanPD_rcg_scene_correct_retest(id,:);
        plotdat_Zscore_meanPD_rcg_scene_incorrect_neu_retest(nc,:) = plotdat_Zscore_meanPD_rcg_scene_incorrect_retest(id,:);
        plotdat_Zscore_meanPD_rcg_scene_FAinternal_neu_retest(nc,:) = plotdat_Zscore_meanPD_rcg_scene_FAinternal_retest(id,:);
        plotdat_Zscore_meanPD_rcg_scene_FAexternal_neu_retest(nc,:) = plotdat_Zscore_meanPD_rcg_scene_FAexternal_retest(id,:);

        Zscore_meanPD_rcg_scene_correct_neu_retest(nc,1) = Zscore_meanPD_rcg_scene_correct_retest(id,1);
        Zscore_meanPD_rcg_scene_incorrect_neu_retest(nc,1) = Zscore_meanPD_rcg_scene_incorrect_retest(id,1);
        Zscore_meanPD_rcg_scene_FAinternal_neu_retest(nc,1) = Zscore_meanPD_rcg_scene_FAinternal_retest(id,1);
        Zscore_meanPD_rcg_scene_FAexternal_neu_retest(nc,1) = Zscore_meanPD_rcg_scene_FAexternal_retest(id,1);

        % --- objects --- %
        meanPD_rcg_obj_correct_neu_retest(nc,1) = meanPD_rcg_obj_correct_retest(id,1);
        meanPD_rcg_obj_incorrect_neu_retest(nc,1) = meanPD_rcg_obj_incorrect_retest(id,1);
        meanPD_rcg_obj_FAinternal_neu_retest(nc,1) = meanPD_rcg_obj_FAinternal_retest(id,1);
        meanPD_rcg_obj_FAexternal_neu_retest(nc,1) = meanPD_rcg_obj_FAexternal_retest(id,1);

        Zscore_PD_rcg_obj_correct_neu_retest(nc,1) = Zscore_PD_rcg_obj_correct_retest(id,1);
        Zscore_PD_rcg_obj_incorrect_neu_retest(nc,1) = Zscore_PD_rcg_obj_incorrect_retest(id,1);
        Zscore_PD_rcg_obj_FAinternal_neu_retest(nc,1) = Zscore_PD_rcg_obj_FAinternal_retest(id,1);
        Zscore_PD_rcg_obj_FAexternal_neu_retest(nc,1) = Zscore_PD_rcg_obj_FAexternal_retest(id,1);

        plotdat_Zscore_meanPD_rcg_obj_correct_neu_retest(nc,:) = plotdat_Zscore_meanPD_rcg_obj_correct_retest(id,:);
        plotdat_Zscore_meanPD_rcg_obj_incorrect_neu_retest(nc,:) = plotdat_Zscore_meanPD_rcg_obj_incorrect_retest(id,:);
        plotdat_Zscore_meanPD_rcg_obj_FAinternal_neu_retest(nc,:) = plotdat_Zscore_meanPD_rcg_obj_FAinternal_retest(id,:);
        plotdat_Zscore_meanPD_rcg_obj_FAexternal_neu_retest(nc,:) = plotdat_Zscore_meanPD_rcg_obj_FAexternal_retest(id,:);

        Zscore_meanPD_rcg_obj_correct_neu_retest(nc,1) = Zscore_meanPD_rcg_obj_correct_retest(id,1);
        Zscore_meanPD_rcg_obj_incorrect_neu_retest(nc,1) = Zscore_meanPD_rcg_obj_incorrect_retest(id,1);
        Zscore_meanPD_rcg_obj_FAinternal_neu_retest(nc,1) = Zscore_meanPD_rcg_obj_FAinternal_retest(id,1);
        Zscore_meanPD_rcg_obj_FAexternal_neu_retest(nc,1) = Zscore_meanPD_rcg_obj_FAexternal_retest(id,1);

        % --- both --- %
        meanPD_rcg_both_correct_neu_retest(nc,1) = meanPD_rcg_both_correct_retest(id,1);
        meanPD_rcg_both_incorrect_neu_retest(nc,1) = meanPD_rcg_both_incorrect_retest(id,1);
        meanPD_rcg_both_FAinternal_neu_retest(nc,1) = meanPD_rcg_both_FAinternal_retest(id,1);
        meanPD_rcg_both_FAexternal_neu_retest(nc,1) = meanPD_rcg_both_FAexternal_retest(id,1);

        Zscore_PD_rcg_both_correct_neu_retest(nc,1) = Zscore_PD_rcg_both_correct_retest(id,1);
        Zscore_PD_rcg_both_incorrect_neu_retest(nc,1) = Zscore_PD_rcg_both_incorrect_retest(id,1);
        Zscore_PD_rcg_both_FAinternal_neu_retest(nc,1) = Zscore_PD_rcg_both_FAinternal_retest(id,1);
        Zscore_PD_rcg_both_FAexternal_neu_retest(nc,1) = Zscore_PD_rcg_both_FAexternal_retest(id,1);

        plotdat_Zscore_meanPD_rcg_both_correct_neu_retest(nc,:) = plotdat_Zscore_meanPD_rcg_both_correct_retest(id,:);
        plotdat_Zscore_meanPD_rcg_both_incorrect_neu_retest(nc,:) = plotdat_Zscore_meanPD_rcg_both_incorrect_retest(id,:);
        plotdat_Zscore_meanPD_rcg_both_FAinternal_neu_retest(nc,:) = plotdat_Zscore_meanPD_rcg_both_FAinternal_retest(id,:);
        plotdat_Zscore_meanPD_rcg_both_FAexternal_neu_retest(nc,:) = plotdat_Zscore_meanPD_rcg_both_FAexternal_retest(id,:);

        Zscore_meanPD_rcg_both_correct_neu_retest(nc,1) = Zscore_meanPD_rcg_both_correct_retest(id,1);
        Zscore_meanPD_rcg_both_incorrect_neu_retest(nc,1) = Zscore_meanPD_rcg_both_incorrect_retest(id,1);
        Zscore_meanPD_rcg_both_FAinternal_neu_retest(nc,1) = Zscore_meanPD_rcg_both_FAinternal_retest(id,1);
        Zscore_meanPD_rcg_both_FAexternal_neu_retest(nc,1) = Zscore_meanPD_rcg_both_FAexternal_retest(id,1);


    end
end



%% process pupil data, session 2, recombi


ec=0; nc=0;

for id=1:length(ids)

    % accuracy based

    % --- scenes --- %
    if id==18
    meanPD_rcg_scene_correct_recombi(id,1) = NaN;
    meanPD_rcg_scene_incorrect_recombi(id,1) = NaN;
    meanPD_rcg_scene_FAinternal_recombi(id,1) = NaN;
    meanPD_rcg_scene_FAexternal_recombi(id,1) = NaN;

    Zscore_PD_rcg_scene_correct_recombi{id,1} = nan(1,3701);
    Zscore_meanPD_rcg_scene_correct_recombi(id,1) = NaN;
    plotdat_Zscore_meanPD_rcg_scene_correct_recombi(id,:)=NaN;

    Zscore_PD_rcg_scene_incorrect_recombi{id,1} = nan(1,3701);
    Zscore_meanPD_rcg_scene_incorrect_recombi(id,1) = NaN;
    plotdat_Zscore_meanPD_rcg_scene_incorrect_recombi(id,:)=NaN;

    Zscore_PD_rcg_scene_FAinternal_recombi{id,1} = nan(1,3701);
    Zscore_meanPD_rcg_scene_FAinternal_recombi(id,1) = NaN;
    plotdat_Zscore_meanPD_rcg_scene_FAinternal_recombi(id,:)=NaN;

    Zscore_PD_rcg_scene_FAexternal_recombi{id,1} = nan(1,3701);
    Zscore_meanPD_rcg_scene_FAexternal_recombi(id,1) = NaN;
    plotdat_Zscore_meanPD_rcg_scene_FAexternal_recombi(id,:) = NaN;

    else
    clear tmpacc times meandat stddat ZscoredTrials
    meandat = nanmean(pupil_rcg_scene_recombi{id,1}.eyeinterp.dat.datai,1);
    stddat = nanstd(pupil_rcg_scene_recombi{id,1}.eyeinterp.dat.datai,1);
    ZscoredTrials = (pupil_rcg_scene_recombi{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_rcg_scene_recombi{id,1}.eyeinterp.dat.datai,1),1))...
        ./repmat(stddat,size(pupil_rcg_scene_recombi{id,1}.eyeinterp.dat.datai,1),1);

    times=length(pupil_rcg_scene_recombi{id,1}.eyeinterp.time{1,1});  
    tmpacc=accuracies_dat{id};
    tmpacc(pupil_rcg_scene_recombi{id,1}.eyeinterp.dat.trl_raus==1)=[];
    meanPD_rcg_scene_correct_recombi(id,1) = mean(nanmean(pupil_rcg_scene_recombi{id,1}.eyeinterp.dat.datai(tmpacc==1,1200:times),1));
    meanPD_rcg_scene_incorrect_recombi(id,1) = mean(nanmean(pupil_rcg_scene_recombi{id,1}.eyeinterp.dat.datai(tmpacc~=1,1200:times),1));
    meanPD_rcg_scene_FAinternal_recombi(id,1) = mean(nanmean(pupil_rcg_scene_recombi{id,1}.eyeinterp.dat.datai(tmpacc==-1,1200:times),1));
    meanPD_rcg_scene_FAexternal_recombi(id,1) = mean(nanmean(pupil_rcg_scene_recombi{id,1}.eyeinterp.dat.datai(tmpacc==0,1200:times),1));

    Zscore_PD_rcg_scene_correct_recombi{id,1} = ZscoredTrials(tmpacc==1,1:times);
    Zscore_meanPD_rcg_scene_correct_recombi(id,1) = mean(nanmean(Zscore_PD_rcg_scene_correct_recombi{id,1}(:,1200:times),1));
    plotdat_Zscore_meanPD_rcg_scene_correct_recombi(id,:)=nanmean(Zscore_PD_rcg_scene_correct_recombi{id,1}(:,1:times),1);

    Zscore_PD_rcg_scene_incorrect_recombi{id,1} = ZscoredTrials(tmpacc~=1,1:times);
    Zscore_meanPD_rcg_scene_incorrect_recombi(id,1) = mean(nanmean(Zscore_PD_rcg_scene_incorrect_recombi{id,1}(:,1200:times),1));
    plotdat_Zscore_meanPD_rcg_scene_incorrect_recombi(id,:)=nanmean(Zscore_PD_rcg_scene_incorrect_recombi{id,1}(:,1:times),1);

    Zscore_PD_rcg_scene_FAinternal_recombi{id,1} = ZscoredTrials(tmpacc==-1,1:times);
    Zscore_meanPD_rcg_scene_FAinternal_recombi(id,1) = mean(nanmean(Zscore_PD_rcg_scene_FAinternal_recombi{id,1}(:,1200:times),1));
    plotdat_Zscore_meanPD_rcg_scene_FAinternal_recombi(id,:)=nanmean(Zscore_PD_rcg_scene_FAinternal_recombi{id,1}(:,1:times),1);

    Zscore_PD_rcg_scene_FAexternal_recombi{id,1} = ZscoredTrials(tmpacc==0,1:times);
    Zscore_meanPD_rcg_scene_FAexternal_recombi(id,1) = mean(nanmean(Zscore_PD_rcg_scene_FAexternal_recombi{id,1}(:,1200:times),1));
    plotdat_Zscore_meanPD_rcg_scene_FAexternal_recombi(id,:) = nanmean(Zscore_PD_rcg_scene_FAexternal_recombi{id,1}(:,1:times),1);

    end

    % --- objects --- %
    clear tmpacc times meandat stddat ZscoredTrials
    meandat = nanmean(pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.datai,1);
    stddat = nanstd(pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.datai,1);
    ZscoredTrials = (pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.datai,1),1))...
        ./repmat(stddat,size(pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.datai,1),1);

    times=length(pupil_rcg_obj_recombi{id,1}.eyeinterp.time{1,1});  
    tmpacc=accuracies_dat{id};
    tmpacc(pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.trl_raus==1)=[];
    meanPD_rcg_obj_correct_recombi(id,1) = mean(nanmean(pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.datai(tmpacc==1,1200:times),1));
    meanPD_rcg_obj_incorrect_recombi(id,1) = mean(nanmean(pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.datai(tmpacc~=1,1200:times),1));
    meanPD_rcg_obj_FAinternal_recombi(id,1) = mean(nanmean(pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.datai(tmpacc==-1,1200:times),1));
    meanPD_rcg_obj_FAexternal_recombi(id,1) = mean(nanmean(pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.datai(tmpacc==0,1200:times),1));

    Zscore_PD_rcg_obj_correct_recombi{id,1} = ZscoredTrials(tmpacc==1,1:times);
    Zscore_meanPD_rcg_obj_correct_recombi(id,1) = mean(nanmean(Zscore_PD_rcg_obj_correct_recombi{id,1}(:,1200:times),1));
    plotdat_Zscore_meanPD_rcg_obj_correct_recombi(id,:) = nanmean(Zscore_PD_rcg_obj_correct_recombi{id,1}(:,1:times),1);

    Zscore_PD_rcg_obj_incorrect_recombi{id,1} = ZscoredTrials(tmpacc~=1,1:times);
    Zscore_meanPD_rcg_obj_incorrect_recombi(id,1) = mean(nanmean(Zscore_PD_rcg_obj_incorrect_recombi{id,1}(:,1200:times),1));
    plotdat_Zscore_meanPD_rcg_obj_incorrect_recombi(id,:) = nanmean(Zscore_PD_rcg_obj_incorrect_recombi{id,1}(:,1:times),1);

    Zscore_PD_rcg_obj_FAinternal_recombi{id,1} = ZscoredTrials(tmpacc==-1,1:times);
    Zscore_meanPD_rcg_obj_FAinternal_recombi(id,1) = mean(nanmean(Zscore_PD_rcg_obj_FAinternal_recombi{id,1}(:,1200:times),1));
    plotdat_Zscore_meanPD_rcg_obj_FAinternal_recombi(id,:) = nanmean(Zscore_PD_rcg_obj_FAinternal_recombi{id,1}(:,1:times),1);

    Zscore_PD_rcg_obj_FAexternal_recombi{id,1} = ZscoredTrials(tmpacc==0,1:times);
    Zscore_meanPD_rcg_obj_FAexternal_recombi(id,1) = mean(nanmean(Zscore_PD_rcg_obj_FAexternal_recombi{id,1}(:,1200:times),1));
    plotdat_Zscore_meanPD_rcg_obj_FAexternal_recombi(id,:) = nanmean(Zscore_PD_rcg_obj_FAexternal_recombi{id,1}(:,1:times),1);

    % --- both --- %
    clear tmpacc times meandat stddat ZscoredTrials
    meandat = nanmean(pupil_rcg_both_recombi{id,1}.eyeinterp.dat.datai,1);
    stddat = nanstd(pupil_rcg_both_recombi{id,1}.eyeinterp.dat.datai,1);
    ZscoredTrials = (pupil_rcg_both_recombi{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_rcg_both_recombi{id,1}.eyeinterp.dat.datai,1),1))...
        ./repmat(stddat,size(pupil_rcg_both_recombi{id,1}.eyeinterp.dat.datai,1),1);

    times=length(pupil_rcg_both_recombi{id,1}.eyeinterp.time{1,1});  
    tmpacc=accuracies_dat{id};
    tmpacc(pupil_rcg_both_recombi{id,1}.eyeinterp.dat.trl_raus==1)=[];
    meanPD_rcg_both_correct_recombi(id,1) = mean(nanmean(pupil_rcg_both_recombi{id,1}.eyeinterp.dat.datai(tmpacc==1,1200:times),1));
    meanPD_rcg_both_incorrect_recombi(id,1) = mean(nanmean(pupil_rcg_both_recombi{id,1}.eyeinterp.dat.datai(tmpacc~=1,1200:times),1));
    meanPD_rcg_both_FAinternal_recombi(id,1) = mean(nanmean(pupil_rcg_both_recombi{id,1}.eyeinterp.dat.datai(tmpacc==-1,1200:times),1));
    meanPD_rcg_both_FAexternal_recombi(id,1) = mean(nanmean(pupil_rcg_both_recombi{id,1}.eyeinterp.dat.datai(tmpacc==0,1200:times),1));

    Zscore_PD_rcg_both_correct_recombi{id,1} = ZscoredTrials(tmpacc==1,1:times);
    Zscore_meanPD_rcg_both_correct_recombi(id,1) = mean(nanmean(Zscore_PD_rcg_both_correct_recombi{id,1}(:,1200:times),1));
    plotdat_Zscore_meanPD_rcg_both_correct_recombi(id,:) = nanmean(Zscore_PD_rcg_both_correct_recombi{id,1}(:,1:times),1);

    Zscore_PD_rcg_both_incorrect_recombi{id,1} = ZscoredTrials(tmpacc~=1,1:times);
    Zscore_meanPD_rcg_both_incorrect_recombi(id,1) = mean(nanmean(Zscore_PD_rcg_both_incorrect_recombi{id,1}(:,1200:times),1));
    plotdat_Zscore_meanPD_rcg_both_incorrect_recombi(id,:) = nanmean(Zscore_PD_rcg_both_incorrect_recombi{id,1}(:,1:times),1);

    Zscore_PD_rcg_both_FAinternal_recombi{id,1} = ZscoredTrials(tmpacc==-1,1:times);
    Zscore_meanPD_rcg_both_FAinternal_recombi(id,:) = mean(nanmean(Zscore_PD_rcg_both_FAinternal_recombi{id,1}(:,1:times),1));
    plotdat_Zscore_meanPD_rcg_both_FAinternal_recombi(id,:) = nanmean(Zscore_PD_rcg_both_FAinternal_recombi{id,1}(:,1:times),1);

    Zscore_PD_rcg_both_FAexternal_recombi{id,1} = ZscoredTrials(tmpacc==0,1:times);
    Zscore_meanPD_rcg_both_FAexternal_recombi(id,:) = mean(nanmean(Zscore_PD_rcg_both_FAexternal_recombi{id,1}(:,1:times),1));
    plotdat_Zscore_meanPD_rcg_both_FAexternal_recombi(id,:) = nanmean(Zscore_PD_rcg_both_FAexternal_recombi{id,1}(:,1:times),1);

    
    if cond(id)==1

        ec=ec+1;

        % === first: encoding === %

        % --- scenes --- %
        clear times ZscoredTrials stddat meandat
        meandat = nanmean(pupil_enc_scene_recombi{id,1}.eyeinterp.dat.datai,1);
        stddat = nanstd(pupil_enc_scene_recombi{id,1}.eyeinterp.dat.datai,1);
        ZscoredTrials = (pupil_enc_scene_recombi{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_enc_scene_recombi{id,1}.eyeinterp.dat.datai,1),1))...
        ./repmat(stddat,size(pupil_enc_scene_recombi{id,1}.eyeinterp.dat.datai,1),1);
        times=length(pupil_enc_scene_recombi{id,1}.eyeinterp.time{1,1});
        meanPD_enc_scene_emo_recombi(ec,1) = mean(nanmean(pupil_enc_scene_recombi{id,1}.eyeinterp.dat.datai(:,1200:times),1));
        Zscore_PD_enc_scene_emo_recombi{ec,1} = ZscoredTrials(:,1:times);
        Zscore_meanPD_enc_scene_emo_recombi(ec,1) = mean(nanmean(ZscoredTrials(:,1200:times),1));
        plotdat_Zscore_meanPD_enc_scene_emo_recombi(ec,:) = nanmean(ZscoredTrials(:,1:times),1);

        % --- objects --- %
        clear times ZscoredTrials stddat meandat
        meandat = nanmean(pupil_enc_obj_recombi{id,1}.eyeinterp.dat.datai,1);
        stddat = nanstd(pupil_enc_obj_recombi{id,1}.eyeinterp.dat.datai,1);
        ZscoredTrials = (pupil_enc_obj_recombi{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_enc_obj_recombi{id,1}.eyeinterp.dat.datai,1),1))...
        ./repmat(stddat,size(pupil_enc_obj_recombi{id,1}.eyeinterp.dat.datai,1),1);
        times=length(pupil_enc_obj_recombi{id,1}.eyeinterp.time{1,1});
        meanPD_enc_obj_emo_recombi(ec,1) = mean(nanmean(pupil_enc_obj_recombi{id,1}.eyeinterp.dat.datai(:,1200:times,:),1));
        Zscore_PD_enc_obj_emo_recombi{ec,1} = ZscoredTrials(:,1:times);
        Zscore_meanPD_enc_obj_emo_recombi(ec,1) = mean(nanmean(ZscoredTrials(:,1200:times),1));
        plotdat_Zscore_meanPD_enc_obj_emo_recombi(ec,:) = nanmean(ZscoredTrials(:,1:times),1);

        % ========================= %


        
        % === next: recognition === %

        % --- scenes --- %
        clear times ZscoredTrials stddat meandat
        meandat = nanmean(pupil_rcg_scene_recombi{id,1}.eyeinterp.dat.datai,1);
        stddat = nanstd(pupil_rcg_scene_recombi{id,1}.eyeinterp.dat.datai,1);
        ZscoredTrials = (pupil_rcg_scene_recombi{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_rcg_scene_recombi{id,1}.eyeinterp.dat.datai,1),1))...
        ./repmat(stddat,size(pupil_rcg_scene_recombi{id,1}.eyeinterp.dat.datai,1),1);
        times=length(pupil_rcg_scene_recombi{id,1}.eyeinterp.time{1,1});
        meanPD_rcg_scene_emo_recombi(ec,1) = mean(nanmean(pupil_rcg_scene_recombi{id,1}.eyeinterp.dat.datai(:,1200:times),1));
        Zscore_PD_rcg_scene_emo_recombi{ec,1} = ZscoredTrials(:,1:times);
        Zscore_meanPD_rcg_scene_emo_recombi(ec,1) = mean(nanmean(ZscoredTrials(:,1200:times),1));
        plotdat_Zscore_meanPD_rcg_scene_emo_recombi(ec,:) = nanmean(ZscoredTrials(:,1:times),1);

        % --- objects --- %
        clear times ZscoredTrials stddat meandat
        meandat = nanmean(pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.datai,1);
        stddat = nanstd(pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.datai,1);
        ZscoredTrials = (pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.datai,1),1))...
        ./repmat(stddat,size(pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.datai,1),1);
        times=length(pupil_rcg_obj_recombi{id,1}.eyeinterp.time{1,1});
        meanPD_rcg_obj_emo_recombi(ec,1) = mean(nanmean(pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.datai(:,1200:times,:),1));
        Zscore_PD_rcg_obj_emo_recombi{ec,1} = ZscoredTrials(:,1:times);
        Zscore_meanPD_rcg_obj_emo_recombi(ec,1) = mean(nanmean(ZscoredTrials(:,1200:times),1));
        plotdat_Zscore_meanPD_rcg_obj_emo_recombi(ec,:) = nanmean(ZscoredTrials(:,1:times),1);

        % --- both --- %
        clear times ZscoredTrials stddat meandat
        meandat = nanmean(pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.datai,1);
        stddat = nanstd(pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.datai,1);
        ZscoredTrials = (pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.datai,1),1))...
        ./repmat(stddat,size(pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.datai,1),1);
        times=length(pupil_rcg_obj_recombi{id,1}.eyeinterp.time{1,1});
        meanPD_rcg_both_emo_recombi(ec,1) = mean(nanmean(pupil_rcg_both_recombi{id,1}.eyeinterp.dat.datai(:,1200:times),1));
        Zscore_PD_rcg_both_emo_recombi{ec,1} = ZscoredTrials(:,1:times);
        Zscore_meanPD_rcg_both_emo_recombi(ec,1) = mean(nanmean(ZscoredTrials(:,1200:times),1));
        plotdat_Zscore_meanPD_rcg_both_emo_recombi(ec,:) = nanmean(ZscoredTrials(:,1:times),1);


        % = accuracy based = %
        % --- scenes --- %
        meanPD_rcg_scene_correct_emo_recombi(ec,1) = meanPD_rcg_scene_correct_recombi(id,1);
        meanPD_rcg_scene_incorrect_emo_recombi(ec,1) = meanPD_rcg_scene_incorrect_recombi(id,1);
        meanPD_rcg_scene_FAinternal_emo_recombi(ec,1) = meanPD_rcg_scene_FAinternal_recombi(id,1);
        meanPD_rcg_scene_FAexternal_emo_recombi(ec,1) = meanPD_rcg_scene_FAexternal_recombi(id,1);

        Zscore_PD_rcg_scene_correct_emo_recombi(ec,1) = Zscore_PD_rcg_scene_correct_recombi(id,1);
        Zscore_PD_rcg_scene_incorrect_emo_recombi(ec,1) = Zscore_PD_rcg_scene_incorrect_recombi(id,1);
        Zscore_PD_rcg_scene_FAinternal_emo_recombi(ec,1) = Zscore_PD_rcg_scene_FAinternal_recombi(id,1);
        Zscore_PD_rcg_scene_FAexternal_emo_recombi(ec,1) = Zscore_PD_rcg_scene_FAexternal_recombi(id,1);

        plotdat_Zscore_meanPD_rcg_scene_correct_emo_recombi(ec,:) = plotdat_Zscore_meanPD_rcg_scene_correct_recombi(id,:);
        plotdat_Zscore_meanPD_rcg_scene_incorrect_emo_recombi(ec,:) = plotdat_Zscore_meanPD_rcg_scene_incorrect_recombi(id,:);
        plotdat_Zscore_meanPD_rcg_scene_FAinternal_emo_recombi(ec,:) = plotdat_Zscore_meanPD_rcg_scene_FAinternal_recombi(id,:);
        plotdat_Zscore_meanPD_rcg_scene_FAexternal_emo_recombi(ec,:) = plotdat_Zscore_meanPD_rcg_scene_FAexternal_recombi(id,:);

        Zscore_meanPD_rcg_scene_correct_emo_recombi(ec,1) = Zscore_meanPD_rcg_scene_correct_recombi(id,1);
        Zscore_meanPD_rcg_scene_incorrect_emo_recombi(ec,1) = Zscore_meanPD_rcg_scene_incorrect_recombi(id,1);
        Zscore_meanPD_rcg_scene_FAinternal_emo_recombi(ec,1) = Zscore_meanPD_rcg_scene_FAinternal_recombi(id,1);
        Zscore_meanPD_rcg_scene_FAexternal_emo_recombi(ec,1) = Zscore_meanPD_rcg_scene_FAexternal_recombi(id,1);

        % --- objects --- %
        meanPD_rcg_obj_correct_emo_recombi(ec,1) = meanPD_rcg_obj_correct_recombi(id,1);
        meanPD_rcg_obj_incorrect_emo_recombi(ec,1) = meanPD_rcg_obj_incorrect_recombi(id,1);
        meanPD_rcg_obj_FAinternal_emo_recombi(ec,1) = meanPD_rcg_obj_FAinternal_recombi(id,1);
        meanPD_rcg_obj_FAexternal_emo_recombi(ec,1) = meanPD_rcg_obj_FAexternal_recombi(id,1);

        Zscore_PD_rcg_obj_correct_emo_recombi(ec,1) = Zscore_PD_rcg_obj_correct_recombi(id,1);
        Zscore_PD_rcg_obj_incorrect_emo_recombi(ec,1) = Zscore_PD_rcg_obj_incorrect_recombi(id,1);
        Zscore_PD_rcg_obj_FAinternal_emo_recombi(ec,1) = Zscore_PD_rcg_obj_FAinternal_recombi(id,1);
        Zscore_PD_rcg_obj_FAexternal_emo_recombi(ec,1) = Zscore_PD_rcg_obj_FAexternal_recombi(id,1);

        plotdat_Zscore_meanPD_rcg_obj_correct_emo_recombi(ec,:) = plotdat_Zscore_meanPD_rcg_obj_correct_recombi(id,:);
        plotdat_Zscore_meanPD_rcg_obj_incorrect_emo_recombi(ec,:) = plotdat_Zscore_meanPD_rcg_obj_incorrect_recombi(id,:);
        plotdat_Zscore_meanPD_rcg_obj_FAinternal_emo_recombi(ec,:) = plotdat_Zscore_meanPD_rcg_obj_FAinternal_recombi(id,:);
        plotdat_Zscore_meanPD_rcg_obj_FAexternal_emo_recombi(ec,:) = plotdat_Zscore_meanPD_rcg_obj_FAexternal_recombi(id,:);

        Zscore_meanPD_rcg_obj_correct_emo_recombi(ec,1) = Zscore_meanPD_rcg_obj_correct_recombi(id,1);
        Zscore_meanPD_rcg_obj_incorrect_emo_recombi(ec,1) = Zscore_meanPD_rcg_obj_incorrect_recombi(id,1);
        Zscore_meanPD_rcg_obj_FAinternal_emo_recombi(ec,1) = Zscore_meanPD_rcg_obj_FAinternal_recombi(id,1);
        Zscore_meanPD_rcg_obj_FAexternal_emo_recombi(ec,1) = Zscore_meanPD_rcg_obj_FAexternal_recombi(id,1);

        % --- both --- %
        meanPD_rcg_both_correct_emo_recombi(ec,1) = meanPD_rcg_both_correct_recombi(id,1);
        meanPD_rcg_both_incorrect_emo_recombi(ec,1) = meanPD_rcg_both_incorrect_recombi(id,1);
        meanPD_rcg_both_FAinternal_emo_recombi(ec,1) = meanPD_rcg_both_FAinternal_recombi(id,1);
        meanPD_rcg_both_FAexternal_emo_recombi(ec,1) = meanPD_rcg_both_FAexternal_recombi(id,1);

        Zscore_PD_rcg_both_correct_emo_recombi(ec,1) = Zscore_PD_rcg_both_correct_recombi(id,1);
        Zscore_PD_rcg_both_incorrect_emo_recombi(ec,1) = Zscore_PD_rcg_both_incorrect_recombi(id,1);
        Zscore_PD_rcg_both_FAinternal_emo_recombi(ec,1) = Zscore_PD_rcg_both_FAinternal_recombi(id,1);
        Zscore_PD_rcg_both_FAexternal_emo_recombi(ec,1) = Zscore_PD_rcg_both_FAexternal_recombi(id,1);

        plotdat_Zscore_meanPD_rcg_both_correct_emo_recombi(ec,:) = plotdat_Zscore_meanPD_rcg_both_correct_recombi(id,:);
        plotdat_Zscore_meanPD_rcg_both_incorrect_emo_recombi(ec,:) = plotdat_Zscore_meanPD_rcg_both_incorrect_recombi(id,:);
        plotdat_Zscore_meanPD_rcg_both_FAinternal_emo_recombi(ec,:) = plotdat_Zscore_meanPD_rcg_both_FAinternal_recombi(id,:);
        plotdat_Zscore_meanPD_rcg_both_FAexternal_emo_recombi(ec,:) = plotdat_Zscore_meanPD_rcg_both_FAexternal_recombi(id,:);

        Zscore_meanPD_rcg_both_correct_emo_recombi(ec,1) = Zscore_meanPD_rcg_both_correct_recombi(id,1);
        Zscore_meanPD_rcg_both_incorrect_emo_recombi(ec,1) = Zscore_meanPD_rcg_both_incorrect_recombi(id,1);
        Zscore_meanPD_rcg_both_FAinternal_emo_recombi(ec,1) = Zscore_meanPD_rcg_both_FAinternal_recombi(id,1);
        Zscore_meanPD_rcg_both_FAexternal_emo_recombi(ec,1) = Zscore_meanPD_rcg_both_FAexternal_recombi(id,1);


    elseif cond(id)==2

        % if id==18
        % else
            nc=nc+1;
        % end

        
        % === first: encoding === %

        % --- scenes --- %

        if id==18
        meanPD_enc_scene_neu_recombi(nc,1) = NaN;
        Zscore_PD_enc_scene_neu_recombi{nc,1} = nan(1,3701);
        Zscore_meanPD_enc_scene_neu_recombi(nc,1) = NaN;
        plotdat_Zscore_meanPD_enc_scene_neu_recombi(nc,:) = nan(1,3701);
        else
        clear times ZscoredTrials stddat meandat
        meandat = nanmean(pupil_enc_scene_recombi{id,1}.eyeinterp.dat.datai,1);
        stddat = nanstd(pupil_enc_scene_recombi{id,1}.eyeinterp.dat.datai,1);
        ZscoredTrials = (pupil_enc_scene_recombi{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_enc_scene_recombi{id,1}.eyeinterp.dat.datai,1),1))...
        ./repmat(stddat,size(pupil_enc_scene_recombi{id,1}.eyeinterp.dat.datai,1),1);
        times=length(pupil_enc_scene_recombi{id,1}.eyeinterp.time{1,1});
        meanPD_enc_scene_neu_recombi(nc,1) = mean(nanmean(pupil_enc_scene_recombi{id,1}.eyeinterp.dat.datai(:,1200:times),1));
        Zscore_PD_enc_scene_neu_recombi{nc,1} = ZscoredTrials(:,1:times);
        Zscore_meanPD_enc_scene_neu_recombi(nc,1) = mean(nanmean(ZscoredTrials(:,1200:times),1));
        plotdat_Zscore_meanPD_enc_scene_neu_recombi(nc,:) = nanmean(ZscoredTrials(:,1:times),1);
        end

        % --- objects --- %
        clear times ZscoredTrials stddat meandat
        meandat = nanmean(pupil_enc_obj_recombi{id,1}.eyeinterp.dat.datai,1);
        stddat = nanstd(pupil_enc_obj_recombi{id,1}.eyeinterp.dat.datai,1);
        ZscoredTrials = (pupil_enc_obj_recombi{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_enc_obj_recombi{id,1}.eyeinterp.dat.datai,1),1))...
        ./repmat(stddat,size(pupil_enc_obj_recombi{id,1}.eyeinterp.dat.datai,1),1);
        times=length(pupil_enc_obj_recombi{id,1}.eyeinterp.time{1,1});
        meanPD_enc_obj_neu_recombi(nc,1) = mean(nanmean(pupil_enc_obj_recombi{id,1}.eyeinterp.dat.datai(:,1200:times,:),1));
        Zscore_PD_enc_obj_neu_recombi{nc,1} = ZscoredTrials(:,1:times);
        Zscore_meanPD_enc_obj_neu_recombi(nc,1) = mean(nanmean(ZscoredTrials(:,1200:times),1));
        plotdat_Zscore_meanPD_enc_obj_neu_recombi(nc,:) = nanmean(ZscoredTrials(:,1:times),1);

        % ========================= %


        
        % === next: recognition === %

        % --- scenes --- %
        clear times ZscoredTrials stddat meandat
        meandat = nanmean(pupil_rcg_scene_recombi{id,1}.eyeinterp.dat.datai,1);
        stddat = nanstd(pupil_rcg_scene_recombi{id,1}.eyeinterp.dat.datai,1);
        ZscoredTrials = (pupil_rcg_scene_recombi{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_rcg_scene_recombi{id,1}.eyeinterp.dat.datai,1),1))...
        ./repmat(stddat,size(pupil_rcg_scene_recombi{id,1}.eyeinterp.dat.datai,1),1);
        times=length(pupil_rcg_scene_recombi{id,1}.eyeinterp.time{1,1});
        meanPD_rcg_scene_neu_recombi(nc,1) = mean(nanmean(pupil_rcg_scene_recombi{id,1}.eyeinterp.dat.datai(:,1200:times),1));
        Zscore_PD_rcg_scene_neu_recombi{nc,1} = ZscoredTrials(:,1:times);
        Zscore_meanPD_rcg_scene_neu_recombi(nc,1) = mean(nanmean(ZscoredTrials(:,1200:times),1));
        plotdat_Zscore_meanPD_rcg_scene_neu_recombi(nc,:) = nanmean(ZscoredTrials(:,1:times),1);

        % --- objects --- %
        clear times ZscoredTrials stddat meandat
        meandat = nanmean(pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.datai,1);
        stddat = nanstd(pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.datai,1);
        ZscoredTrials = (pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.datai,1),1))...
        ./repmat(stddat,size(pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.datai,1),1);
        times=length(pupil_rcg_obj_recombi{id,1}.eyeinterp.time{1,1});
        meanPD_rcg_obj_neu_recombi(nc,1) = mean(nanmean(pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.datai(:,1200:times,:),1));
        Zscore_PD_rcg_obj_neu_recombi{nc,1} = ZscoredTrials(:,1:times);
        Zscore_meanPD_rcg_obj_neu_recombi(nc,1) = mean(nanmean(ZscoredTrials(:,1200:times),1));
        plotdat_Zscore_meanPD_rcg_obj_neu_recombi(nc,:) = nanmean(ZscoredTrials(:,1:times),1);

        % --- both --- %
        clear times ZscoredTrials stddat meandat
        meandat = nanmean(pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.datai,1);
        stddat = nanstd(pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.datai,1);
        ZscoredTrials = (pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.datai - repmat(meandat,size(pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.datai,1),1))...
        ./repmat(stddat,size(pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.datai,1),1);
        times=length(pupil_rcg_obj_recombi{id,1}.eyeinterp.time{1,1});
        meanPD_rcg_both_neu_recombi(nc,1) = mean(nanmean(pupil_rcg_both_recombi{id,1}.eyeinterp.dat.datai(:,1200:times),1));
        Zscore_PD_rcg_both_neu_recombi{nc,1} = ZscoredTrials(:,1:times);
        Zscore_meanPD_rcg_both_neu_recombi(nc,1) = mean(nanmean(ZscoredTrials(:,1200:times),1));
        plotdat_Zscore_meanPD_rcg_both_neu_recombi(nc,:) = nanmean(ZscoredTrials(:,1:times),1);

        % = accuracy based = %
        % --- scenes --- %
        meanPD_rcg_scene_correct_neu_recombi(nc,1) = meanPD_rcg_scene_correct_recombi(id,1);
        meanPD_rcg_scene_incorrect_neu_recombi(nc,1) = meanPD_rcg_scene_incorrect_recombi(id,1);
        meanPD_rcg_scene_FAinternal_neu_recombi(nc,1) = meanPD_rcg_scene_FAinternal_recombi(id,1);
        meanPD_rcg_scene_FAexternal_neu_recombi(nc,1) = meanPD_rcg_scene_FAexternal_recombi(id,1);

        Zscore_PD_rcg_scene_correct_neu_recombi(nc,1) = Zscore_PD_rcg_scene_correct_recombi(id,1);
        Zscore_PD_rcg_scene_incorrect_neu_recombi(nc,1) = Zscore_PD_rcg_scene_incorrect_recombi(id,1);
        Zscore_PD_rcg_scene_FAinternal_neu_recombi(nc,1) = Zscore_PD_rcg_scene_FAinternal_recombi(id,1);
        Zscore_PD_rcg_scene_FAexternal_neu_recombi(nc,1) = Zscore_PD_rcg_scene_FAexternal_recombi(id,1);

        plotdat_Zscore_meanPD_rcg_scene_correct_neu_recombi(nc,:) = plotdat_Zscore_meanPD_rcg_scene_correct_recombi(id,:);
        plotdat_Zscore_meanPD_rcg_scene_incorrect_neu_recombi(nc,:) = plotdat_Zscore_meanPD_rcg_scene_incorrect_recombi(id,:);
        plotdat_Zscore_meanPD_rcg_scene_FAinternal_neu_recombi(nc,:) = plotdat_Zscore_meanPD_rcg_scene_FAinternal_recombi(id,:);
        plotdat_Zscore_meanPD_rcg_scene_FAexternal_neu_recombi(nc,:) = plotdat_Zscore_meanPD_rcg_scene_FAexternal_recombi(id,:);

        Zscore_meanPD_rcg_scene_correct_neu_recombi(nc,1) = Zscore_meanPD_rcg_scene_correct_recombi(id,1);
        Zscore_meanPD_rcg_scene_incorrect_neu_recombi(nc,1) = Zscore_meanPD_rcg_scene_incorrect_recombi(id,1);
        Zscore_meanPD_rcg_scene_FAinternal_neu_recombi(nc,1) = Zscore_meanPD_rcg_scene_FAinternal_recombi(id,1);
        Zscore_meanPD_rcg_scene_FAexternal_neu_recombi(nc,1) = Zscore_meanPD_rcg_scene_FAexternal_recombi(id,1);

        % --- objects --- %
        meanPD_rcg_obj_correct_neu_recombi(nc,1) = meanPD_rcg_obj_correct_recombi(id,1);
        meanPD_rcg_obj_incorrect_neu_recombi(nc,1) = meanPD_rcg_obj_incorrect_recombi(id,1);
        meanPD_rcg_obj_FAinternal_neu_recombi(nc,1) = meanPD_rcg_obj_FAinternal_recombi(id,1);
        meanPD_rcg_obj_FAexternal_neu_recombi(nc,1) = meanPD_rcg_obj_FAexternal_recombi(id,1);

        Zscore_PD_rcg_obj_correct_neu_recombi(nc,1) = Zscore_PD_rcg_obj_correct_recombi(id,1);
        Zscore_PD_rcg_obj_incorrect_neu_recombi(nc,1) = Zscore_PD_rcg_obj_incorrect_recombi(id,1);
        Zscore_PD_rcg_obj_FAinternal_neu_recombi(nc,1) = Zscore_PD_rcg_obj_FAinternal_recombi(id,1);
        Zscore_PD_rcg_obj_FAexternal_neu_recombi(nc,1) = Zscore_PD_rcg_obj_FAexternal_recombi(id,1);

        plotdat_Zscore_meanPD_rcg_obj_correct_neu_recombi(nc,:) = plotdat_Zscore_meanPD_rcg_obj_correct_recombi(id,:);
        plotdat_Zscore_meanPD_rcg_obj_incorrect_neu_recombi(nc,:) = plotdat_Zscore_meanPD_rcg_obj_incorrect_recombi(id,:);
        plotdat_Zscore_meanPD_rcg_obj_FAinternal_neu_recombi(nc,:) = plotdat_Zscore_meanPD_rcg_obj_FAinternal_recombi(id,:);
        plotdat_Zscore_meanPD_rcg_obj_FAexternal_neu_recombi(nc,:) = plotdat_Zscore_meanPD_rcg_obj_FAexternal_recombi(id,:);

        Zscore_meanPD_rcg_obj_correct_neu_recombi(nc,1) = Zscore_meanPD_rcg_obj_correct_recombi(id,1);
        Zscore_meanPD_rcg_obj_incorrect_neu_recombi(nc,1) = Zscore_meanPD_rcg_obj_incorrect_recombi(id,1);
        Zscore_meanPD_rcg_obj_FAinternal_neu_recombi(nc,1) = Zscore_meanPD_rcg_obj_FAinternal_recombi(id,1);
        Zscore_meanPD_rcg_obj_FAexternal_neu_recombi(nc,1) = Zscore_meanPD_rcg_obj_FAexternal_recombi(id,1);

        % --- both --- %
        meanPD_rcg_both_correct_neu_recombi(nc,1) = meanPD_rcg_both_correct_recombi(id,1);
        meanPD_rcg_both_incorrect_neu_recombi(nc,1) = meanPD_rcg_both_incorrect_recombi(id,1);
        meanPD_rcg_both_FAinternal_neu_recombi(nc,1) = meanPD_rcg_both_FAinternal_recombi(id,1);
        meanPD_rcg_both_FAexternal_neu_recombi(nc,1) = meanPD_rcg_both_FAexternal_recombi(id,1);

        Zscore_PD_rcg_both_correct_neu_recombi(nc,1) = Zscore_PD_rcg_both_correct_recombi(id,1);
        Zscore_PD_rcg_both_incorrect_neu_recombi(nc,1) = Zscore_PD_rcg_both_incorrect_recombi(id,1);
        Zscore_PD_rcg_both_FAinternal_neu_recombi(nc,1) = Zscore_PD_rcg_both_FAinternal_recombi(id,1);
        Zscore_PD_rcg_both_FAexternal_neu_recombi(nc,1) = Zscore_PD_rcg_both_FAexternal_recombi(id,1);

        plotdat_Zscore_meanPD_rcg_both_correct_neu_recombi(nc,:) = plotdat_Zscore_meanPD_rcg_both_correct_recombi(id,:);
        plotdat_Zscore_meanPD_rcg_both_incorrect_neu_recombi(nc,:) = plotdat_Zscore_meanPD_rcg_both_incorrect_recombi(id,:);
        plotdat_Zscore_meanPD_rcg_both_FAinternal_neu_recombi(nc,:) = plotdat_Zscore_meanPD_rcg_both_FAinternal_recombi(id,:);
        plotdat_Zscore_meanPD_rcg_both_FAexternal_neu_recombi(nc,:) = plotdat_Zscore_meanPD_rcg_both_FAexternal_recombi(id,:);

        Zscore_meanPD_rcg_both_correct_neu_recombi(nc,1) = Zscore_meanPD_rcg_both_correct_recombi(id,1);
        Zscore_meanPD_rcg_both_incorrect_neu_recombi(nc,1) = Zscore_meanPD_rcg_both_incorrect_recombi(id,1);
        Zscore_meanPD_rcg_both_FAinternal_neu_recombi(nc,1) = Zscore_meanPD_rcg_both_FAinternal_recombi(id,1);
        Zscore_meanPD_rcg_both_FAexternal_neu_recombi(nc,1) = Zscore_meanPD_rcg_both_FAexternal_recombi(id,1);


    end
end



%% only baseline corrected
 
%% process pupil data, session 1

ec=0; nc=0;

for id=1:length(ids)

    % accuracy based

    % --- scenes --- %
    
    if id==18
    meanPD_BSL_rcg_scene_correct_orig(id,1) = NaN;
    meanPD_BSL_rcg_scene_incorrect_orig(id,1) = NaN;
    meanPD_BSL_rcg_scene_FAinternal_orig(id,1) = NaN;
    meanPD_BSL_rcg_scene_FAexternal_orig(id,1) = NaN;

    BSLcorr_PD_rcg_scene_correct_orig{id,1} = nan(1,3701);
    BSLcorr_meanPD_rcg_scene_correct_orig(id,1) = NaN;
    plotdat_BSLcorr_meanPD_rcg_scene_correct_orig(id,:)=NaN;

    BSLcorr_PD_rcg_scene_incorrect_orig{id,1} = nan(1,3701);
    BSLcorr_meanPD_rcg_scene_incorrect_orig(id,1) = NaN;
    plotdat_BSLcorr_meanPD_rcg_scene_incorrect_orig(id,:)=NaN;

    BSLcorr_PD_rcg_scene_FAinternal_orig{id,1} = nan(1,3701);
    BSLcorr_meanPD_rcg_scene_FAinternal_orig(id,1) = NaN;
    plotdat_BSLcorr_meanPD_rcg_scene_FAinternal_orig(id,:)=NaN;

    BSLcorr_PD_rcg_scene_FAexternal_orig{id,1} = nan(1,3701);
    BSLcorr_meanPD_rcg_scene_FAexternal_orig(id,1) = NaN;
    plotdat_BSLcorr_meanPD_rcg_scene_FAexternal_orig(id,:) = NaN;

    else

    clear tmpacc times meanBSL dat BSLcorrdTrials

    dat=pupil_rcg_scene_orig{id,1}.eyeinterp.dat.datai;
    meanBSL = nanmean(dat(:,1:200)');
    BSLcorrdTrials = dat-repmat(meanBSL',1,size(dat,2));

    times=2500;%length(pupil_rcg_scene_orig{id,1}.eyeinterp.time{1,1});  
    tmpacc=accuracies_dat{id};
    tmpacc(pupil_rcg_scene_orig{id,1}.eyeinterp.dat.trl_raus==1)=[];
    meanPD_BSL_rcg_scene_correct_orig(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc==1,1200:times),1));
    meanPD_BSL_rcg_scene_incorrect_orig(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc~=1,1200:times),1));
    meanPD_BSL_rcg_scene_FAinternal_orig(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc==-1,1200:times),1));
    meanPD_BSL_rcg_scene_FAexternal_orig(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc==0,1200:times),1));

    BSLcorr_PD_rcg_scene_correct_orig{id,1} = BSLcorrdTrials(tmpacc==1,1:times);
    BSLcorr_meanPD_rcg_scene_correct_orig(id,1) = mean(BSLcorr_PD_rcg_scene_correct_orig{id,1}(:,1200:times),'all');
    plotdat_BSLcorr_meanPD_rcg_scene_correct_orig(id,:)=nanmean(BSLcorr_PD_rcg_scene_correct_orig{id,1}(:,1:times),1);

    BSLcorr_PD_rcg_scene_incorrect_orig{id,1} = BSLcorrdTrials(tmpacc~=1,1:times);
    BSLcorr_meanPD_rcg_scene_incorrect_orig(id,1) = mean(nanmean(BSLcorr_PD_rcg_scene_incorrect_orig{id,1}(:,1200:times),1));
    plotdat_BSLcorr_meanPD_rcg_scene_incorrect_orig(id,:)=nanmean(BSLcorr_PD_rcg_scene_incorrect_orig{id,1}(:,1:times),1);

    BSLcorr_PD_rcg_scene_FAinternal_orig{id,1} = BSLcorrdTrials(tmpacc==-1,1:times);
    BSLcorr_meanPD_rcg_scene_FAinternal_orig(id,1) = mean(nanmean(BSLcorr_PD_rcg_scene_FAinternal_orig{id,1}(:,1200:times),1));
    plotdat_BSLcorr_meanPD_rcg_scene_FAinternal_orig(id,:)=nanmean(BSLcorr_PD_rcg_scene_FAinternal_orig{id,1}(:,1:times),1);

    BSLcorr_PD_rcg_scene_FAexternal_orig{id,1} = BSLcorrdTrials(tmpacc==0,1:times);
    BSLcorr_meanPD_rcg_scene_FAexternal_orig(id,1) = mean(nanmean(BSLcorr_PD_rcg_scene_FAexternal_orig{id,1}(:,1200:times),1));
    plotdat_BSLcorr_meanPD_rcg_scene_FAexternal_orig(id,:) = nanmean(BSLcorr_PD_rcg_scene_FAexternal_orig{id,1}(:,1:times),1);
    end


    % --- objects --- %
    clear tmpacc times meanBSL dat BSLcorrdTrials

    dat=pupil_rcg_obj_orig{id,1}.eyeinterp.dat.datai;
    meanBSL = nanmean(dat(:,1:200)');
    BSLcorrdTrials = dat-repmat(meanBSL',1,size(dat,2));

    times=length(pupil_rcg_obj_orig{id,1}.eyeinterp.time{1,1});  
    tmpacc=accuracies_dat{id};
    tmpacc(pupil_rcg_obj_orig{id,1}.eyeinterp.dat.trl_raus==1)=[];
    meanPD_BSL_rcg_obj_correct_orig(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc==1,1200:times),1));
    meanPD_BSL_rcg_obj_incorrect_orig(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc~=1,1200:times),1));
    meanPD_BSL_rcg_obj_FAinternal_orig(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc==-1,1200:times),1));
    meanPD_BSL_rcg_obj_FAexternal_orig(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc==0,1200:times),1));

    BSLcorr_PD_rcg_obj_correct_orig{id,1} = BSLcorrdTrials(tmpacc==1,1:times);
    BSLcorr_meanPD_rcg_obj_correct_orig(id,1) = mean(nanmean(BSLcorr_PD_rcg_obj_correct_orig{id,1}(:,1200:times),1));
    plotdat_BSLcorr_meanPD_rcg_obj_correct_orig(id,:) = nanmean(BSLcorr_PD_rcg_obj_correct_orig{id,1}(:,1:times),1);

    BSLcorr_PD_rcg_obj_incorrect_orig{id,1} = BSLcorrdTrials(tmpacc~=1,1:times);
    BSLcorr_meanPD_rcg_obj_incorrect_orig(id,1) = mean(nanmean(BSLcorr_PD_rcg_obj_incorrect_orig{id,1}(:,1200:times),1));
    plotdat_BSLcorr_meanPD_rcg_obj_incorrect_orig(id,:) = nanmean(BSLcorr_PD_rcg_obj_incorrect_orig{id,1}(:,1:times),1);

    BSLcorr_PD_rcg_obj_FAinternal_orig{id,1} = BSLcorrdTrials(tmpacc==-1,1:times);
    BSLcorr_meanPD_rcg_obj_FAinternal_orig(id,1) = mean(nanmean(BSLcorr_PD_rcg_obj_FAinternal_orig{id,1}(:,1200:times),1));
    plotdat_BSLcorr_meanPD_rcg_obj_FAinternal_orig(id,:) = nanmean(BSLcorr_PD_rcg_obj_FAinternal_orig{id,1}(:,1:times),1);

    BSLcorr_PD_rcg_obj_FAexternal_orig{id,1} = BSLcorrdTrials(tmpacc==0,1:times);
    BSLcorr_meanPD_rcg_obj_FAexternal_orig(id,1) = mean(nanmean(BSLcorr_PD_rcg_obj_FAexternal_orig{id,1}(:,1200:times),1));
    plotdat_BSLcorr_meanPD_rcg_obj_FAexternal_orig(id,:) = nanmean(BSLcorr_PD_rcg_obj_FAexternal_orig{id,1}(:,1:times),1);

    % --- both --- %
    clear tmpacc times meanBSL dat BSLcorrdTrials

    dat=pupil_rcg_both_orig{id,1}.eyeinterp.dat.datai;
    meanBSL = nanmean(dat(:,1:200)');
    BSLcorrdTrials = dat-repmat(meanBSL',1,size(dat,2));

    times=length(pupil_rcg_both_orig{id,1}.eyeinterp.time{1,1});  
    tmpacc=accuracies_dat{id};
    tmpacc(pupil_rcg_both_orig{id,1}.eyeinterp.dat.trl_raus==1)=[];
    meanPD_BSL_rcg_both_correct_orig(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc==1,1200:times),1));
    meanPD_BSL_rcg_both_incorrect_orig(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc~=1,1200:times),1));
    meanPD_BSL_rcg_both_FAinternal_orig(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc==-1,1200:times),1));
    meanPD_BSL_rcg_both_FAexternal_orig(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc==0,1200:times),1));

    BSLcorr_PD_rcg_both_correct_orig{id,1} = BSLcorrdTrials(tmpacc==1,1:times);
    BSLcorr_meanPD_rcg_both_correct_orig(id,1) = mean(nanmean(BSLcorr_PD_rcg_both_correct_orig{id,1}(:,1200:times),1));
    plotdat_BSLcorr_meanPD_rcg_both_correct_orig(id,:) = nanmean(BSLcorr_PD_rcg_both_correct_orig{id,1}(:,1:times),1);

    BSLcorr_PD_rcg_both_incorrect_orig{id,1} = BSLcorrdTrials(tmpacc~=1,1:times);
    BSLcorr_meanPD_rcg_both_incorrect_orig(id,1) = mean(nanmean(BSLcorr_PD_rcg_both_incorrect_orig{id,1}(:,1200:times),1));
    plotdat_BSLcorr_meanPD_rcg_both_incorrect_orig(id,:) = nanmean(BSLcorr_PD_rcg_both_incorrect_orig{id,1}(:,1:times),1);

    BSLcorr_PD_rcg_both_FAinternal_orig{id,1} = BSLcorrdTrials(tmpacc==-1,1:times);
    BSLcorr_meanPD_rcg_both_FAinternal_orig(id,:) = mean(nanmean(BSLcorr_PD_rcg_both_FAinternal_orig{id,1}(:,1:times),1));
    plotdat_BSLcorr_meanPD_rcg_both_FAinternal_orig(id,:) = nanmean(BSLcorr_PD_rcg_both_FAinternal_orig{id,1}(:,1:times),1);

    BSLcorr_PD_rcg_both_FAexternal_orig{id,1} = BSLcorrdTrials(tmpacc==0,1:times);
    BSLcorr_meanPD_rcg_both_FAexternal_orig(id,:) = mean(nanmean(BSLcorr_PD_rcg_both_FAexternal_orig{id,1}(:,1:times),1));
    plotdat_BSLcorr_meanPD_rcg_both_FAexternal_orig(id,:) = nanmean(BSLcorr_PD_rcg_both_FAexternal_orig{id,1}(:,1:times),1);

    
    if cond(id)==1

        ec=ec+1;

        % === first: encoding === %

        % --- scenes --- %
        clear tmpacc times meanBSL dat BSLcorrdTrials

        dat=pupil_enc_scene_orig{id,1}.eyeinterp.dat.datai;
        meanBSL = nanmean(dat(:,1:200)');
        BSLcorrdTrials = dat-repmat(meanBSL',1,size(dat,2));

        times=length(pupil_enc_scene_orig{id,1}.eyeinterp.time{1,1});
        meanPD_BSL_enc_scene_emo_orig(ec,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        BSLcorr_PD_enc_scene_emo_orig{ec,1} = BSLcorrdTrials(:,1:times);
        BSLcorr_meanPD_enc_scene_emo_orig(ec,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        plotdat_BSLcorr_meanPD_enc_scene_emo_orig(ec,:) = nanmean(BSLcorrdTrials(:,1:times),1);

        % --- objects --- %
        clear tmpacc times meanBSL dat BSLcorrdTrials

        dat=pupil_enc_obj_orig{id,1}.eyeinterp.dat.datai;
        meanBSL = nanmean(dat(:,1:200)');
        BSLcorrdTrials = dat-repmat(meanBSL',1,size(dat,2));

        times=length(pupil_enc_obj_orig{id,1}.eyeinterp.time{1,1});
        meanPD_BSL_enc_obj_emo_orig(ec,1) = mean(nanmean(BSLcorrdTrials(:,1200:times,:),1));
        BSLcorr_PD_enc_obj_emo_orig{ec,1} = BSLcorrdTrials(:,1:times);
        BSLcorr_meanPD_enc_obj_emo_orig(ec,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        plotdat_BSLcorr_meanPD_enc_obj_emo_orig(ec,:) = nanmean(BSLcorrdTrials(:,1:times),1);

        % ========================= %


        
        % === next: recognition === %

        % --- scenes --- %
        clear tmpacc times meanBSL dat BSLcorrdTrials

        dat=pupil_rcg_scene_orig{id,1}.eyeinterp.dat.datai;
        meanBSL = nanmean(dat(:,1:200)');
        BSLcorrdTrials = dat-repmat(meanBSL',1,size(dat,2));

        times=length(pupil_rcg_scene_orig{id,1}.eyeinterp.time{1,1});
        meanPD_BSL_rcg_scene_emo_orig(ec,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        BSLcorr_PD_rcg_scene_emo_orig{ec,1} = BSLcorrdTrials(:,1:times);
        BSLcorr_meanPD_rcg_scene_emo_orig(ec,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        plotdat_BSLcorr_meanPD_rcg_scene_emo_orig(ec,:) = nanmean(BSLcorrdTrials(:,1:times),1);

        % --- objects --- %
        clear tmpacc times meanBSL dat BSLcorrdTrials

        dat=pupil_rcg_obj_orig{id,1}.eyeinterp.dat.datai;
        meanBSL = nanmean(dat(:,1:200)');
        BSLcorrdTrials = dat-repmat(meanBSL',1,size(dat,2));

        times=length(pupil_rcg_obj_orig{id,1}.eyeinterp.time{1,1});
        meanPD_BSL_rcg_obj_emo_orig(ec,1) = mean(nanmean(BSLcorrdTrials(:,1200:times,:),1));
        BSLcorr_PD_rcg_obj_emo_orig{ec,1} = BSLcorrdTrials(:,1:times);
        BSLcorr_meanPD_rcg_obj_emo_orig(ec,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        plotdat_BSLcorr_meanPD_rcg_obj_emo_orig(ec,:) = nanmean(BSLcorrdTrials(:,1:times),1);

        % --- both --- %
        clear tmpacc times meanBSL dat BSLcorrdTrials

        dat=pupil_rcg_both_orig{id,1}.eyeinterp.dat.datai;
        meanBSL = nanmean(dat(:,1:200)');
        BSLcorrdTrials = dat-repmat(meanBSL',1,size(dat,2));

        times=length(pupil_rcg_both_orig{id,1}.eyeinterp.time{1,1});
        meanPD_BSL_rcg_both_emo_orig(ec,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        BSLcorr_PD_rcg_both_emo_orig{ec,1} = BSLcorrdTrials(:,1:times);
        BSLcorr_meanPD_rcg_both_emo_orig(ec,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        plotdat_BSLcorr_meanPD_rcg_both_emo_orig(ec,:) = nanmean(BSLcorrdTrials(:,1:times),1);


        % = accuracy based = %
        % --- scenes --- %
        meanPD_BSL_rcg_scene_correct_emo_orig(ec,1) = meanPD_BSL_rcg_scene_correct_orig(id,1);
        meanPD_BSL_rcg_scene_incorrect_emo_orig(ec,1) = meanPD_BSL_rcg_scene_incorrect_orig(id,1);
        meanPD_BSL_rcg_scene_FAinternal_emo_orig(ec,1) = meanPD_BSL_rcg_scene_FAinternal_orig(id,1);
        meanPD_BSL_rcg_scene_FAexternal_emo_orig(ec,1) = meanPD_BSL_rcg_scene_FAexternal_orig(id,1);

        BSLcorr_PD_rcg_scene_correct_emo_orig(ec,1) = BSLcorr_PD_rcg_scene_correct_orig(id,1);
        BSLcorr_PD_rcg_scene_incorrect_emo_orig(ec,1) = BSLcorr_PD_rcg_scene_incorrect_orig(id,1);
        BSLcorr_PD_rcg_scene_FAinternal_emo_orig(ec,1) = BSLcorr_PD_rcg_scene_FAinternal_orig(id,1);
        BSLcorr_PD_rcg_scene_FAexternal_emo_orig(ec,1) = BSLcorr_PD_rcg_scene_FAexternal_orig(id,1);

        plotdat_BSLcorr_meanPD_rcg_scene_correct_emo_orig(ec,:) = plotdat_BSLcorr_meanPD_rcg_scene_correct_orig(id,:);
        plotdat_BSLcorr_meanPD_rcg_scene_incorrect_emo_orig(ec,:) = plotdat_BSLcorr_meanPD_rcg_scene_incorrect_orig(id,:);
        plotdat_BSLcorr_meanPD_rcg_scene_FAinternal_emo_orig(ec,:) = plotdat_BSLcorr_meanPD_rcg_scene_FAinternal_orig(id,:);
        plotdat_BSLcorr_meanPD_rcg_scene_FAexternal_emo_orig(ec,:) = plotdat_BSLcorr_meanPD_rcg_scene_FAexternal_orig(id,:);

        BSLcorr_meanPD_rcg_scene_correct_emo_orig(ec,1) = BSLcorr_meanPD_rcg_scene_correct_orig(id,1);
        BSLcorr_meanPD_rcg_scene_incorrect_emo_orig(ec,1) = BSLcorr_meanPD_rcg_scene_incorrect_orig(id,1);
        BSLcorr_meanPD_rcg_scene_FAinternal_emo_orig(ec,1) = BSLcorr_meanPD_rcg_scene_FAinternal_orig(id,1);
        BSLcorr_meanPD_rcg_scene_FAexternal_emo_orig(ec,1) = BSLcorr_meanPD_rcg_scene_FAexternal_orig(id,1);

        % --- objects --- %
        meanPD_BSL_rcg_obj_correct_emo_orig(ec,1) = meanPD_BSL_rcg_obj_correct_orig(id,1);
        meanPD_BSL_rcg_obj_incorrect_emo_orig(ec,1) = meanPD_BSL_rcg_obj_incorrect_orig(id,1);
        meanPD_BSL_rcg_obj_FAinternal_emo_orig(ec,1) = meanPD_BSL_rcg_obj_FAinternal_orig(id,1);
        meanPD_BSL_rcg_obj_FAexternal_emo_orig(ec,1) = meanPD_BSL_rcg_obj_FAexternal_orig(id,1);

        BSLcorr_PD_rcg_obj_correct_emo_orig(ec,1) = BSLcorr_PD_rcg_obj_correct_orig(id,1);
        BSLcorr_PD_rcg_obj_incorrect_emo_orig(ec,1) = BSLcorr_PD_rcg_obj_incorrect_orig(id,1);
        BSLcorr_PD_rcg_obj_FAinternal_emo_orig(ec,1) = BSLcorr_PD_rcg_obj_FAinternal_orig(id,1);
        BSLcorr_PD_rcg_obj_FAexternal_emo_orig(ec,1) = BSLcorr_PD_rcg_obj_FAexternal_orig(id,1);

        plotdat_BSLcorr_meanPD_rcg_obj_correct_emo_orig(ec,:) = plotdat_BSLcorr_meanPD_rcg_obj_correct_orig(id,:);
        plotdat_BSLcorr_meanPD_rcg_obj_incorrect_emo_orig(ec,:) = plotdat_BSLcorr_meanPD_rcg_obj_incorrect_orig(id,:);
        plotdat_BSLcorr_meanPD_rcg_obj_FAinternal_emo_orig(ec,:) = plotdat_BSLcorr_meanPD_rcg_obj_FAinternal_orig(id,:);
        plotdat_BSLcorr_meanPD_rcg_obj_FAexternal_emo_orig(ec,:) = plotdat_BSLcorr_meanPD_rcg_obj_FAexternal_orig(id,:);

        BSLcorr_meanPD_rcg_obj_correct_emo_orig(ec,1) = BSLcorr_meanPD_rcg_obj_correct_orig(id,1);
        BSLcorr_meanPD_rcg_obj_incorrect_emo_orig(ec,1) = BSLcorr_meanPD_rcg_obj_incorrect_orig(id,1);
        BSLcorr_meanPD_rcg_obj_FAinternal_emo_orig(ec,1) = BSLcorr_meanPD_rcg_obj_FAinternal_orig(id,1);
        BSLcorr_meanPD_rcg_obj_FAexternal_emo_orig(ec,1) = BSLcorr_meanPD_rcg_obj_FAexternal_orig(id,1);

        % --- both --- %
        meanPD_BSL_rcg_both_correct_emo_orig(ec,1) = meanPD_BSL_rcg_both_correct_orig(id,1);
        meanPD_BSL_rcg_both_incorrect_emo_orig(ec,1) = meanPD_BSL_rcg_both_incorrect_orig(id,1);
        meanPD_BSL_rcg_both_FAinternal_emo_orig(ec,1) = meanPD_BSL_rcg_both_FAinternal_orig(id,1);
        meanPD_BSL_rcg_both_FAexternal_emo_orig(ec,1) = meanPD_BSL_rcg_both_FAexternal_orig(id,1);

        BSLcorr_PD_rcg_both_correct_emo_orig(ec,1) = BSLcorr_PD_rcg_both_correct_orig(id,1);
        BSLcorr_PD_rcg_both_incorrect_emo_orig(ec,1) = BSLcorr_PD_rcg_both_incorrect_orig(id,1);
        BSLcorr_PD_rcg_both_FAinternal_emo_orig(ec,1) = BSLcorr_PD_rcg_both_FAinternal_orig(id,1);
        BSLcorr_PD_rcg_both_FAexternal_emo_orig(ec,1) = BSLcorr_PD_rcg_both_FAexternal_orig(id,1);

        plotdat_BSLcorr_meanPD_rcg_both_correct_emo_orig(ec,:) = plotdat_BSLcorr_meanPD_rcg_both_correct_orig(id,:);
        plotdat_BSLcorr_meanPD_rcg_both_incorrect_emo_orig(ec,:) = plotdat_BSLcorr_meanPD_rcg_both_incorrect_orig(id,:);
        plotdat_BSLcorr_meanPD_rcg_both_FAinternal_emo_orig(ec,:) = plotdat_BSLcorr_meanPD_rcg_both_FAinternal_orig(id,:);
        plotdat_BSLcorr_meanPD_rcg_both_FAexternal_emo_orig(ec,:) = plotdat_BSLcorr_meanPD_rcg_both_FAexternal_orig(id,:);

        BSLcorr_meanPD_rcg_both_correct_emo_orig(ec,1) = BSLcorr_meanPD_rcg_both_correct_orig(id,1);
        BSLcorr_meanPD_rcg_both_incorrect_emo_orig(ec,1) = BSLcorr_meanPD_rcg_both_incorrect_orig(id,1);
        BSLcorr_meanPD_rcg_both_FAinternal_emo_orig(ec,1) = BSLcorr_meanPD_rcg_both_FAinternal_orig(id,1);
        BSLcorr_meanPD_rcg_both_FAexternal_emo_orig(ec,1) = BSLcorr_meanPD_rcg_both_FAexternal_orig(id,1);


    elseif cond(id)==2

        % if id==18
        % else
        nc=nc+1;
        % end

        % === first: encoding === %

        % --- scenes --- %
        if id==18
        meanPD_BSL_enc_scene_neu_orig(nc,1) = NaN;
        BSLcorr_PD_enc_scene_neu_orig{nc,1} = nan(1,3701);
        BSLcorr_meanPD_enc_scene_neu_orig(nc,1) = NaN;
        plotdat_BSLcorr_meanPD_enc_scene_neu_orig(nc,:) = nan(1,3701);

        else
        clear tmpacc times meanBSL dat BSLcorrdTrials

        dat=pupil_enc_scene_orig{id,1}.eyeinterp.dat.datai;
        meanBSL = nanmean(dat(:,1:200)');
        BSLcorrdTrials = dat-repmat(meanBSL',1,size(dat,2));

        times=length(pupil_enc_scene_orig{id,1}.eyeinterp.time{1,1});
        meanPD_BSL_enc_scene_neu_orig(nc,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        BSLcorr_PD_enc_scene_neu_orig{nc,1} = BSLcorrdTrials(:,1:times);
        BSLcorr_meanPD_enc_scene_neu_orig(nc,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        plotdat_BSLcorr_meanPD_enc_scene_neu_orig(nc,:) = nanmean(BSLcorrdTrials(:,1:times),1);
        end

        % --- objects --- %
        clear tmpacc times meanBSL dat BSLcorrdTrials

        dat=pupil_enc_obj_orig{id,1}.eyeinterp.dat.datai;
        meanBSL = nanmean(dat(:,1:200)');
        BSLcorrdTrials = dat-repmat(meanBSL',1,size(dat,2));

        times=length(pupil_enc_obj_orig{id,1}.eyeinterp.time{1,1});
        meanPD_BSL_enc_obj_neu_orig(nc,1) = mean(nanmean(BSLcorrdTrials(:,1200:times,:),1));
        BSLcorr_PD_enc_obj_neu_orig{nc,1} = BSLcorrdTrials(:,1:times);
        BSLcorr_meanPD_enc_obj_neu_orig(nc,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        plotdat_BSLcorr_meanPD_enc_obj_neu_orig(nc,:) = nanmean(BSLcorrdTrials(:,1:times),1);

        % ========================= %


        
        % === next: recognition === %

        % --- scenes --- %
        clear tmpacc times meanBSL dat BSLcorrdTrials

        dat=pupil_rcg_scene_orig{id,1}.eyeinterp.dat.datai;
        meanBSL = nanmean(dat(:,1:200)');
        BSLcorrdTrials = dat-repmat(meanBSL',1,size(dat,2));

        times=length(pupil_rcg_scene_orig{id,1}.eyeinterp.time{1,1});
        meanPD_BSL_rcg_scene_neu_orig(nc,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        BSLcorr_PD_rcg_scene_neu_orig{nc,1} = BSLcorrdTrials(:,1:times);
        BSLcorr_meanPD_rcg_scene_neu_orig(nc,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        plotdat_BSLcorr_meanPD_rcg_scene_neu_orig(nc,:) = nanmean(BSLcorrdTrials(:,1:times),1);

        % --- objects --- %
        clear tmpacc times meanBSL dat BSLcorrdTrials

        dat=pupil_rcg_obj_orig{id,1}.eyeinterp.dat.datai;
        meanBSL = nanmean(dat(:,1:200)');
        BSLcorrdTrials = dat-repmat(meanBSL',1,size(dat,2));

        times=length(pupil_rcg_obj_orig{id,1}.eyeinterp.time{1,1});
        meanPD_BSL_rcg_obj_neu_orig(nc,1) = mean(nanmean(BSLcorrdTrials(:,1200:times,:),1));
        BSLcorr_PD_rcg_obj_neu_orig{nc,1} = BSLcorrdTrials(:,1:times);
        BSLcorr_meanPD_rcg_obj_neu_orig(nc,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        plotdat_BSLcorr_meanPD_rcg_obj_neu_orig(nc,:) = nanmean(BSLcorrdTrials(:,1:times),1);

        % --- both --- %
        clear tmpacc times meanBSL dat BSLcorrdTrials

        dat=pupil_rcg_both_orig{id,1}.eyeinterp.dat.datai;
        meanBSL = nanmean(dat(:,1:200)');
        BSLcorrdTrials = dat-repmat(meanBSL',1,size(dat,2));

        times=length(pupil_rcg_obj_orig{id,1}.eyeinterp.time{1,1});
        meanPD_BSL_rcg_both_neu_orig(nc,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        BSLcorr_PD_rcg_both_neu_orig{nc,1} = BSLcorrdTrials(:,1:times);
        BSLcorr_meanPD_rcg_both_neu_orig(nc,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        plotdat_BSLcorr_meanPD_rcg_both_neu_orig(nc,:) = nanmean(BSLcorrdTrials(:,1:times),1);

        % = accuracy based = %
        % --- scenes --- %
        meanPD_BSL_rcg_scene_correct_neu_orig(nc,1) = meanPD_BSL_rcg_scene_correct_orig(id,1);
        meanPD_BSL_rcg_scene_incorrect_neu_orig(nc,1) = meanPD_BSL_rcg_scene_incorrect_orig(id,1);
        meanPD_BSL_rcg_scene_FAinternal_neu_orig(nc,1) = meanPD_BSL_rcg_scene_FAinternal_orig(id,1);
        meanPD_BSL_rcg_scene_FAexternal_neu_orig(nc,1) = meanPD_BSL_rcg_scene_FAexternal_orig(id,1);

        BSLcorr_PD_rcg_scene_correct_neu_orig(nc,1) = BSLcorr_PD_rcg_scene_correct_orig(id,1);
        BSLcorr_PD_rcg_scene_incorrect_neu_orig(nc,1) = BSLcorr_PD_rcg_scene_incorrect_orig(id,1);
        BSLcorr_PD_rcg_scene_FAinternal_neu_orig(nc,1) = BSLcorr_PD_rcg_scene_FAinternal_orig(id,1);
        BSLcorr_PD_rcg_scene_FAexternal_neu_orig(nc,1) = BSLcorr_PD_rcg_scene_FAexternal_orig(id,1);

        plotdat_BSLcorr_meanPD_rcg_scene_correct_neu_orig(nc,:) = plotdat_BSLcorr_meanPD_rcg_scene_correct_orig(id,:);
        plotdat_BSLcorr_meanPD_rcg_scene_incorrect_neu_orig(nc,:) = plotdat_BSLcorr_meanPD_rcg_scene_incorrect_orig(id,:);
        plotdat_BSLcorr_meanPD_rcg_scene_FAinternal_neu_orig(nc,:) = plotdat_BSLcorr_meanPD_rcg_scene_FAinternal_orig(id,:);
        plotdat_BSLcorr_meanPD_rcg_scene_FAexternal_neu_orig(nc,:) = plotdat_BSLcorr_meanPD_rcg_scene_FAexternal_orig(id,:);

        BSLcorr_meanPD_rcg_scene_correct_neu_orig(nc,1) = BSLcorr_meanPD_rcg_scene_correct_orig(id,1);
        BSLcorr_meanPD_rcg_scene_incorrect_neu_orig(nc,1) = BSLcorr_meanPD_rcg_scene_incorrect_orig(id,1);
        BSLcorr_meanPD_rcg_scene_FAinternal_neu_orig(nc,1) = BSLcorr_meanPD_rcg_scene_FAinternal_orig(id,1);
        BSLcorr_meanPD_rcg_scene_FAexternal_neu_orig(nc,1) = BSLcorr_meanPD_rcg_scene_FAexternal_orig(id,1);

        % --- objects --- %
        meanPD_BSL_rcg_obj_correct_neu_orig(nc,1) = meanPD_BSL_rcg_obj_correct_orig(id,1);
        meanPD_BSL_rcg_obj_incorrect_neu_orig(nc,1) = meanPD_BSL_rcg_obj_incorrect_orig(id,1);
        meanPD_BSL_rcg_obj_FAinternal_neu_orig(nc,1) = meanPD_BSL_rcg_obj_FAinternal_orig(id,1);
        meanPD_BSL_rcg_obj_FAexternal_neu_orig(nc,1) = meanPD_BSL_rcg_obj_FAexternal_orig(id,1);

        BSLcorr_PD_rcg_obj_correct_neu_orig(nc,1) = BSLcorr_PD_rcg_obj_correct_orig(id,1);
        BSLcorr_PD_rcg_obj_incorrect_neu_orig(nc,1) = BSLcorr_PD_rcg_obj_incorrect_orig(id,1);
        BSLcorr_PD_rcg_obj_FAinternal_neu_orig(nc,1) = BSLcorr_PD_rcg_obj_FAinternal_orig(id,1);
        BSLcorr_PD_rcg_obj_FAexternal_neu_orig(nc,1) = BSLcorr_PD_rcg_obj_FAexternal_orig(id,1);

        plotdat_BSLcorr_meanPD_rcg_obj_correct_neu_orig(nc,:) = plotdat_BSLcorr_meanPD_rcg_obj_correct_orig(id,:);
        plotdat_BSLcorr_meanPD_rcg_obj_incorrect_neu_orig(nc,:) = plotdat_BSLcorr_meanPD_rcg_obj_incorrect_orig(id,:);
        plotdat_BSLcorr_meanPD_rcg_obj_FAinternal_neu_orig(nc,:) = plotdat_BSLcorr_meanPD_rcg_obj_FAinternal_orig(id,:);
        plotdat_BSLcorr_meanPD_rcg_obj_FAexternal_neu_orig(nc,:) = plotdat_BSLcorr_meanPD_rcg_obj_FAexternal_orig(id,:);

        BSLcorr_meanPD_rcg_obj_correct_neu_orig(nc,1) = BSLcorr_meanPD_rcg_obj_correct_orig(id,1);
        BSLcorr_meanPD_rcg_obj_incorrect_neu_orig(nc,1) = BSLcorr_meanPD_rcg_obj_incorrect_orig(id,1);
        BSLcorr_meanPD_rcg_obj_FAinternal_neu_orig(nc,1) = BSLcorr_meanPD_rcg_obj_FAinternal_orig(id,1);
        BSLcorr_meanPD_rcg_obj_FAexternal_neu_orig(nc,1) = BSLcorr_meanPD_rcg_obj_FAexternal_orig(id,1);

        % --- both --- %
        meanPD_BSL_rcg_both_correct_neu_orig(nc,1) = meanPD_BSL_rcg_both_correct_orig(id,1);
        meanPD_BSL_rcg_both_incorrect_neu_orig(nc,1) = meanPD_BSL_rcg_both_incorrect_orig(id,1);
        meanPD_BSL_rcg_both_FAinternal_neu_orig(nc,1) = meanPD_BSL_rcg_both_FAinternal_orig(id,1);
        meanPD_BSL_rcg_both_FAexternal_neu_orig(nc,1) = meanPD_BSL_rcg_both_FAexternal_orig(id,1);

        BSLcorr_PD_rcg_both_correct_neu_orig(nc,1) = BSLcorr_PD_rcg_both_correct_orig(id,1);
        BSLcorr_PD_rcg_both_incorrect_neu_orig(nc,1) = BSLcorr_PD_rcg_both_incorrect_orig(id,1);
        BSLcorr_PD_rcg_both_FAinternal_neu_orig(nc,1) = BSLcorr_PD_rcg_both_FAinternal_orig(id,1);
        BSLcorr_PD_rcg_both_FAexternal_neu_orig(nc,1) = BSLcorr_PD_rcg_both_FAexternal_orig(id,1);

        plotdat_BSLcorr_meanPD_rcg_both_correct_neu_orig(nc,:) = plotdat_BSLcorr_meanPD_rcg_both_correct_orig(id,:);
        plotdat_BSLcorr_meanPD_rcg_both_incorrect_neu_orig(nc,:) = plotdat_BSLcorr_meanPD_rcg_both_incorrect_orig(id,:);
        plotdat_BSLcorr_meanPD_rcg_both_FAinternal_neu_orig(nc,:) = plotdat_BSLcorr_meanPD_rcg_both_FAinternal_orig(id,:);
        plotdat_BSLcorr_meanPD_rcg_both_FAexternal_neu_orig(nc,:) = plotdat_BSLcorr_meanPD_rcg_both_FAexternal_orig(id,:);

        BSLcorr_meanPD_rcg_both_correct_neu_orig(nc,1) = BSLcorr_meanPD_rcg_both_correct_orig(id,1);
        BSLcorr_meanPD_rcg_both_incorrect_neu_orig(nc,1) = BSLcorr_meanPD_rcg_both_incorrect_orig(id,1);
        BSLcorr_meanPD_rcg_both_FAinternal_neu_orig(nc,1) = BSLcorr_meanPD_rcg_both_FAinternal_orig(id,1);
        BSLcorr_meanPD_rcg_both_FAexternal_neu_orig(nc,1) = BSLcorr_meanPD_rcg_both_FAexternal_orig(id,1);


    end
end


%% process pupil data, session 2, retest

ec=0; nc=0;

for id=1:length(ids)

    % accuracy based

    % --- scenes --- %
    clear tmpacc times meanBSL dat BSLcorrdTrials

    dat=pupil_rcg_scene_retest{id,1}.eyeinterp.dat.datai;
    meanBSL = nanmean(dat(:,1:200)');
    BSLcorrdTrials = dat-repmat(meanBSL',1,size(dat,2));

    times=length(pupil_rcg_scene_retest{id,1}.eyeinterp.time{1,1});  
    tmpacc=accuracies_dat{id};
    tmpacc(pupil_rcg_scene_retest{id,1}.eyeinterp.dat.trl_raus==1)=[];

    meanPD_BSL_rcg_scene_correct_retest(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc==1,1200:times),1));
    meanPD_BSL_rcg_scene_incorrect_retest(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc~=1,1200:times),1));
    meanPD_BSL_rcg_scene_FAinternal_retest(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc==-1,1200:times),1));
    meanPD_BSL_rcg_scene_FAexternal_retest(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc==0,1200:times),1));

    BSLcorr_PD_rcg_scene_correct_retest{id,1} = BSLcorrdTrials(tmpacc==1,1:times);
    BSLcorr_meanPD_rcg_scene_correct_retest(id,1) = mean(nanmean(BSLcorr_PD_rcg_scene_correct_retest{id,1}(:,1200:times),1));
    plotdat_BSLcorr_meanPD_rcg_scene_correct_retest(id,:)=nanmean(BSLcorr_PD_rcg_scene_correct_retest{id,1}(:,1:times),1);

    BSLcorr_PD_rcg_scene_incorrect_retest{id,1} = BSLcorrdTrials(tmpacc~=1,1:times);
    BSLcorr_meanPD_rcg_scene_incorrect_retest(id,1) = mean(nanmean(BSLcorr_PD_rcg_scene_incorrect_retest{id,1}(:,1200:times),1));
    plotdat_BSLcorr_meanPD_rcg_scene_incorrect_retest(id,:)=nanmean(BSLcorr_PD_rcg_scene_incorrect_retest{id,1}(:,1:times),1);

    BSLcorr_PD_rcg_scene_FAinternal_retest{id,1} = BSLcorrdTrials(tmpacc==-1,1:times);
    BSLcorr_meanPD_rcg_scene_FAinternal_retest(id,1) = mean(nanmean(BSLcorr_PD_rcg_scene_FAinternal_retest{id,1}(:,1200:times),1));
    plotdat_BSLcorr_meanPD_rcg_scene_FAinternal_retest(id,:)=nanmean(BSLcorr_PD_rcg_scene_FAinternal_retest{id,1}(:,1:times),1);

    BSLcorr_PD_rcg_scene_FAexternal_retest{id,1} = BSLcorrdTrials(tmpacc==0,1:times);
    BSLcorr_meanPD_rcg_scene_FAexternal_retest(id,1) = mean(nanmean(BSLcorr_PD_rcg_scene_FAexternal_retest{id,1}(:,1200:times),1));
    plotdat_BSLcorr_meanPD_rcg_scene_FAexternal_retest(id,:) = nanmean(BSLcorr_PD_rcg_scene_FAexternal_retest{id,1}(:,1:times),1);


    % --- objects --- %
    clear tmpacc times meanBSL dat BSLcorrdTrials

    dat=pupil_rcg_obj_retest{id,1}.eyeinterp.dat.datai;
    meanBSL = nanmean(dat(:,1:200)');
    BSLcorrdTrials = dat-repmat(meanBSL',1,size(dat,2));

    times=length(pupil_rcg_obj_retest{id,1}.eyeinterp.time{1,1});  
    tmpacc=accuracies_dat{id};
    tmpacc(pupil_rcg_obj_retest{id,1}.eyeinterp.dat.trl_raus==1)=[];
    meanPD_BSL_rcg_obj_correct_retest(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc==1,1200:times),1));
    meanPD_BSL_rcg_obj_incorrect_retest(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc~=1,1200:times),1));
    meanPD_BSL_rcg_obj_FAinternal_retest(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc==-1,1200:times),1));
    meanPD_BSL_rcg_obj_FAexternal_retest(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc==0,1200:times),1));

    BSLcorr_PD_rcg_obj_correct_retest{id,1} = BSLcorrdTrials(tmpacc==1,1:times);
    BSLcorr_meanPD_rcg_obj_correct_retest(id,1) = mean(nanmean(BSLcorr_PD_rcg_obj_correct_retest{id,1}(:,1200:times),1));
    plotdat_BSLcorr_meanPD_rcg_obj_correct_retest(id,:) = nanmean(BSLcorr_PD_rcg_obj_correct_retest{id,1}(:,1:times),1);

    BSLcorr_PD_rcg_obj_incorrect_retest{id,1} = BSLcorrdTrials(tmpacc~=1,1:times);
    BSLcorr_meanPD_rcg_obj_incorrect_retest(id,1) = mean(nanmean(BSLcorr_PD_rcg_obj_incorrect_retest{id,1}(:,1200:times),1));
    plotdat_BSLcorr_meanPD_rcg_obj_incorrect_retest(id,:) = nanmean(BSLcorr_PD_rcg_obj_incorrect_retest{id,1}(:,1:times),1);

    BSLcorr_PD_rcg_obj_FAinternal_retest{id,1} = BSLcorrdTrials(tmpacc==-1,1:times);
    BSLcorr_meanPD_rcg_obj_FAinternal_retest(id,1) = mean(nanmean(BSLcorr_PD_rcg_obj_FAinternal_retest{id,1}(:,1200:times),1));
    plotdat_BSLcorr_meanPD_rcg_obj_FAinternal_retest(id,:) = nanmean(BSLcorr_PD_rcg_obj_FAinternal_retest{id,1}(:,1:times),1);

    BSLcorr_PD_rcg_obj_FAexternal_retest{id,1} = BSLcorrdTrials(tmpacc==0,1:times);
    BSLcorr_meanPD_rcg_obj_FAexternal_retest(id,1) = mean(nanmean(BSLcorr_PD_rcg_obj_FAexternal_retest{id,1}(:,1200:times),1));
    plotdat_BSLcorr_meanPD_rcg_obj_FAexternal_retest(id,:) = nanmean(BSLcorr_PD_rcg_obj_FAexternal_retest{id,1}(:,1:times),1);

    % --- both --- %
    clear tmpacc times meanBSL dat BSLcorrdTrials

    dat=pupil_rcg_both_retest{id,1}.eyeinterp.dat.datai;
    meanBSL = nanmean(dat(:,1:200)');
    BSLcorrdTrials = dat-repmat(meanBSL',1,size(dat,2));

    times=length(pupil_rcg_both_retest{id,1}.eyeinterp.time{1,1});  
    tmpacc=accuracies_dat{id};
    tmpacc(pupil_rcg_both_retest{id,1}.eyeinterp.dat.trl_raus==1)=[];
    meanPD_BSL_rcg_both_correct_retest(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc==1,1200:times),1));
    meanPD_BSL_rcg_both_incorrect_retest(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc~=1,1200:times),1));
    meanPD_BSL_rcg_both_FAinternal_retest(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc==-1,1200:times),1));
    meanPD_BSL_rcg_both_FAexternal_retest(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc==0,1200:times),1));

    BSLcorr_PD_rcg_both_correct_retest{id,1} = BSLcorrdTrials(tmpacc==1,1:times);
    BSLcorr_meanPD_rcg_both_correct_retest(id,1) = mean(nanmean(BSLcorr_PD_rcg_both_correct_retest{id,1}(:,1200:times),1));
    plotdat_BSLcorr_meanPD_rcg_both_correct_retest(id,:) = nanmean(BSLcorr_PD_rcg_both_correct_retest{id,1}(:,1:times),1);

    BSLcorr_PD_rcg_both_incorrect_retest{id,1} = BSLcorrdTrials(tmpacc~=1,1:times);
    BSLcorr_meanPD_rcg_both_incorrect_retest(id,1) = mean(nanmean(BSLcorr_PD_rcg_both_incorrect_retest{id,1}(:,1200:times),1));
    plotdat_BSLcorr_meanPD_rcg_both_incorrect_retest(id,:) = nanmean(BSLcorr_PD_rcg_both_incorrect_retest{id,1}(:,1:times),1);

    BSLcorr_PD_rcg_both_FAinternal_retest{id,1} = BSLcorrdTrials(tmpacc==-1,1:times);
    BSLcorr_meanPD_rcg_both_FAinternal_retest(id,:) = mean(nanmean(BSLcorr_PD_rcg_both_FAinternal_retest{id,1}(:,1:times),1));
    plotdat_BSLcorr_meanPD_rcg_both_FAinternal_retest(id,:) = nanmean(BSLcorr_PD_rcg_both_FAinternal_retest{id,1}(:,1:times),1);

    BSLcorr_PD_rcg_both_FAexternal_retest{id,1} = BSLcorrdTrials(tmpacc==0,1:times);
    BSLcorr_meanPD_rcg_both_FAexternal_retest(id,:) = mean(nanmean(BSLcorr_PD_rcg_both_FAexternal_retest{id,1}(:,1:times),1));
    plotdat_BSLcorr_meanPD_rcg_both_FAexternal_retest(id,:) = nanmean(BSLcorr_PD_rcg_both_FAexternal_retest{id,1}(:,1:times),1);

    
    if cond(id)==1

        ec=ec+1;

        
        % === next: recognition === %

        % --- scenes --- %
        clear tmpacc times meanBSL dat BSLcorrdTrials

        dat=pupil_rcg_scene_retest{id,1}.eyeinterp.dat.datai;
        meanBSL = nanmean(dat(:,1:200)');
        BSLcorrdTrials = dat-repmat(meanBSL',1,size(dat,2));

        times=length(pupil_rcg_scene_retest{id,1}.eyeinterp.time{1,1});
        meanPD_BSL_rcg_scene_emo_retest(ec,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        BSLcorr_PD_rcg_scene_emo_retest{ec,1} = BSLcorrdTrials(:,1:times);
        BSLcorr_meanPD_rcg_scene_emo_retest(ec,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        plotdat_BSLcorr_meanPD_rcg_scene_emo_retest(ec,:) = nanmean(BSLcorrdTrials(:,1:times),1);

        % --- objects --- %
        clear tmpacc times meanBSL dat BSLcorrdTrials

        dat=pupil_rcg_obj_retest{id,1}.eyeinterp.dat.datai;
        meanBSL = nanmean(dat(:,1:200)');
        BSLcorrdTrials = dat-repmat(meanBSL',1,size(dat,2));

        times=length(pupil_rcg_obj_retest{id,1}.eyeinterp.time{1,1});
        meanPD_BSL_rcg_obj_emo_retest(ec,1) = mean(nanmean(BSLcorrdTrials(:,1200:times,:),1));
        BSLcorr_PD_rcg_obj_emo_retest{ec,1} = BSLcorrdTrials(:,1:times);
        BSLcorr_meanPD_rcg_obj_emo_retest(ec,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        plotdat_BSLcorr_meanPD_rcg_obj_emo_retest(ec,:) = nanmean(BSLcorrdTrials(:,1:times),1);

        % --- both --- %
        clear tmpacc times meanBSL dat BSLcorrdTrials

        dat=pupil_rcg_both_retest{id,1}.eyeinterp.dat.datai;
        meanBSL = nanmean(dat(:,1:200)');
        BSLcorrdTrials = dat-repmat(meanBSL',1,size(dat,2));

        times=length(pupil_rcg_obj_retest{id,1}.eyeinterp.time{1,1});
        meanPD_BSL_rcg_both_emo_retest(ec,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        BSLcorr_PD_rcg_both_emo_retest{ec,1} = BSLcorrdTrials(:,1:times);
        BSLcorr_meanPD_rcg_both_emo_retest(ec,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        plotdat_BSLcorr_meanPD_rcg_both_emo_retest(ec,:) = nanmean(BSLcorrdTrials(:,1:times),1);


        % = accuracy based = %
        % --- scenes --- %
        meanPD_BSL_rcg_scene_correct_emo_retest(ec,1) = meanPD_BSL_rcg_scene_correct_retest(id,1);
        meanPD_BSL_rcg_scene_incorrect_emo_retest(ec,1) = meanPD_BSL_rcg_scene_incorrect_retest(id,1);
        meanPD_BSL_rcg_scene_FAinternal_emo_retest(ec,1) = meanPD_BSL_rcg_scene_FAinternal_retest(id,1);
        meanPD_BSL_rcg_scene_FAexternal_emo_retest(ec,1) = meanPD_BSL_rcg_scene_FAexternal_retest(id,1);

        BSLcorr_PD_rcg_scene_correct_emo_retest(ec,1) = BSLcorr_PD_rcg_scene_correct_retest(id,1);
        BSLcorr_PD_rcg_scene_incorrect_emo_retest(ec,1) = BSLcorr_PD_rcg_scene_incorrect_retest(id,1);
        BSLcorr_PD_rcg_scene_FAinternal_emo_retest(ec,1) = BSLcorr_PD_rcg_scene_FAinternal_retest(id,1);
        BSLcorr_PD_rcg_scene_FAexternal_emo_retest(ec,1) = BSLcorr_PD_rcg_scene_FAexternal_retest(id,1);

        plotdat_BSLcorr_meanPD_rcg_scene_correct_emo_retest(ec,:) = plotdat_BSLcorr_meanPD_rcg_scene_correct_retest(id,:);
        plotdat_BSLcorr_meanPD_rcg_scene_incorrect_emo_retest(ec,:) = plotdat_BSLcorr_meanPD_rcg_scene_incorrect_retest(id,:);
        plotdat_BSLcorr_meanPD_rcg_scene_FAinternal_emo_retest(ec,:) = plotdat_BSLcorr_meanPD_rcg_scene_FAinternal_retest(id,:);
        plotdat_BSLcorr_meanPD_rcg_scene_FAexternal_emo_retest(ec,:) = plotdat_BSLcorr_meanPD_rcg_scene_FAexternal_retest(id,:);

        BSLcorr_meanPD_rcg_scene_correct_emo_retest(ec,1) = BSLcorr_meanPD_rcg_scene_correct_retest(id,1);
        BSLcorr_meanPD_rcg_scene_incorrect_emo_retest(ec,1) = BSLcorr_meanPD_rcg_scene_incorrect_retest(id,1);
        BSLcorr_meanPD_rcg_scene_FAinternal_emo_retest(ec,1) = BSLcorr_meanPD_rcg_scene_FAinternal_retest(id,1);
        BSLcorr_meanPD_rcg_scene_FAexternal_emo_retest(ec,1) = BSLcorr_meanPD_rcg_scene_FAexternal_retest(id,1);

        % --- objects --- %
        meanPD_BSL_rcg_obj_correct_emo_retest(ec,1) = meanPD_BSL_rcg_obj_correct_retest(id,1);
        meanPD_BSL_rcg_obj_incorrect_emo_retest(ec,1) = meanPD_BSL_rcg_obj_incorrect_retest(id,1);
        meanPD_BSL_rcg_obj_FAinternal_emo_retest(ec,1) = meanPD_BSL_rcg_obj_FAinternal_retest(id,1);
        meanPD_BSL_rcg_obj_FAexternal_emo_retest(ec,1) = meanPD_BSL_rcg_obj_FAexternal_retest(id,1);

        BSLcorr_PD_rcg_obj_correct_emo_retest(ec,1) = BSLcorr_PD_rcg_obj_correct_retest(id,1);
        BSLcorr_PD_rcg_obj_incorrect_emo_retest(ec,1) = BSLcorr_PD_rcg_obj_incorrect_retest(id,1);
        BSLcorr_PD_rcg_obj_FAinternal_emo_retest(ec,1) = BSLcorr_PD_rcg_obj_FAinternal_retest(id,1);
        BSLcorr_PD_rcg_obj_FAexternal_emo_retest(ec,1) = BSLcorr_PD_rcg_obj_FAexternal_retest(id,1);

        plotdat_BSLcorr_meanPD_rcg_obj_correct_emo_retest(ec,:) = plotdat_BSLcorr_meanPD_rcg_obj_correct_retest(id,:);
        plotdat_BSLcorr_meanPD_rcg_obj_incorrect_emo_retest(ec,:) = plotdat_BSLcorr_meanPD_rcg_obj_incorrect_retest(id,:);
        plotdat_BSLcorr_meanPD_rcg_obj_FAinternal_emo_retest(ec,:) = plotdat_BSLcorr_meanPD_rcg_obj_FAinternal_retest(id,:);
        plotdat_BSLcorr_meanPD_rcg_obj_FAexternal_emo_retest(ec,:) = plotdat_BSLcorr_meanPD_rcg_obj_FAexternal_retest(id,:);

        BSLcorr_meanPD_rcg_obj_correct_emo_retest(ec,1) = BSLcorr_meanPD_rcg_obj_correct_retest(id,1);
        BSLcorr_meanPD_rcg_obj_incorrect_emo_retest(ec,1) = BSLcorr_meanPD_rcg_obj_incorrect_retest(id,1);
        BSLcorr_meanPD_rcg_obj_FAinternal_emo_retest(ec,1) = BSLcorr_meanPD_rcg_obj_FAinternal_retest(id,1);
        BSLcorr_meanPD_rcg_obj_FAexternal_emo_retest(ec,1) = BSLcorr_meanPD_rcg_obj_FAexternal_retest(id,1);

        % --- both --- %
        meanPD_BSL_rcg_both_correct_emo_retest(ec,1) = meanPD_BSL_rcg_both_correct_retest(id,1);
        meanPD_BSL_rcg_both_incorrect_emo_retest(ec,1) = meanPD_BSL_rcg_both_incorrect_retest(id,1);
        meanPD_BSL_rcg_both_FAinternal_emo_retest(ec,1) = meanPD_BSL_rcg_both_FAinternal_retest(id,1);
        meanPD_BSL_rcg_both_FAexternal_emo_retest(ec,1) = meanPD_BSL_rcg_both_FAexternal_retest(id,1);

        BSLcorr_PD_rcg_both_correct_emo_retest(ec,1) = BSLcorr_PD_rcg_both_correct_retest(id,1);
        BSLcorr_PD_rcg_both_incorrect_emo_retest(ec,1) = BSLcorr_PD_rcg_both_incorrect_retest(id,1);
        BSLcorr_PD_rcg_both_FAinternal_emo_retest(ec,1) = BSLcorr_PD_rcg_both_FAinternal_retest(id,1);
        BSLcorr_PD_rcg_both_FAexternal_emo_retest(ec,1) = BSLcorr_PD_rcg_both_FAexternal_retest(id,1);

        plotdat_BSLcorr_meanPD_rcg_both_correct_emo_retest(ec,:) = plotdat_BSLcorr_meanPD_rcg_both_correct_retest(id,:);
        plotdat_BSLcorr_meanPD_rcg_both_incorrect_emo_retest(ec,:) = plotdat_BSLcorr_meanPD_rcg_both_incorrect_retest(id,:);
        plotdat_BSLcorr_meanPD_rcg_both_FAinternal_emo_retest(ec,:) = plotdat_BSLcorr_meanPD_rcg_both_FAinternal_retest(id,:);
        plotdat_BSLcorr_meanPD_rcg_both_FAexternal_emo_retest(ec,:) = plotdat_BSLcorr_meanPD_rcg_both_FAexternal_retest(id,:);

        BSLcorr_meanPD_rcg_both_correct_emo_retest(ec,1) = BSLcorr_meanPD_rcg_both_correct_retest(id,1);
        BSLcorr_meanPD_rcg_both_incorrect_emo_retest(ec,1) = BSLcorr_meanPD_rcg_both_incorrect_retest(id,1);
        BSLcorr_meanPD_rcg_both_FAinternal_emo_retest(ec,1) = BSLcorr_meanPD_rcg_both_FAinternal_retest(id,1);
        BSLcorr_meanPD_rcg_both_FAexternal_emo_retest(ec,1) = BSLcorr_meanPD_rcg_both_FAexternal_retest(id,1);


    elseif cond(id)==2

        nc=nc+1;

        
        % === next: recognition === %

        % --- scenes --- %
        clear tmpacc times meanBSL dat BSLcorrdTrials

        dat=pupil_rcg_scene_retest{id,1}.eyeinterp.dat.datai;
        meanBSL = nanmean(dat(:,1:200)');
        BSLcorrdTrials = dat-repmat(meanBSL',1,size(dat,2));

        times=length(pupil_rcg_scene_retest{id,1}.eyeinterp.time{1,1});
        meanPD_BSL_rcg_scene_neu_retest(nc,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        BSLcorr_PD_rcg_scene_neu_retest{nc,1} = BSLcorrdTrials(:,1:times);
        BSLcorr_meanPD_rcg_scene_neu_retest(nc,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        plotdat_BSLcorr_meanPD_rcg_scene_neu_retest(nc,:) = nanmean(BSLcorrdTrials(:,1:times),1);

        % --- objects --- %
        clear tmpacc times meanBSL dat BSLcorrdTrials

        dat=pupil_rcg_obj_retest{id,1}.eyeinterp.dat.datai;
        meanBSL = nanmean(dat(:,1:200)');
        BSLcorrdTrials = dat-repmat(meanBSL',1,size(dat,2));

        times=length(pupil_rcg_obj_retest{id,1}.eyeinterp.time{1,1});
        meanPD_BSL_rcg_obj_neu_retest(nc,1) = mean(nanmean(BSLcorrdTrials(:,1200:times,:),1));
        BSLcorr_PD_rcg_obj_neu_retest{nc,1} = BSLcorrdTrials(:,1:times);
        BSLcorr_meanPD_rcg_obj_neu_retest(nc,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        plotdat_BSLcorr_meanPD_rcg_obj_neu_retest(nc,:) = nanmean(BSLcorrdTrials(:,1:times),1);

        % --- both --- %
        clear tmpacc times meanBSL dat BSLcorrdTrials

        dat=pupil_rcg_both_retest{id,1}.eyeinterp.dat.datai;
        meanBSL = nanmean(dat(:,1:200)');
        BSLcorrdTrials = dat-repmat(meanBSL',1,size(dat,2));

        times=length(pupil_rcg_obj_retest{id,1}.eyeinterp.time{1,1});
        meanPD_BSL_rcg_both_neu_retest(nc,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        BSLcorr_PD_rcg_both_neu_retest{nc,1} = BSLcorrdTrials(:,1:times);
        BSLcorr_meanPD_rcg_both_neu_retest(nc,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        plotdat_BSLcorr_meanPD_rcg_both_neu_retest(nc,:) = nanmean(BSLcorrdTrials(:,1:times),1);

        % = accuracy based = %
        % --- scenes --- %
        meanPD_BSL_rcg_scene_correct_neu_retest(nc,1) = meanPD_BSL_rcg_scene_correct_retest(id,1);
        meanPD_BSL_rcg_scene_incorrect_neu_retest(nc,1) = meanPD_BSL_rcg_scene_incorrect_retest(id,1);
        meanPD_BSL_rcg_scene_FAinternal_neu_retest(nc,1) = meanPD_BSL_rcg_scene_FAinternal_retest(id,1);
        meanPD_BSL_rcg_scene_FAexternal_neu_retest(nc,1) = meanPD_BSL_rcg_scene_FAexternal_retest(id,1);

        BSLcorr_PD_rcg_scene_correct_neu_retest(nc,1) = BSLcorr_PD_rcg_scene_correct_retest(id,1);
        BSLcorr_PD_rcg_scene_incorrect_neu_retest(nc,1) = BSLcorr_PD_rcg_scene_incorrect_retest(id,1);
        BSLcorr_PD_rcg_scene_FAinternal_neu_retest(nc,1) = BSLcorr_PD_rcg_scene_FAinternal_retest(id,1);
        BSLcorr_PD_rcg_scene_FAexternal_neu_retest(nc,1) = BSLcorr_PD_rcg_scene_FAexternal_retest(id,1);

        plotdat_BSLcorr_meanPD_rcg_scene_correct_neu_retest(nc,:) = plotdat_BSLcorr_meanPD_rcg_scene_correct_retest(id,:);
        plotdat_BSLcorr_meanPD_rcg_scene_incorrect_neu_retest(nc,:) = plotdat_BSLcorr_meanPD_rcg_scene_incorrect_retest(id,:);
        plotdat_BSLcorr_meanPD_rcg_scene_FAinternal_neu_retest(nc,:) = plotdat_BSLcorr_meanPD_rcg_scene_FAinternal_retest(id,:);
        plotdat_BSLcorr_meanPD_rcg_scene_FAexternal_neu_retest(nc,:) = plotdat_BSLcorr_meanPD_rcg_scene_FAexternal_retest(id,:);

        BSLcorr_meanPD_rcg_scene_correct_neu_retest(nc,1) = BSLcorr_meanPD_rcg_scene_correct_retest(id,1);
        BSLcorr_meanPD_rcg_scene_incorrect_neu_retest(nc,1) = BSLcorr_meanPD_rcg_scene_incorrect_retest(id,1);
        BSLcorr_meanPD_rcg_scene_FAinternal_neu_retest(nc,1) = BSLcorr_meanPD_rcg_scene_FAinternal_retest(id,1);
        BSLcorr_meanPD_rcg_scene_FAexternal_neu_retest(nc,1) = BSLcorr_meanPD_rcg_scene_FAexternal_retest(id,1);

        % --- objects --- %
        meanPD_BSL_rcg_obj_correct_neu_retest(nc,1) = meanPD_BSL_rcg_obj_correct_retest(id,1);
        meanPD_BSL_rcg_obj_incorrect_neu_retest(nc,1) = meanPD_BSL_rcg_obj_incorrect_retest(id,1);
        meanPD_BSL_rcg_obj_FAinternal_neu_retest(nc,1) = meanPD_BSL_rcg_obj_FAinternal_retest(id,1);
        meanPD_BSL_rcg_obj_FAexternal_neu_retest(nc,1) = meanPD_BSL_rcg_obj_FAexternal_retest(id,1);

        BSLcorr_PD_rcg_obj_correct_neu_retest(nc,1) = BSLcorr_PD_rcg_obj_correct_retest(id,1);
        BSLcorr_PD_rcg_obj_incorrect_neu_retest(nc,1) = BSLcorr_PD_rcg_obj_incorrect_retest(id,1);
        BSLcorr_PD_rcg_obj_FAinternal_neu_retest(nc,1) = BSLcorr_PD_rcg_obj_FAinternal_retest(id,1);
        BSLcorr_PD_rcg_obj_FAexternal_neu_retest(nc,1) = BSLcorr_PD_rcg_obj_FAexternal_retest(id,1);

        plotdat_BSLcorr_meanPD_rcg_obj_correct_neu_retest(nc,:) = plotdat_BSLcorr_meanPD_rcg_obj_correct_retest(id,:);
        plotdat_BSLcorr_meanPD_rcg_obj_incorrect_neu_retest(nc,:) = plotdat_BSLcorr_meanPD_rcg_obj_incorrect_retest(id,:);
        plotdat_BSLcorr_meanPD_rcg_obj_FAinternal_neu_retest(nc,:) = plotdat_BSLcorr_meanPD_rcg_obj_FAinternal_retest(id,:);
        plotdat_BSLcorr_meanPD_rcg_obj_FAexternal_neu_retest(nc,:) = plotdat_BSLcorr_meanPD_rcg_obj_FAexternal_retest(id,:);

        BSLcorr_meanPD_rcg_obj_correct_neu_retest(nc,1) = BSLcorr_meanPD_rcg_obj_correct_retest(id,1);
        BSLcorr_meanPD_rcg_obj_incorrect_neu_retest(nc,1) = BSLcorr_meanPD_rcg_obj_incorrect_retest(id,1);
        BSLcorr_meanPD_rcg_obj_FAinternal_neu_retest(nc,1) = BSLcorr_meanPD_rcg_obj_FAinternal_retest(id,1);
        BSLcorr_meanPD_rcg_obj_FAexternal_neu_retest(nc,1) = BSLcorr_meanPD_rcg_obj_FAexternal_retest(id,1);

        % --- both --- %
        meanPD_BSL_rcg_both_correct_neu_retest(nc,1) = meanPD_BSL_rcg_both_correct_retest(id,1);
        meanPD_BSL_rcg_both_incorrect_neu_retest(nc,1) = meanPD_BSL_rcg_both_incorrect_retest(id,1);
        meanPD_BSL_rcg_both_FAinternal_neu_retest(nc,1) = meanPD_BSL_rcg_both_FAinternal_retest(id,1);
        meanPD_BSL_rcg_both_FAexternal_neu_retest(nc,1) = meanPD_BSL_rcg_both_FAexternal_retest(id,1);

        BSLcorr_PD_rcg_both_correct_neu_retest(nc,1) = BSLcorr_PD_rcg_both_correct_retest(id,1);
        BSLcorr_PD_rcg_both_incorrect_neu_retest(nc,1) = BSLcorr_PD_rcg_both_incorrect_retest(id,1);
        BSLcorr_PD_rcg_both_FAinternal_neu_retest(nc,1) = BSLcorr_PD_rcg_both_FAinternal_retest(id,1);
        BSLcorr_PD_rcg_both_FAexternal_neu_retest(nc,1) = BSLcorr_PD_rcg_both_FAexternal_retest(id,1);

        plotdat_BSLcorr_meanPD_rcg_both_correct_neu_retest(nc,:) = plotdat_BSLcorr_meanPD_rcg_both_correct_retest(id,:);
        plotdat_BSLcorr_meanPD_rcg_both_incorrect_neu_retest(nc,:) = plotdat_BSLcorr_meanPD_rcg_both_incorrect_retest(id,:);
        plotdat_BSLcorr_meanPD_rcg_both_FAinternal_neu_retest(nc,:) = plotdat_BSLcorr_meanPD_rcg_both_FAinternal_retest(id,:);
        plotdat_BSLcorr_meanPD_rcg_both_FAexternal_neu_retest(nc,:) = plotdat_BSLcorr_meanPD_rcg_both_FAexternal_retest(id,:);

        BSLcorr_meanPD_rcg_both_correct_neu_retest(nc,1) = BSLcorr_meanPD_rcg_both_correct_retest(id,1);
        BSLcorr_meanPD_rcg_both_incorrect_neu_retest(nc,1) = BSLcorr_meanPD_rcg_both_incorrect_retest(id,1);
        BSLcorr_meanPD_rcg_both_FAinternal_neu_retest(nc,1) = BSLcorr_meanPD_rcg_both_FAinternal_retest(id,1);
        BSLcorr_meanPD_rcg_both_FAexternal_neu_retest(nc,1) = BSLcorr_meanPD_rcg_both_FAexternal_retest(id,1);


    end
end



%% process pupil data, session 2, recombi


ec=0; nc=0;

for id=1:length(ids)

    % accuracy based

    % --- scenes --- %
    if id==18
    meanPD_BSL_rcg_scene_correct_recombi(id,1) = NaN;
    meanPD_BSL_rcg_scene_incorrect_recombi(id,1) = NaN;
    meanPD_BSL_rcg_scene_FAinternal_recombi(id,1) = NaN;
    meanPD_BSL_rcg_scene_FAexternal_recombi(id,1) = NaN;

    BSLcorr_PD_rcg_scene_correct_recombi{id,1} = nan(1,3701);
    BSLcorr_meanPD_rcg_scene_correct_recombi(id,1) = NaN;
    plotdat_BSLcorr_meanPD_rcg_scene_correct_recombi(id,:)=NaN;

    BSLcorr_PD_rcg_scene_incorrect_recombi{id,1} = nan(1,3701);
    BSLcorr_meanPD_rcg_scene_incorrect_recombi(id,1) = NaN;
    plotdat_BSLcorr_meanPD_rcg_scene_incorrect_recombi(id,:)=NaN;

    BSLcorr_PD_rcg_scene_FAinternal_recombi{id,1} = nan(1,3701);
    BSLcorr_meanPD_rcg_scene_FAinternal_recombi(id,1) = NaN;
    plotdat_BSLcorr_meanPD_rcg_scene_FAinternal_recombi(id,:)=NaN;

    BSLcorr_PD_rcg_scene_FAexternal_recombi{id,1} = nan(1,3701);
    BSLcorr_meanPD_rcg_scene_FAexternal_recombi(id,1) = NaN;
    plotdat_BSLcorr_meanPD_rcg_scene_FAexternal_recombi(id,:) = NaN;

    else
    clear tmpacc times meanBSL dat BSLcorrdTrials

    dat=pupil_rcg_scene_recombi{id,1}.eyeinterp.dat.datai;
    meanBSL = nanmean(dat(:,1:200)');
    BSLcorrdTrials = dat-repmat(meanBSL',1,size(dat,2));
    
    times=length(pupil_rcg_scene_recombi{id,1}.eyeinterp.time{1,1});  
    tmpacc=accuracies_dat{id};
    tmpacc(pupil_rcg_scene_recombi{id,1}.eyeinterp.dat.trl_raus==1)=[];
    meanPD_BSL_rcg_scene_correct_recombi(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc==1,1200:times),1));
    meanPD_BSL_rcg_scene_incorrect_recombi(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc~=1,1200:times),1));
    meanPD_BSL_rcg_scene_FAinternal_recombi(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc==-1,1200:times),1));
    meanPD_BSL_rcg_scene_FAexternal_recombi(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc==0,1200:times),1));

    BSLcorr_PD_rcg_scene_correct_recombi{id,1} = BSLcorrdTrials(tmpacc==1,1:times);
    BSLcorr_meanPD_rcg_scene_correct_recombi(id,1) = mean(nanmean(BSLcorr_PD_rcg_scene_correct_recombi{id,1}(:,1200:times),1));
    plotdat_BSLcorr_meanPD_rcg_scene_correct_recombi(id,:)=nanmean(BSLcorr_PD_rcg_scene_correct_recombi{id,1}(:,1:times),1);

    BSLcorr_PD_rcg_scene_incorrect_recombi{id,1} = BSLcorrdTrials(tmpacc~=1,1:times);
    BSLcorr_meanPD_rcg_scene_incorrect_recombi(id,1) = mean(nanmean(BSLcorr_PD_rcg_scene_incorrect_recombi{id,1}(:,1200:times),1));
    plotdat_BSLcorr_meanPD_rcg_scene_incorrect_recombi(id,:)=nanmean(BSLcorr_PD_rcg_scene_incorrect_recombi{id,1}(:,1:times),1);

    BSLcorr_PD_rcg_scene_FAinternal_recombi{id,1} = BSLcorrdTrials(tmpacc==-1,1:times);
    BSLcorr_meanPD_rcg_scene_FAinternal_recombi(id,1) = mean(nanmean(BSLcorr_PD_rcg_scene_FAinternal_recombi{id,1}(:,1200:times),1));
    plotdat_BSLcorr_meanPD_rcg_scene_FAinternal_recombi(id,:)=nanmean(BSLcorr_PD_rcg_scene_FAinternal_recombi{id,1}(:,1:times),1);

    BSLcorr_PD_rcg_scene_FAexternal_recombi{id,1} = BSLcorrdTrials(tmpacc==0,1:times);
    BSLcorr_meanPD_rcg_scene_FAexternal_recombi(id,1) = mean(nanmean(BSLcorr_PD_rcg_scene_FAexternal_recombi{id,1}(:,1200:times),1));
    plotdat_BSLcorr_meanPD_rcg_scene_FAexternal_recombi(id,:) = nanmean(BSLcorr_PD_rcg_scene_FAexternal_recombi{id,1}(:,1:times),1);

    end

    % --- objects --- %
    clear tmpacc times meanBSL dat BSLcorrdTrials

    dat=pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.datai;
    meanBSL = nanmean(dat(:,1:200)');
    BSLcorrdTrials = dat-repmat(meanBSL',1,size(dat,2));

    times=length(pupil_rcg_obj_recombi{id,1}.eyeinterp.time{1,1});  
    tmpacc=accuracies_dat{id};
    tmpacc(pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.trl_raus==1)=[];
    meanPD_BSL_rcg_obj_correct_recombi(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc==1,1200:times),1));
    meanPD_BSL_rcg_obj_incorrect_recombi(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc~=1,1200:times),1));
    meanPD_BSL_rcg_obj_FAinternal_recombi(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc==-1,1200:times),1));
    meanPD_BSL_rcg_obj_FAexternal_recombi(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc==0,1200:times),1));

    BSLcorr_PD_rcg_obj_correct_recombi{id,1} = BSLcorrdTrials(tmpacc==1,1:times);
    BSLcorr_meanPD_rcg_obj_correct_recombi(id,1) = mean(nanmean(BSLcorr_PD_rcg_obj_correct_recombi{id,1}(:,1200:times),1));
    plotdat_BSLcorr_meanPD_rcg_obj_correct_recombi(id,:) = nanmean(BSLcorr_PD_rcg_obj_correct_recombi{id,1}(:,1:times),1);

    BSLcorr_PD_rcg_obj_incorrect_recombi{id,1} = BSLcorrdTrials(tmpacc~=1,1:times);
    BSLcorr_meanPD_rcg_obj_incorrect_recombi(id,1) = mean(nanmean(BSLcorr_PD_rcg_obj_incorrect_recombi{id,1}(:,1200:times),1));
    plotdat_BSLcorr_meanPD_rcg_obj_incorrect_recombi(id,:) = nanmean(BSLcorr_PD_rcg_obj_incorrect_recombi{id,1}(:,1:times),1);

    BSLcorr_PD_rcg_obj_FAinternal_recombi{id,1} = BSLcorrdTrials(tmpacc==-1,1:times);
    BSLcorr_meanPD_rcg_obj_FAinternal_recombi(id,1) = mean(nanmean(BSLcorr_PD_rcg_obj_FAinternal_recombi{id,1}(:,1200:times),1));
    plotdat_BSLcorr_meanPD_rcg_obj_FAinternal_recombi(id,:) = nanmean(BSLcorr_PD_rcg_obj_FAinternal_recombi{id,1}(:,1:times),1);

    BSLcorr_PD_rcg_obj_FAexternal_recombi{id,1} = BSLcorrdTrials(tmpacc==0,1:times);
    BSLcorr_meanPD_rcg_obj_FAexternal_recombi(id,1) = mean(nanmean(BSLcorr_PD_rcg_obj_FAexternal_recombi{id,1}(:,1200:times),1));
    plotdat_BSLcorr_meanPD_rcg_obj_FAexternal_recombi(id,:) = nanmean(BSLcorr_PD_rcg_obj_FAexternal_recombi{id,1}(:,1:times),1);

    % --- both --- %
    clear tmpacc times meanBSL dat BSLcorrdTrials

    dat=pupil_rcg_both_recombi{id,1}.eyeinterp.dat.datai;
    meanBSL = nanmean(dat(:,1:200)');
    BSLcorrdTrials = dat-repmat(meanBSL',1,size(dat,2));

    times=length(pupil_rcg_both_recombi{id,1}.eyeinterp.time{1,1});  
    tmpacc=accuracies_dat{id};
    tmpacc(pupil_rcg_both_recombi{id,1}.eyeinterp.dat.trl_raus==1)=[];
    meanPD_BSL_rcg_both_correct_recombi(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc==1,1200:times),1));
    meanPD_BSL_rcg_both_incorrect_recombi(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc~=1,1200:times),1));
    meanPD_BSL_rcg_both_FAinternal_recombi(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc==-1,1200:times),1));
    meanPD_BSL_rcg_both_FAexternal_recombi(id,1) = mean(nanmean(BSLcorrdTrials(tmpacc==0,1200:times),1));

    BSLcorr_PD_rcg_both_correct_recombi{id,1} = BSLcorrdTrials(tmpacc==1,1:times);
    BSLcorr_meanPD_rcg_both_correct_recombi(id,1) = mean(nanmean(BSLcorr_PD_rcg_both_correct_recombi{id,1}(:,1200:times),1));
    plotdat_BSLcorr_meanPD_rcg_both_correct_recombi(id,:) = nanmean(BSLcorr_PD_rcg_both_correct_recombi{id,1}(:,1:times),1);

    BSLcorr_PD_rcg_both_incorrect_recombi{id,1} = BSLcorrdTrials(tmpacc~=1,1:times);
    BSLcorr_meanPD_rcg_both_incorrect_recombi(id,1) = mean(nanmean(BSLcorr_PD_rcg_both_incorrect_recombi{id,1}(:,1200:times),1));
    plotdat_BSLcorr_meanPD_rcg_both_incorrect_recombi(id,:) = nanmean(BSLcorr_PD_rcg_both_incorrect_recombi{id,1}(:,1:times),1);

    BSLcorr_PD_rcg_both_FAinternal_recombi{id,1} = BSLcorrdTrials(tmpacc==-1,1:times);
    BSLcorr_meanPD_rcg_both_FAinternal_recombi(id,:) = mean(nanmean(BSLcorr_PD_rcg_both_FAinternal_recombi{id,1}(:,1:times),1));
    plotdat_BSLcorr_meanPD_rcg_both_FAinternal_recombi(id,:) = nanmean(BSLcorr_PD_rcg_both_FAinternal_recombi{id,1}(:,1:times),1);

    BSLcorr_PD_rcg_both_FAexternal_recombi{id,1} = BSLcorrdTrials(tmpacc==0,1:times);
    BSLcorr_meanPD_rcg_both_FAexternal_recombi(id,:) = mean(nanmean(BSLcorr_PD_rcg_both_FAexternal_recombi{id,1}(:,1:times),1));
    plotdat_BSLcorr_meanPD_rcg_both_FAexternal_recombi(id,:) = nanmean(BSLcorr_PD_rcg_both_FAexternal_recombi{id,1}(:,1:times),1);

    
    if cond(id)==1

        ec=ec+1;

        % === first: encoding === %

        % --- scenes --- %
        clear tmpacc times meanBSL dat BSLcorrdTrials

        dat=pupil_enc_scene_recombi{id,1}.eyeinterp.dat.datai;
        meanBSL = nanmean(dat(:,1:200)');
        BSLcorrdTrials = dat-repmat(meanBSL',1,size(dat,2));
        
        times=length(pupil_enc_scene_recombi{id,1}.eyeinterp.time{1,1});
        meanPD_BSL_enc_scene_emo_recombi(ec,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        BSLcorr_PD_enc_scene_emo_recombi{ec,1} = BSLcorrdTrials(:,1:times);
        BSLcorr_meanPD_enc_scene_emo_recombi(ec,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        plotdat_BSLcorr_meanPD_enc_scene_emo_recombi(ec,:) = nanmean(BSLcorrdTrials(:,1:times),1);

        % --- objects --- %
        clear tmpacc times meanBSL dat BSLcorrdTrials

        dat=pupil_enc_obj_recombi{id,1}.eyeinterp.dat.datai;
        meanBSL = nanmean(dat(:,1:200)');
        BSLcorrdTrials = dat-repmat(meanBSL',1,size(dat,2));
        
        times=length(pupil_enc_obj_recombi{id,1}.eyeinterp.time{1,1});
        meanPD_BSL_enc_obj_emo_recombi(ec,1) = mean(nanmean(BSLcorrdTrials(:,1200:times,:),1));
        BSLcorr_PD_enc_obj_emo_recombi{ec,1} = BSLcorrdTrials(:,1:times);
        BSLcorr_meanPD_enc_obj_emo_recombi(ec,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        plotdat_BSLcorr_meanPD_enc_obj_emo_recombi(ec,:) = nanmean(BSLcorrdTrials(:,1:times),1);

        % ========================= %


        
        % === next: recognition === %

        % --- scenes --- %
        clear tmpacc times meanBSL dat BSLcorrdTrials

        dat=pupil_rcg_scene_recombi{id,1}.eyeinterp.dat.datai;
        meanBSL = nanmean(dat(:,1:200)');
        BSLcorrdTrials = dat-repmat(meanBSL',1,size(dat,2));

        times=length(pupil_rcg_scene_recombi{id,1}.eyeinterp.time{1,1});
        meanPD_BSL_rcg_scene_emo_recombi(ec,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        BSLcorr_PD_rcg_scene_emo_recombi{ec,1} = BSLcorrdTrials(:,1:times);
        BSLcorr_meanPD_rcg_scene_emo_recombi(ec,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        plotdat_BSLcorr_meanPD_rcg_scene_emo_recombi(ec,:) = nanmean(BSLcorrdTrials(:,1:times),1);

        % --- objects --- %
        clear tmpacc times meanBSL dat BSLcorrdTrials

        dat=pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.datai;
        meanBSL = nanmean(dat(:,1:200)');
        BSLcorrdTrials = dat-repmat(meanBSL',1,size(dat,2));

        times=length(pupil_rcg_obj_recombi{id,1}.eyeinterp.time{1,1});
        meanPD_BSL_rcg_obj_emo_recombi(ec,1) = mean(nanmean(BSLcorrdTrials(:,1200:times,:),1));
        BSLcorr_PD_rcg_obj_emo_recombi{ec,1} = BSLcorrdTrials(:,1:times);
        BSLcorr_meanPD_rcg_obj_emo_recombi(ec,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        plotdat_BSLcorr_meanPD_rcg_obj_emo_recombi(ec,:) = nanmean(BSLcorrdTrials(:,1:times),1);

        % --- both --- %
        clear tmpacc times meanBSL dat BSLcorrdTrials

        dat=pupil_rcg_both_recombi{id,1}.eyeinterp.dat.datai;
        meanBSL = nanmean(dat(:,1:200)');
        BSLcorrdTrials = dat-repmat(meanBSL',1,size(dat,2));

        times=length(pupil_rcg_obj_recombi{id,1}.eyeinterp.time{1,1});
        meanPD_BSL_rcg_both_emo_recombi(ec,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        BSLcorr_PD_rcg_both_emo_recombi{ec,1} = BSLcorrdTrials(:,1:times);
        BSLcorr_meanPD_rcg_both_emo_recombi(ec,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        plotdat_BSLcorr_meanPD_rcg_both_emo_recombi(ec,:) = nanmean(BSLcorrdTrials(:,1:times),1);


        % = accuracy based = %
        % --- scenes --- %
        meanPD_BSL_rcg_scene_correct_emo_recombi(ec,1) = meanPD_BSL_rcg_scene_correct_recombi(id,1);
        meanPD_BSL_rcg_scene_incorrect_emo_recombi(ec,1) = meanPD_BSL_rcg_scene_incorrect_recombi(id,1);
        meanPD_BSL_rcg_scene_FAinternal_emo_recombi(ec,1) = meanPD_BSL_rcg_scene_FAinternal_recombi(id,1);
        meanPD_BSL_rcg_scene_FAexternal_emo_recombi(ec,1) = meanPD_BSL_rcg_scene_FAexternal_recombi(id,1);

        BSLcorr_PD_rcg_scene_correct_emo_recombi(ec,1) = BSLcorr_PD_rcg_scene_correct_recombi(id,1);
        BSLcorr_PD_rcg_scene_incorrect_emo_recombi(ec,1) = BSLcorr_PD_rcg_scene_incorrect_recombi(id,1);
        BSLcorr_PD_rcg_scene_FAinternal_emo_recombi(ec,1) = BSLcorr_PD_rcg_scene_FAinternal_recombi(id,1);
        BSLcorr_PD_rcg_scene_FAexternal_emo_recombi(ec,1) = BSLcorr_PD_rcg_scene_FAexternal_recombi(id,1);

        plotdat_BSLcorr_meanPD_rcg_scene_correct_emo_recombi(ec,:) = plotdat_BSLcorr_meanPD_rcg_scene_correct_recombi(id,:);
        plotdat_BSLcorr_meanPD_rcg_scene_incorrect_emo_recombi(ec,:) = plotdat_BSLcorr_meanPD_rcg_scene_incorrect_recombi(id,:);
        plotdat_BSLcorr_meanPD_rcg_scene_FAinternal_emo_recombi(ec,:) = plotdat_BSLcorr_meanPD_rcg_scene_FAinternal_recombi(id,:);
        plotdat_BSLcorr_meanPD_rcg_scene_FAexternal_emo_recombi(ec,:) = plotdat_BSLcorr_meanPD_rcg_scene_FAexternal_recombi(id,:);

        BSLcorr_meanPD_rcg_scene_correct_emo_recombi(ec,1) = BSLcorr_meanPD_rcg_scene_correct_recombi(id,1);
        BSLcorr_meanPD_rcg_scene_incorrect_emo_recombi(ec,1) = BSLcorr_meanPD_rcg_scene_incorrect_recombi(id,1);
        BSLcorr_meanPD_rcg_scene_FAinternal_emo_recombi(ec,1) = BSLcorr_meanPD_rcg_scene_FAinternal_recombi(id,1);
        BSLcorr_meanPD_rcg_scene_FAexternal_emo_recombi(ec,1) = BSLcorr_meanPD_rcg_scene_FAexternal_recombi(id,1);

        % --- objects --- %
        meanPD_BSL_rcg_obj_correct_emo_recombi(ec,1) = meanPD_BSL_rcg_obj_correct_recombi(id,1);
        meanPD_BSL_rcg_obj_incorrect_emo_recombi(ec,1) = meanPD_BSL_rcg_obj_incorrect_recombi(id,1);
        meanPD_BSL_rcg_obj_FAinternal_emo_recombi(ec,1) = meanPD_BSL_rcg_obj_FAinternal_recombi(id,1);
        meanPD_BSL_rcg_obj_FAexternal_emo_recombi(ec,1) = meanPD_BSL_rcg_obj_FAexternal_recombi(id,1);

        BSLcorr_PD_rcg_obj_correct_emo_recombi(ec,1) = BSLcorr_PD_rcg_obj_correct_recombi(id,1);
        BSLcorr_PD_rcg_obj_incorrect_emo_recombi(ec,1) = BSLcorr_PD_rcg_obj_incorrect_recombi(id,1);
        BSLcorr_PD_rcg_obj_FAinternal_emo_recombi(ec,1) = BSLcorr_PD_rcg_obj_FAinternal_recombi(id,1);
        BSLcorr_PD_rcg_obj_FAexternal_emo_recombi(ec,1) = BSLcorr_PD_rcg_obj_FAexternal_recombi(id,1);

        plotdat_BSLcorr_meanPD_rcg_obj_correct_emo_recombi(ec,:) = plotdat_BSLcorr_meanPD_rcg_obj_correct_recombi(id,:);
        plotdat_BSLcorr_meanPD_rcg_obj_incorrect_emo_recombi(ec,:) = plotdat_BSLcorr_meanPD_rcg_obj_incorrect_recombi(id,:);
        plotdat_BSLcorr_meanPD_rcg_obj_FAinternal_emo_recombi(ec,:) = plotdat_BSLcorr_meanPD_rcg_obj_FAinternal_recombi(id,:);
        plotdat_BSLcorr_meanPD_rcg_obj_FAexternal_emo_recombi(ec,:) = plotdat_BSLcorr_meanPD_rcg_obj_FAexternal_recombi(id,:);

        BSLcorr_meanPD_rcg_obj_correct_emo_recombi(ec,1) = BSLcorr_meanPD_rcg_obj_correct_recombi(id,1);
        BSLcorr_meanPD_rcg_obj_incorrect_emo_recombi(ec,1) = BSLcorr_meanPD_rcg_obj_incorrect_recombi(id,1);
        BSLcorr_meanPD_rcg_obj_FAinternal_emo_recombi(ec,1) = BSLcorr_meanPD_rcg_obj_FAinternal_recombi(id,1);
        BSLcorr_meanPD_rcg_obj_FAexternal_emo_recombi(ec,1) = BSLcorr_meanPD_rcg_obj_FAexternal_recombi(id,1);

        % --- both --- %
        meanPD_BSL_rcg_both_correct_emo_recombi(ec,1) = meanPD_BSL_rcg_both_correct_recombi(id,1);
        meanPD_BSL_rcg_both_incorrect_emo_recombi(ec,1) = meanPD_BSL_rcg_both_incorrect_recombi(id,1);
        meanPD_BSL_rcg_both_FAinternal_emo_recombi(ec,1) = meanPD_BSL_rcg_both_FAinternal_recombi(id,1);
        meanPD_BSL_rcg_both_FAexternal_emo_recombi(ec,1) = meanPD_BSL_rcg_both_FAexternal_recombi(id,1);

        BSLcorr_PD_rcg_both_correct_emo_recombi(ec,1) = BSLcorr_PD_rcg_both_correct_recombi(id,1);
        BSLcorr_PD_rcg_both_incorrect_emo_recombi(ec,1) = BSLcorr_PD_rcg_both_incorrect_recombi(id,1);
        BSLcorr_PD_rcg_both_FAinternal_emo_recombi(ec,1) = BSLcorr_PD_rcg_both_FAinternal_recombi(id,1);
        BSLcorr_PD_rcg_both_FAexternal_emo_recombi(ec,1) = BSLcorr_PD_rcg_both_FAexternal_recombi(id,1);

        plotdat_BSLcorr_meanPD_rcg_both_correct_emo_recombi(ec,:) = plotdat_BSLcorr_meanPD_rcg_both_correct_recombi(id,:);
        plotdat_BSLcorr_meanPD_rcg_both_incorrect_emo_recombi(ec,:) = plotdat_BSLcorr_meanPD_rcg_both_incorrect_recombi(id,:);
        plotdat_BSLcorr_meanPD_rcg_both_FAinternal_emo_recombi(ec,:) = plotdat_BSLcorr_meanPD_rcg_both_FAinternal_recombi(id,:);
        plotdat_BSLcorr_meanPD_rcg_both_FAexternal_emo_recombi(ec,:) = plotdat_BSLcorr_meanPD_rcg_both_FAexternal_recombi(id,:);

        BSLcorr_meanPD_rcg_both_correct_emo_recombi(ec,1) = BSLcorr_meanPD_rcg_both_correct_recombi(id,1);
        BSLcorr_meanPD_rcg_both_incorrect_emo_recombi(ec,1) = BSLcorr_meanPD_rcg_both_incorrect_recombi(id,1);
        BSLcorr_meanPD_rcg_both_FAinternal_emo_recombi(ec,1) = BSLcorr_meanPD_rcg_both_FAinternal_recombi(id,1);
        BSLcorr_meanPD_rcg_both_FAexternal_emo_recombi(ec,1) = BSLcorr_meanPD_rcg_both_FAexternal_recombi(id,1);


    elseif cond(id)==2

        % if id==18
        % else
            nc=nc+1;
        % end

        
        % === first: encoding === %

        % --- scenes --- %

        if id==18
        meanPD_BSL_enc_scene_neu_recombi(nc,1) = NaN;
        BSLcorr_PD_enc_scene_neu_recombi{nc,1} = nan(1,3701);
        BSLcorr_meanPD_enc_scene_neu_recombi(nc,1) = NaN;
        plotdat_BSLcorr_meanPD_enc_scene_neu_recombi(nc,:) = nan(1,3701);

        else
        clear tmpacc times meanBSL dat BSLcorrdTrials

        dat=pupil_enc_scene_recombi{id,1}.eyeinterp.dat.datai;
        meanBSL = nanmean(dat(:,1:200)');
        BSLcorrdTrials = dat-repmat(meanBSL',1,size(dat,2));
        
        times=length(pupil_enc_scene_recombi{id,1}.eyeinterp.time{1,1});
        meanPD_BSL_enc_scene_neu_recombi(nc,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        BSLcorr_PD_enc_scene_neu_recombi{nc,1} = BSLcorrdTrials(:,1:times);
        BSLcorr_meanPD_enc_scene_neu_recombi(nc,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        plotdat_BSLcorr_meanPD_enc_scene_neu_recombi(nc,:) = nanmean(BSLcorrdTrials(:,1:times),1);
        end

        % --- objects --- %
        clear tmpacc times meanBSL dat BSLcorrdTrials

        dat=pupil_enc_obj_recombi{id,1}.eyeinterp.dat.datai;
        meanBSL = nanmean(dat(:,1:200)');
        BSLcorrdTrials = dat-repmat(meanBSL',1,size(dat,2));
        
        times=length(pupil_enc_obj_recombi{id,1}.eyeinterp.time{1,1});
        meanPD_BSL_enc_obj_neu_recombi(nc,1) = mean(nanmean(BSLcorrdTrials(:,1200:times,:),1));
        BSLcorr_PD_enc_obj_neu_recombi{nc,1} = BSLcorrdTrials(:,1:times);
        BSLcorr_meanPD_enc_obj_neu_recombi(nc,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        plotdat_BSLcorr_meanPD_enc_obj_neu_recombi(nc,:) = nanmean(BSLcorrdTrials(:,1:times),1);

        % ========================= %


        
        % === next: recognition === %

        % --- scenes --- %
        clear tmpacc times meanBSL dat BSLcorrdTrials

        dat=pupil_rcg_scene_recombi{id,1}.eyeinterp.dat.datai;
        meanBSL = nanmean(dat(:,1:200)');
        BSLcorrdTrials = dat-repmat(meanBSL',1,size(dat,2));
        
        times=length(pupil_rcg_scene_recombi{id,1}.eyeinterp.time{1,1});
        meanPD_BSL_rcg_scene_neu_recombi(nc,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        BSLcorr_PD_rcg_scene_neu_recombi{nc,1} = BSLcorrdTrials(:,1:times);
        BSLcorr_meanPD_rcg_scene_neu_recombi(nc,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        plotdat_BSLcorr_meanPD_rcg_scene_neu_recombi(nc,:) = nanmean(BSLcorrdTrials(:,1:times),1);

        % --- objects --- %
        clear tmpacc times meanBSL dat BSLcorrdTrials

        dat=pupil_rcg_obj_recombi{id,1}.eyeinterp.dat.datai;
        meanBSL = nanmean(dat(:,1:200)');
        BSLcorrdTrials = dat-repmat(meanBSL',1,size(dat,2));

        times=length(pupil_rcg_obj_recombi{id,1}.eyeinterp.time{1,1});
        meanPD_BSL_rcg_obj_neu_recombi(nc,1) = mean(nanmean(BSLcorrdTrials(:,1200:times,:),1));
        BSLcorr_PD_rcg_obj_neu_recombi{nc,1} = BSLcorrdTrials(:,1:times);
        BSLcorr_meanPD_rcg_obj_neu_recombi(nc,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        plotdat_BSLcorr_meanPD_rcg_obj_neu_recombi(nc,:) = nanmean(BSLcorrdTrials(:,1:times),1);

        % --- both --- %
        clear tmpacc times meanBSL dat BSLcorrdTrials

        dat=pupil_rcg_both_recombi{id,1}.eyeinterp.dat.datai;
        meanBSL = nanmean(dat(:,1:200)');
        BSLcorrdTrials = dat-repmat(meanBSL',1,size(dat,2));

        times=length(pupil_rcg_obj_recombi{id,1}.eyeinterp.time{1,1});
        meanPD_BSL_rcg_both_neu_recombi(nc,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        BSLcorr_PD_rcg_both_neu_recombi{nc,1} = BSLcorrdTrials(:,1:times);
        BSLcorr_meanPD_rcg_both_neu_recombi(nc,1) = mean(nanmean(BSLcorrdTrials(:,1200:times),1));
        plotdat_BSLcorr_meanPD_rcg_both_neu_recombi(nc,:) = nanmean(BSLcorrdTrials(:,1:times),1);

        % = accuracy based = %
        % --- scenes --- %
        meanPD_BSL_rcg_scene_correct_neu_recombi(nc,1) = meanPD_BSL_rcg_scene_correct_recombi(id,1);
        meanPD_BSL_rcg_scene_incorrect_neu_recombi(nc,1) = meanPD_BSL_rcg_scene_incorrect_recombi(id,1);
        meanPD_BSL_rcg_scene_FAinternal_neu_recombi(nc,1) = meanPD_BSL_rcg_scene_FAinternal_recombi(id,1);
        meanPD_BSL_rcg_scene_FAexternal_neu_recombi(nc,1) = meanPD_BSL_rcg_scene_FAexternal_recombi(id,1);

        BSLcorr_PD_rcg_scene_correct_neu_recombi(nc,1) = BSLcorr_PD_rcg_scene_correct_recombi(id,1);
        BSLcorr_PD_rcg_scene_incorrect_neu_recombi(nc,1) = BSLcorr_PD_rcg_scene_incorrect_recombi(id,1);
        BSLcorr_PD_rcg_scene_FAinternal_neu_recombi(nc,1) = BSLcorr_PD_rcg_scene_FAinternal_recombi(id,1);
        BSLcorr_PD_rcg_scene_FAexternal_neu_recombi(nc,1) = BSLcorr_PD_rcg_scene_FAexternal_recombi(id,1);

        plotdat_BSLcorr_meanPD_rcg_scene_correct_neu_recombi(nc,:) = plotdat_BSLcorr_meanPD_rcg_scene_correct_recombi(id,:);
        plotdat_BSLcorr_meanPD_rcg_scene_incorrect_neu_recombi(nc,:) = plotdat_BSLcorr_meanPD_rcg_scene_incorrect_recombi(id,:);
        plotdat_BSLcorr_meanPD_rcg_scene_FAinternal_neu_recombi(nc,:) = plotdat_BSLcorr_meanPD_rcg_scene_FAinternal_recombi(id,:);
        plotdat_BSLcorr_meanPD_rcg_scene_FAexternal_neu_recombi(nc,:) = plotdat_BSLcorr_meanPD_rcg_scene_FAexternal_recombi(id,:);

        BSLcorr_meanPD_rcg_scene_correct_neu_recombi(nc,1) = BSLcorr_meanPD_rcg_scene_correct_recombi(id,1);
        BSLcorr_meanPD_rcg_scene_incorrect_neu_recombi(nc,1) = BSLcorr_meanPD_rcg_scene_incorrect_recombi(id,1);
        BSLcorr_meanPD_rcg_scene_FAinternal_neu_recombi(nc,1) = BSLcorr_meanPD_rcg_scene_FAinternal_recombi(id,1);
        BSLcorr_meanPD_rcg_scene_FAexternal_neu_recombi(nc,1) = BSLcorr_meanPD_rcg_scene_FAexternal_recombi(id,1);

        % --- objects --- %
        meanPD_BSL_rcg_obj_correct_neu_recombi(nc,1) = meanPD_BSL_rcg_obj_correct_recombi(id,1);
        meanPD_BSL_rcg_obj_incorrect_neu_recombi(nc,1) = meanPD_BSL_rcg_obj_incorrect_recombi(id,1);
        meanPD_BSL_rcg_obj_FAinternal_neu_recombi(nc,1) = meanPD_BSL_rcg_obj_FAinternal_recombi(id,1);
        meanPD_BSL_rcg_obj_FAexternal_neu_recombi(nc,1) = meanPD_BSL_rcg_obj_FAexternal_recombi(id,1);

        BSLcorr_PD_rcg_obj_correct_neu_recombi(nc,1) = BSLcorr_PD_rcg_obj_correct_recombi(id,1);
        BSLcorr_PD_rcg_obj_incorrect_neu_recombi(nc,1) = BSLcorr_PD_rcg_obj_incorrect_recombi(id,1);
        BSLcorr_PD_rcg_obj_FAinternal_neu_recombi(nc,1) = BSLcorr_PD_rcg_obj_FAinternal_recombi(id,1);
        BSLcorr_PD_rcg_obj_FAexternal_neu_recombi(nc,1) = BSLcorr_PD_rcg_obj_FAexternal_recombi(id,1);

        plotdat_BSLcorr_meanPD_rcg_obj_correct_neu_recombi(nc,:) = plotdat_BSLcorr_meanPD_rcg_obj_correct_recombi(id,:);
        plotdat_BSLcorr_meanPD_rcg_obj_incorrect_neu_recombi(nc,:) = plotdat_BSLcorr_meanPD_rcg_obj_incorrect_recombi(id,:);
        plotdat_BSLcorr_meanPD_rcg_obj_FAinternal_neu_recombi(nc,:) = plotdat_BSLcorr_meanPD_rcg_obj_FAinternal_recombi(id,:);
        plotdat_BSLcorr_meanPD_rcg_obj_FAexternal_neu_recombi(nc,:) = plotdat_BSLcorr_meanPD_rcg_obj_FAexternal_recombi(id,:);

        BSLcorr_meanPD_rcg_obj_correct_neu_recombi(nc,1) = BSLcorr_meanPD_rcg_obj_correct_recombi(id,1);
        BSLcorr_meanPD_rcg_obj_incorrect_neu_recombi(nc,1) = BSLcorr_meanPD_rcg_obj_incorrect_recombi(id,1);
        BSLcorr_meanPD_rcg_obj_FAinternal_neu_recombi(nc,1) = BSLcorr_meanPD_rcg_obj_FAinternal_recombi(id,1);
        BSLcorr_meanPD_rcg_obj_FAexternal_neu_recombi(nc,1) = BSLcorr_meanPD_rcg_obj_FAexternal_recombi(id,1);

        % --- both --- %
        meanPD_BSL_rcg_both_correct_neu_recombi(nc,1) = meanPD_BSL_rcg_both_correct_recombi(id,1);
        meanPD_BSL_rcg_both_incorrect_neu_recombi(nc,1) = meanPD_BSL_rcg_both_incorrect_recombi(id,1);
        meanPD_BSL_rcg_both_FAinternal_neu_recombi(nc,1) = meanPD_BSL_rcg_both_FAinternal_recombi(id,1);
        meanPD_BSL_rcg_both_FAexternal_neu_recombi(nc,1) = meanPD_BSL_rcg_both_FAexternal_recombi(id,1);

        BSLcorr_PD_rcg_both_correct_neu_recombi(nc,1) = BSLcorr_PD_rcg_both_correct_recombi(id,1);
        BSLcorr_PD_rcg_both_incorrect_neu_recombi(nc,1) = BSLcorr_PD_rcg_both_incorrect_recombi(id,1);
        BSLcorr_PD_rcg_both_FAinternal_neu_recombi(nc,1) = BSLcorr_PD_rcg_both_FAinternal_recombi(id,1);
        BSLcorr_PD_rcg_both_FAexternal_neu_recombi(nc,1) = BSLcorr_PD_rcg_both_FAexternal_recombi(id,1);

        plotdat_BSLcorr_meanPD_rcg_both_correct_neu_recombi(nc,:) = plotdat_BSLcorr_meanPD_rcg_both_correct_recombi(id,:);
        plotdat_BSLcorr_meanPD_rcg_both_incorrect_neu_recombi(nc,:) = plotdat_BSLcorr_meanPD_rcg_both_incorrect_recombi(id,:);
        plotdat_BSLcorr_meanPD_rcg_both_FAinternal_neu_recombi(nc,:) = plotdat_BSLcorr_meanPD_rcg_both_FAinternal_recombi(id,:);
        plotdat_BSLcorr_meanPD_rcg_both_FAexternal_neu_recombi(nc,:) = plotdat_BSLcorr_meanPD_rcg_both_FAexternal_recombi(id,:);

        BSLcorr_meanPD_rcg_both_correct_neu_recombi(nc,1) = BSLcorr_meanPD_rcg_both_correct_recombi(id,1);
        BSLcorr_meanPD_rcg_both_incorrect_neu_recombi(nc,1) = BSLcorr_meanPD_rcg_both_incorrect_recombi(id,1);
        BSLcorr_meanPD_rcg_both_FAinternal_neu_recombi(nc,1) = BSLcorr_meanPD_rcg_both_FAinternal_recombi(id,1);
        BSLcorr_meanPD_rcg_both_FAexternal_neu_recombi(nc,1) = BSLcorr_meanPD_rcg_both_FAexternal_recombi(id,1);


    end
end

%% make a table : BSLcorrected

ID=ids;
BehavPilot_PupildataTable = table(...
   ID,...
   meanPD_BSL_rcg_scene_correct_orig,meanPD_BSL_rcg_scene_incorrect_orig,meanPD_BSL_rcg_scene_FAinternal_orig,meanPD_BSL_rcg_scene_FAexternal_orig,...
   meanPD_BSL_rcg_obj_correct_orig,meanPD_BSL_rcg_obj_incorrect_orig,meanPD_BSL_rcg_obj_FAinternal_orig,meanPD_BSL_rcg_obj_FAexternal_orig,...
   meanPD_BSL_rcg_both_correct_orig,meanPD_BSL_rcg_both_incorrect_orig,meanPD_BSL_rcg_both_FAinternal_orig,meanPD_BSL_rcg_both_FAexternal_orig,...
   meanPD_BSL_rcg_scene_correct_retest,meanPD_BSL_rcg_scene_incorrect_retest,meanPD_BSL_rcg_scene_FAinternal_retest,meanPD_BSL_rcg_scene_FAexternal_retest,...
   meanPD_BSL_rcg_obj_correct_retest,meanPD_BSL_rcg_obj_incorrect_retest,meanPD_BSL_rcg_obj_FAinternal_retest,meanPD_BSL_rcg_obj_FAexternal_retest,...
   meanPD_BSL_rcg_both_correct_retest,meanPD_BSL_rcg_both_incorrect_retest,meanPD_BSL_rcg_both_FAinternal_retest,meanPD_BSL_rcg_both_FAexternal_retest,...
   meanPD_BSL_rcg_scene_correct_recombi,meanPD_BSL_rcg_scene_incorrect_recombi,meanPD_BSL_rcg_scene_FAinternal_recombi,meanPD_BSL_rcg_scene_FAexternal_recombi,...
   meanPD_BSL_rcg_obj_correct_recombi,meanPD_BSL_rcg_obj_incorrect_recombi,meanPD_BSL_rcg_obj_FAinternal_recombi,meanPD_BSL_rcg_obj_FAexternal_recombi,...
   meanPD_BSL_rcg_both_correct_recombi,meanPD_BSL_rcg_both_incorrect_recombi,meanPD_BSL_rcg_both_FAinternal_recombi,meanPD_BSL_rcg_both_FAexternal_recombi);
writetable(BehavPilot_PupildataTable,['/Users/alex/Dropbox/paperwriting/1315/data/BehavPilot_PupildataTable_AllSubs_' date '_BSLcorrectedOnly.xls'])

ID=ids(1:2:44);
BehavPilot_EMO_PupildataTable = table(...
   ID,...
   meanPD_BSL_enc_scene_emo_orig,meanPD_BSL_enc_obj_emo_orig,...
   meanPD_BSL_rcg_scene_emo_orig,meanPD_BSL_rcg_obj_emo_orig,meanPD_BSL_rcg_both_emo_orig,...
   meanPD_BSL_rcg_scene_correct_emo_orig,meanPD_BSL_rcg_scene_incorrect_emo_orig,meanPD_BSL_rcg_scene_FAinternal_emo_orig,meanPD_BSL_rcg_scene_FAexternal_emo_orig,...
   meanPD_BSL_rcg_obj_correct_emo_orig,meanPD_BSL_rcg_obj_incorrect_emo_orig,meanPD_BSL_rcg_obj_FAinternal_emo_orig,meanPD_BSL_rcg_obj_FAexternal_emo_orig,...
   meanPD_BSL_rcg_both_correct_emo_orig,meanPD_BSL_rcg_both_incorrect_emo_orig,meanPD_BSL_rcg_both_FAinternal_emo_orig,meanPD_BSL_rcg_both_FAexternal_emo_orig,...
   meanPD_BSL_rcg_scene_correct_emo_retest,meanPD_BSL_rcg_scene_incorrect_emo_retest,meanPD_BSL_rcg_scene_FAinternal_emo_retest,meanPD_BSL_rcg_scene_FAexternal_emo_retest,...
   meanPD_BSL_rcg_obj_correct_emo_retest,meanPD_BSL_rcg_obj_incorrect_emo_retest,meanPD_BSL_rcg_obj_FAinternal_emo_retest,meanPD_BSL_rcg_obj_FAexternal_emo_retest,...
   meanPD_BSL_rcg_both_correct_emo_retest,meanPD_BSL_rcg_both_incorrect_emo_retest,meanPD_BSL_rcg_both_FAinternal_emo_retest,meanPD_BSL_rcg_both_FAexternal_emo_retest,...
   meanPD_BSL_rcg_scene_correct_emo_recombi,meanPD_BSL_rcg_scene_incorrect_emo_recombi,meanPD_BSL_rcg_scene_FAinternal_emo_recombi,meanPD_BSL_rcg_scene_FAexternal_emo_recombi,...
   meanPD_BSL_rcg_obj_correct_emo_recombi,meanPD_BSL_rcg_obj_incorrect_emo_recombi,meanPD_BSL_rcg_obj_FAinternal_emo_recombi,meanPD_BSL_rcg_obj_FAexternal_emo_recombi,...
   meanPD_BSL_rcg_both_correct_emo_recombi,meanPD_BSL_rcg_both_incorrect_emo_recombi,meanPD_BSL_rcg_both_FAinternal_emo_recombi,meanPD_BSL_rcg_both_FAexternal_emo_recombi)
writetable(BehavPilot_EMO_PupildataTable,['/Users/alex/Dropbox/paperwriting/1315/data/BehavPilot_PupildataTable_Emo_' date '_BSLcorrectedOnly.xls'])

ID=ids(2:2:44);
BehavPilot_NEU_PupildataTable = table(...
   ID,...
   meanPD_BSL_enc_scene_neu_orig,meanPD_BSL_enc_obj_neu_orig,...
   meanPD_BSL_rcg_scene_neu_orig,meanPD_BSL_rcg_obj_neu_orig,meanPD_BSL_rcg_both_neu_orig,...
   meanPD_BSL_rcg_scene_correct_neu_orig,meanPD_BSL_rcg_scene_incorrect_neu_orig,meanPD_BSL_rcg_scene_FAinternal_neu_orig,meanPD_BSL_rcg_scene_FAexternal_neu_orig,...
   meanPD_BSL_rcg_obj_correct_neu_orig,meanPD_BSL_rcg_obj_incorrect_neu_orig,meanPD_BSL_rcg_obj_FAinternal_neu_orig,meanPD_BSL_rcg_obj_FAexternal_neu_orig,...
   meanPD_BSL_rcg_both_correct_neu_orig,meanPD_BSL_rcg_both_incorrect_neu_orig,meanPD_BSL_rcg_both_FAinternal_neu_orig,meanPD_BSL_rcg_both_FAexternal_neu_orig,...
   meanPD_BSL_rcg_scene_correct_neu_retest,meanPD_BSL_rcg_scene_incorrect_neu_retest,meanPD_BSL_rcg_scene_FAinternal_neu_retest,meanPD_BSL_rcg_scene_FAexternal_neu_retest,...
   meanPD_BSL_rcg_obj_correct_neu_retest,meanPD_BSL_rcg_obj_incorrect_neu_retest,meanPD_BSL_rcg_obj_FAinternal_neu_retest,meanPD_BSL_rcg_obj_FAexternal_neu_retest,...
   meanPD_BSL_rcg_both_correct_neu_retest,meanPD_BSL_rcg_both_incorrect_neu_retest,meanPD_BSL_rcg_both_FAinternal_neu_retest,meanPD_BSL_rcg_both_FAexternal_neu_retest,...
   meanPD_BSL_rcg_scene_correct_neu_recombi,meanPD_BSL_rcg_scene_incorrect_neu_recombi,meanPD_BSL_rcg_scene_FAinternal_neu_recombi,meanPD_BSL_rcg_scene_FAexternal_neu_recombi,...
   meanPD_BSL_rcg_obj_correct_neu_recombi,meanPD_BSL_rcg_obj_incorrect_neu_recombi,meanPD_BSL_rcg_obj_FAinternal_neu_recombi,meanPD_BSL_rcg_obj_FAexternal_neu_recombi,...
   meanPD_BSL_rcg_both_correct_neu_recombi,meanPD_BSL_rcg_both_incorrect_neu_recombi,meanPD_BSL_rcg_both_FAinternal_neu_recombi,meanPD_BSL_rcg_both_FAexternal_neu_recombi)
writetable(BehavPilot_NEU_PupildataTable,['/Users/alex/Dropbox/paperwriting/1315/data/BehavPilot_PupildataTable_NEU_' date '_BSLcorrectedOnly.xls']);


%% make a table : Zscored


ID=ids;
BehavPilot_PupildataTable = table(...
   ID,...
   Zscore_meanPD_rcg_scene_correct_orig,Zscore_meanPD_rcg_scene_incorrect_orig,Zscore_meanPD_rcg_scene_FAinternal_orig,Zscore_meanPD_rcg_scene_FAexternal_orig,...
   Zscore_meanPD_rcg_obj_correct_orig,Zscore_meanPD_rcg_obj_incorrect_orig,Zscore_meanPD_rcg_obj_FAinternal_orig,Zscore_meanPD_rcg_obj_FAexternal_orig,...
   Zscore_meanPD_rcg_both_correct_orig,Zscore_meanPD_rcg_both_incorrect_orig,Zscore_meanPD_rcg_both_FAinternal_orig,Zscore_meanPD_rcg_both_FAexternal_orig,...
   Zscore_meanPD_rcg_scene_correct_retest,Zscore_meanPD_rcg_scene_incorrect_retest,Zscore_meanPD_rcg_scene_FAinternal_retest,Zscore_meanPD_rcg_scene_FAexternal_retest,...
   Zscore_meanPD_rcg_obj_correct_retest,Zscore_meanPD_rcg_obj_incorrect_retest,Zscore_meanPD_rcg_obj_FAinternal_retest,Zscore_meanPD_rcg_obj_FAexternal_retest,...
   Zscore_meanPD_rcg_both_correct_retest,Zscore_meanPD_rcg_both_incorrect_retest,Zscore_meanPD_rcg_both_FAinternal_retest,Zscore_meanPD_rcg_both_FAexternal_retest,...
   Zscore_meanPD_rcg_scene_correct_recombi,Zscore_meanPD_rcg_scene_incorrect_recombi,Zscore_meanPD_rcg_scene_FAinternal_recombi,Zscore_meanPD_rcg_scene_FAexternal_recombi,...
   Zscore_meanPD_rcg_obj_correct_recombi,Zscore_meanPD_rcg_obj_incorrect_recombi,Zscore_meanPD_rcg_obj_FAinternal_recombi,Zscore_meanPD_rcg_obj_FAexternal_recombi,...
   Zscore_meanPD_rcg_both_correct_recombi,Zscore_meanPD_rcg_both_incorrect_recombi,Zscore_meanPD_rcg_both_FAinternal_recombi,Zscore_meanPD_rcg_both_FAexternal_recombi);
writetable(BehavPilot_PupildataTable,['/Users/alex/Dropbox/paperwriting/1315/data/BehavPilot_PupildataTable_AllSubs_' date '_Zscored.xls'])

ID=ids(1:2:44);
BehavPilot_EMO_PupildataTable = table(...
   ID,...
   Zscore_meanPD_enc_scene_emo_orig,Zscore_meanPD_enc_obj_emo_orig,...
   Zscore_meanPD_rcg_scene_emo_orig,Zscore_meanPD_rcg_obj_emo_orig,Zscore_meanPD_rcg_both_emo_orig,...
   Zscore_meanPD_rcg_scene_correct_emo_orig,Zscore_meanPD_rcg_scene_incorrect_emo_orig,Zscore_meanPD_rcg_scene_FAinternal_emo_orig,Zscore_meanPD_rcg_scene_FAexternal_emo_orig,...
   Zscore_meanPD_rcg_obj_correct_emo_orig,Zscore_meanPD_rcg_obj_incorrect_emo_orig,Zscore_meanPD_rcg_obj_FAinternal_emo_orig,Zscore_meanPD_rcg_obj_FAexternal_emo_orig,...
   Zscore_meanPD_rcg_both_correct_emo_orig,Zscore_meanPD_rcg_both_incorrect_emo_orig,Zscore_meanPD_rcg_both_FAinternal_emo_orig,Zscore_meanPD_rcg_both_FAexternal_emo_orig,...
   Zscore_meanPD_rcg_scene_correct_emo_retest,Zscore_meanPD_rcg_scene_incorrect_emo_retest,Zscore_meanPD_rcg_scene_FAinternal_emo_retest,Zscore_meanPD_rcg_scene_FAexternal_emo_retest,...
   Zscore_meanPD_rcg_obj_correct_emo_retest,Zscore_meanPD_rcg_obj_incorrect_emo_retest,Zscore_meanPD_rcg_obj_FAinternal_emo_retest,Zscore_meanPD_rcg_obj_FAexternal_emo_retest,...
   Zscore_meanPD_rcg_both_correct_emo_retest,Zscore_meanPD_rcg_both_incorrect_emo_retest,Zscore_meanPD_rcg_both_FAinternal_emo_retest,Zscore_meanPD_rcg_both_FAexternal_emo_retest,...
   Zscore_meanPD_rcg_scene_correct_emo_recombi,Zscore_meanPD_rcg_scene_incorrect_emo_recombi,Zscore_meanPD_rcg_scene_FAinternal_emo_recombi,Zscore_meanPD_rcg_scene_FAexternal_emo_recombi,...
   Zscore_meanPD_rcg_obj_correct_emo_recombi,Zscore_meanPD_rcg_obj_incorrect_emo_recombi,Zscore_meanPD_rcg_obj_FAinternal_emo_recombi,Zscore_meanPD_rcg_obj_FAexternal_emo_recombi,...
   Zscore_meanPD_rcg_both_correct_emo_recombi,Zscore_meanPD_rcg_both_incorrect_emo_recombi,Zscore_meanPD_rcg_both_FAinternal_emo_recombi,Zscore_meanPD_rcg_both_FAexternal_emo_recombi)
writetable(BehavPilot_EMO_PupildataTable,['/Users/alex/Dropbox/paperwriting/1315/data/BehavPilot_PupildataTable_Emo_' date '_Zscored.xls'])

ID=ids(2:2:44);
BehavPilot_NEU_PupildataTable = table(...
   ID,...
   Zscore_meanPD_enc_scene_neu_orig,Zscore_meanPD_enc_obj_neu_orig,...
   Zscore_meanPD_rcg_scene_neu_orig,Zscore_meanPD_rcg_obj_neu_orig,Zscore_meanPD_rcg_both_neu_orig,...
   Zscore_meanPD_rcg_scene_correct_neu_orig,Zscore_meanPD_rcg_scene_incorrect_neu_orig,Zscore_meanPD_rcg_scene_FAinternal_neu_orig,Zscore_meanPD_rcg_scene_FAexternal_neu_orig,...
   Zscore_meanPD_rcg_obj_correct_neu_orig,Zscore_meanPD_rcg_obj_incorrect_neu_orig,Zscore_meanPD_rcg_obj_FAinternal_neu_orig,Zscore_meanPD_rcg_obj_FAexternal_neu_orig,...
   Zscore_meanPD_rcg_both_correct_neu_orig,Zscore_meanPD_rcg_both_incorrect_neu_orig,Zscore_meanPD_rcg_both_FAinternal_neu_orig,Zscore_meanPD_rcg_both_FAexternal_neu_orig,...
   Zscore_meanPD_rcg_scene_correct_neu_retest,Zscore_meanPD_rcg_scene_incorrect_neu_retest,Zscore_meanPD_rcg_scene_FAinternal_neu_retest,Zscore_meanPD_rcg_scene_FAexternal_neu_retest,...
   Zscore_meanPD_rcg_obj_correct_neu_retest,Zscore_meanPD_rcg_obj_incorrect_neu_retest,Zscore_meanPD_rcg_obj_FAinternal_neu_retest,Zscore_meanPD_rcg_obj_FAexternal_neu_retest,...
   Zscore_meanPD_rcg_both_correct_neu_retest,Zscore_meanPD_rcg_both_incorrect_neu_retest,Zscore_meanPD_rcg_both_FAinternal_neu_retest,Zscore_meanPD_rcg_both_FAexternal_neu_retest,...
   Zscore_meanPD_rcg_scene_correct_neu_recombi,Zscore_meanPD_rcg_scene_incorrect_neu_recombi,Zscore_meanPD_rcg_scene_FAinternal_neu_recombi,Zscore_meanPD_rcg_scene_FAexternal_neu_recombi,...
   Zscore_meanPD_rcg_obj_correct_neu_recombi,Zscore_meanPD_rcg_obj_incorrect_neu_recombi,Zscore_meanPD_rcg_obj_FAinternal_neu_recombi,Zscore_meanPD_rcg_obj_FAexternal_neu_recombi,...
   Zscore_meanPD_rcg_both_correct_neu_recombi,Zscore_meanPD_rcg_both_incorrect_neu_recombi,Zscore_meanPD_rcg_both_FAinternal_neu_recombi,Zscore_meanPD_rcg_both_FAexternal_neu_recombi)
writetable(BehavPilot_NEU_PupildataTable,['/Users/alex/Dropbox/paperwriting/1315/data/BehavPilot_PupildataTable_NEU_' date '_Zscored.xls']);



%% plotting z scores

% clc;clear;

% % load('/Users/alex/Dropbox/paperwriting/1315/data/Zscores_Pupil.mat')

%% orig session

close all

clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_Zscore_meanPD_rcg_scene_correct_emo_orig;
data2 = plotdat_Zscore_meanPD_rcg_scene_correct_neu_orig;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
%ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Correct trials: emotional: red / neutral: blue','Original Set, Scenes'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 

%%%%%%%%%%%

clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_Zscore_meanPD_rcg_scene_incorrect_emo_orig;
data2 = plotdat_Zscore_meanPD_rcg_scene_incorrect_neu_orig;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Incorrect trials: emotional: red / neutral: blue','Original Set, Scenes'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 


%%%%%%%%%%%%%


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_Zscore_meanPD_rcg_scene_correct_emo_orig;
data2 = plotdat_Zscore_meanPD_rcg_scene_incorrect_emo_orig;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Emotional trials: incorrect: red / correct: green','Original Set, Scenes'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 



%%%%%%%%%%%%%


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_Zscore_meanPD_rcg_scene_correct_neu_orig;
data2 = plotdat_Zscore_meanPD_rcg_scene_incorrect_neu_orig;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Neutral trials: incorrect: red / correct: green','Original Set, Scenes'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_Zscore_meanPD_rcg_obj_correct_emo_orig;
data2 = plotdat_Zscore_meanPD_rcg_obj_correct_neu_orig;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
%ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Correct trials: emotional: red / neutral: blue','Original Set, objects'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 

%%%%%%%%%%%

clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_Zscore_meanPD_rcg_obj_incorrect_emo_orig;
data2 = plotdat_Zscore_meanPD_rcg_obj_incorrect_neu_orig;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Incorrect trials: emotional: red / neutral: blue','Original Set, objects'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 


%%%%%%%%%%%%%


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_Zscore_meanPD_rcg_obj_correct_emo_orig;
data2 = plotdat_Zscore_meanPD_rcg_obj_incorrect_emo_orig;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Emotional trials: incorrect: red / correct: green','Original Set, objects'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 



%%%%%%%%%%%%%


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_Zscore_meanPD_rcg_obj_correct_neu_orig;
data2 = plotdat_Zscore_meanPD_rcg_obj_incorrect_neu_orig;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Neutral trials: incorrect: red / correct: green','Original Set, objects'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 

%%%%%%%%%%%

clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_Zscore_meanPD_rcg_both_incorrect_emo_orig;
data2 = plotdat_Zscore_meanPD_rcg_both_incorrect_neu_orig;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Incorrect trials: emotional: red / neutral: blue','Original Set, Scene & Obj'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 


%%%%%%%%%%%%%


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_Zscore_meanPD_rcg_both_correct_emo_orig;
data2 = plotdat_Zscore_meanPD_rcg_both_incorrect_emo_orig;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Emotional trials: incorrect: red / correct: green','Original Set, Scene & Obj'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 



%%%%%%%%%%%%%


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_Zscore_meanPD_rcg_both_correct_neu_orig;
data2 = plotdat_Zscore_meanPD_rcg_both_incorrect_neu_orig;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Neutral trials: incorrect: red / correct: green','Original Set, Scene & Obj'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 


mkdir('/Users/alex/Dropbox/paperwriting/1315/fig/Zscore/OrigSession')
cd('/Users/alex/Dropbox/paperwriting/1315/fig/Zscore/OrigSession')
saveDir = '/Users/alex/Dropbox/paperwriting/1315/fig/Zscore/OrigSession'; 

figList = findobj(allchild(0), 'flat', 'Type', 'figure');

% Loop through all figures and save
for i = 1:length(figList)
    figHandle = figList(i);
    filename = fullfile(saveDir, sprintf('Figure_%d.fig', figHandle.Number));

    saveas(figHandle, filename);
    
end


%% recombi

close all

clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_Zscore_meanPD_rcg_scene_correct_emo_recombi;
data2 = plotdat_Zscore_meanPD_rcg_scene_correct_neu_recombi;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
%ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Correct trials: emotional: red / neutral: blue','Recombi Set, scenes'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 

%%%%%%%%%%%

clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_Zscore_meanPD_rcg_scene_incorrect_emo_recombi;
data2 = plotdat_Zscore_meanPD_rcg_scene_incorrect_neu_recombi;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Incorrect trials: emotional: red / neutral: blue','Recombi Set, scenes'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 


%%%%%%%%%%%%%


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_Zscore_meanPD_rcg_scene_correct_emo_recombi;
data2 = plotdat_Zscore_meanPD_rcg_scene_incorrect_emo_recombi;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Emotional trials: incorrect: red / correct: green','Recombi Set, scenes'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 



%%%%%%%%%%%%%

clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_Zscore_meanPD_rcg_scene_correct_neu_recombi;
data2 = plotdat_Zscore_meanPD_rcg_scene_incorrect_neu_recombi;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Neutral trials: incorrect: red / correct: green','Recombi Set, scenes'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_Zscore_meanPD_rcg_obj_correct_emo_recombi;
data2 = plotdat_Zscore_meanPD_rcg_obj_correct_neu_recombi;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
%ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Correct trials: emotional: red / neutral: blue','Recombi Set, objects'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 

%%%%%%%%%%%

clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_Zscore_meanPD_rcg_obj_incorrect_emo_recombi;
data2 = plotdat_Zscore_meanPD_rcg_obj_incorrect_neu_recombi;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Incorrect trials: emotional: red / neutral: blue','Recombi Set, objects'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 


%%%%%%%%%%%%%


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_Zscore_meanPD_rcg_obj_correct_emo_recombi;
data2 = plotdat_Zscore_meanPD_rcg_obj_incorrect_emo_recombi;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Emotional trials: incorrect: red / correct: green','Recombi Set, objects'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 



%%%%%%%%%%%%%


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_Zscore_meanPD_rcg_obj_correct_neu_recombi;
data2 = plotdat_Zscore_meanPD_rcg_obj_incorrect_neu_recombi;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Neutral trials: incorrect: red / correct: green','Recombi Set, objects'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 

%%%%%%%%%%%

clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_Zscore_meanPD_rcg_both_incorrect_emo_recombi;
data2 = plotdat_Zscore_meanPD_rcg_both_incorrect_neu_recombi;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Incorrect trials: emotional: red / neutral: blue','Recombi Set, Scene & Obj'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 


%%%%%%%%%%%%%


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_Zscore_meanPD_rcg_both_correct_emo_recombi;
data2 = plotdat_Zscore_meanPD_rcg_both_incorrect_emo_recombi;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Emotional trials: incorrect: red / correct: green','Recombi Set, Scene & Obj'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 



%%%%%%%%%%%%%


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_Zscore_meanPD_rcg_both_correct_neu_recombi;
data2 = plotdat_Zscore_meanPD_rcg_both_incorrect_neu_recombi;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Neutral trials: incorrect: red / correct: green','Recombi Set, Scene & Obj'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 


mkdir('/Users/alex/Dropbox/paperwriting/1315/fig/Zscore/RecombiSession')
cd('/Users/alex/Dropbox/paperwriting/1315/fig/Zscore/RecombiSession')
saveDir = '/Users/alex/Dropbox/paperwriting/1315/fig/Zscore/RecombiSession'; 

figList = findobj(allchild(0), 'flat', 'Type', 'figure');

% Loop through all figures and save
for i = 1:length(figList)
    figHandle = figList(i);
    filename = fullfile(saveDir, sprintf('Figure_%d.fig', figHandle.Number));

    saveas(figHandle, filename);
    
end


%% retest

close all

clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_Zscore_meanPD_rcg_scene_correct_emo_retest;
data2 = plotdat_Zscore_meanPD_rcg_scene_correct_neu_retest;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
%ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Correct trials: emotional: red / neutral: blue','Retest Set, scenes'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 

%%%%%%%%%%%

clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_Zscore_meanPD_rcg_scene_incorrect_emo_retest;
data2 = plotdat_Zscore_meanPD_rcg_scene_incorrect_neu_retest;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Incorrect trials: emotional: red / neutral: blue','Retest Set, scenes'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 


%%%%%%%%%%%%%


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_Zscore_meanPD_rcg_scene_correct_emo_retest;
data2 = plotdat_Zscore_meanPD_rcg_scene_incorrect_emo_retest;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Emotional trials: incorrect: red / correct: green','Retest Set, scenes'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 



%%%%%%%%%%%%%

clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_Zscore_meanPD_rcg_scene_correct_neu_retest;
data2 = plotdat_Zscore_meanPD_rcg_scene_incorrect_neu_retest;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Neutral trials: incorrect: red / correct: green','Retest Set, scenes'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_Zscore_meanPD_rcg_obj_correct_emo_retest;
data2 = plotdat_Zscore_meanPD_rcg_obj_correct_neu_retest;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
%ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Correct trials: emotional: red / neutral: blue','Retest Set, objects'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 

%%%%%%%%%%%

clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_Zscore_meanPD_rcg_obj_incorrect_emo_retest;
data2 = plotdat_Zscore_meanPD_rcg_obj_incorrect_neu_retest;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Incorrect trials: emotional: red / neutral: blue','Retest Set, objects'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 


%%%%%%%%%%%%%


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_Zscore_meanPD_rcg_obj_correct_emo_retest;
data2 = plotdat_Zscore_meanPD_rcg_obj_incorrect_emo_retest;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Emotional trials: incorrect: red / correct: green','Retest Set, objects'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 



%%%%%%%%%%%%%


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_Zscore_meanPD_rcg_obj_correct_neu_retest;
data2 = plotdat_Zscore_meanPD_rcg_obj_incorrect_neu_retest;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Neutral trials: incorrect: red / correct: green','Retest Set, objects'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 

%%%%%%%%%%%

clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_Zscore_meanPD_rcg_both_incorrect_emo_retest;
data2 = plotdat_Zscore_meanPD_rcg_both_incorrect_neu_retest;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Incorrect trials: emotional: red / neutral: blue','Retest Set, Scene & Obj'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 


%%%%%%%%%%%%%


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_Zscore_meanPD_rcg_both_correct_emo_retest;
data2 = plotdat_Zscore_meanPD_rcg_both_incorrect_emo_retest;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Emotional trials: incorrect: red / correct: green','Retest Set, Scene & Obj'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 



%%%%%%%%%%%%%


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_Zscore_meanPD_rcg_both_correct_neu_retest;
data2 = plotdat_Zscore_meanPD_rcg_both_incorrect_neu_retest;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Neutral trials: incorrect: red / correct: green','Retest Set, Scene & Obj'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 


mkdir('/Users/alex/Dropbox/paperwriting/1315/fig/Zscore/RetestSession')
cd('/Users/alex/Dropbox/paperwriting/1315/fig/Zscore/RetestSession')
saveDir = '/Users/alex/Dropbox/paperwriting/1315/fig/Zscore/RetestSession'; 

figList = findobj(allchild(0), 'flat', 'Type', 'figure');


% Loop through all figures and save
for i = 1:length(figList)
    figHandle = figList(i);
    filename = fullfile(saveDir, sprintf('Figure_%d.fig', figHandle.Number));

    saveas(figHandle, filename);
    
end

%% orig session

close all

clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_BSLcorr_meanPD_rcg_scene_correct_emo_orig;
data2 = plotdat_BSLcorr_meanPD_rcg_scene_correct_neu_orig;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
%ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Correct trials: emotional: red / neutral: blue','Original Set, Scenes'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 

%%%%%%%%%%%

clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_BSLcorr_meanPD_rcg_scene_incorrect_emo_orig;
data2 = plotdat_BSLcorr_meanPD_rcg_scene_incorrect_neu_orig;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Incorrect trials: emotional: red / neutral: blue','Original Set, Scenes'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 


%%%%%%%%%%%%%


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_BSLcorr_meanPD_rcg_scene_correct_emo_orig;
data2 = plotdat_BSLcorr_meanPD_rcg_scene_incorrect_emo_orig;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Emotional trials: incorrect: red / correct: green','Original Set, Scenes'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 



%%%%%%%%%%%%%


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_BSLcorr_meanPD_rcg_scene_correct_neu_orig;
data2 = plotdat_BSLcorr_meanPD_rcg_scene_incorrect_neu_orig;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Neutral trials: incorrect: red / correct: green','Original Set, Scenes'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_BSLcorr_meanPD_rcg_obj_correct_emo_orig;
data2 = plotdat_BSLcorr_meanPD_rcg_obj_correct_neu_orig;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
%ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Correct trials: emotional: red / neutral: blue','Original Set, objects'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 

%%%%%%%%%%%

clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_BSLcorr_meanPD_rcg_obj_incorrect_emo_orig;
data2 = plotdat_BSLcorr_meanPD_rcg_obj_incorrect_neu_orig;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Incorrect trials: emotional: red / neutral: blue','Original Set, objects'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 


%%%%%%%%%%%%%


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_BSLcorr_meanPD_rcg_obj_correct_emo_orig;
data2 = plotdat_BSLcorr_meanPD_rcg_obj_incorrect_emo_orig;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Emotional trials: incorrect: red / correct: green','Original Set, objects'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 



%%%%%%%%%%%%%


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_BSLcorr_meanPD_rcg_obj_correct_neu_orig;
data2 = plotdat_BSLcorr_meanPD_rcg_obj_incorrect_neu_orig;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Neutral trials: incorrect: red / correct: green','Original Set, objects'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 

%%%%%%%%%%%

clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_BSLcorr_meanPD_rcg_both_incorrect_emo_orig;
data2 = plotdat_BSLcorr_meanPD_rcg_both_incorrect_neu_orig;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Incorrect trials: emotional: red / neutral: blue','Original Set, Scene & Obj'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 


%%%%%%%%%%%%%


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_BSLcorr_meanPD_rcg_both_correct_emo_orig;
data2 = plotdat_BSLcorr_meanPD_rcg_both_incorrect_emo_orig;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Emotional trials: incorrect: red / correct: green','Original Set, Scene & Obj'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 



%%%%%%%%%%%%%


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_BSLcorr_meanPD_rcg_both_correct_neu_orig;
data2 = plotdat_BSLcorr_meanPD_rcg_both_incorrect_neu_orig;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Neutral trials: incorrect: red / correct: green','Original Set, Scene & Obj'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 


mkdir('/Users/alex/Dropbox/paperwriting/1315/fig/BSLcorr/OrigSession')
cd('/Users/alex/Dropbox/paperwriting/1315/fig/BSLcorr/OrigSession')
saveDir = '/Users/alex/Dropbox/paperwriting/1315/fig/BSLcorr/OrigSession'; 

figList = findobj(allchild(0), 'flat', 'Type', 'figure');

% Loop through all figures and save
for i = 1:length(figList)
    figHandle = figList(i);
    filename = fullfile(saveDir, sprintf('Figure_%d.fig', figHandle.Number));

    saveas(figHandle, filename);
    
end


%% recombi

close all

clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_BSLcorr_meanPD_rcg_scene_correct_emo_recombi;
data2 = plotdat_BSLcorr_meanPD_rcg_scene_correct_neu_recombi;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
%ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Correct trials: emotional: red / neutral: blue','Recombi Set, scenes'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 

%%%%%%%%%%%

clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_BSLcorr_meanPD_rcg_scene_incorrect_emo_recombi;
data2 = plotdat_BSLcorr_meanPD_rcg_scene_incorrect_neu_recombi;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Incorrect trials: emotional: red / neutral: blue','Recombi Set, scenes'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 


%%%%%%%%%%%%%


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_BSLcorr_meanPD_rcg_scene_correct_emo_recombi;
data2 = plotdat_BSLcorr_meanPD_rcg_scene_incorrect_emo_recombi;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Emotional trials: incorrect: red / correct: green','Recombi Set, scenes'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 



%%%%%%%%%%%%%

clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_BSLcorr_meanPD_rcg_scene_correct_neu_recombi;
data2 = plotdat_BSLcorr_meanPD_rcg_scene_incorrect_neu_recombi;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Neutral trials: incorrect: red / correct: green','Recombi Set, scenes'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_BSLcorr_meanPD_rcg_obj_correct_emo_recombi;
data2 = plotdat_BSLcorr_meanPD_rcg_obj_correct_neu_recombi;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
%ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Correct trials: emotional: red / neutral: blue','Recombi Set, objects'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 

%%%%%%%%%%%

clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_BSLcorr_meanPD_rcg_obj_incorrect_emo_recombi;
data2 = plotdat_BSLcorr_meanPD_rcg_obj_incorrect_neu_recombi;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Incorrect trials: emotional: red / neutral: blue','Recombi Set, objects'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 


%%%%%%%%%%%%%


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_BSLcorr_meanPD_rcg_obj_correct_emo_recombi;
data2 = plotdat_BSLcorr_meanPD_rcg_obj_incorrect_emo_recombi;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Emotional trials: incorrect: red / correct: green','Recombi Set, objects'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 



%%%%%%%%%%%%%


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_BSLcorr_meanPD_rcg_obj_correct_neu_recombi;
data2 = plotdat_BSLcorr_meanPD_rcg_obj_incorrect_neu_recombi;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Neutral trials: incorrect: red / correct: green','Recombi Set, objects'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 

%%%%%%%%%%%

clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_BSLcorr_meanPD_rcg_both_incorrect_emo_recombi;
data2 = plotdat_BSLcorr_meanPD_rcg_both_incorrect_neu_recombi;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Incorrect trials: emotional: red / neutral: blue','Recombi Set, Scene & Obj'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 


%%%%%%%%%%%%%


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_BSLcorr_meanPD_rcg_both_correct_emo_recombi;
data2 = plotdat_BSLcorr_meanPD_rcg_both_incorrect_emo_recombi;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Emotional trials: incorrect: red / correct: green','Recombi Set, Scene & Obj'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 



%%%%%%%%%%%%%


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_BSLcorr_meanPD_rcg_both_correct_neu_recombi;
data2 = plotdat_BSLcorr_meanPD_rcg_both_incorrect_neu_recombi;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Neutral trials: incorrect: red / correct: green','Recombi Set, Scene & Obj'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 


mkdir('/Users/alex/Dropbox/paperwriting/1315/fig/BSLcorr/RecombiSession')
cd('/Users/alex/Dropbox/paperwriting/1315/fig/BSLcorr/RecombiSession')
saveDir = '/Users/alex/Dropbox/paperwriting/1315/fig/BSLcorr/RecombiSession'; 

figList = findobj(allchild(0), 'flat', 'Type', 'figure');

% Loop through all figures and save
for i = 1:length(figList)
    figHandle = figList(i);
    filename = fullfile(saveDir, sprintf('Figure_%d.fig', figHandle.Number));

    saveas(figHandle, filename);
    
end


%% retest

close all

clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_BSLcorr_meanPD_rcg_scene_correct_emo_retest;
data2 = plotdat_BSLcorr_meanPD_rcg_scene_correct_neu_retest;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
%ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Correct trials: emotional: red / neutral: blue','Retest Set, scenes'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 

%%%%%%%%%%%

clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_BSLcorr_meanPD_rcg_scene_incorrect_emo_retest;
data2 = plotdat_BSLcorr_meanPD_rcg_scene_incorrect_neu_retest;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Incorrect trials: emotional: red / neutral: blue','Retest Set, scenes'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 


%%%%%%%%%%%%%


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_BSLcorr_meanPD_rcg_scene_correct_emo_retest;
data2 = plotdat_BSLcorr_meanPD_rcg_scene_incorrect_emo_retest;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Emotional trials: incorrect: red / correct: green','Retest Set, scenes'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 



%%%%%%%%%%%%%

clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_BSLcorr_meanPD_rcg_scene_correct_neu_retest;
data2 = plotdat_BSLcorr_meanPD_rcg_scene_incorrect_neu_retest;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Neutral trials: incorrect: red / correct: green','Retest Set, scenes'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_BSLcorr_meanPD_rcg_obj_correct_emo_retest;
data2 = plotdat_BSLcorr_meanPD_rcg_obj_correct_neu_retest;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
%ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Correct trials: emotional: red / neutral: blue','Retest Set, objects'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 

%%%%%%%%%%%

clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_BSLcorr_meanPD_rcg_obj_incorrect_emo_retest;
data2 = plotdat_BSLcorr_meanPD_rcg_obj_incorrect_neu_retest;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Incorrect trials: emotional: red / neutral: blue','Retest Set, objects'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 


%%%%%%%%%%%%%


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_BSLcorr_meanPD_rcg_obj_correct_emo_retest;
data2 = plotdat_BSLcorr_meanPD_rcg_obj_incorrect_emo_retest;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Emotional trials: incorrect: red / correct: green','Retest Set, objects'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 



%%%%%%%%%%%%%


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_BSLcorr_meanPD_rcg_obj_correct_neu_retest;
data2 = plotdat_BSLcorr_meanPD_rcg_obj_incorrect_neu_retest;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Neutral trials: incorrect: red / correct: green','Retest Set, objects'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 

%%%%%%%%%%%

clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_BSLcorr_meanPD_rcg_both_incorrect_emo_retest;
data2 = plotdat_BSLcorr_meanPD_rcg_both_incorrect_neu_retest;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'b-o','markerfacecolor','b'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Incorrect trials: emotional: red / neutral: blue','Retest Set, Scene & Obj'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 


%%%%%%%%%%%%%


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_BSLcorr_meanPD_rcg_both_correct_emo_retest;
data2 = plotdat_BSLcorr_meanPD_rcg_both_incorrect_emo_retest;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Emotional trials: incorrect: red / correct: green','Retest Set, Scene & Obj'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 



%%%%%%%%%%%%%


clear meanData1 meanData2 semData1 semData2 data1 data2

data1 = plotdat_BSLcorr_meanPD_rcg_both_correct_neu_retest;
data2 = plotdat_BSLcorr_meanPD_rcg_both_incorrect_neu_retest;

% Calculate means
meanData1 = nanmean(data1, 1);
meanData2 = nanmean(data2, 1);

% Calculate Standard Error of the Mean (SEM)
semData1 = nanstd(data1, 0, 1) / sqrt(size(data1, 1));
semData2 = nanstd(data2, 0, 1) / sqrt(size(data2, 1));

figure;

shadedErrorBar(1:length(meanData2),meanData1,semData1,'lineprops',{'g-o','markerfacecolor','g'}); hold on;
shadedErrorBar(1:length(meanData2),meanData2,semData2,'lineprops',{'r-o','markerfacecolor','r'}); hold on;
H1 = ttest2(data1,data2); sigbar1 = H1*0.001; sigbar1(find(sigbar1==0))=NaN; plot(sigbar1,'k-o','LineWidth',3); % this bit is for calculating significance
xlim([1 length(meanData2)]); %ylim([miny maxy]);% xticklabels([0 500 1000 1500 2000 2500]);
xlabel('time(msec)','Fontsize',20,'Fontweight','bold'); xlim([1 2701])
ylabel('Z-Score','Fontsize',20,'Fontweight','bold');
title({'Neutral trials: incorrect: red / correct: green','Retest Set, Scene & Obj'},'Fontsize',20,'Fontweight','bold'); grid on
xlim([1 length(meanData2)]); 


mkdir('/Users/alex/Dropbox/paperwriting/1315/fig/BSLcorr/RetestSession')
cd('/Users/alex/Dropbox/paperwriting/1315/fig/BSLcorr/RetestSession')
saveDir = '/Users/alex/Dropbox/paperwriting/1315/fig/BSLcorr/RetestSession'; 

figList = findobj(allchild(0), 'flat', 'Type', 'figure');

% Loop through all figures and save
for i = 1:length(figList)
    figHandle = figList(i);
    filename = fullfile(saveDir, sprintf('Figure_%d.fig', figHandle.Number));

    saveas(figHandle, filename);
    
end







%% deprecated

%% collect the Z-score data
% 
% emoid=ids(1:2:44);
% neuid=ids(2:2:44);
% 
% AllZscores_enc_scene_emo_orig=[];
% AllZscores_enc_scene_neu_orig=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_enc_scene_emo_orig{id,1},1)
%         cnt=cnt+1;
%         AllZscores_enc_scene_emo_orig(cnt,:)=Zscore_PD_enc_scene_emo_orig{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_enc_scene_neu_orig{id,1},1)
%         cnt=cnt+1;
%         AllZscores_enc_scene_neu_orig(cnt,:)=Zscore_PD_enc_scene_neu_orig{id,1}(k1,:);
%     end
% end
% 
% 
% AllZscores_enc_emo_obj=[];
% AllZscores_enc_neu_obj=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_enc_obj_emo_orig{id,1},1)
%         cnt=cnt+1;
%         AllZscores_enc_obj_emo_orig(cnt,:)=Zscore_PD_enc_obj_emo_orig{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_enc_obj_neu_orig{id,1},1)
%         cnt=cnt+1;
%         AllZscores_enc_obj_neu_orig(cnt,:)=Zscore_PD_enc_obj_neu_orig{id,1}(k1,:);
%     end
% end
% 
% 
% %%
% 
% AllZscores_enc_scene_emo_recombi=[];
% AllZscores_enc_scene_neu_recombi=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_enc_scene_emo_recombi{id,1},1)
%         cnt=cnt+1;
%         AllZscores_enc_scene_emo_recombi(cnt,:)=Zscore_PD_enc_scene_emo_recombi{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_enc_scene_neu_recombi{id,1},1)
%         cnt=cnt+1;
%         AllZscores_enc_scene_neu_recombi(cnt,:)=Zscore_PD_enc_scene_neu_recombi{id,1}(k1,:);
%     end
% end
% 
% 
% AllZscores_enc_emo_obj=[];
% AllZscores_enc_neu_obj=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_enc_obj_emo_recombi{id,1},1)
%         cnt=cnt+1;
%         AllZscores_enc_obj_emo_recombi(cnt,:)=Zscore_PD_enc_obj_emo_recombi{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_enc_obj_neu_recombi{id,1},1)
%         cnt=cnt+1;
%         AllZscores_enc_obj_neu_recombi(cnt,:)=Zscore_PD_enc_obj_neu_recombi{id,1}(k1,:);
%     end
% end
% 
% 
% %%
% 
% AllZscores_rcg_scene_emo_orig=[];
% AllZscores_rcg_scene_neu_orig=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_scene_emo_orig{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_scene_emo_orig(cnt,:)=Zscore_PD_rcg_scene_emo_orig{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_scene_neu_orig{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_scene_neu_orig(cnt,:)=Zscore_PD_rcg_scene_neu_orig{id,1}(k1,:);
%     end
% end
% 
% 
% AllZscores_rcg_emo_obj=[];
% AllZscores_rcg_neu_obj=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_obj_emo_orig{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_obj_emo_orig(cnt,:)=Zscore_PD_rcg_obj_emo_orig{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_obj_neu_orig{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_obj_neu_orig(cnt,:)=Zscore_PD_rcg_obj_neu_orig{id,1}(k1,:);
%     end
% end
% 
% AllZscores_rcg_emo_both=[];
% AllZscores_rcg_neu_both=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_both_emo_orig{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_both_emo_orig(cnt,:)=Zscore_PD_rcg_both_emo_orig{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_both_neu_orig{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_both_neu_orig(cnt,:)=Zscore_PD_rcg_both_neu_orig{id,1}(k1,:);
%     end
% end
% 
% 
% AllZscores_rcg_scene_emo_correct_orig=[];
% AllZscores_rcg_scene_neu_correct_orig=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_scene_correct_emo_orig{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_scene_emo_correct_orig(cnt,:)=Zscore_PD_rcg_scene_correct_emo_orig{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_scene_correct_neu_orig{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_scene_neu_correct_orig(cnt,:)=Zscore_PD_rcg_scene_correct_neu_orig{id,1}(k1,:);
%     end
% end
% 
% 
% AllZscores_rcg_emo_correct_obj=[];
% AllZscores_rcg_neu_correct_obj=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_obj_correct_emo_orig{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_obj_emo_correct_orig(cnt,:)=Zscore_PD_rcg_obj_correct_emo_orig{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_obj_correct_neu_orig{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_obj_neu_correct_orig(cnt,:)=Zscore_PD_rcg_obj_correct_neu_orig{id,1}(k1,:);
%     end
% end
% 
% AllZscores_rcg_emo_correct_both=[];
% AllZscores_rcg_neu_correct_both=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_both_correct_emo_orig{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_both_emo_correct_orig(cnt,:)=Zscore_PD_rcg_both_correct_emo_orig{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_both_correct_neu_orig{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_both_neu_correct_orig(cnt,:)=Zscore_PD_rcg_both_correct_neu_orig{id,1}(k1,:);
%     end
% end
% 
% %%
% 
% AllZscores_rcg_scene_emo_correct_orig=[];
% AllZscores_rcg_scene_neu_correct_orig=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_scene_correct_emo_orig{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_scene_emo_correct_orig(cnt,:)=Zscore_PD_rcg_scene_correct_emo_orig{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_scene_correct_neu_orig{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_scene_neu_correct_orig(cnt,:)=Zscore_PD_rcg_scene_correct_neu_orig{id,1}(k1,:);
%     end
% end
% 
% 
% AllZscores_rcg_emo_correct_obj=[];
% AllZscores_rcg_neu_correct_obj=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_obj_correct_emo_orig{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_obj_emo_correct_orig(cnt,:)=Zscore_PD_rcg_obj_correct_emo_orig{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_obj_correct_neu_orig{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_obj_neu_correct_orig(cnt,:)=Zscore_PD_rcg_obj_correct_neu_orig{id,1}(k1,:);
%     end
% end
% 
% AllZscores_rcg_emo_correct_both=[];
% AllZscores_rcg_neu_correct_both=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_both_correct_emo_orig{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_both_emo_correct_orig(cnt,:)=Zscore_PD_rcg_both_correct_emo_orig{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_both_correct_neu_orig{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_both_neu_correct_orig(cnt,:)=Zscore_PD_rcg_both_correct_neu_orig{id,1}(k1,:);
%     end
% end
% 
% 
% %%
% 
% AllZscores_rcg_scene_emo_incorrect_orig=[];
% AllZscores_rcg_scene_neu_incorrect_orig=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_scene_incorrect_emo_orig{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_scene_emo_incorrect_orig(cnt,:)=Zscore_PD_rcg_scene_incorrect_emo_orig{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_scene_incorrect_neu_orig{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_scene_neu_incorrect_orig(cnt,:)=Zscore_PD_rcg_scene_incorrect_neu_orig{id,1}(k1,:);
%     end
% end
% 
% 
% AllZscores_rcg_emo_incorrect_obj=[];
% AllZscores_rcg_neu_incorrect_obj=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_obj_incorrect_emo_orig{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_obj_emo_incorrect_orig(cnt,:)=Zscore_PD_rcg_obj_incorrect_emo_orig{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_obj_incorrect_neu_orig{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_obj_neu_incorrect_orig(cnt,:)=Zscore_PD_rcg_obj_incorrect_neu_orig{id,1}(k1,:);
%     end
% end
% 
% AllZscores_rcg_emo_incorrect_both=[];
% AllZscores_rcg_neu_incorrect_both=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_both_incorrect_emo_orig{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_both_emo_incorrect_orig(cnt,:)=Zscore_PD_rcg_both_incorrect_emo_orig{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_both_incorrect_neu_orig{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_both_neu_incorrect_orig(cnt,:)=Zscore_PD_rcg_both_incorrect_neu_orig{id,1}(k1,:);
%     end
% end
% 
% 
% %%
% 
% AllZscores_rcg_scene_emo_recombi=[];
% AllZscores_rcg_scene_neu_recombi=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_scene_emo_recombi{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_scene_emo_recombi(cnt,:)=Zscore_PD_rcg_scene_emo_recombi{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_scene_neu_recombi{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_scene_neu_recombi(cnt,:)=Zscore_PD_rcg_scene_neu_recombi{id,1}(k1,:);
%     end
% end
% 
% 
% AllZscores_rcg_emo_obj=[];
% AllZscores_rcg_neu_obj=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_obj_emo_recombi{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_obj_emo_recombi(cnt,:)=Zscore_PD_rcg_obj_emo_recombi{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_obj_neu_recombi{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_obj_neu_recombi(cnt,:)=Zscore_PD_rcg_obj_neu_recombi{id,1}(k1,:);
%     end
% end
% 
% AllZscores_rcg_emo_both=[];
% AllZscores_rcg_neu_both=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_both_emo_recombi{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_both_emo_recombi(cnt,:)=Zscore_PD_rcg_both_emo_recombi{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_both_neu_recombi{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_both_neu_recombi(cnt,:)=Zscore_PD_rcg_both_neu_recombi{id,1}(k1,:);
%     end
% end
% 
% 
% AllZscores_rcg_scene_emo_correct_recombi=[];
% AllZscores_rcg_scene_neu_correct_recombi=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_scene_correct_emo_recombi{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_scene_emo_correct_recombi(cnt,:)=Zscore_PD_rcg_scene_correct_emo_recombi{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_scene_correct_neu_recombi{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_scene_neu_correct_recombi(cnt,:)=Zscore_PD_rcg_scene_correct_neu_recombi{id,1}(k1,:);
%     end
% end
% 
% 
% AllZscores_rcg_emo_correct_obj=[];
% AllZscores_rcg_neu_correct_obj=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_obj_correct_emo_recombi{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_obj_emo_correct_recombi(cnt,:)=Zscore_PD_rcg_obj_correct_emo_recombi{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_obj_correct_neu_recombi{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_obj_neu_correct_recombi(cnt,:)=Zscore_PD_rcg_obj_correct_neu_recombi{id,1}(k1,:);
%     end
% end
% 
% AllZscores_rcg_emo_correct_both=[];
% AllZscores_rcg_neu_correct_both=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_both_correct_emo_recombi{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_both_emo_correct_recombi(cnt,:)=Zscore_PD_rcg_both_correct_emo_recombi{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_both_correct_neu_recombi{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_both_neu_correct_recombi(cnt,:)=Zscore_PD_rcg_both_correct_neu_recombi{id,1}(k1,:);
%     end
% end
% 
% %%
% 
% AllZscores_rcg_scene_emo_correct_recombi=[];
% AllZscores_rcg_scene_neu_correct_recombi=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_scene_correct_emo_recombi{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_scene_emo_correct_recombi(cnt,:)=Zscore_PD_rcg_scene_correct_emo_recombi{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_scene_correct_neu_recombi{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_scene_neu_correct_recombi(cnt,:)=Zscore_PD_rcg_scene_correct_neu_recombi{id,1}(k1,:);
%     end
% end
% 
% 
% AllZscores_rcg_emo_correct_obj=[];
% AllZscores_rcg_neu_correct_obj=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_obj_correct_emo_recombi{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_obj_emo_correct_recombi(cnt,:)=Zscore_PD_rcg_obj_correct_emo_recombi{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_obj_correct_neu_recombi{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_obj_neu_correct_recombi(cnt,:)=Zscore_PD_rcg_obj_correct_neu_recombi{id,1}(k1,:);
%     end
% end
% 
% AllZscores_rcg_emo_correct_both=[];
% AllZscores_rcg_neu_correct_both=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_both_correct_emo_recombi{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_both_emo_correct_recombi(cnt,:)=Zscore_PD_rcg_both_correct_emo_recombi{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_both_correct_neu_recombi{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_both_neu_correct_recombi(cnt,:)=Zscore_PD_rcg_both_correct_neu_recombi{id,1}(k1,:);
%     end
% end
% 
% 
% %%
% 
% AllZscores_rcg_scene_emo_incorrect_recombi=[];
% AllZscores_rcg_scene_neu_incorrect_recombi=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_scene_incorrect_emo_recombi{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_scene_emo_incorrect_recombi(cnt,:)=Zscore_PD_rcg_scene_incorrect_emo_recombi{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_scene_incorrect_neu_recombi{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_scene_neu_incorrect_recombi(cnt,:)=Zscore_PD_rcg_scene_incorrect_neu_recombi{id,1}(k1,:);
%     end
% end
% 
% 
% AllZscores_rcg_emo_incorrect_obj=[];
% AllZscores_rcg_neu_incorrect_obj=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_obj_incorrect_emo_recombi{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_obj_emo_incorrect_recombi(cnt,:)=Zscore_PD_rcg_obj_incorrect_emo_recombi{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_obj_incorrect_neu_recombi{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_obj_neu_incorrect_recombi(cnt,:)=Zscore_PD_rcg_obj_incorrect_neu_recombi{id,1}(k1,:);
%     end
% end
% 
% AllZscores_rcg_emo_incorrect_both=[];
% AllZscores_rcg_neu_incorrect_both=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_both_incorrect_emo_recombi{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_both_emo_incorrect_recombi(cnt,:)=Zscore_PD_rcg_both_incorrect_emo_recombi{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_both_incorrect_neu_recombi{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_both_neu_incorrect_recombi(cnt,:)=Zscore_PD_rcg_both_incorrect_neu_recombi{id,1}(k1,:);
%     end
% end
% 
% %%
% 
% AllZscores_rcg_scene_emo_retest=[];
% AllZscores_rcg_scene_neu_retest=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_scene_emo_retest{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_scene_emo_retest(cnt,:)=Zscore_PD_rcg_scene_emo_retest{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_scene_neu_retest{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_scene_neu_retest(cnt,:)=Zscore_PD_rcg_scene_neu_retest{id,1}(k1,:);
%     end
% end
% 
% 
% AllZscores_rcg_emo_obj=[];
% AllZscores_rcg_neu_obj=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_obj_emo_retest{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_obj_emo_retest(cnt,:)=Zscore_PD_rcg_obj_emo_retest{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_obj_neu_retest{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_obj_neu_retest(cnt,:)=Zscore_PD_rcg_obj_neu_retest{id,1}(k1,:);
%     end
% end
% 
% AllZscores_rcg_emo_both=[];
% AllZscores_rcg_neu_both=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_both_emo_retest{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_both_emo_retest(cnt,:)=Zscore_PD_rcg_both_emo_retest{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_both_neu_retest{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_both_neu_retest(cnt,:)=Zscore_PD_rcg_both_neu_retest{id,1}(k1,:);
%     end
% end
% 
% 
% AllZscores_rcg_scene_emo_correct_retest=[];
% AllZscores_rcg_scene_neu_correct_retest=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_scene_correct_emo_retest{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_scene_emo_correct_retest(cnt,:)=Zscore_PD_rcg_scene_correct_emo_retest{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_scene_correct_neu_retest{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_scene_neu_correct_retest(cnt,:)=Zscore_PD_rcg_scene_correct_neu_retest{id,1}(k1,:);
%     end
% end
% 
% 
% AllZscores_rcg_emo_correct_obj=[];
% AllZscores_rcg_neu_correct_obj=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_obj_correct_emo_retest{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_obj_emo_correct_retest(cnt,:)=Zscore_PD_rcg_obj_correct_emo_retest{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_obj_correct_neu_retest{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_obj_neu_correct_retest(cnt,:)=Zscore_PD_rcg_obj_correct_neu_retest{id,1}(k1,:);
%     end
% end
% 
% AllZscores_rcg_emo_correct_both=[];
% AllZscores_rcg_neu_correct_both=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_both_correct_emo_retest{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_both_emo_correct_retest(cnt,:)=Zscore_PD_rcg_both_correct_emo_retest{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_both_correct_neu_retest{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_both_neu_correct_retest(cnt,:)=Zscore_PD_rcg_both_correct_neu_retest{id,1}(k1,:);
%     end
% end
% 
% %%
% 
% AllZscores_rcg_scene_emo_correct_retest=[];
% AllZscores_rcg_scene_neu_correct_retest=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_scene_correct_emo_retest{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_scene_emo_correct_retest(cnt,:)=Zscore_PD_rcg_scene_correct_emo_retest{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_scene_correct_neu_retest{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_scene_neu_correct_retest(cnt,:)=Zscore_PD_rcg_scene_correct_neu_retest{id,1}(k1,:);
%     end
% end
% 
% 
% AllZscores_rcg_emo_correct_obj=[];
% AllZscores_rcg_neu_correct_obj=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_obj_correct_emo_retest{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_obj_emo_correct_retest(cnt,:)=Zscore_PD_rcg_obj_correct_emo_retest{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_obj_correct_neu_retest{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_obj_neu_correct_retest(cnt,:)=Zscore_PD_rcg_obj_correct_neu_retest{id,1}(k1,:);
%     end
% end
% 
% AllZscores_rcg_emo_correct_both=[];
% AllZscores_rcg_neu_correct_both=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_both_correct_emo_retest{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_both_emo_correct_retest(cnt,:)=Zscore_PD_rcg_both_correct_emo_retest{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_both_correct_neu_retest{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_both_neu_correct_retest(cnt,:)=Zscore_PD_rcg_both_correct_neu_retest{id,1}(k1,:);
%     end
% end
% 
% 
% %%
% 
% AllZscores_rcg_scene_emo_incorrect_retest=[];
% AllZscores_rcg_scene_neu_incorrect_retest=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_scene_incorrect_emo_retest{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_scene_emo_incorrect_retest(cnt,:)=Zscore_PD_rcg_scene_incorrect_emo_retest{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_scene_incorrect_neu_retest{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_scene_neu_incorrect_retest(cnt,:)=Zscore_PD_rcg_scene_incorrect_neu_retest{id,1}(k1,:);
%     end
% end
% 
% 
% AllZscores_rcg_emo_incorrect_obj=[];
% AllZscores_rcg_neu_incorrect_obj=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_obj_incorrect_emo_retest{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_obj_emo_incorrect_retest(cnt,:)=Zscore_PD_rcg_obj_incorrect_emo_retest{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_obj_incorrect_neu_retest{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_obj_neu_incorrect_retest(cnt,:)=Zscore_PD_rcg_obj_incorrect_neu_retest{id,1}(k1,:);
%     end
% end
% 
% AllZscores_rcg_emo_incorrect_both=[];
% AllZscores_rcg_neu_incorrect_both=[];
% 
% cnt=0;
% for id=1:length(emoid)
%     for k1=1:size(Zscore_PD_rcg_both_incorrect_emo_retest{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_both_emo_incorrect_retest(cnt,:)=Zscore_PD_rcg_both_incorrect_emo_retest{id,1}(k1,:);
%     end
% end
% 
% cnt=0;
% for id=1:length(neuid)
%     for k1=1:size(Zscore_PD_rcg_both_incorrect_neu_retest{id,1},1)
%         cnt=cnt+1;
%         AllZscores_rcg_both_neu_incorrect_retest(cnt,:)=Zscore_PD_rcg_both_incorrect_neu_retest{id,1}(k1,:);
%     end
% end
