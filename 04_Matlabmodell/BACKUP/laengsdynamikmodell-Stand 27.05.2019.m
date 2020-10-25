close all;
clear all;
clc;

addpath([pwd, '\functions']);
%% Parameter

wb = waitbar(0,'Konstanten ausdenken');
fprintf("------------------\n");

g               = 9.81;                 % Erdbeschleunigung                 [m/s^2]
mu              = 0.8;                  % max. Reibkoeffizient auf Asphalt  [-]
m.m_Fzg         = 30;                   % Fahrzeugleermasse                 [kg]
m.m_Zul_max     = 60;                   % max. Zuladungsmasse               [kg]
m.m             = 0;                    % Gesamtmasse Fzg.                  [kg]
r_dyn           = 90;                   % dyn. Radhalbmesser                [mm]
fRoll           = 0.015;                % Rollwiderstandsbeiwert            [-]
alpha_St.max    = 45;                   % max. Steigungswinkel              [°]
alpha_St.alpha  = linspace(-45,45,181); % Steigungswinkel                   [°]
p_max           = 0;                    % max. Straßensteigung              [%]
p               = 0;                    % Straßensteigung                   [%]
rho_Luft        = 1.225;                % Luftdichte                        [kg/m^3]        // [PIS16] S.63; Kap. 3.2.1; Normalbedingungen p=1013 hPa, t=10°C
A_Fzg           = 2;                    % Querspantfläche von Fzg.          [m^2]
c_w             = 0.65;                 % Luftwiderstandsbeiwert            [-]             // [TRZ17] S.256; Tab. D.3; Omnibus 0,6-0,7
v.v_Wind        = 0;                    % Windgeschwindigkeit               [km/h]
                                        % -->(negativ in Fahrtrichtung)
v.v             = 0;                    % Relativgeschwindigkeit            [km/h]
v.v_Fzg         = 6;                    % Fahrzeuggeschwindigkeit           [km/h]
v.v_Fzg_max     = 12;                   % max. Fzg-Geschwindigkeit          [km/h]
a_x             = 0;                    % min. Längsbeschleunigung          [m/s^2]
O_red           = 0;                    % red. Massenträgheitsmoment        [kg*m^2]
e_i             = 0;                    % Massenfaktor                      [-]
i_Getr          = 26;                   % Getriebeübersetzung               [-]
i_Moment        = [50, 20, 30];         % Momentaufteilung                  [%]
                                        % -->(v1, v2, h)
eta.Motor       = 0.90;                 % Wirkungsgrad des Elektromotors    [-]
eta.Batt    	= 0.90;                 % Wirkungsgrad der Batterie         [-]
eta.mech_ges    = 0.80;                 % mechanischer Gesamtwirkungsgrad   [-]
eta.el_ges      = eta.Motor*eta.Batt;   % elektrischer Gesamtwirkungsgrad   [-]
P.P_Nebenaggr   = 20;                   % Bedarfsleistung der Nebenaggregate[W]
k_Raeder        = 6;                    % Anzahl Räder                      [-]
s_Rampe         = 8;                    % durchschnittliche Rampenlänge     [m]
t.t_Besteigung  = 0;                    % Besteigungsdauer                  [s]
t.t_Bordstein   = 3;                    % Bordstein-Besteigungsdauer        [s]
t.t_inf         = 4.8 /60;              % max. Fahrtdauer                   [min]
S               = 0.1;                  % Sicherheitsfaktor                 [-]

l1              = 152.900   *1E-3;      % Schwerpunktrücklage 1             [m]
l2              = 212.800   *1E-3;      % Schwerpunktrücklage 2             [m]
h_W             = 220       *1E-3;      % Koppelpunkthöhe (Wippe)           [m]

waitbar(0.1,wb,'Dumme Fragen stellen');

zustand = questdlg('Welcher Zustand soll betrachtet werden?','Fahrzustand bestimmen','beladen','nicht beladen','nur Platform','nicht beladen');
if isequal(zustand,'beladen')
    fprintf("Beladener Zustand gewählt.\n");
    h_SP        = 387.523   *1E-3;      % Schwerpunkthöhe                   [m]
    lv          = 222.989   *1E-3;      % Schwerpunktrücklage               [m]222.864
    lh          = 334.172   *1E-3;      % Schwerpunktvorlage                [m]334.297
    m.m_Zul     = m.m_Zul_max;          % Zuladungsmasse                    [kg]
elseif isequal(zustand,'nur Platform')
    fprintf("Nur Platform gewählt.\n");
    h_SP        = 209.789   *1E-3;      % Schwerpunkthöhe                   [m]235
    lv          = 224.286   *1E-3;      % Schwerpunktrücklage               [m]222.864
    lh          = 332.875   *1E-3;      % Schwerpunktvorlage                [m]334.297
    m.m_Zul     = 0;                    % Zuladungsmasse                    [kg]
