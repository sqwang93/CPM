function [sur_acc_metric, sur_path_index] = metric_acc_cmp_sel(acc_metric, branch_metric, state_trans, input, odd_or_even)

[num_row, num_col] = size(state_trans);

input = input + 1;

tentative_acc_metric = zeros(num_col, num_row);
sur_acc_metric = zeros(num_row, 1);
sur_path_index = zeros(num_row, 1);

for k = odd_or_even : 2 : num_row
    % State metric accumulation
    for l = 1 : num_col
        tentative_acc_metric(l, k) = branch_metric(state_trans(k, l), input(k, l)) + acc_metric(state_trans(k, l));  
    end
end

[max_acc_metric, sur_path_index] = max(tentative_acc_metric);
sur_acc_metric = max_acc_metric';