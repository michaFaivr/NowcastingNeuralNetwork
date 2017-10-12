%%%20141126 plot histos RAD1>9km cse classif ok, classif wrong
    %nbins=0:2E2:1E4;
    nbins=0:1E-1:10;
    %%% histo RAD1 all values
    figure(9)
    subplot(3,2,1)
%   hist(RAD1(sample_set(setP)),nbins);
    [countsT,centresT] = hist(RAD1(sample_set(setP)),nbins);
    [maxcounts,argmax]=max(countsT);
    bar(centresT,countsT)
    xlim([nbins(1) nbins(end)])
%   set(gca, 'YScale', 'log');
    title( ['histo RAD1>=9km overall values; max at ' sprintf('%i',argmax)])
    clear maxcounts,argmax;
    print('-dpng', '-r1000','classify_CheckingHistoRAD1')
    %cumulated density fct
    subplot(3,2,2)
    cdfplot(RAD1(sample_set(setP)))
    xlim([nbins(1) nbins(end)])    
    ylim([0 1])

    %%% histo RAD1 cases classif ok
    subplot(3,2,3)
%   hist(RAD1(sample_set(setP(goodclmask==1))),nbins);
    [countsG,centresG] = hist(RAD1(sample_set(setP(goodclmask==1))),nbins);
    [maxcounts,argmax]=max(countsG);
    bar(centresG,countsG)
    xlim([nbins(1) nbins(end)])
%   set(gca, 'YScale', 'log');
    title(['histo RAD1>=9km goodCLmask; max at ' sprintf('%i',argmax)])
    clear maxcounts,argmax;
    %cumulated density fct
    subplot(3,2,4)
    cdfplot(RAD1(sample_set(setP(goodclmask==1))))
    xlim([nbins(1) nbins(end)])
    ylim([0 1])

    %%% histo RAD1 cases classif ok
    subplot(3,2,5)
%   hist(RAD1(sample_set(setP(goodclmask~=1))),nbins);
    [countsW,centresW] = hist(RAD1(sample_set(setP(goodclmask~=1))),nbins);
    [maxcounts,argmax]=max(countsW);
    bar(centresW,countsW)
    xlim([nbins(1) nbins(end)])
%   set(gca, 'YScale', 'log');
    title(['histo RAD1>=9km incorrect Classif; max at ' sprintf('%i',argmax)])
    clear maxcounts,argmax;
    %cumulated density fct
    subplot(3,2,6)
    cdfplot(RAD1(sample_set(setP(goodclmask~=1))))
    xlim([nbins(1) nbins(end)]) 
    ylim([0 1])

    print('-dpng', '-r1000','classify_CheckingHistoRAD1')
