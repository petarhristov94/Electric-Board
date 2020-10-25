%% Motor-Datenblatt
mot.V_Nenn      = 45;                   % Nennspannung                      [V]
mot.n_0     	= 8640;                 % Leerlaufdrehzahl                  [1/min]
mot.n_Nenn     	= 3240;                 % Nenndrehzahl                      [1/min]
mot.M_Nenn      = 1.59;                 % Nennmoment (max. Dauerdrehmoment) [Nm]
mot.M_halt      = 4.30;                 % Anhaltemoment                     [Nm]
mot.I_0         = 0.497;                % Leerlaufstrom                     [A]
mot.I_Nenn      = 30;                	% Nennstrom (max. Dauerstrom)       [A]
mot.I_Anlauf    = 81.9;                 % Anlaufstrom                       [A]
mot.eta_EM      = 0.852;                % Max. Wirkungsgrad                 [-]

mot.R_Anschl    = 0.87;                 % Anschlusswiderstand               [Ohm]
%mot.L_Anschl    = 0.279     *1E-3;      % Anschlussinduktivität             [H]
%mot.M_Konst     = 52.5      *1E-3;      % Drehmomentkonstante               [Nm/A]
mot.n_Konst     = 240;                  % Drehzahlkonstante                 [1/min*V]
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

%% Riemenberechnung: Motorseite

an.i_riemen     = 3.750;        % Übersetzung dieser Stufe          [-]

riemen.quest = questdlg('Wählen Sie eine Riemengröße aus?','Riemengröße auswählen','HTD 3M','HTD 5M','HTD 8M','HTD 3M');

switch(riemen.quest)
    case 'HTD 3M'
        fprintf("HTD 3M gewählt.\n");
        riemen.p_Riemen = 3;            % Teilung (Pitch)                   [mm]
        riemen.h_R      = 2.41;         % Riemenhöhe                        [mm]
        riemen.h_Z      = 1.22;         % Zahnhöhe                          [mm]
        riemen.h_p      = 0.381;        % Wirklinienabstand                 [mm]
    case 'HTD 5M'
        fprintf("HTD 5M gewählt.\n");
        riemen.p_Riemen = 5;            % Teilung (Pitch)                   [mm]
        riemen.h_R      = 3.81;         % Riemenhöhe                        [mm]
        riemen.h_Z      = 2.08;         % Zahnhöhe                          [mm]
        riemen.h_p      = 0.5715;       % Wirklinienabstand                 [mm]
    case 'HTD 8M'
        fprintf("HTD 8M gewählt.\n");
        riemen.p_Riemen = 8;            % Teilung (Pitch)                   [mm]
        riemen.h_R      = 5.59;         % Riemenhöhe                        [mm]
        riemen.h_Z      = 3.28;         % Zahnhöhe                          [mm]
        riemen.h_p      = 0.6858;       % Wirklinienabstand                 [mm]
    otherwise 
        fprintf("HTD 3M gewählt.\n");
        riemen.p_Riemen = 3;            % Teilung (Pitch)                   [mm]
        riemen.h_R      = 2.41;         % Riemenhöhe                        [mm]
        riemen.h_Z      = 1.22;         % Zahnhöhe                          [mm]
        riemen.h_p      = 0.381;        % Wirklinienabstand                 [mm]
end

% Riemen-Datenblatt
riemen.L        = 225;                  % nächstliegende Riemenlänge        [mm]
riemen.b        = 15;                   % Riemenbreite                      [mm]

riemen.z_Riemen = riemen.L / riemen.p_Riemen;                                   % Zähnezahl                             [-]
riemen.s        = riemen.h_R - riemen.h_Z;                                      % Riemendicke                           [mm]
riemen.A        = riemen.s * riemen.b;                                          % Riemenquerschnittsfläche              [mm²]


% Geometrieberechnung
an.a            = 52.2;                   % Achsabstand                       [mm]
an.z_Mot        = 16;                   % Zähnezahl Riemenscheibe am Motor  [-]

