function data =  pw_import(File)

%{ 
This function is meant to be used with get_file. 

The function imports the data from File, thich is the path to the file you
want to grab data from. If File contains multiple paths (as a cell array),
then the data will also be a cell array. 

Input: File = file path + file name + .file type
Output: data from file(s) as a cell array
%}

for idx = 1:length(File)
    data{idx} = importdata(File{idx});
end

end














