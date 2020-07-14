function img = getCCDdata(file, frames, image_size, data_type)
 fid = fopen(file);
 %frames = inputdlg('Number of frames?');
 %frames = str2num(frames{:}); 
 dims = [image_size image_size frames];
 v3d = fread(fid, data_type);
 img = reshape(v3d,dims);
end