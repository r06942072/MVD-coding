function bits = b_C2bits(b_C)
bits = char(zeros(1, b_C(1)));
bits(:) = '0';
temp = d2b(b_C(2));
bits(length(bits)-length(temp)+1:end) = temp(:);
    function output = d2b(input)
        output = dec2bin(abs(input));
        if input < 0
            for i = 1:length(output)
                if output(i) == '0'
                    output(i) = '1';
                elseif output(i) == '1'
                    output(i) = '0';
                end
            end
        end
    end
end