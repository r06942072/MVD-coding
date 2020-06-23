%   written by Chunhung Lin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function mat = seq2mat(seq, height, width, frameIndex)
%  turn a seq into a matrix wiht zigzag scan
%  if the seq length is not long enough, append fake data 999
%  
size = height*width;
if length(seq)<size % current frame, append fake data 999
    append = ones(1, size-length(seq))*999;
    seq = [seq, append];
end
mat = zeros(height, width);
seqIndex = 1;
if mod(frameIndex, 2) == 1
    % from up to down
    for i=1:height
        if mod(i, 2) == 1
            for j=1:width
                mat(i, j) = seq(seqIndex);
                seqIndex = seqIndex + 1;
            end
        elseif mod(i, 2) == 0
            for j=width:-1:1
                mat(i, j) = seq(seqIndex);
                seqIndex = seqIndex + 1;
            end
        end
    end
elseif mod(frameIndex, 2) == 0
    % from down to up
    for i=height:-1:1
        if mod(i, 2) == 1
            for j=width:-1:1
                mat(i, j) = seq(seqIndex);
                seqIndex = seqIndex + 1;
            end
        elseif mod(i, 2) == 0
            for j=1:width
                mat(i, j) = seq(seqIndex);
                seqIndex = seqIndex + 1;
            end
        end
    end
end
end