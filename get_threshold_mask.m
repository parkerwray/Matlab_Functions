function dummy = get_threshold_mask(dummy, threshold)

%{

This function finds the valuea in a 1D or 2D array that are above a set threshold. It also generates a
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
%   mask = NaN(size(dummy));
    
    %for i = 1:size(dummy,3)
       % threshold = intmax('int16');
     %  dummy2 = dummy(:,:,i);
       dummy(dummy>threshold)= 1;
       dummy(dummy~=1) = NaN;
       % mask()>=threshold) = 1;
   % end
    
    
end