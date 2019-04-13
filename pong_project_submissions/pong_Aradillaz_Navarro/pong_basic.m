function pong_basic
%Modified the pong code by David Buckingham
%https://www.mathworks.com/matlabcentral/fileexchange/31177-dave-s-matlab-pong

%%%%%% main part of the code %%%
global game_over

close all
initData  %first function, initialize the data variables
initFigure %second function, initialize the figure
while ~game_over %runs till game_over = 1
    moveBall; %third function, compute ball movement including collision detection
    movePaddle; %fourth function, compute paddle position based on user input. 
    refreshPlot; %fifth function, refresh plot based on moveBall and movePaddle
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function initData %first function, initialize the data variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX
global PADDLE_WIDTH BALL_SIZE %Target_WIDTH Target2_Width Target3_Width
global BALL_INIT_VX BALL_INIT_VY DT ex ey DELAY
global PADDLE_VX PADDLE_SPEED 
global game_over level count score
global goal1_x goal1_y red_x red_y 

level = 1;
count = 0;
score = 0;
game_over = 0;
WALL_X_MIN = 0;
WALL_X_MAX = 100;
WALL_Y_MIN = 0;
WALL_Y_MAX = 100;
PADDLE_WIDTH = 20;
BALL_SIZE = 10;
Angle = randi([5,45]);
% Target_WIDTH = 1; 
% Target2_Width = 80;
% Target3_Width = 60;
BALL_INIT_VX = -8*cosd(Angle);
BALL_INIT_VY = -8*sind(Angle);
PADDLE_VX = 0;
PADDLE_SPEED = 6; 
DT = 0.1; 
ex = 2;
ey = 2;
DELAY = 0.001;
goal1_x = randi([10 90])
goal1_y = randi([10 90])
red_x = randi([10 90])
red_y = randi([10 90])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function initFigure %second function, initialize the figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global PADDLE_WIDTH BALL_SIZE % Target_WIDTH Target2_Width Target3_Width
global WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX
global BALL_INIT_VX BALL_INIT_VY
global ball_x ball_y ball_vx ball_vy 
global paddle_x_left paddle_x_right paddle_y %Target_y_up Target_y_down Target_x Target2_x_left Target2_x_right Target2_y Target3_x_left Target3_x_right Target3_y
global ball_anim paddle_anim % target_anim target2_anim target3_anim
global level score linescore
global goal1_x goal1_y goal1_box red_x red_y red_box

fig = figure; %initialize the figure
set(fig, 'Resize', 'off'); %do not allow figure to resize
set(fig,'KeyPressFcn',@keyDown); %setkey presses for later
ball_x = WALL_X_MAX; %0.5*(WALL_X_MIN+WALL_X_MAX); 
ball_y = WALL_Y_MAX;
ball_vx = BALL_INIT_VX; 
ball_vy = BALL_INIT_VY;
% Target_y_up = (80);%NEW TARGET
% Target_y_down = 40 ; %NEW TARGET
% Target_x = Target_WIDTH;
% Target2_x_left = 40;
% Target2_x_right = Target2_Width;
% Target2_y = 99;
% Target3_x_left = 40;
% Target3_x_right = Target3_Width;
% Target3_y = 99; 
paddle_x_left = 0;
paddle_x_right = PADDLE_WIDTH;
paddle_y = 10;
axis([WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX]); %set the size of the board.
axis manual;
hold on;
title(['press keys <left/right> to move the paddle; level = ',num2str(level)],'Fontsize',14);
set(gca, 'color', 'w', 'YTick', [], 'XTick', []); %remove x and y label
xlabel('Karen and Marios Pong Game')
img = imread('space.jpg');  
hold on;
image([WALL_X_MIN WALL_X_MAX],[WALL_Y_MAX WALL_Y_MIN],img);
%%%%%%% set the ball and paddle %%%%%%
ball_anim = plot(ball_x,ball_y,'o','Markersize',BALL_SIZE,'Markerfacecolor','y','Markeredgecolor','y'); %create ball
paddle_anim = line('Xdata',[paddle_x_left paddle_x_right],'Ydata',[paddle_y paddle_y],'Color','g','Linewidth',5); %paddle
%Goals
goal1_box = patch('XData',[goal1_x goal1_x goal1_x+3 goal1_x+3],...
                  'YData',[goal1_y goal1_y+3 goal1_y+3 goal1_y]);
set(goal1_box,'FaceColor','w');              

%red anti goals
red_box = patch('XData',[red_x red_x red_x+2.5 red_x+2.5],...
                  'YData',[red_y red_y+2.5 red_y+2.5 red_y]);
set(red_box,'FaceColor','r');              

