
function pong_basic
%Modified the pong code by David Buckingham
%https://www.mathworks.com/matlabcentral/fileexchange/31177-dave-s-matlab-pong

%%%%%% main part of the code %%%
global game_over

close all
initData  %first function, initialize the data variables
initFigure %second function, initialize the figure

% insert background images here

while ~game_over %runs till game_over = 1
    moveBall; %third function, compute ball movement including collision detection
    movePaddle; %fourth function, compute paddle position based on user input. 
    refreshPlot; %fifth function, refresh plot based on moveBall and movePaddle
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function initData %first function, initialize the data variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX
global PADDLE_WIDTH BALL_SIZE 
global BALL_INIT_VX BALL_INIT_VY DT DELAY
global PADDLE_VX PADDLE_SPEED 
global game_over level

level = 0;
game_over = 0;
WALL_X_MIN = 0;
WALL_X_MAX = 100;
WALL_Y_MIN = 0;
WALL_Y_MAX = 100;
PADDLE_WIDTH = 20;
BALL_SIZE = 20;
BALL_INIT_VX = -0.75; % og= -2 for both x & y but too faast, changed DT to 0.2 but ball went through paddle P:
BALL_INIT_VY = -2; % og= -2
PADDLE_VX = 0;
PADDLE_SPEED =1.5 ; % og=1.5
DT = 0.5; %CHANGE ME TO CHANGE SPEEDDDDD OF BALL :0 LOLOL (sab wuz here) og=0.5
DELAY = 0.001;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function initFigure %second function, initialize the figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global PADDLE_WIDTH BALL_SIZE 
global WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX
global BALL_INIT_VX BALL_INIT_VY
global ball_x ball_y ball_vx ball_vy 
global paddle_x_left paddle_x_right paddle_y
global ball_anim paddle_anim
global level


fig = figure(1); %initialize the figure
set(fig, 'Resize', 'off'); %do not allow figure to resize
set(fig,'KeyPressFcn',@keyDown); %setkey presses for later
ball_x = WALL_X_MAX; %0.5*(WALL_X_MIN+WALL_X_MAX); 
ball_y = WALL_Y_MAX;
ball_vx = BALL_INIT_VX; 
ball_vy = BALL_INIT_VY;
paddle_x_left = 0;
paddle_x_right = PADDLE_WIDTH;
paddle_y = 10;
axis([WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX]); %set the size of the board.
axis manual;
hold on;
title(['Welcome to the Unbeatable Game - You will not succeed'],'Fontsize',14);
xlabel('Brought to you by Wahlen, Hamdan-Shepard, and Traxler LLC');

% scenery constants
n=40;
theta = linspace(0,2*pi,n);
theta_downhalf = linspace(-pi,0,40);
theta_uphalf = linspace(pi,0,40);
theta_L = linspace(pi/2,-pi/2,40);
theta_R = linspace(-pi/2,pi/2,40);
x_sun1 = 50+8*cos(theta_downhalf);      % noon
y_sun1 = 100+8*sin(theta_downhalf);
x_sun2 = 1+8*cos(theta);             % sunset
y_sun2 = 70+8*sin(theta);
x_sun3 = 100+8*cos(theta);             % sunrise
y_sun3 = 35+8*sin(theta);
x_moon1 = 60+8*cos(theta);             % midnight
y_moon1 = 91+8*sin(theta);
x_moon2 = 57+9*cos(theta);             
y_moon2 = 93+9*sin(theta);
x_rock = [0 10 20];
y_rock = [13 85 13];
x_rock1 = [-10 3 15];
y_rock1 = [13 70 13];
x_rock2 = [15 30 45];
y_rock2 = [13 77 13];
x_rock3 = [4 18 35];
y_rock3 = [13 75 13];
x_rock4 = [4 15 29];
y_rock4 = [13 55 13];
x_rock5 = [25 40 55];
y_rock5 = [13 60 13];
xtip=[8.5 10 11.5];
ytip=[75 85 75];
x_lake = 80+40*cos(theta);
y_lake = 23+8*sin(theta);
x_star1 = 78+0.5*cos(theta);    % STRS: high to low
y_star1 = 88+0.5*sin(theta);
x_star2 = 15+0.5*cos(theta);
y_star2 = 82+0.5*sin(theta);
x_star3 = 47+0.5*cos(theta);
y_star3 = 65+0.5*sin(theta);
x_star4 = 90+0.5*cos(theta);
y_star4 = 58+0.5*sin(theta);
x_tree1 = 52+6*cos(theta);      % TREES
y_tree1 = 46+9.5*sin(theta);
x_tree2 = 62+6*cos(theta); 
y_tree2 = 46+8*sin(theta);
x_tree3 = 72+5*cos(theta);
y_tree3 = 47.5+11*sin(theta);
x_tree4 = 82+5.5*cos(theta);
y_tree4 = 46+7*sin(theta);
x_tree5 = 92+6.5*cos(theta); % ideal boi
y_tree5 = 46+9*sin(theta);
x_tree1b = 56+6*cos(theta);      % BACK TREES with 1 pt height + 4pt to R
y_tree1b = 47+9.5*sin(theta);
x_tree2b = 66+6*cos(theta); 
y_tree2b = 47+8*sin(theta);
x_tree3b = 76+5*cos(theta);
y_tree3b = 48.5+8*sin(theta);
x_tree4b = 86+5.5*cos(theta);
y_tree4b = 48+9*sin(theta);
x_tree5b = 96+6.5*cos(theta); % ideal boi
y_tree5b = 48+10.5*sin(theta);

