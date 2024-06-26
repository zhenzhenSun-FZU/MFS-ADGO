 clc; clear; 
addpath(genpath('.\result1\'))
dataset='Scene';
%'emotion';'bird';'education';'health';'Scene';'Yeast';'image';'medical';'social';'stackexchess';'Bibtex_data'

alphaCandi =[10^-3,10^-2,10^-1,1,10^1,10^2,10^3];  %[10^-3,10^-2,10^-1,1,10^1,10^2,10^3]
betaCandi = [10^-3,10^-1,1,10^1,10^3]; %[10^-3,10^-1,1,10^1,10^3]
lambdaCandi = [10^-3,10^-1,1,10^1,10^3,10^5,10^7];%[10^-3,10^-1,1,10^1,10^3,10^5,10^7]

ap=zeros(1,10);
mi=zeros(1,10);
ma=zeros(1,10);
cv=200.*ones(1,10);
hl=ones(1,10);
rl=ones(1,10);
oe=ones(1,10);
for alpha = alphaCandi
    for beta = betaCandi
        for lambda = lambdaCandi
            result_path = strcat('D:\ADGNSMFS\result1\',dataset,'\','alpha_',num2str(alpha),'_beta_',num2str(beta),'_lambda_',num2str(lambda),'_resultAvg.mat');
            load(result_path);
            for i = 1:10
                if ap(i) <  Avg_Result{1,i}(5,1)
                    ap(i) = Avg_Result{1,i}(5,1);
                end
                if mi(i) < Avg_Result{1,i}(7,1)
                    mi(i) = Avg_Result{1,i}(7,1);
                end
                if ma(i) < Avg_Result{1,i}(6,1)
                    ma(i) = Avg_Result{1,i}(6,1);
                end
                if cv(i) > Avg_Result{1,i}(3,1)
                    cv(i) = Avg_Result{1,i}(3,1);
                end
                if hl(i) > Avg_Result{1,i}(1,1)
                    hl(i) = Avg_Result{1,i}(1,1);
                end
                if rl(i) > Avg_Result{1,i}(2,1)
                    rl(i) = Avg_Result{1,i}(2,1);
                end
                if oe(i) > Avg_Result{1,i}(4,1)
                    oe(i) = Avg_Result{1,i}(4,1);
                end
            end
        end
    end
end
AP_ADGNSMFS = ap;
CV_ADGNSMFS = cv;
HL_ADGNSMFS = hl;
MA_ADGNSMFS = ma;
MI_ADGNSMFS = mi;
RL_ADGNSMFS = rl;
OE_ADGNSMFS = oe;
result_path1 = strcat('D:\ADGNSMFS\bestResult1\',dataset);
if exist(result_path1,'file') == 0
    mkdir('D:\ADGNSMFS\bestResult1\',dataset);
end
result_path = strcat('D:\ADGNSMFS\bestResult1\',dataset,'\','ADGNSMFS.mat');
save(result_path,'AP_ADGNSMFS',...
    'CV_ADGNSMFS','HL_ADGNSMFS','MA_ADGNSMFS','MI_ADGNSMFS','RL_ADGNSMFS','OE_ADGNSMFS');
