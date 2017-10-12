%# 20150409
%1) plot boxplot IWPcl_L0 0-30 Real-Outputs
%2) plot scatter IWPcl_L0(real(i),output(j)

%///////////////////////////////////////////
%1. 1D SCAN TRAINING TARGET AND OUTPUT
%///////////////////////////////////////////
%# 20150511
ONED_Training_TargetOutput


%///////////////////////////////////////////
%2. boxplot diff targets-outputs overall
%///////////////////////////////////////////
%--- 0) stats
IWPdiff = IWPcl-Y;

[IWP_T,Isorted] = sort(IWPdiff);

meanIWPdiff = IWP_T(floor(end/2));
avgIWPdiff  = mean(IWP_T);
Q1          = IWP_T(floor(end/4));
Q4          = IWP_T(floor(end*0.75));

%--- 1) box plot diffs realtargets - outputs IWPcl_L0
figure(11)
boxplot(IWPdiff)

title({['Boxplot overall Targets - Outputs. Nb pts=' sprintf('%i',numel(Y))]; ...
       ['mean Target-Output=', sprintf('%5.1f',meanIWPdiff)]; ...
       ['avg Target-Output=', sprintf('%5.1f',avgIWPdiff)]; ...
       ['25th percentile=', sprintf('%5.1f',Q1)]; ...
       ['75th percentile=', sprintf('%5.1f',Q4)]})

Alphastr = ['_' sprintf('%03i',Outshift1*100) sprintf('%03i',Outshift2*100) ]

print('-dpng', '-r1000', ['STATS_1D_DIFF'  trainFcn '_' sprintf('%i',NBcla) 'cl_' DIVIDER sprintf('%i',round(divid*100)) 'E-2' Alphastr ])
clear figure

%///////////////////////////////////////////////////
%3. 20150511 make groups IWPcl 0-NBcla-1
%///////////////////////////////////////////////////
%31cl -> 6 groups for targets and outputs  
BigN = numel(IWPcl)
%pause
IWPclgpsTar=-1*ones(BigN,1);
IWPclgpsOut=-1*ones(BigN,1);
if NBcla>8
%   IWPgpsref = [0 2000 4000 6000 10000 40000];
    IWPgpsref = [0 1000 5000 40000];
else
%# 20150521 go basck to 0-1-5-40
%   IWPgpsref = [0 2000 4000 6000 40000];
   IWPgpsref = [0 1000 5000 40000];
    %# 20150526 use 4 IWPgps
   %IWPgpsref = [0 1E3 4E3 8E3 4E4];
%# 20150513
%   IWPgpsref = [0 1.7E3 6.4E3 40000];
%# 20150519
%   IWPgpsref = [0 1.7E3 3E3 4.5E3 6.4E3 40000];
end
%%% attention : IWPcl and Y are classes in 0:NBcla
%% use threshvect to make conversion classes to IWP (kg)

%-- group IWPclTar ---
%%NB : IWPcl & Y : 1xN
%%     IWPclgpsTar & IWPclgpsOut : Nx1
INDiter=1;
for GP=1:numel(IWPgpsref)-1 
    currentIWPgpTar = find(IWPgpsref(GP)<=threshvect(IWPcl+1) & IWPgpsref(GP+1)>threshvect(IWPcl+1));
    currentIWPgpOut = find(IWPgpsref(GP)<=threshvect(Y+1)     & IWPgpsref(GP+1)>threshvect(Y+1));
    currentN = numel(currentIWPgpOut);
    whos currentIWPgpTar
    whos currentIWPgpOut
    whos IWPcl
    whos Y
    whos IWPclgpsTar
    whos IWPclgpsOut
%pause
%   IWPclgpsTar(INDiter + currentN) = IWPcl(currentIWPgpTar);
%   IWPclgpsOut(INDiter + currentN) = Y(currentIWPgpOut);
    IWPclgpsTar(currentIWPgpTar)=GP-1;
    IWPclgpsOut(currentIWPgpOut)=GP-1;
    INDiter = INDiter + currentN;
    clear currentN currentIWPgpOut currentIWPgpTar
end
IWPclgpsTar(1:100)
IWPclgpsOut(1:100)
%pause


