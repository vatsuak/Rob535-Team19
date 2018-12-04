
%% Clear For Fresh Run. ! Delete Section Before Submission !

clear
clc

%% Load Data

load ('TestTrack.mat');

bl = TestTrack.bl;       % Left Boundaries
br = TestTrack.br;       % Right Boundaries
cline = TestTrack.cline; % Center Line
theta = TestTrack.theta; % Center Line's Orientation


%% Initial Conditions

x0   =   287;
u0   =   5.0;
y0   =  -176;
v0   =   0.0;
psi0 =   2.0;
r0   =   0.0;

z0 = [x0, u0, y0, v0, psi0, r0];

%% Manual Drive

% F : [-5000, 2500]
% delta = [-0.5, 0.5]
U = [[2000, 0];
    [2000, 0];
    [2000, 0];
    [2000, 0];
    [2000,  0]];

[Y, t] = forwardIntegrateControlInput(U,z0); %  U nx2 , z0 1x6

plot(bl(1,:),bl(2,:),'r')
hold on
plot(br(1,:),br(2,:),'r')
hold on