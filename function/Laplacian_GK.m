function L = Laplacian_GK(X,k,sigma)
% each column is a data


if nargin < 3
    sigma = 1;
elseif nargin < 2
    k = 5;
end

    [nSmp, nFea] = size(X);
    D = EuDist2(X);
    W = spalloc(nSmp,nSmp,20*nSmp);
    
    [dumb,idx] = sort(D, 2); % sort each row

    for i = 1 : nSmp
        j = idx(i,2:k+1);
        for n = 1 : k
        W(i,j(n)) = exp(-norm(X(i,:)-X(j(n),:))^2/2/sigma^2);
        end
    end
    
    nRowW = size(W,1);
    for i = 1:nRowW
        sum_row = sum(W(i,:));
        W(i,:) = W(i,:)/sum_row;
    end
    diag_ele_arr = sum(W+W',2)/2;
    A = diag(diag_ele_arr);
    L = A-(W+W')/2;
end
    
  
    
    
    
    