% % NOON % %
% patch([0 0 100 100],[0 100 100 0],[135,206,250]/255,'edgecolor',[135,206,250]/255); hold on; % daytime sky
%  patch(x_sun1,y_sun1,[255,255,102]/255,'edgecolor',[255,255,102]/255); % sun
%  line([50 70],[99 99],'Color',[255,255,102]/255,'Linewidth',1); % R (CW)
%  line([52 67],[98.75 93.75],'Color',[255,255,102]/255,'Linewidth',1); % pre45degR
%  line([54 64],[96 84],'Color',[255,255,102]/255,'Linewidth',1); % 45degR
%  line([52 57.25],[94 80],'Color',[255,255,102]/255,'Linewidth',1); % post45degR
%  line([50 50],[92 76],'Color',[255,255,102]/255,'Linewidth',1); % down
%  line([43.75 48],[80 94],'Color',[255,255,102]/255,'Linewidth',1); % pre45degL
%  line([36 46],[84 96],'Color',[255,255,102]/255,'Linewidth',1); % 45degL
%  line([33 48],[93.75 98.75],'Color',[255,255,102]/255,'Linewidth',1); % post45degL
%  line([30 50],[99 99],'Color',[255,255,102]/255,'Linewidth',1); % L
%  patch(x_rock3,y_rock3,[176,196,222]/255,'edgecolor',[119,136,153]/255); % mountain
% patch(x_rock,y_rock,[176,196,222]/255,'edgecolor',[119,136,153]/255); % mountain
% patch(x_rock1,y_rock1,[176,196,222]/255,'edgecolor',[119,136,153]/255); % mountain
% patch(x_rock2,y_rock2,[176,196,222]/255,'edgecolor',[119,136,153]/255); % mountain
% patch(x_rock4,y_rock4,[176,196,222]/255,'edgecolor',[119,136,153]/255); % mountain
% patch(x_rock5,y_rock5,[176,196,222]/255,'edgecolor',[119,136,153]/255); % mountain                                                                                          % insert MOUNTAINS here % %
% patch([0 0 100 100],[0 35 35 0],[50,205,50]/255,'edgecolor',[50,205,50]/255); % grass
%     patch(x_lake,y_lake,[176,224,230]/255,'edgecolor',[176,224,230]/255); % lake
%     line([48 50],[22 22],'Color',[255,255,102]/255,'Linewidth',1); % sun reflection
%     line([47 53],[23 23],'Color',[255,255,102]/255,'Linewidth',0.8);
%     line([48 52.5],[24 24],'Color',[255,255,102]/255,'Linewidth',1);
%     line([46 53],[25 25],'Color',[255,255,102]/255,'Linewidth',0.8);
%     line([48 51],[26 26],'Color',[255,255,102]/255,'Linewidth',1);
% %back trees
% patch([94 95.5 97 98.5],[34 44 44 34],[160,82,45]/255,'edgecolor',[160,82,45]/255); % BACK tree5: trunk
%  patch(x_tree5b,y_tree5b,[107,142,35]/255,'edgecolor',[107,142,35]/255);                    % green
%   patch([64 65.5 67 68.5],[34 44 44 34],[160,82,45]/255,'edgecolor',[160,82,45]/255); % tree2: trunk
%   patch(x_tree2b,y_tree2b,[0,100,0]/255,'edgecolor',[0,100,0]/255);                   % green
%    patch([54 55.5 57 58.5],[34 44 44 34],[160,82,45]/255,'edgecolor',[160,82,45]/255); % tree1: trunk
%    patch(x_tree1b,y_tree1b,[107,142,35]/255,'edgecolor',[107,142,35]/255);                       % green
%     patch([74 75.5 77 78.5],[34 44 44 34],[160,82,45]/255,'edgecolor',[160,82,45]/255); % tree3: trunk
%     patch(x_tree3b,y_tree3b,[107,142,35]/255,'edgecolor',[107,142,35]/255);                   % green
%      patch([84 85.5 87 88.5],[34 44 44 34],[160,82,45]/255,'edgecolor',[160,82,45]/255); % tree4: trunk
%      patch(x_tree4b,y_tree4b,[0,128,0]/255,'edgecolor',[0,128,0]/255);                      % green
% %front trees
%  patch([90 91.5 93 94.5],[32 41 41 32],[139,69,19]/255,'edgecolor',[139,69,19]/255); % FRONT tree5: trunk
%  patch(x_tree5,y_tree5,[34,139,34]/255,'edgecolor',[34,139,34]/255);                    % green
%   patch([60 61.5 63 64.5],[32 41 41 32],[139,69,19]/255,'edgecolor',[139,69,19]/255); % tree2: trunk
%   patch(x_tree2,y_tree2,[34,139,34]/255,'edgecolor',[34,139,34]/255);                   % green
%    patch([50 51.5 53 54.5],[32 41 41 32],[139,69,19]/255,'edgecolor',[139,69,19]/255); % tree1: trunk
%    patch(x_tree1,y_tree1,[0,100,0]/255,'edgecolor',[0,100,0]/255);                       % green
%     patch([70 71.5 73 74.5],[32 41 41 32],[139,69,19]/255,'edgecolor',[139,69,19]/255); % tree3: trunk
%     patch(x_tree3,y_tree3,[0,128,0]/255,'edgecolor',[0,128,0]/255);                   % green
%      patch([80 81.5 83 84.5],[32 41 41 32],[139,69,19]/255,'edgecolor',[139,69,19]/255); % tree4: trunk
%      patch(x_tree4,y_tree4,[0,100,0]/255,'edgecolor',[0,100,0]/255);                      % green

