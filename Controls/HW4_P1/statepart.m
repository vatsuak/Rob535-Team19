function [pd] = statepart(Y,Uin)

    m    = 1400;                % Mass of Car
    N_w  = 2.00;                % ?? 
    f    = 0.01;                % ??
    I_z  = 2667;                % Momemnt of Inertia
    a    = 1.35;                % Front Axle to COM
    b    = 1.45;                % Rear Axle to Com
    B_y  = 0.27;                % Empirically Fit Coefficient
    C_y  = 1.35;                % Empirically Fit Coefficient
    D_y  = 0.70;                % Empirically Fit Coefficient
    E_y  = -1.6;                % Empirically Fit Coefficient
    g    = 9.806;               % Graviational Constant
    
    pd = zeros(6,6) ;
    
            
    alpha_f = (U_in(2) - atan((Y(4)+a*Y(6))/Y(2)));
    alpha_r = (- atan((Y(4)-b*Y(6))/Y(2)));

    psi_yf = ((1-E_y)*alpha_f(Y) + E_y/B_y*atan(B_y*alpha_f(Y)));  % S_hy = 0
    psi_yr = ((1-E_y)*alpha_r(Y) + E_y/B_y*atan(B_y*alpha_r(Y)));  % S_hy = 0

    F_yf = (b/(a+b)*m*g*D_y*sin(C_y*atan(B_y*psi_yf(Y)))); %S_vy = 0;
    F_yr = (a/(a+b)*m*g*D_y*sin(C_y*atan(B_y*psi_yr(Y))));

    pd(:,6) =  [          Y(2)*cos(Y(5))-Y(4)*sin(Y(5));
               1/m*(-f*m*g+N_w*Uin(1)-F_yf(Y)*sin(Uin(2)))+Y(4)*Y(6);
                         Y(2)*sin(Y(5))+Y(4)*cos(Y(5));
                    1/m*(F_yf(Y)*cos(Uin(2))+F_yr)-Y(2)*Y(6);
                                        Y(6);
                          1/I_z*(a*F_yf(Y)*cos(Uin(2))-b*F_yr)];
                      
end