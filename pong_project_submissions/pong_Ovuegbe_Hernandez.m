
function pong_basic

%Modified the pong code by David Buckingham
%https://www.mathworks.com/matlabcentral/fileexchange/31177-dave-s-matlab-pong

%%%%%% main part of the code %%%
global game_over 

close all
initData  %first function, initialize the data variables
initFigure %second function, initialize the figure
initFigure %second function, initialize the figure
while ~game_over %runs till game_over = 1
%     readV; %%%%%%%% Read Arduino voltage
    moveBall; %third function, compute ball movement including collision detection
    moveBall2;
    movePaddle; %fourth function, compute paddle position based on user input. 
    movePaddle2; %fourth function, compute paddle position based on user input. 
    move_Extension%move the extensions
    refreshPlot; %fifth function, refresh plot based on moveBall and movePaddle
    
    
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function initData %first function, initialize the data variables
;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX 
global PADDLE_WIDTH BALL_SIZE PADDLE_WIDTH2
global BALL_INIT_VX BALL_INIT_VY DT DELAY BALL_INIT_VX2 BALL_INIT_VY2
global PADDLE_VX PADDLE_SPEED PADDLE_VX2 PADDLE_SPEED2 
global game_over level
global EXTENSION_R EXTENSION_L EXTENSION_LVX EXTENSION_RVX EXTENSION_SPEED



level = 0;
game_over = 0;
WALL_X_MIN = 0;
WALL_X_MAX = 100;
WALL_Y_MIN = 0;
WALL_Y_MAX = 100;
PADDLE_WIDTH = 20;
PADDLE_WIDTH2 = 20;
BALL_SIZE = 10;
BALL_INIT_VX = -0.5;
BALL_INIT_VY = -0.5;
BALL_INIT_VX2 = -0.75;
BALL_INIT_VY2 = -0.5;
PADDLE_VX = 0;
PADDLE_SPEED = 3; 
PADDLE_VX2 = 0;
PADDLE_SPEED2 = 3; 
DT = 0.1; 
DELAY = 0.001;
EXTENSION_R = 10;
EXTENSION_L = 10;
EXTENSION_LVX =1.75;
EXTENSION_RVX = 4.5;
EXTENSION_SPEED = 1.5;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function initFigure %second function, initialize the figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global PADDLE_WIDTH BALL_SIZE 
global WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX
global BALL_INIT_VX BALL_INIT_VY BALL_INIT_VX2 BALL_INIT_VY2
global ball_x ball_y ball_vx ball_vy ball_x2 ball_y2 ball_vx2 ball_vy2 
global paddle_x_left paddle_x_right paddle_y paddle_x_left2 paddle_x_right2 paddle_y2
global ball_anim paddle_anim extension_animL extension_animR ball_anim2 paddle_anim2
global level
global extension_left extension_right
global EXTENSION_R EXTENSION_L 


fig = figure; %initialize the figure
set(fig, 'Resize', 'off'); %do not allow figure to resize
set(fig,'KeyPressFcn',@keyDown); %setkey presses for later
ball_x = WALL_X_MAX; %0.5*(WALL_X_MIN+WALL_X_MAX); 
ball_y = WALL_Y_MAX;
ball_vx = BALL_INIT_VX; 
ball_vy = BALL_INIT_VY;
ball_x2 = WALL_X_MAX-5; %0.5*(WALL_X_MIN+WALL_X_MAX); 
ball_y2 = WALL_Y_MAX-5;
ball_vx2 = BALL_INIT_VX2; 
ball_vy2 = BALL_INIT_VY2;
paddle_x_left = 0;
paddle_x_right = PADDLE_WIDTH;
paddle_y = 10;
paddle_x_left2 = 0;
paddle_x_right2 = PADDLE_WIDTH;
paddle_y2 = 10;
extension_left = 0;
extension_right = 20;

axis([WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX]); %set the size of the board.
axis manual;
hold on;
title(['<z/c> & <left/right> to move the paddle; score = ',num2str(level)],'Fontsize',14);
set(gca, 'color', 'w', 'YTick', [], 'XTick', []); %remove x and y label
xlabel('Chinonso Ovuegbe');
ylabel('Ernesto Hernandez'); 

