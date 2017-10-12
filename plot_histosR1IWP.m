%%%20150127 plot histos RAD1>9km : R1 for IWP>=IWPseuil & R1;IWP<euil
%args = RAD1, IWP, setT, IWPseuil

    %% histos of IWP<IWPseuil
    nbins=0:1E-1:12;
    %%% histo RAD1 all values
    figure(9)
    subplot(2,2,1)
%   hist(RAD1(sample_set(setP)),nbins);
    whos IWP
    IWPset0 = find(IWP<CLseuil);  
    %
    [countsT,centresT] = hist(RAD1(IWPset0),nbins); hold on
    [maxcounts,argmax]=max(countsT);
    meanR1LIWP = mean(mean(RAD1(IWPset0)));
    sigR1LIWP  = std(RAD1(IWPset0))
    bar(centresT,countsT)
    xlim([nbins(1) nbins(end)])
%   set(gca, 'YScale', 'log');
    title( ['histo RAD1>=9km & IWP<' sprintf('%i',CLseuil) 'g.m-2; max at ' sprintf('%i',argmax) ...
            'meanR1 LIWP= ' sprintf('%5.1f',meanR1LIWP) ])
    clear maxcounts,argmax;
    %%% cumulated density fct
    subplot(2,2,2)
%   cdfplot(RAD1(IWPset0))
    xlim([nbins(1) nbins(end)])    
    ylim([0 1])
%%   print('-dpng', '-r1000','classify_CheckingHistoRAD1lowerIWP')

    %% histos of IWP>=IWPseuil
    nbins=0:1E-1:12;
    %%% histo RAD1 all values
    subplot(2,2,3)
%   hist(RAD1(sample_set(setP)),nbins);
    whos IWP
    IWPset1 = find(IWP>=CLseuil);
    %
%    [countsT,centresT] = hist(RAD1(IWPset1),nbins); hold on
%    [maxcounts,argmax]=max(countsT);
    [maxcounts,argmax]=max(max(RAD1(IWPset1)));
%   maxcounts  %2.99 for 4K
%   maxR=RAD1(IWPset1(argmax))%%7E-2 wrong !!!
%    maxI=IWP(IWPset1(argmax))
    meanR1HIWP = mean(mean(RAD1(IWPset1)));
%%   sigR1HIWP  = std(RAD1(IWPset1))
%   0.99*maxR
%   pause    
    pcR1IWP = find(IWP>=CLseuil & RAD1<=maxcounts);
    pcR1HIWP = find(RAD1<=1.6); %0.9*maxcounts) %--> used in filterIWP_Floop 'HIWP' case
    % histogram 99pcR1IWP
    [countsT,centresT] = hist(RAD1(pcR1IWP),nbins); hold on       
    bar(centresT,countsT)
    xlim([nbins(1) nbins(end)])
%   set(gca, 'YScale', 'log');
    title( ['histo RAD1>=9km & IWP>=' sprintf('%i',CLseuil) 'g.m-2; max at ' sprintf('%i',argmax) ...
           'meanR1 HIWP= ' sprintf('%5.1f',meanR1HIWP)])
    clear maxcounts,argmax;
    %%% cumulated density fct
    %% get 99% top R1 value
    subplot(2,2,4)
%   cdfplot(RAD1(pcR1IWP))
    xlim([nbins(1) nbins(end)])
    ylim([0 1])
    print('-dpng', '-r1000','classify_CheckingHistoRAD1lowHighIWP')