% % SUNSET % %
% patch([0 0 100 100],[0 100 100 0],[255,215,0]/255,'edgecolor',[255,215,0]/255); hold on; % orange sky
%     patch(x_sun2,y_sun2,[255,99,71]/255,'edgecolor',[255,99,71]/255); % sun
%     line([1 1],[77 92],'Color',[255,99,71]/255,'Linewidth',1); % sunray 1 
%     line([4 10],[76 90],'Color',[255,99,71]/255,'Linewidth',1); % sunray 2 
%     line([7 16],[73 82],'Color',[255,99,71]/255,'Linewidth',1); % sunray 3 
%     line([8 20],[70 70],'Color',[255,99,71]/255,'Linewidth',1); % sunray 4
% patch(x_rock3,y_rock3,[176,196,222]/255,'edgecolor',[119,136,153]/255); % mountain
% patch(x_rock,y_rock,[176,196,222]/255,'edgecolor',[119,136,153]/255); % mountain
% patch(x_rock1,y_rock1,[176,196,222]/255,'edgecolor',[119,136,153]/255); % mountain
% patch(x_rock2,y_rock2,[176,196,222]/255,'edgecolor',[119,136,153]/255); % mountain
% patch(x_rock4,y_rock4,[176,196,222]/255,'edgecolor',[119,136,153]/255); % mountain
% patch(x_rock5,y_rock5,[176,196,222]/255,'edgecolor',[119,136,153]/255); % mountain                                                                                          % insert MOUNTAINS here % % 
% patch([0 0 100 100],[0 35 35 0],[50,205,50]/255,'edgecolor',[50,205,50]/255); % grass
% patch(x_lake,y_lake,[176,224,230]/255,'edgecolor',[176,224,230]/255);
%  line([62 72],[22 22],'Color',[255,215,0]/255,'Linewidth',1); % sky reflection maybe?
%  line([70 86],[27 27],'Color',[255,215,0]/255,'Linewidth',1);
%  line([85 95],[24 24],'Color',[255,215,0]/255,'Linewidth',1);
%  line([80 90],[20 20],'Color',[255,215,0]/255,'Linewidth',1);
%  line([50 63],[24 24],'Color',[255,215,0]/255,'Linewidth',1);
% back trees
% patch([94 95.5 97 98.5],[34 44 44 34],[160,82,45]/255,'edgecolor',[160,82,45]/255); % BACK tree5: trunk
%  patch(x_tree5b,y_tree5b,[107,142,35]/255,'edgecolor',[107,142,35]/255);                    % green
%   patch([64 65.5 67 68.5],[34 44 44 34],[160,82,45]/255,'edgecolor',[160,82,45]/255); % tree2: trunk
%   patch(x_tree2b,y_tree2b,[0,100,0]/255,'edgecolor',[0,100,0]/255);                   % green
%    patch([54 55.5 57 58.5],[34 44 44 34],[160,82,45]/255,'edgecolor',[160,82,45]/255); % tree1: trunk
%    patch(x_tree1b,y_tree1b,[107,142,35]/255,'edgecolor',[107,142,35]/255);                       % green
%     patch([74 75.5 77 78.5],[34 44 44 34],[160,82,45]/255,'edgecolor',[160,82,45]/255); % tree3: trunk
%     patch(x_tree3b,y_tree3b,[107,142,35]/255,'edgecolor',[107,142,35]/255);                   % green
%      patch([84 85.5 87 88.5],[34 44 44 34],[160,82,45]/255,'edgecolor',[160,82,45]/255); % tree4: trunk
%      patch(x_tree4b,y_tree4b,[0,128,0]/255,'edgecolor',[0,128,0]/255);                      % green
% front trees
%  patch([90 91.5 93 94.5],[32 41 41 32],[139,69,19]/255,'edgecolor',[139,69,19]/255); % FRONT tree5: trunk
%  patch(x_tree5,y_tree5,[34,139,34]/255,'edgecolor',[34,139,34]/255);                    % green
%   patch([60 61.5 63 64.5],[32 41 41 32],[139,69,19]/255,'edgecolor',[139,69,19]/255); % tree2: trunk
%   patch(x_tree2,y_tree2,[34,139,34]/255,'edgecolor',[34,139,34]/255);                   % green
%    patch([50 51.5 53 54.5],[32 41 41 32],[139,69,19]/255,'edgecolor',[139,69,19]/255); % tree1: trunk
%    patch(x_tree1,y_tree1,[0,100,0]/255,'edgecolor',[0,100,0]/255);                       % green
%     patch([70 71.5 73 74.5],[32 41 41 32],[139,69,19]/255,'edgecolor',[139,69,19]/255); % tree3: trunk
%     patch(x_tree3,y_tree3,[0,128,0]/255,'edgecolor',[0,128,0]/255);                   % green
%      patch([80 81.5 83 84.5],[32 41 41 32],[139,69,19]/255,'edgecolor',[139,69,19]/255); % tree4: trunk
%      patch(x_tree4,y_tree4,[0,100,0]/255,'edgecolor',[0,100,0]/255);                      % green

% % MIDNIGHT % %
patch([0 0 100 100],[0 100 100 0],[25,25,112]/255,'edgecolor',[25,25,112]/255); hold on; % night sky
patch(x_moon1,y_moon1,[224,255,255]/255,'edgecolor',[224,255,255]/255); % toenail moon
patch(x_moon2,y_moon2,[25,25,112]/255,'edgecolor',[25,25,112]/255);
patch(x_rock3,y_rock3,[176,196,222]/255,'edgecolor',[119,136,153]/255); % mountain
patch(x_rock,y_rock,[176,196,222]/255,'edgecolor',[119,136,153]/255); % mountain
patch(x_rock1,y_rock1,[176,196,222]/255,'edgecolor',[119,136,153]/255); % mountain
patch(x_rock2,y_rock2,[176,196,222]/255,'edgecolor',[119,136,153]/255); % mountain
patch(x_rock4,y_rock4,[176,196,222]/255,'edgecolor',[119,136,153]/255); % mountain
patch(x_rock5,y_rock5,[176,196,222]/255,'edgecolor',[119,136,153]/255); % mountain
% insert MOUNTAINS here % %
patch([0 0 100 100],[0 35 35 0],[50,205,50]/255,'edgecolor',[50,205,50]/255); % grass

patch(x_lake,y_lake,[176,224,230]/255,'edgecolor',[176,224,230]/255); % lake
    line([56 63],[20 20],'Color',[224,255,255]/255,'Linewidth',1); % moon reflection
    line([59 65],[21 21],'Color',[224,255,255]/255,'Linewidth',0.8);
    line([62 68],[22 22],'Color',[224,255,255]/255,'Linewidth',1);
    line([63 67],[23 23],'Color',[224,255,255]/255,'Linewidth',0.8);
    line([64 66],[24 24],'Color',[224,255,255]/255,'Linewidth',1);
 patch(x_star1,y_star1,[224,255,255]/255,'edgecolor',[224,255,255]/255); % star1
 patch(x_star2,y_star2,[224,255,255]/255,'edgecolor',[224,255,255]/255); % star2
 patch(x_star3,y_star3,[224,255,255]/255,'edgecolor',[224,255,255]/255); % star3
 patch(x_star4,y_star4,[224,255,255]/255,'edgecolor',[224,255,255]/255); % star3
