function [correlator] = gen_mtchd_fltr(Ns, m, h, frq_puls_rspns)
% This function can generate CPFSK correlator(matched filter);
% [correlator] = gen_mtchd_fltr(Ns, m, h)
% input h: Modulation index
% input m: Size of modulation alphabet set
% input Ns: the number of sample per symbol
% output correlator: each clommn is a correlator correspoding to each modulation symbol.

% Generate CPFSK matched filter, the number is m.
acc_phase = zeros(Ns + 1, m);
for k = 1 : m                  % Index of the correlator group
    for i = 2 : Ns + 1         % Index of the correlator phase track
        acc_phase(i, k) = acc_phase(i - 1, k) + (2 * k - m - 1) * frq_puls_rspns(i - 1);
    end
end

correlator = exp(j * pi * h * acc_phase);
correlator(1, :) = [];