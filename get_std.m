function [std_brightness] = get_std(dummy)
%% Find Standard Deviation Brightness
%{ 
This code relies on the fact that a nan mask is used. Else, the average 
 will be scaled incorrectly because it divides by N!
%}

    for i = 1:size(dummy,3)
    dummy2 = dummy(:,:,i);
    std_brightness(i) = std(dummy2(:),[],'omitnan');
    end

end