%back trees
patch([94 95.5 97 98.5],[34 44 44 34],[160,82,45]/255,'edgecolor',[160,82,45]/255); % BACK tree5: trunk
 patch(x_tree5b,y_tree5b,[107,142,35]/255,'edgecolor',[107,142,35]/255);                    % green
  patch([64 65.5 67 68.5],[34 44 44 34],[160,82,45]/255,'edgecolor',[160,82,45]/255); % tree2: trunk
  patch(x_tree2b,y_tree2b,[0,100,0]/255,'edgecolor',[0,100,0]/255);                   % green
   patch([54 55.5 57 58.5],[34 44 44 34],[160,82,45]/255,'edgecolor',[160,82,45]/255); % tree1: trunk
   patch(x_tree1b,y_tree1b,[107,142,35]/255,'edgecolor',[107,142,35]/255);                       % green
    patch([74 75.5 77 78.5],[34 44 44 34],[160,82,45]/255,'edgecolor',[160,82,45]/255); % tree3: trunk
    patch(x_tree3b,y_tree3b,[107,142,35]/255,'edgecolor',[107,142,35]/255);                   % green
     patch([84 85.5 87 88.5],[34 44 44 34],[160,82,45]/255,'edgecolor',[160,82,45]/255); % tree4: trunk
     patch(x_tree4b,y_tree4b,[0,128,0]/255,'edgecolor',[0,128,0]/255);                      % green
%front trees
 patch([90 91.5 93 94.5],[32 41 41 32],[139,69,19]/255,'edgecolor',[139,69,19]/255); % FRONT tree5: trunk
 patch(x_tree5,y_tree5,[34,139,34]/255,'edgecolor',[34,139,34]/255);                    % green
  patch([60 61.5 63 64.5],[32 41 41 32],[139,69,19]/255,'edgecolor',[139,69,19]/255); % tree2: trunk
  patch(x_tree2,y_tree2,[34,139,34]/255,'edgecolor',[34,139,34]/255);                   % green
   patch([50 51.5 53 54.5],[32 41 41 32],[139,69,19]/255,'edgecolor',[139,69,19]/255); % tree1: trunk
   patch(x_tree1,y_tree1,[0,100,0]/255,'edgecolor',[0,100,0]/255);                       % green
    patch([70 71.5 73 74.5],[32 41 41 32],[139,69,19]/255,'edgecolor',[139,69,19]/255); % tree3: trunk
    patch(x_tree3,y_tree3,[0,128,0]/255,'edgecolor',[0,128,0]/255);                   % green
     patch([80 81.5 83 84.5],[32 41 41 32],[139,69,19]/255,'edgecolor',[139,69,19]/255); % tree4: trunk
     patch(x_tree4,y_tree4,[0,100,0]/255,'edgecolor',[0,100,0]/255);                      % green

% % SUNRISE % %
% patch([0 0 100 100],[0 100 100 0],[255,182,193]/255,'edgecolor',[255,182,193]/255); hold on; % pink sky
%     patch(x_sun3,y_sun3,[255,99,71]/255,'edgecolor',[255,99,71]/255); % sun
%     line([99 99],[35 70],'Color',[255,99,71]/255,'Linewidth',1); % sun ray 1 (CCW)
%     line([99 91],[35 68],'Color',[255,99,71]/255,'Linewidth',1); % sun ray 2
%     line([100 83],[37 64],'Color',[255,99,71]/255,'Linewidth',1.2); % sun ray 3
%     line([98 78],[42 58],'Color',[255,99,71]/255,'Linewidth',1); % sun ray 4
%     line([90.6 76.5],[36 38.5],'Color',[255,99,71]/255,'Linewidth',1.35); % sun ray 5
%  patch(x_rock3,y_rock3,[176,196,222]/255,'edgecolor',[119,136,153]/255); % mountain
% patch(x_rock,y_rock,[176,196,222]/255,'edgecolor',[119,136,153]/255); % mountain
% patch(x_rock1,y_rock1,[176,196,222]/255,'edgecolor',[119,136,153]/255); % mountain
% patch(x_rock2,y_rock2,[176,196,222]/255,'edgecolor',[119,136,153]/255); % mountain
% patch(x_rock4,y_rock4,[176,196,222]/255,'edgecolor',[119,136,153]/255); % mountain
% patch(x_rock5,y_rock5,[176,196,222]/255,'edgecolor',[119,136,153]/255); % mountain
%                                                                                               % insert MOUNTAINS here % %
% patch([0 0 100 100],[0 35 35 0],[50,205,50]/255,'edgecolor',[50,205,50]/255); % grass

