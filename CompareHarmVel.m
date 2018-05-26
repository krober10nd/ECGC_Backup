clearvars; close all; clc;

fort54_2 = 'BASE/BASE_V20_wIT.54.nc';
fort54_1 = 'NOCH/NOCH.54.nc';

u_amp1 = ncread(fort54_1,'u_amp');
v_amp1 = ncread(fort54_1,'v_amp');
x1 = ncread(fort54_1,'x');
y1 = ncread(fort54_1,'y');
t1 = ncread(fort54_1,'element')'; 

u_amp2 = ncread(fort54_2,'u_amp');
v_amp2 = ncread(fort54_2,'v_amp');
x2 = ncread(fort54_2,'x');
y2 = ncread(fort54_2,'y');
t2 = ncread(fort54_2,'element')'; 

u_amp1_m2 = u_amp1(6,:)';
v_amp1_m2 = v_amp1(6,:)';
U_amp1 = sqrt(u_amp1_m2.^2 + v_amp1_m2.^2); 
% figure;
% trisurf(t1,x1,y1,U_amp1); shading interp; colorbar; view(2);
% colormap(cmocean('speed'))
% title('M2 tidal speed w/ channel'); 
%print -dpng -r300 M2Speed_wch

u_amp2_m2 = u_amp2(6,:)';
v_amp2_m2 = v_amp2(6,:)';
U_amp2 = sqrt(u_amp2_m2.^2 + v_amp2_m2.^2); 
% figure;
% trisurf(t2,x2,y2,U_amp2); shading interp; colorbar; view(2);
% colormap(cmocean('speed'))
% title('M2 tidal speed w/o channel'); 
%print -dpng -r300 M2Speed_woch

F_m2_1 = scatteredInterpolant(x1,y1,U_amp1,'linear','none');
F_m2_2 = scatteredInterpolant(x2,y2,U_amp2,'linear','none');

% interpoalate solution 2 on base grid's triangulation
U_amp2c = F_m2_2(x1,y1);

%%
pd = 100*(U_amp2c-U_amp1)./U_amp1;
% plot the difference
figure, trisurf(t1,x1,y1,pd); view(2); shading interp;
%figure, trisurf(t1,x1,y1,U_amp2c-U_amp1); view(2); shading interp;
title('Percent diff (w ch - w/o ch), M2 norm velocity');
cb = colorbar;
caxis([-25 25])
%caxis([-50 50]); 
colormap(cmocean('balance',10));
ylabel(cb,'percent difference');
print -dpng -r300 M2Speed_diff_woch_minus_wch
