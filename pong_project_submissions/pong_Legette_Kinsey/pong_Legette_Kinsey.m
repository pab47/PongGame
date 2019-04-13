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
    if game_over == 1
        return
    end
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
global game_over level score count
global bonus_x bonus_y 
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
BALL_INIT_VX = -3.5*cosd(Angle);
BALL_INIT_VY = -3.5*sind(Angle);
PADDLE_VX = 0;
PADDLE_SPEED = 5; 
DT = 0.2; 
DELAY = 0.001;
bonus_x = randi([10 30]);
bonus_y = randi([60 90]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function initFigure %second function, initialize the figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global PADDLE_WIDTH BALL_SIZE 
global WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX
global BALL_INIT_VX BALL_INIT_VY
global ball_x ball_y ball_vx ball_vy 
global paddle_x_left paddle_x_right paddle_y
global ball_anim paddle_anim
global level score strscore
global bonus_x bonus_y bonus_box

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
hold on;
title('Press the spacebar to move the paddle','Fontsize',14);
set(gca, 'color', 'w', 'YTick', [], 'XTick', []); %remove x and y label
%BONUS  
bonus_box = patch('XData',[bonus_x bonus_x bonus_x+2 bonus_x+2],...
                  'YData',[bonus_y bonus_y+2 bonus_y+2 bonus_y]);
set(bonus_box,'FaceColor','g');              

%%%%%%% set the ball and paddle %%%%%%
ball_anim = plot(ball_x,ball_y,'o','Markersize',BALL_SIZE,...
                'Markerfacecolor','r','Markeredgecolor','r'); %create ball
paddle_anim = line('Xdata',[paddle_x_left paddle_x_right],...
                   'Ydata',[paddle_y paddle_y],'Color','g','Linewidth',5); %paddle
strscore = {'Score: ',num2str(level-1)};
dim = [0 .8 .11 .11];
score = annotation('textbox',dim,'String',strscore,'FontSize',14,'EdgeColor','none');

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
global game_over level strscore
global bonus_x bonus_y PADDLE_WIDTH bonus_box

ball_x = ball_x + ball_vx*DT;
ball_y = ball_y + ball_vy*DT;

%%%%%%%% Basic pong edit #1: %%%%%%%%%%%%
% Does the ball hit a wall?
if ball_x < WALL_X_MIN || ball_x > WALL_X_MAX
    ball_vx = -ball_vx;
end
% Does the ball hit the ceiling
if ball_y > WALL_Y_MAX
    ball_vy = -(ball_vy+(rand/2));
end

% Does the ball hit the paddle
if ball_y <= paddle_y +1 && ball_y>=paddle_y
    if ball_x < paddle_x_right && ball_x > paddle_x_left
    %ball_vx = -ball_vx;
    ball_vy = abs(ball_vy);
    level = level+1;
    strscore = {'Score: ',num2str(level-1)};
    end
end
%BONUS
if ball_y <= bonus_y +5 && ball_y >= bonus_y
    if ball_x <= bonus_x +5 && ball_x >= bonus_x
        PADDLE_WIDTH = 30;
        set(bonus_box,'XData',[0 0 0 0],'YData',[0 0 0 0]);
        drawnow;
    end  
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (ball_y < WALL_Y_MIN)
     game_over = 1;
     disp('GAME OVER')
     score = level-1;
     fprintf('Your Score: %2.0f \n',score)
     load('High_Score.mat','High_Score');
     if score > High_Score
         High_Score = score;
         save('High_Score.mat','High_Score');
     end
     fprintf('High Score: %2.0f \n',High_Score)
     
     close all
     return
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
if paddle_x_left < WALL_X_MIN 
    paddle_x_left = WALL_X_MIN;
    paddle_x_right = WALL_X_MIN + PADDLE_WIDTH;
elseif paddle_x_right > WALL_X_MAX 
    PADDLE_VX = -PADDLE_VX;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function refreshPlot %fifth function, refresh plot based on moveBall and movePaddle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global ball_x ball_y
global ball_anim paddle_anim
global paddle_x_left paddle_x_right paddle_y
global DELAY score strscore
set(ball_anim, 'XData', ball_x, 'YData', ball_y);
set(paddle_anim, 'Xdata',[paddle_x_left paddle_x_right], 'YData', [paddle_y paddle_y]);
set(score, 'String',strscore);
drawnow;
pause(DELAY);   


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function keyDown(src,event) %called from initFigure to take key press to move the paddle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global PADDLE_VX PADDLE_SPEED level count
switch event.Key
  case 'space'
     if count < level;
    PADDLE_VX = PADDLE_SPEED;
    count = level;
     end
end


