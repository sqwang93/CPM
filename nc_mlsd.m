function [demod_sym] = nc_mlsd(ref_phase, corr_metric, h, output, state_trans, input, phase_state)

[state_num, input_num] = size(output);
[tmp, mod_sym_num] = size(corr_metric);
demod_sym = zeros(mod_sym_num, 1);

% For matlab matrix index convenience, modify output symbol representation.
output = output + 1;

% For simplicity and debuging, program saves total survivor metric at every symbol.
acc_metric = zeros(state_num, mod_sym_num + 1);
acc_metric(1, 1) = 100;      % Init acc_metric according to initial state

% Survivor path saving
survivor_path = zeros(state_num, mod_sym_num);

% Survivor path phase reference
phase_ref_old = ref_phase * ones(state_num, 1);
phase_ref_new = ref_phase * ones(state_num, 1);

branch_metric = zeros(state_num, input_num);    % Branch metric state_num * input_num

for k = 1 : mod_sym_num 
    % branch metric calculation.
%     for i = 1 : state_num
%         for l = 1 : input_num
%             branch_metric(i, l) = real(corr_metric(output(i, l), k) * conj(phase_ref_new(i)) * exp(-j * 2 * pi * h * phase_state(i, 1) ));
%         end
%     end
    for i = 1 + mod(k - 1, 2) : 2 : state_num
        for l = 1 : input_num
            branch_metric(i, l) = real(corr_metric(output(i, l), k) * conj(phase_ref_new(i)) * exp(-j * pi * h * phase_state(i)));
        end
    end    

    % Path metric accumulation, compartion and maximum metric selection&saving
    [acc_metric(:, k + 1), sur_path_index] = metric_acc_cmp_sel(acc_metric(:, k), branch_metric, state_trans, input, 1 + mod(k, 2));
    
    % Survivor state path saving
    for n = 1 + mod(k, 2) : 2 : state_num
          survivor_path(n, k) = state_trans(n, sur_path_index(n));
    end
    
    % Survivor path phase reference updating
    for n = 1 + mod(k, 2) : 2 : state_num
        phase_ref_new(n) = (.9 * phase_ref_old(state_trans(n, sur_path_index(n))) ...
        + .1 * corr_metric(output(state_trans(n, sur_path_index(n)), input(n, sur_path_index(n)) + 1), k) ... 
        * exp(-j * pi * h * phase_state(state_trans(n, sur_path_index(n))))) ;
    end
    phase_ref_old = phase_ref_new;
end

[maximum index] = max(acc_metric(:, mod_sym_num + 1));
% index = 1;
% Traceback for decoding
for i = mod_sym_num : -1 : 1
    demod_sym(i) = input(index, find(state_trans(index, :) == survivor_path(index, i)));
    index = survivor_path(index, i);
end

demod_sym(end) = [];