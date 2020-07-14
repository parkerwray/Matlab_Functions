
function Xeff = pw_MG(Xb, Xn, w, type, loud)

%{ 
This function calculates the Maxwell Garnett effective index based on N
inclusions

Xn is a matrix of the different inclusions
wavelength x number of inclusions (complex double)

w is a column vector of weights
[w1;w2;w3;...]


%}


Xb = repmat(Xb,[1,size(Xn,2)]);
if type == 0
    'Material properties are m = n+ik: Converting to e = m^2'
    eb = Xb.^2;
    en = Xn.^2;
end
if type == 1
    'Material is in terms of epsilon'
    eb = Xb;
    en = Xn;
end
Anum = (en-eb);
Adenom = (en+2.*eb);

if sum(Adenom == 0)
    'Denominator is 0!'
    keyboard;
end
A = Anum./Adenom;
B = A*w;
enum = (1+2.*B);
edenom = (1-B);

if sum(edenom == 0)
    'Denominator is 0!'
    keyboard;
end

e = eb(:,1).*enum./edenom;

if type == 0 
    'Converting meff = sqrt(eff)'
    Xeff = sqrt(e);
end
if type == 1
    Xeff = e;
end


if loud
    figure, 
    subplot(2,1,1)
    plot(real(Xn))
    xlabel('count');
    ylabel('Inclusion Real Index(s)');
    subplot(2,1,2)
    plot(imag(Xn))
    xlabel('count');
    ylabel('Inclusion Imag Index(s)');
    
    figure, 
    subplot(2,1,1)
    plot(real(Xeff))
    xlabel('count');
    ylabel('Eff Real Index(s)');
    subplot(2,1,2)
    plot(imag(Xeff))
    xlabel('count');
    ylabel('Eff Imag Index(s)');

end
    
    




end