%patch(x_lake,y_lake,[176,224,230]/255,'edgecolor',[176,224,230]/255); % lake
%     line([93 98],[26 26],'Color',[255,165,0]/255,'Linewidth',1); % some sun reflection
%     line([92 98],[27 27],'Color',[255,165,0]/255,'Linewidth',0.8);
%     line([90 98],[28 28],'Color',[255,165,0]/255,'Linewidth',1);
%     line([90 97],[29 29],'Color',[255,165,0]/255,'Linewidth',0.8);
%     line([92 99],[30 30],'Color',[255,165,0]/255,'Linewidth',1);
% patch(x_star1,y_star1,[224,255,255]/255,'edgecolor',[224,255,255]/255); % star1
% %back trees
% patch([94 95.5 97 98.5],[34 44 44 34],[160,82,45]/255,'edgecolor',[160,82,45]/255); % BACK tree5: trunk
%  patch(x_tree5b,y_tree5b,[107,142,35]/255,'edgecolor',[107,142,35]/255);                    % green
%   patch([64 65.5 67 68.5],[34 44 44 34],[160,82,45]/255,'edgecolor',[160,82,45]/255); % tree2: trunk
%   patch(x_tree2b,y_tree2b,[0,100,0]/255,'edgecolor',[0,100,0]/255);                   % green
%    patch([54 55.5 57 58.5],[34 44 44 34],[160,82,45]/255,'edgecolor',[160,82,45]/255); % tree1: trunk
%    patch(x_tree1b,y_tree1b,[107,142,35]/255,'edgecolor',[107,142,35]/255);                       % green
%     patch([74 75.5 77 78.5],[34 44 44 34],[160,82,45]/255,'edgecolor',[160,82,45]/255); % tree3: trunk
%     patch(x_tree3b,y_tree3b,[107,142,35]/255,'edgecolor',[107,142,35]/255);                   % green
%      patch([84 85.5 87 88.5],[34 44 44 34],[160,82,45]/255,'edgecolor',[160,82,45]/255); % tree4: trunk
%      patch(x_tree4b,y_tree4b,[0,128,0]/255,'edgecolor',[0,128,0]/255);                      % green
%      %front trees
%  patch([90 91.5 93 94.5],[32 41 41 32],[139,69,19]/255,'edgecolor',[139,69,19]/255); % FRONT tree5: trunk
%  patch(x_tree5,y_tree5,[34,139,34]/255,'edgecolor',[34,139,34]/255);                    % green
%   patch([60 61.5 63 64.5],[32 41 41 32],[139,69,19]/255,'edgecolor',[139,69,19]/255); % tree2: trunk
%   patch(x_tree2,y_tree2,[34,139,34]/255,'edgecolor',[34,139,34]/255);                   % green
%    patch([50 51.5 53 54.5],[32 41 41 32],[139,69,19]/255,'edgecolor',[139,69,19]/255); % tree1: trunk
%    patch(x_tree1,y_tree1,[0,100,0]/255,'edgecolor',[0,100,0]/255);                       % green
%     patch([70 71.5 73 74.5],[32 41 41 32],[139,69,19]/255,'edgecolor',[139,69,19]/255); % tree3: trunk
%     patch(x_tree3,y_tree3,[0,128,0]/255,'edgecolor',[0,128,0]/255);                   % green
%      patch([80 81.5 83 84.5],[32 41 41 32],[139,69,19]/255,'edgecolor',[139,69,19]/255); % tree4: trunk
%      patch(x_tree4,y_tree4,[0,100,0]/255,'edgecolor',[0,100,0]/255);                      % green

set(gca, 'color', 'w', 'YTick', [], 'XTick', []); %remove x and y label


%%%%%%% set the ball and paddle %%%%%%
%delete(ball_anim)
ball_anim = plot(ball_x,ball_y,'o','Markersize',BALL_SIZE,'Markerfacecolor','g','Markeredgecolor','y'); %create ball
paddle_anim = line('Xdata',[paddle_x_left paddle_x_right],'Ydata',[paddle_y paddle_y],'Color','r','Linewidth',5); %paddle

%%%%%%%% set the walls %%%%%%%
line('Xdata',[WALL_X_MIN WALL_X_MIN],'Ydata',[WALL_Y_MIN WALL_Y_MAX],'Color','k','Linewidth',3); %left wall
line('Xdata',[WALL_X_MIN WALL_X_MAX],'Ydata',[WALL_Y_MAX WALL_Y_MAX],'Color','k','Linewidth',3); %top wall
line('Xdata',[WALL_X_MAX WALL_X_MAX],'Ydata',[WALL_Y_MIN WALL_Y_MAX],'Color','k','Linewidth',3); %right wall

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function moveBall %third function, compute ball movement including collision detection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global ball_x ball_y ball_vx ball_vy  DT
global WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX
global paddle_x_left paddle_x_right paddle_y
global game_over level
global PADDLE_SPEED
global ball_anim paddle_anim BALL_SIZE

n=40;
theta = linspace(0,2*pi,n);
theta_downhalf = linspace(-pi,0,40);
theta_uphalf = linspace(pi,0,40);
theta_L = linspace(pi/2,-pi/2,40);
theta_R = linspace(-pi/2,pi/2,40);
x_sun1 = 50+8*cos(theta_downhalf);      % noon
y_sun1 = 100+8*sin(theta_downhalf);
x_sun2 = 1+8*cos(theta);             % sunset
y_sun2 = 70+8*sin(theta);
x_sun3 = 100+8*cos(theta);             % sunrise
y_sun3 = 35+8*sin(theta);
x_moon1 = 60+8*cos(theta);             % midnight
y_moon1 = 91+8*sin(theta);
x_moon2 = 57+9*cos(theta);             
y_moon2 = 93+9*sin(theta);
x_rock = [0 10 20];
y_rock = [13 85 13];
x_rock1 = [-10 3 15];
y_rock1 = [13 70 13];
x_rock2 = [15 30 45];
y_rock2 = [13 77 13];
x_rock3 = [4 18 35];
y_rock3 = [13 75 13];
x_rock4 = [4 15 29];
y_rock4 = [13 55 13];
x_rock5 = [25 40 55];
y_rock5 = [13 60 13];
xtip=[8.5 10 11.5];
ytip=[75 85 75];
x_lake = 80+40*cos(theta);
y_lake = 23+8*sin(theta);
x_star1 = 78+0.5*cos(theta);    % STRS: high to low
y_star1 = 88+0.5*sin(theta);
x_star2 = 15+0.5*cos(theta);
y_star2 = 82+0.5*sin(theta);
x_star3 = 47+0.5*cos(theta);
y_star3 = 65+0.5*sin(theta);
x_star4 = 90+0.5*cos(theta);
y_star4 = 58+0.5*sin(theta);
x_tree1 = 52+6*cos(theta);      % TREES
y_tree1 = 46+9.5*sin(theta);
x_tree2 = 62+6*cos(theta); 
y_tree2 = 46+8*sin(theta);
x_tree3 = 72+5*cos(theta);
y_tree3 = 47.5+11*sin(theta);
x_tree4 = 82+5.5*cos(theta);
y_tree4 = 46+7*sin(theta);
x_tree5 = 92+6.5*cos(theta); % ideal boi
y_tree5 = 46+9*sin(theta);
x_tree1b = 56+6*cos(theta);      % BACK TREES with 1 pt height + 4pt to R
y_tree1b = 47+9.5*sin(theta);
x_tree2b = 66+6*cos(theta); 
y_tree2b = 47+8*sin(theta);
x_tree3b = 76+5*cos(theta);
y_tree3b = 48.5+8*sin(theta);
x_tree4b = 86+5.5*cos(theta);
y_tree4b = 48+9*sin(theta);
x_tree5b = 96+6.5*cos(theta); % ideal boi
y_tree5b = 48+10.5*sin(theta);

