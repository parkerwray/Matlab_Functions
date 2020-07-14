function [mat] = pw_read_wvase_mat(name, file, loud)
fid = fopen(file);
tline = fgetl(fid);
tline = fgetl(fid);
tline = fgetl(fid);
A = fscanf(fid, '%f %f %f\n');
fclose(fid);
A = reshape(A,[3, length(A)/3]);
ev = A(1,:);
e1 = A(2,:);
e2 = A(3,:);
e = e1+1i.*e2;
m = sqrt(e);
n = real(m);
k = imag(m);
lda = 1239.84193./ev;

mat = struct('name',name,...
             'lda',lda,...
             'm',m,...
             'n',n,...
             'k',k,...
             'ev',ev.',...
             'e',e.',...
             'e1',e1.',...
             'e2',e2.');
if loud
   disp(name);
   disp(['Wavelength range ',num2str(min(lda)), '-',num2str(max(lda)),'nm']);
end

end






