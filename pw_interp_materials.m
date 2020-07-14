function [n, k, m] = pw_interp_materials(n0,k0,lda0,lda, loud)

% lda_min = max([300,min(lda0),min(lda0)]);
% lda_max = min([2000,max(lda_Material_1),max(lda_Material_2)]);

% Interpolate material data
%lda = lda_min:1:lda_max;
n = smooth(interp1(lda0, n0, lda,'spline'),5);
k = smooth(interp1(lda0, k0, lda,'spline'),5);
k(k<0) = 0;
m = n+1i*k;

if loud
    figure, 
    subplot(2,1,1)
    plot(lda,n)
    xlabel('Wavelength');
    ylabel('n');
    subplot(2,1,2)
    plot(lda,k)
    xlabel('Wavelength');
    ylabel('k');
end

end










