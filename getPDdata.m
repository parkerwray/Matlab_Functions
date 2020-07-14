function [rawPDdata, PDpks] = getPDdata(file, samples_per_pulse)
fileID = fopen(file,'r'); 
rawPDdata = fread(fileID, 'int16');  %% Previous is double, now it is I16
fclose(fileID); 

tolerance = 0.1.*samples_per_pulse; %samples
PDpks = findpeaks(rawPDdata,'MinPeakDistance',samples_per_pulse-tolerance,'MinPeakHeight',-100);

end
