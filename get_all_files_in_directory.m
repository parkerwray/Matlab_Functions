
function [filepath, filename, parentdirectory] = get_all_files_in_directory(filetype)

parentdirectory = uigetdir;
parentlisting = dir(parentdirectory);
idx3 = 1;
for idx = 1:length(parentlisting)
    if min(parentlisting(idx).name ~= '.')
        % if name has a type (e.g., '.something'), then it is not a folder.
        % The if statement assigns a logic to every character in the name
        % string.
        childdirectory = [parentdirectory,'\',parentlisting(idx).name];
        childlisting = dir(childdirectory);
        for idx2 = 1:length(childlisting)
            if childlisting(idx2).isdir == 0 && strfind(childlisting(idx2).name,filetype)>0
            filepath{idx3} = [childdirectory,'\',childlisting(idx2).name];
            filename{idx3} = childlisting(idx2).name;
            idx3 = idx3+1;
            end
        end
    end
end






















