close all;
clear all;
clc;

variation = 3;

addpath([pwd, '\functions']);
%% Parameter

wb = waitbar(0,'Naturkonstanten ausdenken');

g               = 9.81;                 % Erdbeschleunigung                 [m/s^2]
mu              = 0.8;                  % max. Reibkoeffizient auf Asphalt  [-]
m.m_Fzg         = 20;                   % Fahrzeugleermasse                 [kg]
m.m_Zul         = 60;                   % Zuladungsmasse                    [kg]
m.m             = 0;                    % Gesamtmasse Fzg.                  [kg]
r_dyn           = 85;                   % dyn. Radhalbmesser                [mm]
fRoll           = 0.015;                % Rollwiderstandsbeiwert            [-]
alpha_St.max    = 45;                   % max. Steigungswinkel              [°]
alpha_St.alpha  = linspace(-45,45,180); % Steigungswinkel                   [°]
p_max           = 0;                    % max. Straßensteigung              [%]
p               = 0;                    % Straßensteigung                   [%]
rho_Luft        = 1.2;                  % Luftdichte                        [kg/m^3]
A_Fzg           = 2;                    % Querspantfläche von Fzg.          [m^2]
c_w             = 0.95;                 % Luftwiderstandsbeiwert            [-]
v.v_Wind        = 0;                    % Windgeschwindigkeit               [km/h]
                                        % -->(negativ in Fahrtrichtung)
v.v             = 0;                    % Relativgeschwindigkeit            [km/h]
v.v_Fzg         = 6;                    % Fahrzeuggeschwindigkeit           [km/h]
v.v_Fzg_max     = 12;                   % max. Fzg-Geschwindigkeit          [km/h]
a_x             = 0;                    % min. Längsbeschleunigung          [m/s^2]
O_red           = 0;                    % red. Massenträgheitsmoment        [kg*m^2]
e_i             = 0;                    % Massenfaktor                      [-]
i_Getr          = 26;                   % Getriebeübersetzung               [-]
i_Moment        = [35, 35, 30];         % Momentaufteilung                  [%]
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

waitbar(0.1,wb,'Zu viele Naturkonstanten ausgedacht');
lv              = 222.864   *1E-3;      % Schwerpunktrücklage               [m]
l1              = 152.875   *1E-3;      % Schwerpunktrücklage 1             [m]
l2              = 212.783   *1E-3;      % Schwerpunktrücklage 2             [m]
lh              = 334.297   *1E-3;      % Schwerpunktvorlage                [m]
h_W             = 200       *1E-3;      % Koppelpunkthöhe (Wippe)           [m]
waitbar(0.2,wb,'Einige löschen...');

