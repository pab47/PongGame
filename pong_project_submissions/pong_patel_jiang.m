function pong_basic
%Modified the pong code by David Buckingham
%https://www.mathworks.com/matlabcentral/fileexchange/31177-dave-s-matlab-pong
clc
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
global PADDLE_WIDTH BALL_SIZE BALL2_SIZE
global BALL_INIT_VX BALL_INIT_VY DT DELAY
global BALL2_INIT_VX BALL2_INIT_VY
global PADDLE_VX PADDLE_SPEED 
global game_over level
global MESSAGE_X MESSAGE_Y 

MESSAGE_X = 7; %location of message displays. 38, 55 is pretty centered
MESSAGE_Y = 55;

level = 0;
game_over = 0;
WALL_X_MIN = 0;
WALL_X_MAX = 100;
WALL_Y_MIN = 0;
WALL_Y_MAX = 100;
PADDLE_WIDTH = 20;
BALL_SIZE = 10;
BALL_INIT_VX = -9;
BALL_INIT_VY = -9;
BALL2_SIZE = 10;
BALL2_INIT_VX= -9;
BALL2_INIT_VY = -9;
PADDLE_VX = 0;
PADDLE_SPEED = 15; %its was at 9 before 
DT = 0.1; 
DELAY = 0.01;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function initFigure %second function, initialize the figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global PADDLE_WIDTH BALL_SIZE BALL2_SIZE
global WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX
global BALL_INIT_VX BALL_INIT_VY
global BALL2_INIT_VX BALL2_INIT_VY
global ball_x ball_y ball_vx ball_vy ball2_x ball2_y ball2_vx ball2_vy 
global paddle_x_left paddle_x_right paddle_y
global ball_anim paddle_anim ball2_anim Score
global bonus_xl bonus_xr bonus_y1 bonus_y2  bonus_anim


fig = figure; %initialize the figure
set(fig, 'Resize', 'off'); %do not allow figure to resize
set(fig,'KeyPressFcn',@keyDown); %setkey presses for later
Score = [0]
%hold on
%h = text(80,95,['Score:', num2str(Score)],'Fontsize',14);

bonus_xl= 10
bonus_xr= 20
bonus_y1= 60
bonus_y2= 65

ball_x = 0.5*WALL_X_MAX; %0.5*(WALL_X_MIN+WALL_X_MAX); 
ball_y = WALL_Y_MAX;
ball_vx =BALL_INIT_VX; 
ball_vy = BALL_INIT_VY;
ball2_x = 0.6*WALL_X_MAX; %0.5*(WALL_X_MIN+WALL_X_MAX); 
ball2_y = 0.6*WALL_Y_MAX;
ball2_vx =BALL2_INIT_VX; 
ball2_vy = BALL2_INIT_VY;
paddle_x_left = 0;
paddle_x_right = PADDLE_WIDTH;
paddle_y = 10;
axis([WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX]); %set the size of the board.
axis manual;
hold on;
%title(['press keys <left/right> to move the paddle; level = ',num2str(level)],'Fontsize',14);
set(gca, 'color', '[0.7, 0.7, 0.7]', 'YTick', [], 'XTick', []); %remove x and y label

%%%%%%% set the ball and paddle %%%%%%
ball_anim = plot(ball_x,ball_y,'o','Markersize',BALL_SIZE,'Markerfacecolor','r','Markeredgecolor','r'); %create ball
ball2_anim = plot(ball2_x,ball2_y,'o','Markersize',BALL2_SIZE,'Markerfacecolor','c','Markeredgecolor','c');
paddle_anim = line('Xdata',[paddle_x_left paddle_x_right],'Ydata',[paddle_y paddle_y],'Color','b','Linewidth',5); %paddle
bonus_anim= line('Xdata',[bonus_xl bonus_xr], 'Ydata',[bonus_y1 bonus_y2], 'Color', 'b','Linewidth', 5); %bonus
% score_anim = plot(80,95,disp(Score),'Color','b')

%%%%%%%% set the walls %%%%%%%
line('Xdata',[WALL_X_MIN WALL_X_MIN],'Ydata',[WALL_Y_MIN WALL_Y_MAX],'Color','[0.8500, 0.3250, 0.0980]','Linewidth',6); %left wall
line('Xdata',[WALL_X_MIN WALL_X_MAX],'Ydata',[WALL_Y_MAX WALL_Y_MAX],'Color','[0.8500, 0.3250, 0.0980]','Linewidth',6); %top wall
line('Xdata',[WALL_X_MAX WALL_X_MAX],'Ydata',[WALL_Y_MIN WALL_Y_MAX],'Color','[0.8500, 0.3250, 0.0980]','Linewidth',6); %right wall


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function moveBall %third function, compute ball movement including collision detection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global ball_x ball_y ball_vx ball_vy  DT
global ball2_x ball2_y ball2_vx ball2_vy  
global WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX
global paddle_x_left paddle_x_right paddle_y
global game_over 
global MESSAGE_X MESSAGE_Y Score
global bonus_xl bonus_xr bonus_y1 bonus_y2

% Score = [0]
%text(80,95,[' Score: ',num2str(Score)],'Fontsize',14);

hold on
title(['WELCOME           Score: ',num2str(Score)],'Fontsize',20);


