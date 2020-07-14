function [P1,f] = pw_fft(X,Fs,loud)


L = 2^nextpow2(length(X))+10.^6;
Y = fft(X,L);
P2 = abs(Y/L).^2;
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;

if loud == 1
figure,
plot(f(1:end),P1(1:end)) 
title('Single-Sided Spectral Density of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|^2')
end

end