else
    fprintf("Nicht beladener Zustand gewählt.\n");
    h_SP        = 312.473   *1E-3;      % Schwerpunkthöhe                   [m]235
    lv          = 223.755   *1E-3;      % Schwerpunktrücklage               [m]222.864
    lh          = 333.406   *1E-3;      % Schwerpunktvorlage                [m]334.297
    m.m_Zul     = 11.2;                 % Zuladungsmasse                    [kg] 
end

waitbar(0.2,wb,'Noch mehr Konstanten');

m.m = m.m_Fzg + m.m_Zul;
p = tand(alpha_St.alpha);
p_max = tand(alpha_St.max);
e_i = O_red/(m.m_Fzg*(r_dyn*1E-3)^2) + 1;
v.v = v.v_Fzg + v.v_Wind;
t.t_Besteigung = s_Rampe/v.v_Fzg_max*3.6;

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

%% Bedarfkennwerte

waitbar(0.6,wb,'Kräfte und Leistungen berechnen');

F_Bed = fRoll*m.m*g*cosd(alpha_St.alpha) + ...          % Bedarfskraft am Rad       [N]
    m.m*g*sind(alpha_St.alpha) + ...
    0.5*c_w*A_Fzg*rho_Luft*(v.v/3.6)^2 + ...
    (e_i*m.m_Fzg + m.m_Zul)*a_x;

M.M_Bed_R = F_Bed*r_dyn*1E-3;                           % Bedarfsmoment am Rad      [Nm]
M.M_Bed_EM = (M.M_Bed_R/eta.mech_ges)/i_Getr;           % Bedarfsmoment am Motor    [Nm]
M.M_UE_R = 0;                                           % Überschussmom. am Rad     [Nm]
M.M_UE_EM = 0;                                          % Überschussmom. am Motor   [Nm]

P.P_Bed_R = F_Bed*(v.v_Fzg/3.6);                        % Bedarfsleistung am Rad    [Nm]
P.P_Bed_EM = P.P_Bed_R/eta.mech_ges;                    % Bedarfsleistung am Motor  [Nm]
P.P_Bed_Batt = P.P_Bed_EM/eta.Motor + ...               % Bedarfsleistung am Rad    [Nm]
    P.P_Nebenaggr;
P.P_Bed_Entlade = P.P_Bed_Batt/eta.Batt;                % Bed.-Leistung an der Batt [Nm]
P.P_Bed_Zelle = 0;                                      % Notw. Entladeleistung     [Nm]

E.E_Bed_R = P.P_Bed_R*t.t_inf/60;                       % Bedarfsenergie am Rad     [Wh]
E.E_Bed_EM = P.P_Bed_EM*t.t_inf/60;                     % Bedarfsenergie am Motor   [Wh]
E.E_Bed_Batt = P.P_Bed_Batt*t.t_inf/60;                 % Bed.-E. der Batt.-Klemmen [Wh]
E.E_Bed_Entlade = P.P_Bed_Entlade*t.t_inf/60;           % Bed.-Energie an der Batt. [Wh]
E.E_Bed_Zelle = 0;                                      % Bed.-Energie pro Zelle    [Wh]

w.w_R = (v.v_Fzg/3.6)/(r_dyn*1E-3);                     % Radwinkelgeschwindigkeit  [1/s]
w.w_R_max = (v.v_Fzg_max/3.6)/(r_dyn*1E-3);             % max Radwinkelgeschw.      [1/s]
n.n_R = w.w_R/(2*pi)*60;                                % Raddrehzahl               [1/min]
n.n_R_max = w.w_R_max/(2*pi)*60;                        % max. Raddrehzahl          [1/min]
n.n_EM = round(n.n_R*i_Getr,0);                         % Motordrehzahl             [1/min]
n.n_EM_max = round(n.n_R_max*i_Getr,0);                 % Motordrehzahl             [1/min]

%% Horizontalkräfte (X-Richtung)

waitbar(0.7,wb,'Aufstandskräfte mit dem rechten Hand Regel am Linken bestimmen');

% dynamische Kräfte:
Fx.Fx_h = (i_Moment(3)/100)*F_Bed;
Fx.Fx_W = m.m*g*sind(alpha_St.alpha) + m.m*a_x + ...
    fRoll*m.m*g*cosd(alpha_St.alpha) + ...
    0.5*c_w*A_Fzg*rho_Luft*(v.v/3.6)^2 - Fx.Fx_h;           % Schnittkraft X-Richtung    [N]