%%%%%%% set the ball and paddle %%%%%%
ball_anim = plot(ball_x,ball_y,'o','Markersize',BALL_SIZE,'Markerfacecolor','r','Markeredgecolor','r'); %create ball
ball_anim2 = plot(ball_x2,ball_y2,'o','Markersize',BALL_SIZE,'Markerfacecolor','g','Markeredgecolor','r'); %create ball
paddle_anim = line('Xdata',[paddle_x_left paddle_x_right],'Ydata',[paddle_y paddle_y],'Color','g','Linewidth',5); %paddle
paddle_anim2 = line('Xdata',[paddle_x_left2 paddle_x_right2],'Ydata',[paddle_y2 paddle_y2],'Color','b','Linewidth',5); %paddle
%extension_animL = line('Xdata',[paddle_x_left+ EXTENSION_L - extension_left, paddle_x_left  - extension_left],'Ydata', [paddle_y paddle_y],'Color','r','Linewidth',10); % add the extension to the game
extension_animR = line('Xdata',[paddle_x_right , paddle_x_right + EXTENSION_R ],'Ydata', [paddle_y paddle_y],'Color','r','Linewidth',10);

%%%%%%%% set the walls %%%%%%%
line('Xdata',[WALL_X_MIN WALL_X_MIN],'Ydata',[WALL_Y_MIN WALL_Y_MAX],'Color','k','Linewidth',3); %left wall
line('Xdata',[WALL_X_MIN WALL_X_MAX],'Ydata',[WALL_Y_MAX WALL_Y_MAX],'Color','k','Linewidth',3); %top wall
line('Xdata',[WALL_X_MAX WALL_X_MAX],'Ydata',[WALL_Y_MIN WALL_Y_MAX],'Color','k','Linewidth',3); %right wall


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function moveBall %third function, compute ball movement including collision detection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global ball_x ball_y ball_vx ball_vy  DT
global WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX
global paddle_x_left paddle_x_right paddle_y paddle_x_left2 paddle_x_right2 paddle_y2
global game_over level

%ball_x = ball_x + ball_vx*DT;
%ball_y = ball_y + ball_vy*DT;

%%%%%%%% Basic pong edit #1: %%%%%%%%%%%%
% Write code to move the ball here. You code will include logic to get the ball to 
% detect the left, right, and top wall and the paddle and subsequently to change its
% movement based on which wall/paddle the ball hits.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (ball_x <= 0)
    ball_vx =  -1*ball_vx;
    ball_x = ball_x + ball_vx*DT;
ball_y = ball_y + ball_vy*DT;
else
    ball_x = ball_x + ball_vx*DT;
ball_y = ball_y + ball_vy*DT;
end

% if (ball_y <= paddle_y)
%     if (ball_x >= paddle_x_left)
%         if(ball_x <= paddle_x_left + 20 )
% %             disp('in loop')
% %             paddle_x_left
% %             paddle_x_right
% %             ball_x
%           ball_vy =  -1*ball_vy;
%             ball_x = ball_x + ball_vx*DT;
%             ball_y = ball_y + ball_vy*DT;
%             level = level +1; %Scoring criteria to record 1 point for each bounce 
%             title(['press keys <left/right> to move the paddle1; Score = ',num2str(level)],'Fontsize',14);
%         else
%              ball_x = ball_x + ball_vx*DT;
%             ball_y = ball_y + ball_vy*DT;
%   
%         end
% else 
%      ball_x = ball_x + ball_vx*DT;
%     ball_y = ball_y + ball_vy*DT;
%     end
% end

%When ball 1 hits paddle 2 
if (ball_y <= paddle_y2)
    if (ball_x >= paddle_x_left2)
        if(ball_x <= paddle_x_left2 + 20 )
%             disp('in loop')
%             paddle_x_left
%             paddle_x_right
%             ball_x
          ball_vy =  -1*ball_vy;
            ball_x = ball_x + ball_vx*DT;
            ball_y = ball_y + ball_vy*DT;
           
            level = level +1; %Scoring criteria to record 1 point for each bounce 
             title(['press keys <left/right> to move the paddle1; Score = ',num2str(level)],'Fontsize',14)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        else
            if (ball_x >= paddle_x_left)
        if(ball_x <= paddle_x_left + 20 )
