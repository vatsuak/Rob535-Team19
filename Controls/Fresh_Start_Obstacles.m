
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
    obs_bound(i,:) = [mean(tempx), norm(mean(tempx)-tempx(1,:))];
    tempx = [tempx;tempx(1,:)];
    
    hold on
    plot(tempx(:,1),tempx(:,2),'g')
    hold on
    circle(obs_bound(i,1),obs_bound(i,2),obs_bound(i,3))
    
    
end

%% Ref Path Selection based on Obstacles

endtrack = false;
left_track = true;
current_track = Y_left;
prev_track = Y_right;
final_track = zeros(size(Y_right));
search_horizon = 500;  %look forward 500 steps
indx = 1;
counter = 1;

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
            [~,indx] = min((prev_track(:,1) - current_track(indx,1)).^2 + (prev_track(:,3) - current_track(indx,3)).^2);
            break
        end
    end
    
    if left_track
        current_track = Y_left;
        prev_track = Y_right;
        final_track(1+ 500*(counter-1): 1 + 500*(counter-1) + search_horizon,:) = current_track(indx:indx +search_horizon,:);
    else
        current_track = Y_right;
        prev_track = Y_left;
        final_track(1+ 500*(counter-1): 1 + 500*(counter-1) + search_horizon,:) = current_track(indx:indx +search_horizon,:);
    end
    counter = counter+1;
    indx = indx + search_horizon;
end
final_track = final_track(1:1 + 500*(counter-2) + search_horizon, :);
hold on
plot(final_track(:,1),final_track(:,3),'k','linewidth',1.5)

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

function circle(x,y,r)
%x and y are the coordinates of the center of the circle
%r is the radius of the circle
%0.01 is the angle step, bigger values will draw the circle faster but
%you might notice imperfections (not very smooth)
ang=0:0.01:2*pi; 
xp=r*cos(ang);
yp=r*sin(ang);
plot(x+xp,y+yp,'k','linewidth',3);
end