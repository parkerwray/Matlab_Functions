function [fmask, dummy] = get_mask(dummy)

%{
Make a mask user specified NaN mask. 

Input: image (dummy)
Output: mask, masked image
%}

%%
L = length(squeeze(dummy(1,1,:)));
flag = 1;
flag2 = 0;
if squeeze(length(dummy(1,1,:))) == 1
    dim = dummy(:,:,1);
else
    dim = dummy(:,:,10);
end
dim2 = dim;
fmask = zeros(size(dim));
figure,
while flag == 1
    if flag2 ==0
    imshow(dim,[1.*min(dim(:)) 1.*max(dim(:))]), m = impoly();
    nmask = double(createMask(m));
    end
fmask = nmask; % 1.*imgaussfilt((1.*nmask),20);
dim = dim2.*(fmask);
imshow(dim,[]);
flag = inputdlg('Redo? [1/0]');
flag = str2num(flag{:}); 
if flag == 0
    break;
end

end
fmask(fmask == 0) = NaN;
for i = 1:L
    dummy(:,:,i) = dummy(:,:,i).*fmask;
end

end