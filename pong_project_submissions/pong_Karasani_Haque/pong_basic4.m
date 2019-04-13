function pong_basic
%Modified the pong code by David Buckingham
%https://www.mathworks.com/matlabcentral/fileexchange/31177-dave-s-matlab-pong
%%%%%% main part of the code %%%

inital_param

global game_over 
global Counter 
game_over = 0;

    
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
global game_over level score
global s1 s2 s3 s4 s5 % breaker line status 
global e1


s1 = 0; s2 = 0; s3 = 0; s4 = 0; s5 = 0; 
load('scores.mat')
score = 5; 
level = level;
e1 = e1;

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
PADDLE_SPEED = 20; 
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
global level score
global l1 l2 l3 l4 l5 % breaker line variables 


% p = rand(1,10);
% q = ones(10);
% save('pqfile.mat','p','q')

fig = figure; %initialize the figure
set(fig, 'Resize', 'off'); %do not allow figure to resize
set(fig,'WindowKeyPressFcn',@keyDown); %setkey presses for later
ball_x = WALL_X_MAX -1; %0.5*(WALL_X_MIN+WALL_X_MAX); 
ball_y = WALL_Y_MAX -1;
ball_vx = BALL_INIT_VX; 
ball_vy = BALL_INIT_VY;
paddle_x_left = 0;
paddle_x_right = PADDLE_WIDTH;
paddle_y = 10;
axis([WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX]); %set the size of the board.
axis manual;
hold on;
title(['level = ',num2str(level),],'Fontsize',14);
xlabel('Panchajanya karasani, Tressha haque ')
set(gca, 'color', 'w', 'YTick', [], 'XTick', []); %remove x and y label

%%%%%%% set the ball and paddle %%%%%%
ball_anim = plot(ball_x,ball_y,'o','Markersize',BALL_SIZE,'Markerfacecolor','r','Markeredgecolor','r'); %create ball
paddle_anim = line('Xdata',[paddle_x_left paddle_x_right],'Ydata',[paddle_y paddle_y],'Color','g','Linewidth',5); %paddle

%%%%%%%% set the walls %%%%%%%
line('Xdata',[WALL_X_MIN WALL_X_MIN],'Ydata',[WALL_Y_MIN WALL_Y_MAX],'Color','k','Linewidth',3); %left wall
line('Xdata',[WALL_X_MIN WALL_X_MAX],'Ydata',[WALL_Y_MAX WALL_Y_MAX],'Color','k','Linewidth',3); %top wall
line('Xdata',[WALL_X_MAX WALL_X_MAX],'Ydata',[WALL_Y_MIN WALL_Y_MAX],'Color','k','Linewidth',3); %right wall

% breaker lines 
l1 = line('Xdata',[80 90],'Ydata',[95 95],'Color','r','Linewidth',3); 
l2 = line('Xdata',[60 70],'Ydata',[95 95],'Color','r','Linewidth',3); 
l3 = line('Xdata',[40 50],'Ydata',[95 95],'Color','r','Linewidth',3); 
l4 = line('Xdata',[20 30],'Ydata',[95 95],'Color','r','Linewidth',3); 
l5 = line('Xdata',[0 10],'Ydata',[95 95],'Color','r','Linewidth',3); 



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function moveBall %third function, compute ball movement including collision detection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global ball_x ball_y ball_vx ball_vy  DT
global WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX
global paddle_x_left paddle_x_right paddle_y
global game_over level score 
global l1 l2 l3 l4 l5
global s1 s2 s3 s4 s5 
global e1

ball_x = ball_x + ball_vx*DT;
ball_y = ball_y + ball_vy*DT;

%%%%%%%% Basic pong edit #1: %%%%%%%%%%%%
% Write code to move the ball here. You code will include logic to get the ball to 
% detect the left, right, and top wall and the paddle and subsequently to change its
% movement based on which wall/paddle the ball hits.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (ball_y < WALL_Y_MIN)
     game_over = 1;
end

