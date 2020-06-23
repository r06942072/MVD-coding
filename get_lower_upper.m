%   written by Chunhung Lin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function new = get_lower_upper(freq_table, SUM, lower, upper, index)
new = [];
gap = upper-lower;
lower1=lower;  %
lower = lower + gap*sum(freq_table(1:index-1))/SUM;
upper = lower1 + gap*sum(freq_table(1:index))/SUM;
new = [lower, upper];
end