for var_ind = 1:variation
    
    m.m = m.m_Fzg + m.m_Zul;
    p = tand(alpha_St.alpha);
    p_max = tand(alpha_St.max);
    e_i = O_red/(m.m_Fzg*(r_dyn*1E-3)^2) + 1;
    v.v = v.v_Fzg + v.v_Wind;
    t.t_Besteigung = s_Rampe/v.v_Fzg_max*3.6;
    
    waitbar(0.25,wb,'Dumme Fragen stellen');
    
    zustand = questdlg('Welcher Zustand soll betrachtet werden?','Fahrzustand bestimmen','beladen','nicht beladen','nicht beladen');
    if isequal(zustand,'beladen')
        h_SP    = 516       *1E-3;      % Schwerpunkthöhe                   [m]
    else
        h_SP    = 172       *1E-3;      % Schwerpunkthöhe                   [m]
    end
    fprintf("Parameter erfolgreich definiert.\n");
    
    %% Geometrie [mm]
    
    waitbar(0.4,wb,'Geometrie aus der 5. Klasse anwenden');
    
    geom.l_AE(var_ind) = h_W*1E3 - r_dyn;                 % [mm]
    geom.gamma1(var_ind) = real(atand(l1*1E3/geom.l_AE(var_ind)));
    geom.gamma2(var_ind) = real(atand(l2*1E3/geom.l_AE(var_ind)));
    geom.gamma(var_ind) = geom.gamma1(var_ind) + geom.gamma2(var_ind);
    geom.l_AB(var_ind) = geom.l_AE(var_ind)/cosd(geom.gamma1(var_ind));
    geom.l_AC(var_ind) = geom.l_AE(var_ind)/cosd(geom.gamma2(var_ind));
    geom.l_AD(var_ind) = (geom.l_AE(var_ind)^2 + (lv*1E3+lh*1E3)^2)^(1/2);
    geom.l_BC(var_ind) = (l1+l2)*1E3;
    geom.l_FG(var_ind) = 70;
    geom.l_DG(var_ind) = geom.l_AE(var_ind);
    geom.l_FD(var_ind) = (geom.l_FG(var_ind)^2 + geom.l_DG(var_ind)^2)^(1/2);
    geom.l_AF(var_ind) = lv*1E3 + lh*1E3 - geom.l_FG(var_ind);
    geom.delta(var_ind) = real(acosd((geom.l_AC(var_ind)^2 + geom.l_BC(var_ind)^2 - geom.l_AB(var_ind)^2)/(2*geom.l_AC(var_ind)*geom.l_BC(var_ind))));
    geom.h_Stufe(var_ind) = 200;
    geom.l_Stufe(var_ind) = 600;
    geom.gap(var_ind) = 15;
    geom.t(var_ind) = geom.l_BC(var_ind)/(geom.l_AC(var_ind)*sind(geom.delta(var_ind))) * (((r_dyn-geom.gap(var_ind))*cosd(geom.delta(var_ind)) + ...
        ((geom.l_AC(var_ind)^2 - (r_dyn-geom.gap(var_ind))^2)*sind(geom.delta(var_ind))^2)^(1/2))*cosd(geom.delta(var_ind)) - (r_dyn-geom.gap(var_ind)));
    
    
    if      ~(geom.l_BC(var_ind) > r_dyn * 2)
        fprintf("Problem: l_BC ist zu kurz. Beide Vorderräder kollidieren.\n");
    elseif  ~(geom.l_AD(var_ind) - r_dyn > geom.l_AC(var_ind) + r_dyn)
        fprintf("Problem: l_AD ist zu kurz. Hinter- und Mittelrad kollidieren.\n");
    elseif  ~(geom.l_AB(var_ind) + geom.l_AC(var_ind) >= geom.l_BC(var_ind))
        fprintf("Problem: l_BC zu kurz. Dreieck-Bedingung verletzt.\n");
    elseif  ~(geom.l_AC(var_ind) + geom.l_BC(var_ind) >= geom.l_AB(var_ind))
        fprintf("Problem: l_AB zu kurz. Dreieck-Bedingung verletzt.\n");
    elseif  ~(geom.l_BC(var_ind) + geom.l_AB(var_ind) >= geom.l_AC(var_ind))
        fprintf("Problem: l_AC zu kurz. Dreieck-Bedingung verletzt.\n");
    elseif  ~( ( (r_dyn + S*geom.l_Stufe(var_ind))^2 + (geom.h_Stufe(var_ind) + r_dyn - r_dyn)^2 )^(1/2) <= geom.l_BC(var_ind) )
        fprintf("Problem: l_BC=" + geom.l_BC(var_ind) + " muss länger als " + ((r_dyn + S*geom.l_Stufe(var_ind))^2 + ...
            (geom.h_Stufe(var_ind) + r_dyn - r_dyn)^2 )^(1/2) + "mm sein, damit das Hinderniss bestiegen werden kann.\n");
    elseif  ~( geom.l_BC(var_ind) <= ( ((1-S)*geom.l_Stufe(var_ind) - r_dyn)^2 + (r_dyn - r_dyn)^2 )^(1/2) )
        fprintf("Problem: l_BC=" + geom.l_BC(var_ind) + " muss kürzer als " + ...
            ( ((1-S)*geom.l_Stufe(var_ind) - r_dyn)^2 + (r_dyn - r_dyn)^2 )^(1/2) + " mm sein\n");
    elseif  ~(((geom.l_BC(var_ind)^2-geom.t(var_ind)^2)^(1/2)*sind(geom.delta(var_ind)) + ...
            geom.t(var_ind)*cosd(geom.delta(var_ind)))*geom.l_AC(var_ind)/geom.l_BC(var_ind) + r_dyn - geom.t(var_ind) >= (1+S)*geom.gap(var_ind))
        fprintf("Problem: that shit stuff");
    elseif  true
        fprintf("Keine Probleme mit der Geometrie gefunden.\n");
    end
    
    waitbar(0.5,wb,'Stufe "Geometrie-Guru" erreicht');
    
    %% Bedarfkennwerte
    
    waitbar(0.6,wb,'Kräfte und Leistungen berechnen');
    
    F_Bed(var_ind,:) = fRoll*m.m*g*cosd(alpha_St.alpha) + ...                        % Bedarfskraft am Rad       [N]
        m.m*g*sind(alpha_St.alpha) + ...
        0.5*c_w*A_Fzg*rho_Luft*(v.v/3.6)^2 + ...
        (e_i*m.m_Fzg + m.m_Zul)*a_x;
    
    M.M_Bed_R(var_ind,:) = F_Bed(var_ind,:)*r_dyn*1E-3;                           % Bedarfsmoment am Rad      [Nm]
    M.M_Bed_EM(var_ind,:) = (M.M_Bed_R(var_ind,:)/eta.mech_ges)/i_Getr;           % Bedarfsmoment am Motor    [Nm]
    M.M_UE_R(var_ind,:) = 0;                                           % Überschussmom. am Rad     [Nm]
    M.M_UE_EM(var_ind,:) = 0;                                          % Überschussmom. am Motor   [Nm]
    
    P.P_Bed_R(var_ind,:) = F_Bed(var_ind,:)*(v.v_Fzg/3.6);                        % Bedarfsleistung am Rad    [Nm]
    P.P_Bed_EM(var_ind,:) = P.P_Bed_R(var_ind,:)/eta.mech_ges;                    % Bedarfsleistung am Motor  [Nm]
    P.P_Bed_Batt(var_ind,:) = P.P_Bed_EM(var_ind,:)/eta.Motor + ...               % Bedarfsleistung am Rad    [Nm]
        P.P_Nebenaggr;
    P.P_Bed_Entlade(var_ind,:) = P.P_Bed_Batt(var_ind,:)/eta.Batt;                % Bed.-Leistung an der Batt [Nm]
    P.P_Bed_Zelle(var_ind,:) = 0;                                      % Notw. Entladeleistung     [Nm]
    
    E.E_Bed_R(var_ind,:) = P.P_Bed_R(var_ind,:)*t.t_inf/60;                       % Bedarfsenergie am Rad     [Wh]
    E.E_Bed_EM(var_ind,:) = P.P_Bed_EM(var_ind,:)*t.t_inf/60;                     % Bedarfsenergie am Motor   [Wh]
    E.E_Bed_Batt(var_ind,:) = P.P_Bed_Batt(var_ind,:)*t.t_inf/60;                 % Bed.-E. der Batt.-Klemmen [Wh]
    E.E_Bed_Entlade(var_ind,:) = P.P_Bed_Entlade(var_ind,:)*t.t_inf/60;           % Bed.-Energie an der Batt. [Wh]
    E.E_Bed_Zelle(var_ind,:) = 0;                                      % Bed.-Energie pro Zelle    [Wh]
    
    w_R(var_ind,:) = (v.v_Fzg/3.6)/(r_dyn*1E-3);                       % Radwinkelgeschwindigkeit  [1/s]
    n_R(var_ind,:) = w_R(var_ind,:)/(2*pi)*60;                                    % Raddrehzahl               [1/min]
    n_EM(var_ind,:) = round(n_R(var_ind,:)*i_Getr,0);                             % Motordrehzahl             [1/min]
    
    fprintf("Bedarfkennwerte erfolgreich errechnet.\n");
    
    %% Horizontalkräfte (X-Richtung)
    
    waitbar(0.7,wb,'Aufstandskräfte mit dem rechten Hand Regel am Linken bestimmen');
    
    % dynamische Kräfte:
    Fx.Fx_h(var_ind,:) = (i_Moment(3)/100)*F_Bed(var_ind,:);
    Fx.Fx_W(var_ind,:) = m.m*g*sind(alpha_St.alpha) + m.m*a_x + ...
        fRoll*m.m*g*cosd(alpha_St.alpha) + ...
        0.5*c_w*A_Fzg*rho_Luft*(v.v/3.6)^2 - Fx.Fx_h(var_ind,:);           % Schnittkraft X-Richtung    [N]
    Fx.Fx_v2(var_ind,:) = (i_Moment(2)/100)*F_Bed(var_ind,:);
    Fx.Fx_v1(var_ind,:) = Fx.Fx_W(var_ind,:) - Fx.Fx_v2(var_ind,:);
    %% Vertikalkräfte (Z-Richtung)
    
    % statsche Kräfte:
    Fz.Fz_stat.Fz_h_stat(var_ind,:) = 1/(lv+lh)*(m.m*g*lv);
    Fz.Fz_stat.Fz_W_stat(var_ind,:) = m.m*g - Fz.Fz_stat.Fz_h_stat(var_ind,:);
    Fz.Fz_stat.Fz_v1_stat(var_ind,:) = 1/(l1+l2)*(Fz.Fz_stat.Fz_W_stat(var_ind,:)*l2);
    Fz.Fz_stat.Fz_v2_stat(var_ind,:) = Fz.Fz_stat.Fz_W_stat(var_ind,:) - Fz.Fz_stat.Fz_v1_stat(var_ind,:);
    
    % dynamische Kräfte:
    Fz.Fz_dyn.Fz_W(var_ind,:) = 1/(lv+lh)*( - m.m*g*sind(alpha_St.alpha)*h_SP ...  % Schnittkraft Z-Richtung    [N]
        - m.m*a_x*h_SP + Fx.Fx_W(var_ind,:)*h_W + m.m*g*cosd(alpha_St.alpha)*lh);
    Fz.Fz_dyn.Fz_v1(var_ind,:) = 1/(l1+l2)*( Fz.Fz_dyn.Fz_W(var_ind,:)*l2 - Fx.Fx_W(var_ind,:)*h_W);
    Fz.Fz_dyn.Fz_v2(var_ind,:) = Fz.Fz_dyn.Fz_W(var_ind,:) - Fz.Fz_dyn.Fz_v1(var_ind,:);
    Fz.Fz_dyn.Fz_h(var_ind,:) = m.m*g*cosd(alpha_St.alpha) - Fz.Fz_dyn.Fz_W(var_ind,:);
    
    fprintf("Achslasten erfolgreich bestimmt.\n");
    
    %% Kraftschluss
    
    waitbar(0.8,wb,'ACHTUNG! RUTSCHGEFAHR!');
    
    fR.fR_v1(var_ind,:) = Fx.Fx_v1(var_ind,:) ./ Fz.Fz_dyn.Fz_v1(var_ind,:);
    fR.fR_v2(var_ind,:) = Fx.Fx_v2(var_ind,:) ./ Fz.Fz_dyn.Fz_v2(var_ind,:);
    fR.fR_h(var_ind,:) = Fx.Fx_h(var_ind,:) ./ Fz.Fz_dyn.Fz_h(var_ind,:);
    
    fprintf("Kraftschluss berechnet.\n");
    
