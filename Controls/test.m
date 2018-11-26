    
syms X y u v Si r Fx dell
Uin = [Fx, dell];


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

    alpha_f = (Uin(2) - atan((v+a*r)/u));
    alpha_r = (- atan((v-b*r)/u));

    psi_yf = ((1-E_y)*alpha_f + E_y/B_y*atan(B_y*alpha_f));  % S_hy = 0
    psi_yr = ((1-E_y)*alpha_r + E_y/B_y*atan(B_y*alpha_r));  % S_hy = 0

    F_yf = (b/(a+b)*m*g*D_y*sin(C_y*atan(B_y*psi_yf))); %S_vy = 0;
    F_yr = (a/(a+b)*m*g*D_y*sin(C_y*atan(B_y*psi_yr)));

    pd =  [          u*cos(Si)-v*sin(Si);
                   1/m*(-f*m*g+N_w*Uin(1)-F_yf*sin(Uin(2)))+v*r;
                             u*sin(Si)+v*cos(Si);
                        1/m*(F_yf*cos(Uin(2))+F_yr)-u*r;
                                            r;
                              1/I_z*(a*F_yf*cos(Uin(2))-b*F_yr)];
    
    F = jacobian(pd,[Fx, dell])
    
%     ip = [      0, 0 ;
%             N_w/m, -F_yf/m*cos(Uin(2));
%                 0, 0;
%                 0, -F_yf/m*sin(Uin(2));
%                 0, 0;
%                 0,  -a/I_z*F_yf*sin(Uin(2))] ;