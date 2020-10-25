%% Geometrie [mm]

waitbar(0.4,wb,'Geometrie aus der 5. Klasse anwenden');
fprintf("------------------\n");

geom.l_AE = h_W*1E3 - r_dyn;                 % [mm]
geom.gamma = real(atand(l1*1E3/geom.l_AE));
geom.beta = real(atand(l2*1E3/geom.l_AE));
geom.gamma_beta = geom.gamma + geom.beta;
geom.l_AB = geom.l_AE/cosd(geom.gamma);
geom.l_AC = geom.l_AE/cosd(geom.beta);
geom.l_AD = (geom.l_AE^2 + (lv*1E3+lh*1E3)^2)^(1/2);
geom.l_BC = (l1+l2)*1E3;
geom.l_FG = 70;
geom.l_DG = geom.l_AE;
geom.l_FD = (geom.l_FG^2 + geom.l_DG^2)^(1/2);
geom.l_AF = lv*1E3 + lh*1E3 - geom.l_FG;
geom.delta = real(acosd((geom.l_AC^2 + geom.l_BC^2 - geom.l_AB^2)/(2*geom.l_AC*geom.l_BC)));
geom.h_Stufe = 200 *(1+S);
geom.l_Stufe = 600;
geom.gap = 15;
geom.t = geom.l_BC/(geom.l_AE) * (((r_dyn-geom.gap)*cosd(geom.delta) + ...
    ((geom.l_AC^2 - (r_dyn-geom.gap)^2)*sind(geom.delta)^2)^(1/2))*cosd(geom.delta) - (r_dyn-geom.gap));

if      ~(geom.l_BC > r_dyn * 2)
    fprintf("Problem: l_BC ist zu kurz. Beide Vorderräder kollidieren.\n");
elseif  ~(geom.l_AD - r_dyn > geom.l_AC + r_dyn)
    fprintf("Problem: l_AD ist zu kurz. Hinter- und Mittelrad kollidieren.\n");
elseif  ~(geom.l_AB + geom.l_AC >= geom.l_BC)
    fprintf("Problem: l_BC zu kurz. Dreieck-Bedingung verletzt.\n");
elseif  ~(geom.l_AC + geom.l_BC >= geom.l_AB)
    fprintf("Problem: l_AB zu kurz. Dreieck-Bedingung verletzt.\n");
elseif  ~(geom.l_BC + geom.l_AB >= geom.l_AC)
    fprintf("Problem: l_AC zu kurz. Dreieck-Bedingung verletzt.\n");
elseif  ~( ( (r_dyn + S*geom.l_Stufe)^2 + (geom.h_Stufe + r_dyn - r_dyn)^2 )^(1/2) <= geom.l_BC )
    fprintf("Problem: l_BC=" + geom.l_BC + " muss länger als " + ((r_dyn + S*geom.l_Stufe)^2 + ...
        (geom.h_Stufe + r_dyn - r_dyn)^2 )^(1/2) + "mm sein, damit das Hinderniss bestiegen werden kann.\n");
elseif  ~( geom.l_BC <= ( ((1-S)*geom.l_Stufe - r_dyn)^2 + (r_dyn - r_dyn)^2 )^(1/2) )
    fprintf("Problem: l_BC=" + geom.l_BC + " muss kürzer als " + ...
        ( ((1-S)*geom.l_Stufe - r_dyn)^2 + (r_dyn - r_dyn)^2 )^(1/2) + " mm sein\n");
elseif  ~(((geom.l_BC^2-geom.t^2)^(1/2)*sind(geom.delta) + ...
        geom.t*cosd(geom.delta))*geom.l_AC/geom.l_BC + r_dyn - geom.t >= (1+S)*geom.gap)
    fprintf("Problem: that shit stuff");
elseif  true
    fprintf("Keine Probleme mit der Geometrie gefunden.\n");
end

% Maximale Verdrehung im Gelenk der Wippe
geom.epsilon = asind(geom.h_Stufe/((l1+l2)*1E3));
geom.dz_punkt_A = geom.l_AC*cosd(90-geom.epsilon-geom.delta)-geom.l_AE;
geom.teta = asind(geom.dz_punkt_A/((lv+lh)*1E3));

waitbar(0.5,wb,'Stufe "Geometrie-Guru" erreicht');
