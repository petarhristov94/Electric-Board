%% Motor-Datenblatt
i_Getr = 21;

mot.V_Nenn      = 24;                   % Nennspannung                      [V]
mot.n_0     	= 4300;                 % Leerlaufdrehzahl                  [1/min]
mot.n_Nenn     	= 3240;                 % Nenndrehzahl                      [1/min]
mot.M_Nenn      = 0.536;                % Nennmoment (max. Dauerdrehmoment) [Nm]
mot.M_halt      = 4.30;                 % Anhaltemoment                     [Nm]
mot.I_0         = 0.497;                % Leerlaufstrom                     [A]
mot.I_Nenn      = 9.28;                 % Nennstrom (max. Dauerstrom)       [A]
mot.I_Anlauf    = 81.9;                 % Anlaufstrom                       [A]
mot.eta_EM      = 0.852;                % Max. Wirkungsgrad                 [-]

mot.R_Anschl    = 0.293;                % Anschlusswiderstand               [Ohm]
mot.L_Anschl    = 0.279     *1E-3;      % Anschlussinduktivität             [H]
mot.M_Konst     = 52.5      *1E-3;      % Drehmomentkonstante               [Nm/A]
mot.n_Konst     = 182;                  % Drehzahlkonstante                 [1/min*V]
mot.Kennsteig   = 1.01      *1E3;       % Kennliniensteigung                [1/min / Nm]
mot.t_Anlauf    = 8.83      *1E-3;      % Mechanische Anlaufzeitkonstante   [s]
mot.O_Mot       = 832       *1E-5;      % Rotorträgheitsmoment              [kg*m²]

mot.n_Grenz     = 6000;                 % Grenzdrehzahl                     [1/min]
mot.F_ax_dyn    = 12;                   % Max. axiale Belastung (dynamisch) [N]
mot.F_ax_stat   = 170;                  % Max. axiale Belastung (statisch)  [N]
mot.F_rad       = 112;                  % Max. radiale Bel. (5mm ab Flansch)[N]

mot.polpaar     = 7;                    % Polpaarzahl                       [-]
mot.phasen      = 3;                    % Anzahl Phasen                     [-]
mot.m_EM        = 0.360;                % Motorgewicht                      [kg]

mot.d_Ab        = 8;                    % Abtrieb-Wellendurchmesser         [mm]
mot.l_Ab        = 23.1 - 2.8;           % Abtrieb-Wellenlänge               [mm]
mot.l_Ab_Nut    = 2.8;                  % Abtrieb-Wellennutlänge            [mm]
mot.l_G         = 45.5;                 % Motorlänge (Gehäuse)              [mm]
mot.d_G         = 60;                   % Motoraußendurchmesser (Gehäuse)   [mm]
mot.P_Nenn      = 200;                  % Motorleistung                     [W]

%% Getriebe-Datenblatt

getr.i          = 13/3;                 % Getriebeübersetzung               [-]
getr.O_Getr     = 12        *1E-5;      % Massenträgheitsmoment             [kg*m²]
getr.M_Dauer    = 4;                    % Max. Dauerdrehmoment              [Nm]
getr.M_Kurz     = 6;                    % Kurzzeitig zul. Dauerdrehmoment   [Nm]
getr.eta_Getr   = 0.91;                 % Max. Wirkungsgrad                 [-]
getr.m_Getr     = 0.460;                % Gewicht                           [kg]
getr.spiel      = 0.6;                  % Mittleres Getriebespiel (unbel.)  [°]

getr.d_Ab       = 12;                   % Abtrieb-Wellendurchmesser         [mm]
getr.l_Ab       = 29.5 - 3.15;          % Abtrieb-Wellenlänge               [mm]
getr.l_Ab_Nut   = 3.15;                 % Abtrieb-Wellennutlänge            [mm]
getr.l_G        = 49;                   % Getriebelänge (Gehäuse)           [mm]
getr.d_G        = 52;                   % Getrieaußendurchmesser (Gehäuse)  [mm]

getr.n_Grenz    = 6000;                 % Grenzdrehzahl                     [1/min]
getr.F_ax_dyn   = 200;                  % Max. axiale Belastung (dynamisch) [N]
getr.F_ax_aufp  = 500;                  % Max. axiale Aufpresskraft         [N]
getr.F_rad      = 420;                  % Max. radiale Be. (12mm ab Flansch)[N]
getr.Drehsinn   = 1;                    % Drehsinn, An. zu Ab. (gleich = 1) [-]

