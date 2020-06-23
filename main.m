clear all;
clc;
close all;

% adjust distance
filename = {'Akiyo','Bus','City','Cheerleaders','Container','FlowerGarden','Football'...
    'Foreman','Hall','Highway','Waterfall'};
final_result = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i=1:length(filename)
    file_current = filename{i};
    load(strcat('..\data_MotionVector\', file_current,'.mat'));
    disp('*');
    disp('video seq = ');
    disp(file_current);
    %
    seq = seqMVx_zigzag;
    tic;
    bitStream = encoder_pro(seq, symbol, height, width);
    time = toc;
    bps = length(bitStream)/length(seq);
    %         dseq = decoder_pro(bitStream, symbol, length(seq), height, width);
    %         if seq == dseq
    %             disp('Perfectly reconstruct');
    %         end
    final_result = [final_result; [bps, time]];
    %
    seq = seqMVy_zigzag;
    tic;
    bitStream = encoder_pro(seq, symbol, height, width);
    time = toc;
    bps = length(bitStream)/length(seq);
    %     dseq = decoder_pro(bitStream, symbol, length(seq), height, width);
    %     if seq == dseq
    %         disp('Perfectly reconstruct');
    %     end
    final_result = [final_result; [bps, time]];
end
disp('finish~');