%             disp('in loop')
%             paddle_x_left
%             paddle_x_right
%             ball_x
          ball_vy =  -1*ball_vy;
            ball_x = ball_x + ball_vx*DT;
            ball_y = ball_y + ball_vy*DT;
           level = level +1; %Scoring criteria to record 1 point for each bounce 
             title(['press keys <left/right> to move the paddle1; Score = ',num2str(level)],'Fontsize',14) 
            
        
        else
             ball_x = -1;
            ball_y = -1;
            ball_vx =0;
            ball_vy =0;
        end
      else
           ball_x = -1;
            ball_y = -1;
            ball_vx =0;
            ball_vy =0;
            end
        end
            
       
    else
            
      if (ball_x >= paddle_x_left)
        if(ball_x <= paddle_x_left + 20 )
%             disp('in loop')
%             paddle_x_left
%             paddle_x_right
%             ball_x
          ball_vy =  -1*ball_vy;
            ball_x = ball_x + ball_vx*DT;
            ball_y = ball_y + ball_vy*DT;
            level = level +1; %Scoring criteria to record 1 point for each bounce 
            title(['press keys <left/right> to move the paddle1; Score = ',num2str(level)],'Fontsize',14)
            
        
        else
             ball_x = -1;
            ball_y = -1;
            ball_vx =0;
            ball_vy =0;
        end
      else
           ball_x = -1;
            ball_y = -1;
            ball_vx =0;
            ball_vy =0;
      end
       
    end
end

if (ball_x >= 100)
   
    ball_vx =  -1*ball_vx;
    ball_x = ball_x + ball_vx*DT;
ball_y = ball_y + ball_vy*DT;
else
    ball_x = ball_x + ball_vx*DT;
ball_y = ball_y + ball_vy*DT;
end
if (ball_y >= 100)
   
    ball_vy =  -1*ball_vy;
    ball_x = ball_x + ball_vx*DT;
ball_y = ball_y + ball_vy*DT;
else
    ball_x = ball_x + ball_vx*DT;
ball_y = ball_y + ball_vy*DT;

end    

%  if (ball_y < WALL_Y_MIN)
%       game_over = 0; 
%       disp('One more life left') 
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function moveBall2 %third function, compute ball movement including collision detection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global ball_x2 ball_y2 ball_y ball_vx2 ball_vy2  DT
global WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX
global paddle_x_left paddle_x_right paddle_y paddle_x_left2 paddle_x_right2 paddle_y2
global game_over level

%ball_x = ball_x + ball_vx*DT;
%ball_y = ball_y + ball_vy*DT;

%%%%%%%% Basic pong edit #1: %%%%%%%%%%%%
% Write code to move the ball here. You code will include logic to get the ball to 
% detect the left, right, and top wall and the paddle and subsequently to change its
% movement based on which wall/paddle the ball hits.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if (ball_x2 <= 0)
   
    ball_vx2 =  -1*ball_vx2;
    ball_x2 = ball_x2 + ball_vx2*DT;
ball_y2 = ball_y2 + ball_vy2*DT;
else
    ball_x2 = ball_x2 + ball_vx2*DT;
ball_y2 = ball_y2 + ball_vy2*DT;
end

% if (ball_y2 <= paddle_y)
%     if (ball_x2 >= paddle_x_left)
%         if(ball_x2 <= paddle_x_left + 20 )
%             
%           ball_vy2 =  -1*ball_vy2;
%             ball_x2 = ball_x2 + ball_vx2*DT;
%             ball_y2 = ball_y2 + ball_vy2*DT;
%             level = level +1; 
%             
%         else
%              ball_x2 = ball_x2 + ball_vx2*DT;
%             ball_y2 = ball_y2 + ball_vy2*DT;
%   
%         end
% else 
%      ball_x2 = ball_x2 + ball_vx2*DT;
%     ball_y2 = ball_y2 + ball_vy2*DT;
%     end
% end

if (ball_y2 <= paddle_y2)
    if (ball_x2 >= paddle_x_left2)
        if(ball_x2 <= paddle_x_left2 + 20 )
%             disp('in loop')
%             paddle_x_left
%             paddle_x_right
%             ball_x
          ball_vy2 =  -1*ball_vy2;
            ball_x2 = ball_x2 + ball_vx2*DT;
            ball_y2 = ball_y2 + ball_vy2*DT;
            level = level +1; %Scoring criteria to record 1 point for each bounce 
           title(['press keys <left/right> to move the paddle1; Score = ',num2str(level)],'Fontsize',14)
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        else
            if (ball_x2 >= paddle_x_left)
        if(ball_x2 <= paddle_x_left + 20 )
