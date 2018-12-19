
%% Clear For Fresh Run. ! Delete Section Before Submission !

clear
close all 
clc



load ('TestTrack.mat');
load('Uref.mat');
load('Yref.mat');
load('U_left_slow.mat');
load('Y_left_slow.mat');
load('U_right.mat');
load('Y_right.mat');


Nobs = 25;
Xobs = generateRandomObstacles(Nobs, TestTrack);
obs_bound = zeros(Nobs,3);


% info = getTrajectoryInfo(Yref,Uref,Xobs)

Uref = Uref(:,2:-1:1);

bl = TestTrack.bl;       % Left Boundaries
br = TestTrack.br;       % Right Boundaries
cline = TestTrack.cline; % Center Line
theta = TestTrack.theta; % Center Line's Orientation

close all
figure(2)
hold on
plot(bl(1,:),bl(2,:),'r')
plot(br(1,:),br(2,:),'r')
plot(Y_left(:,1),Y_left(:,3),'b')
plot(Y_right(:,1),Y_right(:,3),'b')
plot(cline(1,:),cline(2,:),'--g')

for i = 1:length(Xobs)
    
    tempx = Xobs{i};
    obs_bound(i,:) = [mean(tempx), norm(mean(tempx)-tempx(1,:))+0.5];
    tempx = [tempx;tempx(1,:)];
    
    plot(tempx(:,1),tempx(:,2),'g')
    draw_circle(obs_bound(i,1),obs_bound(i,2),obs_bound(i,3))
    
    
end

% %% Ref Path Selection based on Obstacles
% 
% endtrack = false;
% left_track = false;
% current_track = Y_right;
% current_input = U_right;
% prev_track = Y_left;
% prev_input = U_left;
% final_track = zeros(size(Y_right));
% final_input = zeros(size(U_right));
% search_horizon = 500;  %look forward 500 steps
% indx = 1;
% counter = 1;
% choose_right = false;
% 
% while (~endtrack)
%     if (indx > size(current_track,1) - search_horizon)
%         search_horizon = size(current_track,1) - (indx);
%         endtrack = true;
%     end
%     for i = 1:Nobs
%         flip = ~isempty(find(vecnorm(current_track(indx:indx+search_horizon, [1,3] ) - obs_bound(i,[1,2]),2,2) < obs_bound(i,3)));
%         if flip
%             disp('Flipped Lanes !')
%             left_track = ~left_track;
%             if(i==1)
%                 choose_right = false;
%             end
%             [~,indx] = min((prev_track(:,1) - current_track(indx,1)).^2 + (prev_track(:,3) - current_track(indx,3)).^2);
%             break
%         end
%     end
%     
%     if left_track
%         current_track = Y_left;
%         current_input = U_left;
%         prev_track = Y_right;
%         prev_input = U_right;
%         final_track(1+ 500*(counter-1): 1 + 500*(counter-1) + search_horizon,:) = current_track(indx:indx +search_horizon,:);
%         final_input(1+ 500*(counter-1): 1 + 500*(counter-1) + search_horizon,:) = current_input(indx:indx +search_horizon,:);
%     else
%         current_track = Y_right;
%         prev_track = Y_left;
%         current_input = U_right;
%         prev_input = U_left;
%         final_track(1+ 500*(counter-1): 1 + 500*(counter-1) + search_horizon,:) = current_track(indx:indx +search_horizon,:);
%         final_input(1+ 500*(counter-1): 1 + 500*(counter-1) + search_horizon,:) = current_input(indx:indx +search_horizon,:);
%     end
%     counter = counter+1;
%     indx = indx + search_horizon;
% end
% 
% final_track = final_track(1:1 + 500*(counter-2) + search_horizon, :);
% final_input = final_input(1:1 + 500*(counter-2) + search_horizon, :);
% 
% hold on
% plot(final_track(:,1),final_track(:,3),'k','linewidth',1.5)

%% Ref Path Selection based on Obstacles - 2


Lchanges = 0;
backsteps_curr = 200;
backsteps_new = 40;
npts = 50;
pt = zeros(backsteps_curr-backsteps_new+1,6);
current_track = Y_left;
current_input = U_left;
pts1= zeros(backsteps_curr-backsteps_new+1,6);
pts2 = zeros(backsteps_curr-backsteps_new+1,6);

for i = 1:Nobs
       if rem(Lchanges,2)==1
            prev_track = Y_left;
            prev_input = U_left;
        else 
            prev_track = Y_right;
            prev_input = U_right;
       end
    
        [xobs,yobs] = circle(obs_bound(i,1),obs_bound(i,2),obs_bound(i,3));
