function [out_data] = correct_jitter_v4(data, search_region, fixed_delay, chunk_size)
    impulse_interp_factor = 8;
    if nargin < 2
        % default search region
        search_region = [1, 800];
    end
    if nargin < 3
        fixed_delay = 190;
    end
    if nargin <4
        % number of frames to form a chunk
        chunk_size = 3;
    end
    HALF_RANGE = 50;
    template_set = false;
    out_data = zeros(size(data));
    h = waitbar(0, 'Correcting jitter...');
    for ci = 1:chunk_size:size(data, 3)
        frame_range = ci : min(size(data, 3), ci+chunk_size-1);
        temp_data = data(:, :, frame_range);

        if ~template_set
            template_peak_ind = find_template_delay ...
                (mean(temp_data(search_region(1):search_region(2),1:128,1), 2));
            original_start = search_region(1) - 1;
            search_region(1) = max(1, original_start + template_peak_ind - HALF_RANGE + 1);
            search_region(2) = original_start + template_peak_ind + HALF_RANGE;
            template_peak_ind = HALF_RANGE;
            [temp_data, init_template] = correct_jitter_cuda ...
                (temp_data, search_region(1)-1, ...
                 search_region(2)-search_region(1)+1, ...
                 impulse_interp_factor, template_peak_ind, ...
                 fixed_delay-search_region(1)+1);
            template_set = true;
        else
            [temp_data] = correct_jitter_cuda ...
                (temp_data, search_region(1)-1, ...
                 search_region(2)-search_region(1)+1, ...
                 impulse_interp_factor, template_peak_ind, ...
                 fixed_delay-search_region(1)+1, init_template);
        end
        out_data(:, :, frame_range) = temp_data;
        waitbar(ci/size(data, 3), h);
    end
    close(h);
end

function delay = find_template_delay(template)
    PEAK_THRESHOLD = 0.5;
    y = template;
    y(y<0.0) = 0.0;
    [~, locs] = findpeaks(y, 'MinPeakHeight', PEAK_THRESHOLD * max(y));
    delay = locs(1);
end