%////////////////////////////////
%#5. 20150520 do both --> LOOP
%////////////////////////////////
BOXHIST_list = {'BOX','HIST'}
%%%
for BH=1:2
%%%

%///////////////////////////////////////////////////
%4. 20150507 boxplot diff targets-outputs per IWPcl 0-NBcla-1
%///////////////////////////////////////////////////
figure(12)
clf
CLSstep = 0:NBcla-1
if NBcla>10
    CLSstep=5
end


%%%
for CLS =0:numel(IWPgpsref)-2
%%%
%   CLSb = CLS*CLSstep; 
%   IWPset = find(IWPcl==CLSb)
%   thisIWPdiff=IWPcl(IWPset)-Y(IWPset);
    %# 20150511
    IWPset = find(IWPclgpsTar==CLS)
    thisIWPdiff=IWPclgpsTar(IWPset)-IWPclgpsOut(IWPset); 

if CLS==1
    disp('IWPclgpsTar(IWPset)')
    IWPclgpsTar(IWPset(1:100))
    disp('IWPclgpsOut(IWPset)')
    IWPclgpsOut(IWPset(1:100))
    disp('thisIWPdiff')
    thisIWPdiff(1:100)
    %pause
end

    [IWP_T,Isorted] = sort(thisIWPdiff);
%    meanIWPdiff=round(10*IWP_T(floor(end/2))/1)/10;
%    Q1=round(10*IWP_T(floor(end/4))/1)/10;
%    Q4=round(10*IWP_T(floor(end*0.75))/1)/10;
     numel(thisIWPdiff)
     max(max(thisIWPdiff))
     min(min(thisIWPdiff))
     CLS
     whos IWPset
     whos IWP_T
  
     medianIWPdiff = IWP_T(floor(end/2));
     avgIWPdiff = mean(IWP_T);
     Q1 = IWP_T(floor(end/4));
     Q4 = IWP_T(floor(end*0.75)); 

    subplot(2,3,CLS+1)
%# 20150511 replace boxplot by hist for testing

%////////////////////////////////
%#5. 20150520 do both --> LOOP
%////////////////////////////////
BOXHIST_list = {'BOX','HIST'}
%%%
%for BH=1:2
%%%
%%plottype='BOX';%'HIST'

plottype=BOXHIST_list{BH}
switch plottype
    case 'BOX'
    boxplot(thisIWPdiff); hold on
    ylim([-6 6])
    case 'HIST' 
    HH=hist(thisIWPdiff); hold on
    ylim([0 numel(IWPset)])
end
%   ylim([-1*NBcla NBcla])
%   ylim([-6 6])
%   xlabel(sprintf('%i',CLS+1))  
    %% set IWP intervals
    xlabel([ sprintf('%i',IWPgpsref(CLS+1)) '-' sprintf('%i',IWPgpsref(CLS+2)) 'kg.m-2' ])
    BOXstr='';
    if CLS==1
        BOXstr='Boxplot overall Targets - Outputs per Target';
    end
    title({[BOXstr ' Nb pts=' sprintf('%i',numel(IWPset))]; ...
       ['mean Target-Output=', sprintf('%5.1f',medianIWPdiff)]; ...
       ['avg Target-Output=', sprintf('%5.1f',avgIWPdiff)]; ...
       ['25th percentile=', sprintf('%5.1f',Q1)]; ...
       ['75th percentile=', sprintf('%5.1f',Q4)]})    

    clear thisIWPdiff IWPset Q1 Q4 meanIWPdiff IWP_T Isorted
%%%
end %for CLS
%%%

 NBgps=numel(IWPgpsref)-1;
 print('-dpng', '-r1000', [ plottype 'plot_diffs_perIWP'  trainFcn '_' sprintf('%i',NBcla) 'cl_' sprintf('%i',NBgps) 'gps'  DIVIDER sprintf('%i',round(divid*100)) 'E-2' Alphastr ])
clear figure

%%%
end %for BH
%%%


