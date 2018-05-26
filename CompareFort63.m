clearvars; clc; 
% compare two fort.56 


fort63_first  = 'fortWOCh.63.nc'; 
fort63_second = 'fortWCH.63.nc'; 


x1 = ncread(fort63_first,'x'); 
x2 = ncread(fort63_second,'x'); 
t1 = ncread(fort63_first,'element')'; 

y1 = ncread(fort63_first,'y'); 
y2 = ncread(fort63_second,'y'); 

bnde = extdom_edges2(t1',[x1,y1]);  
poly = extdom_polygon(bnde,[x1,y1],1); 
for i = 1 : length(poly)
   poly{i}(end+1,:) = [NaN,NaN];  
end
poly_vec = cell2mat(poly'); 
edges = Get_poly_edges(poly_vec); 

amp1 = ncread(fort63_first,'zeta'); 
amp2 = ncread(fort63_second,'zeta'); 

figure, 
for i = 1 : size(amp1,2)
m2_1 = amp1(:,i);
m2_2 = amp2(:,i); 

F_m2_1 = scatteredInterpolant(x1,y1,m2_1,'linear','linear'); 
F_m2_2 = scatteredInterpolant(x2,y2,m2_2,'linear','linear'); 

% interpoalate solution 2 on base grid's triangulation
m2_2c = F_m2_2(x1,y1); 

% plot the difference
%cla, trisurf(t1,x1,y1,m2_2c-m2_1); view(2); shading interp;  
cla, trisurf(t1,x1,y1,m2_2c); view(2); shading interp;  

title(['Free surface difference WCH-WOCH at ',num2str(i)]); cb = colorbar; 
caxis([-0.25 0.25]); colormap(cmocean('balance'));
ylabel(cb,'meters');axis([-95 -94.6 29.3 29.38]); axis equal
pause(0.5)

end