Fx.Fx_v2 = (i_Moment(2)/100)*F_Bed;
Fx.Fx_v1 = Fx.Fx_W - Fx.Fx_v2;
%% Vertikalkräfte (Z-Richtung)

% statsche Kräfte:
Fz.Fz_stat.Fz_h_stat = 1/(lv+lh)*(m.m*g*lv);
Fz.Fz_stat.Fz_W_stat = m.m*g - Fz.Fz_stat.Fz_h_stat;
Fz.Fz_stat.Fz_v1_stat = 1/(l1+l2)*(Fz.Fz_stat.Fz_W_stat*l2);
Fz.Fz_stat.Fz_v2_stat = Fz.Fz_stat.Fz_W_stat - Fz.Fz_stat.Fz_v1_stat;

% dynamische Kräfte:
Fz.Fz_dyn.Fz_W = 1/(lv+lh)*( - m.m*g*sind(alpha_St.alpha)*h_SP ...  % Schnittkraft Z-Richtung    [N]
    - m.m*a_x*h_SP + Fx.Fx_W*h_W + m.m*g*cosd(alpha_St.alpha)*lh);
Fz.Fz_dyn.Fz_v1 = 1/(l1+l2)*( Fz.Fz_dyn.Fz_W*l2 - Fx.Fx_W*h_W);
Fz.Fz_dyn.Fz_v2 = Fz.Fz_dyn.Fz_W - Fz.Fz_dyn.Fz_v1;
Fz.Fz_dyn.Fz_h = m.m*g*cosd(alpha_St.alpha) - Fz.Fz_dyn.Fz_W;

%% Kraftschluss

waitbar(0.8,wb,'ACHTUNG! RUTSCHGEFAHR!');

fR.fR_v1 = Fx.Fx_v1 ./ Fz.Fz_dyn.Fz_v1;
fR.fR_v2 = Fx.Fx_v2 ./ Fz.Fz_dyn.Fz_v2;
fR.fR_h = Fx.Fx_h ./ Fz.Fz_dyn.Fz_h;

%% Plot

waitbar(0.82,wb,'Bunte Bleistifte aus dem Euro-Laden kaufen');
fprintf("------------------\n");

prop.color.F_W = [0, 0, 0];
prop.color.F_h = [0, 0.45, 0.74];
prop.color.F_v2 = [1, 0.529, 0];
prop.color.F_v1 = [0.894, 0.118, 0.169];
prop.color.grey = [0.5, 0.5, 0.5];

prop.color.F_R = [87/255, 24/255, 69/255];
prop.color.F_EM = [144/255, 12/255, 62/255];
prop.color.F_Batt = [199/255, 0/255, 57/255];
prop.color.F_Entlade = [255/255, 87/255, 51/255];

% -------------------------------------------------------------------------
% Achslasten in Abhängigkeit der Straßensteigung
% -------------------------------------------------------------------------

waitbar(0.85,wb,'Malen....');

hold on;
plot(alpha_St.alpha, Fz.Fz_dyn.Fz_W, 'LineStyle',':', 'color', prop.color.F_W);
plot(alpha_St.alpha, Fz.Fz_dyn.Fz_v1, 'LineStyle','-', 'color', prop.color.F_v1);
plot(alpha_St.alpha, Fz.Fz_dyn.Fz_v2, 'LineStyle','-', 'color', prop.color.F_v2);
plot(alpha_St.alpha, Fz.Fz_dyn.Fz_h, 'LineStyle','-', 'color', prop.color.F_h);
% Interpolation um Winkel zu berechnen
interpolate = fnc_interpolation(Fz.Fz_dyn, alpha_St.alpha, 0);
plot(interpolate.ans(1,:), 0, '*','color',prop.color.grey);
for index_txt = 1:length(interpolate.ans)
    txt = ['  ' num2str(interpolate.ans(1,index_txt)) '°'];
    text(interpolate.ans(1,index_txt), 0, ...
        txt, 'FontSize', 10, 'color',prop.color.grey, ...
        'FontWeight', 'normal', 'FontAngle', 'italic');
