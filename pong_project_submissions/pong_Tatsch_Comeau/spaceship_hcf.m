function spaceship_hcf
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
global game_over level player_score cpu_score score_required

level = 0;
player_score = 0;
cpu_score = 0;
score_required = int16(5) + ((rand * 100)/20);
game_over = 0;
WALL_X_MIN = 0;
WALL_X_MAX = 100;
WALL_Y_MIN = 0;
WALL_Y_MAX = 100;
PADDLE_WIDTH = 20;
BALL_SIZE = 10;
BALL_INIT_VX = -3;
BALL_INIT_VY = -3;
PADDLE_VX = 0;
PADDLE_SPEED = 5; 
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
global asteroid_x asteroid_y asteroid_vx asteroid_vy
global ball_anim paddle_anim score_display asteroid_anim


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
asteroid_x = WALL_X_MIN;
asteroid_y = WALL_Y_MAX - (rand * 100);
asteroid_vx = -BALL_INIT_VX;
asteroid_vy = -BALL_INIT_VY;
axis([WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX]); %set the size of the board.
axis manual;
hold on;
title('press keys <left/right> to move the paddle','Fontsize',14);
xlabel('Travis Tatsch and Nicholas Comeau');
set(gca, 'color', 'w', 'YTick', [], 'XTick', []); %remove x and y label

%%%%%%% set the ball, paddle, and score %%%%%%
ball_anim = plot(ball_x,ball_y,'o','Markersize',BALL_SIZE,'Markerfacecolor','r','Markeredgecolor','r'); %create ball
asteroid_anim = plot(asteroid_x, asteroid_y, 'o', 'Markersize', BALL_SIZE, 'Markerfacecolor', 'b', 'Markeredgecolor', 'b'); %create asteroid on a random y axis
paddle_anim = line('Xdata',[paddle_x_left paddle_x_right],'Ydata',[paddle_y paddle_y],'Color','g','Linewidth',5); %paddle
score_txt = {'Player score: 0'};
score_display = text(-15, -6, score_txt);

%%%%%%%% set the walls %%%%%%%
line('Xdata',[WALL_X_MIN WALL_X_MIN],'Ydata',[WALL_Y_MIN WALL_Y_MAX],'Color',[0.4940 0.1840 0.5560],'Linewidth',3); %left wall
line('Xdata',[WALL_X_MIN WALL_X_MAX],'Ydata',[WALL_Y_MAX WALL_Y_MAX],'Color','k','Linewidth',3); %top wall
line('Xdata',[WALL_X_MAX WALL_X_MAX],'Ydata',[WALL_Y_MIN WALL_Y_MAX],'Color','k','Linewidth',3); %right wall


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function moveBall %third function, compute ball movement including collision detection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global ball_x ball_y ball_vx ball_vy  DT
global WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX
global paddle_x_left paddle_x_right paddle_y
global asteroid_x asteroid_y asteroid_vx asteroid_vy
global game_over player_score cpu_score score_required

ball_x = ball_x + ball_vx*DT;
ball_y = ball_y + ball_vy*DT;
asteroid_x = asteroid_x + asteroid_vx*DT;
asteroid_y = asteroid_y + asteroid_vy*DT;

%%%%%%%% Basic pong edit #1: %%%%%%%%%%%%
% Write code to move the ball here. You code will include logic to get the ball to 
% detect the left, right, and top wall and the paddle and subsequently to change its
% movement based on which wall/paddle the ball hits.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% These represent the ball collisions
if (ball_y < WALL_Y_MIN)
     cpu_score = cpu_score + 1;
elseif(ball_y <= paddle_y && ball_x > paddle_x_left && ball_x < paddle_x_right)
    %bounce back
    ball_vy = -1 * ball_vy;
    ball_y = ball_y + ball_vy*DT;
elseif(ball_y > WALL_Y_MAX)
    ball_vy = -1 * ball_vy;
    ball_y = ball_y + ball_vy*DT;
    player_score = player_score + 1;
elseif(ball_x > WALL_X_MAX)
    ball_vx = -1*ball_vx;
    ball_x = ball_x + ball_vx*DT;
elseif(ball_x < WALL_X_MIN)
    %enter wormhole, teleport ball
    ball_x = WALL_X_MAX - (rand*100);
    ball_y = WALL_Y_MAX - (rand*100);
    ball_vx = -1 * ball_vx;
    ball_vy = -1 * ball_vy;
elseif(ball_x == asteroid_x && ball_y == asteroid_y)
    %asteroid collision
    ball_vx = -1*ball_vx;
    ball_x = ball_x + ball_vx*DT;
    ball_vy = -1*ball_vy;
    ball_y = ball_y + ball_vy*DT;
    asteroid_vx = -1*asteroid_vx;
    asteroid_x = asteroid_x + asteroid_vx*DT;
    asteroid_vy = -1*asteroid_vy;
    asteroid_y = asteroid_y + asteroid_vy*DT;
end

%%% These represent the asteroid collision, minus collision with the ball
if (asteroid_y < WALL_Y_MIN || asteroid_y > WALL_Y_MAX)
    asteroid_vy = -1*asteroid_vy;
    asteroid_y = asteroid_y + asteroid_vy*DT;
elseif(asteroid_x > WALL_X_MAX)
    asteroid_vx = -1*asteroid_vx;
    asteroid_x = asteroid_x + asteroid_vx*DT;
elseif(asteroid_x < WALL_X_MIN)
    %enter wormhole, teleport asteroid
    asteroid_x = WALL_X_MAX - (rand * 100);
    asteroid_y = WALL_Y_MAX - (rand * 100);
    asteroid_vy = -1*asteroid_vy;
    asteroid_vx = -1*asteroid_vx;
end

if(player_score >= score_required || cpu_score >= 5)
    game_over = 1;
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

%%%%%%%% Basic pong edit #2: %%%%%%%%%%%%
% Write code to move the paddle here. Your code will include logic to get
% the paddle to detect the left and right wall and to avoid it from
% penetrating either walls. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(paddle_x_left < WALL_X_MIN)
    paddle_x_left = WALL_X_MIN;
elseif(paddle_x_right > WALL_X_MAX)
    paddle_x_right = WALL_X_MAX;
    paddle_x_left = paddle_x_right - PADDLE_WIDTH;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function refreshPlot %fifth function, refresh plot based on moveBall and movePaddle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global ball_x ball_y
global ball_anim paddle_anim score_display asteroid_anim
global paddle_x_left paddle_x_right paddle_y
global asteroid_x asteroid_y
global player_score cpu_score score_txt
global DELAY

set(ball_anim, 'XData', ball_x, 'YData', ball_y);
set(paddle_anim, 'Xdata',[paddle_x_left paddle_x_right], 'YData', [paddle_y paddle_y]);
score_txt = {'Hits to ship: ' player_score};
set(score_display, 'String', score_txt);
set(asteroid_anim, 'XData', asteroid_x, 'YData', asteroid_y);
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

