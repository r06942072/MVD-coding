% dependencies:
%   make_segment.m
%   adjust_low1.m
%   adjust_up1.m
%   written by Chunhung Lin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function seq = decoder_pro(bitStream, symbol, data_length, height, width)
% parameters
SUM_max = 8000;
SUM_shrink_rate = 5;
center_adjust_step = 6;
symbolList = [0];
numOfContext = 4;
distance = [2, 1, 0]; %frame i, i-1, i-2 ....
context(1) = 1;
%
freq_table = init_freq_table(symbol, numOfContext);
SUM = sum(freq_table);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
seq = [];
lower = 0;  upper = 1;
low_b = 0;  up_b = 1;
index_b = 2;
if bitStream(1) == '0'
    up_b = 0.5;
elseif bitStream(1) == '1'
    low_b = 0.5;
else
    error('Error');
end
for i = 1:data_length
    % Step1. make segment based on freq_table, lower, upper
    seg = make_segment(freq_table(:, context(i)), SUM(context(i)), lower, upper);
    % Step2. output one symbol based on segment
    index = find((seg(1:end-1)<=low_b)&(seg(2:end)>=up_b));
    while isempty(index)
        if index_b > length(bitStream)
            error('No more bits to decode');
            return;
        end
        if bitStream(index_b)=='0'
            up_b = up_b - (up_b-low_b)/2;
        elseif bitStream(index_b)=='1'
            low_b = low_b + (up_b-low_b)/2;
        else
            error('Bits should be either 0 or 1');
        end
        index_b = index_b + 1;
        index = find((seg(1:end-1)<=low_b)&(seg(2:end)>=up_b));
    end
    seq(i) = symbol(index);
    %
    if (i==data_length)
        break;
    end
    % Step3-1. update the i freq_table and SUM
    freq_table = update_freq_table(freq_table, [index, context(i)], center_adjust_step);
    SUM = sum(freq_table);
    %
    SUM_index = find(SUM>=SUM_max);
    if ~isempty(SUM_index)
        freq_table(:, context(i)) = ceil(freq_table(:, context(i))/SUM_shrink_rate);
        SUM = sum(freq_table);
    end
    % Step3-2. decoded seq 1 to i -> the i+1 context
    ii = i+1;
    size = height*width;
    frameIndex = ceil(ii/size);
    list_current = [];
    list_past1 = [];
    list_past2 = [];
    % current
    startIndex_current = size*(frameIndex-1) + 1;
    sub_seq_current = seq(startIndex_current:i);
    mat_current = seq2mat(sub_seq_current, height, width, frameIndex);
    list_current = get_list(mat_current, get_center_pos(ii, height, width, frameIndex), distance(1));
    % past1
    startIndex_past1 = size*(frameIndex-2) + 1;
    if startIndex_past1 >= 1
        sub_seq_past1 = seq(startIndex_past1:startIndex_past1+size-1);
        mat_past1 = seq2mat(sub_seq_past1, height, width, frameIndex-1);
        list_past1 = get_list(mat_past1, get_center_pos(ii, height, width, frameIndex), distance(2));
    end
    % past2
    startIndex_past2 = size*(frameIndex-3) + 1;
    if startIndex_past2 >= 1
        sub_seq_past2 = seq(startIndex_past2:startIndex_past2+size-1);
        mat_past2 = seq2mat(sub_seq_past2, height, width, frameIndex-2);
        list_past2 = get_list(mat_past2, get_center_pos(ii, height, width, frameIndex), distance(3));
    end
    % assign context
    myList = [list_current, list_past1, list_past2];
    percentage = getPercentage(myList, symbolList);
    if (percentage >= 0.9)
        context(ii) = 1;
    elseif (percentage >= 0.7) && (percentage < 0.9)
        context(ii) = 2;
    elseif (percentage >= 0.5) && (percentage < 0.7)
        context(ii) = 3;
    elseif (percentage < 0.5)
        context(ii) = 4;
    else
        error('error');
    end
    % Step4. update lower and upper based on the interval of output symbol
    lower = seg(index);
    upper = seg(index+1);
    % Step5. should satisfied 0.5 as a threshold
    while((lower>=0.5) || (upper<=0.5))
        if lower>=0.5
            new = adjust_low1(lower, upper, low_b, up_b);
            lower = new(1); upper = new(2); low_b = new(3); up_b = new(4);
        elseif upper<=0.5
            new = adjust_up1(lower, upper, low_b, up_b);
            lower = new(1); upper = new(2); low_b = new(3); up_b = new(4);
        end
    end
end
end

