clearvars; clc; 
%%
fileEle = 'SLPEXP/SLP0.53.nc'; 
fileVel = 'SLPEXP/SLP0.54.nc'; 
const   = 6; 
%%
b = ncread(fileEle,'depth');
amp = ncread(fileEle,'amp');
eamp = amp(const,:)' ;

phs = ncread(fileEle,'phs');
ephs = phs(const,:)' ;

U_AMP = ncread(fileVel,'u_amp');
U_PHS = ncread(fileVel,'u_phs');
V_AMP = ncread(fileVel,'v_amp');
V_PHS = ncread(fileVel,'v_phs');

uamp = U_AMP(const,:)';
vamp = V_AMP(const,:)';
uphs = U_PHS(const,:)';
vphs = V_PHS(const,:)';


[Fx,Fy] = comptide_eflux( b, eamp, ephs, uamp, uphs, vamp, vphs) ;

TotF = hypot(Fx,Fy) ; 

X = ncread(fileEle,'x');
Y = ncread(fileEle,'y');
T   = ncread(fileEle,'element')';

%% 
fileEle = 'BASE/BASE_V20_wIT.53.nc'; 
fileVel = 'BASE/BASE_V20_wIT.54.nc'; 

b = ncread(fileEle,'depth');
amp = ncread(fileEle,'amp');
eamp = amp(const,:)' ;

phs = ncread(fileEle,'phs');
ephs = phs(const,:)' ;

U_AMP = ncread(fileVel,'u_amp');
U_PHS = ncread(fileVel,'u_phs');
V_AMP = ncread(fileVel,'v_amp');
V_PHS = ncread(fileVel,'v_phs');

uamp = U_AMP(const,:)';
vamp = V_AMP(const,:)';
uphs = U_PHS(const,:)';
vphs = V_PHS(const,:)';


[Fx,Fy] = comptide_eflux( b, eamp, ephs, uamp, uphs, vamp, vphs) ;

TotF2 = hypot(Fx,Fy) ; 

lon = ncread(fileEle,'x');
lat = ncread(fileEle,'y');
t   = ncread(fileEle,'element')';

FIntrp = scatteredInterpolant(lon,lat,TotF2) ; 
TotF2_On1 = FIntrp(X,Y) ; 

figure; 
PD = 100.*(TotF2_On1 - TotF)./TotF ; 

fastscatter(X,Y,(TotF2_On1 - TotF)); 
cmocean('balance',9); 
caxis([-1 1])

figure;
trisurf(T,X,Y,PD); shading interp; view(2); 
caxis([-5 5])





