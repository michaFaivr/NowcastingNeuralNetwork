%%%20141126 plot histos RAD3>9km cse classif ok, classif wrong
    %nbins=0:2E2:1E4;
    nbins=0:1E-1:2;
    %%% histo RAD3 all values
    figure(9)
    subplot(3,2,1)
%   hist(RAD3(sample_set(setP)),nbins);
    [countsT,centresT] = hist(RAD3(sample_set(setP)),nbins);
    bar(centresT,countsT)
    xlim([nbins(1) nbins(end)])
%   set(gca, 'YScale', 'log');
    title('histo RAD3>=9km overall values')
    print('-dpng', '-r1000','classify_CheckingHistoRAD3')
    %cumulated density fct
    subplot(3,2,2)
    cdfplot(RAD3(sample_set(setP)))
    xlim([nbins(1) nbins(end)])    
    ylim([0 1])

    %%% histo RAD3 cases classif ok
    subplot(3,2,3)
%   hist(RAD3(sample_set(setP(goodclmask==1))),nbins);
    [countsG,centresG] = hist(RAD3(sample_set(setP(goodclmask==1))),nbins);
    bar(centresG,countsG)
    xlim([nbins(1) nbins(end)])
%   set(gca, 'YScale', 'log');
    title('histo RAD3>=9km goodCLmask')
    %cumulated density fct
    subplot(3,2,4)
    cdfplot(RAD3(sample_set(setP(goodclmask==1))))
    xlim([nbins(1) nbins(end)])
    ylim([0 1])

    %%% histo RAD3 cases classif ok
    subplot(3,2,5)
%   hist(RAD3(sample_set(setP(goodclmask~=1))),nbins);
    [countsW,centresW] = hist(RAD3(sample_set(setP(goodclmask~=1))),nbins);
    bar(centresW,countsW)
    xlim([nbins(1) nbins(end)])
%   set(gca, 'YScale', 'log');
    title('histo RAD3>=9km incorrect Classif')
    %cumulated density fct
    subplot(3,2,6)
    cdfplot(RAD3(sample_set(setP(goodclmask~=1))))
    xlim([nbins(1) nbins(end)]) 
    ylim([0 1])

    print('-dpng', '-r1000','classify_CheckingHistoRAD3')
