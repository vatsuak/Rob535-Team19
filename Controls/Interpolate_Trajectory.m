

load('U.mat')
load('Y0.mat')

Y = Y0';

interp_size = 4;
Usim = [interp(U(1,:),interp_size);interp(U(2,:),interp_size)];
Ysim = [interp(Y0(1,:),interp_size);interp(Y0(3,:),interp_size)];
