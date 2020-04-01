function P = Posture_set(L, a, c, m, xRoot, yRoot) 

% compute posture variables given the links configuration  

% L : length of links (meter) 
% a : angle of links (degree) 
% m : mass of links (kilogram) 
% c : distance of center of mass (percentage)
% xRoot, yRoot : coordinates of the root of the chain


%% initialisations

% number of links
NbLinks = length(L); 

% error check : we expect input in degrees... 
if all (a < pi ) & all (a > -pi ) 
    a
    warning('Angles are expected to be in degrees...')
end

% angle from horizontal   
alpha = a .* pi ./180;           % radian for all computations
theta = [alpha(1) diff(alpha)];  % difference in alpha 

%% compute coordinates 
xEndLink = cumsum(L .* cos(alpha));  % end of all links 
yEndLink = cumsum(L .* sin(alpha));	
% x = xEndLink(1:end-1);               % end of previous link = beg of current link
% y = yEndLink(1:end-1); 

x = [0, xEndLink];                          % add first link, with Root coordinate
y = [0, yEndLink]; 
x = x + xRoot; 
y = y + yRoot; 

%% pack all that is a single struct (easier than a long list of args)
P.Length = L; 
P.CoM    = c; 
P.Mass   = m; 
P.x      = x; 
P.y      = y; 
P.theta  = theta; 
P.nLinks = NbLinks; 


P = Posture_setGravityTorques(P); 

end