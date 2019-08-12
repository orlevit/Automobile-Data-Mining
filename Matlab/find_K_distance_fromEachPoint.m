function Dk_and_kPointIndex = find_K_distance_fromEachPoint(XX,k,d_method)
% d_method = 'E' or 'M' (Eclidian, Manhattan). (default: 'E')

%{
%Example:
XX=[1,5,2,10]';
Dk_and_kPointIndex = find_K_distance_fromEachPoint(XX,2);
Result:
Dk_and_kPointIndex =
     4     2
     4     1
     3     2
     8     3
     ^     ^
     |     |
 k-dist.   Point Index

%}

%load MMN_22; XX = MMN_22;

if nargin < 3
    d_method = 'E';
end

D = pdist_or(XX, d_method);
Z = squareform(D);
k = k+1; %<-- to exclude the current point (wirh dist=0)
for i=1:length(Z(1,:))
   [Z_row_sort,i_sort] = sort(Z(i,:));
   Dk_and_kPointIndex(i,1:2) = [Z_row_sort(k),i_sort(k)];
end

return