%% Berechnung der Antriebskette: Motorseite

an.i_kette      = i_Getr/getr.i;        % Übersetzung dieser Stufe          [-]
an.kette.p_Kette= 9.525;                % Teilung der Kette                 [mm]
an.kette.dr     = 6.35;                 % Rollendurchmesser                 [mm]
an.kette.F_zul  = 8880;                 % ISO Bruchkraft                    [N]
an.kette.q      = 0.39;                 % Massenbelegung                    [kg/m]

% Geometrieberechnung
an.a_0          = 50;                   % geometrischer Achsabstand         [mm]
an.z_Mot        = 13;                   % Zähnezahl Kettentrieb am Motor    [-]
% 13 bis 14 Zähne geeignet für Kettengeschwindigkeiten unter 3 m/s. Quelle:
% https://www.schweizer-fn.de/maschinenelemente/kettenantrieb/kettenantrieb.php

an.z_Ab         = round(an.z_Mot * an.i_kette);                                         % Zähnezahl Kettenscheibe Abtrieb       [-]
an.i_kette      = an.z_Ab/an.z_Mot;

% Antrieb
an.Motor.phi    = 360/an.z_Mot;                                                         % Teilungswinkel des Antriebs [°]
an.Motor.d_0    = an.kette.p_Kette/sind(an.Motor.phi/2);                                % Teilkreisdurchmesser (Antrieb)        [mm]
an.Motor.d_max  = an.Motor.d_0;
an.Motor.d_min  = an.Motor.d_0*cosd(an.Motor.phi/2);
an.Motor.h      = 0.5*(an.Motor.d_max - an.Motor.d_max*cosd(an.Motor.phi/2));           % Höhe der transv. Schwingungsanregung  [mm]
an.Motor.n      = n.n_EM/getr.i;                                                        % Drehzahl (Antrieb)                    [1/min]
an.Motor.v_max  = pi*an.Motor.n/60*an.Motor.d_max*1E-3;                                 % min. Kettengeschwindigkeit (Antrieb)  [m/s]
an.Motor.v_min  = pi*an.Motor.n/60*an.Motor.d_max*1E-3*cosd(an.Motor.phi/2);            % max. Kettengeschwindigkeit (Antrieb)  [m/s]
an.Motor.Ungleichfoermigkeit = (1-cosd(an.Motor.phi/2))*100;                            % Ungleichförmigkeit des Antriebs       [%]
an.Motor.v      = 0.5*an.Motor.d_0*1E-3*2*pi*an.Motor.n/60;

% Abtrieb
an.Abtrieb.phi  = 360/an.z_Ab;                                                          % Teilungswinkel des Abtriebs [°]
an.Abtrieb.d_0  = an.kette.p_Kette/sind(an.Abtrieb.phi/2);                              % Teilkreisdurchmesser (Abtrieb)        [mm]
an.Abtrieb.d_max= an.Abtrieb.d_0;
an.Abtrieb.d_min= an.Abtrieb.d_0*cosd(an.Abtrieb.phi/2);
an.Abtrieb.h    = 0.5*(an.Abtrieb.d_max - an.Abtrieb.d_max*cosd(an.Abtrieb.phi/2));     % Höhe der transv. Schwingungsanregung  [mm]
an.Abtrieb.n    = n.n_EM/(getr.i*an.i_kette);                                           % Drehzahl (Abtrieb)                    [1/min]
an.Abtrieb.v_max= pi*an.Abtrieb.n/60*an.Abtrieb.d_max*1E-3;                             % min. Kettengeschwindigkeit (Abtrieb)  [m/s]
an.Abtrieb.v_min= pi*an.Abtrieb.n/60*an.Abtrieb.d_max*1E-3*cosd(an.Abtrieb.phi/2);      % max. Kettengeschwindigkeit (Abtrieb)  [m/s]
an.Abtrieb.Ungleichfoermigkeit = (1-cosd(an.Abtrieb.phi/2))*100;                        % Ungleichförmigkeit des Abtriebs       [%]
an.Abtrieb.v    = 0.5*an.Abtrieb.d_0*1E-3*2*pi*an.Abtrieb.n/60;

if (an.a_0 < ((an.Motor.d_0+an.Abtrieb.d_0)/2))
    an.a_0 = (an.Motor.d_0+an.Abtrieb.d_0)/2 + 10;
    fprintf("Mindestwertunterschreitung! \n" + ...
        "Der Achsabstand wurde zu " + num2str(an.a_0) + " mm gesetzt.");
