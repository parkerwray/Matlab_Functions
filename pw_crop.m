function [image, rect2] = pw_crop(I, rect)

%{ 
This function crops an image. If you have a crop mask, then the code uses
the user specified mask. If you do not, the code allows you to dynamically
draw a crop mask. 

Input: Image, crop mask (optional)
Output: Cropped image, crop mask (optional)
%}

exist rect;

if ans    
    image = imcrop(I,rect);
    rect2 = rect;
else
    [image, rect2] = imcrop(I);
end

end













