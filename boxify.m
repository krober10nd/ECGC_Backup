clearvars; close all;

shp = shaperead('pr_1s_0m_contour.shp');
j = 0;
pts = [[shp.X]',[shp.Y]'] ;
nbox=10;
botl= min(pts);
topr= max(pts);
coef = [0 0; 1 0; 1 1; 0 1; 0 0];

xv = linspace(botl(1),topr(1),nbox+1);
yv = linspace(botl(2),topr(2),nbox+1);

[xg,yg]=meshgrid(xv,yv);
dy = abs(yg(2,1)-yg(1,1));
dx = abs(xg(1,2)-xg(1,1));

% box corners
boxc_x = xg(1:end-1,1:end-1);
boxc_y = yg(1:end-1,1:end-1);
boxc_x = boxc_x(:); boxc_y = boxc_y(:);

x0y0 = [boxc_x,boxc_y];

for i = 1 : length(x0y0)
    boubox{i}  = x0y0(i,:) + coef.*[dx,dy];
    bboxes{i}  = [min(boubox{i});max(boubox{i})]';
end

for i = 1 : length(boubox)
    edges = Get_poly_edges([boubox{i}; NaN NaN]);
    in=inpoly(pts,[boubox{i}; NaN NaN],edges);
    if sum(in) > 0
        j = j + 1;
        kept{j} = [boubox{i}; NaN NaN];
        keptb{j} = bboxes{i};
    end
end

plt = cell2mat(kept');
hold on;
plot(plt(:,1),plt(:,2),'r-')
plot(pts(:,1),pts(:,2),'g-')
axis equal
