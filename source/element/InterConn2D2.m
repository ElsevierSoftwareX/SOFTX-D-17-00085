% Tim Truster
% 08/30/2012
%
% Routine to determine the bounds of integration and other information for
% 2D DG interface elements.
% Generates integration elements of same shape as parent element.
%
% Modified 02/24/2013 for truncated tributary area

truncsectors = 1;

        if nelL == 3 || nelL == 6
        xlintL = zeros(2,3);
        nelLB = 3;
        else
        xlintL = zeros(2,4);
        nelLB = 4;
        end
        if nelR == 3 || nelR == 6
        xlintR = zeros(2,3);
        nelRB = 3;
        else
        xlintR = zeros(2,4);
        nelRB = 4;
        end
        
        % Determine bounds of integration, right
        
        if nelRB == 4
            
            t1 = [(xlR(1,2)-xlR(1,1)); (xlR(2,2)-xlR(2,1)); 0];
            t2 = [(xlR(1,4)-xlR(1,1)); (xlR(2,4)-xlR(2,1)); 0];
            t3 = VecCrossProd(t1,t2);
            aR = VecNormalize(t3);
            hR = sqrt((xlR(1,2)-xlR(1,1))^2+(xlR(2,2)-xlR(2,1))^2)/aR;
            
            drR = 2;
            roR = -1;

            % Upper Limit
            if nodeAR == ElemFlagR(2) || nodeAR == 0
                eR2 = 1;
                xlintR(:,2) = xlR(:,2);
                xlintR(:,3) = xlR(:,3);
            elseif nodeAR == -1 %no enrichment but DG instead
                xy = xlL(:,1);
                POUxi = POU_Coord(xy(1),xy(2),xlR,1,nelR);
                eR2 = POUxi(1);
                xlintR(:,2) = xy;
                shl = shlq(POUxi(1),1,nelR,nelR,0,0);
                xlintR(:,3) = xlR*shl;
            elseif nelR == 9 && nodeAR == ElemFlagR(5)
                eR2 = 0;
                xlintR(:,2) = xlR(:,5);
                xlintR(:,3) = xlR(:,7);
            end
            % Lower Limit
            if nodeBR == ElemFlagR(1) || nodeBR == 0
                eR1 = -1;
                xlintR(:,1) = xlR(:,1);
                xlintR(:,4) = xlR(:,4);
            elseif nodeBR == -1 %no enrichment but DG instead
                xy = xlL(:,2);
                POUxi = POU_Coord(xy(1),xy(2),xlR,1,nelR);
                eR1 = POUxi(1);
                xlintR(:,1) = xy;
                shl = shlq(POUxi(1),1,nelR,nelR,0,0);
                xlintR(:,4) = xlR*shl;
            elseif nelR == 9 && nodeBR == ElemFlagR(5)
                eR1 = 0;
                xlintR(:,1) = xlR(:,5);
                xlintR(:,4) = xlR(:,7);
            end
            
            if truncsectors
            % shorten support for bubble
            lside23 = norm(xlintR(:,2)-xlintR(:,3),2);
            lside14 = norm(xlintR(:,1)-xlintR(:,4),2);
            lside12 = norm(xlintR(:,2)-xlintR(:,1),2);
            shortyn = (lside12 < lside23) && (lside12 < lside14);
            if shortyn && lside14 < lside23
                lintratio = lside12/lside14;
                lintxy1 = (xlintR(:,4)-xlintR(:,1))*lintratio + xlintR(:,1);
                POUxi = POU_Coord(lintxy1(1),lintxy1(2),xlintR,0,nelRB);
%                 shl = shlq(-1,POUxi(2),nelR,nelR,0,0);
%                 lintxy1 = xlintR*shl;
                xlintR(:,4) = lintxy1;
                shl = shlq(1,POUxi(2),nelRB,nelRB,0,0);
                lintxy2 = xlintR*shl;
                xlintR(:,3) = lintxy2;
            elseif shortyn && lside14 >= lside23
                lintratio = lside12/lside23;
                lintxy1 = (xlintR(:,3)-xlintR(:,2))*lintratio + xlintR(:,2);
                POUxi = POU_Coord(lintxy1(1),lintxy1(2),xlintR,0,nelRB);
