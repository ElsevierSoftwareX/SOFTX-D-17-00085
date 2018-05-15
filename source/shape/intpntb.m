function [w,s] = intpntb(l,lint,ib)

% C-----------------------------------------------------------------------
% C      Purpose: Gauss quadrature for 3-d Brick element
% C      Inputs:
% C         ll     - Number of points/direction
% C      Outputs:
% C         lint   - Total number of quadrature points
% C         s(4,*) - Gauss points (1-3) and weights (4)
% C-----------------------------------------------------------------------
%       implicit  none
% 
%       integer   ll,lint, i,j,k,n
%       real*8    s(4,125),gauss(10),weight(10)
   s = zeros(3,1);
   gauss = zeros(10,1);
   weight = zeros(10,1);

   if ib == 0
   
% c     1 pt. quadrature
      if(lint==1)
        for i = 1:3
          s(i,1) = 0.d0;
        end % i
        w = 8.0d0;

% c     2 x 2 x 2 pt. quadrature
      elseif(lint==8)
        l1 = 2;
        gauss(1)  =-0.577350269189626D0;
        gauss(2)  = 0.577350269189626D0;
        weight(1) = 1.D0;
        weight(2) = 1.D0;
        i = ceil(l/l1^2);
        l = (l-(i-1)*l1^2);
        j = ceil(l/l1);
        k = (l-(j-1)*l1);
        s(1)=gauss(k);
        s(2)=gauss(j);
        s(3)=gauss(i);
        w=weight(i)*weight(j)*weight(k);

% c        for 3*3*3 pts quadrature
      elseif(lint==27)
        l1 = 3;
        gauss(1)  =-0.774596669241483d0;
        gauss(2)  = 0.d0;
        gauss(3)  = 0.774596669241483d0;
        weight(1) = 0.555555555555556d0;
        weight(2) = 0.888888888888889d0;
        weight(3) = 0.555555555555556d0;
        i = ceil(l/l1^2);
        l = (l-(i-1)*l1^2);
        j = ceil(l/l1);
        k = (l-(j-1)*l1);
        s(1)=gauss(k);
        s(2)=gauss(j);
        s(3)=gauss(i);
        w=weight(i)*weight(j)*weight(k);

% c        for 4*4*4 pts quadrature
      elseif(lint==64)
        l1 = 4;
        gauss(1)  =-0.861136311594953d0;
        gauss(2)  =-0.339981043584856d0;
        gauss(3)  = 0.339981043584856d0;
        gauss(4)  = 0.861136311594953d0;
        weight(1) = 0.347854845137454d0;
        weight(2) = 0.652145154862546d0;
        weight(3) = 0.652145154862546d0;
        weight(4) = 0.347854845137454d0;
        i = ceil(l/l1^2);
        l = (l-(i-1)*l1^2);
        j = ceil(l/l1);
        k = (l-(j-1)*l1);
        s(1)=gauss(k);
        s(2)=gauss(j);
        s(3)=gauss(i);
        w=weight(i)*weight(j)*weight(k);

% c      For 5*5*5 pts quadrature
       elseif(lint==125)
        l1 = 5;
        gauss(1)  =-0.906179845938664d0;
        gauss(2)  =-0.538469310105683d0;
        gauss(3)  = 0.d0;
        gauss(4)  =+0.538469310105683d0;
        gauss(5)  =+0.906179845938664d0;
        weight(1) = 0.236926885056189d0;
        weight(2) = 0.478628670449366d0;
        weight(3) = 0.568888888888889d0;
        weight(4) = 0.478628670449366d0;
        weight(5) = 0.236926885056189d0;
        i = ceil(l/l1^2);
        l = (l-(i-1)*l1^2);
        j = ceil(l/l1);
        k = (l-(j-1)*l1);
        s(1)=gauss(k);
        s(2)=gauss(j);
        s(3)=gauss(i);
        w=weight(i)*weight(j)*weight(k);

