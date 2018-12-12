
%% Clear For Fresh Run. ! Delete Section Before Submission !

clear
close all
clc

%% Load Data

load ('TestTrack.mat');
load('Uref.mat');
load('Yref.mat');

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
plot(Yref(:,1),Yref(:,3),'b')


%% Interpolate borders and centerline to match size of Yl

interp_size = ceil(size(Yref,1)/size(bl,2));  % ceil(x) rounds up to the nearest low integer

b_l = [interp(bl(1,:),interp_size);interp(bl(2,:),interp_size)];
b_r = [interp(br(1,:),interp_size);interp(br(2,:),interp_size)];
c_line = [interp(cline(1,:),interp_size);interp(cline(2,:),interp_size)];

%====Check====

close all
plot(b_l(1,:),b_l(2,:),'r')
hold on
plot(b_r(1,:),b_r(2,:),'r')
hold on
plot(Yref(:,1),Yref(:,3),'b')

%=============

%% Build bounds vector based on the nearest matching coordinates from centerline

err = 0.1; % find nearest point to the 0.05


bl_scaled = zeros(2,size(Yref,1));
br_scaled = zeros(2,size(Yref,1));
cline_scaled = zeros(2,size(Yref,1));

for i = 1:1:size(Yref,1)
    
    %indx = find( (abs(c_line(1,:) - Yref(i,1))<= err).* (abs(c_line(2,:) - Yref(i,3))<= err),1)
    [~,indx] = min((c_line(1,:) - Yref(i,1)).^2 + (c_line(2,:) - Yref(i,3)).^2);
    
    bl_scaled(:,i) = b_l(:,indx);
    br_scaled(:,i) = b_r(:,indx);
    cline_scaled(:,i) = c_line(:,indx);
    
    
end


%====Check====

close all
plot(bl_scaled(1,:),bl_scaled(2,:),'r')
hold on
plot(br_scaled(1,:),br_scaled(2,:),'r')
hold on
plot(Yref(:,1),Yref(:,3),'b')

%=============

%% Take a segment of ref trajectory

nsteps = 800;


close all
plot(bl_scaled(1,1:nsteps),bl_scaled(2,1:nsteps),'r')
hold on
plot(br_scaled(1,1:nsteps),br_scaled(2,1:nsteps),'r')
hold on
plot(Yref(1:nsteps,1),Yref(1:nsteps,3),'b')

%% Initial Conditions Vector

X0 = [reshape(Yref(1:nsteps,:)',1,6*nsteps), reshape(Uref(1:nsteps-1,:)',1,2*(nsteps-1))];

                      
%% Fmincon b GENERATION

lowbounds = min(bl_scaled(:,1:nsteps),br_scaled(:,1:nsteps));
highbounds = max(bl_scaled(:,1:nsteps),br_scaled(:,1:nsteps));

[lb,ub]=bound_cons(nsteps,Yref(1:nsteps,5)' ,lowbounds, highbounds);

%% Fmincon Trajcetory GENERATION


options = optimoptions('fmincon','SpecifyConstraintGradient',true,...
                       'SpecifyObjectiveGradient',true) ;

cf=@costfun_fresh;
nc=@nonlcon;

z=fmincon(cf,X0,[],[],[],[],lb',ub',nc,options);

Y_fcon = reshape(z(1:6*nsteps),6,nsteps)';
U_fcon = reshape(z(6*nsteps+1:end),2,nsteps-1);


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