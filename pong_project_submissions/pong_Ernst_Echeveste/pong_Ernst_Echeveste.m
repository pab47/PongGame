function pong_basic
%Modified the pong code by David Buckingham
%https://www.mathworks.com/matlabcentral/fileexchange/31177-dave-s-matlab-pong

%%%%%% main part of the code %%%
global game_over
global count spacing
global DELAY
global portal_jumps
global vels
global time_1

close all
initData  %first function, initialize the data variables
initFigure %second function, initialize the figure
while ~game_over %runs till game_over = 1
    moveBall; %third function, compute ball movement including collision detection
    movePaddle; %fourth function, compute paddle position based on user input. 
    refreshPlot; %fifth function, refresh plot based on moveBall and movePaddle
    if count == spacing
        choice = floor(rand()*10);
    elseif count >= spacing
        if choice < 5
            draw_Portal_1
        elseif choice >=5
            draw_Portal_2
        end
    end
    count = count+1;
end
clf('reset');
set(gca, 'color', 'k', 'YTick', [], 'XTick', []);
text(.2,.5,'GAME OVER', 'Color','w','FontSize', 30,'FontName','BankGothic Md BT');
pause(DELAY*2000);
clf('reset');
set(gca, 'color', 'k', 'YTick', [], 'XTick', []);
text(.15,.7,'Finishing velocity:','Color','w','FontSize', 14,'FontName','BankGothic Md BT');
text(.2,.6,[num2str(round(vels(1,length(vels)),2)),' in the X direction'],'Color','w','FontSize', 14,'FontName','BankGothic Md BT');
text(.2,.5,[num2str(round(vels(2,length(vels)),2)),' in the Y direction'],'Color','w','FontSize', 14,'FontName','BankGothic Md BT');
text(.15,.35,['Time elapsed: ', num2str(round(time_1,2)),' Seconds'],'Color','w','FontSize', 14,'FontName','BankGothic Md BT');
text(.15,.25,['Number of portal jumps: ', num2str(portal_jumps)],'Color','w','FontSize', 14,'FontName','BankGothic Md BT');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function initData %first function, initialize the data variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX
global PADDLE_WIDTH BALL_SIZE 
global BALL_INIT_VX BALL_INIT_VY DT DELAY
global PADDLE_VX PADDLE_SPEED 
global game_over level
global count spacing
global paddle_1 paddle_2
global portal_jumps
global vels
global Rowdy_Orange Rowdy_Blue Ball_White Paddle_Gray 
global Outside_Border Timer_Color

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
DT = 0.1; 
DELAY = 0.001;

count = 0;
spacing = 600;
paddle_1 = 0;
paddle_2 = 0;
portal_jumps = 0;
vels = [BALL_INIT_VX; BALL_INIT_VY];

Rowdy_Orange = [244 81 30]/255;
Rowdy_Blue = [57 73 171]/255;
Ball_White = [251 252 252]/255;
Paddle_Gray = [66 73 73]/255;
Outside_Border = [66 73 73]/255;
Timer_Color = [26 82 118]/255;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function initFigure %second function, initialize the figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global PADDLE_WIDTH BALL_SIZE 
global WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX
global BALL_INIT_VX BALL_INIT_VY
global ball_x ball_y ball_vx ball_vy 
global paddle_x_left paddle_x_right paddle_y
global ball_anim paddle_anim
global port_1 port_1_2 port_2 port_2_2
global timer_disp
global Ball_White Paddle_Gray Outside_Border Timer_Color Rowdy_Blue

fig = figure; %initialize the figure
set(fig, 'Resize', 'off'); %do not allow figure to resize
set(fig,'KeyPressFcn',@keyDown); %setkey presses for later
set(fig,'KeyReleaseFcn',@keyUp); %setkey presses for later
ball_x = WALL_X_MAX; %0.5*(WALL_X_MIN+WALL_X_MAX); 
ball_y = WALL_Y_MAX;
ball_vx = BALL_INIT_VX; 
ball_vy = BALL_INIT_VY;
paddle_x_left = 0;
paddle_x_right = PADDLE_WIDTH;
paddle_y = 10;
axis([WALL_X_MIN-5 WALL_X_MAX+5 WALL_Y_MIN WALL_Y_MAX+10]); %set the size of the board.
axis manual;
hold on;
title('press keys <left/right> to move the paddle','Fontsize',14);
show_image = imread('UTSA.png');
image(show_image,'XData',[WALL_X_MIN-5 WALL_X_MAX+5],'YData',[WALL_Y_MAX+10 WALL_Y_MIN],'AlphaData',0.5);
xlabel('Sal Echeveste and Justin Ernst');

%%%%%%% set the ball and paddle %%%%%%
ball_anim = plot(ball_x,ball_y,'o','Markersize',BALL_SIZE,'Markerfacecolor',Ball_White,'Markeredgecolor',Rowdy_Blue); %create ball
paddle_anim = line('Xdata',[paddle_x_left paddle_x_right],'Ydata',[paddle_y paddle_y],'Color',Paddle_Gray,'Linewidth',5); %paddle

