
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

U = [repmat([-0.03, 2000],200,1);
    repmat([0, 2000],200,1);
    repmat([0.005, 1500],300,1);
    repmat([-0.005, -1500],200,1);
    repmat([-0.01, -2500],150,1);
    repmat([-0.045, 00],300,1);
    repmat([0.00, -2500],200,1);
    repmat([-0.02,1500],400,1);
    repmat([-0.04, 1500],100,1);
     repmat([-0.05, 1000],100,1);
      repmat([ 0.0025, 800],600,1);
       repmat([-0.005, -500],200,1);
        repmat([0.015, -1500],150,1);
         repmat([0.032, -1000],400,1);
     repmat([-0.02, -500],300,1);
     repmat([-0.015, 00],300,1);
     repmat([-0.08, 500],200,1);
     repmat([-0.01, 00],300,1);
     repmat([-0.0, 0],250,1);
     repmat([0.055, 00],300,1);
     repmat([0.045, 00],300,1);
     repmat([0.02, 100],300,1);
     repmat([0, 100],400,1);
     repmat([-0.04, 800],500,1);
     repmat([-0.0059, -700],300,1);
     repmat([-0.025, 00],400,1); 
     repmat([-0.045, 100],400,1);
     repmat([-0.005, 100],500,1);
     repmat([0.0095, 100],300,1);
     repmat([-0.015, 100],250,1);
 repmat([0.095, 100],300,1);
 repmat([0.014, 1000],600,1);
 repmat([-0.01, -1500],200,1);
  repmat([-0.05, -400],200,1);
   repmat([-0.057, -100],500,1);
    repmat([-0.02, 100],250,1);
     repmat([-0.01, -500],150,1);
      repmat([0.49, -100],150,1);
       repmat([0.038, 500],250,1);
        repmat([-0.0, 1000],420,1);
         repmat([-0.0007, 1100],580,1);
          repmat([0.45, -2100],150,1);
           repmat([0.05, 1000],100,1);
           repmat([-0.015, 1500],200,1);
           repmat([0.012, 500],200,1);
           repmat([-0.004, 100],300,1);
           repmat([0.0, 100],300,1);
           repmat([0.001,100],300,1);
           repmat([0.001, 100],300,1);
           repmat([0.04, 100],150,1);
   ];
 %repmat([0.04, 100],150,1);



[Y, t] = forwardIntegrateControlInput(U,z0); %  U nx2 , z0 1x6
Uref = U;
Yref = Y;

plot(bl(1,:),bl(2,:),'r')
hold on
plot(br(1,:),br(2,:),'r')
hold on
% plot((br(1,:)+cline(1,:))/2,(br(2,:)+cline(2,:))/2,'.');
plot(Y(:,1), Y(:,3),'b')
hold on
quiver(Y(end,1), Y(end,3),1*cos(Y(end,5)),1*sin(Y(end,5)),Y(end,2),'linewidth',3,'color','g')
quiver(Y(end,1), Y(end,3),1*sin(Y(end,5)),1*cos(Y(end,5)),Y(end,4),'linewidth',3,'color','r')

Y(:,2) = Y(:,2)*3.6;
Y(:,5) = Y(:,5)*180/pi;
Y(end,2:end)