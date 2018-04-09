% Example_3_ECGC: Mesh the greater US East Coast and Gulf of Mexico region
addpath(genpath('utilities/'))
addpath(genpath('datasets/'))
addpath(genpath('m_map/'))

 clc; clearvars;


%% STEP 1: set mesh extents and set parameters for mesh
min_el    = 60;  		% minimum resolution in meters.
% for block 8 & 9, we use 1 km nearhosre (for non-US waters) 
%min_el    = 1e3; 
max_el_ns = 250; 
% for block 8 & 9, we use  5 km max nearhosre (for non-US waters) 
%max_el_ns = 5e3; 

max_el    = [4e3  0 -250        % 4 km max ele on the shelf
             12e3 0 -inf]; 		% 12 km global max ele. 
         
wl        = [100 0 -inf         % global wavelength of 100 elements per M2.
             NaN 0 -50];        % turn wavelength from 0 to -50 m.
         
slp       = 15; 
ch        = 10; 
grade     = 0.15; 		% mesh grade in decimal percent.
r         = 2;          % feature size
dt        = 3; 
efres     = 90;
%% STEP 2: specify geographical datasets and process the geographical data 
%% to be used later with other OceanMesh classes...

% for block 8 & 9 we use GSHHS
coastline = 'combined4.shp';
demfile   = 'combined4.nc';

for block = 6 : 10
if block == 0 
   bbox = [-72 -60.5; 
            41.75 46];  
elseif block == 1 
    bbox = [-78 -60.5 
             36.75 42 ]; 
elseif block == 2 
    bbox = [-82.3  -60.5
             31.75 37.0]; 
elseif block == 3
    %bbox = [-82.3 -60.5 
    %         26.7500 32]; 
    bbox = [-82.3 -60.5
             28.000 32];
elseif block == 4 
    %bbox = [-82.3 -79.1 
    %         24.0  27];
    bbox = [-82.3 -79.4
             24.0  28.25];
elseif block == 5 
    bbox = [-87  -82.0 
             24.0  31]; 
elseif block == 6
    bbox = [-92  -86.75 
            24.0  31 ];
elseif block == 7 
    bbox = [-98  -91.75
             24   30.5];
elseif block == 8
    % Puerto Rico
    bbox = [-67.50 -65.15
             17.60  18.60];

elseif block == 9 
    bbox = [-98  -60.5
             5    24.25];
    min_el = 1e3; 
    max_el_ns = 5e3; 
    coastline = 'GSHHS_f_L1.shp'; 
    efres     = 1e3; 

elseif block == 10
    %bbox = [-79.2 -60.5 
    %         23.9  27.1];
    bbox = [-79.6 -60.5
             23.9  28.25];
    min_el = 1e3;
    max_el_ns = 5e3; 
    coastline = 'GSHHS_f_L1.shp'; 
    efres     = 1e3; 
end
gdat = geodata('shp',coastline,...
               'dem',demfile,...
               'bbox',bbox,...
               'h0',min_el);
% NOTE: You can plot the dem with shapefile and bounding box by using the 
% overloaded plot command:
%plot(gdat,'dem'); 

%% STEP 3: create an edge function class
fh = edgefx('geodata',gdat,...
            'fs',r,...
            'max_el_ns',max_el_ns,...
            'slp',slp,...
            'fl',-1,...
            'wl',wl,...
            'ch',ch,...
            'max_el',max_el,...
            'g',grade,...
            'dt',dt,...
            'h0',efres);

%% STEP 4: Pass your edgefx class object along with some meshing options and
% build the mesh...
msh = meshgen('h0',min_el,'bbox',bbox,'ef',fh,...
              'bou',gdat,'nscreen',5,'plot_on',1,'itmax',100,'dj_cutoff',0.001);
% now build the mesh with your options and the edge function.
msh = msh.build; 

%% STEP 5: Plot it and write a triangulation fort.14 compliant file to disk.
fname = ['ECGC_BASE_',num2str(bbox(1)),'_',num2str(bbox(1,2)),'_',num2str(bbox(2,1)),'_',num2str(bbox(2,2))]
write(msh.grd,fname);

end
