%%%20150127 plot histos RAD1>9km : R1 for IWP>=IWPseuil & R1;IWP<euil
%args = RAD1, IWP, setT, IWPseuil

    %% histos of IWP<IWPseuil
    nbins=linspace(0.,2.,50);
    nbinsB=linspace(0.,0.1,50);
    %--- LIWP vs R1 ---
    figure(9)
    subplot(2,2,1)
    whos IWP
    whos MTnumvect
%   IWPset0 = find(IWP<CLseuil);  
    IWPset0 = find(IWP<CLseuil & Fnumvect==Frank & MTnumvect==MTnum );
    %
    [countsT,centresT] = hist(RAD1(IWPset0),nbins); hold on
    [maxcounts,argmax]=max(countsT);
    meanR1LIWP = mean(mean(RAD1(IWPset0)));
    sigR1LIWP  = std(RAD1(IWPset0))
    bar(centresT,countsT)
    xlim([nbins(1) nbins(end)])
    title( ['histo RAD1 & IWP<' sprintf('%i',floor(CLseuil/1E3)) 'kg.m-2; max at ' sprintf('%i',argmax) ...
            'meanR1 LIWP= ' sprintf('%5.1f',meanR1LIWP) ])
    clear maxcounts argmax countsT centresT 
    %%% cumulated density fct

    %--- LIWP vs R4 ---
    subplot(2,2,2)
%   cdfplot(RAD1(IWPset0))
    [countsT,centresT] = hist(RAD4(IWPset0),nbinsB); hold on
    [maxcounts,argmax]=max(countsT);
    meanR4LIWP = mean(mean(RAD4(IWPset0)));
    sigR4LIWP  = std(RAD4(IWPset0))
    bar(centresT,countsT)
    xlim([nbinsB(1) nbinsB(end)])
    title( ['RAD4 & IWP<' sprintf('%i',floor(CLseuil/1E3)) 'kg.m-2; max at' sprintf('%i',argmax) ...
            'meanR4 LIWP= ' sprintf('%5.1f',meanR4LIWP) ])
    clear maxcounts argmax countsT centresT 
    xlim([nbinsB(1) nbinsB(end)])    

    %% histos of IWP>=IWPseuil

    %--- HIWP vs R1 ---
    subplot(2,2,3)
%   hist(RAD1(sample_set(setP)),nbins);
    whos IWP
%   IWPset1 = find(IWP>=CLseuil);
    IWPset1 = find(IWP>=CLseuil & Fnumvect==Frank & MTnumvect==MTnum );
%    [countsT,centresT] = hist(RAD1(IWPset1),nbins); hold on
%    [maxcounts,argmax]=max(countsT);
    [maxcounts,argmax]=max(max(RAD1(IWPset1)));
%   maxcounts  %2.99 for 4K
%   maxR=RAD1(IWPset1(argmax))%%7E-2 wrong !!!
%    maxI=IWP(IWPset1(argmax))
    meanR1HIWP = mean(mean(RAD1(IWPset1)));
%%   sigR1HIWP  = std(RAD1(IWPset1))
    pcR1IWP = find(IWP>=CLseuil & RAD1<=maxcounts & Fnumvect==Frank & MTnumvect==MTnum );
%%%   pcR1HIWP = find(RAD1<=1.6); %0.9*maxcounts) %--> used in filterIWP_Floop 'HIWP' case
    % histogram 99pcR1IWP
    [countsT,centresT] = hist(RAD1(pcR1IWP),nbins); hold on       
    bar(centresT,countsT)
    xlim([nbins(1) nbins(end)])
%   set(gca, 'YScale', 'log');
    title( ['histo RAD1 & IWP>=' sprintf('%i',floor(CLseuil/1E3)) 'kg.m-2; max at ' sprintf('%i',argmax) ...
           'meanR1 HIWP= ' sprintf('%5.1f',meanR1HIWP)])
    clear maxcounts argmax meanR1HIWP

    %--- HIWP vs R4 ---
    subplot(2,2,4)
%   cdfplot(RAD1(pcR1IWP))
    [maxcounts,argmax]=max(max(RAD4(IWPset1)));
    meanR4HIWP = mean(mean(RAD4(IWPset1)));
    pcR4IWP = find(IWP>=CLseuil & RAD4<=maxcounts & Fnumvect==Frank & MTnumvect==MTnum );
    pcR4HIWP = find(RAD4<=1.6); %0.9*maxcounts) %--> used in filterIWP_Floop 'HIWP' case
    [countsT,centresT] = hist(RAD4(pcR4IWP),nbinsB); hold on
    bar(centresT,countsT)
    xlim([nbinsB(1) nbinsB(end)])
    title( ['RAD4& IWP>=' sprintf('%i',floor(CLseuil/1E3)) 'kg.m-2; max at ' sprintf('%i',argmax) ...
           'meanR4 HIWP= ' sprintf('%5.1f',meanR4HIWP)])
    clear maxcounts argmax meanR4HIWP
    xlim([nbinsB(1) nbinsB(end)])

    print('-dpng', '-r1000',[ 'classify_CheckingHisto_F' sprintf('%02i',Frank) 'MT' sprintf('%02i',MTnum) '_R1R4lowHighIWP'])