end

an.X            = ceil(2*an.a_0/an.kette.p_Kette + (an.z_Mot+an.z_Ab)/2 + ...           % Gliederzahl der Kette                 [-]
                    ((an.z_Ab-an.z_Mot)/(2*pi))^2 * an.kette.p_Kette/an.a_0);
if mod(an.X,2)==1
    an.X = an.X - 1;
end

an.a            = an.kette.p_Kette/4 * (an.X - (an.z_Mot+an.z_Ab)/2 + ...               % tatsächlicher Achsabstand             [mm]
                    sqrt( (an.X - (an.z_Mot+an.z_Ab)/2)^2 - 2*((an.z_Ab-an.z_Mot)/pi)^2 ));
an.L            = an.X * an.kette.p_Kette;                                              % Lasttrumlänge                         [mm]
an.L_W          = an.X * an.kette.p_Kette * (1 + 1/1000);                               % Ketten-Wirklänge                      [mm]

an.kette.f_1 = 1.45;    % z_an = 13
an.kette.f_2 = 0.92;    % i ~ 5
an.kette.f_3 = 1;       % Stoßfreier Betrieb (E-Motor)
an.kette.f_4 = 1.18;    % a/p = 20 (minimal)
an.kette.f_5 = 1.4;     % mangelhafte Schmierung ohne Verschmutzung
an.kette.f_6 = 1/( (0.584/(   1/(an.z_Mot + 1/an.z_Ab)* (1E3/an.X)   ))^(1/3) );

an.kette.f_G = an.kette.f_1 * an.kette.f_2 * an.kette.f_3 * an.kette.f_4 * an.kette.f_5 * an.kette.f_6;
an.kette.P_D = P.P_Notw.Nabe * an.kette.f_G;

an.kette.U = P.P_Notw.Nabe / an.Abtrieb.v_max;
an.kette.U_f = an.kette.q * an.Abtrieb.v^2;
an.kette.F_ges = an.kette.U + an.kette.U_f;
an.kette.S_B = an.kette.F_zul/an.kette.F_ges;

an = orderfields(an);

%% Berechnung der Antriebskette: Lenkerseite

% DIN 8187 05B-1
ab.i_kette      = 1;                    % Übersetzung dieser Stufe          [-]
ab.kette.p_Kette= 8.00;                 % Teilung der Kette                 [mm]
ab.kette.dr     = 5.00;                 % Rollendurchmesser                 [mm]
ab.kette.F_zul  = 5000;                 % ISO Bruchkraft                    [N]
ab.kette.q      = 0.20;                 % Massenbelegung                    [kg/m]

% Geometrieberechnung
ab.a_0          = 200;                  % geometrischer Achsabstand         [mm]
ab.z_Mot        = 19;                   % Zähnezahl Kettentrieb am Motor    [-]
% Ungleichförmigkeit 1,4%. Vgl. MG Skript S.323/326

ab.z_Ab         = round(ab.z_Mot * ab.i_kette);                                         % Zähnezahl Kettenscheibe Abtrieb       [-]
ab.i_kette      = ab.z_Ab/ab.z_Mot;

% Antrieb
ab.Welle.phi    = 360/ab.z_Mot;                                                         % Teilungswinkel des Antriebs [°]
ab.Welle.d_0    = ab.kette.p_Kette/sind(ab.Welle.phi/2);                                % Teilkreisdurchmesser (Antrieb)        [mm]
ab.Welle.d_max  = ab.Welle.d_0;
ab.Welle.d_min  = ab.Welle.d_0*cosd(ab.Welle.phi/2);
ab.Welle.h      = 0.5*(ab.Welle.d_max - ab.Welle.d_max*cosd(ab.Welle.phi/2));           % Höhe der transv. Schwingungsanregung  [mm]
ab.Welle.n      = n.n_EM/(getr.i*an.i_kette);                                           % Drehzahl (Antrieb)                    [1/min]
ab.Welle.v_max  = pi*ab.Welle.n/60*ab.Welle.d_max*1E-3;                                 % min. Kettengeschwindigkeit (Antrieb)  [m/s]
ab.Welle.v_min  = pi*ab.Welle.n/60*ab.Welle.d_max*1E-3*cosd(ab.Welle.phi/2);            % max. Kettengeschwindigkeit (Antrieb)  [m/s]
ab.Welle.Ungleichfoermigkeit = (1-cosd(ab.Welle.phi/2))*100;                            % Ungleichförmigkeit des Antriebs       [%]
ab.Welle.v      = 0.5*ab.Welle.d_0*1E-3*2*pi*ab.Welle.n/60;