% c      For 10*10*10 pts quadrature
       elseif(lint==1000)
        l1 = 10;

        gauss(1)  = -0.973906528517172;
        gauss(2)  = -0.865063366688985;
        gauss(3)  = -0.679409568299024;
        gauss(4)  = -0.433395394129247;
        gauss(5)  = -0.148874338981631;
        gauss(6)  =  0.148874338981631;
        gauss(7)  =  0.433395394129247;
        gauss(8)  =  0.679409568299024;
        gauss(9)  =  0.865063366688985;
        gauss(10) =  0.973906528517172;

        weight(1) = 0.0666713443086881;
        weight(2) = 0.149451349150581;
        weight(3) = 0.219086362515982;
        weight(4) = 0.269266719309996;
        weight(5) = 0.295524224714753;
        weight(6) = 0.295524224714753;
        weight(7) = 0.269266719309996;
        weight(8) = 0.219086362515982;
        weight(9) = 0.149451349150581;
        weight(10)= 0.0666713443086881;

        i = ceil(l/l1^2);
        l = (l-(i-1)*l1^2);
        j = ceil(l/l1);
        k = (l-(j-1)*l1);
        s(1)=gauss(k);
        s(2)=gauss(j);
        s(3)=gauss(i);
        w=weight(i)*weight(j)*weight(k);
        
      end

      elseif ib == 1

% c     2 x 2 pt. quadrature
      if(lint==4)
        l1 = 2;
        gauss(1)  =-0.577350269189626D0;
        gauss(2)  = 0.577350269189626D0;
        weight(1) = 1.D0;
        weight(2) = 1.D0;
        j = ceil(l/l1);
        k = (l-(j-1)*l1);
        s(1)=-1.d0;
        s(2)=gauss(k);
        s(3)=gauss(j);
        w=weight(j)*weight(k);
          
% c        for 3*3 pts quadrature
      elseif(lint==9)
        l1 = 3;
        gauss(1)  =-0.774596669241483d0;
        gauss(2)  = 0.d0;
        gauss(3)  = 0.774596669241483d0;
        weight(1) = 0.555555555555556d0;
        weight(2) = 0.888888888888889d0;
        weight(3) = 0.555555555555556d0;
        j = ceil(l/l1);
        k = (l-(j-1)*l1);
        s(1)=-1.d0;
        s(2)=gauss(k);
        s(3)=gauss(j);
        w=weight(j)*weight(k);
% c
% c	4x4 integration.
% c	----------------
        elseif lint == 16
        l1 = 4;
        gauss(1)  =-0.861136311594953d0;
        gauss(2)  =-0.339981043584856d0;
        gauss(3)  = 0.339981043584856d0;
        gauss(4)  = 0.861136311594953d0;
        weight(1) = 0.347854845137454d0;
        weight(2) = 0.652145154862546d0;
        weight(3) = 0.652145154862546d0;
        weight(4) = 0.347854845137454d0;
        j = ceil(l/l1);
        k = (l-(j-1)*l1);
        s(1)=-1.d0;
        s(2)=gauss(k);
        s(3)=gauss(j);
        w=weight(j)*weight(k);
        
% c      For 5*5*5 pts quadrature
       elseif(lint==25)
        l1 = 5;
        gauss(1)  =-0.906179845938664d0;
        gauss(2)  =-0.538469310105683d0;
        gauss(3)  = 0.d0;
        gauss(4)  =+0.538469310105683d0;
        gauss(5)  =+0.906179845938664d0;
        weight(1) = 0.236926885056189d0;
        weight(2) = 0.478628670449366d0;
        weight(3) = 0.568888888888889d0;
        weight(4) = 0.478628670449366d0;
        weight(5) = 0.236926885056189d0;
        j = ceil(l/l1);
        k = (l-(j-1)*l1);
        s(1)=-1.d0;
        s(2)=gauss(k);
        s(3)=gauss(j);
        w=weight(j)*weight(k);
        
        end
  

      elseif ib == 2

% c     2 x 2 pt. quadrature
      if(lint==4)
        l1 = 2;
        gauss(1)  =-0.577350269189626D0;
        gauss(2)  = 0.577350269189626D0;
        weight(1) = 1.D0;
        weight(2) = 1.D0;
        j = ceil(l/l1);
        k = (l-(j-1)*l1);
        s(1)=1.d0;
        s(2)=gauss(k);
        s(3)=gauss(j);
        w=weight(j)*weight(k);
          
% c        for 3*3 pts quadrature
      elseif(lint==9)
        l1 = 3;
        gauss(1)  =-0.774596669241483d0;
        gauss(2)  = 0.d0;
        gauss(3)  = 0.774596669241483d0;
        weight(1) = 0.555555555555556d0;
        weight(2) = 0.888888888888889d0;
        weight(3) = 0.555555555555556d0;
        j = ceil(l/l1);
        k = (l-(j-1)*l1);
        s(1)=1.d0;
        s(2)=gauss(k);
        s(3)=gauss(j);
        w=weight(j)*weight(k);
