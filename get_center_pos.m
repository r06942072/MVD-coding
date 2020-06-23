% dependencies:
%   seq2mat.m
%   written by Chunhung Lin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pos = get_center_pos(index, height, width, frameIndex)
% 
size = height*width;
seq = [1:size];
mat = seq2mat(seq, height, width, frameIndex);
location = index - size*(frameIndex-1);
[pos_i, pos_j] = find(mat==location);
pos = [pos_i, pos_j];
end