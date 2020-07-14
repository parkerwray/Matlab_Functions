
function Xeff = pw_Bruggeman2(X1, X2, w, type)

if type == 0
    'Material properties are m = n+ik: Converting to e = m^2'
    e1 = X1.^2;
    e2 = X2.^2;
end
if type == 1
    'Material is in terms of epsilon'
end

w1 = w;
w2 = 1-w;
B =  (3.*w1-1).*e1+(3.*w2-1).*e2;
e = 0.25.*(B+sqrt(B^2+8.*e1.*e2);

if type == 0 
    'Converting meff = sqrt(eff)'
    Xeff = sqrt(e);
end
if type == 1
    Xeff = e;
end

end





























