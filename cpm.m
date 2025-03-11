function [sym_err_rat] = cpm(EbN0, m, Ns, frm_num, fre_offset, ideal_timing)

% EbN0: bit energy divides noise power spectrum density
% m: Size of modulation alphabet set
% Ns:The number of sample per symbol
% frm_num: the number of frame in the simulation
% fre_offset: frequency difference between transmiter and receiver
% sym_err_rat: symbol error rate

h = 1/m;              % Modulation index of CPFSK

% Config slot structure(according to FH rate)
info_sym_num = 47;    % The number of symbol used for transfer traffic data per slot
pilot_sym_num = 4;    % The number of pilot-symbol used for initial phase estimation
tail_sym_num = 1;     % The number of tailing-symbol forcing the FSM to 'zero-state'

% SNR adjustment according to correlation between EbN0 and symbol's SNR
% - 10 * log10(Ns) due to sample rate Ns times symbol rate
% 10 * log10(log2(m)) due to log2(m) bits transmited per symbol
SNR = EbN0 - 10 * log10(Ns) + 10 * log10(log2(m));

% Declare varible for SER statistics
err_num_total = zeros(1, 1);

frq_puls_rspns = rc_frq_puls(Ns);

% Generate correlator(matched filter) 
mtchd_fltr = gen_mtchd_fltr(Ns, m, h, frq_puls_rspns);

% Generate from-some-state, output(frequency control for cpfsk) & to-some-state matrix.
[state_from_input, state_from, to_state_output, ~, phase_state] = gen_trlls(m, h);

for i = 1 : frm_num
    % Generate coded modulation tansmitting signal
    [src_data, mod_sig] = gen_cpm_sig(pilot_sym_num, info_sym_num, tail_sym_num, h, m, Ns, frq_puls_rspns, fre_offset, ideal_timing);
    
    % Via gaussian channel
    noisy_sig = awgn(mod_sig, SNR, 0);

    % Correlation
    [corr_metric, ref_phase] = mtchd_fltr_proc(pilot_sym_num, noisy_sig, mtchd_fltr, Ns);
    
    % Noncoherent maximum likelihood sequence detection
%     demod_sym_co = mlsd(corr_metric, h, to_state_output, state_from, state_from_input, phase_state);
    demod_sym_nc = nc_mlsd(ref_phase, corr_metric, h, to_state_output, state_from, state_from_input, phase_state);
   
     % Symbol error statistic
%     demod_sym = [demod_sym_nc, demod_sym_co];
    
    [err_num, ~] = symerr(demod_sym_nc, src_data, 'column-wise');
    err_num_total = err_num_total + err_num';
end

sym_err_rat = err_num_total/frm_num/info_sym_num;
disp(['Noncoherent MLSD SER is ', num2str(sym_err_rat(1))]);
% disp(['Coherent MLSD SER is ', num2str(sym_err_rat(2))]);