%%%%%%%% set the walls %%%%%%%
line('Xdata',[WALL_X_MIN WALL_X_MIN],'Ydata',[WALL_Y_MIN WALL_Y_MAX],'Color','k','Linewidth',3); %left wall
line('Xdata',[WALL_X_MIN WALL_X_MAX],'Ydata',[WALL_Y_MAX WALL_Y_MAX],'Color','k','Linewidth',3); %top wall
line('Xdata',[WALL_X_MAX WALL_X_MAX],'Ydata',[WALL_Y_MIN WALL_Y_MAX],'Color','k','Linewidth',3); %right wall

% Timer
tic;
timer_disp = text(35,105,[0,' Seconds'], 'Color',Timer_Color,'FontSize', 16,'FontName','BankGothic Md BT');
text(52,105,'Seconds', 'Color',Timer_Color,'FontSize', 16,'FontName','BankGothic Md BT');

% Outer Walls
line('XData',[WALL_X_MIN-5 WALL_X_MIN-5],'YData',[WALL_Y_MIN WALL_Y_MAX+10],'Color',Outside_Border,'Linewidth',3);
line('XData',[WALL_X_MAX+5 WALL_X_MAX+5],'YData',[WALL_Y_MIN WALL_Y_MAX+10],'Color',Outside_Border,'Linewidth',3);
line('XData',[WALL_X_MIN-5 WALL_X_MAX+5],'YData',[WALL_Y_MIN WALL_Y_MIN],'Color',Outside_Border,'Linewidth',3);
line('XData',[WALL_X_MIN-5 WALL_X_MAX+5],'YData',[WALL_Y_MAX+10 WALL_Y_MAX+10],'Color',Outside_Border,'Linewidth',3);

% Portals
port_1 = line('Xdata',[WALL_X_MAX WALL_X_MAX],'Ydata',[WALL_Y_MIN WALL_Y_MAX],'Color','k','Linewidth',2); 
port_1_2 = line('Xdata',[WALL_X_MIN WALL_X_MAX],'Ydata',[WALL_Y_MAX WALL_Y_MAX],'Color','k','Linewidth',2);
port_2 = line('Xdata',[WALL_X_MIN WALL_X_MIN],'Ydata',[WALL_Y_MIN WALL_Y_MAX],'Color','k','Linewidth',2); 
port_2_2 = line('Xdata',[WALL_X_MIN WALL_X_MAX],'Ydata',[WALL_Y_MAX WALL_Y_MAX],'Color','k','Linewidth',2);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function moveBall %third function, compute ball movement including collision detection
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global ball_x ball_y ball_vx ball_vy DT
global WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX
global paddle_x_left paddle_x_right paddle_y
global game_over 
global count
global paddle_1 paddle_2
global portal_jumps
global vels

ball_x = ball_x + ball_vx*DT;
ball_y = ball_y + ball_vy*DT;

cap = 7;
if ball_vx >= cap || ball_vx <=-cap ...
    || ball_vy >=cap || ball_vy <=-cap
    increase_V_Factor = 1;
else
    increase_V_Factor = 1.1;
end

if (ball_x <= WALL_X_MIN)
    ball_vx = -ball_vx*increase_V_Factor;
    ball_vy = ball_vy*increase_V_Factor;
    ball_x = (ball_x)+(ball_vx*DT);
    ball_y = ball_y + ball_vy*DT;
elseif (ball_x >= WALL_X_MAX)
    ball_vx = -ball_vx*increase_V_Factor;
    ball_vy = ball_vy*increase_V_Factor;
    ball_x = (ball_x)+(ball_vx*DT);
    ball_y = ball_y + ball_vy*DT;
elseif (ball_y >= WALL_Y_MAX)
    ball_vy = -ball_vy*increase_V_Factor;
    ball_vx = ball_vx*increase_V_Factor;
    ball_y = (ball_y)+(ball_vy*DT);
    ball_x = ball_x + ball_vx*DT;
elseif (ball_y <= paddle_y+2 ...
        && ball_y >= paddle_y-1 ...
        && ball_x >= paddle_x_left ...
        && ball_x <= paddle_x_right)
    ball_vy = -ball_vy*increase_V_Factor;
    ball_vx = ball_vx*increase_V_Factor;
    ball_y = (ball_y)+(ball_vy*DT);
    ball_x = ball_x + ball_vx*DT;
elseif paddle_1 == 1
    if (ball_x >= WALL_X_MAX-2 ...
           && ball_y <= WALL_Y_MAX-60 ...
           && ball_y >= WALL_Y_MIN+20)
        ball_x = (WALL_X_MIN+13)+(ball_vx*DT);
        ball_y = (WALL_Y_MAX-3) + ball_vy*DT;
        count = 0;
        portal_jumps = portal_jumps+1;
        erase_Portal_1
    elseif (ball_y >= WALL_Y_MAX-2 ...
            && ball_x >= WALL_X_MIN+5 ...
            && ball_x <= WALL_X_MAX-80)
        ball_x = (WALL_X_MAX-3)+(ball_vx*DT);
        ball_y = (WALL_Y_MIN+30) + ball_vy*DT;
        count = 0;
        portal_jumps = portal_jumps+1;
        erase_Portal_1
    end
