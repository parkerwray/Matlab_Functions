
function hes_image = pw_roi_hes(image, cw, wscales, cb, bscales)



mask = double(roipoly(mat2gray(image)));
image = mat2gray(image)-0.5;

fw = @(x) unipolarFiltering_v2(x, wscales, bscales, cw, zeros(length(bscales)));
fb = @(x) unipolarFiltering_v2(x, wscales, bscales, zeros(length(wscales)), cb);



hes_white = roifilt2(image, mask, fw);
hes_black = roifilt2(image,mask,fb);
hes_image = (hes_white-hes_black).*mask;


end
























