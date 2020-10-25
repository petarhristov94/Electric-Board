close all;
clear all;
clc;

addpath([pwd, '\functions']);
addpath([pwd, '\functions\other']);
%% Parameter
parameter;

%% Geometrie [mm]
geometrie;

%% Bedarfkennwerte
calcmodell;

%% Plot
plotmodell;

%% Permutations
% i_Moment.permutations = modellpermutations(0:5:100, 3);
% for index = 1:length(i_Moment.permutations)
%     i_Moment.current = i_Moment.permutations(index,:);
%     calcmodell;
%     variable_to_test.M_Notw(index) = M.M_Notw;
% end

%plotpermutations;

%% Finalkram
waitbar(1,wb,'Ergebnisse darstellen');
spreadfigures;
geom = orderfields(geom);
close(wb);
clear axis dist distribution index index_txt interpolate proc prop temp_1 temp_len txt wb;
fprintf("------------------\n");
%close all;