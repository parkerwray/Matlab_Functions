%% General Experiment Inputs


%% DEFINE EXPERIMENT VARIABLES
frames = 128; 
ton = 5; %sec
toff = 10; %sec
pulse_width = 3*10^(-3); %sec
freq = 10; %frames/sec (Determined by laser rep. rate)
stimulations = 11;
number_of_experiments = 9;
wavelength = 488; %nm






%% COLLECT PHOTODIODE DATA
%{
The code assumes a standard file format where the experiments are labled 1.dat, 2.dat,...
The code loads the photodiode (PD) data for each experiment and saves it into a 2D matrix 
dim-1 = time series data for each experiment. dim-2 = experiment number.
The data also searches and saves only the peak values in the variable PDpks. 
The peak values are determined by the user input samples_per_pulse. 
Once the data is collected, the units are initially meaningless. 
To convert to meaningful units, you need the user input for the mean value of
the energy per pulse. You then normalize the mean of the data to this mean value. 

NOTE: The values of the peaks from the rawPDdata and the PDpks data are the
same. This verifies the code getPDdata works!

%}
clearvars PDraw PDpks PDmean PDstd Measured_mean_pulse_energy convert_true

%USER INPUT
samples_per_pulse = 50;

mean_pulse_energy = 9; %mJ
[~,pathname] = uigetfile; %grab first file
filepath = pathname;

