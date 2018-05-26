clearvars; clc; close all
% Plot tidal ellipses
%filenames and directiories
fort54  = 'BASE/BASE_V20_woIT.54.nc';
fort542 = 'NOCH/NOCH.54.nc';
obs = 'TIDES_STA.csv';

% read Grid
x = ncread(fort54,'x');
y = ncread(fort54,'y');
const   = ncread(fort54,'const');
b       = ncread(fort54,'depth');
t       = ncread(fort54,'element')';
p = [x,y];
bnde = extdom_edges2(t,p);
poly = extdom_polygon(bnde,p,-1);
polyc= cell2mat(poly');
edges=Get_poly_edges(polyc);

conn = {'M2'};

% Create your own grid
% map model to locations
%[xg,yg]= meshgrid(-75.6 :0.01: -74.6 , 38.6:0.01:40.1);
[xg,yg]=meshgrid(-95.2:0.01:-94.7,29.35:0.01:30.6); 
pts = [xg(:),yg(:)];
in = inpoly(pts,polyc,edges);
pts(~in,:) = [];

mdl = KDTreeSearcher(p);
idx = knnsearch(mdl,pts,'k',12);

load D_cell.mat
%%
figure;
cc = 0;
for c = conn
    cc = cc + 1;
    % our model
    pos = find(contains(string(const'),c{1}));
    u_amp = ncread(fort54,'u_amp',[pos 1],[1 length(x)]);
    u_phs = ncread(fort54,'u_phs',[pos 1],[1 length(x)]);
    v_amp = ncread(fort54,'v_amp',[pos 1],[1 length(x)]);
    v_phs = ncread(fort54,'v_phs',[pos 1],[1 length(x)]);
    
    [u_am, u_gm] = sta_interp(x(idx),y(idx),b(idx),u_amp(idx),...
        u_phs(idx),pts(:,1),pts(:,2));
    [v_am, v_gm] = sta_interp(x(idx),y(idx),b(idx),v_amp(idx),...
        v_phs(idx),pts(:,1),pts(:,2));
    u_ao = u_am;
    u_go = u_gm;
    v_ao = v_am;
    v_go = v_gm;
    
    [SEMA, ECC, INC, PHA, wm] = ap2em1(u_am, u_gm, v_am, v_gm);
    
    
    mx = 5;
    wm  = squeeze(wm);
    for i = 1:length(SEMA)
        
        if D_cell{1}(i) > 0.01
            h1 = plot( pts(i,1) + real(wm(i,:))/mx, ...
                pts(i,2) + imag(wm(i,:))/mx, 'r' ) ;  % Clockwise
            hold on;
            plot( pts(i,1) + mean(real(wm(i,[1 end])))/mx, ...
                pts(i,2) + mean(imag(wm(i,[1 end])))/mx, 'ko',...
                'MarkerFaceColor','k','MarkerSize',3)
        end
    end
end

%%
cc = 0;
x = ncread(fort542,'x');
y = ncread(fort542,'y');
b       = ncread(fort542,'depth');
mdl = KDTreeSearcher([x,y]);

idx = knnsearch(mdl,pts,'k',12);

for c = conn
    cc = cc + 1;
    % our model
    pos = find(contains(string(const'),c{1}));
    u_amp = ncread(fort542,'u_amp',[pos 1],[1 length(x)]);
    u_phs = ncread(fort542,'u_phs',[pos 1],[1 length(x)]);
    v_amp = ncread(fort542,'v_amp',[pos 1],[1 length(x)]);
    v_phs = ncread(fort542,'v_phs',[pos 1],[1 length(x)]);
    
    [u_am, u_gm] = sta_interp(x(idx),y(idx),b(idx),u_amp(idx),...
        u_phs(idx),pts(:,1),pts(:,2));
    
    
    [v_am, v_gm] = sta_interp(x(idx),y(idx),b(idx),v_amp(idx),...
        v_phs(idx),pts(:,1),pts(:,2));
    
    [SEMA, ECC, INC, PHA, wm] = ap2em1(u_am, u_gm, v_am, v_gm);
    
    
    mx = 5;
    wm  = squeeze(wm);
    for i = 1:length(SEMA)
       if D_cell{1}(i) > 0.01
            %model
            h1 = plot( pts(i,1) + real(wm(i,:))/mx, ...
                pts(i,2) + imag(wm(i,:))/mx, 'b-' ) ;  % Clockwise
            
            hold on;
            plot( pts(i,1) + mean(real(wm(i,[1 end])))/mx, ...
                pts(i,2) + mean(imag(wm(i,[1 end])))/mx, 'ko',...
                'MarkerFaceColor','k','MarkerSize',3)
       end
        
    end
end
%plot_google_map('MapType','satellite')


%%
 D_cell{cc} = sqrt(0.5*(u_am.^2 + u_ao.^2 - 2*u_ao.*u_am.*cosd(u_go - u_gm) + ...
     v_am.^2 + v_ao.^2 - 2*v_ao.*v_am.*cosd(v_go - v_gm)));



