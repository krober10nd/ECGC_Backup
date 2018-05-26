clearvars; clc; close all
% compare two fort.53
fort53_second  = 'BASE/BASE_V20_wIT.53.nc';
fort53_first   = 'SLPEXP/SLP0.53.nc';
% 1. Q1
% 2. O1
% 3. P1
% 4. K1
% 5. N2
% 6. M2
% 7. S2
% 8. K2
const          = 'M2';
idx            = 6;
%
x1 = ncread(fort53_first,'x');
y1 = ncread(fort53_first,'y');
t1 = ncread(fort53_first,'element')';
% bnde = extdom_edges2(t1,[x1,y1]);
% poly = extdom_polygon(bnde,[x1,y1],-1);
% polyc = cell2mat(poly');
% save polyc polyc
load polyc
x2 = ncread(fort53_second,'x');
y2 = ncread(fort53_second,'y');
t2 = ncread(fort53_second,'element')';

amp1 = ncread(fort53_first,'amp');
amp2 = ncread(fort53_second,'amp');
phs1 = ncread(fort53_first,'phs');
phs2 = ncread(fort53_second,'phs');

p_1 = phs1(idx,:)';
p_2 = phs2(idx,:)';

a_1 = amp1(idx,:)';
a_2 = amp2(idx,:)';

% convert to complex
c_2 = a_2.*exp(1i*deg2rad(p_2));

tic
F_2 = scatteredInterpolant(x2,y2,c_2,'linear','none');
toc
c_2_on1 = F_2(x1,y1);

% convert back to amp and phs
a_int = abs(c_2_on1);
p_int = rad2deg(angle(c_2_on1));
p_int(p_int < 0) = p_int(p_int < 0) + 360;
%%
pd = 100*(p_int-p_1)./p_1;
df = p_int-p_1;
pd(abs(df)<0.001) = NaN;

figure; trisurf(t1,x1,y1,df); view(2); shading interp;
hold on; plot(polyc(:,1),polyc(:,2),'k-');
axis equal
cb = colorbar; caxis([-10 10]); colormap(cmocean('balance',9));
ylabel(cb,'percent difference');

% houston
% xlim([-95.4037 -94.3721])
% ylim([29.1490 29.9627])

% % new england
% xlim([-72.5968 -61.5574]);
% ylim([39.8300 46.7758]);
%
% % philadelphia
% xlim([-75.8511 -73.7493]);
% ylim([38.8895 40.2119]);
%
% % cheaspeake
% xlim([-78.4693 -73.7403]);
% ylim([36.7117 39.6871]);
%
% % south atlantic bight
% xlim([-82.3466 -79.0505])
% ylim([30.5123 32.5861])

% south atlantic bight 2
xlim([-82.0531 -80.7853])
ylim([30.3965 31.3964]);
title = [const,'_',fort53_second,'_minus_',fort53_first];
print(title,'-dpng','-r300');




