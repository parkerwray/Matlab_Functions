function matrix = pw_upsample(matrix, resample)

matrix = upsample(matrix,resample);

dims = ndims(matrix);
if dims > 1
    for idx = 1:dims-1
     matrix = upsample(permute(matrix,[2,3,1]),resample);
    end
end
matrix = permute(matrix,[2,3,1]);
end
    





