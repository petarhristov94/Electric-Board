%% Plot

waitbar(0.82,wb,'Bunte Bleistifte aus dem Euro-Laden kaufen');
fprintf("------------------\n");

prop.color.white        = [1, 1, 1];
prop.color.black        = [0, 0, 0];

prop.color.F_W          = [0, 0, 0];
prop.color.F_h          = [0, 0.45, 0.74];
prop.color.F_v2         = [1, 0.529, 0];
prop.color.F_v1         = [0.894, 0.118, 0.169];
prop.color.grey         = [0.5, 0.5, 0.5];

prop.color.F_R          = [87/255, 24/255, 69/255];
prop.color.F_EM         = [144/255, 12/255, 62/255];
prop.color.F_Batt       = [199/255, 0/255, 57/255];
prop.color.F_Entlade    = [255/255, 87/255, 51/255];

% -------------------------------------------------------------------------
% Achslasten in Abhängigkeit der Straßensteigung
% -------------------------------------------------------------------------

waitbar(0.85,wb,'Malen....');

hold on;
plot(alpha_St.alpha, Fz.Fz_dyn.Fz_W, 'LineStyle',':', 'color', prop.color.F_W);
plot(alpha_St.alpha, Fz.Fz_dyn.Fz_v1, 'LineStyle','-', 'color', prop.color.F_v1);
plot(alpha_St.alpha, Fz.Fz_dyn.Fz_v2, 'LineStyle','-', 'color', prop.color.F_v2);
plot(alpha_St.alpha, Fz.Fz_dyn.Fz_h, 'LineStyle','-', 'color', prop.color.F_h);
plot(interpolate.intrplt_geom.ans(1,:), 0, '*','color',prop.color.grey);
for index_txt = 1:length(interpolate.intrplt_geom.ans)
    txt = ['  ' num2str(interpolate.intrplt_geom.ans(1,index_txt)) '°'];
    text(interpolate.intrplt_geom.ans(1,index_txt), 0, ...
        txt, 'FontSize', 10, 'color',prop.color.grey, ...
        'FontWeight', 'normal', 'FontAngle', 'italic');
end
prop.ylimit = ylim;
prop.delta = 0.025*sum(abs(prop.ylimit));
prop.xlimit = xlim;
prop.arrowlen = 0.13*sum(abs(prop.xlimit));
prop.legend = ["F_z_W", "F_z_v_1", "F_z_v_2", "F_z_h"];
axis.drawArrow = @(x,y,varargin) quiver( x(1),y(1),x(2)-x(1),y(2)-y(1),0, varargin{:} );
if min(alpha_St.alpha) >= 0 || max(alpha_St.alpha) > 0
    axis.drawArrow([prop.arrowlen,0.5],[prop.ylimit(2)-prop.delta,prop.ylimit(2)-prop.delta],'color',prop.color.grey,'MarkerFaceColor',prop.color.grey,...
        'MarkerEdgeColor','none','Marker','>','ShowArrowHead','off');
    text(1, prop.ylimit(2)-prop.delta, 'Steigung', 'FontSize', 8,'color',prop.color.grey, ...
        'FontWeight', 'bold', 'FontAngle', 'italic', ...
        'HorizontalAlignment','left','VerticalAlignment','top');
    legend(prop.legend,'Location','northeast');
end
if min(alpha_St.alpha) < 0
    axis.drawArrow([-prop.arrowlen,-0.5],[prop.ylimit(2)-prop.delta,prop.ylimit(2)-prop.delta],'color',prop.color.grey,'MarkerFaceColor',prop.color.grey,...
        'MarkerEdgeColor','none','Marker','<','ShowArrowHead','off');
    text(-1, prop.ylimit(2)-prop.delta, 'Gefälle', 'FontSize', 8,'color',prop.color.grey, ...
        'FontWeight', 'bold', 'FontAngle', 'italic', ...
        'HorizontalAlignment','right','VerticalAlignment','top');
    axis.drawArrow([0,0],ylim,'color',prop.color.grey,'ShowArrowHead','off', 'LineStyle','--');
    legend(prop.legend,'Location','southeast');
