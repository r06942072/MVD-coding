%   written by Chunhung Lin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function percentage = getPercentage(myList, symbolList)
% output:
%   the percentage of elements in myList include in symbolList
if isempty(myList)
    percentage = 0;
else
    count = 0;
    for i=1:length(myList)
        if find(myList(i)==symbolList)
            count = count + 1;
        end
    end
    percentage = count/length(myList);
end
end