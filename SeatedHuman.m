function [L, m, c] = SeatedHuman()

% More human like body 
% https://exrx.net/Kinesiology/Segments
% Average values

%     HeadNeck  Trunk   UpperArm  Forearm  Hand
L = [  0.1075,  0.295,   0.175,   0.1585, 0.0575  ];
c = [  0.55,    0.5995,  0.447,   0.432,  0.468   ]; 
m = [  0.0681,  0.4302,  0.0263,  0.015,  0.00585 ]; 

% reorder before joining links (order matters in a kinematic chain...)
NewOrder = [2 1 3 4 5]; 
L = L(NewOrder); 
c = c(NewOrder);
m = m(NewOrder);

% new link length = Trunk, but mass and Com = (Trunk + Head)  
[L1, m1, c1] = JoinTwoLinks ( L(1:2), m(1:2), c(1:2), L(1)); 
% new link of as the sum of forearm + Hand 
[L3, m3, c3] = JoinTwoLinks ( L(4:5), m(4:5), c(4:5), L(4) + L(5)); 
% NB : adding a mass into the hand = increase m(5)

% back to the 3-links system
L = [L1 L(3) L3]; 
m = [m1 m(3) m3]; 
c = [c1 c(3) c3]; 

% scale to body weight and height
BW = 78; 
BH = 1.73; 
L = L .* BH; 
m = m .* BW; 

end

function [LL, mm, cc] = JoinTwoLinks ( L, m, c, newL)
% join 2 links into a single one 

t1 = L(1) * c(1) * m(1) + ( L(1) + L(2) * c(2) ) * m(2); % torque 
la = t1 / ( (m(1) + m(2)) ) ; 
cc = la / newL ; 

LL = newL; 
mm = sum(m);

end