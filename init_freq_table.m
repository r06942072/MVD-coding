%   written by Chunhung Lin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function freq_table = init_freq_table(symbol, numOfContext)
% uniform
% freq_table = ones(length(symbol), numOfContext);
%
% one-pulse model
% center = ceil(length(symbol)/2);
% freq_table = ones(length(symbol), numOfContext);
% freq_table(center,:) = 500;
% 
% gaussian model, F(v) = max(a*exp(-sigma*v^2), 1);
a = length(symbol)*10;
sigma = [numOfContext:-1:1];
freq_table = a*exp(-symbol'.^2*sigma);
freq_table = max(freq_table, 1);
end