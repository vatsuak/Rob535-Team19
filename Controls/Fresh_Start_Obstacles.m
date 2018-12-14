
%% Clear For Fresh Run. ! Delete Section Before Submission !

clear
close all 
clc

%% Load Data

load ('TestTrack.mat');
load('Uref.mat');
load('Yref.mat');
load('U_left.mat');
load('Y_left.mat');
load('U_right.mat');
load('Y_right.mat');


Nobs = 3; %based on Q1 results
Xobs = generateRandomObstacles(Nobs, TestTrack);
obs_bound = zeros(Nobs,3);


% info = getTrajectoryInfo(Yref,Uref,Xobs)

Uref = Uref(:,2:-1:1);

bl = TestTrack.bl;       % Left Boundaries
br = TestTrack.br;       % Right Boundaries
cline = TestTrack.cline; % Center Line
theta = TestTrack.theta; % Center Line's Orientation

close all
plot(bl(1,:),bl(2,:),'r')
hold on
plot(br(1,:),br(2,:),'r')
hold on
plot(Y_left(:,1),Y_left(:,3),'b')
hold on
plot(Y_right(:,1),Y_right(:,3),'b')
hold on
plot(cline(1,:),cline(2,:),'--g')
hold on

for i = 1:length(Xobs)
    
    tempx = Xobs{i};
    obs_bound(i,:) = [mean(tempx), norm(mean(tempx)-tempx(1,:))+0.5];
    tempx = [tempx;tempx(1,:)];
    
    hold on
    plot(tempx(:,1),tempx(:,2),'g')
    hold on
    circle(obs_bound(i,1),obs_bound(i,2),obs_bound(i,3))
    
    
end

%% Ref Path Selection based on Obstacles

endtrack = false;
left_track = false;
current_track = Y_right;
current_input = U_right;
prev_track = Y_left;
prev_input = U_left;
final_track = zeros(size(Y_right));
final_input = zeros(size(U_right));
search_horizon = 500;  %look forward 500 steps
indx = 1;
counter = 1;
choose_right = false;

while (~endtrack)
    if (indx > size(current_track,1) - search_horizon)
        search_horizon = size(current_track,1) - (indx);
        endtrack = true;
    end
    for i = 1:Nobs
        flip = ~isempty(find(vecnorm(current_track(indx:indx+search_horizon, [1,3] ) - obs_bound(i,[1,2]),2,2) < obs_bound(i,3)));
        if flip
            disp('Flipped Lanes !')
            left_track = ~left_track;
            if(i==1)
                choose_right = false;
            end
            [~,indx] = min((prev_track(:,1) - current_track(indx,1)).^2 + (prev_track(:,3) - current_track(indx,3)).^2);
            break
        end
    end
    
    if left_track
        current_track = Y_left;
        current_input = U_left;
        prev_track = Y_right;
        prev_input = U_right;
        final_track(1+ 500*(counter-1): 1 + 500*(counter-1) + search_horizon,:) = current_track(indx:indx +search_horizon,:);
        final_input(1+ 500*(counter-1): 1 + 500*(counter-1) + search_horizon,:) = current_input(indx:indx +search_horizon,:);
    else
        current_track = Y_right;
        prev_track = Y_left;
        current_input = U_right;
        prev_input = U_left;
        final_track(1+ 500*(counter-1): 1 + 500*(counter-1) + search_horizon,:) = current_track(indx:indx +search_horizon,:);
        final_input(1+ 500*(counter-1): 1 + 500*(counter-1) + search_horizon,:) = current_input(indx:indx +search_horizon,:);
    end
    counter = counter+1;
    indx = indx + search_horizon;
end

final_track = final_track(1:1 + 500*(counter-2) + search_horizon, :);
final_input = final_input(1:1 + 500*(counter-2) + search_horizon, :);

hold on
plot(final_track(:,1),final_track(:,3),'k','linewidth',1.5)

%% Control Input to drive the car

[Ufinal, Yfinal]=get_inputs_pid(final_track,final_input);

%% Plot final track

% Yfw_int = forwardIntegrateControlInput(Ufinal);

hold on
plot(Yfinal(:,1),Yfinal(:,3),'r','linewidth',1.5)
hold on
% plot(Yfw_int(:,1),Yfw_int(:,3),'g','linewidth',1.5)

%% Functions Imported from HW

function [Ufinal , Yfinal]=get_inputs_pid(final_track,final_input)
    
    segmentsize = 11000;
    Kp = [0,0,0,0,0.02,0;...
          50,0,50,0,0,0];
      
    Kd = [0,0,0,0,20.0,0;...
    100.0,0,100.0,0,0,0];

    Yfinal = zeros(segmentsize, 6);
    Ufinal = zeros(segmentsize, 2);
    Yfinal(1,:) = final_track(1,:);
    dy_prev = 0;
    
    for i = 2:size(Yfinal,1)
        
        
        Uref = final_input(i,:);
        
        dy = Yfinal(i-1,:) - final_track(i,:);
        dd = (dy - dy_prev)/0.01;
        
        dy_prev = dy;
        
%         A = statepart_hand(Yref, Uref);
%         B = inputpart_hand(Yref, Uref);
        
        orient = final_track(i,5) - atan2(-dy(3),-dy(1)+0.001)
%         if abs(orient) > 1.0
%             final_track(i,:)
%             e
%         end
        du = -(Kp*dy'+Kd*dd');  %+ Kp(1,5)*atan2(dy(3),dy(1)) %- [Kp(1,5)*orient; 0]
        u = Uref + du';  
        Ufinal(i-1,:) = u;
        Ytemp = forwardIntegrateControlInput([u;u], Yfinal(i-1,:));
        Yfinal(i,:) = Ytemp(end,:);
        
    end
    
    disp('DONE !')
end

function circle(x,y,r)
%x and y are the coordinates of the center of the circle
%r is the radius of the circle
%0.01 is the angle step, bigger values will draw the circle faster but
%you might notice imperfections (not very smooth)
ang=0:0.01:2*pi; 
xp=r*cos(ang);
yp=r*sin(ang);
plot(x+xp,y+yp, 'k' ,'linewidth',3);
end
