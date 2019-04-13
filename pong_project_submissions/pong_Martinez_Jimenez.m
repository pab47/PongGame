function pong_advanced
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

global BLOCKS HIGHSCORE
level = 1;
game_over = 0;
WALL_X_MIN = 0;
WALL_X_MAX = 100;
WALL_Y_MIN = 0;
WALL_Y_MAX = 100;
PADDLE_WIDTH = 20;
BALL_SIZE = 8;
BALL_INIT_VX = 7;
BALL_INIT_VY = 7;
PADDLE_VX = 0;
PADDLE_SPEED = 10; 
DT = 0.1; 

%%% Initializing a 5x10 of BLOCKS %%%
BLOCKS = zeros(5,10);
HIGHSCORE = 0;
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

global BLOCKS SCORE GAMEOVER WIN


fig = figure; %initialize the figure
set(fig, 'Resize', 'off'); %do not allow figure to resize
set(fig,'KeyPressFcn',@keyDown); %setkey presses for later
ball_x = paddle_x_left + PADDLE_WIDTH/2; %0.5*(WALL_X_MIN+WALL_X_MAX); 
ball_y = paddle_y + 2;
ball_vx = BALL_INIT_VX; 
ball_vy = BALL_INIT_VY;
paddle_x_left = 0;
paddle_x_right = PADDLE_WIDTH;
paddle_y = 10;
axis([WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX]); %set the size of the board.
axis manual;
hold on;
xlabel('Victor Martinez - Enrique Jimenez','FontSize',15)
title(['press keys <left/right> to move the paddle; level = ',num2str(level)],'Fontsize',14);
set(gca, 'color', 'k', 'YTick', [], 'XTick', []); %remove x and y label

%%%%%%% set the ball and paddle %%%%%%
ball_anim = plot(ball_x,ball_y,'o','Markersize',BALL_SIZE,'Markerfacecolor','r','Markeredgecolor','r'); %create ball
paddle_anim = line('Xdata',[paddle_x_left paddle_x_right],'Ydata',[paddle_y paddle_y],'Color','w','Linewidth',5); %paddle

%%%%%%%% set the walls %%%%%%%
line('Xdata',[WALL_X_MIN WALL_X_MIN],'Ydata',[WALL_Y_MIN WALL_Y_MAX],'Color','k','Linewidth',2); %left wall
line('Xdata',[WALL_X_MIN WALL_X_MAX],'Ydata',[WALL_Y_MAX WALL_Y_MAX],'Color','k','Linewidth',2); %top wall
line('Xdata',[WALL_X_MAX WALL_X_MAX],'Ydata',[WALL_Y_MIN WALL_Y_MAX],'Color','k','Linewidth',2); %right wall


%%%%%%% Set the BLOCKS %%%%%%%%%
colors = 'brgyw';
for i=1:5
    for j=0:9
        BLOCKS(i,j+1) = rectangle(...
        'Position',[j*WALL_X_MAX/10,WALL_Y_MAX-WALL_Y_MAX/20*(2+i),WALL_X_MAX/10,WALL_Y_MAX/20],...
        'FaceColor',colors(i));
    end

%%%%% Set Score %%%%
    
    SCORE = text(0,WALL_Y_MAX-(WALL_Y_MAX/20),' Score:    ',...
            'FontName','Impact',...
            'Color','w',...
            'FontWeight','Bold',...
            'FontSize',15);
        
    GAMEOVER = text(WALL_X_MAX/2,WALL_Y_MAX/2,sprintf('             '),...
            'FontName','Impact',...
            'FontWeight','Bold',...
            'FontSize',20,...
            'FontUnits','normalized',...
            'HorizontalAlignment','Center',...
            'color','r');
       
     WIN = text(WALL_X_MAX/2,WALL_Y_MAX/2,sprintf('             '),...
            'FontName','Impact',...
            'FontWeight','Bold',...
            'FontSize',20,...
            'FontUnits','normalized',...
            'HorizontalAlignment','Center',...
            'color','y');

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function moveBall %third function, compute ball movement including collision detection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global ball_x ball_y ball_vx ball_vy  DT
global WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX
global paddle_x_left paddle_x_right paddle_y
global game_over level

