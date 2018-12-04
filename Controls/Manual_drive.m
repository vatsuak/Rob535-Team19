
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

% F limits     : [-5000, 2500]
% delta limits : [-0.5, 0.5]

clf('reset')

U = [repmat([-0.04, 2400],100,1);
    repmat([0, 2400],200,1);
    repmat([0.0, 2400],30,1);
    repmat([0.0, 2400],100,1);
    repmat([0.0, 2400],180,1);
    repmat([-0.0, 1800],130,1);
    repmat([-0.03,0],350,1);
    repmat([+0.04, 2400],200,1);
    repmat([+0.003, 2400],280,1);
    repmat([+0.00, -4900],150,1);
    repmat([+0.05, 0.0],50,1);
    repmat([+0.0, 1000],170,1);
    repmat([-0.09, 0],300,1);];
 

 
%     repmat([-0.125, 1700],300,1);
%     repmat([-0.05, 1900],100,1);
%     repmat([+0.2, 1900],200,1);
%     repmat([+0.2, 1600],100,1);];

%     repmat([-0.05, 2400],50,1);
%     repmat([0.0, 2400],100,1);
%     repmat([0.0, 2000],100,1);
%     repmat([0.0, 1000],200,1);
%     repmat([-0.1, 500],400,1);];

[Y, t] = forwardIntegrateControlInput(U,z0); %  U nx2 , z0 1x6
Y(:,2) = Y(:,2)*3.6;
Y(end,:)

plot(bl(1,1:100),bl(2,1:100),'r')
hold on
plot(br(1,1:100),br(2,1:100),'r')
hold on
plot(Y(:,1), Y(:,3),'b')