%         obs = [Xobs{i};Xobs{1}(1,:)];
        [x1,y1] = (polyxpoly(current_track(:,1),current_track(:,3),xobs,yobs));
        if ~isempty([x1,y1])
            Lchanges = Lchanges + 1;
            disp('Lane Change!')
            
            [~,indx1(i)] = min((x1(1) - current_track(:,1)).^2 + (y1(1) - current_track(:,3)).^2);    
            [~,indx2(i)] = min((prev_track(:,1) - x1(1)).^2 + (prev_track(:,3) - y1(1)).^2);
            pt1 = current_track(indx1(i)-backsteps_curr,:);
            pt2 = prev_track(indx2(i)-backsteps_new,:);
            pt1u = current_input(indx1(i)-backsteps_curr,:);
            pt2u = current_input(indx1(i)-backsteps_curr,:);
           
        for j = 1:6
            pt(:,j) = linspace(pt1(j),pt2(j),backsteps_curr-backsteps_new+1);
        end
            
            pts1 = current_track(indx1(i)-backsteps_curr:indx1(i)-backsteps_new,:);
            pts2 = prev_track(indx2(i)-backsteps_curr:indx2(i)-backsteps_new,:);
        for k = 1:size(pts1)
            pt(k,1)= (k/size(pts1,1)*pts2(k,1)+ (1-k/size(pts1,1))*pts1(k,1));
            pt(k,3)= (k/size(pts1,1)*pts2(k,3)+ (1-k/size(pts1,1))*pts1(k,3));
        end
        pt(1:size(pts1,1)/2,5) = atan2(pt2(1)-pt1(1),pt2(3)-pt1(3));
        pt(size(pts1,1)/2:end,5) = pt2(5);
        
            ptu(:,2) = -500;
            ptu(1:size(pts1,1),1) =  -0.1*sin(2*pi/size(pts1,1)*[1:size(pts1,1)]);
%             sign(atan2(current_track(indx1(i),4),pt(1,4)))*
        current_track = ([current_track(1:indx1(i)-backsteps_curr,:);pt;prev_track(indx2(i)-backsteps_new:end,:)]);
        current_input = [current_input(1:indx1(i)-backsteps_curr,:); ptu ; prev_input(indx2(i)-backsteps_new:end,:)];

        end    
  
        
end

final_track = current_track;
final_input = current_input;

plot(final_track(:,1),final_track(:,3),'k','linewidth',1.5)


%% Control Input to drive the car
tic

[Ufinal , Yfinal]=waypt_controller(final_track);

toc


%% Get Trajectory Info
% 
% info = getTrajectoryInfo(Yfinal,Ufinal,Xobs,TestTrack)



%%
[~,indx_inpt] = find(Ufinal(:,1) ~= 0);
length(indx_inpt)
[intg_Y, T] = forwardIntegrateControlInput(Ufinal(1:length(indx_inpt),:));

hold on
plot(intg_Y(:,1),intg_Y(:,3),'g','linewidth',1.5)

% % [Ufinal, Yfinal]=get_inputs_pid(final_track,final_input)
% %% Plot final track
% 
% % Yfw_int = forwardIntegrateControlInput(Ufinal);
% 
% plot(Yfinal(:,1),Yfinal(:,3),'r','linewidth',1.5)
% % plot(Yfw_int(:,1),Yfw_int(:,3),'g','linewidth',1.5)
%%
function [Ufinal , Yfinal] =waypt_controller(final_track)
    
    inputsize = 100000;


    Yfinal = zeros(inputsize, 6);
    Ufinal = zeros(inputsize, 2);
    Yfinal(1,:) = final_track(1,:);
    
    pos_tolerance = 1.0;
    K_pos = 20;
    K_orient = 3.0;
    
    endtrack = false;
    trgt_indx = 20;
    indx_increment = 100;
    ctrl_indx = 1;
    counter = 1;
    
    while (~endtrack)
        
        refpos  = final_track(trgt_indx, [1,3]);
        refagl  = atan2(final_track(trgt_indx, 3)- Yfinal(ctrl_indx,3),final_track(trgt_indx, 1)- Yfinal(ctrl_indx,1)+0.01);
        
        errpos  = norm(refpos - Yfinal(ctrl_indx,[1,3]));
        errangl = refagl - Yfinal(ctrl_indx,5);
        
        if (abs(errangl) > 3 || abs(errpos) > 25)
            errpos
            refagl
            errangl
            dy = final_track(trgt_indx, 3)- Yfinal(ctrl_indx,3)
            dx = final_track(trgt_indx, 1)- Yfinal(ctrl_indx,1)
            car_orient = Yfinal(ctrl_indx,5)
            input = u
            hold on
            plot(Yfinal(1:ctrl_indx,1),Yfinal(1:ctrl_indx,3),'r','linewidth',1.5)
            disp('Problem ... Exiting !!')
            break
        end
        
        if(errpos <=  pos_tolerance)
