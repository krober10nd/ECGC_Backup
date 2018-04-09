addpath(genpath('utilities/'))
addpath(genpath('datasets/'))
addpath(genpath('m_map/'))

% Post-processing script to take a msh and create all the necessary
% input files for simulation
%%
DT        =  2.0 ;                 % goal timestep
TS        = '01-Aug-2012 00:00' ; % start time of simulation
TE        = '31-Nov-2012 00:00' ; % end time of simulation
%%
DEMFILE   = '/home2/krober10/OceanMesh2D-oop2_v3/OceanMesh2D/combined4.nc'; 
BUOYFILE  = '/home2/krober10/OceanMesh2D-oop2_v3/OceanMesh2D/Gridded_N_values.mat'; 
TPXO9     = '/home2/krober10/OceanMesh2D-oop2_v3/OceanMesh2D/tpxo9_netcdf/h_tpxo9.v1.nc'; 
CONST     = 'major8' ; 
MSHFILE   = 'step1_BASE.14'; 
%%
m  = msh(MSHFILE) ; 

m2 = msh('BouExt.BASE.14'); 
m = m2 + m; 

m = GridData(DEMFILE,m,'type','depth') ; 

m = CheckTimestep(m,DT) ;

m = GridData(DEMFILE,m,'type','slope') ; 

m = renum(m) ;

m = makens(m,'islands') ; 

m = Calc_tau0(m) ; 

m = Calc_IT_Fric(m,'Nfname',BUOYFILE) ; 

load zones 
m = Calc_Cf(m,poly,cfvals);

% boundary of DEM has some problems, use older DEM to replace these values. 
K = find(m.p(:,1) > -60.5 & m.p(:,1) < -59.5); 
m = GridData('/Users/Keith/Desktop/DEM_PRODUCTS/DEM_FILES/combined_wpr.nc',m,'K',K); 

% ensure good conveyance through channels 
m.b = max(m.b,1.0); 

save -v7.3 TempMesh m
% These next two steps are interactive.
%m = makens(m,'outer',1) ; 
%
%m = makens(m,'outer',0) ; 
%
%m = Make_f15( m, TS, TE, 1, 'tidal_database', TPXO9, 'const', {CONST}  ) ; 
%m.f15.dramp = 30;                 % ramp period
%m.f15.nramp = 1;                  % ramp type
%m.f15.outge = [5 10.0 31.0 3600]; % global elevation
%m.f15.ntip  =  2;                 % sal + normal tidal potential
%m.f15.outhar = [30 120 360 0];    % THAS, THAF, NHAINC, FMV
%m.f15.outhar_flag = [0 0 5 5] ;   % NHASE, NHASV, NHAGE, NHAGV

%save TIDES_BASEv8 m
%write( m,'TIDES_BASEv8') ; 