an.z_Ab         = ceil(an.z_Mot * an.i_riemen);                                 % Zähnezahl Riemenscheibe Abtrieb       [-]
%an.z_Ab         = 72;
an.i_riemen     = an.z_Ab/an.z_Mot;
an.n_1          = mot.n_0;                                                      % Drehzahl (Antrieb)                    [1/min]
an.n_2          = mot.n_0/an.i_riemen;                                          % Drehzahl (Abtrieb)                    [1/min]
an.d_1          = an.z_Mot * riemen.p_Riemen / pi - 2*riemen.h_p;               % Scheibendurchmesser (Antrieb)         [mm]
an.d_2          = an.z_Ab * riemen.p_Riemen / pi - 2*riemen.h_p;                % Scheibendurchmesser (Abtrieb)         [mm]
if (an.a < ((an.d_1+an.d_2)/2))
    an.a = (an.d_1+an.d_2)/2 + 10;
    fprintf("Mindestwertunterschreitung! \n" + ...
        "Der Achsabstand wurde zu " + num2str(an.a) + " mm gesetzt.");
end
an.beta         = abs(rad2deg(asin((an.d_2 - an.d_1)/(2 * an.a))));             % Trumneigungswinkel                    [°]
an.alpha_1      = 180 - 2*an.beta;                                              % Umschlingungswinkel (Antrieb)         [°]
an.alpha_2      = 180 + 2*an.beta;                                              % Umschlingungswinkel (Abtrieb)         [°]
an.v_Riemen     = pi*an.n_1/60*an.d_1*1E-3;                                     % Riemengeschwindigkeit (Antrieb)       [m/s]

an.L_W          = 2*an.a*cosd(an.beta) + pi*(an.d_1)*(180-2*an.beta)/360 ...    % Riemen-Wirklänge                      [mm]
                + pi*(an.d_2)*(180+2*an.beta)/360 ;                                         
an.L_1          = an.a * cosd(an.beta);                                         % Lasttrumlänge                         [mm]

an.z_eingriff_1 = floor( an.alpha_1/360*an.z_Mot);                              % Eingriffszähnezahl der Scheibe 1      [-]
an.z_eingriff_2 = floor( an.alpha_2/360*an.z_Ab);                               % Eingriffszähnezahl der Scheibe 2      [-]

an.Mot_konst_max = mot.M_Nenn;
an.Ab_konst_max = an.Mot_konst_max * an.i_riemen;








prop.color.black        = [0, 0, 0];

fig_motor.fig = figure;
hold on;
fig_motor.scheibe_1 = viscircles([  an.d_1/2         an.d_2/2 ] ,an.d_1/2);
fig_motor.scheibe_2 = viscircles([  (an.d_1/2+an.a)  an.d_2/2 ] ,an.d_2/2);

fig_motor.th_1 = linspace( pi - deg2rad(an.alpha_1/2), pi + deg2rad(an.alpha_1/2), 100);
plot((an.d_1/2 + riemen.s/2) * cos(fig_motor.th_1) + an.d_1/2, ...
    (an.d_1/2 + riemen.s/2) * sin(fig_motor.th_1) + an.d_2/2, ...
    'color', prop.color.black,'LineWidth',riemen.s);

fig_motor.th_2 = linspace( 2*pi + deg2rad(an.alpha_2/2), 2*pi - deg2rad(an.alpha_2/2), 100);
plot((an.d_2/2 + riemen.s/2) * cos(fig_motor.th_2) + (an.d_1/2+an.a), ...
    (an.d_2/2 + riemen.s/2) * sin(fig_motor.th_2) + an.d_2/2, ...
    'color', prop.color.black,'LineWidth',riemen.s);

fig_motor.trum_1(1,:) = [(an.d_1/2 + riemen.s/2) * cos(fig_motor.th_1(end)) + an.d_1/2, ...
    (an.d_1/2 + riemen.s/2) * sin(fig_motor.th_2(1)) + an.d_2/2];
fig_motor.trum_1(2,:) = [(an.d_2/2 + riemen.s/2) * cos(fig_motor.th_2(1)) + (an.d_1/2+an.a), ...
    (an.d_2/2 + riemen.s/2) * sin(fig_motor.th_2(1)) + an.d_2/2];
plot(fig_motor.trum_1(:,1),fig_motor.trum_1(:,2), 'color', prop.color.black,'LineWidth',riemen.s);

fig_motor.trum_2(1,:) = [(an.d_1/2 + riemen.s/2) * cos(fig_motor.th_1(1)) + an.d_1/2, ...
    (an.d_1/2 + riemen.s/2) * sin(fig_motor.th_2(end)) + an.d_2/2];