%             disp('Achieved Target ! Moving to Next')
            if (trgt_indx == size(final_track,1))
                disp('Successfully Completed Track !')
                endtrack = true;
            end
            trgt_indx = min(trgt_indx + indx_increment, size(final_track,1));
        end
        
        
        u = [  min(max(K_orient*errangl, -0.5), 0.5) , min(K_pos*errpos,600) ];
        Ufinal(ctrl_indx,:) = u;
        
        
        Ytemp = forwardIntegrateControlInput([u;u], Yfinal(ctrl_indx,:));
        if (counter >= 1000)
            disp('Performing Sanity Update')
            counter = 0;
            Ytemp = forwardIntegrateControlInput(Ufinal(1:ctrl_indx,:));
        end
        ctrl_indx = ctrl_indx + 1;
        Yfinal(ctrl_indx,:) = Ytemp(end,:);
        counter = counter + 1;
        
%         hold on
%         plot(Yfinal(ctrl_indx-1:ctrl_indx,1),Yfinal(ctrl_indx-1:ctrl_indx,3),'g','linewidth',1.5)
%         pause(0.001);
        
    end
    
    Ufinal = Ufinal(1:ctrl_indx-1,:);
    Yfinal = Yfinal(1:ctrl_indx-1,:);
    
    disp('DONE !')
end



%% Functions Imported from HW

function [Ufinal , Yfinal]=get_inputs_pid(final_track,final_input)
    
    segmentsize = 11000;
    Kp = [0,0,0,0,-0.2,0;...
          20,0,22,0,0,0];
      
    Kd = [0,0,0,0,4.0,0;...
    100.0,5,120.0,0,0,0];

    Yfinal = zeros(segmentsize, 6);
    Ufinal = zeros(segmentsize, 2);
    Yfinal(1,:) = final_track(1,:);
    dy_prev = 0;
    
    for i = 2:size(Yfinal,1)
        
        
        Uref = final_input(i,:);
        
        dy = Yfinal(i-1,:) - final_track(i,:)
%         if dy(:,5) >1
%             c
%         end
        dd = (dy - dy_prev)/0.01;
        
        dy_prev = dy;
        
%         A = statepart_hand(Yref, Uref);
%         B = inputpart_hand(Yref, Uref);
%         
%         orient = final_track(i,5) - atan2(-dy(3),-dy(1)+0.001)
%         if abs(orient) > 1.0
%             final_track(i,:)
%             e
%         end
         du = -(Kp*dy'+Kd*dd');  %+ Kp(1,5)*atan2(dy(3),dy(1)) %- [Kp(1,5)*orient; 0]
        u = Uref + du';  
        Ufinal(i-1,:) = u;
%         Ufinal(i-1,1) = u-(Yfinal(i-1,4),Yfinal(i,4));
        Ytemp = forwardIntegrateControlInput_2(u, Yfinal(i-1,:));
        Yfinal(i,:) = Ytemp(end,:);
        
%         plot(Yfinal(i-1:i,1),Yfinal(i-1:i,3),'c','linewidth',1.5)
%         pause(0.001);
    end
    
    disp('DONE !')
end

function draw_circle(x,y,r)
%x and y are the coordinates of the center of the circle
%r is the radius of the circle
%0.01 is the angle step, bigger values will draw the circle faster but
%you might notice imperfections (not very smooth)
ang=0:0.5:2*pi; 
xp=r*cos(ang);
yp=r*sin(ang);
plot(x+xp,y+yp, 'k' ,'linewidth',3);
end


function [xp,yp]= circle(x,y,r)
%x and y are the coordinates of the center of the circle
%r is the radius of the circle
%0.01 is the angle step, bigger values will draw the circle faster but
%you might notice imperfections (not very smooth)
ang=0:0.5:2*pi; 
xp=x+r*cos(ang);
yp=y+r*sin(ang);
end