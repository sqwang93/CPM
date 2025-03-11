function [state_from_input, state_from, to_state_output, to_state, phase_state] = gen_trlls(m, h)

state_num = 2/h;
input_sym_num = m;

to_state = zeros(state_num, input_sym_num);    
to_state_output = zeros(state_num, input_sym_num);
phase_state = zeros(state_num, input_sym_num);
state_from = zeros(state_num, input_sym_num);               % State transition matrix
state_from_input = zeros(state_num, input_sym_num);          % State transition matrix corresponding input

for i = 1 : state_num
    for k = 1 : input_sym_num
        to_state(i, k) = mod(i - 1 + (2 * (k - 1) - (m - 1)), state_num);
        to_state_output(i, k) = k - 1;
    end
end

phase_state = (0 : state_num - 1)';

% For matlab matrix index convenience, modify state representation.
to_state = to_state + 1;

for k = 1 : state_num
    l = 1;
    for i = 1 : state_num
        for j = 1 : input_sym_num
            if to_state(i, j) == k
                state_from(k, l) = i;
                state_from_input(k, l) = j - 1;
                l = l + 1;
            end
        end
    end
end