end
prop.ylimit = ylim;
prop.delta = 0.025*sum(abs(prop.ylimit));
prop.xlimit = xlim;
prop.arrowlen = 0.13*sum(abs(prop.xlimit));
prop.legend = ["F_z_W", "F_z_v_1", "F_z_v_2", "F_z_h"];
drawArrow = @(x,y,varargin) quiver( x(1),y(1),x(2)-x(1),y(2)-y(1),0, varargin{:} );
if min(alpha_St.alpha) >= 0 || max(alpha_St.alpha) > 0
    drawArrow([prop.arrowlen,0.5],[prop.ylimit(2)-prop.delta,prop.ylimit(2)-prop.delta],'color',prop.color.grey,'MarkerFaceColor',prop.color.grey,...
        'MarkerEdgeColor','none','Marker','>','ShowArrowHead','off');
    text(1, prop.ylimit(2)-prop.delta, 'Steigung', 'FontSize', 8,'color',prop.color.grey, ...
        'FontWeight', 'bold', 'FontAngle', 'italic', ...
        'HorizontalAlignment','left','VerticalAlignment','top');
    legend(prop.legend,'Location','northeast');
end
if min(alpha_St.alpha) < 0
    drawArrow([-prop.arrowlen,-0.5],[prop.ylimit(2)-prop.delta,prop.ylimit(2)-prop.delta],'color',prop.color.grey,'MarkerFaceColor',prop.color.grey,...
        'MarkerEdgeColor','none','Marker','<','ShowArrowHead','off');
    text(-1, prop.ylimit(2)-prop.delta, 'Gefälle', 'FontSize', 8,'color',prop.color.grey, ...
        'FontWeight', 'bold', 'FontAngle', 'italic', ...
        'HorizontalAlignment','right','VerticalAlignment','top');
    drawArrow([0,0],ylim,'color',prop.color.grey,'ShowArrowHead','off', 'LineStyle','--');
    legend(prop.legend,'Location','southeast');
end
hold off;
title("Achslasten in Abhängigkeit der Straßensteigung" + " (" + zustand + ")");
ylabel("Kraft [N]");
xlabel("Steigung [°]");
grid on;
alpha_St.krit_geom = min(interpolate.ans(interpolate.ans>0));

% -------------------------------------------------------------------------
% Horzontalkräfte in Abhängigkeit der Straßensteigung
% -------------------------------------------------------------------------

waitbar(0.9,wb,'Malen..Malen...');

figure;
hold on;
plot(alpha_St.alpha, Fx.Fx_W, 'LineStyle',':', 'color', prop.color.F_W);
plot(alpha_St.alpha, Fx.Fx_v1, 'LineStyle','-', 'color', prop.color.F_v1);
plot(alpha_St.alpha, Fx.Fx_v2, 'LineStyle','-', 'color', prop.color.F_v2);
plot(alpha_St.alpha, Fx.Fx_h, 'LineStyle','-', 'color', prop.color.F_h);
prop.ylimit = ylim;
prop.delta = 0.025*sum(abs(prop.ylimit));
prop.xlimit = xlim;
prop.arrowlen = 0.13*sum(abs(prop.xlimit));
prop.legend = ["F_x_W", "F_x_v_1", "F_x_v_2", "F_x_h"];
drawArrow = @(x,y,varargin) quiver( x(1),y(1),x(2)-x(1),y(2)-y(1),0, varargin{:} );
if min(alpha_St.alpha) >= 0 || max(alpha_St.alpha) > -12
    drawArrow([prop.arrowlen,0.5],[prop.ylimit(2)-prop.delta,prop.ylimit(2)-prop.delta],'color',prop.color.grey,'MarkerFaceColor',prop.color.grey,...
        'MarkerEdgeColor','none','Marker','>','ShowArrowHead','off');
    text(1, prop.ylimit(2)-prop.delta, 'Steigung', 'FontSize', 8,'color',prop.color.grey, ...
        'FontWeight', 'bold', 'FontAngle', 'italic', ...
        'HorizontalAlignment','left','VerticalAlignment','top');
    legend(prop.legend,'Location','northeast');
end
if min(alpha_St.alpha) < 0
    drawArrow([-prop.arrowlen,-0.5],[prop.ylimit(2)-prop.delta,prop.ylimit(2)-prop.delta],'color',prop.color.grey,'MarkerFaceColor',prop.color.grey,...
        'MarkerEdgeColor','none','Marker','<','ShowArrowHead','off');
    text(-1, prop.ylimit(2)-prop.delta, 'Gefälle', 'FontSize', 8,'color',prop.color.grey, ...
        'FontWeight', 'bold', 'FontAngle', 'italic', ...
        'HorizontalAlignment','right','VerticalAlignment','top');
    drawArrow([0,0],ylim,'color',prop.color.grey,'ShowArrowHead','off', 'LineStyle','--');
    legend(prop.legend,'Location','southeast');
end
hold off;
title("Horzontalkräfte in Abhängigkeit der Straßensteigung" + " (" + zustand + ")");
ylabel("Kraft [N]");
xlabel("Steigung [°]");
grid on;