% c
% c	4x4 integration.
% c	----------------
        elseif lint == 16
        l1 = 4;
        gauss(1)  =-0.861136311594953d0;
        gauss(2)  =-0.339981043584856d0;
        gauss(3)  = 0.339981043584856d0;
        gauss(4)  = 0.861136311594953d0;
        weight(1) = 0.347854845137454d0;
        weight(2) = 0.652145154862546d0;
        weight(3) = 0.652145154862546d0;
        weight(4) = 0.347854845137454d0;
        j = ceil(l/l1);
        k = (l-(j-1)*l1);
        s(1)=1.d0;
        s(2)=gauss(k);
        s(3)=gauss(j);
        w=weight(j)*weight(k);
        
% c      For 5*5*5 pts quadrature
       elseif(lint==25)
        l1 = 5;
        gauss(1)  =-0.906179845938664d0;
        gauss(2)  =-0.538469310105683d0;
        gauss(3)  = 0.d0;
        gauss(4)  =+0.538469310105683d0;
        gauss(5)  =+0.906179845938664d0;
        weight(1) = 0.236926885056189d0;
        weight(2) = 0.478628670449366d0;
        weight(3) = 0.568888888888889d0;
        weight(4) = 0.478628670449366d0;
        weight(5) = 0.236926885056189d0;
        j = ceil(l/l1);
        k = (l-(j-1)*l1);
        s(1)=1.d0;
        s(2)=gauss(k);
        s(3)=gauss(j);
        w=weight(j)*weight(k);
        
      end
  

      elseif ib == 3

% c     2 x 2 pt. quadrature
      if(lint==4)
        l1 = 2;
        gauss(1)  =-0.577350269189626D0;
        gauss(2)  = 0.577350269189626D0;
        weight(1) = 1.D0;
        weight(2) = 1.D0;
        j = ceil(l/l1);
        k = (l-(j-1)*l1);
        s(1)=gauss(k);
        s(2)=-1.d0;
        s(3)=gauss(j);
        w=weight(j)*weight(k);
          
% c        for 3*3 pts quadrature
      elseif(lint==9)
        l1 = 3;
        gauss(1)  =-0.774596669241483d0;
        gauss(2)  = 0.d0;
        gauss(3)  = 0.774596669241483d0;
        weight(1) = 0.555555555555556d0;
        weight(2) = 0.888888888888889d0;
        weight(3) = 0.555555555555556d0;
        j = ceil(l/l1);
        k = (l-(j-1)*l1);
        s(1)=gauss(k);
        s(2)=-1.d0;
        s(3)=gauss(j);
        w=weight(j)*weight(k);
% c
% c	4x4 integration.
% c	----------------
        elseif lint == 16
        l1 = 4;
        gauss(1)  =-0.861136311594953d0;
        gauss(2)  =-0.339981043584856d0;
        gauss(3)  = 0.339981043584856d0;
        gauss(4)  = 0.861136311594953d0;
        weight(1) = 0.347854845137454d0;
        weight(2) = 0.652145154862546d0;
        weight(3) = 0.652145154862546d0;
        weight(4) = 0.347854845137454d0;
        j = ceil(l/l1);
        k = (l-(j-1)*l1);
        s(1)=gauss(k);
        s(2)=-1.d0;
        s(3)=gauss(j);
        w=weight(j)*weight(k);
        
% c      For 5*5*5 pts quadrature
       elseif(lint==25)
        l1 = 5;
        gauss(1)  =-0.906179845938664d0;
        gauss(2)  =-0.538469310105683d0;
        gauss(3)  = 0.d0;
        gauss(4)  =+0.538469310105683d0;
        gauss(5)  =+0.906179845938664d0;
        weight(1) = 0.236926885056189d0;
        weight(2) = 0.478628670449366d0;
        weight(3) = 0.568888888888889d0;
        weight(4) = 0.478628670449366d0;
        weight(5) = 0.236926885056189d0;
        j = ceil(l/l1);
        k = (l-(j-1)*l1);
        s(1)=gauss(k);
        s(2)=-1.d0;
        s(3)=gauss(j);
        w=weight(j)*weight(k);
        
      end
  

      elseif ib == 4

