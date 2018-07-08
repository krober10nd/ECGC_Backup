clearvars; clc; close all;

addpath(genpath('utilities/'))
addpath(genpath('datasets/'))
addpath(genpath('m_map/'))

%% OUTERMOST BOX
bbox = [-100  -60	% lon_min lon_max
           5   46]; % lat_min lat_max
min_el    = 500;  	% Minimum resolution in meters.
max_el    = 10e3;
grade     = 0.25;
R         = 8;
SLP       = 15 ; 
dem       = 'topo15_compressed.nc'; 
coastline = 'GSHHS_f_L1';
gdat{1} = geodata('shp',coastline,...
    'dem',dem,...
    'bbox',bbox,...
    'h0',min_el);

fh{1} = edgefx('geodata',gdat{1},...
    'fs',R,'max_el',max_el,'g',grade,'slp',SLP);

%% Higher resolution boxes around the East Coast
load('bboxes copy2.mat');
min_el    = 50;  	% Minimum resolution in meters.
max_el_ns = 250; 
max_el    = 10e3;
grade     = 0.25;
SLP       = 15; 
R         = 8;
coastline = 'combined4';

tic
for i = 1 : 14
  
    gdat{i+1} = geodata('shp',coastline,...
        'dem',dem,...
        'bbox',bboxes{i},...
        'h0',min_el);
    
    
    fh{i+1} = edgefx('geodata',gdat{i+1},...
        'fs',R,'max_el',max_el,'max_el_ns',250,'g',grade,'slp',SLP);
    
    i
   
end
toc
%%

mshopts = meshgen('ef',fh,'bou',gdat,'itmax',50);
mshopts = mshopts.build;
m = mshopts.grd; 
save -v7.3 Junk m
%%
% put bathy data on it
m = interp(m,'combined4.nc','type','depth'); 
idx = find(m.p(:,1) > -61 & m.p(:,1) < -59); 
m = interp(m,'topo15_compressed.nc','type','depth','K',idx); 
m.b = max(m.b,1); 

% check CFL
m = CheckTimestep(m,2); 
m = renum(m); 

% add boundary conditions 
m = makens(m,'auto',gdat{1}); 

% add some nodal attributes
m = Calc_tau0(m); 
BUOYFILE  = 'Gridded_N_values.mat'; 
m = interp(m,'combined4.nc','type','slope'); 
m = Calc_IT_Fric(m,BUOYFILE,'cutoff_depth',200,'cit',0.175); 
load zones.mat
m = Calc_f13_inpoly(m,'Cf',poly,cfvals); 
%%  configure the control file and write to disk
TS        = '01-Aug-2012 00:00' ; % start time of simulation
TE        = '31-Nov-2012 00:00' ; % end time of simulation
DT        = 2; 
TPXO9     = 'h_tpxo9.v1.nc'; 
CONST     = 'major8' ; 

m = Make_f15( m, TS, TE, DT, 'tidal_database', TPXO9, 'const', {CONST}  ) ; 
m.f15.dramp = 30;                 % ramp period
m.f15.nramp = 1;                  % ramp type
m.f15.outge = [5 10.0 31.0 3600]; % global elevation
m.f15.ntip  =  2;                 % sal + normal tidal potential
m.f15.outhar = [30 120 180 0];    % THAS, THAF, NHAINC, FMV
m.f15.outhar_flag = [0 0 5 5] ;   % NHASE, NHASV, NHAGE, NHAGV

save -v7.3 ECGC_50m_10km_R8_G25_SLP15.mat m 

write(m,'ECGC_50m_10km_R8_G25_SLP15');

FnGlobal_SAL_to_fort24('ECGC_50m_10km_R8_G25_SLP15.24',m,'.','FES2014'); 
