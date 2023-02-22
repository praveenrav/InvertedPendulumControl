clear
clc

L  = 1.0;               %Length
mc = 3;                 %Mass of Cart
mp = 1;                 %Mass of Payload
b  = 0.1;               %Damping factor
g  = 9.81;              %Gravity
M = mc + mp;

% Force Domain LQR:
a21 = (M * g)/(L * mc);
a22 = (-b)/(mp * L);
a41 = (mp * g)/(mc);

A = [0 1 0 0; a21 a22 0 0; 0 0 0 1; a41 0 0 0];
B = [0 (1/(L*mc)) 0 (1/mc)]';
Q = [(10/pi) 0 0 0; 0 (1/pi) 0 0; 0 0 (100/3) 0; 0 0 0 1];
R = 0.5;

[K_forc, S, e] = lqr(A, B, Q, R);

% Velocity Domain LQR:
A = [0 1 0; (g/L) (-b/(mp * L)) 0; 0 0 0];
B = [0; (1/L); 1];
Q = [(10/pi) 0 0; 0 (1/pi) 0; 0 0 (300/3)];
R = 15;

[K_vel, S, e] = lqr(A, B, Q, R);