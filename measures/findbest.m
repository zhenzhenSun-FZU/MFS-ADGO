clc; clear; 
addpath(genpath('.\result\'))
dataset='stackexchess';
%'emotion';'bird';'education';'health';'Scene';'Yeast';'image';'medical';'social';'stackexchess';'Bibtex_data'

alphaCandi = [10^-3,10^-2,10^-1,1,10^1,10^2,10^3];
betaCandi = [10^-3,10^-1,1,10^1,10^3];
lambdaCandi = [10^-3,10^-1,1,10^1,10^3,10^5,10^7];
ap=zeros(1,10);
mi=zeros(1,10);
ma=zeros(1,10);
cv=200.*ones(1,10);
hl=ones(1,10);
rl=ones(1,10);
for alpha = alphaCandi
    for beta = betaCandi
        for lambda = lambdaCandi
            result_path = strcat('D:\ADGNSMFS\result\',dataset,'\','alpha_',num2str(alpha),'_beta_',num2str(beta),'_lambda_',num2str(lambda),'_result.mat');
            load(result_path);
            for i = 1:10
                if ap(i) < AP(i)
                    ap(i) = AP(i);
                end
                if mi(i) < MI(i)
                    mi(i) = MI(i);
                end
                if ma(i) < MA(i)
                    ma(i) = MA(i);
                end
                if cv(i) > CV(i)
                    cv(i) = CV(i);
                end
                if hl(i) > HL(i)
                    hl(i) = HL(i);
                end
                if rl(i) > RL(i)
                    rl(i) = RL(i);
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
result_path = strcat('D:\ADGNSMFS\bestResult\',dataset,'\','ADGNSMFS.mat');
save(result_path,'AP_ADGNSMFS',...
    'CV_ADGNSMFS','HL_ADGNSMFS','MA_ADGNSMFS','MI_ADGNSMFS','RL_ADGNSMFS');
