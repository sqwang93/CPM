clear
close all
clc

EbN0 = 6 : 1 : 14;
len = length(EbN0);
sym_err_rat = zeros(4, len);

for i = 1 : 5
    sym_err_rat(1, i) = cpm(EbN0(i), 4, 4, 200 * 3^i, .000, 1);
    sym_err_rat(2, i) = cpm(EbN0(i), 4, 16, 200 * 3^i, .000, 0);
    sym_err_rat(3, i + 4) = cpm(EbN0(i + 4), 8, 4, 200 * 3^i, .000, 1);
    sym_err_rat(4, i + 4) = cpm(EbN0(i + 4), 8, 16, 200 * 3^i, .000, 0);
end

semilogy(EbN0, sym_err_rat(1, :), 'r-*', EbN0, sym_err_rat(2, :), 'b-^', EbN0, sym_err_rat(3, :), 'c-<', EbN0, sym_err_rat(4, :), 'g->');
title('MCPM 1RC nonideal symbol sync(1/16 symbol period) demodulation simulation');
xlabel('EbN0'); ylabel('SER');
legend('Ideal M=4 1RC', 'Nonideal M=4 1RC', 'Ideal M=8 1RC', 'Nonideal M=8 1RC');
grid on

for i = 1 : 5
%     sym_err_rat(1, i) = cpm(EbN0(i), 4, 4, 200 * 3^i, .000, 1);
    sym_err_rat(2, i) = cpm(EbN0(i), 4, 4, 200 * 3^i, .001, 1);
%     sym_err_rat(3, i + 4) = cpm(EbN0(i + 4), 8, 4, 200 * 3^i, .000, 1);
    sym_err_rat(4, i + 4) = cpm(EbN0(i + 4), 8, 4, 200 * 3^i, .001, 1);
end

figure;
semilogy(EbN0, sym_err_rat(1, :), 'r-*', EbN0, sym_err_rat(2, :), 'b-^', EbN0, sym_err_rat(3, :), 'c-<', EbN0, sym_err_rat(4, :), 'g->');
title('MCPM 1RC nonideal frequency sync demodulation simulation');
xlabel('EbN0'); ylabel('SER');
legend('Ideal M=4 1RC', 'Nonideal M=4 1RC', 'Ideal M=8 1RC', 'Nonideal M=8 1RC');
grid on
