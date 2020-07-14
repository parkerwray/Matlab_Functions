
function [true_max, max_mask] = get_max(dummy, thresh_value, saturate_value)
%{

This function finds the max value in a 1D or 2D array. It also generates a
mask of the regions that are >= thresh_value.*max. The function relies on
NAN logic. 

Inputs:
dummy = image you want to find max value
thresh_value = threshold for making mask >= thresh_value.*max
saturate_value = maximum values that should be ignored when finding max

Outputs:
true_max = maximum value 
max_mask = mask of all values  >= thresh_value.*max and <= saturate_value
%}


%[~, dummymask, ~] = make_mask_logical(dummy, dummymask);
    max_mask = NaN(size(dummy));
    
    for i = 1:size(dummy,3)
       % threshold = intmax('int16');
        dummy2 = dummy(:,:,i);
        dummy2(dummy2>=saturate_value) = NaN;
        true_max(i) = nanmax(nanmax(dummy2,[],1),[],2);
        [y, x] = find(dummy2 > (thresh_value).*true_max(i));
        max_index = sub2ind(size(dummy2),y,x);
        test= max_mask(:,:,i);
        test(max_index) = 1;
        max_mask(:,:,i) = test;
    end
    
    
end















