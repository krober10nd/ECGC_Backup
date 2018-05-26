clearvars; close all;

[errBase,valBase]=ValidateTides('BASE/BASE_V20_wIT.53.nc','TIDES_STA.csv');
[errSLP0,valSLP0]=ValidateTides('SLPEXP/SLP0.53.nc','TIDES_STA.csv');
[errSLP5,valSLP5]=ValidateTides('SLPEXP/SLP5.53.nc','TIDES_STA.csv');
[errSLP10,valSLP10]=ValidateTides('SLPEXP/SLP10.53.nc','TIDES_STA.csv');

figure; 
histogram(valBase{3,1}*100,10,'BinLimits',[0,20]); 
hold on
histogram(valSLP0{3,1}*100,10,'BinLimits',[0,20]); 



