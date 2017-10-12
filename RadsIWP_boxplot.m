%# 20150430 boxplot 4 Ascii RADS from MTSAT collocated with RASTA spots
figure(100)
%--- boxplot R1 ---
subplot(1,5,1)
whos RAD1
boxplot(RAD1)
title('RAD1')

%--- boxplot R2 ---
subplot(1,5,2)
whos RAD2
boxplot(RAD2)
title('RAD2')

%--- boxplot R3 ---
subplot(1,5,3)
whos RAD3
boxplot(RAD3)
title('RAD3')

%--- boxplot R4 ---
subplot(1,5,4)
whos RAD4
boxplot(RAD4)
title(' RAD4')

%--- boxplot IWP ---
subplot(1,5,5)
whos IWP
boxplot(IWP)

meanIWP=round(IWP(floor(end/2))/1);
Q1=round(IWP(floor(end/4))/1);
Q4=round(IWP(floor(end*0.75))/1);

text(0.2,meanIWP*1,sprintf('%i',meanIWP) )
text(0.2,Q1*1,sprintf('%i',Q1) )
text(0.2,Q4*1,sprintf('%i',Q4) )

%title(['IWP mean=' sprintf('%5.1f',meanIWP) ...
%       'Q1=' sprintf('%5.1f',Q1) ...
%       'Q4=' sprintf('%5.1f',Q4) ])

print('-depsc', '-r2000',['Boxplots_RadsIWP_F' sprintf('%02i',Frank) 'MT' sprintf('%02i',MTnum)] )
clear figure

%/////////////////////
%histo RAD1 vs IWP>Q4
figure(4) 
%   nbins=0:1E-1:3;    
    nbins=0:1E-1:8;
    [countsT,centresT] = hist(RAD1(IWP>Q4),nbins);
    [maxcounts,argmax] = max(countsT);
    bar(centresT,countsT)
    xlim([nbins(1) nbins(end)])
%   set(gca, 'YScale', 'log');
    title(['histo RAD1 for IWP(>=9km)>' sprintf('%i',Q4) 'g/m2; max at ' sprintf('%5.1f',nbins(argmax))])
    clear maxcounts,argmax;

print('-depsc', '-r2000',['Histos_RadsIWPQ4_F' sprintf('%02i',Frank) 'MT' sprintf('%02i',MTnum)] )
clear figure
clear nbins countsT centresT

%/////////////////////
%Boxplot RAD1 vs IWP>Q4
subplot(1,5,5)
whos IWP
RAD1_Imax=RAD1(IWP>Q4);
boxplot(RAD1(IWP>Q4))

clear meanIWP Q1 Q4
meanIWP=round(RAD1_Imax(floor(end/2))/1);
Q1=round(RAD1_Imax(floor(end/4))/1);
Q4=round(RAD1_Imax(floor(end*0.75))/1);

text(0.2,meanIWP*1,sprintf('%i',meanIWP) )
text(0.2,Q1*1,sprintf('%i',Q1) )
text(0.2,Q4*1,sprintf('%i',Q4) )

print('-depsc', '-r2000',['Boxplot_RadsIWPQ4_F' sprintf('%02i',Frank) 'MT' sprintf('%02i',MTnum)] )
clear figure


%/////////////////////
%histo RAD1 vs IWP<Q1
figure(4)
    nbins=0:1E-1:8;
    [countsT,centresT] = hist(RAD1(IWP<Q1),nbins);
    [maxcounts,argmax] = max(countsT);
    bar(centresT,countsT)
    xlim([nbins(1) nbins(end)])
%   set(gca, 'YScale', 'log');
    title(['histo RAD1 for IWP(>=9km)<' sprintf('%i',Q1) 'g/m2; max at ' sprintf('%5.1f',nbins(argmax))])
    clear maxcounts,argmax;

print('-depsc', '-r2000',['Histos_RadsIWPQ1_F' sprintf('%02i',Frank) 'MT' sprintf('%02i',MTnum)] )
clear figure