%                 shl = shlq(1,POUxi(2),nelR,nelR,0,0);
%                 lintxy1 = xlintR*shl;
                xlintR(:,3) = lintxy1;
                shl = shlq(-1,POUxi(2),nelRB,nelRB,0,0);
                lintxy2 = xlintR*shl;
                xlintR(:,4) = lintxy2;
            end
            end
            
        elseif nelRB == 3
            
            t1 = [(xlR(1,2)-xlR(1,1)); (xlR(2,2)-xlR(2,1)); 0];
            t2 = [(xlR(1,3)-xlR(1,1)); (xlR(2,3)-xlR(2,1)); 0];
            t3 = VecCrossProd(t1,t2);
            aR = VecNormalize(t3);
            aR = aR/2;
            hR = sqrt((xlR(1,2)-xlR(1,1))^2+(xlR(2,2)-xlR(2,1))^2)/aR;
            
            drR = 1;
            roR = 0;

            % Upper Limit
            if nodeAR == ElemFlagR(2) || nodeAR == 0
                eR2 = 1;
                xlintR(:,2) = xlR(:,2);
            elseif nodeAR == -1 %no enrichment but DG instead
                xy = xlL(:,1);
                POUxi = POU_Coord(xy(1),xy(2),xlR,1,nelR);
                eR2 = POUxi(1);
                xlintR(:,2) = xy;
            elseif nelR == 6 && nodeAR == ElemFlagR(4)
                eR2 = 1/2;
            end
            % Lower Limit
            if nodeBR == ElemFlagR(1) || nodeBR == 0
                eR1 = 0;
                xlintR(:,1) = xlR(:,1);
            elseif nodeBR == -1 %no enrichment but DG instead
                xy = xlL(:,2);
                POUxi = POU_Coord(xy(1),xy(2),xlR,1,nelR);
                eR1 = POUxi(1);
                xlintR(:,1) = xy;
            elseif nelR == 6 && nodeBR == ElemFlagR(4)
                eR1 = 1/2;
            end
            xlintR(:,3) = xlR(:,3);
            
            if truncsectors
            % shorten support for bubble
            lside23 = norm(xlintR(:,2)-xlintR(:,3),2);
            lside13 = norm(xlintR(:,1)-xlintR(:,3),2);
            lside12 = norm(xlintR(:,2)-xlintR(:,1),2);
            shortyn = (lside12 < lside23) && (lside12 < lside13);
            if shortyn && lside13 < lside23
                lintratio = lside12/lside13;
                lintxy1 = (xlintR(:,3)-xlintR(:,1))*lintratio + xlintR(:,1);
                shl = shlt(1-lintratio,lintratio,nelRB,nelRB,0,0);
                lintxy2 = xlintR*shl;
                xlintR(:,3) = (lintxy1 + lintxy2)/2;
            elseif shortyn && lside13 >= lside23
                lintratio = lside12/lside23;
                lintxy1 = (xlintR(:,3)-xlintR(:,2))*lintratio + xlintR(:,2);
                POUxi = POU_Coord(lintxy1(1),lintxy1(2),xlintR,1,nelRB);
                shl = shlt(0,POUxi(2),nelRB,nelRB,0,0);
                lintxy2 = xlintR*shl;
                xlintR(:,3) = (lintxy1 + lintxy2)/2;
            end
            end
        
        end
        
        % Determine bounds of integration, left
        
        if nelLB == 4
            
            t1 = [(xlL(1,2)-xlL(1,1)); (xlL(2,2)-xlL(2,1)); 0];
            t2 = [(xlL(1,4)-xlL(1,1)); (xlL(2,4)-xlL(2,1)); 0];
            t3 = VecCrossProd(t1,t2);
            aL = VecNormalize(t3);
            hL = sqrt((xlL(1,2)-xlL(1,1))^2+(xlL(2,2)-xlL(2,1))^2)/aL;
            
            drL = 2;
            roL = -1;

            % Upper Limit
            if nodeAL == ElemFlagL(1) || nodeAL == 0
                eL1 = -1;
                xlintL(:,1) = xlL(:,1);
                xlintL(:,4) = xlL(:,4);
            elseif nodeAL == -1 %no enrichment but DG instead
                xy = xlR(:,2);
                POUxi = POU_Coord(xy(1),xy(2),xlL,1,nelL);
                eL1 = POUxi(1);
                xlintL(:,1) = xy;
                shl = shlq(POUxi(1),1,nelL,nelL,0,0);
                xlintL(:,4) = xlL*shl;
            elseif nelL == 9 && nodeAL == ElemFlagL(5)
                eL1 = 0;
                xlintL(:,1) = xlL(:,5);
                xlintL(:,4) = xlL(:,7);
            end
            % Lower Limit
            if nodeBL == ElemFlagL(2) || nodeBL == 0
                eL2 = 1;
                xlintL(:,2) = xlL(:,2);
                xlintL(:,3) = xlL(:,3);
            elseif nodeBL == -1 %no enrichment but DG instead
                xy = xlR(:,1);
                POUxi = POU_Coord(xy(1),xy(2),xlL,1,nelL);
                eL2 = POUxi(1);
                xlintL(:,2) = xy;
                shl = shlq(POUxi(1),1,nelL,nelL,0,0);
                xlintL(:,3) = xlL*shl;
            elseif nelL == 9 && nodeB == ElemFlagL(5)
                eL2 = 0;
                xlintL(:,2) = xlL(:,5);
                xlintL(:,3) = xlL(:,7);
            end
            
            if truncsectors
            % shorten support for bubble
            lside23 = norm(xlintL(:,2)-xlintL(:,3),2);
            lside14 = norm(xlintL(:,1)-xlintL(:,4),2);
            lside12 = norm(xlintL(:,2)-xlintL(:,1),2);
            shortyn = (lside12 < lside23) && (lside12 < lside14);
            if shortyn && lside14 < lside23
                lintratio = lside12/lside14;
                lintxy1 = (xlintL(:,4)-xlintL(:,1))*lintratio + xlintL(:,1);
                POUxi = POU_Coord(lintxy1(1),lintxy1(2),xlintL,0,nelLB);
