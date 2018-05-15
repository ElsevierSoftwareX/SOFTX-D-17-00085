function [w,s] = intpntp(i,p,ib)

% C-----------------------------------------------------------------------
% C      Purpose: Gauss quadrature for 3-d Pyramid element
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

%    PyraGaussRuleInfo[{rule_,numer_},point_]:= Module[
%  {g1,g2,g3,g4,g5,w1,w2,w3,w4,
 jk=[-1,-1; 1,-1; 1,1; -1,1];
 jk4=[-1,0; 1,0; 0,-1; 0,1];
 jk9=[-1,-1; 0,-1; 1,-1;
      -1,0; 0,0; 1,0; -1,1; 0,1; 1,1];
 wg9=[64,40,25]/81;
 eps=1e-16;
%  info={{Null,Null,Null},0},
%  j,k,m,p=rule,i=point},
 if ib == 0
     
 if p==1
    s=[0,0,-1/2]';
    w=128/27;
 elseif p==5 % for 5 node element K/M matrices
     g1=8*sqrt(2/15)/5;
     if i<5
         j = jk(i,1);
         k = jk(i,2);
         s=[j*g1,k*g1,-2/3];
         w=81/100;
     elseif i==5
         s=[0,0,2/5];
         w=125/27;
     end
     
 elseif p==6
%      g1=Sqrt[12/35];
%      g2={1/6,1/2};
%      w2={576/625,64/15};
%      if [i<5, {j,k}=jk[[i]]; info={{j*g1,k*g1,-2/3},504/625}];
%      elseif [i>4, info={{0,0,g2[[i-4]]},w2[[i-4]]}]];
%      end

 elseif p==8 % for 14 node element K matrix
     g1=sqrt(1/3);
     g2=(2*sqrt(10)-5)/15;
     g3=-2/3-g2;
     w1=5*(68+5*sqrt(10))/432;
     w2=85/54-w1;
     if i<5
         j = jk(i,1);
         k = jk(i,2);
         s=[j*g1,k*g1,g2];
         w=w1;
     elseif i>4
         j = jk(i-4,1);
         k = jk(i-4,2);
         s=[j*g1,k*g1,g3];
         w=w2;
     end
 elseif p==9
%     g1=8*Sqrt[(573+5*Sqrt[2865])/(109825+969*Sqrt[2865])];
%     g2=Sqrt[(2*(8025+Sqrt[2865]))/35]/37;
%     g3=-(87+Sqrt[2865])/168; g4=(-87+Sqrt[2865])/168;
%     w1=7*(11472415-70057*Sqrt[2865])/130739500;w2=84091/68450-w1;
%     if [i<5, {j,k}=jk[[i]]; info={{j*g1,k*g1,g3},w1}];
%     elseif [i>4&&i<9, {j,k}=jk[[i-4]]; info={{j*g2,k*g2,g4},w2}];
%     elseif [i==9, info={{0,0,2/3},18/5}]]; 
%     end
    
 elseif p==13 % for 14 node element mass matrix
%     g1=7*Sqrt[35/59]/8; g2=224*Sqrt[336633710/33088740423]/37;
%     g3=Sqrt[37043/35]/56; g4=-127/153; g5=1490761/2842826;
%     w1=170569/331200; w2=276710106577408/1075923777052725;
%     w3=12827693806929/30577384040000;
%     w4=10663383340655070643544192/4310170528879365193704375;
%     if [i<5, {j,k}=jk[[i]]; info={{j*g1,k*g1,-1/7},w1}];
%     elseif [i>4&&i<9, {j,k}=jk4[[i-4]];info={{j*g2,k*g2,-9/28},w2}];
%     elseif [i>8&&i<13,{j,k}=jk[[i-8]]; info={{j*g3,k*g3,g4},w3}];
%     elseif [i==13, info={{0,0,g5},w4}]];
%     end
    
 elseif p==18
%     g1=Sqrt[3/5]; g2=1-2*(10-Sqrt[10])/15;
%     g3=-2/3-g2; w1=5*(68+5*Sqrt[10])/432; w2=85/54-w1;
%     if [i<10, {j,k}=jk9[[i]]; m=Abs[j]+Abs[k];
%     info={{j*g1,k*g1,g2},w1*wg9[[m+1]] }];
%     elseif [i>9&&i<19, {j,k}=jk9[[i-9]]; m=Abs[j]+Abs[k];
%     info={{j*g1,k*g1,g3},w2*wg9[[m+1]] }]];
%     end
 elseif p==27
%     g1=Sqrt[3/5];
%     g3=-0.854011951853700535688324041975993416;
%     g4=-0.305992467923296230556472913192103090;
%     g5= 0.410004419776996766244796955168096505;
%     if [!numer, {g3,g4,g5}=Rationalize[{g3,g4,g5},eps]];
%     w1=(4/15)*(4+5*(g4+g5)+10*g4*g5)/((g3-g4)*(g3-g5)*(1-g3)^2);
%     w2=(4/15)*(4+5*(g3+g5)+10*g3*g5)/((g3-g4)*(g5-g4)*(1-g4)^2);
%     w3=(4/15)*(4+5*(g3+g4)+10*g3*g4)/((g3-g5)*(g4-g5)*(1-g5)^2);
%     if [i<10, {j,k}=jk9[[i]]; m=Abs[j]+Abs[k];
%     info={{j*g1,k*g1,g3},w1*wg9[[m+1]]}];
%     elseif [i>9&&i<19, {j,k}=jk9[[i-9]]; m=Abs[j]+Abs[k];
%     info={{j*g1,k*g1,g4},w2*wg9[[m+1]]}];
%     elseif [i>18, {j,k}=jk9[[i-18]];m=Abs[j]+Abs[k];
%     info={{j*g1,k*g1,g5},w3*wg9[[m+1]]}]];
%     end
 end

end %if
% 
%       return
% 
%       end