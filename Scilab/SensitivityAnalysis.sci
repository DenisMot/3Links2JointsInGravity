function SensitivityAnalysis(P)
    // Analysis of the sensitivity of errors in segments morphology 
    //
    // LOGIC : change segment length by +/- 10% and check torques 
    // 
    // Output :
    //   3D plot of shoulder torque as a function of link length and trunk angle
    //   posture plot of 3 postures 


    
    changeLength  = (90:1:110) ./ 100;       // Error in segment length 
    nChangeLength = length(changeLength); 
    iChangeToPlot = [1:10:nChangeLength];    // I will plot these ones
    

    // add label information in the posture struct 
    P1 = P; 
    P1.SegmentName = ["Trunk", "Arm", "Forearm"]; 

    for iLink = 1:P1.nLinks
        VaryLinkLength(P1)
    end 

endfunction

////////////////////////////////////////////////////////////////////////////////
// NOTE : 
// because functions are embedded, we do not need to pass arguments : 
// when fun1 calls fun2, fun2 knows all variables in fun1
// This is handy, but imposes long names for variables to avoid confusions.  
////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////
function VaryLinkLength(P)
    P1 = P; 
    // prepare figure to plot postures
    iFigPosture = 100 * iLink; 
    figure(iFigPosture); clf;
    set(gcf(), "figure_name", msprintf("Fig %%d: Change in %s Length", P1.SegmentName(iLink))); 

    // loop 
    for iChangeLength = 1:length(changeLength)
        P1.Length(iLink) = P.Length(iLink) .* changeLength(iChangeLength); 
        [ShoulderTorques, ShoulderAngles, TrunkAngles] = VaryTrunkAngles(P1, iChangeToPlot );
        ST(iChangeLength,:) = ShoulderTorques;
    end
    
    // figure for the 3D plot 
    figure(iLink); clf;
    set(gcf(), "figure_name", msprintf("Fig %%d: Change in %s Length", P1.SegmentName(iLink))); 
    plot3d(changeLength*100, TrunkAngles, ST)
    xlabel(msprintf("%s Length changeLength (%%)", P1.SegmentName(iLink)))
    ylabel(msprintf("%s Angles (°)", P1.SegmentName(iLink)))
    zlabel("ShoulderTorques (Nm)")


endfunction

////////////////////////////////////////////////////////////////////////////////
function [ShoulderTorques, ShoulderAngles, TrunkAngles] = VaryTrunkAngles(P, iChangeToPlot )
    TrunkAngles = 100:-1:60; 
    ShoulderTorques = zeros(TrunkAngles) + %nan; 
    ShoulderAngles  = zeros(TrunkAngles) + %nan; 

    for iAngle = 1:length(TrunkAngles)
        P2 = Posture_moveTheta1(P, TrunkAngles(iAngle) );
        ShoulderTorques(iAngle) = P2.Torque(2);                 // store shouder torque 
        ShoulderAngles(iAngle) = sum(P2.theta(1:2)) * 180/%pi;  // store shouder angle 

        
        iSubPlot = find(iChangeLength == iChangeToPlot ); 
        if (~isempty(iSubPlot) & iAngle == 1 ) then        
            SubPlotPosture(P2, iFigPosture, length(iChangeToPlot), iSubPlot);
            xtitle(msprintf("%s : %5.2f m ", P2.SegmentName(iLink), P2.Length(iLink)))
        end
        
    end
endfunction

function SubPlotPosture(P, iFigPosture, nSubPlot, iSubPlot)
    figure(iFigPosture)
    subplot(1, nSubPlot, iSubPlot)
    Posture_plot(P)
endfunction

////////////////////////////////////////////////////////////////////////////////
function PlotAngles(changeLength, ShoulderTorques, ShoulderAngles, TrunkAngles )

    Colors = jetcolormap(8);        

    nColors = size(Colors, 1); 

    theColor = Colors(pmodulo(iChangeLength+changeLength*100,nColors)+1, :); 
    theLegend = msprintf('%d %%', changeLength*100); 


    subplot(2,1,1)
    plot(ShoulderAngles,ShoulderTorques,"-*", 'Color', theColor )
    plot(ShoulderAngles,ShoulderAngles .*0,"-.k")
    xlabel("Shoulder Angle (deg)")
    ylabel("Shoulder Torque (Nm)")
    title("Shoulder Torque as function of Shoulder Angle")

    subplot(2,1,2)
    plot(TrunkAngles,ShoulderTorques,"-*", 'Color', theColor )
    xlabel("Trunk Angle (deg)")
    ylabel("Shoulder Torque (Nm)")
    title("Shoulder Torque as function of trunk Angle")

    h = gca()
    h.user_data = [h.user_data theLegend]; 
    legend (h.user_data)


endfunction
