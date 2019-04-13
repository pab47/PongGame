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
    movePaddle2;
    refreshPlot; %fifth function, refresh plot based on moveBall and movePaddle
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function initData %first function, initialize the data variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX
global PADDLE_WIDTH BALL_SIZE 
global BALL_INIT_VX BALL_INIT_VY DT DELAY
global PADDLE_VX PADDLE_SPEED PADDLE_VY
global game_over score
global block1_x_left block1_x_right block1_y_up block1_y_down
global block2_x_left block2_x_right block2_y_up block2_y_down

score = 0;
game_over = 0;
WALL_X_MIN = 0;
WALL_X_MAX = 100;
WALL_Y_MIN = 0;
WALL_Y_MAX = 100;
PADDLE_WIDTH = 20;
BALL_SIZE = 10;
BALL_INIT_VX = -12;
BALL_INIT_VY = -12;
PADDLE_VX = 0;
PADDLE_VY = 0;
PADDLE_SPEED = 20; 
DT = 0.1; 
DELAY = 0.01;
block1_x_left = 15.0;
block1_x_right = 35.0;
block1_y_up = 75.0;
block1_y_down = 65.0;
block2_x_left = 65.0;
block2_x_right = 85.0;
block2_y_up = 55.0;
block2_y_down = 45.0;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function initFigure %second function, initialize the figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global PADDLE_WIDTH BALL_SIZE 
global WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX
global BALL_INIT_VX BALL_INIT_VY
global ball_x ball_y ball_vx ball_vy 
global paddle_x_left paddle_x_right paddle_y
global ball_anim paddle_anim
global score
global block1_x_left block1_x_right block1_y_up block1_y_down
global block2_x_left block2_x_right block2_y_up block2_y_down

x1 = [block1_x_left block1_x_right block1_x_right block1_x_left];
y1 = [block1_y_up block1_y_up block1_y_down block1_y_down];
x2 = [block2_x_left block2_x_right block2_x_right block2_x_left];
y2 = [block2_y_up block2_y_up block2_y_down block2_y_down];

fig = figure; %initialize the figure
set(fig, 'Resize', 'off'); %do not allow figure to resize
set(fig,'KeyPressFcn',@keyDown); %setkey presses for later
ball_x = WALL_X_MAX; %0.5*(WALL_X_MIN+WALL_X_MAX); 
ball_y = WALL_Y_MAX;
ball_vx = BALL_INIT_VX; 
ball_vy = BALL_INIT_VY;
paddle_x_left = 0;
paddle_x_right = paddle_x_left + PADDLE_WIDTH;
paddle_y = 10;
axis([WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX]); %set the size of the board.
axis manual;
hold on;
title(['Press arrow keys <left/right/up/down> to move paddle || Score = ',num2str(score)],'Fontsize',9);
xlabel('Hector Trejo and Allison Toms');
set(gca, 'color', 'w', 'YTick', [], 'XTick', []); %remove x and y label

%%%%%%% set the ball and paddle %%%%%%
ball_anim = plot(ball_x,ball_y,'o','Markersize',BALL_SIZE,'Markerfacecolor','r','Markeredgecolor','r'); %create ball
paddle_anim = line('Xdata',[paddle_x_left paddle_x_right],'Ydata',[paddle_y paddle_y],'Color','g','Linewidth',5); %paddle


%%%%% additional obstacles %%%%%
patch(x1,y1,'yellow'); %left yellow block
patch(x2,y2,'yellow'); %right yellow block

%%%%%%%% set the walls %%%%%%%
line('Xdata',[WALL_X_MIN WALL_X_MIN],'Ydata',[WALL_Y_MIN WALL_Y_MAX],'Color','k','Linewidth',3); %left wall
line('Xdata',[WALL_X_MIN WALL_X_MAX],'Ydata',[WALL_Y_MAX WALL_Y_MAX],'Color','k','Linewidth',3); %top wall
line('Xdata',[WALL_X_MAX WALL_X_MAX],'Ydata',[WALL_Y_MIN WALL_Y_MAX],'Color','k','Linewidth',3); %right wall


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function moveBall %third function, compute ball movement including collision detection

global ball_x ball_y ball_vx ball_vy  DT
global WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX
global paddle_x_left paddle_x_right paddle_y
global game_over score
global block1_x_left block1_x_right block1_y_up block1_y_down
global block2_x_left block2_x_right block2_y_up block2_y_down

