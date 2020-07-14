function mat = pw_read_refinfo_mat(name, file,loud)
%'Z:\Project - Dusty Plasma MURI\Material Data\IR Refractive Index
%Data\Ag.csv'

test = readmatrix(file);
idx = find(isnan(test));
if isempty(idx)
    lda = test(1:end,1)*10^3;
    n_d =  test(1:end,2);
    k_d = zeros(length(lda),1);    
else
    lda = test(1:idx(1)-1,1)*10^3;
    n_d =  test(1:idx(1)-1,2);
    k_d = test(idx(1)+1:end, 2);
end
[lda,idx] = unique(lda);
n = n_d(idx);
k = k_d(idx); 

m = n+1i.*k;

e1 = n.^2-k.^2;
e2 = 2.*n.*k;
e = e1+1i.*e2;


ev = 1239.84193./lda;

mat = struct('name',name,...
             'lda',lda,...
             'm',m,...
             'n',n,...
             'k',k,...
             'ev',ev,...
             'e',e,...
             'e1',e1,...
             'e2',e2);

if loud
   disp(name);
   disp(['Wavelength range ',num2str(min(lda)), '-',num2str(max(lda)),'nm']);
end
               
         
end







