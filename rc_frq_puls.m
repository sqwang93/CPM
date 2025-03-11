function [frq_puls_rspns] = rc_frq_puls(Ns)

% [frq_puls_rspns] = rc_frq_puls(Ns)
% Ns: the number of sample per symbol period

% Calculating Sample point
t = 1/2/Ns : 1/Ns : 1 - 1/2/Ns;
frq_puls_rspns = zeros(length(t), 1);
frq_puls_rspns = 1/2 * (1 - cos(2 * pi * t));

% Normalization to 1
frq_puls_rspns = frq_puls_rspns/sum(frq_puls_rspns);