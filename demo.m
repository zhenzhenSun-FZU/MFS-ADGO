% This is an example file on how the MFS-ADGO [1] program could be used.

% [1] Sun Z, Xie H, Liu J, et al.
% Multi-label feature selection via adaptive dual-graph optimization[J]. Expert Systems With Applications, 243 (2024):122884

clc;clear;
addpath(genpath('.\'))
dataset = 'emotion';
datapath=strcat('./data/',dataset,'.mat');
load(datapath);
X = double(X);
% Calucate some statitics about the data
num_label = size(Y,2);
[num_data, num_feature] = size(X);

%different numbers of features
if num_feature <= 100
    selectedFN = 7; 
else
    selectedFN = 10;
end

randorder = randperm(num_data);
cv_num = 5;

% The default setting of MLKNN
 Num = 10;Smooth = 1;  

% n_fold validation and evaluation
for cv = 1:cv_num
    fprintf('Data processing, Cross validation: %d\n', cv);
    
    % Training set and test set for the i-th fold
    [cv_train_data,cv_train_target,cv_test_data,cv_test_target ] = generateCVSet(X,Y,randorder,cv,cv_num);
    tmp_cv_train_target = cv_train_target;
    tmp_cv_train_target(tmp_cv_train_target==0) = -1;
    tmp_cv_test_target = cv_test_target;
    tmp_cv_test_target(tmp_cv_test_target==0) = -1;
    
    para.alpha = 1e-3;para.beta = 1e-3; para.lambda = 1e-3;
    
    % Running the MFS-ADGO procedure for feature selection
    t0 = clock;
    [ W, obj ] = MFS_ADGO( cv_train_data', cv_train_target', para );
    time = etime(clock, t0);
    [dumb, idx] = sort(sum(W.*W,2),'descend');
    
    HL = []; RL= [];OE = [];CV = [];AP = [];
    for FeaNum=10:10:10*selectedFN
        
        fea = idx(1:FeaNum);
        [Prior,PriorN,Cond,CondN]=MLKNN_train(cv_train_data(:,fea),tmp_cv_train_target',Num,Smooth);

        [HammingLoss,RankingLoss,Coverage,OneError,Average_Precision,macrof1,microf1,EBA,EBP,EBR,EBF,LBA,LBP,LBR,LBF]=...
                       MLKNN_test(cv_train_data(:,fea),tmp_cv_train_target',cv_test_data(:,fea),tmp_cv_test_target',Num,Prior,PriorN,Cond,CondN);
        HL = [HL HammingLoss];
        RL = [RL RankingLoss];
        CV = [CV Coverage];
        OE = [OE OneError];
        AP = [AP Average_Precision];
    end
    result_path = strcat('.\result\',dataset);
    if exist(result_path,'file') == 0
          mkdir(result_path);
    end
    savepath=strcat(result_path,'\','cv',num2str(cv),'.mat');
    save(savepath,'HL','RL','CV','OE','AP','time');
end


