
function [File, FileName, PathName] = get_file(file_location)

%{
This function is used to grab files from a folder. If multiple files is
selected, the output is an array of all selected files.
Input: initial file location (as a string) or nothing.
Output: complete file path, file name, path name
%}

exist file_location var;

if ans
    [FileName,PathName] = uigetfile(file_location, 'MultiSelect','on');
    File = fullfile(PathName,FileName);
else
    [FileName,PathName] = uigetfile('MultiSelect','on');
    File = fullfile(PathName,FileName);
end


end