% Abtrieb
ab.Rad.phi      = 360/ab.z_Ab;                                                          % Teilungswinkel des Abtriebs [°]
ab.Rad.d_0      = ab.kette.p_Kette/sind(ab.Rad.phi/2);                                  % Teilkreisdurchmesser (Abtrieb)        [mm]
ab.Rad.d_max    = ab.Rad.d_0;
ab.Rad.d_min    = ab.Rad.d_0*cosd(ab.Rad.phi/2);
ab.Rad.h        = 0.5*(ab.Rad.d_max - ab.Rad.d_max*cosd(ab.Rad.phi/2));                 % Höhe der transv. Schwingungsanregung  [mm]
ab.Rad.n        = n.n_EM/(getr.i*an.i_kette*ab.i_kette);                                % Drehzahl (Abtrieb)                    [1/min]
ab.Rad.v_max    = pi*ab.Rad.n/60*ab.Rad.d_max*1E-3;                                     % min. Kettengeschwindigkeit (Abtrieb)  [m/s]
ab.Rad.v_min    = pi*ab.Rad.n/60*ab.Rad.d_max*1E-3*cosd(ab.Rad.phi/2);                  % max. Kettengeschwindigkeit (Abtrieb)  [m/s]
ab.Rad.Ungleichfoermigkeit = (1-cosd(ab.Rad.phi/2))*100;                                % Ungleichförmigkeit des Abtriebs       [%]
ab.Rad.v        = 0.5*ab.Rad.d_0*1E-3*2*pi*ab.Rad.n/60;

if (ab.a_0 < ((ab.Welle.d_0+ab.Rad.d_0)/2))
    ab.a_0 = (ab.Welle.d_0+ab.Rad.d_0)/2 + 10;
    fprintf("Mindestwertunterschreitung! \n" + ...
        "Der Achsabstand wurde zu " + num2str(ab.a_0) + " mm gesetzt.");
end

ab.X            = ceil(2*ab.a_0/ab.kette.p_Kette + (ab.z_Mot+ab.z_Ab)/2 + ...           % Gliederzahl der Kette                 [-]
                    ((ab.z_Ab-ab.z_Mot)/(2*pi))^2 * ab.kette.p_Kette/ab.a_0);
if mod(ab.X,2)==1
    ab.X = ab.X - 1;
end

ab.a            = ab.kette.p_Kette/4 * (ab.X - (ab.z_Mot+ab.z_Ab)/2 + ...               % tatsächlicher Achsabstand             [mm]
                    sqrt( (ab.X - (ab.z_Mot+ab.z_Ab)/2)^2 - 2*((ab.z_Ab-ab.z_Mot)/pi)^2 ));
ab.L            = ab.X * ab.kette.p_Kette;                                              % Lasttrumlänge                         [mm]
ab.L_W          = ab.X * ab.kette.p_Kette * (1 + 1/1000);                               % Ketten-Wirklänge                      [mm]

% MG Skript S.326-327
ab.kette.f_1    = 1;        % z_an = 19
ab.kette.f_2    = 1.22;     % i = 1
ab.kette.f_3    = 1;        % Stoßfreier Betrieb (E-Motor)
ab.kette.f_4    = 1.18;     % a/p = 20 (minimal)
ab.kette.f_5    = 1.4;      % mangelhafte Schmierung ohne Verschmutzung
ab.kette.f_6    = 1/( (0.584/(   1/(ab.z_Mot + 1/ab.z_Ab)* (1E3/ab.X)   ))^(1/3) );

ab.kette.f_G    = ab.kette.f_1 * ab.kette.f_2 * ab.kette.f_3 * ab.kette.f_4 * ab.kette.f_5 * ab.kette.f_6;
ab.kette.P_D    = P.P_Notw.Nabe * ab.kette.f_G;

ab.kette.U      = P.P_Notw.Nabe / ab.Rad.v_max;
ab.kette.U_f    = ab.kette.q * ab.Rad.v^2;
ab.kette.F_ges  = ab.kette.U + ab.kette.U_f;
ab.kette.S_B    = ab.kette.F_zul/ab.kette.F_ges;

ab = orderfields(ab);
