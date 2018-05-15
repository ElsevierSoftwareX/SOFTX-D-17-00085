% Tim Truster
% 10/16/2013
%
% Routine to determine the bounds of integration and other information for
% 3D DG interface elements.
% Uses truncated sector approach from the CMAME paper.

truncsectors = 1;0; % 1 for truncation, 0 for full sectors

        if nelL == 4 || nelL == 10
        xlintL = zeros(3,4);
        nelLB = 4;
        else
        xlintL = zeros(3,6);
        nelLB = 8;
        end
        if nelR == 4 || nelR == 10
        xlintR = zeros(3,4);
        nelRB = 4;
        else
        xlintR = zeros(3,6);
        nelRB = 8;
        end
        
        % Determine bounds of integration, right
        
        if nelRB == 8
            
            xlintR(:,1:3) = xit;
            % Make sure that the nodes on wedge are oriented according to
            % the positive right-hand-rule
            r1 = xlintR(:,2) - xlintR(:,1); %edge n1 -> n2
            r2 = xlintR(:,3) - xlintR(:,1); %edge n1 -> n3
            r3 = VecCrossProd(r1,r2); % normal to triangle plane
            n3 = xlintR(:,1) + r3'; % add normal to a node in the plane
            xi = POU_Coord3(n3(1),n3(2),n3(3),xlR,1,nelR); % find if point lies on inside
            if xi(3) <= -1
                xlintR = xlintR(:,[2 1 3]);
            end
            
            % Form full sector as a wedge - project nodes to opposite face
            % Node 4
            xi = POU_Coord3(xlintR(1,1),xlintR(2,1),xlintR(3,1),xlR,1,nelR);
            xi(3) = 1;
            shlR = shlb(xi,nelR,nelR,0,0);
            xlintR(:,4) = xlR*shlR;
            % Node 5
            xi = POU_Coord3(xlintR(1,2),xlintR(2,2),xlintR(3,2),xlR,1,nelR);
            xi(3) = 1;
            shlR = shlb(xi,nelR,nelR,0,0);
            xlintR(:,5) = xlR*shlR;
            % Node 6
            xi = POU_Coord3(xlintR(1,3),xlintR(2,3),xlintR(3,3),xlR,1,nelR);
            xi(3) = 1;
            shlR = shlb(xi,nelR,nelR,0,0);
            xlintR(:,6) = xlR*shlR;
            
            if truncsectors
                
                xlintRtot = xlintR;
                %step 1 - see CMAME Truster and Masud page 18
                lside12 = norm(xlintR(:,1)-xlintR(:,2),2);
                lside23 = norm(xlintR(:,2)-xlintR(:,3),2);
                lside31 = norm(xlintR(:,3)-xlintR(:,1),2);
                lside41 = norm(xlintR(:,4)-xlintR(:,1),2);
                lside52 = norm(xlintR(:,5)-xlintR(:,2),2);
                lside63 = norm(xlintR(:,6)-xlintR(:,3),2);
                %step 2
                lsideb = max([lside12,lside23,lside31]);
                lsidedc = min([lside41,lside52,lside63]);
                shortyn = lsideb < lsidedc;
                
                % shorten support for bubble
                if shortyn
                    lintratio = lsideb/lsidedc;
                    if shortyn && abs(lside41 - lsidedc)<1e-14
                        sided = 4; sidec = 1;
                    elseif shortyn && abs(lside52 - lsidedc)<1e-14
                        sided = 5; sidec = 2;
                    elseif shortyn && abs(lside63 - lsidedc)<1e-14
                        sided = 6; sidec = 3;
                    end
                    %step 3
                    zbar = (xlintR(:,sided)-xlintR(:,sidec))*lintratio + xlintR(:,sidec);
                    %step 4
                    POUxi = POU_Coord3(zbar(1),zbar(2),zbar(3),xlintR,0,6);
                    %step 5
                    % Node 4
                    shl = shlw([0 0 POUxi(3)],6,6,0,0);
                    xlintR(:,4) = xlintRtot*shl;
                    % Node 5
                    shl = shlw([1 0 POUxi(3)],6,6,0,0);
                    xlintR(:,5) = xlintRtot*shl;
                    % Node 6
                    shl = shlw([0 1 POUxi(3)],6,6,0,0);
                    xlintR(:,6) = xlintRtot*shl;
                end
            
            end
            
        elseif nelRB == 4
            
            error('tetrahedral sectors not coded')
        
        end
        
        % Determine bounds of integration, left
        
        if nelLB == 8
            
            xlintL(:,1:3) = xit;
            % Make sure that the nodes on wedge are oriented according to
            % the positive right-hand-rule
            r1 = xlintL(:,2) - xlintL(:,1); %edge n1 -> n2
            r2 = xlintL(:,3) - xlintL(:,1); %edge n1 -> n3
            r3 = VecCrossProd(r1,r2); % normal to triangle plane
            n3 = xlintL(:,1) + r3'; % add normal to a node in the plane
            xi = POU_Coord3(n3(1),n3(2),n3(3),xlL,1,nelL); % find if point lies on inside
            if xi(3) <= -1
                xlintL = xlintL(:,[2 1 3]);
            end
            
            % Form full sector as a wedge - project nodes to opposite face
            % Node 4
            xi = POU_Coord3(xlintL(1,1),xlintL(2,1),xlintL(3,1),xlL,1,nelL);
            xi(3) = 1;
            shlL = shlb(xi,nelL,nelL,0,0);
            xlintL(:,4) = xlL*shlL;
            % Node 5
            xi = POU_Coord3(xlintL(1,2),xlintL(2,2),xlintL(3,2),xlL,1,nelL);
            xi(3) = 1;
            shlL = shlb(xi,nelL,nelL,0,0);
            xlintL(:,5) = xlL*shlL;
            % Node 6
            xi = POU_Coord3(xlintL(1,3),xlintL(2,3),xlintL(3,3),xlL,1,nelL);
            xi(3) = 1;
            shlL = shlb(xi,nelL,nelL,0,0);
            xlintL(:,6) = xlL*shlL;
            
            if truncsectors
                
                xlintLtot = xlintL;
                %step 1 - see CMAME Truster and Masud page 18
                lside12 = norm(xlintL(:,1)-xlintL(:,2),2);
                lside23 = norm(xlintL(:,2)-xlintL(:,3),2);
                lside31 = norm(xlintL(:,3)-xlintL(:,1),2);
                lside41 = norm(xlintL(:,4)-xlintL(:,1),2);
                lside52 = norm(xlintL(:,5)-xlintL(:,2),2);
                lside63 = norm(xlintL(:,6)-xlintL(:,3),2);
                %step 2
                lsideb = max([lside12,lside23,lside31]);
                lsidedc = min([lside41,lside52,lside63]);
                shortyn = lsideb < lsidedc;
                
                % shorten support for bubble
                if shortyn
                    lintratio = lsideb/lsidedc;
                    if shortyn && abs(lside41 - lsidedc)<1e-14
                        sided = 4; sidec = 1;
                    elseif shortyn && abs(lside52 - lsidedc)<1e-14
                        sided = 5; sidec = 2;
                    elseif shortyn && abs(lside63 - lsidedc)<1e-14
                        sided = 6; sidec = 3;
                    end
                    %step 3
                    zbar = (xlintL(:,sided)-xlintL(:,sidec))*lintratio + xlintL(:,sidec);
                    %step 4
                    POUxi = POU_Coord3(zbar(1),zbar(2),zbar(3),xlintL,0,6);
                    %step 5
                    % Node 4
                    shl = shlw([0 0 POUxi(3)],6,6,0,0);
                    xlintL(:,4) = xlintLtot*shl;
                    % Node 5
                    shl = shlw([1 0 POUxi(3)],6,6,0,0);
                    xlintL(:,5) = xlintLtot*shl;
                    % Node 6
                    shl = shlw([0 1 POUxi(3)],6,6,0,0);
                    xlintL(:,6) = xlintLtot*shl;
                end
            
            end
        
        elseif nelLB == 4
            
            error('tetrahedral sectors not coded')
        
        end
        