% -------------------------------------------------------------------------
% Kraftschlussbeiwert der Achsen in Abhängigkeit der Straßensteigung
% -------------------------------------------------------------------------

waitbar(0.95,wb,'Malen....Malen..Malen...');

figure;
hold on;
plot(alpha_St.alpha, fR.fR_v1, '-', 'color', prop.color.F_v1);
plot(alpha_St.alpha, fR.fR_v2, '-', 'color', prop.color.F_v2);
plot(alpha_St.alpha, fR.fR_h,  '-', 'color', prop.color.F_h);
drawArrow([0 prop.xlimit(2)],[mu, mu],'color',prop.color.grey,'MarkerFaceColor',prop.color.grey,...
    'MarkerEdgeColor','none','ShowArrowHead','off','LineStyle','--');
text(1, mu, ['\mu = ',num2str(mu)], 'FontSize', 10,'color',prop.color.grey, ...
    'FontWeight', 'bold', 'FontAngle', 'italic', ...
    'HorizontalAlignment','left','VerticalAlignment','top');
ylim([-1,1]);
xlim([-alpha_St.krit_geom alpha_St.krit_geom]);
% Interpolation um Winkel zu berechnen
interpolate = fnc_interpolation(fR, alpha_St.alpha, mu);
plot(min(abs(interpolate.ans(1,:))), mu, '*','color',prop.color.grey);
for index_txt = 1:length(interpolate.ans)
    if isequal(interpolate.ans(1,index_txt), min(abs(interpolate.ans(1,:))))
        txt = ['  ' num2str(interpolate.ans(1,index_txt)) '°'];
        text(interpolate.ans(1,index_txt), mu, ...
            txt, 'FontSize', 10, 'color',prop.color.grey, ...
            'FontWeight', 'normal', 'FontAngle', 'italic', ...
            'HorizontalAlignment','left','VerticalAlignment','top');
    end
end
prop.ylimit = ylim;
prop.delta = 0.025*sum(abs(prop.ylimit));
prop.xlimit = xlim;
prop.arrowlen = 0.13*sum(abs(prop.xlimit));
prop.legend = ["f_R_v_1", "f_R_v_2", "f_R_h"];
if min(alpha_St.alpha) >= 0 || max(alpha_St.alpha) > 0
    drawArrow([prop.arrowlen,0.5],[prop.ylimit(2)-prop.delta,prop.ylimit(2)-prop.delta],'color',prop.color.grey,'MarkerFaceColor',prop.color.grey,...
        'MarkerEdgeColor','none','Marker','>','ShowArrowHead','off');
    text(1, prop.ylimit(2)-prop.delta, 'Steigung', 'FontSize', 8,'color',prop.color.grey, ...
        'FontWeight', 'bold', 'FontAngle', 'italic', ...
        'HorizontalAlignment','left','VerticalAlignment','top');
    legend(prop.legend,'Location','northeast');
end
if min(alpha_St.alpha) < 0
    drawArrow([-prop.arrowlen,-0.5],[prop.ylimit(2)-prop.delta,prop.ylimit(2)-prop.delta],'color',prop.color.grey,'MarkerFaceColor',prop.color.grey,...
        'MarkerEdgeColor','none','Marker','<','ShowArrowHead','off');
    text(-1, prop.ylimit(2)-prop.delta, 'Gefälle', 'FontSize', 8,'color',prop.color.grey, ...
        'FontWeight', 'bold', 'FontAngle', 'italic', ...
        'HorizontalAlignment','right','VerticalAlignment','top');
    drawArrow([0,0],ylim,'color',prop.color.grey,'ShowArrowHead','off', 'LineStyle','--');
    legend(prop.legend,'Location','southeast');
end
hold off;
title("Kraftschlussbeiwert der Achsen in Abhängigkeit der Straßensteigung" + " (" + zustand + ")");
ylabel("Kraftschlussbeiwert [-]");
xlabel("Steigung [°]");
grid on;
alpha_St.krit_fR = min(interpolate.ans(interpolate.ans>0));

% -------------------------------------------------------------------------
% Bedarfsmoment in Abhängigkeit der Straßensteigung
% -------------------------------------------------------------------------

