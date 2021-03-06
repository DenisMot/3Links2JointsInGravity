function Posture_plot(P, iColor)

% plot a posture 
% P : a posture struct (as provided by OnePosture) 
% iColor : index in colors list  

% arguments check 
if nargin < 2 
    iColor = 5;
end


%% do the plot 
hold on; axis equal
Colors = get(gca,'colororder'); 
nColors = size(Colors, 1); 
for i = 1:P.nLinks
    LinkColor = Colors(mod(i+iColor,nColors)+1, :); % next in list of colors
    plotLink(P, i, LinkColor)
end

grid on 

%title(sprintf('Shoulder Angle = %5.0f deg', alpha(2) * 180/pi))
end

function plotLink(P, i, LinkColor)
% plot one link in the posture  
% P : a posture struct (as provided by OnePosture) 
% i : link number 
% LinkColor : color to plot this link 

% unpack the posture struct (easier for equations...)
L = P.Length; 
c = P.CoM; 
m = P.Mass;
x = P.x;
y = P.y; 
alpha = cumsum(P.theta);

% constants 
GravityGain = 1/50; % gain to plot newtons in a 2D space of meters...

% coordinates of the beg of link 
x1 = x(i); 
y1 = y(i); 

% coordinates of the end of link 
x2 = x1 + L(i) .* cos( alpha(i) ); 
y2 = y1 + L(i) .* sin( alpha(i) ); 

% coordinates of the center of mass
xCom = x1 + L(i).* c(i) .* cos( alpha(i) ); 
yCom = y1 + L(i).* c(i) .* sin( alpha(i) ); 

% torque value 
torque = P.Torque(i); 

% plot the link 
plot([x1 x2], [y1 y2], '-', 'LineWidth', 6, 'Color', LinkColor )

% plot the Com
plot(xCom, yCom , 'o', 'MarkerSize', 15, 'MarkerFaceColor', 'white' , 'Color', LinkColor ) ; 

% plot the vertical arrow figuring torque at this link    
yTorque = yCom + torque .* GravityGain ; 
PlotVerticalArrow(xCom, yCom, yTorque, LinkColor, torque)

end

function PlotVerticalArrow(x, yBeg, yEnd, LinkColor, torque)
% plot a vertical arrow with associated number 
% x : position along (only one value : vertical)
% yBeg, yEnd : start and stop of the arrow
% LinkColor : color to plot this link 
% torque : value of the torque to be displayed 

% line of the arrow 
plot([x x], [yBeg yEnd] , '-o', 'MarkerSize', 1, 'MarkerFaceColor', 'white' , 'Color', LinkColor ) ; 
% end of the arrow
if yEnd - yBeg < 0 
    plot(x, yEnd , 'v', 'MarkerSize', 10, 'MarkerFaceColor', 'white' , 'Color', LinkColor ) ; 
else
    plot(x, yEnd , '^', 'MarkerSize', 10, 'MarkerFaceColor', 'white' , 'Color', LinkColor ) ; 
end
% torque value 
text(x, yEnd , sprintf('%10.2f Nm', torque), 'Color', LinkColor)% , 'BackgroundColor', 'white' ) 
end 