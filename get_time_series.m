function [series, mask] = get_time_series(mov, loud)

[dummy, mask] = get_mask(mov);
[series] = get_average_time_series(dummy);

if loud == 1
    figure, 
    plot(series)
    xlabel('Frames')
    ylabel('Series')
end


end













