% c     2 x 2 pt. quadrature
      if(lint==4)
        l1 = 2;
        gauss(1)  =-0.577350269189626D0;
        gauss(2)  = 0.577350269189626D0;
        weight(1) = 1.D0;
        weight(2) = 1.D0;
        j = ceil(l/l1);
        k = (l-(j-1)*l1);
        s(1)=gauss(k);
        s(2)=1.d0;
        s(3)=gauss(j);
        w=weight(j)*weight(k);
          
% c        for 3*3 pts quadrature
      elseif(lint==9)
        l1 = 3;
        gauss(1)  =-0.774596669241483d0;
        gauss(2)  = 0.d0;
        gauss(3)  = 0.774596669241483d0;
        weight(1) = 0.555555555555556d0;
        weight(2) = 0.888888888888889d0;
        weight(3) = 0.555555555555556d0;
        j = ceil(l/l1);
        k = (l-(j-1)*l1);
        s(1)=gauss(k);
        s(2)=1.d0;
        s(3)=gauss(j);
        w=weight(j)*weight(k);
% c
% c	4x4 integration.
% c	----------------
        elseif lint == 16
        l1 = 4;
        gauss(1)  =-0.861136311594953d0;
        gauss(2)  =-0.339981043584856d0;
        gauss(3)  = 0.339981043584856d0;
        gauss(4)  = 0.861136311594953d0;
        weight(1) = 0.347854845137454d0;
        weight(2) = 0.652145154862546d0;
        weight(3) = 0.652145154862546d0;
        weight(4) = 0.347854845137454d0;
        j = ceil(l/l1);
        k = (l-(j-1)*l1);
        s(1)=gauss(k);
        s(2)=1.d0;
        s(3)=gauss(j);
        w=weight(j)*weight(k);
        
% c      For 5*5*5 pts quadrature
       elseif(lint==25)
        l1 = 5;
        gauss(1)  =-0.906179845938664d0;
        gauss(2)  =-0.538469310105683d0;
        gauss(3)  = 0.d0;
        gauss(4)  =+0.538469310105683d0;
        gauss(5)  =+0.906179845938664d0;
        weight(1) = 0.236926885056189d0;
        weight(2) = 0.478628670449366d0;
        weight(3) = 0.568888888888889d0;
        weight(4) = 0.478628670449366d0;
        weight(5) = 0.236926885056189d0;
        j = ceil(l/l1);
        k = (l-(j-1)*l1);
        s(1)=gauss(k);
        s(2)=1.d0;
        s(3)=gauss(j);
        w=weight(j)*weight(k);
        
      end
  

      elseif ib == 5

% c     2 x 2 pt. quadrature
      if(lint==4)
        l1 = 2;
        gauss(1)  =-0.577350269189626D0;
        gauss(2)  = 0.577350269189626D0;
        weight(1) = 1.D0;
        weight(2) = 1.D0;
        j = ceil(l/l1);
        k = (l-(j-1)*l1);
        s(1)=gauss(k);
        s(2)=gauss(j);
        s(3)=-1.d0;
        w=weight(j)*weight(k);
          
% c        for 3*3 pts quadrature
      elseif(lint==9)
        l1 = 3;
        gauss(1)  =-0.774596669241483d0;
        gauss(2)  = 0.d0;
        gauss(3)  = 0.774596669241483d0;
        weight(1) = 0.555555555555556d0;
        weight(2) = 0.888888888888889d0;
        weight(3) = 0.555555555555556d0;
        j = ceil(l/l1);
        k = (l-(j-1)*l1);
        s(1)=gauss(k);
        s(2)=gauss(j);
        s(3)=-1.d0;
        w=weight(j)*weight(k);
% c
% c	4x4 integration.
% c	----------------
        elseif lint == 16
        l1 = 4;
        gauss(1)  =-0.861136311594953d0;
        gauss(2)  =-0.339981043584856d0;
        gauss(3)  = 0.339981043584856d0;
        gauss(4)  = 0.861136311594953d0;
        weight(1) = 0.347854845137454d0;
        weight(2) = 0.652145154862546d0;
        weight(3) = 0.652145154862546d0;
        weight(4) = 0.347854845137454d0;
        j = ceil(l/l1);
        k = (l-(j-1)*l1);
        s(1)=gauss(k);
        s(2)=gauss(j);
        s(3)=-1.d0;
        w=weight(j)*weight(k);
        
