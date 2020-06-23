%   written by Chunhung Lin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function freq_table = update_freq_table(freq_table, location, center_adjust_step)
%
enable_symmetric_adjust = 1;
center = ceil(size(freq_table,1)/2);
if (enable_symmetric_adjust)
    gap = abs(location(1)-center);
    freq_table(center+gap, location(2)) = freq_table(center+gap, location(2)) + center_adjust_step;
    freq_table(center-gap, location(2)) = freq_table(center-gap, location(2)) + center_adjust_step;
end
end