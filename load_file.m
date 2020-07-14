function data = load_file(file)
   
    for idx = 1:length(file)
        %load(file{idx})
        data{idx} = importdata(file{idx});
    end
    
end











