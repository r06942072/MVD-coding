function b_C = lowUp2b_C(lower, upper)
global k;
k = 2;
% input = [low, up]
% output = [b, C]
if (lower<0) || (upper>1)
    error('error');
end
b = 1;
while true
    C = ceil(lower*(k^b));
    if upper >= (C+1)*(k^-b)
        b_C = [b, C];
%         disp(['b = ', num2str(b_C(1))]);
%         disp(['C = ', num2str(b_C(2))]);
        return;
    end
    b = b + 1;
end