ball_x = ball_x + ball_vx*DT;
ball_y = ball_y + ball_vy*DT;
ex=1;
ey=1;

%   if (level>=2 && level<4)
%       delete(ball_anim);
%       delete(paddle_anim);
%       delete(patch([0 0 100 100],[0 35 35 0],[50,205,50]/255,'edgecolor',[50,205,50]/255)); % grass
% 
% delete(patch(x_lake,y_lake,[176,224,230]/255,'edgecolor',[176,224,230]/255)); % lake
%     delete(line([56 63],[20 20],'Color',[224,255,255]/255,'Linewidth',1)); % moon reflection
%     delete(line([59 65],[21 21],'Color',[224,255,255]/255,'Linewidth',0.8));
%     delete(line([62 68],[22 22],'Color',[224,255,255]/255,'Linewidth',1));
%     delete(line([63 67],[23 23],'Color',[224,255,255]/255,'Linewidth',0.8));
%     delete(line([64 66],[24 24],'Color',[224,255,255]/255,'Linewidth',1));
%  delete(patch(x_star1,y_star1,[224,255,255]/255,'edgecolor',[224,255,255]/255)); % star1
%  delete(patch(x_star2,y_star2,[224,255,255]/255,'edgecolor',[224,255,255]/255)); % star2
%  delete(patch(x_star3,y_star3,[224,255,255]/255,'edgecolor',[224,255,255]/255)); % star3
%  delete(patch(x_star4,y_star4,[224,255,255]/255,'edgecolor',[224,255,255]/255)); % star3
% %back trees
% delete(patch([94 95.5 97 98.5],[34 44 44 34],[160,82,45]/255,'edgecolor',[160,82,45]/255)); % BACK tree5: trunk
%  delete(patch(x_tree5b,y_tree5b,[107,142,35]/255,'edgecolor',[107,142,35]/255));                    % green
%   delete(patch([64 65.5 67 68.5],[34 44 44 34],[160,82,45]/255,'edgecolor',[160,82,45]/255)); % tree2: trunk
%   delete(patch(x_tree2b,y_tree2b,[0,100,0]/255,'edgecolor',[0,100,0]/255));                   % green
%    delete(patch([54 55.5 57 58.5],[34 44 44 34],[160,82,45]/255,'edgecolor',[160,82,45]/255)); % tree1: trunk
%    delete(patch(x_tree1b,y_tree1b,[107,142,35]/255,'edgecolor',[107,142,35]/255));                       % green
%     delete(patch([74 75.5 77 78.5],[34 44 44 34],[160,82,45]/255,'edgecolor',[160,82,45]/255)); % tree3: trunk
%     delete(patch(x_tree3b,y_tree3b,[107,142,35]/255,'edgecolor',[107,142,35]/255));                   % green
%      delete(patch([84 85.5 87 88.5],[34 44 44 34],[160,82,45]/255,'edgecolor',[160,82,45]/255)); % tree4: trunk
%      delete(patch(x_tree4b,y_tree4b,[0,128,0]/255,'edgecolor',[0,128,0]/255));                      % green
% %front trees
%  delete(patch([90 91.5 93 94.5],[32 41 41 32],[139,69,19]/255,'edgecolor',[139,69,19]/255)); % FRONT tree5: trunk
%  delete(patch(x_tree5,y_tree5,[34,139,34]/255,'edgecolor',[34,139,34]/255));                    % green
%   delete(patch([60 61.5 63 64.5],[32 41 41 32],[139,69,19]/255,'edgecolor',[139,69,19]/255)); % tree2: trunk
%   delete(patch(x_tree2,y_tree2,[34,139,34]/255,'edgecolor',[34,139,34]/255));                   % green
%    delete(patch([50 51.5 53 54.5],[32 41 41 32],[139,69,19]/255,'edgecolor',[139,69,19]/255)); % tree1: trunk
%    delete(patch(x_tree1,y_tree1,[0,100,0]/255,'edgecolor',[0,100,0]/255));                       % green
%     delete(patch([70 71.5 73 74.5],[32 41 41 32],[139,69,19]/255,'edgecolor',[139,69,19]/255)); % tree3: trunk
%     delete(patch(x_tree3,y_tree3,[0,128,0]/255,'edgecolor',[0,128,0]/255));                   % green
%      delete(patch([80 81.5 83 84.5],[32 41 41 32],[139,69,19]/255,'edgecolor',[139,69,19]/255)); % tree4: trunk
%      delete(patch(x_tree4,y_tree4,[0,100,0]/255,'edgecolor',[0,100,0]/255));                      % green
% 
% patch([0 0 100 100],[0 100 100 0],[255,182,193]/255,'edgecolor',[255,182,193]/255); hold on; % pink sky
%     patch(x_sun3,y_sun3,[255,99,71]/255,'edgecolor',[255,99,71]/255); % sun
%     line([99 99],[35 70],'Color',[255,99,71]/255,'Linewidth',1); % sun ray 1 (CCW)
%     line([99 91],[35 68],'Color',[255,99,71]/255,'Linewidth',1); % sun ray 2
%     line([100 83],[37 64],'Color',[255,99,71]/255,'Linewidth',1.2); % sun ray 3
%     line([98 78],[42 58],'Color',[255,99,71]/255,'Linewidth',1); % sun ray 4
%     line([90.6 76.5],[36 38.5],'Color',[255,99,71]/255,'Linewidth',1.35); % sun ray 5
%  patch(x_rock3,y_rock3,[176,196,222]/255,'edgecolor',[119,136,153]/255); % mountain
% patch(x_rock,y_rock,[176,196,222]/255,'edgecolor',[119,136,153]/255); % mountain
% patch(x_rock1,y_rock1,[176,196,222]/255,'edgecolor',[119,136,153]/255); % mountain
% patch(x_rock2,y_rock2,[176,196,222]/255,'edgecolor',[119,136,153]/255); % mountain
% patch(x_rock4,y_rock4,[176,196,222]/255,'edgecolor',[119,136,153]/255); % mountain
% patch(x_rock5,y_rock5,[176,196,222]/255,'edgecolor',[119,136,153]/255); % mountain
%                                                                                               % insert MOUNTAINS here % %
% patch([0 0 100 100],[0 35 35 0],[50,205,50]/255,'edgecolor',[50,205,50]/255); % grass
% 
% patch(x_lake,y_lake,[176,224,230]/255,'edgecolor',[176,224,230]/255); % lake
%     line([93 98],[26 26],'Color',[255,165,0]/255,'Linewidth',1); % some sun reflection
%     line([92 98],[27 27],'Color',[255,165,0]/255,'Linewidth',0.8);
%     line([90 98],[28 28],'Color',[255,165,0]/255,'Linewidth',1);
%     line([90 97],[29 29],'Color',[255,165,0]/255,'Linewidth',0.8);
%     line([92 99],[30 30],'Color',[255,165,0]/255,'Linewidth',1);
% patch(x_star1,y_star1,[224,255,255]/255,'edgecolor',[224,255,255]/255); % star1
% %back trees
% patch([94 95.5 97 98.5],[34 44 44 34],[160,82,45]/255,'edgecolor',[160,82,45]/255); % BACK tree5: trunk
%  patch(x_tree5b,y_tree5b,[107,142,35]/255,'edgecolor',[107,142,35]/255);                    % green
%   patch([64 65.5 67 68.5],[34 44 44 34],[160,82,45]/255,'edgecolor',[160,82,45]/255); % tree2: trunk
%   patch(x_tree2b,y_tree2b,[0,100,0]/255,'edgecolor',[0,100,0]/255);                   % green
%    patch([54 55.5 57 58.5],[34 44 44 34],[160,82,45]/255,'edgecolor',[160,82,45]/255); % tree1: trunk
%    patch(x_tree1b,y_tree1b,[107,142,35]/255,'edgecolor',[107,142,35]/255);                       % green
%     patch([74 75.5 77 78.5],[34 44 44 34],[160,82,45]/255,'edgecolor',[160,82,45]/255); % tree3: trunk
%     patch(x_tree3b,y_tree3b,[107,142,35]/255,'edgecolor',[107,142,35]/255);                   % green
%      patch([84 85.5 87 88.5],[34 44 44 34],[160,82,45]/255,'edgecolor',[160,82,45]/255); % tree4: trunk
%      patch(x_tree4b,y_tree4b,[0,128,0]/255,'edgecolor',[0,128,0]/255);                      % green
%      %front trees
%  patch([90 91.5 93 94.5],[32 41 41 32],[139,69,19]/255,'edgecolor',[139,69,19]/255); % FRONT tree5: trunk
%  patch(x_tree5,y_tree5,[34,139,34]/255,'edgecolor',[34,139,34]/255);                    % green
%   patch([60 61.5 63 64.5],[32 41 41 32],[139,69,19]/255,'edgecolor',[139,69,19]/255); % tree2: trunk
%   patch(x_tree2,y_tree2,[34,139,34]/255,'edgecolor',[34,139,34]/255);                   % green
%    patch([50 51.5 53 54.5],[32 41 41 32],[139,69,19]/255,'edgecolor',[139,69,19]/255); % tree1: trunk
%    patch(x_tree1,y_tree1,[0,100,0]/255,'edgecolor',[0,100,0]/255);                       % green
%     patch([70 71.5 73 74.5],[32 41 41 32],[139,69,19]/255,'edgecolor',[139,69,19]/255); % tree3: trunk
%     patch(x_tree3,y_tree3,[0,128,0]/255,'edgecolor',[0,128,0]/255);                   % green
%      patch([80 81.5 83 84.5],[32 41 41 32],[139,69,19]/255,'edgecolor',[139,69,19]/255); % tree4: trunk
%      patch(x_tree4,y_tree4,[0,100,0]/255,'edgecolor',[0,100,0]/255);                      % green
% 
%         % delete(ball_anim)
%        %  delete(paddle_anim)
% ball_anim = plot(ball_x,ball_y,'o','Markersize',BALL_SIZE,'Markerfacecolor','g','Markeredgecolor','y'); %create ball
% paddle_anim = line('Xdata',[paddle_x_left paddle_x_right],'Ydata',[paddle_y paddle_y],'Color','r','Linewidth',5); %paddle
%      end

