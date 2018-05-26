clearvars; clc;

bbox    = [-100 -80; 15 33];
DEMFILE = '/Users/Keith/Desktop/DEM_FILES/result/combined4.nc';
FILE    = '/Users/Keith/Desktop/Harmonic_Files/BASe/BASE_V20_wIT.53.nc';

lon = ncread(FILE,'x');
lat = ncread(FILE,'y');
depth = ncread(FILE,'depth');

gdat= geodata('dem',DEMFILE,'bbox',bbox,'h0',90/111e3) ;

[xg,yg]=ndgrid(gdat.Fb.GridVectors{1},gdat.Fb.GridVectors{2}) ;

boubox = [bbox(1,1) bbox(2,1);
    bbox(1,1) bbox(2,2); ...
    bbox(1,2) bbox(2,2);
    bbox(1,2) bbox(2,1); ...
    bbox(1,1) bbox(2,1)];

in = inpoly([lon,lat],boubox);

IDXinDEM = FindLinearIdx(lon(in),lat(in),xg,yg) ;

PD = (-depth(in) - gdat.Fb.Values(IDXinDEM))./gdat.Fb.Values(IDXinDEM); 
PD = PD.*100 ; 
figure; fastscatter(xg(IDXinDEM),yg(IDXinDEM),PD);
cb=colorbar; ylabel(cb,'bathymetric percent error'); 
cmocean('balance'); 
caxis([-10 10])
edges = -10:1:10;
Y = discretize(PD,edges);

for i = 1 : length(edges) 
  count(i) = length(find(Y==i));   
end
count = count./sum(~isnan(Y)) ; 
%figure; 
hold on; plot(-10:1:10,count,'b-'); 
xlabel('Percent error in bathymetry'); 
ylabel('Percent of nodes'); 
grid minor; 