% target_anim = line('Xdata',[Target_x Target_x],'Ydata',[Target_y_up Target_y_down],'Color','w','Linewidth',5); %New Target upper left
% target2_anim = line('Xdata',[Target2_y Target2_y],'Ydata',[Target2_x_left Target2_x_right],'Color','w','Linewidth',5);%Target upper right
% target3_anim =  line('Xdata',[Target3_x_left Target3_x_right],'Ydata',[Target3_y Target3_y],'Color','w','Linewidth',5);%Target lowest in middle
linescore = {'Score: ',num2str(level-1)};
dim = [0 .8 .11 .11];
score = annotation('textbox',dim,'String',linescore,'FontSize',14,'EdgeColor','none');
% plot(Target_x,Target_y,'o','Markersize',Target_Size,'Markerfacecolor','r','Markeredgecolor','r');
% old target above in green 
%%%%%%%% set the walls %%%%%%%
line('Xdata',[WALL_X_MIN WALL_X_MIN],'Ydata',[WALL_Y_MIN WALL_Y_MAX],'Color','r','Linewidth',3); %left wall
line('Xdata',[WALL_X_MIN WALL_X_MAX],'Ydata',[WALL_Y_MAX WALL_Y_MAX],'Color','r','Linewidth',3); %top wall
line('Xdata',[WALL_X_MAX WALL_X_MAX],'Ydata',[WALL_Y_MIN WALL_Y_MAX],'Color','r','Linewidth',3); %right wall


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function moveBall %third function, compute ball movement including collision detection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global ball_x ball_y ball_vx ball_vy  DT 
global WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX
global paddle_x_left paddle_x_right paddle_y
global game_over level linescore
global goal1_x goal1_y goal1_box 
global red_x red_y red_box

%global Target2_y Target2_x_left Target2_x_right
% global Target2_x_left Target2_x_right Target2_y Target_x_left Target_x_right Target_y
ball_x = ball_x + ball_vx*DT;
ball_y = ball_y + ball_vy*DT;
ex=1;
ey=1;
%%%%%%%% Basic pong edit #1: %%%%%%%%%%%%
% x y vx vy  Posiiton and Velocity, Treated as a Point
% Write code to move the ball here. You code will include logic to get the ball to 
% detect the left, right, and top wall and the paddle and subsequently to change its
% movement based on which wall/paddle the ball hits.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%does the ball hit the side walls
if ball_x <= WALL_X_MIN +2.5 || ball_x == WALL_X_MAX
%     ball_vx = -ex*ball_vx;
    ball_vy = ball_vy;
    ball_x = WALL_X_MIN +98; % to make the ball appear on the other wall
end

%When the ball hits the top
if ball_y > WALL_Y_MAX
    ball_vy =-(ball_vy+(rand/2));
end
%if it hits the paddle
if ball_y <= paddle_y +1 && ball_y>=paddle_y 
    if ball_x < paddle_x_right && ball_x > paddle_x_left
    %ball_vx = -ball_vx;
    ball_vy = abs(ball_vy);
    level = level+1;
    linescore = {'Score: ',num2str(level-1)};
    end
end
%goal 
if ball_y <= goal1_y +5 && ball_y >= goal1_y
    if ball_x <= goal1_x +5 && ball_x >= goal1_x
    level = level+1;
    linescore = {'Score: ',num2str(level-1)};
    set(goal1_box,'XData',[1 1 1 1],'YData',[1 1 1 1]);
    drawnow;
    end
end
% what if ball hits red 
if ball_y <= red_y +5 && ball_y >= red_y
    if ball_x <= red_x +5 && ball_x >= red_x
    level = level-1;
    linescore = {'Score: ',num2str(level-1)};
    set(red_box,'XData',[0 0 0 0],'YData',[0 0 0 0]);
    drawnow;
    end
end
if (ball_y < WALL_Y_MIN)
     game_over = 1;
     disp('YOU LOSE TRY AGAIN IF YOU DARE')
     score = level-1;
     fprintf('Your score: %2.0f\n', score)
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

if paddle_x_left <= WALL_X_MIN
   paddle_x_left = WALL_X_MIN;
end
if paddle_x_right >= WALL_X_MAX 
   paddle_x_left = WALL_X_MAX - PADDLE_WIDTH;
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
global DELAY score linescore

set(ball_anim, 'XData', ball_x, 'YData', ball_y);
set(paddle_anim, 'Xdata',[paddle_x_left paddle_x_right], 'YData', [paddle_y paddle_y]);
set(score, 'String',linescore);
drawnow;
pause(DELAY);   


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function keyDown(src,event) %called from initFigure to take key press to move the paddle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global PADDLE_VX PADDLE_SPEED

switch event.Key
  case 'rightarrow'
    PADDLE_VX = PADDLE_SPEED;
  case 'leftarrow'
    PADDLE_VX = -PADDLE_SPEED;
  otherwise
    PADDLE_VX = 0;
end

