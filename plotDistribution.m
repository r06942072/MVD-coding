function plotDistribution(in_xLabel, in_title, seq)
figure;
h = histogram(seq, 'DisplayName', strcat('Total Count = ', num2str(length(seq))));
xlabel(in_xLabel);
ylabel('Count');
legend;
title(in_title);
% 
E = h.BinEdges;
y = h.BinCounts;
xloc = E(1:end-1)+diff(E)/2;
text(xloc, y+1, string(y), 'Color', 'r');
end