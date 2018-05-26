clearvars; clc; close all;
% Qx = U*H
% Qy = V*H

velfile1 = '/Users/Keith/Desktop/Harmonic_Files/BASE/BASE_V20_wIT.54.nc';
velfile2 = '/Users/Keith/Desktop/Harmonic_Files/SLPEXP/NOCH.54.nc';

u_amp1 = ncread(velfile1,'u_amp');
v_amp1 = ncread(velfile1,'v_amp');
x1 = ncread(velfile1,'x');
y1 = ncread(velfile1,'y');
b1 = ncread(velfile1,'depth');
t1 = ncread(velfile1,'element')';

u_amp2 = ncread(velfile2,'u_amp');
v_amp2 = ncread(velfile2,'v_amp');
x2 = ncread(velfile2,'x');
y2 = ncread(velfile2,'y');
b2 = ncread(velfile2,'depth');
t2 = ncread(velfile2,'element')';

u_amp1_m2 = u_amp1(6,:)';
v_amp1_m2 = v_amp1(6,:)';
U_amp1 = sqrt(u_amp1_m2.^2 + v_amp1_m2.^2);
Qx1    = u_amp1_m2.*b1;

u_amp2_m2 = u_amp2(6,:)';
v_amp2_m2 = v_amp2(6,:)';
U_amp2 = sqrt(u_amp2_m2.^2 + v_amp2_m2.^2);
Qx2    = u_amp2_m2.*b2;

F = scatteredInterpolant(x2,y2,Qx2,'linear','none');

Qx2_on1 = F(x1,y1) ;
%%
f