figure;
hold on;
plot(alpha_St.alpha, M.M_Bed_R, 'LineStyle','-', 'color', prop.color.F_R);
plot(alpha_St.alpha, M.M_Bed_EM, 'LineStyle','-', 'color', prop.color.F_EM);
prop.ylimit = ylim;
% Interpolation um Winkel zu berechnen
interpolate = fnc_interpolation(alpha_St.alpha, M.M_Bed_EM, alpha_St.krit_geom);
plot(alpha_St.krit_geom, min(abs(interpolate.ans(1,:))), '*','color',prop.color.grey);
for index_txt = 1:length(interpolate.ans)
    if isequal(interpolate.ans(1,index_txt), min(abs(interpolate.ans(1,:))))
        txt = ['  ' num2str(round(interpolate.ans(1,index_txt),2)) ' Nm'];
        text(alpha_St.krit_geom, interpolate.ans(1,index_txt), ...
            txt, 'FontSize', 10, 'color',prop.color.grey, ...
            'FontWeight', 'normal', 'FontAngle', 'italic', ...
            'HorizontalAlignment','left','VerticalAlignment','middle');
    end
end
prop.delta = 0.025*sum(abs(prop.ylimit));
prop.xlimit = xlim;
prop.arrowlen = 0.13*sum(abs(prop.xlimit));
prop.legend = ["M_B_e_d_R", "M_B_e_d_E_M"];
drawArrow = @(x,y,varargin) quiver( x(1),y(1),x(2)-x(1),y(2)-y(1),0, varargin{:} );
if min(alpha_St.alpha) >= 0 || max(alpha_St.alpha) > -12
    drawArrow([prop.arrowlen,0.5],[prop.ylimit(2)-prop.delta,prop.ylimit(2)-prop.delta],'color',prop.color.grey,'MarkerFaceColor',prop.color.grey,...
        'MarkerEdgeColor','none','Marker','>','ShowArrowHead','off');
    text(1, prop.ylimit(2)-prop.delta, 'Steigung', 'FontSize', 8,'color',prop.color.grey, ...
        'FontWeight', 'bold', 'FontAngle', 'italic', ...
        'HorizontalAlignment','left','VerticalAlignment','top');
    legend(prop.legend,'Location','northeast');
end
if min(alpha_St.alpha) < 0
    drawArrow([-prop.arrowlen,-0.5],[prop.ylimit(2)-prop.delta,prop.ylimit(2)-prop.delta],'color',prop.color.grey,'MarkerFaceColor',prop.color.grey,...
        'MarkerEdgeColor','none','Marker','<','ShowArrowHead','off');
    text(-1, prop.ylimit(2)-prop.delta, 'Gefälle', 'FontSize', 8,'color',prop.color.grey, ...
        'FontWeight', 'bold', 'FontAngle', 'italic', ...
        'HorizontalAlignment','right','VerticalAlignment','top');
    drawArrow([0,0],ylim,'color',prop.color.grey,'ShowArrowHead','off', 'LineStyle','--');
    legend(prop.legend,'Location','southeast');
end
hold off;
title("Bedarfsmoment in Abhängigkeit der Straßensteigung" + " (" + zustand + ")");
ylabel("Moment [Nm]");
xlabel("Steigung [°]");
grid on;
M.M_Notw.gesamt = interpolate.ans;

% -------------------------------------------------------------------------
% Bedarfsleistung in Abhängigkeit der Straßensteigung
% -------------------------------------------------------------------------

figure;
hold on;
plot(alpha_St.alpha, P.P_Bed_R, 'LineStyle','-', 'color', prop.color.F_R);
plot(alpha_St.alpha, P.P_Bed_EM, 'LineStyle','-', 'color', prop.color.F_EM);
plot(alpha_St.alpha, P.P_Bed_Batt, 'LineStyle','-', 'color', prop.color.F_Batt);
plot(alpha_St.alpha, P.P_Bed_Entlade, 'LineStyle','-', 'color', prop.color.F_Entlade);
prop.ylimit = ylim;
% Interpolation um Winkel zu berechnen
interpolate = fnc_interpolation(alpha_St.alpha, P.P_Bed_EM, alpha_St.krit_geom);
plot(alpha_St.krit_geom, min(abs(interpolate.ans(1,:))), '*','color',prop.color.grey);
for index_txt = 1:length(interpolate.ans)
    if isequal(interpolate.ans(1,index_txt), min(abs(interpolate.ans(1,:))))
        txt = ['  ' num2str(round(interpolate.ans(1,index_txt),2)) ' W'];
        text(alpha_St.krit_geom, interpolate.ans(1,index_txt), ...
            txt, 'FontSize', 10, 'color',prop.color.grey, ...
            'FontWeight', 'normal', 'FontAngle', 'italic', ...
            'HorizontalAlignment','left','VerticalAlignment','middle');
    end