end
hold off;
title("Achslasten in Abhängigkeit der Straßensteigung" + " (" + zustand + ")");
ylabel("Kraft [N]");
xlabel("Steigung [°]");
grid on;

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
axis.drawArrow = @(x,y,varargin) quiver( x(1),y(1),x(2)-x(1),y(2)-y(1),0, varargin{:} );
if min(alpha_St.alpha) >= 0 || max(alpha_St.alpha) > -12
    axis.drawArrow([prop.arrowlen,0.5],[prop.ylimit(2)-prop.delta,prop.ylimit(2)-prop.delta],'color',prop.color.grey,'MarkerFaceColor',prop.color.grey,...
        'MarkerEdgeColor','none','Marker','>','ShowArrowHead','off');
    text(1, prop.ylimit(2)-prop.delta, 'Steigung', 'FontSize', 8,'color',prop.color.grey, ...
        'FontWeight', 'bold', 'FontAngle', 'italic', ...
        'HorizontalAlignment','left','VerticalAlignment','top');
    legend(prop.legend,'Location','northeast');
end
if min(alpha_St.alpha) < 0
    axis.drawArrow([-prop.arrowlen,-0.5],[prop.ylimit(2)-prop.delta,prop.ylimit(2)-prop.delta],'color',prop.color.grey,'MarkerFaceColor',prop.color.grey,...
        'MarkerEdgeColor','none','Marker','<','ShowArrowHead','off');
    text(-1, prop.ylimit(2)-prop.delta, 'Gefälle', 'FontSize', 8,'color',prop.color.grey, ...
        'FontWeight', 'bold', 'FontAngle', 'italic', ...
        'HorizontalAlignment','right','VerticalAlignment','top');
    axis.drawArrow([0,0],ylim,'color',prop.color.grey,'ShowArrowHead','off', 'LineStyle','--');
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
plot(min(abs(interpolate.intrplt_krit.ans(1,:))), konst.mu, '*','color',prop.color.grey);
for index_txt = 1:length(interpolate.intrplt_krit.ans)
    if isequal(interpolate.intrplt_krit.ans(1,index_txt), min(abs(interpolate.intrplt_krit.ans(1,:))))
        txt = ['  ' num2str(interpolate.intrplt_krit.ans(1,index_txt)) '°'];
        text(interpolate.intrplt_krit.ans(1,index_txt), konst.mu, ...
            txt, 'FontSize', 10, 'color',prop.color.grey, ...
            'FontWeight', 'normal', 'FontAngle', 'italic', ...
            'HorizontalAlignment','left','VerticalAlignment','top');
    end
end
axis.drawArrow([0 prop.xlimit(2)],[konst.mu, konst.mu],'color',prop.color.grey,'MarkerFaceColor',prop.color.grey,...
    'MarkerEdgeColor','none','ShowArrowHead','off','LineStyle','--');
text(1, konst.mu, ['\mu = ',num2str(konst.mu)], 'FontSize', 10,'color',prop.color.grey, ...
    'FontWeight', 'bold', 'FontAngle', 'italic', ...
    'HorizontalAlignment','left','VerticalAlignment','top');
ylim([-1,1]);
xlim([-alpha_St.krit_geom alpha_St.krit_geom]);
prop.ylimit = ylim;
prop.delta = 0.025*sum(abs(prop.ylimit));
prop.xlimit = xlim;
prop.arrowlen = 0.13*sum(abs(prop.xlimit));
prop.legend = ["f_R_v_1", "f_R_v_2", "f_R_h"];
if min(alpha_St.alpha) >= 0 || max(alpha_St.alpha) > 0
    axis.drawArrow([prop.arrowlen,0.5],[prop.ylimit(2)-prop.delta,prop.ylimit(2)-prop.delta],'color',prop.color.grey,'MarkerFaceColor',prop.color.grey,...
        'MarkerEdgeColor','none','Marker','>','ShowArrowHead','off');
    text(1, prop.ylimit(2)-prop.delta, 'Steigung', 'FontSize', 8,'color',prop.color.grey, ...
        'FontWeight', 'bold', 'FontAngle', 'italic', ...
        'HorizontalAlignment','left','VerticalAlignment','top');
    legend(prop.legend,'Location','northeast');
