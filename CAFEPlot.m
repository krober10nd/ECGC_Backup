function [h] = CAFEPlot(file1,file2,const,type,color)
% Compute the cumulative area fraction difference between two fort.53's for
% either harmonic amplitudes or harmonic phases (by changing the "type").
% CAFE plots originate from Hagen et al. 2001.
% kjr, und, chl 2018
x1 = ncread(file1,'x');
y1 = ncread(file1,'y') ;
t1 = double(ncread(file1,'element')');
p1 = [x1,y1] ;
switch type
    case('amp')
        disp('For amplitude');
        temp  = ncread(file1,'amp');
        a1 = temp(const,:)'; clearvars temp;
    case('amppe')
        disp('For amplitude with percent error');
        temp  = ncread(file1,'amp');
        a1 = temp(const,:)'; clearvars temp;
    case('phs')
        disp('For phase');
        temp  = ncread(file1,'phs');
        a1 = temp(const,:)'; clearvars temp;
end
x2 = ncread(file2,'x');
y2 = ncread(file2,'y') ;
t2 = double(ncread(file2,'element')');
p2 = [x2,y2] ;
switch type
    case('amp')
        temp  = ncread(file2,'amp');
        a2 = temp(const,:)'; clearvars temp;
        F  = scatteredInterpolant(x2,y2,a2);
        clearvars a2;
        a2 = F(x1,y1);
    case('amppe')
        temp  = ncread(file2,'amp');
        a2 = temp(const,:)'; clearvars temp;
        F  = scatteredInterpolant(x2,y2,a2);
        clearvars a2;
        a2 = F(x1,y1);
    case('phs')
        temp  = ncread(file2,'amp');
        a2 = temp(const,:)'; clearvars temp;
        temp  = ncread(file2,'phs');
        phs2 = temp(const,:)'; clearvars temp;
        % convert to complex
        c_2 = a2.*exp(1i*deg2rad(phs2));
        % interpolate onto 1
        F  = scatteredInterpolant(x2,y2,c_2);
        a2 = F(x1,y1);
        % convert back to phase
        a2 = rad2deg(angle(a2));
        a2(a2 < 0) = a2(a2 < 0) + 360;
end

pmid1 = (p1(t1(:,1),:)+p1(t1(:,2),:)+p1(t1(:,3),:))/+3; % compute centroids
pmid2 = (p2(t2(:,1),:)+p2(t2(:,2),:)+p2(t2(:,3),:))/+3; % compute centroids

% calculate areas of triangles
for i = 1 : length(t1)
    x1 = p1(t1(i,1),1);
    x2 = p1(t1(i,2),1);
    x3 = p1(t1(i,3),1);
    y1 = p1(t1(i,1),2);
    y2 = p1(t1(i,2),2);
    y3 = p1(t1(i,3),2);
    
    area1(i) = 1/2*abs((x2-x1)*(y3-y1)-(x3-x1)*(y2-y1));
    aa1(i,1) = sum(a1(t1(i,:)))/3; % <-average solution on element
    aa2(i,1) = sum(a2(t1(i,:)))/3; % <-average solution on element
end
%
switch type
    case('amp')
        bins = -0.10:0.01:0.10;
        error = aa2 - aa1 ;
    case('amppe')
        bins = -5:1:5;
        error = 100.*((aa2 - aa1)./aa1);
    case('phs')
        bins = -10:1:10;
        error = aa2 - aa1 ;
end

% % DEBUG
% figure;
% fastscatter(pmid1(:,1),pmid1(:,2),error);
% cmocean('balance',9); colorbar;
% figure;
% % END DEBUG

binmap = discretize(error,bins);
for i = 1 : length(bins)
    ix=find(binmap==i);
    NumInBin=length(find(binmap==i));
    areaOfErr(i)=NumInBin*sum(area1(ix));
end
totalArea = sum(area1)*length(t1);
% cumulative area fraction
hold on;h= plot(bins,100.*(areaOfErr./totalArea),'color',color,'linewi',2);
switch type
    case('amp')
        % decorations
        hold on; plot(linspace(-0.1,0.1,100),linspace(1,1,100),'k-','linewi',2);
        xlim([-0.1 0.1]);
        ylim([0.001 100]);
        YTick=[0.01; 0.1; 1; 10; 100];
        yticks(YTick);
        xlabel('Elevation Difference (m)');
        ylabel('Cumulative Area (%)');
        set(gca, 'YScale', 'log');
        set(gca,'FontSize',16);
        grid minor;
    case('amppe')
        % decorations
        hold on; plot(linspace(-5,5,100),linspace(1,1,100),'k-','linewi',2);
        xlim([-5 5]);
        ylim([0.001 100]);
        YTick=[0.01; 0.1; 1; 10; 100];
        yticks(YTick);
        xlabel('Relative Elevation Difference (%)');
        ylabel('Cumulative Area (%)');
        set(gca, 'YScale', 'log');
        set(gca,'FontSize',16);
        grid minor;
    case('phs')
        % decorations
        hold on; plot(linspace(-10,10,100),linspace(1,1,100),'k-','linewi',2);
        xlim([-10 10]);
        ylim([0.001 100]);
        YTick=[0.01; 0.1; 1; 10; 100];
        yticks(YTick);
        xlabel('Elevation Phase Difference (deg)');
        ylabel('Cumulative Area (%)');
        set(gca, 'YScale', 'log');
        set(gca,'FontSize',16);
        grid minor;
end