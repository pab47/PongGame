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
BALL_SIZE = 10;
BALL_INIT_VX = -5;
BALL_INIT_VY = -7;
PADDLE_VX = 0;
PADDLE_SPEED = 8; 
DT = 0.1; 
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
global obj1 obj2 obj3
global obj1_left obj1_right obj2_left obj2_right obj3_left obj3_right
global obj1_ymin obj1_ymax obj2_ymin obj2_ymax obj3_ymin obj3_ymax


obj1_left = 15;
obj1_right = 30;
obj2_left = 42.5;
obj2_right = 57.5;
obj3_left = 70;
obj3_right = 85;
obj1_ymin = 70;
obj1_ymax = 75;
obj2_ymin = 52.5;
obj2_ymax = 57.5;
obj3_ymin = 70;
obj3_ymax = 75;



fig = figure; %initialize the figure
set(fig, 'Resize', 'off'); %do not allow figure to resize
set(fig,'KeyPressFcn',@keyDown); %setkey presses for later
ball_x = WALL_X_MAX - 2.5; %0.5*(WALL_X_MIN+WALL_X_MAX); 
ball_y = WALL_Y_MAX - 2.5 ;
ball_vx = BALL_INIT_VX; 
ball_vy = BALL_INIT_VY;
paddle_x_left = 0;
paddle_x_right = PADDLE_WIDTH;
paddle_y = 10;
axis([WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX]); %set the size of the board.
axis manual;
hold on;
title(['Score = ',num2str(level)],'Fontsize',14);
xlabel('Move Left = Left Arrow and Move Right = Right Arrow, Stop = Down Arrow')
set(gca, 'color', 'w', 'YTick', [], 'XTick', []); %remove x and y label

%%%%%%% set the ball and paddle %%%%%%
patch([0 100 100 0],[0 0 5 5],'b'); 
set(gcf,'color','c'); hold on
ball_anim = plot(ball_x,ball_y,'o','Markersize',BALL_SIZE,'Markerfacecolor', rand(1,3),'Markeredgecolor',rand(1,3));%create ball
paddle_anim = line('Xdata',[paddle_x_left paddle_x_right],'Ydata',[paddle_y paddle_y],'Color','k','Linewidth',5); %paddle
obj2 = line('Xdata',[obj2_left obj2_right],'Ydata',[55 55],'Color','w','Linewidth',5); %obstacle 2
obj3 = line('Xdata',[obj3_left obj3_right],'Ydata',[72.5 72.5],'Color','w','Linewidth',5); %obstacle 3
obj1 = line('Xdata',[obj1_left obj1_right],'Ydata',[72.5 72.5],'Color','w','Linewidth',5); %obstacle 1
hold on


%line('Xdata',[22 28],'Ydata',[32.5 32.5],'Color','k','Linewidth',5); %obstacle 4 
%line('Xdata',[72 78],'Ydata',[32.5 32.5],'Color','k','Linewidth',5); %obstacle 5 

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
global obj1_left obj1_right obj2_left obj2_right obj3_left obj3_right
global obj3_ymin obj3_ymax obj1_ymin obj1_ymax obj2_ymin obj2_ymax
global obj1 obj2 obj3
global ball_anim BALL_SIZE


ball_x = ball_x + ball_vx*DT;
ball_y = ball_y + ball_vy*DT;

ex = 1 +.015;
ey = 1 +.015;


 
%%%%%%%% Basic pong edit #1: %%%%%%%%%%%%
% Write code to move the ball here. You code will include logic to get the ball to 
% detect the left, right, and top wall and the paddle and subsequently to change its
% movement based on which wall/paddle the ball hits.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ball_x <= WALL_X_MIN + 2.5 || ball_x > WALL_X_MAX 
    
    ball_vx = -ex*ball_vx;
    ball_vy = ball_vy;
    ball_anim = plot(ball_x,ball_y,'o','Markersize',BALL_SIZE,'Markerfacecolor', rand(1,3),'Markeredgecolor',rand(1,3));%create ball
  
