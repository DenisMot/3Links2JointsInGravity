// Relation between torque and angle (at the shoulder)
//
// For a seated reaching movement in front of me : 
//   - a 2D profile view captures what is most important 
//   - trunk + arm + forearm summarizes the kinematic chain
//   - the main constaints occur at the end posture 
// For a typical movement : 
//   - the arm and forearm move to the end position
//   - the trunk reamains still   

//// clear things  
close ; clear ; 

////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
// **** FIRST : Initialize ****
// This bloc mimics matlab' automatic function compilation on the path 

PRG_PATH = get_absolute_file_path("main.sce");          
FullFileInitTRT = fullfile(PRG_PATH, "InitTRT.sce" );
exec(FullFileInitTRT); 
chdir(PRG_PATH); 
////////////////////////////////////////////////////////////////////////////////

//// Initialisations 
// define root and end effector position 
x0 = 10;   
xEndEffector = x0 + 0.46; 
y0 = 0;
yEndEffector = y0 + 0.42; 

// define links 
//      first  second    third
L = [  0.75,   0.35,    0.45   ]; // length in meter
a = [    90,    -70,       0   ]; // angle from horizontal in degrees
c = [  0.45,   0.45,    0.55   ]; // position of COM in percent
m = [    20,    1.1,     0.9   ]; // mass in kg

P1 = Posture_set(L, a, c, m, x0, y0) ;   // compute the posture
TrunkAngles = 100:-1:60; 
ShoulderTorques = zeros(TrunkAngles) + %nan; 
ShoulderAngles  = zeros(TrunkAngles) + %nan; 

for iAngle = 1:length(TrunkAngles)
    P2 = Posture_moveTheta1(P1, TrunkAngles(iAngle) );
    ShoulderTorques(iAngle) = P2.Torque(2);                 // store shouder torque 
    ShoulderAngles(iAngle) = sum(P2.theta(1:2)) * 180/%pi;  // store shouder angle 

    if pmodulo(iAngle-1,10)==0 then   // every 10 degrees
        figure(); clf
        plot(x0+1, y0+1.1);     // to get the same scale on all plots
        Posture_plot(P2);   
    end
end

//// final plot : Shoulder Torque as function of Shoulder Angle
// NB : equations predict that this plot looks like cos(alpha2)... 
figure (1001010); clf; 



subplot(2,1,1);set(gca(),"auto_clear","off")
plot(ShoulderAngles,ShoulderTorques,"-*")
plot(ShoulderAngles,ShoulderAngles .*0,"-.k")
xlabel("Shoulder Angle (deg)")
ylabel("Shoulder Torque (Nm)")
title("Shoulder Torque as function of Shoulder Angle")

subplot(2,1,2);set(gca(),"auto_clear","off")
plot(TrunkAngles,ShoulderTorques,"-*")
plot(TrunkAngles,ShoulderAngles .*0,"-.k")
xlabel("Trunk Angle (deg)")
ylabel("Shoulder Torque (Nm)")
title("Shoulder Torque as function of trunk Angle")
