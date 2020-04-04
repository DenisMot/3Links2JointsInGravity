function P = Posture_moveTheta1(P, theta1) 

// move to a new posture with a given theta1  
//
// P : a posture struct (as provided by OnePosture) 
// theta1 : agnle of the first link (in degrees) 

// argument check 
if P.Length > 3 then
    error("A posture with only 3 links is expected")
end
// error check : we expect input in degrees... 
if theta1 < %pi  & theta1 > -%pi  then
    theta1
    warning("theta1 is expected in degrees")
end 

// unpack the posture struct 
L = P.Length; 
xRoot = P.x(1); 
yRoot = P.y(1); 

//// change the posture 

theta1 = theta1 .* %pi ./ 180; 

xEnd = P.x($); 
yEnd = P.y($); 

xBeg = xRoot + L(1) .* cos(theta1) ; 
yBeg = yRoot + L(1) .* sin(theta1) ; 

dx = xEnd - xBeg;
dy = yEnd - yBeg;

// compute angles for the last 2 links
// By definition, the first angle is absolute, and the second relative... 
// ... because this is originally thought for 2-links system
[alpha2, theta3] = Cart2Ang(dx, dy, L(2), L(3)); 

// set theta for all the chain 
theta(1,1) = theta1;
theta(1,2) = alpha2 - theta(1); 
theta(1,3) = theta3; 
alpha = cumsum(theta);



// set cartesian coordinates
X = cumsum(P.Length .* cos(alpha));  // $ of all links 
Y = cumsum(P.Length .* sin(alpha));  
X = [xRoot, X + xRoot];                    // add root
Y = [yRoot, Y + yRoot];

// set the posture values (the changed ones)
P.x = X; 
P.y = Y; 
P.theta = theta; 

P = Posture_setGravityTorques(P);
endfunction
 
