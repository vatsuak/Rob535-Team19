
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
clc

U = [repmat([-0.04, 2400],100,1);
    repmat([0, 2400],200,1);
    repmat([0.0, 2400],30,1);
    repmat([0.0, 2400],100,1);
    repmat([0.0, 2400],180,1);
    repmat([-0.0, 1800],130,1);
    repmat([-0.03,0],350,1);
    repmat([+0.04, 2400],200,1);
    repmat([+0.003, 2400],250,1);
    repmat([+0.00, -4000],150,1);
    repmat([+0.023, -500.0],250,1);
    repmat([-0.010, -2000.0],250,1);
    repmat([-0.0350,  -1500.0],250,1);
    repmat([0.0010, 000],250,1);    
    repmat([0.05, 3500],250,1);
    repmat([-0.039, -2000],250,1);
    repmat([-0.01, -500],400,1);
    repmat([-0.03, 1000],450,1);
    repmat([-0.04, 1700],100,1);
    repmat([-0.02, 2000],250,1);

    repmat([0.04, -1600],170,1);
    repmat([0.48, 2000],150,1);
    repmat([0.48, -1000],200,1);
    repmat([0.01, -1000],50,1);
    repmat([0.035, 2490],140,1);
    repmat([-0.03, 2490],110,1);
    repmat([-0.35, -1900],200,1);
    repmat([-0.4,2490],200,1);
    repmat([-0.2, 1500],170,1);
    repmat([0.48, -1000],150,1);
    repmat([0.48, 2499],150,1);
    repmat([0.01, 2499],150,1);
    repmat([0.0, 2499],170,1);
    repmat([0.001, 2499],165,1);
    repmat([0.09, 2499],70,1);
    repmat([0.4, 2499],80,1);
    repmat([0.3, 2499],200,1);
    repmat([0., 2499],200,1);
    repmat([0, 2499],200,1);
    repmat([0, 2499],200,1);
    repmat([0, 2499],40,1);
    % repmat([0.48, -1000],200,1);
    % repmat([0.48, -1000],200,1);
    ];
 

 
%     repmat([-0.125, 1700],300,1);
%     repmat([-0.05, 1900],100,1);d 
%     repmat([+0.2, 1900],200,1);
%     repmat([+0.2, 1600],100,1);];

%     repmat([-0.05, 2400],50,1);
%     repmat([0.0, 2400],100,1);
%     repmat([0.0, 2000],100,1);
%     repmat([0.0, 1000],200,1);
%     repmat([-0.1, 500],400,1);];

[Y, t] = forwardIntegrateControlInput(U,z0); %  U nx2 , z0 1x6
Uref = U;
Yref = Y;

plot(bl(1,:),bl(2,:),'r')
hold on
plot(br(1,:),br(2,:),'r')
hold on
plot(Y(:,1), Y(:,3),'b')
hold on
quiver(Y(end,1), Y(end,3),1*cos(Y(end,5)),1*sin(Y(end,5)),Y(end,2),'linewidth',3,'color','g')
quiver(Y(end,1), Y(end,3),1*sin(Y(end,5)),1*cos(Y(end,5)),Y(end,4),'linewidth',3,'color','r')

Y(:,2) = Y(:,2)*3.6;
Y(:,5) = Y(:,5)*180/pi;
Y(end,2:end)