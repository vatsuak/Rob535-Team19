
%% Clear For Fresh Run. ! Delete Section Before Submission !

clear
clc
%% Load Data

load ('TestTrack.mat');

bl = TestTrack.bl;       % Left Boundaries
br = TestTrack.br;       % Right Boundaries
cline = TestTrack.cline; % Center Line
theta = TestTrack.theta; % Center Line's Orientation

hold on
plot(bl(1,:),bl(2,:),'r')
hold on
plot(br(1,:),br(2,:),'r')
%% Initialize Constants

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
S_hy = 0.00;                % Horizontal Offset in y
S_vy = 0.00;                % Vertical Offset in y
g    = 9.806;               % Graviational Constant

%% Initialize Time and Prediction Data

dt   = 0.01;                % Time Step
PredHorizon = 10;           % Prediction Horizon Size

% interp_size = 4;
% bx = [interp(bl(1,:),interp_size);interp(bl(2,:),interp_size)];
% by = [interp(br(1,:),interp_size);interp(br(2,:),interp_size)];
% nsteps = size(bx,2);
% T = 0.0:dt:nsteps*dt;

nsteps  = size(bl,2);
nstates = 6;
ninputs = 2;


%% Initial Conditions

x0   =   287;
u0   =   5.0;
y0   =  -176;
v0   =   0.0;
psi0 =   2.0;
r0   =   0.0;

z0 = [x0, u0, y0, v0, psi0, r0];

%% Nonlinear System Formulation

j = 0;
% Uin(:,i) = [Fx, deltaf]

alpha_f = @(Y)(U_in(2, j+1) - atan((Y(4)+a*Y(6))/Y(2)));
alpha_r = @(Y)(- atan((Y(4)-b*Y(6))/Y(2)));

psi_yf = @(Y)((1-E_y)*alpha_f(Y) + E_y/B_y*atan(B_y*alpha_f(Y)));  % S_hy = 0
psi_yr = @(Y)((1-E_y)*alpha_r(Y) + E_y/B_y*atan(B_y*alpha_r(Y)));  % S_hy = 0

F_yf = @(Y)(b/(a+b)*m*g*D_y*sin(C_y*atan(B_y*psi_yf(Y)))); %S_vy = 0;
F_yr = @(Y)(a/(a+b)*m*g*D_y*sin(C_y*atan(B_y*psi_yr(Y)))); %S_vy = 0;

sysNL = @(i,Y)[          Y(2)*cos(Y(5))-Y(4)*sin(Y(5));
               1/m*(-f*m*g+N_w*Uin(1,j+1)-F_yf(Y)*sin(Uin(2,j+1)))+Y(4)*Y(6);
                         Y(2)*sin(Y(5))+Y(4)*cos(Y(5));
                    1/m*(F_yf(Y)*cos(Uin(2,j+1))+F_yr)-Y(2)*Y(6);
                                        Y(6);
                          1/I_z*(a*F_yf(Y)*cos(Uin(2,j+1))-b*F_yr)];
                      
%% REF PATH GENERATION

lowbounds = min(bl,br);
highbounds = max(bl,br);

[lb,ub]=bound_cons(nsteps,theta ,lowbounds, highbounds);


options = optimoptions('fmincon','SpecifyConstraintGradient',true,...
                       'SpecifyObjectiveGradient',true) ;
                   
% x0=zeros(1,5*nsteps-2); ??
X0 = [repmat([x0,u0,y0,v0,psi0,r0],1,nsteps), repmat([0,0],1,nsteps-1)];

cf=@costfun;
nc=@nonlcon;

z=fmincon(cf,X0,[],[],[],[],lb',ub',nc,options);

Y0=reshape(z(1:6*nsteps),6,nsteps)';
U=reshape(z(6*nsteps+1:end),2,nsteps-1);


%% REF PATH FOLLOWING WITHOUT OBSTACLES

%% Functions Imported from HW

function [lb,ub]=bound_cons(nsteps,theta ,lowbounds, highbounds) %,input_range

% ub = zeros(1,6*nsteps);
% lb = zeros(1,6*nsteps);
% 
% for i = 1:nsteps
%     
% ub(6*i-5:6*i) = [highbounds(1,i), +inf,highbounds(2,i), +inf, theta(i)+pi/2, +inf];
% 
% lb(6*i-5:6*i) = [lowbounds(1,i), -inf, lowbounds(2,i), -inf, theta(i)-pi/2, -inf];
% 
% end

ub = [];
lb = [];

for i = 1:nsteps
    
ub = [ub,[highbounds(1,i), +inf,highbounds(2,i), +inf, theta(i)+pi/2, +inf]];

lb = [lb,[lowbounds(1,i), -inf, lowbounds(2,i), -inf, theta(i)-pi/2, -inf]];

end

% size(ub)
% size(lb)

ub = [ub,repmat([2500,0.5],1,nsteps-1) ]';
lb = [lb,repmat([-5000,-0.5],1,nsteps-1) ]';

end