%             disp('in loop')
%             paddle_x_left
%             paddle_x_right
%             ball_x
          ball_vy2 =  -1*ball_vy2;
            ball_x2 = ball_x2 + ball_vx2*DT;
            ball_y2 = ball_y2 + ball_vy2*DT;
            level = level +1; %Scoring criteria to record 1 point for each bounce 
            title(['press keys <left/right> to move the paddle1; Score = ',num2str(level)],'Fontsize',14)
        
        else
             ball_x2 = -1;
            ball_y2 = -1;
            ball_vx2 =0;
            ball_vy2 =0;
        end
      else
           ball_x2 = -1;
            ball_y2 = -1;
            ball_vx2 =0;
            ball_vy2 =0;
            end
        end
            
       
    else
            
      if (ball_x2 >= paddle_x_left)
        if(ball_x2 <= paddle_x_left + 20 )
%             disp('in loop')
%             paddle_x_left
%             paddle_x_right
%             ball_x
          ball_vy2 =  -1*ball_vy2;
            ball_x2 = ball_x2 + ball_vx2*DT;
            ball_y2 = ball_y2 + ball_vy2*DT;
            level = level +1; %Scoring criteria to record 1 point for each bounce 
             title(['press keys <left/right> to move the paddle1; Score = ',num2str(level)],'Fontsize',14)
            
        
        else
             ball_x2 = -1;
            ball_y2 = -1;
            ball_vx2 =0;
            ball_vy2 =0;
        end
      else
           ball_x2 = -1;
            ball_y2 = -1;
            ball_vx2 =0;
            ball_vy2 =0;
      end
       
    end
end


if (ball_x2 >= 100)
   
    ball_vx2 =  -1*ball_vx2;
    ball_x2 = ball_x2 + ball_vx2*DT;
ball_y2 = ball_y2 + ball_vy2*DT;
else
    ball_x2 = ball_x2 + ball_vx2*DT;
ball_y2 = ball_y2 + ball_vy2*DT;
end
if (ball_y2 >= 100)
   
    ball_vy2 =  -1*ball_vy2;
    ball_x2 = ball_x2 + ball_vx2*DT;
ball_y2 = ball_y2 + ball_vy2*DT;
else
    ball_x2 = ball_x2 + ball_vx2*DT;
ball_y2 = ball_y2 + ball_vy2*DT;
end    

%End game only if both balls fall below paddle 
if (ball_y < WALL_Y_MIN...
    && ball_y2 < WALL_Y_MIN)
     game_over = 1;
     text(0.5*WALL_X_MAX, 0.5*WALL_Y_MAX, 'Game Over', 'Fontsize', 14); 
     %text(0.5*WALL_X_MAX, 0.7*WALL_Y_MAX,  num2str(level)); 
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function movePaddle %fourth function, compute paddle position based on user input. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global PADDLE_VX 
global PADDLE_WIDTH DT
global paddle_x_left paddle_x_right 
global WALL_X_MIN WALL_X_MAX PADDLE_SPEED voltage

% voltage = readVoltage(arduino, 'A1')/5;
%  PADDLE_VX = readVoltage(arduino, 'A1')/5*PADDLE_SPEED;              %Arduino read voltage
PADDLE_VX = 0.95*PADDLE_VX;
paddle_x_left = paddle_x_left + PADDLE_VX*DT;
paddle_x_right = paddle_x_left + PADDLE_WIDTH; 

if (paddle_x_right >= WALL_X_MAX)
    PADDLE_VX = 0;
    paddle_x_right = WALL_X_MAX;
    paddle_x_left = WALL_X_MAX - PADDLE_WIDTH;
end
if (paddle_x_left <= WALL_X_MIN)
    PADDLE_VX = 0;
    paddle_x_left = WALL_X_MIN;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function movePaddle2 %fourth function, compute paddle position based on user input. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global PADDLE_VX2 
global PADDLE_WIDTH DT
global paddle_x_left2 paddle_x_right2 
global WALL_X_MIN WALL_X_MAX PADDLE_SPEED2 voltage

