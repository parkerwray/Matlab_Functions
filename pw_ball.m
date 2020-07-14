function circlePixels = pw_ball(res)


imageSizeX = res;
imageSizeY = res;
imageSizeZ = res;
[columnsInImage, rowsInImage, zImage] = meshgrid(1:imageSizeX, 1:imageSizeY, 1:imageSizeZ);
% Next create the circle in the image.
centerX = round(imageSizeX./2)+1;
centerY = round(imageSizeY./2)+1;
centerZ = round(imageSizeZ./2)+1;
radius = round(imageSizeY./2)-1;
circlePixels = (rowsInImage - centerY).^2 ...
    + (columnsInImage - centerX).^2 ...
    + (zImage - centerZ).^2 <= radius.^2;

end








