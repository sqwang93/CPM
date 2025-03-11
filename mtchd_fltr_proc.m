function [corr_metric, ref_phase] = mtchd_fltr_proc(pilot_num, mod_sig, mtchd_fltr, Ns)

pilot_rcv_sig = mod_sig(1 : pilot_num * Ns);

mod_sig(1 : pilot_num * Ns) = [];

[n_row, n_col] = size(mtchd_fltr);
corr_metric = ones(n_row, length(mod_sig)/Ns);

mod_sig = reshape(mod_sig, Ns, length(mod_sig)/Ns);
corr_metric = mtchd_fltr' * mod_sig;

ref_phase = sum(pilot_rcv_sig)/pilot_num;