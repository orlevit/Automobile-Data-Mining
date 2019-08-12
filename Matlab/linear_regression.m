%Or2
clear

groupRange =...
[-inf,5000;...
5000,6600;...
6600,7300;...
7300,8000;...
8000,9100;...
9100,10300;...
10300,12500;...
12500,15500;...
15500,17200;...
17200,22500;...
22500,45400;...
45400,inf];

groupNames =...
 ['A';'B';'C';'D';'E';'F';'G';'H';'I';'J';'K';'L'];

load data_from___aba_update___file; %load "data" array

% data = fliplr(data);

data(:,1) = data(:,1)*40282 + 5118;

data_orig = data;
[ny,nx] = size(data_orig);
k_folds = 10;
n_of_data_points = round((ny/k_folds)*(k_folds-1));

rand('seed',3)
%y = datasample([1:10;11:20],4,2, 'Replace',false);

all_indexes = [1:ny]';

Ycorrect_validation_matrix = [];
Ypredict_validation_matrix = [];
ind_validate_matrix = [];
coeff_matrix = [];
rmse_matrix  = [];
std_matrix   = [];
R2_matrix    = [];

for k=1:k_folds
    ind_train    = datasample(all_indexes,n_of_data_points, 'Replace',false);
    ind_validate = setdiff(all_indexes,ind_train);
    
    data_train = data(ind_train,:);
    data_val   = data(ind_validate,:);
    
    Xt = data_train(:,2:end);
    Yt = data_train(:,1);
    Xv = data_val(:,2:end);
    Yv = data_val(:,1);    
    
    %Linear regresion
    [nyt,nxt] = size(Xt);
    At = nan(nyt,nxt+1);
    At(:,1) = ones(nyt,1);
    At(:,2:end) = Xt;    
    c = pinv(At)*Yt; %Coefficients
    
    %Valitation
    [nyv,nxv] = size(Xv);
    Av = nan(nyv,nxv+1);
    Av(:,1) = ones(nyv,1);
    Av(:,2:end) = Xv;   
    Ypredict = Av * c;
    
    ind_validate_matrix = [ind_validate_matrix, ind_validate];
    coeff_matrix        = [coeff_matrix,c];
    rmse_matrix         = [rmse_matrix, rms(Yv - Ypredict)];
    std_matrix          = [std_matrix, std(Yv - Ypredict)];
    Ycorrect_validation_matrix = [Ycorrect_validation_matrix, Yv];
    Ypredict_validation_matrix = [Ypredict_validation_matrix, Ypredict];
    
    Yv_mean = mean(Yv);
    SS_tot = sum((Yv - Yv_mean).^2);
    SS_res = sum((Yv - Ypredict).^2);    
    R2 = 1 - SS_res/SS_tot;    
    R2_matrix = [R2_matrix, R2];            
end

figure(1); clf
plot(Ycorrect_validation_matrix(:),Ypredict_validation_matrix(:),'*')
hold on
axis equal
grid on; zoom on;
xlabel('Correct')
ylabel('Predicted')
max1 = max([Ycorrect_validation_matrix(:);Ypredict_validation_matrix(:)]);
h=plot([0,max1],[0,max1],'--r');
axis([0,max1,0,max1])

%Sanity Check
if size(Ypredict_validation_matrix,2) ~= k_folds
    error('Dimention Inconsistency')
end


%-- Devision into Groups --
%Correct
Ycorrect_validation_matrix_groups = [];
[ny,nx] = size(Ypredict_validation_matrix);
for iy=1:ny
    for ix=1:nx        
        y = Ycorrect_validation_matrix(iy,ix);
        for j=1:length(groupRange(:,1))
            range = groupRange(j,:);
            if range(1) <= y && y < range(2)
                group_no = j;
                Ycorrect_validation_matrix_groups(iy,ix) = groupNames(group_no);
                break
            end
        end
    end
end

%Prediction
Ypredict_validation_matrix_groups = [];
[ny,nx] = size(Ypredict_validation_matrix);
for iy=1:ny
    for ix=1:nx        
        y = Ypredict_validation_matrix(iy,ix);
        for j=1:length(groupRange(:,1))
            range = groupRange(j,:);
            if range(1) <= y && y < range(2)
                group_no = j;
                Ypredict_validation_matrix_groups(iy,ix) = groupNames(group_no);
                break
            end
        end
    end
end

if_print_groups = 0;
if if_print_groups
    %Plot Correct Groups
    fprintf('Correct Groups:\n')
    for iy=1:ny
        for ix=1:nx
            fprintf('%s ',Ycorrect_validation_matrix_groups(iy,ix));
        end
        fprintf('\n')
    end
    fprintf('\n')
    %Plot Predicted Groups
    fprintf('Predicted Groups:\n')
    for iy=1:ny
        for ix=1:nx
            fprintf('%s ',Ypredict_validation_matrix_groups(iy,ix));
        end
        fprintf('\n')
    end
end
Y_diff_groups = round(Ycorrect_validation_matrix_groups - Ypredict_validation_matrix_groups);
ii = find(Y_diff_groups);
Y_diff_groups(ii) = 1;

no_of_errors_in_each_Krun = sum(Y_diff_groups,1);
sum(no_of_errors_in_each_Krun) / k_folds


aa=1;

