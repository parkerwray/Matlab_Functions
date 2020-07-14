function pw_mov(dummy,scale,rate)
%{ 
Make a movie from a 3D matrix (X,Y, Time)
%}

exist rate;
if ans
else
    rate = 10;
end
exist scale;
if ans 
else 
    scale = 1;
end
dummy(isnan(dummy)) = 0;
implay(mat2gray(dummy,[scale.*min(dummy(:))  scale.*max(dummy(:))]),rate)

end



