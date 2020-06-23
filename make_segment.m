% ex. 
% prob = [0.7, 0.2, 0.1]; 
% segment = [0, 0.7, 0.9, 1];
function new = make_segment(prob, SUM, lower, upper)
new = lower;
gap = upper-lower;
for i = 1:length(prob)-1
    new = horzcat(new, lower+gap*sum(prob(1:i))/SUM);
end
new =[new,upper]; 
end