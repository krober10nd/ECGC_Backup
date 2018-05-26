% Compare errors at stations
% Given two fort.53's, calculate the station errors (complex rmse)
% and then difference the errors and calc percent error.
% plot the sign of the difference of the errors.
f53B = 'BASE/BASE_V20_wIT.53.nc';
f53A = 'BASE/BASE_V20_woIT.53.nc';
CSV  = 'TIDES_STA.csv';
%%
amp1 = ncread(f53A,'amp');
amp2 = ncread(f53B,'amp');

[errA,valA,sta_locsA,OBSA,MODA] = ValidateTides(f53A,CSV);
[errB,valB,sta_locsB,OBSB,MODB] = ValidateTides(f53B,CSV);

SIGNA = MODA{3,1} - OBSA{3,1}; 
SIGNB = MODB{3,1} - OBSB{3,1}; 

T_o = readtable(CSV);
I1 = strfind(T_o.Source,'Truth');
I2 = strfind(T_o.Name,'_TP');
I3 = strfind(T_o.Name,'_Shelf');
I = find(cellfun(@isempty,I1) & cellfun(@isempty,I2) & cellfun(@isempty,I3));

T_o = T_o(I,:);
%%
close all;
errorDiff = 100.*((valB{3,1} - valA{3,1})./valA{3,1}); 

figure; fastscatter(sta_locsA{1}{3,1},sta_locsA{2}{3,1},errorDiff,'MarkerSize',15);axis equal
improve = find(errorDiff<-5); 
degrade = find(errorDiff>5); 

hold on; plot(sta_locsA{1}{3,1}(improve),sta_locsA{2}{3,1}(improve),'bs','MarkerSize',20);
hold on; plot(sta_locsA{1}{3,1}(degrade),sta_locsA{2}{3,1}(degrade),'ro','MarkerSize',20);

title('Percent difference in M2 complex error'); 

colormap(cmocean('balance',8)); cb=colorbar; caxis([-50 50])
ylabel(cb,'m of complex rmse'); set(gca,'FontSize',15)

numel(improve)
numel(degrade) 
%%
inc = SIGNA > 0; 
dec = SIGNA < 0; 
figure; plot(sta_locsA{1}{3,1}(inc),sta_locsA{2}{3,1}(inc),'r+','MarkerSize',20);
hold on; plot(sta_locsA{1}{3,1}(dec),sta_locsA{2}{3,1}(dec),'bo','MarkerSize',20);
title('Sign of amplitude errors'); 
%%
inc = SIGNB > 0; 
dec = SIGNB < 0; 
figure; plot(sta_locsB{1}{3,1}(inc),sta_locsB{2}{3,1}(inc),'r+','MarkerSize',20);
hold on; plot(sta_locsB{1}{3,1}(dec),sta_locsB{2}{3,1}(dec),'bo','MarkerSize',20);
title('Sign of amplitude errors'); 
%% 
idx = find(sign(SIGNA) ~= sign(SIGNB));  
figure; plot(sta_locsB{1}{3,1}(idx),sta_locsB{2}{3,1}(idx),'kx','MarkerSize',20);
title('Sign change of amplitude errors'); 