ball_x = ball_x + ball_vx*DT;
ball_y = ball_y + ball_vy*DT;

% Basic pong edit #1: %%%%%%%%%%%%
% Write code to move the ball here. You code will include logic to get the ball to 
% detect the left, right, and top wall and the paddle and subsequently to change its
% movement based on which wall/paddle the ball hits.


e_x = 1;
e_y = 1;

if (ball_y <= paddle_y ) && (ball_x >= paddle_x_left) && (ball_x <= paddle_x_right) && (ball_vy < 0) %detects paddle

   ball_vy = -e_y * ball_vy*(1.07) + (-0.1+0.2*rand());
    ball_vx = ball_vx;
    
    score = score+1; %ITERATIVE VALUE THAT ADDS 1 EVERY TIME BALL TOUCHES bottom PADDLE 
   title(['Press arrow keys <left/right/up/down> to move paddle || Score = ',num2str(score)],'Fontsize',9);
    %TITLE UPDATES EVERY TIME BALL TOUCHES PADDLE. SCORE = LEVEL + 1 

elseif    (ball_y >= WALL_Y_MAX) && (ball_vy > 0)% detects top wall
    
    ball_vy = -e_y * ball_vy + (-0.1+0.2*rand());
    ball_vx = ball_vx;


elseif (ball_x  <= WALL_X_MIN)  && (ball_vx < 0)... % detects left wall
       || (ball_x >= WALL_X_MAX)  && (ball_vx > 0)% detects right wall
   
    ball_vx = -e_x * ball_vx;
    ball_vy = ball_vy;

    
elseif ((ball_x >= block1_x_left) && (ball_x <= block1_x_right) && (ball_y <= block1_y_up +0.1 ) && (ball_y >= block1_y_down + 5) && (ball_vy < 0)) ... %top of b1
        || ((ball_x >= block1_x_left) && (ball_x <= block1_x_right) && (ball_y <= block1_y_up -5 ) && (ball_y >= block1_y_down +0.1) && (ball_vy > 0))...%bottom of b1
   || ((ball_x >= block2_x_left) && (ball_x <= block2_x_right) && (ball_y <= block2_y_up +0.1 ) && (ball_y >= block2_y_down +5) && (ball_vy < 0)) ... %top of b2
        || ((ball_x >= block2_x_left) && (ball_x <= block2_x_right) && (ball_y <= block2_y_up -5 ) && (ball_y >= block2_y_down +0.1) && (ball_vy > 0))%bottom of b2
   
    
    ball_vy = -e_y * ball_vy;
    ball_vx = ball_vx;
    
elseif (ball_y < paddle_y - 5)
    game_over = 1;

   title(['YOU A LOSER, JUST LIKE YOUR MOTHER || Score = ',num2str(score)],'Fontsize',11);
    %IF GAME OVER = 1, THE GAME ROASTS YOU AND YOUR MOTHER AT THE SAME TIME 
  
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function movePaddle % compute paddle x position based on user input. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global PADDLE_VX
global PADDLE_WIDTH DT
global paddle_x_left paddle_x_right
global WALL_X_MIN WALL_X_MAX

paddle_x_left = paddle_x_left + PADDLE_VX*DT;
paddle_x_right = paddle_x_left + PADDLE_WIDTH; 

if (paddle_x_left < WALL_X_MIN)
    paddle_x_left = WALL_X_MIN;
    
else if (paddle_x_right > WALL_X_MAX)
        paddle_x_left = WALL_X_MAX - PADDLE_WIDTH; 

    end 

end

function movePaddle2 %compute paddle y position based on user input. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global PADDLE_VY DT
global paddle_y


paddle_y = paddle_y + PADDLE_VY*DT;

if (paddle_y < 10)
    paddle_y = 10;
    
else if (paddle_y > 30)
        paddle_y = 30; 

    end 

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function refreshPlot %refresh plot based on moveBall and movePaddle
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
global PADDLE_VX PADDLE_VY PADDLE_SPEED

switch event.Key
  case 'rightarrow'
    PADDLE_VX = PADDLE_SPEED;
  case 'leftarrow'
    PADDLE_VX = -PADDLE_SPEED;
    case 'uparrow'
        PADDLE_VY = PADDLE_SPEED;
    case 'downarrow'
        PADDLE_VY = -PADDLE_SPEED;
    otherwise
    PADDLE_VX = 0;
end

