% FIR Filter function to use as testbench
% Taken from MATLAB Help Center Forum
% Link (from Lecture Slides):   https://bit.ly/2Ia1NlR

function [y,z] = fir_filt_linear_buff(b,x,z)
    y = zeros(size(x));
    for n=1:length(x)
        z = [x(n); z(1:end-1)];
        y(n) = b * z;
    end
end