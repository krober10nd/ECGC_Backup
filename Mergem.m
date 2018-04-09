clearvars; clc;
addpath(genpath('utilities/'))
% merge automatically generated meshes together. 

filenames{1} = 'ECGC_BASE_-72_-60.5_41.75_46.14'; 

filenames{2} = 'ECGC_BASE_-78_-60.5_36.75_42.14'; 

filenames{3} = 'ECGC_BASE_-82.3_-60.5_31.75_37.14';

filenames{4} = 'ECGC_BASE_-82.3_-60.5_28_32.14'; 

filenames{5} = 'ECGC_BASE_-82.3_-79.4_24_28.25.14';

filenames{6} = 'ECGC_BASE_-87_-82_24_31.14'; 

filenames{7} = 'ECGC_BASE_-92_-86.75_24_31.14';

filenames{8} = 'ECGC_BASE_-98_-91.75_24_30.5.14';

filenames{9} = 'ECGC_BASE_-98_-60.5_5_24.25.14';

filenames{10}= 'ECGC_BASE_-79.6_-60.5_23.9_28.25.14'; 

% puerto rico 
filenames{11}= 'ECGC_BASE_-67.5_-65.15_17.6_18.6.14';

m1 = msh(filenames{1});
[m1.p,m1.t] = Fix_bad_edges_and_mesh(m1.p,m1.t,0,0.01); 
m2 = msh(filenames{2});
[m2.p,m2.t] = Fix_bad_edges_and_mesh(m2.p,m2.t,0,0.01); 
comb = m1 + m2;
for i = 3 : 11
    m = msh(filenames{i});
    [m.p,m.t]=Fix_bad_edges_and_mesh(m.p,m.t,0,0.01); 
    comb = m + comb;
    disp(['Completed merging ',num2str(i)]);
end

write(comb,'step1_BASE'); 
