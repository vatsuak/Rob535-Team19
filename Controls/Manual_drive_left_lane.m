
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

U = [repmat([0.02, 2400],138,1);
    repmat([-0.009, 1500],180,1);
    repmat([-0.028, 0],100,1);
    repmat([0.0015, 1500],350,1);
    repmat([-0.0028,-3000],130,1);
    repmat([0.00, -2000],100,1);
%     repmat([0, 0],20,1);
    repmat([-0.024, 100],500,1);
    repmat([-0.024, 100],800,1);
    repmat([-0.001, 2400],300,1);
    repmat([0.00, 100],300,1);
    repmat([-0.001, -2500],280,1);
    
    repmat([+0.04, 0],400,1);
    repmat([0, 100],400,1);
    repmat([-0.04, 0],500,1);
    repmat([0, 150],280,1);
    repmat([+0.047, 100],550,1);
    repmat([0, 50],330,1);
    repmat([-0.034, 0],300,1);
    repmat([-0.0262, 2400],350,1);
    repmat([0, 100],100,1);
    repmat([-0.032, 200],50,1);
    repmat([-0.05, 0],170,1);
    repmat([0.015, 500],250,1);
    repmat([-0.015, 100],130,1);
    repmat([0.005, 100],80,1);
    repmat([+0.0, -4500],100,1);
    repmat([+0.09, 0],70,1);
    repmat([+0, 0],20,1);
    repmat([+0.07, -2700],100,1);  
    repmat([0.49, 500],100,1);
    repmat([-0.01, 2400],200,1);
    repmat([0.013, 2400],100,1);
    repmat([0.04, 2400],90,1);
    repmat([0.01, 0],30,1);
    repmat([-0.02, 10],100,1);
    repmat([-0.045, -700],200,1);
    repmat([-0.4, 10],50,1);
    repmat([-0.2, 10],100,1);
    repmat([-0.03, 100],200,1);
    repmat([-0.1, 100],80,1);
    repmat([0.04, -3500],100,1);
    
    
    repmat([0.1, 10],200,1);
    repmat([0.15, 10],100,1);
    repmat([-0.062, 2400],50,1);
    repmat([-0.005, 2400],200,1);
    repmat([0, 2400],100,1);
    repmat([0.0015, 0],300,1);
    repmat([0.0015, -2000],270,1);
    repmat([0.18, 10],100,1);
    repmat([-0.000, 2400],280,1);
    repmat([0.00013, 42],1050,1);
    repmat([0.008, 42],310,1);
    repmat([-0.008, 42],150,1);
%     repmat([0.001, 10],300,1);
    
%     repmat([0., 10],100,1);
%     repmat([-0.04, 10],100,1);

    ];
 

 


[Y, t] = forwardIntegrateControlInput(U,z0); %  U nx2 , z0 1x6
U_left = U;
Y_left = Y;

plot(bl(1,:),bl(2,:),'r')
hold on
plot(br(1,:),br(2,:),'r')
hold on
plot(Y(:,1), Y(:,3),'b')


quiver(Y(end,1), Y(end,3),1*cos(Y(end,5)),1*sin(Y(end,5)),Y(end,2),'linewidth',3,'color','g')
quiver(Y(end,1), Y(end,3),1*sin(Y(end,5)),1*cos(Y(end,5)),Y(end,4),'linewidth',3,'color','r')

Y(:,2) = Y(:,2)*3.6;
Y(:,5) = Y(:,5)*180/pi;
Y(end,2:end)