end
if min(alpha_St.alpha) < 0
    axis.drawArrow([-prop.arrowlen,-0.5],[prop.ylimit(2)-prop.delta,prop.ylimit(2)-prop.delta],'color',prop.color.grey,'MarkerFaceColor',prop.color.grey,...
        'MarkerEdgeColor','none','Marker','<','ShowArrowHead','off');
    text(-1, prop.ylimit(2)-prop.delta, 'Gefälle', 'FontSize', 8,'color',prop.color.grey, ...
        'FontWeight', 'bold', 'FontAngle', 'italic', ...
        'HorizontalAlignment','right','VerticalAlignment','top');
    axis.drawArrow([0,0],ylim,'color',prop.color.grey,'ShowArrowHead','off', 'LineStyle','--');
    legend(prop.legend,'Location','southeast');
end
hold off;
title("Kraftschlussbeiwert der Achsen in Abhängigkeit der Straßensteigung" + " (" + zustand + ")");
ylabel("Kraftschlussbeiwert [-]");
xlabel("Steigung [°]");
grid on;

% -------------------------------------------------------------------------
% Bedarfsmoment in Abhängigkeit der Straßensteigung
% -------------------------------------------------------------------------

figure;
hold on;
plot(alpha_St.alpha, M.M_Bed_R, 'LineStyle','-', 'color', prop.color.F_R);
plot(alpha_St.alpha, M.M_Bed_EM, 'LineStyle','-', 'color', prop.color.F_EM);
plot(alpha_St.krit_fR, min(abs(interpolate.intrplt_M.ans(1,:))), '*','color',prop.color.grey);
for index_txt = 1:length(interpolate.intrplt_M.ans)
    if isequal(interpolate.intrplt_M.ans(1,index_txt), min(abs(interpolate.intrplt_M.ans(1,:))))
        txt = ['  ' num2str(round(interpolate.intrplt_M.ans(1,index_txt),2)) ' Nm'];
        text(alpha_St.krit_fR, interpolate.intrplt_M.ans(1,index_txt), ...
            txt, 'FontSize', 10, 'color',prop.color.grey, ...
            'FontWeight', 'normal', 'FontAngle', 'italic', ...
            'HorizontalAlignment','left','VerticalAlignment','middle');
    end
end
prop.ylimit = ylim;
prop.delta = 0.025*sum(abs(prop.ylimit));
prop.xlimit = xlim;
prop.arrowlen = 0.13*sum(abs(prop.xlimit));
prop.legend = ["M_B_e_d_R", "M_B_e_d_E_M"];
axis.drawArrow = @(x,y,varargin) quiver( x(1),y(1),x(2)-x(1),y(2)-y(1),0, varargin{:} );
if min(alpha_St.alpha) >= 0 || max(alpha_St.alpha) > -12
    axis.drawArrow([prop.arrowlen,0.5],[prop.ylimit(2)-prop.delta,prop.ylimit(2)-prop.delta],'color',prop.color.grey,'MarkerFaceColor',prop.color.grey,...
        'MarkerEdgeColor','none','Marker','>','ShowArrowHead','off');
    text(1, prop.ylimit(2)-prop.delta, 'Steigung', 'FontSize', 8,'color',prop.color.grey, ...
        'FontWeight', 'bold', 'FontAngle', 'italic', ...
        'HorizontalAlignment','left','VerticalAlignment','top');
    legend(prop.legend,'Location','northeast');
end
if min(alpha_St.alpha) < 0
    axis.drawArrow([-prop.arrowlen,-0.5],[prop.ylimit(2)-prop.delta,prop.ylimit(2)-prop.delta],'color',prop.color.grey,'MarkerFaceColor',prop.color.grey,...
        'MarkerEdgeColor','none','Marker','<','ShowArrowHead','off');
    text(-1, prop.ylimit(2)-prop.delta, 'Gefälle', 'FontSize', 8,'color',prop.color.grey, ...
        'FontWeight', 'bold', 'FontAngle', 'italic', ...
        'HorizontalAlignment','right','VerticalAlignment','top');
    axis.drawArrow([0,0],ylim,'color',prop.color.grey,'ShowArrowHead','off', 'LineStyle','--');
    legend(prop.legend,'Location','southeast');