end
prop.delta = 0.025*sum(abs(prop.ylimit));
prop.xlimit = xlim;
prop.arrowlen = 0.13*sum(abs(prop.xlimit));
prop.legend = ["P_B_e_d_R", "P_B_e_d_E_M", "P_B_e_d_B_a_t_t", "P_B_e_d_E_n_t_l_a_d_e"];
drawArrow = @(x,y,varargin) quiver( x(1),y(1),x(2)-x(1),y(2)-y(1),0, varargin{:} );
if min(alpha_St.alpha) >= 0 || max(alpha_St.alpha) > -12
    drawArrow([prop.arrowlen,0.5],[prop.ylimit(2)-prop.delta,prop.ylimit(2)-prop.delta],'color',prop.color.grey,'MarkerFaceColor',prop.color.grey,...
        'MarkerEdgeColor','none','Marker','>','ShowArrowHead','off');
    text(1, prop.ylimit(2)-prop.delta, 'Steigung', 'FontSize', 8,'color',prop.color.grey, ...
        'FontWeight', 'bold', 'FontAngle', 'italic', ...
        'HorizontalAlignment','left','VerticalAlignment','top');
    legend(prop.legend,'Location','northeast');
end
if min(alpha_St.alpha) < 0
    drawArrow([-prop.arrowlen,-0.5],[prop.ylimit(2)-prop.delta,prop.ylimit(2)-prop.delta],'color',prop.color.grey,'MarkerFaceColor',prop.color.grey,...
        'MarkerEdgeColor','none','Marker','<','ShowArrowHead','off');
    text(-1, prop.ylimit(2)-prop.delta, 'Gefälle', 'FontSize', 8,'color',prop.color.grey, ...
        'FontWeight', 'bold', 'FontAngle', 'italic', ...
        'HorizontalAlignment','right','VerticalAlignment','top');
    drawArrow([0,0],ylim,'color',prop.color.grey,'ShowArrowHead','off', 'LineStyle','--');
    legend(prop.legend,'Location','southeast');
end
hold off;
title("Bedarfsleistung in Abhängigkeit der Straßensteigung" + " (" + zustand + ")");
ylabel("Leistung [W]");
xlabel("Steigung [°]");
grid on;
P.P_Notw.gesamt = interpolate.ans;

% -------------------------------------------------------------------------
% Bedarfsenergie in Abhängigkeit der Straßensteigung
% -------------------------------------------------------------------------

figure;
hold on;
plot(alpha_St.alpha, E.E_Bed_R, 'LineStyle','-', 'color', prop.color.F_R);
plot(alpha_St.alpha, E.E_Bed_EM, 'LineStyle','-', 'color', prop.color.F_EM);
plot(alpha_St.alpha, E.E_Bed_Batt, 'LineStyle','-', 'color', prop.color.F_Batt);
plot(alpha_St.alpha, E.E_Bed_Entlade, 'LineStyle','-', 'color', prop.color.F_Entlade);
prop.ylimit = ylim;
prop.delta = 0.025*sum(abs(prop.ylimit));
prop.xlimit = xlim;
prop.arrowlen = 0.13*sum(abs(prop.xlimit));
prop.legend = ["E_B_e_d_R", "E_B_e_d_E_M", "E_B_e_d_B_a_t_t", "E_B_e_d_E_n_t_l_a_d_e"];
drawArrow = @(x,y,varargin) quiver( x(1),y(1),x(2)-x(1),y(2)-y(1),0, varargin{:} );
if min(alpha_St.alpha) >= 0 || max(alpha_St.alpha) > -12
    drawArrow([prop.arrowlen,0.5],[prop.ylimit(2)-prop.delta,prop.ylimit(2)-prop.delta],'color',prop.color.grey,'MarkerFaceColor',prop.color.grey,...
        'MarkerEdgeColor','none','Marker','>','ShowArrowHead','off');
    text(1, prop.ylimit(2)-prop.delta, 'Steigung', 'FontSize', 8,'color',prop.color.grey, ...
        'FontWeight', 'bold', 'FontAngle', 'italic', ...
        'HorizontalAlignment','left','VerticalAlignment','top');
    legend(prop.legend,'Location','northeast');
end
if min(alpha_St.alpha) < 0
    drawArrow([-prop.arrowlen,-0.5],[prop.ylimit(2)-prop.delta,prop.ylimit(2)-prop.delta],'color',prop.color.grey,'MarkerFaceColor',prop.color.grey,...
        'MarkerEdgeColor','none','Marker','<','ShowArrowHead','off');
    text(-1, prop.ylimit(2)-prop.delta, 'Gefälle', 'FontSize', 8,'color',prop.color.grey, ...
        'FontWeight', 'bold', 'FontAngle', 'italic', ...
        'HorizontalAlignment','right','VerticalAlignment','top');
    drawArrow([0,0],ylim,'color',prop.color.grey,'ShowArrowHead','off', 'LineStyle','--');
    legend(prop.legend,'Location','southeast');
