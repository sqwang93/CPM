function [src_data, mod_sig] = gen_cpm_sig(pilot_sym_num, info_sym_num, tail_sym_num, h, m, Ns, frq_puls_rspns, fre_offset, ideal_timing)

% [src_data, mod_sig] = gen_trans_sig(sym_num, h, m, Ns, output, next_state)
% h: Modulation index
% m: Size of modulation alphabet set
% Ns: the number of sample per symbol
% output: code trellis output matrix
% to_state: trellis state transition matrix

% This program generates phase-titled CPM signal.

sym_num_per_slot = pilot_sym_num + info_sym_num + tail_sym_num;
coded_sym = zeros(sym_num_per_slot, 1);
output_sampl_num = 1 + sym_num_per_slot * Ns;          % Increment 1 for initial modulation phase

src_data = randi(m - 1, info_sym_num, 1);

coded_sym(pilot_sym_num + 1 : pilot_sym_num + info_sym_num) = src_data;
coded_sym(end) = mod(m - mod(sum(2 * src_data - m + mod(info_sym_num - 1, 2)) - m, 2 * m)/2, m);

% CPFSK modulation
acc_phas = zeros(output_sampl_num, 1);
for i = pilot_sym_num * Ns + 2 : output_sampl_num
    acc_phas(i) = acc_phas(i - 1) + (2 * coded_sym(fix((i + Ns - 2)/Ns)) - m + 1) * frq_puls_rspns(1 + mod(i - 2, Ns));
end
mod_sig = exp(1i * pi * h * acc_phas);

% Add frequency offset
mod_sig = mod_sig .* exp(1i * 2 * pi * fre_offset/Ns * (1 : length(mod_sig)))';

% Get rid of initial modulation phase signal
if ideal_timing == 1  % ideal timing synchronization
    mod_sig(1) = [];
else
    mod_sig(end) = []; % Timing offset is 1/Ns symbol
end