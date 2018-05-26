clearvars; close all; clc; 

file1 = 'BASE/maxvel.63.nc'; 
file2 = 'NOCH/maxvel.63.nc'; 

x1=ncread(file1,'x');
y1=ncread(file1,'y');
t1=ncread(file1,'element')';
vel_max1=ncread(file1,'vel_max');

x2=ncread(file2,'x');
y2=ncread(file2,'y');
t2=ncread(file2,'element')';
vel_max2=ncread(file2,'vel_max');

F2 = scatteredInterpolant(x2,y2,vel_max2) ; 

vel_max2_on_mesh1 = F2(x1,y1) ; 

figure; 
trisurf(t1,x1,y1,vel_max2_on_mesh1 - vel_max1); 
cmocean('balance',9); 
caxis([-0.25 0.25]); 
shading interp; 
view(2)