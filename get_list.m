%   written by Chunhung Lin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function list = get_list(mat, center, manhattan_distance)
% given a matrix, find all the elements within a distance from center position
list = [];
height = size(mat, 1);
width = size(mat, 2);
for i=1:height
    for j=1:width
        d = abs(i-center(1)) + abs(j-center(2));
        if d <= manhattan_distance
            if mat(i, j) == 999
                continue;
            end
            %
            list = [list, mat(i, j)];
        end
    end
end
end