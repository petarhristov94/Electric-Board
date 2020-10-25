%% Bedarfkennwerte

waitbar(0.6,wb,'Kräfte und Leistungen berechnen');

F_Bed = ( fRoll*m.m*konst.g*cosd(alpha_St.alpha) + ...  % Bedarfskraft am Rad       [N]
    m.m*konst.g*sind(alpha_St.alpha) + ...
    0.5*konst.c_w*konst.A_Fzg*konst.rho_Luft*(v.v/3.6)^2 + ...
    (konst.e_i*m.m_Fzg + m.m_Zul)*a_x ...
    )*(1+S);

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

F_Bed_Ebene = ( fRoll*m.m*konst.g*cosd(0) + ...         % Bed.-Kraft am Rad (Ebene) [N]
    m.m*konst.g*sind(0) + ...
    0.5*konst.c_w*konst.A_Fzg*konst.rho_Luft*(v.v_max/3.6)^2 + ...
    (konst.e_i*m.m_Fzg + m.m_Zul)*a_x ...
    )*(1+S);
M.M_Bed_R_Ebene = F_Bed_Ebene*r_dyn*1E-3;               % Bed.-Moment am Rad (Ebene)[Nm]
P.P_Bed_R_Ebene = F_Bed_Ebene*(v.v_Fzg_max/3.6);        % Bed.-Leistung Rad (Ebene) [Nm]
%% Horizontalkräfte (X-Richtung)

waitbar(0.7,wb,'Aufstandskräfte mit dem rechten Hand Regel am Linken bestimmen');

% dynamische Kräfte:
Fx.Fx_h = (i_Moment.current(3)/100)*F_Bed;
Fx.Fx_W = m.m*konst.g*sind(alpha_St.alpha) + m.m*a_x + ...
    fRoll*m.m*konst.g*cosd(alpha_St.alpha) + ...
    0.5*konst.c_w*konst.A_Fzg*konst.rho_Luft*(v.v/3.6)^2 - Fx.Fx_h;             % Schnittkraft X-Richtung    [N]
Fx.Fx_v2 = (i_Moment.current(2)/100)*F_Bed;
Fx.Fx_v1 = Fx.Fx_W - Fx.Fx_v2;
%% Vertikalkräfte (Z-Richtung)

% statsche Kräfte:
Fz.Fz_stat.Fz_h_stat = 1/(lv+lh)*(m.m*konst.g*lv);
Fz.Fz_stat.Fz_W_stat = m.m*konst.g - Fz.Fz_stat.Fz_h_stat;
Fz.Fz_stat.Fz_v1_stat = 1/(l1+l2)*(Fz.Fz_stat.Fz_W_stat*l2);
Fz.Fz_stat.Fz_v2_stat = Fz.Fz_stat.Fz_W_stat - Fz.Fz_stat.Fz_v1_stat;

% dynamische Kräfte:
Fz.Fz_dyn.Fz_W = 1/(lv+lh)*( - m.m*konst.g*sind(alpha_St.alpha)*h_SP ...        % Schnittkraft Z-Richtung    [N]
    - m.m*a_x*h_SP + Fx.Fx_W*h_W + m.m*konst.g*cosd(alpha_St.alpha)*lh);
Fz.Fz_dyn.Fz_v1 = 1/(l1+l2)*( Fz.Fz_dyn.Fz_W*l2 - Fx.Fx_W*h_W);
Fz.Fz_dyn.Fz_v2 = Fz.Fz_dyn.Fz_W - Fz.Fz_dyn.Fz_v1;
Fz.Fz_dyn.Fz_h = m.m*konst.g*cosd(alpha_St.alpha) - Fz.Fz_dyn.Fz_W;

%% Kraftschluss

waitbar(0.8,wb,'ACHTUNG! RUTSCHGEFAHR!');

fR.fR_v1 = Fx.Fx_v1 ./ Fz.Fz_dyn.Fz_v1;
fR.fR_v2 = Fx.Fx_v2 ./ Fz.Fz_dyn.Fz_v2;
fR.fR_h = Fx.Fx_h ./ Fz.Fz_dyn.Fz_h;

%% Interpolations

% Interpolation um Winkel bei Geometrie zu berechnen
interpolate.intrplt_geom = fnc_interpolation(Fz.Fz_dyn, alpha_St.alpha, 0);
alpha_St.krit_geom = min(interpolate.intrplt_geom.ans(interpolate.intrplt_geom.ans>0));

% Interpolation um Winkel bei Kraftschluss zu berechnen
interpolate.intrplt_krit = fnc_interpolation(fR, alpha_St.alpha, konst.mu);
alpha_St.krit_fR = min(interpolate.intrplt_krit.ans(interpolate.intrplt_krit.ans>0));

% Interpolation um Moment zu berechnen
interpolate.intrplt_M = fnc_interpolation(alpha_St.alpha, M.M_Bed_EM, alpha_St.krit_fR);
M.M_Notw.gesamt_getr = interpolate.intrplt_M.ans;

% Interpolation um Leistung zu berechnen
interpolate.intrplt_P = fnc_interpolation(alpha_St.alpha, P.P_Bed_EM, alpha_St.krit_fR);
P.P_Notw.gesamt = interpolate.intrplt_P.ans;

%% Komponentendimensionierung

M.M_Notw.Nabe_Ebene = round(M.M_Bed_R_Ebene*max(i_Moment.current)*1E-2/2,3);
M.M_Notw.pro_Motor_getr_Ebene = round(M.M_Bed_R_Ebene/i_Getr*max(i_Moment.current)*1E-2/2,3);
P.P_Notw.Nabe_Ebene = round(2*pi*n.n_R_max/60*M.M_Notw.Nabe_Ebene,1);

M.M_Notw.Nabe = round(M.M_Notw.gesamt_getr*i_Getr*max(i_Moment.current)*1E-2/2,3);
M.M_Notw.pro_Motor_getr = round(M.M_Notw.gesamt_getr*max(i_Moment.current)*1E-2/2,3);
P.P_Notw.Nabe = round(2*pi*n.n_R/60*M.M_Notw.Nabe,1);

% -------------------------------------------------------------------------