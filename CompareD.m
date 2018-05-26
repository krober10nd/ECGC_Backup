clearvars; clc; close all
% Compare the complex RMSE discrepancy in the harmonic constitutents. 
%filenames and directiories
fort54  = 'BASE/BASE_V20_wIT.54.nc';
fort542 = 'GRADE/G25.54.nc';

% read Grid
x1 = ncread(fort54,'x');
y1 = ncread(fort54,'y');
const = ncread(fort54,'const');
t1 = ncread(fort54,'element')';

conn = {'M2'};
%%
cc = 0; 
for c = conn
    cc = cc + 1;
    % first model 
    pos = find(contains(string(const'),c{1}));
    u_ao = ncread(fort54,'u_amp',[pos 1],[1 length(x1)])';
    u_go = ncread(fort54,'u_phs',[pos 1],[1 length(x1)])';
    v_ao = ncread(fort54,'v_amp',[pos 1],[1 length(x1)])';
    v_go = ncread(fort54,'v_phs',[pos 1],[1 length(x1)])';
    
end

%%
x2 = ncread(fort542,'x');
y2 = ncread(fort542,'y');
cc = 0;
for c = conn
    cc = cc + 1;
    % second model 
    pos = find(contains(string(const'),c{1}));
    u_amp = ncread(fort542,'u_amp',[pos 1],[1 length(x2)])';
    u_phs = ncread(fort542,'u_phs',[pos 1],[1 length(x2)])';
    v_amp = ncread(fort542,'v_amp',[pos 1],[1 length(x2)])';
    v_phs = ncread(fort542,'v_phs',[pos 1],[1 length(x2)])';
    
    % convert to complex number
    c_u = u_amp.*exp(1i*deg2rad(u_phs));
    c_v = v_amp.*exp(1i*deg2rad(v_phs));

    F_u = scatteredInterpolant(x2,y2,c_u); 
    F_v = scatteredInterpolant(x2,y2,c_v); 

    % interpolate complex number onto base mesh
    cOn1 = F_u(x1,y1) ; 
    % get back amp and phase
    u_am = abs(cOn1);
    u_gm = rad2deg(angle(cOn1));
    u_gm(u_gm < 0) = u_gm(u_gm < 0) + 360;
    
    cOn1 = F_v(x1,y1) ;
    % get back amp and phase
    v_am = abs(cOn1);
    v_gm = rad2deg(angle(cOn1));
    v_gm(v_gm < 0) = v_gm(v_gm < 0) + 360;
end

D_cell{cc} = sqrt(0.5*(u_am.^2 + u_ao.^2 - 2*u_ao.*u_am.*cosd(u_go - u_gm) + ...
    v_am.^2 + v_ao.^2 - 2*v_ao.*v_am.*cosd(v_go - v_gm)));
%%
figure; trisurf(t1,x1,y1,D_cell{1}); shading interp
caxis([0 0.10]); view(2); 
colormap(cmocean('thermal',5));
%axis([-88.4 -87.5 30.1 31]) % mobile bay 
title('K1 velocity RMSE discrepancy, NOCH-BASE');
