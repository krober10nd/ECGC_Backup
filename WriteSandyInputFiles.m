%% Write the cold start Sandy input files.  
DT        = 1.50 ;                   % goal timestep
TS        = '05-Oct-2012 00:00' ; % start time of simulation
TE        = '25-Oct-2012 00:00' ; % end time of simulation
TPXO      = 'tpxo9_netcdf/h_tpxo9.v1.nc'; 
CONST     = 'major8' ; 

m = Make_f15( m, TS, TE, DT, 'tidal_database', TPXO, 'const', {CONST} ) ; 

m.f15.rnday    = 20; 
m.f15.nscreen = 4320; 
m.f15.dramp   = 12;
m.f15.nramp   = 1; 
m.f15.ntip    = 2; 
m.f15.nhstar  = 5;
m.f15.nhsinc  = 1152000;

write( m ,'COLDSTART_SANDY','15') ;

%%  Write the hot start Sandy input files. 
m.f15 = []; 
DT= 5;
TS= '05-Oct-2012 00:00' ;
TE= '01-Nov-2012 00:00'; 
TPXO      = 'tpxo9_netcdf/h_tpxo9.v1.nc'; 
CONST     = 'major8' ; 

m = Make_f15( m, TS, TE, DT, 'tidal_database', TPXO, 'const', {CONST} ) ; 
m.f15.ihot    = 367; 
m.f15.im      = 511112; 
m.f15.nws     = -12; 
m.f15.nstam    = 0; 

m.f15.wtiminc = 900;   
m.f15.rnday   = 27; 
m.f15.ntip    = 2; 
m.f15.dramp   = 0.5; 
m.f15.nramp   = 1; 
m.f15.ntip    = 2; 
m.f15.outge  = [5 20.50 28 72]; 
m.f15.outgw  = 0; 
write( m ,'HOTSTART_SANDY','15') ;