global BLOCKS SCORE GAMEOVER HIGHSCORE WIN ball_anim

ball_x = ball_x + ball_vx*DT;   ex = 1;
ball_y = ball_y + ball_vy*DT;   ey = 1 + 0.01*rand;

%%%% Ball hitting Paddle%%%%
if (paddle_x_left < ball_x && ball_x < paddle_x_right && ball_y < paddle_y + 1.5)
    ball_vx = ball_vx;
    ball_vy = -ey*ball_vy;
    
%%% SOUND When hitting PADDLE%%%
amp=10; % short
fs=2050 ; 
duration=5;
freq=1500;
values=0:19/fs:duration;
a=amp*sin(2*pi* freq*values);
sound(a);

end

%%%% Ball hitting Left Wall%%%%
if(ball_x < WALL_X_MIN + 1.5)
    ball_vx = -ex*ball_vx;
    ball_vy = ball_vy;
end

%%%% Ball hitting Top Wall%%%%
if(ball_y > WALL_Y_MAX - 1.5)
    ball_vx = ball_vx;
    ball_vy = -ey*ball_vy;
end

%%%% Ball hitting Right Wall%%%%
if(ball_x > WALL_X_MAX - 1.5)
    ball_vx = -ex*ball_vx;
    ball_vy = ball_vy;
end 

%%%% Ball hitting BLOCKS%%%%
 YPos = ceil(ball_y/WALL_Y_MAX*20);  
 YPos = 19-YPos;

  if ismember(YPos,[1 2 3 4 5])
     XPos = max(1,ceil(ball_x/WALL_X_MAX*10));
     if BLOCKS(YPos,XPos)
              delete(BLOCKS(YPos,XPos))
              BLOCKS(YPos,XPos) = 0;
              ball_vx = ball_vx;
              ball_vy = -ey*ball_vy; 
              HIGHSCORE = HIGHSCORE + (6-YPos);          
              set(SCORE,'String',sprintf(' Score: %i', HIGHSCORE));

   %%%SOUND When hitting BLOCKS%%%           
amp=10; % ugly median
fs=9950  ;
duration=95;
freq=9000;
values=0:919/fs:duration;
a=amp*cos(pi* freq*values);
sound(a);
     
     

                  %%%% YOU WON %%%%
             if isempty(find(BLOCKS,1))
                delete(ball_anim);             
                
             %%% SOUND When you WIN :D %%% 
             
 %%%%%%%%%%%%%%%%%%%%%%%% PUT SOUND WHEN YOU WIN HERE %%%%%%%%%%%%%%%%%%%     

                set(WIN,'String',sprintf('YOU WIN!!'),'Visible','on')
             end
     end
  end
             
             
                   %%%% GAME OVER %%%%
if (ball_y < WALL_Y_MIN)
    game_over = 1;
            %%% SOUND When you LOOSE :P %%%     
                load laughter.mat;
                sound (y);   
                set(GAMEOVER,'String',sprintf('GAME OVER'),'Visible','on')
            
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

%%% PADDLE Stops at Left Wall %%%%

if (paddle_x_left < WALL_X_MIN)    
   paddle_x_left = WALL_X_MIN; 
   
%%%% PADDLE Stops at Right Wall %%%%
   
elseif(paddle_x_right > WALL_X_MAX)    
    paddle_x_right = WALL_X_MAX;    
    paddle_x_left = WALL_X_MAX - PADDLE_WIDTH;
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function refreshPlot %fifth function, refresh plot based on moveBall and movePaddle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global ball_x ball_y
global ball_anim paddle_anim
global paddle_x_left paddle_x_right paddle_y
global DELAY  level

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


