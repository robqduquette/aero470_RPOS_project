# aero470_RPOS_project
 Control of a simulated spacecraft performing rendezvous, proximity operations and docking

# Folder Setup

    src - contains source code
    derivations - contains analytical scripts 
    test - contains test files

# Running the simulation

   run the simulation while in the src folder
   
   initfcn.m contains initialization parameters and allows for running the simulation with different parameters. Parameters include:
    - LQR_ON: choose whether to use LQR or PID control
    - pos_init: choose the initial position
    - vel_init: choose the initial velocity
    - n: the mean motion of the target in rad/s
    - m: the mass of the chaser spacecraft
    - max_thrust: the maximum thrust the chaser spacecraft can produce

    PID parameters can be changed in the simulink model.
    LQR state and control penalty matrices can be set in initfcn.m

