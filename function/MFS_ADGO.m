function [W, obj] = MFS_ADGO(X_train, Y_train, para )
%% function discription
% ----------------------------------------------------------------------
% Function for multi-label feature selection
% Zhenzhen Sun
% Inputs:   
%          X_train--A d x N array, the i-th instance is stored in X_train(:,i)
%          Y_train--A C x N array, C is the number of possible labels, Y_train(i,j) is 1 if the i-th instance has the j-th label, and -1 otherwise
%
%          para--the set of parameters
%
% Outputs:  
%          W--A d x C array, d is the number of features, coefficient matrix for feature selection
%
%          obj--The objective values
%
% ----------------------------------------------------------------------

% Calucate some statitics about the data
Y_train(Y_train==-1)=0;
[num_feature, num_train] = size(X_train); num_label = size(Y_train, 1);

H=eye(num_train)-ones(num_train,num_train)./num_train;


%Initialize F
F =rand(num_label, num_train); % c x n

% Initialize W
W = zeros(num_feature, num_label); % d x c

iter = 1;
Maxiter = 50;

obji = 1;
while iter <= Maxiter
    %Update Sf
    for i=1:num_feature
        for j=1:num_feature
            Sf(i,j)=exp(-(norm(W(i,:)-W(j,:),2)^2/(2*para.beta)));
        end
        Sf(i,:)=Sf(i,:)./sum(Sf(i,:));
    end
    diag_ele_arr = sum(Sf+Sf',2)/2;
    Af = diag(diag_ele_arr);
    Lf = Af-(Sf+Sf)/2;
    
    %Update Sd
    for p=1:num_train
        for q=1:num_train
            Sd(p,q)=exp(-(norm(F(:,p)-F(:,q),2)^2/(2*para.beta)));
        end
        Sd(p,:)=Sd(p,:)./sum(Sd(p,:));
    end
    diag_ele_arr = sum(Sd+Sd',2)/2;
    Ad = diag(diag_ele_arr);
    Ld = Ad-(Sd+Sd)/2;
    
    %Update W
    X1 = X_train * H; 
    F1 = F * H;
    u = 1./sqrt(sum(W.*W, 2) + eps);    
    U = diag(u);
    B = X1*F1' + 0.5*para.lambda*(1/(sqrt(trace(W'*W))+eps))*W;
    A = X1*X1' + para.alpha*Lf + para.lambda*U;
    W = A\B;  %B/A 相当于 BA^{-1}, A\B相当于A^{-1}B
    
    %Update F--------------------------------------------------------------
    P = H + eye(num_train) + para.alpha*Ld;
    Q = W'*X_train*H + Y_train;
    F = F.* Q ./ (F*P+eps);
    
    infor_entropy1=0;
    for pos_i=1:num_feature
        for pos_j=1:num_feature
            infor_entropy1=infor_entropy1+Sf(pos_i,pos_j)*log(Sf(pos_i,pos_j)+1e-10);
        end
    end   
    infor_entropy2=0;
    for pos_p=1:num_train
        for pos_q=1:num_train
            infor_entropy2=infor_entropy2+Sd(pos_p,pos_q)*log(Sd(pos_p,pos_q)+1e-10);
        end
    end
    
    obj(iter) = norm((W'*X_train-F)*H,'fro')^2 + norm(F-Y_train,'fro')^2 + para.alpha*(trace(F*Ld*F')...
    +trace(W'*Lf*W)+para.beta*(infor_entropy1+infor_entropy2)) + para.lambda*(sum(sqrt(sum(W.*W,2)))-sqrt(sum(sum(W.*W,2))));

    cver = abs((obj(iter) - obji)/obji);
    obji = obj(iter);
    iter = iter + 1;
    if (cver < 10^-3 && iter > 2) , break, end
    
end

end