end
hold off;
title("Bedarfsmoment in Abhängigkeit der Straßensteigung" + " (" + zustand + ")");
ylabel("Moment [Nm]");
xlabel("Steigung [°]");
grid on;

% -------------------------------------------------------------------------
% Bedarfsleistung in Abhängigkeit der Straßensteigung
% -------------------------------------------------------------------------

figure;
hold on;
plot(alpha_St.alpha, P.P_Bed_R, 'LineStyle','-', 'color', prop.color.F_R);
plot(alpha_St.alpha, P.P_Bed_EM, 'LineStyle','-', 'color', prop.color.F_EM);
plot(alpha_St.alpha, P.P_Bed_Batt, 'LineStyle','-', 'color', prop.color.F_Batt);
plot(alpha_St.alpha, P.P_Bed_Entlade, 'LineStyle','-', 'color', prop.color.F_Entlade);
plot(alpha_St.krit_fR, min(abs(interpolate.intrplt_P.ans(1,:))), '*','color',prop.color.grey);
for index_txt = 1:length(interpolate.intrplt_P.ans)
    if isequal(interpolate.intrplt_P.ans(1,index_txt), min(abs(interpolate.intrplt_P.ans(1,:))))
        txt = ['  ' num2str(round(interpolate.intrplt_P.ans(1,index_txt),2)) ' W'];
        text(alpha_St.krit_fR, interpolate.intrplt_P.ans(1,index_txt), ...
            txt, 'FontSize', 10, 'color',prop.color.grey, ...
            'FontWeight', 'normal', 'FontAngle', 'italic', ...
            'HorizontalAlignment','left','VerticalAlignment','middle');
    end
end
prop.ylimit = ylim;
prop.delta = 0.025*sum(abs(prop.ylimit));
prop.xlimit = xlim;
prop.arrowlen = 0.13*sum(abs(prop.xlimit));
prop.legend = ["P_B_e_d_R", "P_B_e_d_E_M", "P_B_e_d_B_a_t_t", "P_B_e_d_E_n_t_l_a_d_e"];
axis.drawArrow = @(x,y,varargin) quiver( x(1),y(1),x(2)-x(1),y(2)-y(1),0, varargin{:} );
if min(alpha_St.alpha) >= 0 || max(alpha_St.alpha) > -12
    axis.drawArrow([prop.arrowlen,0.5],[prop.ylimit(2)-prop.delta,prop.ylimit(2)-prop.delta],'color',prop.color.grey,'MarkerFaceColor',prop.color.grey,...
        'MarkerEdgeColor','none','Marker','>','ShowArrowHead','off');
    text(1, prop.ylimit(2)-prop.delta, 'Steigung', 'FontSize', 8,'color',prop.color.grey, ...
        'FontWeight', 'bold', 'FontAngle', 'italic', ...
        'HorizontalAlignment','left','VerticalAlignment','top');
    legend(prop.legend,'Location','northeast');
end
if min(alpha_St.alpha) < 0
    axis.drawArrow([-prop.arrowlen,-0.5],[prop.ylimit(2)-prop.delta,prop.ylimit(2)-prop.delta],'color',prop.color.grey,'MarkerFaceColor',prop.color.grey,...
        'MarkerEdgeColor','none','Marker','<','ShowArrowHead','off');
    text(-1, prop.ylimit(2)-prop.delta, 'Gefälle', 'FontSize', 8,'color',prop.color.grey, ...
        'FontWeight', 'bold', 'FontAngle', 'italic', ...
        'HorizontalAlignment','right','VerticalAlignment','top');
    axis.drawArrow([0,0],ylim,'color',prop.color.grey,'ShowArrowHead','off', 'LineStyle','--');
    legend(prop.legend,'Location','southeast');