elseif ball_y <= paddle_y + 2.5 && ball_y >= paddle_y - 2.5 && ball_x >= paddle_x_left && ball_x <= paddle_x_right  
     
    ball_vy = -ey*ball_vy;
    ball_vx =  ball_vx;
    ball_anim = plot(ball_x,ball_y,'o','Markersize',BALL_SIZE,'Markerfacecolor', rand(1,3),'Markeredgecolor',rand(1,3));%create ball
    level = level + 1; %Score incrementation for touching the paddle
    title(['Score = ',num2str(level)],'Fontsize',14);
    
elseif ball_y > WALL_Y_MAX - 2.5
    
    ball_vy = -ey*ball_vy;
    ball_vx =  ball_vx;
    ball_anim = plot(ball_x,ball_y,'o','Markersize',BALL_SIZE,'Markerfacecolor', rand(1,3),'Markeredgecolor',rand(1,3));%create ball
    
    
elseif ball_x > obj3_left -2.5 && ball_x < obj3_right + 2.5 && ball_y <= obj3_ymax && ball_y >= obj3_ymin  
    
    ball_vx = ball_vx;
    ball_vy = -ey*ball_vy;
    %Next line changes obstacle color per obstacle collision
    obj2 = line('Xdata',[obj2_left obj2_right],'Ydata',[55 55],'Color','w','Linewidth',5); %obstacle 2
    obj3 = line('Xdata',[obj3_left obj3_right],'Ydata',[72.5 72.5],'Color','g','Linewidth',5); %obstacle 3
    obj1 = line('Xdata',[obj1_left obj1_right],'Ydata',[72.5 72.5],'Color','w','Linewidth',5); %obstacle 1
    
    ball_anim = plot(ball_x,ball_y,'o','Markersize',BALL_SIZE,'Markerfacecolor', rand(1,3),'Markeredgecolor',rand(1,3));%create ball


    
elseif ball_x > obj1_left -2.5 && ball_x <= obj1_right + 2.5 && ball_y <= obj1_ymax && ball_y >= obj1_ymin

    ball_vx = ball_vx;
    ball_vy = -ey*ball_vy;
    %Next line changes obstacle color per obstacle collision
    obj2 = line('Xdata',[obj2_left obj2_right],'Ydata',[55 55],'Color','w','Linewidth',5); %obstacle 2
    obj3 = line('Xdata',[obj3_left obj3_right],'Ydata',[72.5 72.5],'Color','w','Linewidth',5); %obstacle 3
    obj1 = line('Xdata',[obj1_left obj1_right],'Ydata',[72.5 72.5],'Color','b','Linewidth',5); %obstacle 1

    ball_anim = plot(ball_x,ball_y,'o','Markersize',BALL_SIZE,'Markerfacecolor', rand(1,3),'Markeredgecolor',rand(1,3));%create ball

elseif ball_x > obj2_left -2.5 && ball_x < obj2_right + 2.5 && ball_y <= obj2_ymax && ball_y >= obj2_ymin

    ball_vx = ball_vx;
    ball_vy = -ey*ball_vy;
    %Next line changes obstacle color per obstacle collision
    obj2 = line('Xdata',[obj2_left obj2_right],'Ydata',[55 55],'Color','y','Linewidth',5); %obstacle 2
    obj3 = line('Xdata',[obj3_left obj3_right],'Ydata',[72.5 72.5],'Color','w','Linewidth',5); %obstacle 3
    obj1 = line('Xdata',[obj1_left obj1_right],'Ydata',[72.5 72.5],'Color','w','Linewidth',5); %obstacle 1
    
    ball_anim = plot(ball_x,ball_y,'o','Markersize',BALL_SIZE,'Markerfacecolor', rand(1,3),'Markeredgecolor',rand(1,3));%create ball
    
    
end

if (ball_y < WALL_Y_MIN)
     game_over = 1;
     textColor = 'cyan';
     text(50,50,'NEXT TIME LOSER', 'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',20)
     title(['High Score = ',num2str(level)],'Fontsize',14);
   
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

if paddle_x_left >= 80
    paddle_x_left = 80;
end
if paddle_x_left <= 0 
    paddle_x_left = 0;
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
global PADDLE_VX PADDLE_SPEED

switch event.Key
  case 'rightarrow' 
    PADDLE_VX = PADDLE_SPEED;
  case 'leftarrow'
    PADDLE_VX = -PADDLE_SPEED;
  otherwise
    PADDLE_VX = 0;

end