elseif paddle_2 == 1
    if (ball_x <= WALL_X_MIN+2 ...
           && ball_y <= WALL_Y_MAX-60 ...
           && ball_y >= WALL_Y_MIN+20)
        ball_x = (WALL_X_MAX-13)+(ball_vx*DT);
        ball_y = (WALL_Y_MAX-3) + ball_vy*DT;
        count = 0;
        portal_jumps = portal_jumps+1;
        erase_Portal_2
    elseif (ball_y >= WALL_Y_MAX-2 ...
            && ball_x >= WALL_X_MIN+80 ...
            && ball_x <= WALL_X_MAX-5)
        ball_x = (WALL_X_MIN+3)+(ball_vx*DT);
        ball_y = (WALL_Y_MIN+30) + ball_vy*DT;
        count = 0;
        portal_jumps = portal_jumps+1;
        erase_Portal_2
    end
end
vels = [vels [ball_vx; ball_vy]];

if (ball_y < WALL_Y_MIN+5)
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

if (paddle_x_left <= WALL_X_MIN)
    paddle_x_left = WALL_X_MIN;
    paddle_x_right = paddle_x_left + PADDLE_WIDTH;
elseif (paddle_x_right >= WALL_X_MAX)
    paddle_x_right = WALL_X_MAX;
    paddle_x_left = paddle_x_right - PADDLE_WIDTH; 
end

function draw_Portal_1
    global port_1 port_1_2
    global WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX
    global paddle_1
    global Rowdy_Orange 
    set(port_1,'Xdata',[WALL_X_MAX-2 WALL_X_MAX-2],'Ydata',[WALL_Y_MIN+20 WALL_Y_MAX-60],'Color',Rowdy_Orange,'Linewidth',3); 
    set(port_1_2,'Xdata',[WALL_X_MIN+5 WALL_X_MAX-80],'Ydata',[WALL_Y_MAX-2 WALL_Y_MAX-2],'Color',Rowdy_Orange,'Linewidth',3);
    paddle_1 = 1;
    
function draw_Portal_2
    global port_2 port_2_2
    global WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX
    global paddle_2
    global Rowdy_Blue
    
    set(port_2,'Xdata',[WALL_X_MIN+2 WALL_X_MIN+2],'Ydata',[WALL_Y_MIN+20 WALL_Y_MAX-60],'Color',Rowdy_Blue,'Linewidth',3); 
    set(port_2_2,'Xdata',[WALL_X_MIN+80 WALL_X_MAX-5],'Ydata',[WALL_Y_MAX-2 WALL_Y_MAX-2],'Color',Rowdy_Blue,'Linewidth',3);
    paddle_2 = 1;
    
function erase_Portal_1
    global port_1 port_1_2
    global WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX
    global paddle_1
    set(port_1,'Xdata',[WALL_X_MAX WALL_X_MAX],'Ydata',[WALL_Y_MIN WALL_Y_MAX],'Color','k','Linewidth',2); 
    set(port_1_2,'Xdata',[WALL_X_MIN WALL_X_MAX],'Ydata',[WALL_Y_MAX WALL_Y_MAX],'Color','k','Linewidth',2);
    paddle_1 = 0;
    
function erase_Portal_2
    global port_2 port_2_2
    global WALL_X_MIN WALL_X_MAX WALL_Y_MIN WALL_Y_MAX
    global paddle_2
    set(port_2,'Xdata',[WALL_X_MIN WALL_X_MIN],'Ydata',[WALL_Y_MIN WALL_Y_MAX],'Color','k','Linewidth',2); 
    set(port_2_2,'Xdata',[WALL_X_MIN WALL_X_MAX],'Ydata',[WALL_Y_MAX WALL_Y_MAX],'Color','k','Linewidth',2);
    paddle_2 = 0;
       

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function refreshPlot %fifth function, refresh plot based on moveBall and movePaddle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global ball_x ball_y
global ball_anim paddle_anim
global paddle_x_left paddle_x_right paddle_y
global DELAY
global timer_disp
global time_1

set(ball_anim, 'XData', ball_x, 'YData', ball_y);
set(paddle_anim, 'Xdata',[paddle_x_left paddle_x_right], 'YData', [paddle_y paddle_y]);
time_1 = toc;
set(timer_disp,'String',num2str(round(time_1,2)));
drawnow;
pause(DELAY);   


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function keyDown(src,event) %called from initFigure to take key press to move the paddle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global PADDLE_VX PADDLE_SPEED
global game_over

switch event.Key
  case 'rightarrow'
    PADDLE_VX = PADDLE_SPEED;
  case 'leftarrow'
    PADDLE_VX = -PADDLE_SPEED;
  case 'escape'
    game_over = 1; 
  otherwise
    PADDLE_VX = 0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function keyUp(src,event) %called from initFigure to take key release to stop moving the paddle
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global PADDLE_VX 

switch event.Key
  case 'rightarrow'
    PADDLE_VX = 0;
  case 'leftarrow'
    PADDLE_VX = 0;
  otherwise
    PADDLE_VX = 0;
end

