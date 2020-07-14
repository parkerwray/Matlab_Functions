function y = get_fit(fit, x)

% This function produces a curve from a fit object at specific x values

y = feval(fit,x)';


end


