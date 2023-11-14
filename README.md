# InvertedPendulumControl

This project was part of the ME 6404: Advanced Control System Design and Implementation course as part of my graduate studies at the Georgia Institute of Technology.

It consisted of forming groups of two to explore the dynamics of an inverted pendulum system and to create various types of controllers for stabilization.

Specifically, the project initially required the derivation of the equations of motion of the inverted pendulum system and the conversion of the system into two types of state-space representations: force-based and velocity-based control efforts. The force-based system used `[x, x_dot, theta, theta_dot]` to represent the states of the system, while the velocity-based system used `[theta_integral, theta, x]` as the states.

Afterwards, several controllers of various objectives were developed and implemented in simulation, each of which were tested against disturbances inputted by the user:
1. A force-based non-linear controller using feedback linearization causing the pendulum to become upright if it is initially hanging down
2. A force-based linear-quadratic regulator (LQR) to drive the four states of the system towards zero, assuming the pendulum is initially upright
3. Combining force-based feedback linearization and LQR control to initially right the pendulum if it is initially hanging, and drive all the states to zero if the pendulum is near the upright position
4. A velocity-based LQR controller to balance the pendulum provided that the pendulum is initially upright


A PDF copy of the final lab report is provided summarizing the project objectives, methodology, derivation of the system's state-space representations, derivation of the controllers, and a discussion/analysis of the controllers' performances.

Additionally, a video has been created showcasing the results of the controllers' performance in simulation, whose link is as follows: https://youtu.be/S0qoqIZO_Pk
