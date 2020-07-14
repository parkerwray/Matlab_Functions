function [PAraw,PAchannel] = getPAdata(DAQseq,first_experiment,last_experiment)
%% DEFINE PHYSICAL VARIABLES
halftime_reconstruction = 1; %flag
transducer_radius = 50; %mm
transducer_center_frequency = 12; %MHz
transducer_cutoff_frequency = 15; %MHz
DAQ_sample_frequency = 80; %MHz
speed_of_sound = 1.523; % mm/us = mm*MHz
optical_wavelength = 488; %nm
optical_pulse_rep_rate = 10; %hz
acoustic_wavelength_cutoff = speed_of_sound./transducer_cutoff_frequency; %Acoustic cutoff wavelength in mm
acoustic_wavelength_center = speed_of_sound./transducer_center_frequency; %Acoustic center wavelength in mm
theoretical_resolution = 0.8*acoustic_wavelength_cutoff; %resolution in mm
theoretical_z_resolution = 6; %resolution in mm
image_angle = 275; %Angle of the image in degrees

%% DEFINE STRUCTURES TO SAVE DATA
u = struct('cm', 10^(-2),'mm', 10^(-3), 'um', 10^(-6), 'nm', 10^(-9),...
    'MHz', 10^6, ...
    'ms', 10^(-3), 'us', 10^(-6), 'ns', 10^(-9));

f = struct('data',[],...
    'raw', [],...
    'hes',[],...
    'I', [],...
    'Fi', [],...
    'x', 0,...
    'y', 0,...
    'Lx', 90,...
    'Ly', 90,...
    'dx', theoretical_resolution,...
    'dy', theoretical_resolution,...
    'Lkx',1./theoretical_resolution,...
    'Lky',1./theoretical_resolution,...  
    'dkx',1./(90),...  %X K-Space Resolution
    'dky',1./(90),...  %Y K-Space Resolution
    'izi',1,...
    'izf',1,...
    'ires',1,...
    'icords',[],...
    'isize', [],... %Size of Image
    'icent', [],... %Center of Image
    'ihv',[],...   %Weighting Factors of Processed Images
    'ihw',[],...  %Weighting Factors of Hessian Filtered Images
    'mask',[],...
    'fcen', transducer_center_frequency,...
    'fcut', transducer_cutoff_frequency,...
    'fs', DAQ_sample_frequency,...
    'res', theoretical_resolution,... 
    'zres', theoretical_z_resolution,...
    'sos', speed_of_sound,...
    'olda', optical_wavelength,...
    'alda', acoustic_wavelength_center,...
    'dalda', acoustic_wavelength_cutoff-acoustic_wavelength_center,...
    'r', transducer_radius,...
    'halftime', halftime_reconstruction,...
    'halftime_overlap', [],...
    'file', [],...
    'fileim',['data2recon.mat'],...
    'filename','you_forgot',...
    'daq',[],...
    'ang', image_angle,...
    'speed', 0,...
    'distance', [],...
    'notes',[],...
    'interp', 1,...
    'angle_weight',1);



%% DEFINE SPEED OF SOUND
prompt = {'Speed of Sound? [mm/us]'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {num2str(f.sos)};
ans = inputdlg(prompt,dlg_title,num_lines,defaultans);
ans = str2num(ans{:}); 
f.sos = ans;


% 


%% DEFINE IMAGE SIZE
prompt = {'Size of Image? [mm] (Default is Transducer Radius)'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {num2str(f.r)};
ans = inputdlg(prompt,dlg_title,num_lines,defaultans);
ans = str2num(ans{:}); 
f.Dx = ans; %2*f.r; % Define how large horizontal image is, in mm
f.Dy = ans; %2*f.r; % Define how large verticle image is, in mm
f.x = f.Dx/2; 
f.y = f.Dy/2; 

%% DEFINE X-Y IMAGE RESOLUTION
prompt = {'x-y Resolution? [% * mm] (fraction of system resolution)'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {num2str(0.5)};
ans = inputdlg(prompt,dlg_title,num_lines,defaultans);
ans = str2num(ans{:}); 
f.dx = ans.*f.res; % Define the resolution of each pixel, in mm
f.dy = f.dx;

%% ANGLE WEIGHT RECONSTRUCTION TO REDUCE STREAK ARTIFACTS
prompt = {'Angle weight in reconstruction? [angle^weight]'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {num2str(1)};
ans = inputdlg(prompt,dlg_title,num_lines,defaultans);
ans = str2num(ans{:}); 
f.angle_weight = ans;


%% INTERPOLATE ELEMENT DATA TO INCRESE FIELD OF VIEW
prompt = {'Interpolate X-Y data by # times? [# * elements]'};
dlg_title = 'Input';
num_lines = 1;

defaultans = {num2str(1)};
ans = inputdlg(prompt,dlg_title,num_lines,defaultans);
ans = str2num(ans{:}); 
f.interp = ans;


%clear data xq yq zq

%% LOOP TO RECONSTRUCT ALL EXPERIMENTS

    
    h = waitbar(0,'Reading and Reconstructing PACT Files');
     for i = first_experiment:last_experiment
            filepath = uigetdir; %grab first file
            f.file = strcat(filepath,'\'); 
            f.daq = DAQseq; %char('No 2','No 0','No 1','No 3');
          
            f = PA_Movie_Collect_Data(f);
            
            %Interpolate For Better Resolution
            [xq,yq,zq]=meshgrid(1:(1./f.interp):size(f.data,2),1:1:size(f.data,1),1:1:size(f.data,3));
            data = interp3(f.data,xq,yq,zq);
            f.data = data;
            PAchannel(:,:,:,i) = f.data;
            
            %% DEFINE HALFTIME RECONSTRUCTION
%                 x = inputdlg('Halftime Reconstruction? [1/0]');
%                 f.halftime  = str2num(x{:}); 
%                 halftime = f.halftime;
%                 if halftime  
%                 % For breast system, the Radius is 110 mm, which corresponds to 3000 points after laser, at 40MHz
%                     half = ceil((f.fs./f.sos).*f.r);
%                     prompt = {'Percent Overlap? [%]'};
%                     dlg_title = 'Input';
%                     num_lines = 1;
%                     defaultans = {num2str(2)};
%                     ans = inputdlg(prompt,dlg_title,num_lines,defaultans);
%                     ans = str2num(ans{:})./100; 
%                     overlap = (ans.*half);
%                     f.data(round(half+overlap):end,:,:)= []; 
%                 end
%                 f.halftime = half;
%                 f.halftime_overlap = overlap;
%                 keyboard
%                 clear half overlap
            f.data(3000:end,:,:)= []; 
            f.data(1:900,:,:) = 0;
            %f.data = mean(f.data,3);
            frames = size(f.data,3); 
            
            f = Reconstruction_2D_UsingFStruct(f);
            PAraw(:,:,:,i) = f.I;
       
     end
delete(h);
 end
%f.icords = imref2d(f.isize,[-f.x,f.x],[-f.y,f.y]);
%save(strcat(f.file,'_init'),'-v7.3')
%end


























































