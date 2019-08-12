function nearest_neighbour(X,Y,x_new)

nX = size(X,1);
nY = length(Y);
if nX ~= nY
    error('nX ~= nY')
end

mean_class = [];
y_class = unique(Y);

for i=1:length(y_class)
    c = y_class(i);
    ii = find(Y==c);
    Xc = X(ii,:);
    mean_class(end+1,:) = mean(Xc,1);
end

for i=1:length(x_new(:,1))
    x0 = x_new(i,:);
    normC = [];
    for c=1:length(mean_class(:,1))
        mC = mean_class(c,:);
        normC(end+1) = norm(x0 - mC);
    end
    ii = find(normC == min(normC));
    if length(ii) == 1
        y_new(i) = y_class(ii);
    else
        aa=1;
    end
end

aa=1;