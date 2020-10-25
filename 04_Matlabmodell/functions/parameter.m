%% Parameter

wb = waitbar(0,'Konstanten ausdenken');
fprintf("------------------\n");

konst.g         = 9.81;                 % Erdbeschleunigung                 [m/s^2]
konst.mu        = 0.8;                  % max. Reibkoeffizient auf Asphalt  [-]
m.m_Fzg         = 10;                   % Fahrzeugleermasse                 [kg]
m.m_Zul_max     = 95;                   % max. Zuladungsmasse               [kg]
m.m             = 0;                    % Gesamtmasse Fzg.                  [kg]
r_dyn           = 40;                   % dyn. Radhalbmesser                [mm]
fRoll           = 0.05;                 % Radwiderstandsbeiwert             [-]
alpha_St.max    = 45;                   % max. Steigungswinkel              [°]
alpha_St.alpha  = ...
    linspace(-alpha_St.max, ...
    alpha_St.max, ...
    (2*alpha_St.max+1));                % Steigungswinkel                   [°]
konst.p_max     = 0;                    % max. Straßensteigung              [%]
konst.p         = 0;                    % Straßensteigung                   [%]
konst.rho_Luft  = 1.225;                % Luftdichte                        [kg/m^3]        // [PIS16] S.63; Kap. 3.2.1; Normalbedingungen p=1013 hPa, t=10°C
konst.A_Fzg     = 1.2;                  % Querspantfläche von Fzg.          [m^2]
konst.c_w       = 0.78;                 % Luftwiderstandsbeiwert            [-]             // [TRZ17] S.256; Tab. D.3; Omnibus 0,6-0,7
v.v_Wind        = 0;                    % Windgeschwindigkeit               [km/h]
                                        % -->(negativ in Fahrtrichtung)
v.v             = 0;                    % Relativgeschwindigkeit            [km/h]
v.v_max         = 0;                    % max. Relativgeschwindigkeit       [km/h]
v.v_Fzg         = 3;                    % Fahrzeuggeschwindigkeit           [km/h]
v.v_Fzg_max     = 6;                    % max. Fzg-Geschwindigkeit          [km/h]
a_x             = 0;                    % min. Längsbeschleunigung          [m/s^2]
konst.O_red     = 0;                    % red. Massenträgheitsmoment        [kg*m^2]
konst.e_i       = 0;                    % Massenfaktor                      [-]
i_Getr          = 3.750;                % Getriebeübersetzung               [-]
% i_Moment.current= [30, 20, 50];         % Momentaufteilung                  [%]
                                        % -->(v1, v2, h)
eta.Motor       = 0.90;                 % Wirkungsgrad des Elektromotors    [-]
eta.Batt    	= 0.90;                 % Wirkungsgrad der Batterie         [-]
eta.mech_ges    = 0.80;                 % mechanischer Gesamtwirkungsgrad   [-]
eta.el_ges      = eta.Motor*eta.Batt;   % elektrischer Gesamtwirkungsgrad   [-]
P.P_Nebenaggr   = 18;                   % Bedarfsleistung der Nebenaggregate[W]
k_Raeder        = 4;                    % Anzahl Räder                      [-]
s_Rampe         = 8;                    % durchschnittliche Rampenlänge     [m]
t.t_Besteigung  = 0;                    % Besteigungsdauer                  [s]
t.t_Bordstein   = 3;                    % Bordstein-Besteigungsdauer        [s]
t.t_inf         = 4.8 /60;              % max. Fahrtdauer                   [min]
S               = 0.0;                  % Sicherheitsfaktor                 [-]

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
konst.p = tand(alpha_St.alpha);
konst.p_max = tand(alpha_St.max);
konst.e_i = konst.O_red/(m.m_Fzg*(r_dyn*1E-3)^2) + 1;
v.v = v.v_Fzg + v.v_Wind;
v.v_max = v.v_Fzg_max + v.v_Wind;
t.t_Besteigung = s_Rampe/v.v_Fzg_max*3.6;