% voltage = readVoltage(arduino, 'A1')/5;
%  PADDLE_VX = readVoltage(arduino, 'A1')/5*PADDLE_SPEED;              %Arduino read voltage
PADDLE_VX2 = 0.95*PADDLE_VX2;
paddle_x_left2 = paddle_x_left2 + PADDLE_VX2*DT;
paddle_x_right2 = paddle_x_left2 + PADDLE_WIDTH; 

if (paddle_x_right2 >= WALL_X_MAX)
    PADDLE_VX2 = 0;
    paddle_x_right2 = WALL_X_MAX;
    paddle_x_left2 = WALL_X_MAX - PADDLE_WIDTH;
end
if (paddle_x_left2 <= WALL_X_MIN)
    PADDLE_VX2 = 0;
    paddle_x_left2 = WALL_X_MIN;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function move_Extension %fourth function, compute paddle position based on user input. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global PADDLE_VX 
global  DT
global paddle_x_left paddle_x_right EXTENSION_SPEED
global EXTENSION_R EXTENSION_L extension_left extension_right EXTENSION_LVX EXTENSION_RVX
PADDLE_VX

% extension_left = extension_left + PADDLE_VX*DT*+EXTENSION_LVX*DT;
% extension_right = extension_right + PADDLE_VX*DT*+EXTENSION_RVX*DT; 

% paddle_x_right
% extension_right
% EXTENSION_RVX
% extension_left

extension_left = extension_left + paddle_x_left+EXTENSION_LVX*DT;
% extension_right = extension_right + paddle_x_right+(EXTENSION_RVX*DT); 

if (extension_left <= paddle_x_left - EXTENSION_L)
   % extension_left = paddle_x_left - EXTENSION_L ;
    EXTENSION_LVX = EXTENSION_SPEED ;
end
    if (extension_left >= paddle_x_left)
        %extension_left = paddle_x_left ;
        EXTENSION_LVX = - EXTENSION_SPEED;
    end


if (extension_right >= paddle_x_right )
    extension_right = paddle_x_right  ;
    EXTENSION_RVX =  - EXTENSION_RVX ;
    extension_right = extension_right +(EXTENSION_RVX*DT); 
end
if (extension_right <= paddle_x_right - 2*EXTENSION_R)
        extension_right = paddle_x_right - 2*EXTENSION_R ;
        EXTENSION_RVX =  - EXTENSION_RVX;
        extension_right = extension_right +(EXTENSION_RVX*DT); 
end
if(extension_right < paddle_x_right + EXTENSION_R)
    if(extension_right > paddle_x_right - 2*EXTENSION_R)
        EXTENSION_RVX =  EXTENSION_RVX;
        extension_right = extension_right +(EXTENSION_RVX*DT); 
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
global ball_x ball_y ball_x2 ball_y2 
global ball_anim paddle_anim extension_animR extension_animL ball_anim2 paddle_anim2
global paddle_x_left paddle_x_right paddle_y paddle_x_left2 paddle_x_right2 paddle_y2
global DELAY
global EXTENSION_L EXTENSION_R extension_left extension_right

set(ball_anim, 'XData', ball_x, 'YData', ball_y);
set(ball_anim2, 'XData', ball_x2, 'YData', ball_y2);
set(paddle_anim, 'Xdata',[paddle_x_left paddle_x_right], 'YData', [paddle_y paddle_y]);
set(paddle_anim2, 'Xdata',[paddle_x_left2 paddle_x_right2], 'YData', [paddle_y2 paddle_y2]);
%set(extension_animL,'Xdata',[extension_left,   extension_left + EXTENSION_L],'Ydata', [paddle_y paddle_y]);
set(extension_animR, 'Xdata',[extension_right , extension_right+EXTENSION_R ],'Ydata', [paddle_y paddle_y]);
drawnow;
pause(DELAY);   


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function keyDown(src,event) %called from initFigure to take key press to move the paddle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global PADDLE_VX PADDLE_SPEED PADDLE_VX2 PADDLE_SPEED2

switch event.Key
  case 'rightarrow'
    PADDLE_VX = PADDLE_SPEED;
  case 'leftarrow'
    PADDLE_VX = -PADDLE_SPEED;
  case 'c'
    PADDLE_VX2 = PADDLE_SPEED2;
  case 'z'
    PADDLE_VX2 = -PADDLE_SPEED2;
  otherwise
    PADDLE_VX = 0;
    PADDLE_VX2 = 0;
    
end

% function readV
% global  voltage 
% voltage = readVoltage(arduino,'A1');