end
%% Plot

waitbar(0.82,wb,'Bunte Bleistifte aus dem Euro-Laden kaufen');

prop.color.black = [0, 0, 0];
prop.color.grey = [0.5, 0.5, 0.5];
prop.color.blue = [0, 0.45, 0.74];
prop.color.orange = [1, 0.529, 0];
prop.color.red = [0.894, 0.118, 0.169];

% -------------------------------------------------------------------------
% Achslasten in Abhängigkeit der Straßensteigung
% -------------------------------------------------------------------------

waitbar(0.85,wb,'Malen....');

hold on;
for var_ind = 1:variation
    switch var_ind
        case 1
            linestyle = '-';
        case 2
            linestyle = '--';
        case 3
            linestyle = ':';
    end
    plot(alpha_St.alpha, Fz.Fz_dyn.Fz_W(var_ind,:), 'LineStyle',linestyle, 'color', prop.color.black);
    plot(alpha_St.alpha, Fz.Fz_dyn.Fz_v1(var_ind,:), 'LineStyle',linestyle, 'color', prop.color.red);
    plot(alpha_St.alpha, Fz.Fz_dyn.Fz_v2(var_ind,:), 'LineStyle',linestyle, 'color', prop.color.orange);
    plot(alpha_St.alpha, Fz.Fz_dyn.Fz_h(var_ind,:), 'LineStyle',linestyle, 'color', prop.color.blue);
