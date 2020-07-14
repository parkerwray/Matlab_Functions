function inverted_mask = pw_invert_mask(mask)

%{
This function inverts a NAN logic mask
%}


mask(isnan(mask)) = 0;
mask = (~mask);
mask = double(mask);
mask(mask <= 0) = NaN;
inverted_mask = mask;
end