fig_motor.trum_2(2,:) = [(an.d_2/2 + riemen.s/2) * cos(fig_motor.th_2(end)) + (an.d_1/2+an.a), ...
    (an.d_2/2 + riemen.s/2) * sin(fig_motor.th_2(end)) + an.d_2/2];
plot(fig_motor.trum_2(:,1),fig_motor.trum_2(:,2), 'color', prop.color.black,'LineWidth',riemen.s);

plot([an.d_1/2 an.d_1/2+an.a],[an.d_2/2 an.d_2/2], 'LineStyle', '-.', 'color', prop.color.black)

plot([fig_motor.trum_2(1,1) (an.d_1/2)],[fig_motor.trum_2(1,2) (an.d_2/2)], 'LineStyle', ':', 'color', prop.color.black)
plot([fig_motor.trum_1(1,1) (an.d_1/2)],[fig_motor.trum_1(1,2) (an.d_2/2)], 'LineStyle', ':', 'color', prop.color.black)

plot([fig_motor.trum_2(2,1) (an.d_1/2+an.a)],[fig_motor.trum_2(2,2) (an.d_2/2)], 'LineStyle', ':', 'color', prop.color.black)
plot([fig_motor.trum_1(2,1) (an.d_1/2+an.a)],[fig_motor.trum_1(2,2) (an.d_2/2)], 'LineStyle', ':', 'color', prop.color.black)


text((an.d_1/2), (an.d_2/2), ...
    [' \alpha_1 = ', num2str(round(an.alpha_1,1)), '° '], ...
    'FontSize', 10, 'color',prop.color.black, ...
    'HorizontalAlignment','left','VerticalAlignment','top');
text((an.d_1/2+an.a), (an.d_2/2), ...
    [' \alpha_2 = ', num2str(round(an.alpha_2,1)), '° '], ...
    'FontSize', 10, 'color',prop.color.black, ...
    'HorizontalAlignment','right','VerticalAlignment','top');

text((an.d_1/2 + an.a/2), (an.d_2/2), ...
    ['a = ', num2str(an.a), ' mm'], ...
    'FontSize', 10, 'color',prop.color.black, ...
    'HorizontalAlignment','center','VerticalAlignment','bottom');

text((an.d_1/2), (an.d_2/2-an.d_1/2-riemen.s), ...
    {['treibend'],['M_A_n = ', num2str(round(an.Mot_konst_max,2)), ' Nm'],['n_1 = ', num2str(round(an.n_1,2)), ' min^-^1'],['z = ', num2str(an.z_Mot),'; z_e = ', num2str(an.z_eingriff_1)]}, ...
    'FontSize', 10, 'color',prop.color.black, ...
    'HorizontalAlignment','right','VerticalAlignment','top');
text((an.d_1/2 + an.a), (0-riemen.s), ...
    {['getrieben'],['M_A_b = ', num2str(round(an.Ab_konst_max,2)), ' Nm'],['n_2 = ', num2str(round(an.n_2,2)), ' min^-^1'],['z = ', num2str(an.z_Ab),'; z_e = ', num2str(an.z_eingriff_2)]}, ...
    'FontSize', 10, 'color',prop.color.black, ...
    'HorizontalAlignment','right','VerticalAlignment','top');

text((an.d_1/2), (an.d_2/2), ...
    [' \od_1= ', num2str(round(an.d_1,2)), ' mm '], ...
    'FontSize', 10, 'color',prop.color.black, ...
    'HorizontalAlignment','left','VerticalAlignment','bottom');
text((an.d_1/2+an.a), (an.d_2/2), ...
    [' \od_2= ', num2str(round(an.d_2,2)), ' mm '], ...
    'FontSize', 10, 'color',prop.color.black, ...
    'HorizontalAlignment','left','VerticalAlignment','bottom');

text((0), (an.d_2), ...
    {['i = ', num2str(an.i_riemen)],['L_W = ', num2str(an.L_W), ' mm'],['\beta = ', num2str(round(an.beta,1)), '°']}, ...
    'FontSize', 10, 'color',prop.color.black, ...
    'HorizontalAlignment','left','VerticalAlignment','bottom');

title(riemen.quest);
xlim([-an.d_2*0.25 (an.d_1+an.a+an.d_2/2)]);
axis equal;
set(gca, 'Xcolor', 'w', 'Ycolor', 'w')
set(gca, 'XTick', []);
set(gca, 'YTick', []);

%% Riemenberechnung: Lenkerseite