%///////////////////////////////////////////////////////////////
%5. test #pts Y>20 ;#IWPcl>20 and display on figure scatter plot
%//////////////////////////////////////////////////////////////
BIWP1=find(IWPcl>25)
BIWP2=find(Y>25)
N1=numel(BIWP1) %123
N2=numel(BIWP2) %0

%//////////////////////////////////////////////
%6. scatter plot density colors
%//////////////////////////////////////////////
%%http://stackoverflow.com/questions/21006490/scatter-plot-with-density-in-matlab
figure(10)
currentMap=colormap(jet);
currentMap(1,:)=[1 1 1]; %necessaire!
colormap(currentMap);

whos IWPcl
whos Y
values = hist3([Y',IWPcl'] , {0:1:NBcla 0:1:NBcla} );
imagesc(log10(values)); hold on
%# 20150416 back to linear scale
%%imagesc(values); hold on
ylabel('IWPcls OUTPUTS')
xlabel('IWPcls TARGETS')
colorbar
axis equal
axis xy
lsline

title({['x=outputs,y=targets']; ...
       ['correlation=' sprintf('%5.2f',corrcoef(Y',IWPcl'))] })

print('-dpng', '-r1000', ['SCATTER_Targets-outputs_densitycolors'  trainFcn trainingfct '_' sprintf('%i',NBcla) 'cl_' DIVIDER sprintf('%i',round(divid*100)) 'E-2' Alphastr])

hold off

clear figure


%//////////////////////////////////////
%7. cdf Y and IWPcl
%//////////////////////////////////////
figure(12)
clf
subplot(2,1,1)
cdfplot(IWPcl)
xlim([0 NBcla-1])
title('TARGET cdf')

subplot(2,1,2)
cdfplot(Y)
title('OUTPUT cdf')
xlim([0 NBcla-1])

%# 20150417 same graph
clr=[0 0 1
     0 0 0];
%hold on
CDFA = cdfplot(IWPcl);
hold on
set(CDFA,'Color',clr(1,:))
CDFB = cdfplot(Y);
set(CDFB,'Color',clr(2,:))
hold off

%hold on
%Alpha=cdf(Y);
%x=0:1:NBcla-1;
%plot(x,Alpha,'k')
%title('bluecurve=TARGETS & blackcurve=OUTPUTS')
print('-dpng', '-r1000', ['CDF_Targets-outputs_densitycolors'  trainFcn trainingfct '_' sprintf('%i',NBcla) 'cl_' ...
                         sprintf('%02i',nbHL) 'HL' DIVIDER sprintf('%i',round(divid*100)) 'E-2' Alphastr])

hold off

clear figure



%//////////////////////////////////////////////
%8. boxplot diff targets-outputs per IWPcl0-30
%//////////////////////////////////////////////
clear IWPdiff
IWPdiff = -99*ones(numel(IWPcl),NBcla)
whos IWPdiff

%for NN=5:5   %1:NBcla
%    %--- arrays for current NN
%    theSet = find(IWPcl==NN);
%    whos theSet
%    TAR =IWPcl(theSet);
%    OUT =Y(theSet);
%
%    %--- 0) stats
%    IWPdiff(:,NN) = TAR-OUT;
%   % IWPdiff= IWPcl-Y;
%    [IWP_T,Isorted] = sort(IWPdiff(:,NN));
%
%    meanIWPdiff=round(10*IWP_T(floor(end/2))/1)/10;
%    Q1=round(10*IWP_T(floor(end/4))/1)/10;
%    Q4=round(10*IWP_T(floor(end*0.75))/1)/10;
%
%end %for NN
%
%%--- 1) box plot diffs realtargets - outputs IWPcl_L0
%figure(11)
%boxplot(IWPdiff(:,NN))
%
%title({['Boxplot overall Targets - Outputs. Nb pts=' sprintf('%i',numel(Y))]; ...
%       ['mean Target-Output=', sprintf('%5.1f',meanIWPdiff)]; ...
%       ['25th percentile=', sprintf('%5.1f',Q1)]; ...
%       ['75th percentile=', sprintf('%5.1f',Q4)]})
%
%print('-dpng', '-r1000', ['STATS_1D_DIFF'  trainFcn '_' sprintf('%i',NBcla)])
%
%clear figure
%
