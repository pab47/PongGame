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
global PADDLE_VX PADDLE_SPEED PADDLE_VY PADDLE2_SPEED
global game_over level score i


level = 0;
game_over = 0;
WALL_X_MIN = 0;
WALL_X_MAX = 100;
WALL_Y_MIN = 0;
WALL_Y_MAX = 100;
PADDLE_WIDTH = 20;
BALL_SIZE = 10;
BALL_INIT_VX = -2;
BALL_INIT_VY = -2;
PADDLE_VX = 0;
PADDLE_SPEED = 5; 
PADDLE2_SPEED = 2;
DT = 0.1; 
DELAY = 0.001;
score = 7;
i = 50;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function initFigure %second function, initialize the figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global PADDLE_WIDTH BALL_SIZE 
global WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX
global BALL_INIT_VX BALL_INIT_VY
global ball_x ball_y ball_vx ball_vy 
global paddle_x_left paddle_x_right paddle_y paddle2_y paddle2_x_left paddle2_x_right
global ball_anim paddle_anim paddle2_anim
global level score h


fig = figure; %initialize the figure
set(fig, 'Resize', 'off'); %do not allow figure to resize
set(fig,'KeyPressFcn',@keyDown); %setkey presses for later
ball_x = WALL_X_MAX; %0.5*(WALL_X_MIN+WALL_X_MAX); 
ball_y = WALL_Y_MAX;
ball_vx = BALL_INIT_VX; 
ball_vy = BALL_INIT_VY;
paddle_x_left = 0;
paddle_x_right = PADDLE_WIDTH;
paddle2_x_left = 0;
paddle2_x_right = PADDLE_WIDTH;
paddle_y = 10;
paddle2_y = 50;
axis([WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX]); %set the size of the board.
axis manual;
xlabel('Ishan Rajwade & Sadam Abdelmutaal')
hold on;
title(['Press keys \rightarrow \leftarrow \uparrow \downarrow  to move the paddle; level = ',num2str(level)],'Fontsize',14);
set(gca, 'color', 'w', 'YTick', [], 'XTick', []); %remove x and y label

%%%%%%% set the ball and paddle %%%%%%
ball_anim = plot(ball_x,ball_y,'o','Markersize',BALL_SIZE,'Markerfacecolor','r','Markeredgecolor','r'); %create ball
paddle_anim = line('Xdata',[paddle_x_left paddle_x_right],'Ydata',[paddle_y paddle_y],'Color','g','Linewidth',5); %paddle
paddle2_anim = line('Xdata',[paddle2_x_left paddle2_x_right],'Ydata',[paddle2_y paddle2_y],'Color','g','Linewidth',5); %paddle2
txt = {'Lives','left', num2str(score)};
h = text(101,50,txt);
%%%%%%%% set the walls %%%%%%%
line('Xdata',[WALL_X_MIN WALL_X_MIN],'Ydata',[WALL_Y_MIN WALL_Y_MAX],'Color','k','Linewidth',3); %left wall
line('Xdata',[WALL_X_MIN WALL_X_MAX],'Ydata',[WALL_Y_MAX WALL_Y_MAX],'Color','k','Linewidth',3); %top wall
line('Xdata',[WALL_X_MAX WALL_X_MAX],'Ydata',[WALL_Y_MIN WALL_Y_MAX],'Color','k','Linewidth',3); %right wall


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function moveBall %third function, compute ball movement including collision detection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global ball_x ball_y ball_vx ball_vy  DT BALL_INIT_VX BALL_INIT_VY
global WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX
global paddle_x_left paddle_x_right paddle_y paddle2_x_left paddle2_x_right paddle2_y
global game_over level score i h
ex = 1+.1*rand;
ey = 1+.1*rand;




if( (ball_x >= WALL_X_MIN) && (ball_x<= WALL_X_MAX) && (ball_y <= paddle_y+.2) && (ball_y>=paddle_y-.2 ))
    if( (ball_x >= paddle_x_left) && (ball_x <= paddle_x_right))
        ball_vy=-1.*ball_vy;
        ball_x = ball_x + ball_vx*DT;
        ball_y = ball_y + ball_vy*DT*ey;
        
%         display(ball_y)
%         signx = signx.*-1;
%         signy = signy.*-1;
%         display(signx)
%         display(signy)
       
    else
        ball_x = ball_x + ball_vx*DT;
        ball_y = ball_y + ball_vy*DT;
    end
elseif(ball_x >= WALL_X_MIN && ball_x<= WALL_X_MAX && ball_y <= paddle2_y + .2 && ball_y>=paddle2_y-.2)
    if(ball_x >= paddle2_x_left && ball_x <= paddle2_x_right)
        ball_vy=-1.*ball_vy;
        ball_x = ball_x + ball_vx*DT;
        ball_y = ball_y + ball_vy*DT*ey;
        
%         display(ball_y)
%         signx = signx.*-1;
%         signy = signy.*-1;
%         display(signx)
%         display(signy)
       
    else
        ball_x = ball_x + ball_vx*DT;
        ball_y = ball_y + ball_vy*DT;
    end
elseif (ball_x>WALL_X_MIN && ball_x<WALL_X_MAX && ball_y>WALL_Y_MIN && ball_y<WALL_Y_MAX)
    ball_x = ball_x + ball_vx*DT;
    ball_y = ball_y + ball_vy*DT;
    %display(ball_y)

elseif(ball_x >= WALL_X_MIN-.2 && ball_x<= WALL_X_MIN+.2 && ball_y > WALL_Y_MIN && ball_y < WALL_Y_MAX)
    ball_vx = -1.*ball_vx;
    ball_x = ball_x + ball_vx*DT*ex;
    ball_y = ball_y + ball_vy*DT;
