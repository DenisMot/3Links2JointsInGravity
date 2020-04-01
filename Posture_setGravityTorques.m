function P = Posture_setGravityTorques(P)

L = P.Length ; 
c = P.CoM    ; 
m = P.Mass   ; 

alpha = cumsum(P.theta);
NbLinks = P.nLinks;

% gravity (necessary to get forces)
g = 9.81; 

%% compute lever arm ingrediants  
% distance from the axis of rotation to the root of the link
ShiftLnk = L .* cos(alpha);                       
% distance from the root of the link to the CoM
ShiftCoM = L .* c .* cos(alpha); 

%% compute torques at each joint 
for j = 1:NbLinks                                 % for each joint... 	
    T(j) = 0;                                     % init torque at this joint
    for l = j:NbLinks                             % for the distal links...		
    	LA = sum(ShiftLnk(j:l-1)) + ShiftCoM(l);  % lever arm (of each link)
    	Tl = LA .* g .* m(l);                     % torque (of each link)
    	T(j) = T(j) + Tl;                         % sum torques (of each link)
    end
end

P.Torque = T;

end