end
hold off;
title("Bedarfsenergie in Abhängigkeit der Straßensteigung" + " (" + zustand + ")");
ylabel("Energie [Wh]");
xlabel("Steigung [°]");
grid on;

% -------------------------------------------------------------------------

fprintf("Diagramme geplottet.\n");

%% Komponentendimensionierung

fprintf("------------------\n");

fprintf("Maximale Drehzahl bei Geschwindigkeit v = " + v.v_Fzg_max + " km/h:\n" + ...
    "    n_R_max  = " + round(n.n_R_max,1) + " 1/min\n" + ...
    "    n_EM_max = " + round(n.n_EM_max,1) + " 1/min\n" + ...
    "\n");

fprintf("Drehzahl bei Geschwindigkeit v = " + v.v_Fzg + " km/h:\n" + ...
    "    n_R      = " + round(n.n_R,1) + " 1/min\n" + ...
    "    n_EM     = " + round(n.n_EM,1) + " 1/min\n" + ...
    "\n");

M.M_Notw.pro_Motor_v1_nabe = round(M.M_Notw.gesamt*i_Getr*i_Moment(1)*1E-2/2,3);
M.M_Notw.pro_Motor_v2_nabe = round(M.M_Notw.gesamt*i_Getr*i_Moment(2)*1E-2/2,3);
M.M_Notw.pro_Motor_h_nabe = round(M.M_Notw.gesamt*i_Getr*i_Moment(3)*1E-2/2,3);

M.M_Notw.pro_Motor_v1 = round(M.M_Notw.gesamt*i_Moment(1)*1E-2/2,3);
M.M_Notw.pro_Motor_v2 = round(M.M_Notw.gesamt*i_Moment(2)*1E-2/2,3);
M.M_Notw.pro_Motor_h = round(M.M_Notw.gesamt*i_Moment(3)*1E-2/2,3);

fprintf("Notwendiges Motormoment pro Rad jeder Achse:\n" + ... 
    "(alpha_St = " + round(alpha_St.krit_geom,1) + "°" + ", v = " + v.v_Fzg + " km/h)\n" + ...
    "    M_Rv1    = " + M.M_Notw.pro_Motor_v1_nabe + " Nm   x2\n" + ...
    "    M_Rv2    = " + M.M_Notw.pro_Motor_v2_nabe + " Nm   x2\n" + ...
    "    M_Rh     = " + M.M_Notw.pro_Motor_h_nabe + " Nm   x2\n" + ...
    "    Insgesamt notwendig " + round(M.M_Notw.gesamt * i_Getr,2) + " Nm\n" + ...
    "\n");

fprintf("Notwendiges Motormoment pro Motor jeder Achse:\n" + ... 
    "(alpha_St = " + round(alpha_St.krit_geom,1) + "°" + ", v = " + v.v_Fzg + " km/h" + ", i = " + i_Getr + ")\n" + ...
    "    M_v1     = " + M.M_Notw.pro_Motor_v1 + " Nm   x2\n" + ...
    "    M_v2     = " + M.M_Notw.pro_Motor_v2 + " Nm   x2\n" + ...
    "    M_h      = " + M.M_Notw.pro_Motor_h + " Nm   x2\n" + ...
    "    Insgesamt notwendig " + round(M.M_Notw.gesamt,2) + " Nm\n" + ...
    "\n");

P.P_Notw.pro_Motor_v1 = round(2*pi*n.n_EM/60*M.M_Notw.pro_Motor_v1,1);
P.P_Notw.pro_Motor_v2 = round(2*pi*n.n_EM/60*M.M_Notw.pro_Motor_v2,1);
P.P_Notw.pro_Motor_h = round(2*pi*n.n_EM/60*M.M_Notw.pro_Motor_h,1);

fprintf("Notwendige Motorleistung pro Motor jeder Achse:\n" + ...
    "(alpha_St = " + round(alpha_St.krit_geom,1) + "°" + ", v = " + v.v_Fzg + " km/h)\n" + ...
    "    P_v1     = " + P.P_Notw.pro_Motor_v1 + " W   x2\n" + ...
    "    P_v2     = " + P.P_Notw.pro_Motor_v2 + " W   x2\n" + ...
    "    P_h      = " + P.P_Notw.pro_Motor_h + " W   x2\n" + ...
    "    Insgesamt notwendig " + round(P.P_Notw.gesamt,2) + " W\n" );
% -------------------------------------------------------------------------

waitbar(1,wb,'Ergebnisse darstellen');
spreadfigures;
geom = orderfields(geom);
close(wb);
clear drawArrow index_txt interpolate prop txt wb;
fprintf("------------------\n");