end
% Interpolation um Winkel zu berechnen
% interpolate = fnc_interpolation(Fz.Fz_dyn, alpha_St.alpha, 0);
% plot(interpolate.ans(1,:), 0, '*','color',prop.color.grey);
% for index_txt = 1:length(interpolate.ans)
%     txt = ['  ' num2str(interpolate.ans(1,index_txt)) '°'];
%     text(interpolate.ans(1,index_txt), 0, ...
%         txt, 'FontSize', 10, 'color',prop.color.grey, ...
%         'FontWeight', 'normal', 'FontAngle', 'italic');
% end
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
% alpha_St.krit_geom = min(interpolate.ans(interpolate.ans>0));
% -------------------------------------------------------------------------
% Horzontalkräfte in Abhängigkeit der Straßensteigung
% -------------------------------------------------------------------------

waitbar(0.9,wb,'Malen..Malen...');

figure;
hold on;
for var_ind = 1:variation
    switch var_ind
        case 1
            linestyle = '-';
        case 2
            linestyle = '--';
        case 3
            linestyle = ':';
    end
    plot(alpha_St.alpha, Fx.Fx_W(var_ind,:), 'LineStyle',linestyle, 'color', prop.color.black);
    plot(alpha_St.alpha, Fx.Fx_v1(var_ind,:), 'LineStyle',linestyle, 'color', prop.color.red);
    plot(alpha_St.alpha, Fx.Fx_v2(var_ind,:), 'LineStyle',linestyle, 'color', prop.color.orange);
    plot(alpha_St.alpha, Fx.Fx_h(var_ind,:), 'LineStyle',linestyle, 'color', prop.color.blue);