if (ball_y>=WALL_Y_MAX)
        ball_vx=ball_vx;
        ball_vy=-ey*(ball_vy);
end
%%%%%%%% Basic pong edit #1: %%%%%%%%%%%%
% Write code to move the ball here. You code will include logic to get the ball to 
% detect the left, right, and top wall and the paddle and subsequently to change its
% movement based on which wall/paddle the ball hits.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if (ball_x<=WALL_X_MIN)
    ball_vy=ball_vy;
    ball_vx=-ex*ball_vx;
end
if(ball_x>=WALL_X_MAX)
    ball_vy=ball_vy;
    ball_vx=-ex*ball_vx;
end
if (ball_x>=paddle_x_left && ball_x<=paddle_x_right && ball_y<=paddle_y)
     ball_vx=ball_vx;
     ball_vy=-ey*(ball_vy);
     level=level+1;
     title(['Welcome to the Unbeatable Game - Your Score is ',num2str(level)],'Fontsize',14);
     PADDLE_SPEED = PADDLE_SPEED+.1;
     DT = DT+.1; 
%      if ball_y+ball_vy*DT < WALL_Y_MIN
%          ball_y=WALL_Y_MIN;
%      end
elseif (ball_y <= WALL_Y_MIN || ball_y<paddle_y)
     game_over = 1;
     title(['GAME OVER - Your Score is ',num2str(level)],'Fontsize',20);
     n=40;
     theta = linspace(0,2*pi,n);
     theta_dhalf = linspace(pi,2*pi,n);
     x_dead = 50+45*cos(theta);  % % FROWNY FACE CUZ YOU DEAD % % 
     y_dead = 50+50*sin(theta);
     x_tongue = 70+5*cos(theta_dhalf); % tongue
     y_tongue = 35+7*sin(theta_dhalf);
     patch(x_dead,y_dead,[178, 190, 181]/255,'edgecolor',[16,1,1]/255);
     line([25 35],[55 65],'Color',[16,1,1]/255,'Linewidth',3); % right eye
     line([25 35],[65 55],'Color',[16,1,1]/255,'Linewidth',3);
     line([65 75],[65 75],'Color',[16,1,1]/255,'Linewidth',3); % left eye
     line([65 75],[75 65],'Color',[16,1,1]/255,'Linewidth',3);
     patch(x_tongue,y_tongue,[219,92,92]/255,'edgecolor',[16,1,1]/255); % tongue
     line([25 75],[35 35],'Color',[16,1,1]/255,'Linewidth',3); % mouth
     
     if (game_over == 1 && level == 0)
         title(['You Can Do Better - Your Score is ',num2str(level)],'Fontsize',20);
         n=40;
         theta = linspace(0,2*pi,n);
         x_dead = 50+45*cos(theta);  % % PATENTED TJ SQUINT % % 
         y_dead = 50+50*sin(theta);
         patch(x_dead,y_dead,[255,227,159]/255,'edgecolor',[16,1,1]/255);
         line([25 45],[65 65],'Color',[16,1,1]/255,'Linewidth',4); % R EYE
         line([55 75],[65 65],'Color',[16,1,1]/255,'Linewidth',4); % L EYE
         line([25 75],[35 35],'Color',[16,1,1]/255,'Linewidth',4); % mouth
         
     elseif (game_over == 1 && level >= 10)
         title(['You Are a Worthy Challenger - Your Score is ',num2str(level)],'Fontsize',16); 
         n=40;
         theta = linspace(0,2*pi,n);
         x_dead = 50+45*cos(theta);  % % SO AWESOME % % 
         y_dead = 50+50*sin(theta);
         x_coolR = 42+2*cos(theta);  % R EYE
         y_coolR = 62+3*sin(theta);
         x_coolL = 72+2*cos(theta);  % L EYE
         y_coolL = 62+3*sin(theta);
         patch(x_dead,y_dead,[255,227,159]/255,'edgecolor',[16,1,1]/255);
         line([25 45],[65 65],'Color',[16,1,1]/255,'Linewidth',4); % R EYE
         line([55 75],[65 65],'Color',[16,1,1]/255,'Linewidth',4); % L EYE
         patch(x_coolR,y_coolR,[16,1,1]/255,'edgecolor',[16,1,1]/255); % cool R eye
         patch(x_coolL,y_coolL,[16,1,1]/255,'edgecolor',[16,1,1]/255); % cool L eye
         line([35 65],[25 27],'Color',[16,1,1]/255,'Linewidth',4); % mouth1
         line([65 75],[27 37],'Color',[16,1,1]/255,'Linewidth',4); % mouth2
     end
   
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function movePaddle %fourth function, compute paddle position based on user input. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global PADDLE_VX 
global PADDLE_WIDTH DT
global paddle_x_left paddle_x_right
global WALL_X_MIN WALL_X_MAX