if ( WALL_X_MIN >= ball_x) % left wall go through
    
    ball_vx = ball_vx;
    ball_x = ball_x + 98 + ball_vx*DT;
end

if ( WALL_X_MAX-1 <= ball_x) % right wall go through
    ball_vx = ball_vx;
    ball_x = ball_x + 100 + ball_vx*DT;
end

% if ( WALL_X_MIN >= ball_x) % left wall bounce 
%     ball_vx = -ball_vx;
% end
% 
% if ( WALL_X_MAX <= ball_x) % right wall bounce 
%     ball_vx = -ball_vx;
% end


if ( WALL_Y_MAX <= ball_y) % top wall bounce 
    ball_vy = -ball_vy;
end

if (paddle_y >= ball_y) % paddle bounce
    if(ball_x >= paddle_x_left && ball_x <= paddle_x_right)
        if(ball_vy <= 0) % for ball not to get stuck at the paddle 
        ball_vy = e1 * -ball_vy;
        end
    end
    
end

if (ball_y >= 94 && ball_y <= 94.5 )  % for deleting lines 
    if (ball_x >= 80 && ball_x <= 90)
        if(s1 == 0 )
        delete(l1);
        score = score -1; 
        title(['level = ',num2str(level),'  score  ' num2str(score) ],'Fontsize',14);  
        s1 =1 ;
        end 
    end
    if (ball_x >= 60 && ball_x <= 70)
         if(s2 == 0 )
        delete(l2);
        score = score -1; 
        title(['level = ',num2str(level),'  score  ' num2str(score) ],'Fontsize',14);  
        s2 =1 ;
        end 
    end
    if (ball_x >= 40 && ball_x <= 50)
        if(s3 == 0 )
        delete(l3);
        score = score -1; 
        title(['level = ',num2str(level),'  score  ' num2str(score) ],'Fontsize',14);  
        s3 =1 ;
        end 
    end
    if (ball_x >= 20 && ball_x <= 30)
        if(s4 == 0 )
        delete(l4);
        score = score -1; 
        title(['level = ',num2str(level),'  score  ' num2str(score) ],'Fontsize',14);  
        s4 =1 ;
        end  
      
    end
    if (ball_x >= 0 && ball_x <= 10)
        if(s5 == 0 )
        delete(l5);
        score = score -1; 
        title(['level = ',num2str(level),'  score  ' num2str(score) ],'Fontsize',14);  
        s5 =1 ;
        end 
    end
  
end

if ( score <= 0)
    game_over = 1   
    title(['level = ',num2str(level),],'Fontsize',14);
    level = level +1 ;
    e1 = 0.1+ e1 
save('scores.mat','level','e1')
    pong_basic4;
    
end

        


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function movePaddle %fourth function, compute paddle position based on user input. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global PADDLE_VX 
global PADDLE_WIDTH DT
global paddle_x_left paddle_x_right
global WALL_X_MIN WALL_X_MAX Counter

if (paddle_x_left <  WALL_X_MIN) % left wall limit
    paddle_x_left = WALL_X_MIN;
    paddle_x_right = WALL_X_MIN + 20;
end

if (paddle_x_right > WALL_X_MAX) % right wall limit 
    paddle_x_left = WALL_X_MAX - 20;
    paddle_x_right = WALL_X_MAX;
end



paddle_x_left = paddle_x_left + PADDLE_VX*DT;
paddle_x_right = paddle_x_left + PADDLE_WIDTH; 

if( Counter == 1 )  % counter was created for step wise paddle movement 
    Coutner = 0;
    PADDLE_VX = 0;
end

% paddle_x_left = paddle_x_left + PADDLE_VX*DT;
% paddle_x_right = paddle_x_left + PADDLE_WIDTH; 

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
global PADDLE_VX PADDLE_SPEED Counter

switch event.Key
  case 'rightarrow'
    PADDLE_VX = PADDLE_SPEED;
    Counter = 1;
  case 'leftarrow'
    PADDLE_VX = -PADDLE_SPEED;
    Counter = 1;
  otherwise
    PADDLE_VX = 0;  
   
end