% c      For 5*5*5 pts quadrature
       elseif(lint==25)
        l1 = 5;
        gauss(1)  =-0.906179845938664d0;
        gauss(2)  =-0.538469310105683d0;
        gauss(3)  = 0.d0;
        gauss(4)  =+0.538469310105683d0;
        gauss(5)  =+0.906179845938664d0;
        weight(1) = 0.236926885056189d0;
        weight(2) = 0.478628670449366d0;
        weight(3) = 0.568888888888889d0;
        weight(4) = 0.478628670449366d0;
        weight(5) = 0.236926885056189d0;
        j = ceil(l/l1);
        k = (l-(j-1)*l1);
        s(1)=gauss(k);
        s(2)=gauss(j);
        s(3)=-1.d0;
        w=weight(j)*weight(k);

% c      For 10*10 pts quadrature
       elseif(lint==100)
        l1 = 10;
        gauss(1)  = -0.973906528517172;
        gauss(2)  = -0.865063366688985;
        gauss(3)  = -0.679409568299024;
        gauss(4)  = -0.433395394129247;
        gauss(5)  = -0.148874338981631;
        gauss(6)  =  0.148874338981631;
        gauss(7)  =  0.433395394129247;
        gauss(8)  =  0.679409568299024;
        gauss(9)  =  0.865063366688985;
        gauss(10) =  0.973906528517172;

        weight(1) = 0.0666713443086881;
        weight(2) = 0.149451349150581;
        weight(3) = 0.219086362515982;
        weight(4) = 0.269266719309996;
        weight(5) = 0.295524224714753;
        weight(6) = 0.295524224714753;
        weight(7) = 0.269266719309996;
        weight(8) = 0.219086362515982;
        weight(9) = 0.149451349150581;
        weight(10)= 0.0666713443086881;
        j = ceil(l/l1);
        k = (l-(j-1)*l1);
        s(1)=gauss(k);
        s(2)=gauss(j);
        s(3)=-1.d0;
        w=weight(j)*weight(k);

      end
      
      elseif ib == 6

% c     2 x 2 pt. quadrature
      if(lint==4)
        l1 = 2;
        gauss(1)  =-0.577350269189626D0;
        gauss(2)  = 0.577350269189626D0;
        weight(1) = 1.D0;
        weight(2) = 1.D0;
        j = ceil(l/l1);
        k = (l-(j-1)*l1);
        s(1)=gauss(k);
        s(2)=gauss(j);
        s(3)=1.d0;
        w=weight(j)*weight(k);
          
% c        for 3*3 pts quadrature
      elseif(lint==9)
        l1 = 3;
        gauss(1)  =-0.774596669241483d0;
        gauss(2)  = 0.d0;
        gauss(3)  = 0.774596669241483d0;
        weight(1) = 0.555555555555556d0;
        weight(2) = 0.888888888888889d0;
        weight(3) = 0.555555555555556d0;
        j = ceil(l/l1);
        k = (l-(j-1)*l1);
        s(1)=gauss(k);
        s(2)=gauss(j);
        s(3)=1.d0;
        w=weight(j)*weight(k);
% c
% c	4x4 integration.
% c	----------------
        elseif lint == 16
        l1 = 4;
        gauss(1)  =-0.861136311594953d0;
        gauss(2)  =-0.339981043584856d0;
        gauss(3)  = 0.339981043584856d0;
        gauss(4)  = 0.861136311594953d0;
        weight(1) = 0.347854845137454d0;
        weight(2) = 0.652145154862546d0;
        weight(3) = 0.652145154862546d0;
        weight(4) = 0.347854845137454d0;
        j = ceil(l/l1);
        k = (l-(j-1)*l1);
        s(1)=gauss(k);
        s(2)=gauss(j);
        s(3)=1.d0;
        w=weight(j)*weight(k);
        
% c      For 5*5*5 pts quadrature
       elseif(lint==25)
        l1 = 5;
        gauss(1)  =-0.906179845938664d0;
        gauss(2)  =-0.538469310105683d0;
        gauss(3)  = 0.d0;
        gauss(4)  =+0.538469310105683d0;
        gauss(5)  =+0.906179845938664d0;
        weight(1) = 0.236926885056189d0;
        weight(2) = 0.478628670449366d0;
        weight(3) = 0.568888888888889d0;
        weight(4) = 0.478628670449366d0;
        weight(5) = 0.236926885056189d0;
        j = ceil(l/l1);
        k = (l-(j-1)*l1);
        s(1)=gauss(k);
        s(2)=gauss(j);
        s(3)=1.d0;
        w=weight(j)*weight(k);
        
      end

   end %if
% 
%       return
% 
%       end