ball_x = ball_x + ball_vx*DT;
ball_y = ball_y + ball_vy*DT;
ball2_x = ball2_x + ball2_vx*DT;
ball2_y = ball2_y + ball2_vy*DT;
%%%%%%%% Basic pong edit #1: %%%%%%%%%%%%
% Write code to move the ball here. You code will include logic to get the ball to 
% detect the left, right, and top wall and the paddle and subsequently to change its
% movement based on which wall/paddle the ball hits.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



if ball_x <= WALL_X_MIN;
    ball_vx = -ball_vx;
    
elseif   ball2_x <= WALL_X_MIN;  
    ball2_vx= -ball2_vx;
    
elseif ball_x >= WALL_X_MAX ;
    ball_vx = -ball_vx;
    
elseif ball2_x >= WALL_X_MAX;
    ball2_vx = -ball2_vx;
    
elseif ball_y >= WALL_Y_MAX ;
    ball_vy = -ball_vy;

elseif  ball2_y >= WALL_Y_MAX ;
    ball2_vy = -ball2_vy;
    
elseif ball_y <= bonus_y1+1 ...
    && ball_x >= bonus_xl ...
    && ball_y >= bonus_y1-1 ...
    && ball_x <= bonus_xr;
     ball_vy = ball_vy;
     ball_vx = ball_vx ;
     Score = Score + 3 
     
     elseif ball2_y <= bonus_y1+1 ...
    && ball2_x >= bonus_xl ...
    && ball2_y >= bonus_y1-1 ...
    && ball2_x <= bonus_xr;
     ball2_vy = ball2_vy;
     ball2_vx = ball2_vx ;
     Score = Score + 3 
    
elseif ball_y <= paddle_y +1 ...
    && ball_x >= paddle_x_left ...
    && ball_x <= paddle_x_right;
     ball_vy = -1.10*ball_vy;
     ball_vx = 1.10*ball_vx ;
     Score = Score + 1 
    
     elseif ball2_y <= paddle_y +1 ...
    && ball2_x >= paddle_x_left ...
    && ball2_x <= paddle_x_right;
     ball2_vy = -1.10*ball2_vy;
     ball2_vx = 1.10*ball2_vx ;
     Score = Score +1
     

elseif ball_y < WALL_Y_MIN ...
    && Score < 7; 
    game_over = 1
    printText = ['GAME OVER LOSER! DO BETTER     Score:'];
      h = text(MESSAGE_X,MESSAGE_Y,[printText       , num2str(Score)], 'Fontsize',20);
    
elseif ball2_y < WALL_Y_MIN ...
       && Score < 7 ;    
      game_over =1 % change to (game over = 1);
     printText = ['GAME OVER LOSER! DO BETTER     Score:'];
      h = text(MESSAGE_X,MESSAGE_Y,[printText       , num2str(Score)], 'Fontsize',20); 
     
 
    elseif ball_y < WALL_Y_MIN ...
    &&  Score >7 & Score<11; 
    game_over = 1
    printText = ['GAME OVER.. Respectable        Score:'];
      h = text(MESSAGE_X,MESSAGE_Y,[printText       , num2str(Score)], 'Fontsize',20);
    
  
elseif ball2_y < WALL_Y_MIN ...
      &&  Score >7 & Score< 11;    
      game_over =1 % change to (game over = 1);
     printText = ['GAME OVER.. Respectable       Score:'];
      h = text(MESSAGE_X,MESSAGE_Y,[printText       , num2str(Score)], 'Fontsize',20);
      
          elseif ball_y < WALL_Y_MIN ...
    && Score > 11; 
    game_over = 1
    printText = ['GAME OVER.. CHAMPION        Score:'];
      h = text(MESSAGE_X,MESSAGE_Y,[printText       , num2str(Score)], 'Fontsize',20);
    
  
elseif ball2_y < WALL_Y_MIN ...
      &&  Score > 11;    
      game_over =1 % change to (game over = 1);
     printText = ['GAME OVER.. CHAMPION       Score:'];
      h = text(MESSAGE_X,MESSAGE_Y,[printText       , num2str(Score)], 'Fontsize',20);
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
if paddle_x_left <= WALL_X_MIN;
%PADDLE_VX= 0.25*paddle_x_right;
paddle_x_left=0;
end
if paddle_x_right >= WALL_X_MAX;
%    PADDLE_VX= -0.25*paddle_x_left;
paddle_x_left= 80  ;
end


%%%%%%%% Basic pong edit #2: %%%%%%%%%%%%
% Write code to move the paddle here. Your code will include logic to get
% the paddle to detect the left and right wall and to avoid it from
% penetrating either walls. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function refreshPlot %fifth function, refresh plot based on moveBall and movePaddle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global ball_x ball_y ball2_x ball2_y
global ball_anim paddle_anim ball2_anim
global paddle_x_left paddle_x_right paddle_y
global DELAY 
global bonus_xl bonus_xr bonus_y1  bonus_anim

set(ball_anim, 'XData', ball_x, 'YData', ball_y);
set(ball2_anim, 'XData', ball2_x, 'YData', ball2_y);
set(paddle_anim, 'Xdata',[paddle_x_left paddle_x_right], 'YData', [paddle_y paddle_y]);
set(bonus_anim, 'Xdata',[bonus_xl bonus_xr], 'YData', [bonus_y1 bonus_y1]);
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

