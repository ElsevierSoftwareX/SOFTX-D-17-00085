function [itemo,indo,imatch] = binsearch(itemi,list,lowin,len)
%
%...  Written by Tim Truster (Fall 2009)
%     No modifications when copied to NLFEA ver2
%...  Program to find entry in integer array, numerically sorted
%     Returns imatch = .true. if itemi is in list
%     Returns indo = index of list entry that is <= itemi
%     Returns itemo = entry in list <= itemi
%
%**********************************************************************

%       implicit none
% 
% %     Input Variables
%       integer itemi,len,lowin
% 	integer list(len)
% 
% %     Output Variables
% 	integer itemo,indo
% 	logical imatch
% 
% %     Local Variables
%       integer low,high,mid
% 	logical ifound

    if(len==0)
	    imatch = 0;
	    itemo = itemi;
	    indo = len;
        return
    end

	if(itemi>=list(len))
	   if(itemi>list(len))
	      imatch = 0;
	      itemo = list(len);
	      indo = len;
	   else
	      imatch = 1;
	      itemo = list(len);
	      indo = len;
	   end
      elseif(itemi<list(lowin))
	   imatch = 0;
	   itemo = list(lowin);
	   indo = lowin-1;
	else
         low = lowin;
         high = len;
         mid = floor((low+high)/2);
	   ifound = 0;
	   imatch = 0;
       while(ifound==0)
         if(itemi==list(mid))
	         ifound = 1;
	         imatch = 1;
	      elseif(high-low>1)
             if (itemi<list(mid))
	            high = mid;
	         else
	            low = mid;
             end
	         mid = floor((low+high)/2);
	      else
	         ifound = 1;
          end
       end
         itemo = list(mid);
	   indo = mid;
	end