paddle_x_left = paddle_x_left + PADDLE_VX*DT;
paddle_x_right = paddle_x_left + PADDLE_WIDTH; 
if (paddle_x_left<=WALL_X_MIN)
        PADDLE_VX=0;
        paddle_x_left=WALL_X_MIN;  %THESE TWO LINES GET IT TO STOP AT LEFT WALL
else if (paddle_x_right>=WALL_X_MAX)
        PADDLE_VX=0;
        paddle_x_right=WALL_X_MAX;
        paddle_x_left=80; %THIS IS ESSENTIAL TO GET IT TO STOP AT RIGHT WALL
        %IF WANT IT TO SHOOT OUT OTHER SIDE, CHANGE # TO 0
    end
end

%%%%%%%% Basic pong edit #2: %%%%%%%%%%%%
% Write code to move the paddle here. Your code will include logic to get
% the paddle to detect the left and right wall and to avoid it from
% penetrating either walls. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function refreshPlot %fifth function, refresh plot based on moveBall and movePaddle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global ball_x ball_y
global ball_anim paddle_anim
global paddle_x_left paddle_x_right paddle_y
global DELAY

set(ball_anim, 'XData', ball_x, 'YData', ball_y);
set(paddle_anim, 'Xdata',[paddle_x_left paddle_x_right], 'YData', [paddle_y paddle_y]);
drawnow;
pause(DELAY);   


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function keyDown(src,event) %called from initFigure to take key press to move the paddle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global PADDLE_VX PADDLE_SPEED game_over

switch event.Key
  case 'rightarrow'
    PADDLE_VX = PADDLE_SPEED;
  case 'leftarrow'
    PADDLE_VX = -PADDLE_SPEED;
  case 'q'
    game_over=1; %q key ends game
    close(1);
  case 'space' %space bar restarts game
    close all
    initData  %first function, initialize the data variables
    initFigure
    while ~game_over %runs till game_over = 1
    moveBall; %third function, compute ball movement including collision detection
    movePaddle; %fourth function, compute paddle position based on user input. 
    refreshPlot;
    end
  otherwise
    PADDLE_VX = 0;
end