%                 shl = shlq(-1,POUxi(2),nelL,nelL,0,0);
%                 lintxy1 = xlintL*shl;
                xlintL(:,4) = lintxy1;
                shl = shlq(1,POUxi(2),nelLB,nelLB,0,0);
                lintxy2 = xlintL*shl;
                xlintL(:,3) = lintxy2;
            elseif shortyn && lside14 >= lside23
                lintratio = lside12/lside23;
                lintxy1 = (xlintL(:,3)-xlintL(:,2))*lintratio + xlintL(:,2);
                POUxi = POU_Coord(lintxy1(1),lintxy1(2),xlintL,0,nelLB);
%                 shl = shlq(1,POUxi(2),nelL,nelL,0,0);
%                 lintxy1 = xlintL*shl;
                xlintL(:,3) = lintxy1;
                shl = shlq(-1,POUxi(2),nelLB,nelLB,0,0);
                lintxy2 = xlintL*shl;
                xlintL(:,4) = lintxy2;
            end
            end
        
        elseif nelLB == 3
            
            t1 = [(xlL(1,2)-xlL(1,1)); (xlL(2,2)-xlL(2,1)); 0];
            t2 = [(xlL(1,3)-xlL(1,1)); (xlL(2,3)-xlL(2,1)); 0];
            t3 = VecCrossProd(t1,t2);
            aL = VecNormalize(t3);
            aL = aL/2;
            hL = sqrt((xlL(1,2)-xlL(1,1))^2+(xlL(2,2)-xlL(2,1))^2)/aL;
            
            drL = 1;
            roL = 0;

            % Upper Limit
            if nodeAL == ElemFlagL(1) || nodeAL == 0
                eL1 = 0;
                xlintL(:,1) = xlL(:,1);
            elseif nodeAL == -1 %no enrichment but DG instead
                xy = xlR(:,2);
                POUxi = POU_Coord(xy(1),xy(2),xlL,1,nelL);
                eL1 = POUxi(1);
                xlintL(:,1) = xy;  
            elseif nelL == 6 && nodeAL == ElemFlagL(4)
                eL1 = 1/2;
            end
            % Lower Limit
            if nodeBL == ElemFlagL(2) || nodeBL == 0
                eL2 = 1;
                xlintL(:,2) = xlL(:,2);
            elseif nodeBL == -1 %no enrichment but DG instead
                xy = xlR(:,1);
                POUxi = POU_Coord(xy(1),xy(2),xlL,1,nelL);
                eL2 = POUxi(1);
                xlintL(:,2) = xy;  
            elseif nelL == 6 && nodeBL == ElemFlagL(4)
                eL2 = 1/2;
            end
            xlintL(:,3) = xlL(:,3);
            
            if truncsectors
            % shorten support for bubble
            lside23 = norm(xlintL(:,2)-xlintL(:,3),2);
            lside13 = norm(xlintL(:,1)-xlintL(:,3),2);
            lside12 = norm(xlintL(:,2)-xlintL(:,1),2);
            shortyn = (lside12 < lside23) && (lside12 < lside13);
            if shortyn && lside13 < lside23
                lintratio = lside12/lside13;
                lintxy1 = (xlintL(:,3)-xlintL(:,1))*lintratio + xlintL(:,1);
                shl = shlt(1-lintratio,lintratio,nelLB,nelLB,0,0);
                lintxy2 = xlintL*shl;
                xlintL(:,3) = (lintxy1 + lintxy2)/2;
            elseif shortyn && lside13 >= lside23
                lintratio = lside12/lside23;
                lintxy1 = (xlintL(:,3)-xlintL(:,2))*lintratio + xlintL(:,2);
                POUxi = POU_Coord(lintxy1(1),lintxy1(2),xlintL,1,nelLB);
                shl = shlt(0,POUxi(2),nelLB,nelLB,0,0);
                lintxy2 = xlintL*shl;
                xlintL(:,3) = (lintxy1 + lintxy2)/2;
            end
            end
        
        end
        