end
hold off;
title("Bedarfsleistung in Abhängigkeit der Straßensteigung" + " (" + zustand + ")");
ylabel("Leistung [W]");
xlabel("Steigung [°]");
grid on;

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
axis.drawArrow = @(x,y,varargin) quiver( x(1),y(1),x(2)-x(1),y(2)-y(1),0, varargin{:} );
if min(alpha_St.alpha) >= 0 || max(alpha_St.alpha) > -12
    axis.drawArrow([prop.arrowlen,0.5],[prop.ylimit(2)-prop.delta,prop.ylimit(2)-prop.delta],'color',prop.color.grey,'MarkerFaceColor',prop.color.grey,...
        'MarkerEdgeColor','none','Marker','>','ShowArrowHead','off');
    text(1, prop.ylimit(2)-prop.delta, 'Steigung', 'FontSize', 8,'color',prop.color.grey, ...
        'FontWeight', 'bold', 'FontAngle', 'italic', ...
        'HorizontalAlignment','left','VerticalAlignment','top');
    legend(prop.legend,'Location','northeast');
end
if min(alpha_St.alpha) < 0
    axis.drawArrow([-prop.arrowlen,-0.5],[prop.ylimit(2)-prop.delta,prop.ylimit(2)-prop.delta],'color',prop.color.grey,'MarkerFaceColor',prop.color.grey,...
        'MarkerEdgeColor','none','Marker','<','ShowArrowHead','off');
    text(-1, prop.ylimit(2)-prop.delta, 'Gefälle', 'FontSize', 8,'color',prop.color.grey, ...
        'FontWeight', 'bold', 'FontAngle', 'italic', ...
        'HorizontalAlignment','right','VerticalAlignment','top');
    axis.drawArrow([0,0],ylim,'color',prop.color.grey,'ShowArrowHead','off', 'LineStyle','--');
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

fprintf("Momentenaufteilung:   " + num2str(i_Moment.current) + "\n");

fprintf("------------------\n");

fprintf("Ebenefahrt mit Geschwindigkeit v = " + v.v_Fzg_max + " km/h:\n" + ...
    "    n_R_max  = " + round(n.n_R_max,1) + " 1/min\n" + ...
    "    n_EM_max = " + round(n.n_EM_max,1) + " 1/min\n" + ...
    "\n");

fprintf("Notwendiges Motormoment pro Rad jeder Achse:\n" + ... 
    "|alpha_St = 0°" + ", v = " + v.v_Fzg_max + " km/h|   (i = " + i_Getr + ")\n" + ...
    "    M_R      = " + M.M_Notw.Nabe_Ebene + " Nm   x6   (" + M.M_Notw.pro_Motor_getr_Ebene + " Nm)\n" + ...
    "\n");

fprintf("Notwendige Motorleistung am Rad jeder Achse:\n" + ...
    "|alpha_St = 0°" + ", v = " + v.v_Fzg_max + " km/h|\n" + ...
    "    P        = " + P.P_Notw.Nabe_Ebene + " W \n" + ...
    "Insgesamt " + 6*P.P_Notw.Nabe_Ebene + "W notwendig.\n" + ...
    "\n");
fprintf("------------------\n");

fprintf("Steigungsfahrt mit Geschwindigkeit v = " + v.v_Fzg + " km/h:\n" + ...
    "    n_R      = " + round(n.n_R,1) + " 1/min\n" + ...
    "    n_EM     = " + round(n.n_EM,1) + " 1/min\n" + ...
    "\n");

fprintf("Notwendiges Motormoment pro Rad jeder Achse:\n" + ... 
    "|alpha_St = " + round(alpha_St.krit_fR,1) + "°" + ", v = " + v.v_Fzg + " km/h|   (i = " + i_Getr + ")\n" + ...
    "    M_R      = " + M.M_Notw.Nabe + " Nm   x6   (" + M.M_Notw.pro_Motor_getr + " Nm)\n" + ...
    "\n");

fprintf("Notwendige Motorleistung pro Rad jeder Achse:\n" + ...
    "|alpha_St = " + round(alpha_St.krit_fR,1) + "°" + ", v = " + v.v_Fzg + " km/h|\n" + ...
    "    P        = " + P.P_Notw.Nabe + " W \n" + ...
    "Insgesamt " + 6*P.P_Notw.Nabe + "W notwendig.\n" + ...
    "\n");
% -------------------------------------------------------------------------