end
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
for var_ind = 1:variation
    switch var_ind
        case 1
            linestyle = '-';
        case 2
            linestyle = '--';
        case 3
            linestyle = ':';
    end
    plot(alpha_St.alpha, fR.fR_v1(var_ind,:), linestyle, 'color', prop.color.red);
    plot(alpha_St.alpha, fR.fR_v2(var_ind,:), linestyle, 'color', prop.color.orange);
    plot(alpha_St.alpha, fR.fR_h(var_ind,:),  linestyle, 'color', prop.color.blue);
end
drawArrow([0 prop.xlimit(2)],[mu, mu],'color',prop.color.grey,'MarkerFaceColor',prop.color.grey,...
    'MarkerEdgeColor','none','ShowArrowHead','off','LineStyle','--');
text(1, mu, ['\mu = ',num2str(mu)], 'FontSize', 10,'color',prop.color.grey, ...
    'FontWeight', 'bold', 'FontAngle', 'italic', ...
    'HorizontalAlignment','left','VerticalAlignment','top');
ylim([-1,1]);
xlim([-25 25]);
% Interpolation um Winkel zu berechnen
% interpolate = fnc_interpolation(fR, alpha_St.alpha, mu);
% plot(min(abs(interpolate.ans(1,:))), mu, '*','color',prop.color.grey);
% for index_txt = 1:length(interpolate.ans)
%     if isequal(interpolate.ans(1,index_txt), min(abs(interpolate.ans(1,:))))
%         txt = ['  ' num2str(interpolate.ans(1,index_txt)) '°'];
%         text(interpolate.ans(1,index_txt), mu, ...
%             txt, 'FontSize', 10, 'color',prop.color.grey, ...
%             'FontWeight', 'normal', 'FontAngle', 'italic', ...
%             'HorizontalAlignment','left','VerticalAlignment','top');
%     end
% end
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
% alpha_St.krit_fR = min(interpolate.ans(interpolate.ans>0));

waitbar(1,wb,'Ergebnisse darstellen');

% -------------------------------------------------------------------------
spreadfigures;
fprintf("Diagramme geplottet.\n");
geom = orderfields(geom);
close(wb);
clear drawArrow index_txt interpolate prop txt wb;