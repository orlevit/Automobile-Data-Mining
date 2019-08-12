function D = pdist_or(X,d_method)
%PDIST Pairwise distance between observations.
%   D = PDIST(X) returns a vector D containing the Euclidean distances
%   between each pair of observations in the M-by-N data matrix X. Rows of
%   X correspond to observations, columns correspond to variables. D is a
%   1-by-(M*(M-1)/2) row vector, corresponding to the M*(M-1)/2 pairs of
%   observations in X.
%
%   d_method = 'E' or 'M' (Eclidian, Manhattan). (default: 'E')

if nargin < 2
    d_method = 'E';
end

[ny,nx] = size(X);

D= [];
for i1=1:ny
    for i2=(i1+1):ny
        x1 = X(i1,:);
        x2 = X(i2,:);
        if strcmpi(d_method,'E')
            D(1,end+1) = norm(x1-x2);
        elseif strcmpi(d_method,'M')
            D(1,end+1) = sum(abs(x1-x2));
        end
%         if D(end)==0
%             aa=1;
%         end
    end    
end