for i = 1:number_of_experiments
    %file = strcat(filepath,'\', num2str(i),'.dat'); % Itterate through esperiment files
    file = strcat(filepath,'\', '5','.dat'); % Itterate through esperiment files
    [dummy1,dummy2] = getPDdata(file, samples_per_pulse); % Get experimental data
    dummy1 = dummy1(1:(frames)*samples_per_pulse); % only keep data collected during experiment time
    dummy2 = dummy2(10:frames); % only collect peaks during experiment time (PACT/CCD ON time)
    %dummy2 = dummy2(10:frames);
    %dummy2(1)  = 2*dummy2(1); % 1st peak is always artificially half (unknown reason). If first pulse isn't used, no need to scale.
    PDraw(:,i) = dummy1;
    PDpks(:,i) = dummy2;
end
clearvars dummy1 dummy2

Measured_mean_pulse_energy = mean(PDpks(:));
convert_true = mean_pulse_energy./Measured_mean_pulse_energy;


PDpks = PDpks.*convert_true;
PDmean = mean(PDpks(:));
PDstd = std(PDpks(:));



%% COLLECT CCD DATA
%{
The code assumes a standard file format where the experiments are labled 1.dat, 2.dat,...
The code also assumes the CCD data is in units of photons and excitation
pulses are of a single wavelength, which you know.

The code loads the CCD data for each experiment and saves it into a 4D matrix 
dim-1&2 = image dimensions, dim-3 = time series, dim-4 = experiments. 

Images then need to be corrected based on flucuations in pulse energy. This
is done using the PDdata to scale all pixels in an image by a const.

The CCD shutter opens 184us before the laser pulse and stays on for
appriximately ~600us (Note: the CCD is programed for 800us exposure). The
PD recieves the trigger to begin sampling 6us before the laser pulse. There
is then a 5us internal delay from the myRIO ADC. This means the PD sampling
occurs ~1us before the pulse. 

Since the CCD shutter opens so early before the pulse, te would expect the
first pulse is missed. Therefore, the first recorded pulse should be
truncated from the PD data. BUT running cross-correlations in a control
experiment shows not skipping a pulse results in more correlated signals
between CCD data and PD data. Therefore, no pulse shift is used.

More work needs to be done to determine true synching of the same pulse. 

Based on the equation for fluorescence, we can determine how to normalize
the CCD data. 

F = ln(10)*molar_extinction*concentration*const*I0
Where const = quantum_efficiency*detector_efficiency...

Therefore, the normalization is F/I0. Where F is the fluorescent signal (in
mJ) and I0 is the pulse power (in mJ). Thus, we need to convert the CCD
signal to units of energy (mJ)!
%}

%% Define CCD variables
clearvars CCDraw CCDmin CCDpks CCDpks_detrend
gain = 0;
image_size = 212;
data_type = 'int16';
first_experiment = 1; % Start File Counter 
last_experiment = number_of_experiments; %Last File Counter (n>j)  

down_sample = 1;
accums = 1; %number of added frames in Andor
delay = 0; % [0/1] use 1 if shutter was used as 'auto'

h = 6.62607040*10^(-34)*(10^3); % mJ*s
c = (3*10^8)*10^9; %nm/s
E = h*c./wavelength; %mJ
out_band_correction = 10^(7)*10^(7);
in_band_correction = 10^(0.3);
counts_to_mJ_488nm = 2.6*10^(-9);

[~,filepath] = uigetfile; %grab first file
h = waitbar(0,'Reading CCD Files');
 for i = first_experiment:last_experiment
     %file = strcat(filepath, num2str(i),'.dat'); % Itterate through esperiment files
      file = strcat(filepath, '5','.dat');
     % Get Data From New Experiment
     dummy = getCCDdata(file, frames, image_size, data_type);
     % Save downsampled version of each experiment
     CCDraw(:,:,:,i) = E*out_band_correction*imresize(dummy(:,:,10:end),[image_size/down_sample,image_size/down_sample]);
     CCDmin(:,i) = min(min(CCDraw(:,:,:,i),[],1),[],2);
     CCDpks(:,i) = mean(mean(CCDraw(:,:,:,i),1),2);
     CCDpks_detrend(:,i) = detrend(CCDpks(:,i),2);
     waitbar(i / last_experiment)
 end
close(h)


%% COLLECT PA DATA

%{
%}
DAQseq = char('No 1','No 3','No 0','No 2');
%number_of_experiments
[PAraw,PAchannel] = getPAdata(DAQseq,1,1); 

%% CCD AND PD CORRELATION ANALYSIS


series_correlation(PDpks(:), CCDpks(:));
title('Zero-Normalized Cross-Correlation')
matrix_correlation(PDpks(:), CCDpks(:));
labels = {'CCD','PD'};
%labels = {'CCD 1','CCD 2','CCD 3','CCD 4','CCD 5','PD 1','PD 2','PD 3','PD 4','PD 5'};
%labels = {'CCD 1','CCD 2','CCD 3','CCD 4','CCD 5','CCD 6','CCD 7','CCD 8','CCD 9','CCD 10','PD 1','PD 2','PD 3','PD 4','PD 5','PD 6','PD 7','PD 8','PD 9','PD 10'};
set(gca,'XTickLabel',labels);   % gca gets the current axis
set(gca,'YTickLabel',labels);   % gca gets the current axis
title('Correlation between CCD mean and PD')




%% Plot CCD/PD CCD and PD data
CCDcorrect = PDpks(:)./CCDpks(:);%CCDpks(:)./PDpks(:);
%dummy1 = (CCDcorrect-min(CCDcorrect))/(max(CCDcorrect)-min(CCDcorrect))-0.5;
%dummy2 = (CCDpks_detrend(:)-min(CCDpks_detrend(:)))/(max(CCDpks_detrend(:))-min(CCDpks_detrend(:)))-0.5;
dummy1 = mat2gray(CCDcorrect);
dummy2 = mat2gray(CCDmin(:));
dummy3 = mat2gray(PDpks(:));

figure,
subplot(2,3,1)
plot(dummy1(:))
xlabel('Number of Pulses')
ylabel('Energy per Pulse')
title('CCD/PD')
legend(strcat('sigma/mu = ', num2str(std(dummy1)./abs(mean(dummy1))))) 

subplot(2,3,2)
plot(dummy2(:))
xlabel('Number of Pulses')
ylabel('Energy per Pulse')
title('CCD')
legend(strcat('sigma/mu = ', num2str(std(dummy2)./abs(mean(dummy2))))) 

subplot(2,3,3)
plot(dummy3)
xlabel('Number of Pulses')
ylabel('Energy per Pulse')
title('PD')
legend(strcat('sigma/mu = ', num2str(std(dummy3)./abs(mean(dummy3))))) 

subplot(2,3,4)
histogram(dummy1(:))
ylabel('Number of Pulses')
xlabel('Energy per Pulse')
legend(strcat('sigma = ', num2str(std(dummy1(:))))) 

subplot(2,3,5)
histogram(dummy2(:))
ylabel('Number of Pulses')
xlabel('Energy per Pulse')
legend(strcat('sigma = ', num2str(std(dummy2(:))))) 

subplot(2,3,6)
histogram(dummy3)
ylabel('Number of Pulses')
xlabel('Energy per Pulse')
legend(strcat('sigma = ', num2str(std(dummy3)))) 

%% Plot PD Data
figure,
subplot(4,1,1)
plot(PDpks(:))
xlabel('Number of Pulses')
ylabel('Energy per Pulse')
title('Photodiode Response')
legend(strcat('sigma/mu = ', num2str(std(PDpks(:))./abs(mean(PDpks(:)))))) 

subplot(4,1,2)
histogram(PDpks(:))
ylabel('Number of Pulses')
xlabel('Energy per Pulse')
legend(strcat('sigma= ', num2str(std(PDpks(:)))))

subplot(4,1,3)
histogram(100.*((PDpks(:)./PDmean)-1))
ylabel('Number of Pulses')
xlabel('%\Delta from \mu')

subplot(4,1,4)
histogram(diff(PDpks(:)))
ylabel('Number of Pulses')
xlabel('\DeltaE Between Consecutive Pulses')

% subplot(3,1,1)
% plot(diff(PDpks(:)))
% xlabel('Number of Pulses')
% ylabel('\DeltaE Between Consecutive Pulses')

%% Plot CCD Data
figure,
subplot(4,1,1)
plot(CCDpks(:))
xlabel('Number of Pulses')
ylabel('Energy per Pulse')
title('CCD Image Mean Response')
legend(strcat('sigma/mu = ', num2str(std(CCDpks(:))./abs(mean(CCDpks(:))))))

subplot(4,1,2)
histogram(CCDpks(:))
ylabel('Number of Pulses')
xlabel('Energy per Pulse')
legend(strcat('sigma = ', num2str(std(CCDpks(:)))))

subplot(4,1,3)
plot(diff(CCDpks(:)))
xlabel('Number of Pulses')
ylabel('\DeltaE Between Consecutive Pulses')

subplot(4,1,4)
histogram(diff(CCDpks(:)))
ylabel('Number of Pulses')
xlabel('\DeltaE Between Consecutive Pulses')

figure,
subplot(4,1,1)
plot(CCDpks_detrend(:))
xlabel('Number of Pulses')
ylabel('Energy per Pulse')

subplot(4,1,2)
histogram(CCDpks_detrend(:))
ylabel('Number of Pulses')
xlabel('Energy per Pulse')

subplot(4,1,3)
plot(diff(CCDpks_detrend(:)))
xlabel('Number of Pulses')
ylabel('\DeltaE Between Consecutive Pulses')

subplot(4,1,4)
histogram(diff(CCDpks_detrend(:)))
ylabel('Number of Pulses')
xlabel('\DeltaE Between Consecutive Pulses')


































%% CCD Correlation Analysis

figure,
% Plot Photobleacing Rates
for i = first_experiment:last_experiment
    plot(squeeze(mean(mean(experiment(:,:,:,i),1),2)))
    hold on
end
    xlabel('frames')
    ylabel('counts/photons')
    
    
    
%% Remove photobleaching from each experiment
figure,
dummy  = squeeze(mean(mean(experiment(:,:,:,5),1),2));
dummy_filt = smooth(dummy,frames);
t = 1:frames;
[poly2_fit, poly2_goodness] = fit(t',dummy_filt,'poly2');
plot(dummy)
hold on
plot(dummy_filt)
plot(poly2_fit,'g')
hold off










%% Correlation Analysis 



%%


for i = 1:10
    CCDnorm(:,i) = CCDpks(:,i)./PDpks(:,i);
end


% plotcorrelation(corrcoef(PDpks)) %NOTE: no change occurs from removing the mean
% title('Correlation between PD recordings vs. Experiment')
% 
% plotcorrelation(corrcoef(CCDpks_detrend)) % Must use detrended data or everything is strongly correlated because all have photobleach curve!
% title('Correlation between detrended CCD mean recordings vs. Experiment')
% figure,
% for i = 1:5
%     plot(-(frames-1):(frames-1),xcorr(CCDpks_detrend(:,1), PDpks(:,i)-mean(PDpks(:,i)),'coeff'))
%     hold on
% end
% title('correlation between CCD exp1 and PD experiments')
% 
% figure,
% for i = 1:5
%     plot(-(frames-1):(frames-1),xcorr(CCDpks_detrend(:,1), CCDpks_detrend(:,i),'coeff'))
%     hold on
% end
% title('correlation between CCD exp1 and PD experiments')



%%
CCDcorrect = CCDpks(:)./PDpks(:);
%dummy1 = (CCDcorrect-min(CCDcorrect))/(max(CCDcorrect)-min(CCDcorrect))-0.5;
%dummy2 = (CCDpks_detrend(:)-min(CCDpks_detrend(:)))/(max(CCDpks_detrend(:))-min(CCDpks_detrend(:)))-0.5;
dummy1 = CCDcorrect;
dummy2 = CCDpks(:);
figure,
subplot(3,2,1)
plot(dummy1(:))
xlabel('Number of Pulses')
ylabel('Energy per Pulse')
title('CCD/PD')
legend(strcat('sigma/mu = ', num2str(std(dummy1)./abs(mean(dummy1))))) 
subplot(3,2,2)
plot(dummy2(:))
xlabel('Number of Pulses')
ylabel('Energy per Pulse')
title('CCD')
legend(strcat('sigma/mu = ', num2str(std(dummy2)./abs(mean(dummy2))))) 
subplot(3,2,3)
histogram(dummy1(:))
ylabel('Number of Pulses')
xlabel('Energy per Pulse')
legend(strcat('sigma = ', num2str(std(dummy1(:))))) 
subplot(3,2,4)
histogram(dummy2(:))
ylabel('Number of Pulses')
xlabel('Energy per Pulse')
legend(strcat('sigma = ', num2str(std(dummy2(:))))) 
subplot(3,2,5)
histogram(diff(dummy1(:)))
ylabel('Number of Pulses')
xlabel('\DeltaE Between Consecutive Pulses')
legend(strcat('sigma = ', num2str(std(diff(dummy1(:)))))) 
subplot(3,2,6)
histogram(diff(dummy2(:)))
ylabel('Number of Pulses')
xlabel('\DeltaE Between Consecutive Pulses')
legend(strcat('sigma = ', num2str(std(diff(dummy2(:)))))) 






