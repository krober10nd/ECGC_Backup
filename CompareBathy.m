clearvars; clc; close all; 

fort54_2 = 'BASE/BASE_V20_wIT.53.nc';
fort54_1 = 'NOCH/NOCH.53.nc';

x1 = ncread(fort54_1,'x');
y1 = ncread(fort54_1,'y');
t1 = ncread(fort54_1,'element')'; 
b1 = ncread(fort54_1,'depth'); 

x2 = ncread(fort54_2,'x');
y2 = ncread(fort54_2,'y');
t2 = ncread(fort54_2,'element')'; 
b2 = ncread(fort54_2,'depth'); 

F = scatteredInterpolant(x2,y2,b2,'linear','none');
b2_on1 = F(x1,y1); 

figure
trisurf(t1,x1,y1,100.*(b2_on1-b1)./b2_on1); view(2); 
shading interp; axis equal; cb = colorbar;
caxis([-10 10]) ; colormap(cmocean('balance',9));
ylabel(cb,'bathymetric difference in m');

%%
figure
trisurf(t1,x1,y1,b1); view(2); 
caxis([0 100])
figure
trisurf(t2,x2,y2,b2); view(2); 
caxis([0 100])