elseif(ball_x >= WALL_X_MAX-.2 && ball_x<= WALL_X_MAX+.2 && ball_y > WALL_Y_MIN && ball_y < WALL_Y_MAX)
    ball_vx = -1.*ball_vx*ex;
    ball_x = ball_x + ball_vx*DT;
    ball_y = ball_y + ball_vy*DT;

elseif(ball_x > WALL_X_MIN && ball_x< WALL_X_MAX && ball_y >= WALL_Y_MAX-.2 && ball_y <= WALL_Y_MAX+.2)
    ball_vy = -1.*ball_vy;
    ball_x = ball_x + ball_vx*DT;
    ball_y = ball_y + ball_vy*DT*ey;

else
    ball_x = ball_x + ball_vx*DT;
    ball_y = ball_y + ball_vy*DT;
end
%%%%%%%% Basic pong edit #1: %%%%%%%%%%%%
% Write code to move the ball here. You code will include logic to get the ball to 
% detect the left, right, and top wall and the paddle and subsequently to change its
% movement based on which wall/paddle the ball hits.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (ball_y < WALL_Y_MIN)
    score = score - 1;
    ball_x = WALL_X_MAX;
    ball_y = WALL_Y_MAX;
    ball_vx = BALL_INIT_VX;
    ball_vy = BALL_INIT_VY;
    i = i-6;
    delete(h);
    txt = {'Lives','left',num2str(score)};
    h = text(101,50,txt);
    
end
if (score == 0)
    game_over = 1;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function movePaddle %fourth function, compute paddle position based on user input. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global PADDLE_VX PADDLE_VY PADDLE2_SPEED
global PADDLE_WIDTH DT
global paddle_x_left paddle_x_right paddle_y paddle2_x_left paddle2_x_right
global WALL_X_MIN WALL_X_MAX WALL_Y_MAX

if(paddle2_x_left >= WALL_X_MIN && paddle2_x_right <= WALL_X_MAX)
    paddle2_x_left = paddle2_x_left + PADDLE2_SPEED*DT;
    paddle2_x_right = paddle2_x_left + PADDLE_WIDTH;
elseif(paddle2_x_left <= WALL_X_MIN && PADDLE2_SPEED < 0)
    PADDLE2_SPEED = -1.*PADDLE2_SPEED;
    paddle2_x_left = paddle2_x_left + PADDLE2_SPEED*DT;
    paddle2_x_right = paddle2_x_left + PADDLE_WIDTH;
elseif(paddle2_x_right >= WALL_X_MAX && PADDLE2_SPEED > 0)
    PADDLE2_SPEED = -1.*PADDLE2_SPEED;
    paddle2_x_left = paddle2_x_left + PADDLE2_SPEED*DT;
    paddle2_x_right = paddle2_x_left + PADDLE_WIDTH;
     

    
    
end

if(PADDLE_VX == 0)
    paddle_x_left = paddle_x_left + PADDLE_VX*DT;
    paddle_x_right = paddle_x_left + PADDLE_WIDTH;
    paddle_y = paddle_y + PADDLE_VY*DT;
    PADDLE_VX = .7.*PADDLE_VX;
    PADDLE_VY = .7.*PADDLE_VY;
elseif(paddle_x_left >= WALL_X_MIN && paddle_x_right <= WALL_X_MAX && paddle_y < WALL_Y_MAX)
    paddle_x_left = paddle_x_left + PADDLE_VX*DT;
    paddle_x_right = paddle_x_left + PADDLE_WIDTH;
    paddle_y = paddle_y + PADDLE_VY*DT;
    PADDLE_VX = .7.*PADDLE_VX;
    PADDLE_VY = .7.*PADDLE_VY;
elseif(paddle_x_left <= WALL_X_MIN && PADDLE_VX > 0 && paddle_y < WALL_Y_MAX)
     paddle_x_left = paddle_x_left + PADDLE_VX*DT;
     paddle_x_right = paddle_x_left + PADDLE_WIDTH;
     paddle_y = paddle_y + PADDLE_VY*DT;
     PADDLE_VX = .7.*PADDLE_VX;
     PADDLE_VY = .7.*PADDLE_VY;
elseif(paddle_x_right >WALL_X_MAX && PADDLE_VX < 0 && paddle_y < WALL_Y_MAX)
    paddle_x_left = paddle_x_left + PADDLE_VX*DT;
    paddle_x_right = paddle_x_left + PADDLE_WIDTH;
    paddle_y = paddle_y + PADDLE_VY*DT;
    PADDLE_VX = .7.*PADDLE_VX;
    PADDLE_VY = .7.*PADDLE_VY;
% elseif(paddle_y<WALL_Y_MAX && paddle_y < WALL_Y_MAX)
%     paddle_y = paddle_y + PADDLE_VY*DT;
%     paddle_y = 

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
global ball_anim paddle_anim score_anim paddle2_anim
global paddle_x_left paddle_x_right paddle_y paddle2_x_left paddle2_x_right paddle2_y
global DELAY score

set(ball_anim, 'XData', ball_x, 'YData', ball_y);
set(paddle_anim, 'Xdata',[paddle_x_left paddle_x_right], 'YData', [paddle_y paddle_y]);
set(paddle2_anim, 'Xdata',[paddle2_x_left paddle2_x_right], 'YData', [paddle2_y paddle2_y]);
% set(score_anim,'data',score);
% txt = {'score  ', num2str(score)};
% text(102,10,txt)
drawnow;
pause(DELAY);   


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function keyDown(src,event) %called from initFigure to take key press to move the paddle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global PADDLE_VX PADDLE_SPEED PADDLE_VY


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
    PADDLE_VY = 0;
end

