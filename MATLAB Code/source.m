function source
clear all
clear classes
clc

z1 = 0;

%CONSTANTS
L  = 1.0;               %Length
mc = 3;                 %Mass of Cart
mp = 1;                 %Mass of Payload
b  = 0.1;               %Damping factor
g  = 9.81;              %Gravity
min_cycle = 0.05;       %Minimum cycle time
Mode = 'Acceleration';  %Velocity or Force or Acceleration
th_in = pi;             %Initial Angle

%PREPARE THE FIGURE WINDOW & GET PENDULUM OBJECT
figure(1); clf
Pend = PENDULUM('InitialStates',[th_in 0 0 0], 'WorkspaceLength', 8,'Damping',b,...
    'MassCart', mc, 'MassPendulum', mp, 'PendulumLength',L,'Mode',Mode);
 
%PREPARE THE STREAMING FIGURE WINDOWS
figure(2); clf

subplot(3,1,1);
Stream_Theta = STREAM_AXIS_DATA(gca);
ylabel('\theta')

subplot(3,1,2);
Stream_Pos = STREAM_AXIS_DATA(gca);
ylabel('Position')

subplot(3,1,3);
Stream_Vel = STREAM_AXIS_DATA(gca);
ylabel('Velocity')


%BEGINNING OF SIMULATION LOOP
quit    = 0;
U_fbl   = 0;
del     = min_cycle;

while quit == 0
    
    %KEEP TRACK OF TIME
    now = GETTIME;
    
    %CHECK IF THE ESC, F1 KEY IS BEING PRESSED
    tmp = keyinfo;
    tmp = tmp(1);
    if  tmp == 27
        quit = 1;
    end
    clear tmp
    
    %GET VR FROM THE KEYBOARD
    %37 = left  arrow  %39 = right arrow
    U_manual = GET_MANUAL_COMMAND(37, 39);
    
    % The States
    Q  = Pend.Q;
    q1 = Q(1);
    q2 = Q(2);
    q3 = Q(3);
    q4 = Q(4);
    

    if(abs(q1) < pi/10)
        Mode = 'Force';
    else
        Mode = 'Acceleration';
    end
        
    %Feedback Linearization   
    switch Mode
        case 'Force'
            U_fbl = 0;
            
        case 'Velocity'
            %U_fbl = ??
            
        case 'Acceleration'    
            k0 = 10;
            k1 = 20/3;
            v = (-k0*q1) - (k1*q2);
            U_fbl = (L/cos(q1)) * (v - ((g/L) * sin(q1)) + ((1/(mp * L))*(b*q2)));
            U_lqr = 0;
    end
    
    %Full State Feedback (from LQR)
    switch Mode
        case 'Force'       
            K = [139.6402   40.7009   -8.1650  -13.0049];
            X = Q;
            U_lqr = -K*X;
        case 'Velocity'
            K = [36.0602   11.3308   -2.5820]; 
            z1 = z1*0.99 + Q(1)*del;
            z2 = Q(1);
            z3 = Q(3);
            Z = [z1 z2 z3]';
            
            U_lqr = -K * Z;
            %U_lqr = ??
            
            %hint: this mode is sensitive to numerical error that manifests itself in the form of 'integral wind-up'. See if
            %you can understand why this is the case. To make this mode work reliably in this simulation environment, you need to
            %mitigate the integral wind-up.
            
            %K       = [??  ??  ??];
            %z1      = z1*0.99 + Q(1)*del;               %0.99 mitigates integral wind-up in the z1 state caused by numerical errors.
            %z2      = Q(1);
            %z3      = Q(3);
            %Z       = [z1 z2 z3]';
            %U_lqr   = -K * Z;
            
        case 'Acceleration'
                %U_lqr = ??
    end
  
    
    %Actuate the Pendulum
    Pend.U = U_manual + U_fbl + U_lqr;    
         
    %Trace states
    Stream_Theta.stream(now, Q(1));
    Stream_Pos.stream(now, Q(3));
    Stream_Vel.stream(now, Q(4));
     
    %update screen
    drawnow
    
    %HANDLE ANY IDLE TIME
    finish = GETTIME;    
    while finish <= now + min_cycle;
        finish = GETTIME;
    end
    del = finish - now;
end


%--------------------------------------------------
function Uout = GET_MANUAL_COMMAND(xm, xp)
umax 	= 1;
U       = 0; 

tmp = keyinfo;
if sum(abs(tmp)) ~= 0
    if find(tmp == xp)
        U = U + umax;
    end
    if find(tmp == xm)
        U = U - umax;
    end
end

Uout = U;

%--------------------------------------------------
function out = GETTIME
%time = GETTIME returns the current cpu clock time in milliseconds

tmp = clock;
out = 3600*tmp(4) + 60*tmp(5)+tmp(6);
     


