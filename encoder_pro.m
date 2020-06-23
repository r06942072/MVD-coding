% dependencies:
%   get_list.m
%   get_center_pos.m
%   seq2mat.m
%   getPercentage.m

%   get_lower_upper.m
%   adjust_low.m
%   adjust_up.m
%   b_C2Stream.m
%   LowUp2b_C.m
%   written by Chunhung Lin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function bitStream = encoder_pro(seq, symbol, height, width)
% parameters
SUM_max = 8000;
SUM_shrink_rate = 5;
center_adjust_step = 6;
symbolList = [0];
numOfContext = 4;
distance = [2, 1, 0]; %frame i, i-1, i-2 ....

% Step. assign all context, seq 1 to i-1 -> the i context
size = height*width;
context(1) = 1;
for i = 2:length(seq)
    frameIndex = ceil(i/size);
    list_current = [];
    list_past1 = [];
    list_past2 = [];
    % current
    startIndex_current = size*(frameIndex-1) + 1;
    sub_seq_current = seq(startIndex_current:i-1);
    mat_current = seq2mat(sub_seq_current, height, width, frameIndex);
    list_current = get_list(mat_current, get_center_pos(i, height, width, frameIndex), distance(1));
    % past1
    startIndex_past1 = size*(frameIndex-2) + 1;
    if startIndex_past1 >= 1
        sub_seq_past1 = seq(startIndex_past1:startIndex_past1+size-1);
        mat_past1 = seq2mat(sub_seq_past1, height, width, frameIndex-1);
        list_past1 = get_list(mat_past1, get_center_pos(i, height, width, frameIndex), distance(2));
    end
    % past2
    startIndex_past2 = size*(frameIndex-3) + 1;
    if startIndex_past2 >= 1
        sub_seq_past2 = seq(startIndex_past2:startIndex_past2+size-1);
        mat_past2 = seq2mat(sub_seq_past2, height, width, frameIndex-2);
        list_past2 = get_list(mat_past2, get_center_pos(i, height, width, frameIndex), distance(3));
    end
    % assign context
    myList = [list_current, list_past1, list_past2];
    percentage = getPercentage(myList, symbolList);
    if (numOfContext == 6)
        if (percentage >= 0.9)
            context(i) = 1;
        elseif (percentage >= 0.7) && (percentage < 0.9)
            context(i) = 2;
        elseif (percentage >= 0.5) && (percentage < 0.7)
            context(i) = 3;
        elseif (percentage >= 0.3) && (percentage < 0.5)
            context(i) = 4;
        elseif (percentage >= 0.1) && (percentage < 0.3)
            context(i) = 5;
        elseif (percentage < 0.1)
            context(i) = 6;
        else
            error('error');
        end
    elseif (numOfContext == 4)
        if (percentage >= 0.9)
            context(i) = 1;
        elseif (percentage >= 0.7) && (percentage < 0.9)
            context(i) = 2;
        elseif (percentage >= 0.5) && (percentage < 0.7)
            context(i) = 3;
        elseif (percentage < 0.5)
            context(i) = 4;
        else
            error('error');
        end
    elseif (numOfContext == 3)
        if (percentage >= 0.9)
            context(i) = 1;
        elseif (percentage >= 0.7) && (percentage < 0.9)
            context(i) = 2;
        elseif (percentage < 0.7)
            context(i) = 3;
        else
            error('error');
        end
    elseif (numOfContext == 2)
        if (percentage >= 0.9)
            context(i) = 1;
        elseif (percentage < 0.9)
            context(i) = 2;
        else
            error('error');
        end
    end
end

% plotDistribution('Context value', '123', context);
% %
% fig = figure;
% for i=1:numOfContext
%     indices = find(context==i);
%     subseq = seq(indices);
%     %
%     subplot(ceil(numOfContext/2),2,i);
%     h = histogram(subseq);
%     %
%     zero_percentage = length(find(subseq==0))/length(subseq);
%     %
%     xlabel('Motion vector difference');
%     ylabel('Count');
%     legend(strcat('(context, count, zero%) = ', num2str(i), ', ', num2str(length(subseq)), ', ', num2str(zero_percentage)));
% end
% saveas(fig, strcat('./expResult/', '123', '_numOfContext=', num2str(numOfContext), '_d=', num2str(distance)), 'fig');

% init freq table
freq_table = init_freq_table(symbol, numOfContext);
SUM = sum(freq_table);
%
% figure;
% heatmap(freq_table);
% colormap(gray);
% colorbar;
% title('init freq table');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
bitStream = [];
lower = 0;  upper = 1;
for i = 1:length(seq)
    % Step1. adjust lower and upper
    index = find(symbol==seq(i));
    new = get_lower_upper(freq_table(:, context(i)), SUM(context(i)), lower, upper, index);
    lower = new(1);
    upper = new(2);
    % Step2. should satisfied 0.5 as a threshold
    while((lower>=0.5) || (upper<=0.5))
        if lower >= 0.5
            new = adjust_low(lower, upper);
            bitStream = horzcat(bitStream,'1');
        elseif upper <= 0.5
            new = adjust_up(lower, upper);
            bitStream = horzcat(bitStream,'0');
        end
        lower = new(1);
        upper = new(2);
    end
    % Step3. update freq_table and SUM
    %
    freq_table = update_freq_table(freq_table, [index, context(i)], center_adjust_step);
    SUM = sum(freq_table);
    %
    SUM_index = find(SUM>=SUM_max);
    if ~isempty(SUM_index)
        freq_table(:, context(i)) = ceil(freq_table(:, context(i))/SUM_shrink_rate);
        SUM = sum(freq_table);
    end
end
if (lower > 0.5)||(upper < 0.5)
    error('error');
end
bitStream = horzcat(bitStream, b_C2bits(lowUp2b_C(lower, upper)));
end