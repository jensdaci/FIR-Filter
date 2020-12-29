
% Behavior model for FIR Filter
% Group:    Jens Daci (jd3693)
%           Mateusz Ardito-Proulx (mma2256)

clear;
clc

% Generating numbers for Input and Coeff.
I = randi([0 1000], 16384, 1);
C = randi([0 1000], 64, 1);

% Writing the values into a text file
fid_I = fopen('input.txt', 'w');
T_write_I = table(I, 'VariableNames', {'I'});
writetable(T_write_I, 'input.txt');
T_read_I = readtable('input.txt');

fid_C = fopen('coefficients.txt', 'w');
T_write_C = table(C, 'VariableNames', {'C'});
writetable(T_write_C, 'coefficients.txt');
T_read_C = readtable('coefficients.txt');

% Instantiating arrays to hold variables
input_arr = zeros(16448, 1);
coeff_arr = zeros(64, 1);
y_arr = zeros(16384, 1);
multiplication_arr = zeros(64, 1);

% Storing the input values into an array (padding zeros)
for i=1:16448  
    if i <= 64
        input_arr(i) = 0;
    elseif i > 64
        input = T_read_I.I(i-64);
        input_arr(i) = input;
    end
end

% Storing coefficients into an array
for i=1:64
    coeff = T_read_C.C(i);
    coeff_arr(i) = coeff;
end

% Calculating the output using summation formula
for n=65:16448  
    for i=1:64
        multiplication_arr(i) = coeff_arr(i) * input_arr(n+1-i);
    end
    y_arr(n-64) = sum(multiplication_arr);
end

% Writing results to a text file
fid_Y = fopen('output.txt', 'w');
T_write_Y = table(y_arr, 'VariableNames', {'Y'}); 
writetable(T_write_Y, 'output.txt', 'WriteVariableNames', 0);

writetable(T_write_I, 'input.txt', 'WriteVariableNames', 0);
writetable(T_write_C, 'coefficients.txt', 'WriteVariableNames', 0);


% Testing the results with a golden output (Testbench)
input_gold = zeros(16384, 1);
error = 0;

for i=1:16384
    input_gold(i) = input_arr(i+64);
end

[output_gold, z_arr] = fir_filt_linear_buff(coeff_arr', input_gold, zeros(64, 1));

for i=1:16384
    if y_arr(i) ~= output_gold(i)
        error = error + 1;
    end
end

if error == 0
    S = 'The results DO match!';
else
    S = 'The results DO NOT match';
end

disp("Error is: " + error)
disp(S)

% Truncating the output to 16 bits (To Facilitate Verilog Testbench)
y_16bit_arr = zeros(16384, 16);
y_16bit = zeros(16384, 1);
fid_Y_16bit = fopen('output_16bit.txt', 'w');

for i=1:16384    
    y_char = dec2bin(y_arr(i), 16);
   
    for j=1:16
        if y_char(j) == 49
            y_16bit_arr(i, j) = 1;
        elseif y_char(j) == 48
            y_16bit_arr(i, j) = 0;
        end 
        y_char_16(j) = y_char(j);
    end
    y_16bit(i) = str2num(y_char_16);
    fprintf(fid_Y_16bit,'%016d\n', y_16bit(i));
end

% Finishing
fclose(fid_I);
fclose(fid_C);
fclose(fid_Y);
fclose(fid_Y_16bit);

