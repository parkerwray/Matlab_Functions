function [mean_brightness] = get_average(dummy)
%% Find Mean Brightness
%{ 
This code relies on the fact that a nan mask is used. Else, the average 
 will be scaled incorrectly because it divides by N!
%}

    for i = 1:size(dummy,3)
    mean_brightness(i) = mean(mean(dummy(:,:,i),1,'omitnan'),2,'omitnan');
    end

end





