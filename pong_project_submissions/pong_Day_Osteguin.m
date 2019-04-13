function pong_Day_Osteguin
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
global PADDLE_VX PADDLE_VY PADDLE_SPEED_X PADDLE_SPEED_Y
global game_over Score1
global ex ex2

Score1 = 0;
game_over = 0;
WALL_X_MIN = 0;
WALL_X_MAX = 100;
WALL_Y_MIN = 0;
WALL_Y_MAX = 100;
PADDLE_WIDTH = 20;
BALL_SIZE = 10;
BALL_INIT_VX = -8;
BALL_INIT_VY = -8;
PADDLE_VX = 0;
PADDLE_VY = 0;
PADDLE_SPEED_X = 8; 
PADDLE_SPEED_Y = 3; 
DT = 0.1; 
DELAY = 0.001;
ex = 1+0.1*rand;
ex2 = 1+0.1*rand;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function initFigure %second function, initialize the figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global PADDLE_WIDTH BALL_SIZE 
global WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX
global BALL_INIT_VX BALL_INIT_VY
global ball_x ball_y ball_vx ball_vy 
global paddle_x_left paddle_x_right paddle_y
global ball_anim paddle_anim
global Score


fig = figure; %initialize the figure
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
Score = text(0,WALL_Y_MAX-WALL_Y_MAX/20,' Score: 0',...
    'FontName','FixedWidth',...
    'Color','b',...
    'FontWeight','Bold',...
    'FontUnits','normalized');

hold on;
title(['Arrow keys to move paddle, any other key to stop'],'FontName','FixedWidth','Fontsize',14);
xlabel('Carolyn Day and Vangelina Osteguin');
% title(['press keys <left/right> to move the paddle; Score = ',num2str(Score)],'Fontsize',14);
set(gca, 'color', 'w', 'YTick', [], 'XTick', []); %remove x and y label

%%%%%%% set the ball and paddle %%%%%%
ball_anim = plot(ball_x,ball_y,'o','Markersize',BALL_SIZE,'Markerfacecolor','r','Markeredgecolor','w'); %create ball
paddle_anim = line('Xdata',[paddle_x_left paddle_x_right],'Ydata',[paddle_y paddle_y],'Color','g','Linewidth',5); %paddle

%%%%%%%% set the walls %%%%%%%
line('Xdata',[WALL_X_MIN WALL_X_MIN],'Ydata',[WALL_Y_MIN WALL_Y_MAX],'Color','k','Linewidth',3); %left wall
line('Xdata',[WALL_X_MIN WALL_X_MAX],'Ydata',[WALL_Y_MAX WALL_Y_MAX],'Color','k','Linewidth',3); %top wall
line('Xdata',[WALL_X_MAX WALL_X_MAX],'Ydata',[WALL_Y_MIN WALL_Y_MAX],'Color','k','Linewidth',3); %right wall
line('Xdata',[80 80],'Ydata',[30 40],'Color','b','Linewidth',3);
line('Xdata',[70 70],'Ydata',[30 40],'Color','b','Linewidth',3);
line('Xdata',[70 80],'Ydata',[30 30],'Color','b','Linewidth',3);
line('Xdata',[70 80],'Ydata',[40 40],'Color','b','Linewidth',3);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function moveBall %third function, compute ball movement including collision detection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global ball_x ball_y ball_vx ball_vy  DT ball_anim BALL_INIT_VY BALL_INIT_VX
global WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX
global paddle_x_left paddle_x_right paddle_y
global game_over Score Score1
global ex ex2

ball_x = ball_x + ball_vx*DT;
ball_y = ball_y + ball_vy*DT;


if (ball_y < paddle_y) 
    game_over = 1;
elseif (ball_x <= paddle_x_right && ball_x >= paddle_x_left && ball_y <= (paddle_y + 1) && ball_y > paddle_y) %detect paddle
    ball_vy = -ball_vy*ex;
    ball_vx = ball_vx*ex2;
    Score1 = Score1 + 1;
    set(Score,'String',sprintf(' Score: %i',Score1))
elseif (ball_x < WALL_X_MIN)
    ball_vx = - ball_vx*ex2;
    ball_vy = ball_vy*ex;
elseif (ball_x > WALL_X_MAX)  %detect right wall
    ball_vx = - ball_vx*ex;
    ball_vy = ball_vy*ex2;
elseif (ball_y > WALL_Y_MAX) %detect top wall
    ball_vy = -ball_vy*ex;
    ball_vx = ball_vx*ex2;
elseif abs(ball_vx) >= 8
    ball_vx = ball_vx*.75; 
elseif abs(ball_vy) >= 8
    ball_vy = ball_vy*.75;    
elseif (ball_x <= 80 && ball_x >= 70 && ball_y <= 40 && ball_y >= 30)
    set (ball_anim,'Markerfacecolor',rand(1,3))
end
    
    



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function movePaddle %fourth function, compute paddle position based on user input. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global PADDLE_VX PADDLE_VY
global PADDLE_WIDTH DT
global paddle_x_left paddle_x_right paddle_y
global WALL_X_MIN WALL_X_MAX WALL_Y_MAX

paddle_x_left = paddle_x_left + PADDLE_VX*DT;
paddle_x_right = paddle_x_left + PADDLE_WIDTH;
paddle_y = paddle_y + PADDLE_VY*DT;

if (paddle_x_left < WALL_X_MIN)
    paddle_x_left = WALL_X_MIN;
elseif (paddle_x_right > WALL_X_MAX)
    paddle_x_left = WALL_X_MAX - PADDLE_WIDTH;
end

if (paddle_y < 10)
    paddle_y = 10;
elseif (paddle_y > WALL_Y_MAX)
    paddle_y = WALL_Y_MAX;
end

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
global PADDLE_VX PADDLE_SPEED_X PADDLE_SPEED_Y PADDLE_VY
switch event.Key
    case 'rightarrow'
      PADDLE_VX = PADDLE_SPEED_X;
      PADDLE_VY = 0;
    case 'leftarrow'
      PADDLE_VX = -PADDLE_SPEED_X;
      PADDLE_VY = 0;
    case 'uparrow'
      PADDLE_VX = 0;
      PADDLE_VY = PADDLE_SPEED_Y;
    case 'downarrow'
      PADDLE_VX = 0;
      PADDLE_VY = -PADDLE_SPEED_Y;
    otherwise
      PADDLE_VX = 0;
      PADDLE_VY = 0;
end

function keyUp(src,event) %called from initFigure to take key press to move the paddle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global PADDLE_VX PADDLE_SPEED_X PADDLE_SPEED_Y PADDLE_VY
switch event.Key
    case 'rightarrow'
      if PADDLE_VX == 0
          PADDLE_VX = 0;
      end
    case 'leftarrow'
      PADDLE_VX == 1
      PADDLE_VX = 0;
    case 'uparrow'
      PADDLE_VY == PADDLE_SPEED_Y  
      PADDLE_VY = 0;
    case 'downarrow'
      PADDLE_VY == -PADDLE_SPEED_Y
      PADDLE_VY = 0;
    otherwise
      PADDLE_VX = 0;
      PADDLE_VY = 0;
end
