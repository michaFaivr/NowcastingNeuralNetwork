%IWPseuilT=cloudythresh; %0.9; %1 ;%1.6 as in filterIWP_Fl : same result as no duplicate
IWPseuilT=cloudythresh-1000;
nbdup=3 ;%4->POD=.87 but fails to reproduce RASTAtracks ...  %3->POD=.79  %2-->POD=.69 %1-->POD=.59 %0-->POD=.49
highIWP = find(IWP>=IWPseuilT);
dupstring=['rep' sprintf('%i',nbdup) '_' sprintf('%i',floor(cloudythresh/1E3)) 'kgm2'];;
%# 2015128
if numel(highIWP>1)
    %%% duplicate on RAD1
    whos RAD1
    RT1 = RAD1(highIWP);
    whos RT1
    NB = repmat(RT1,nbdup);
    whos NB
    RAD1 = [RAD1;NB(:,1)];
    whos RAD1
    clear RT1 NB
    %%% duplicate on RAD2
    RT2 = RAD2(highIWP);
    whos RT2
    NB = repmat(RT2,nbdup);
    RAD2 = [RAD2;NB(:,1)];
    whos RAD2
    clear RT2 NB
    %%% duplicate on RAD2
    RT3 = RAD3(highIWP);
    whos RT3
    NB = repmat(RT3,nbdup);
    RAD3 = [RAD3;NB(:,1)];
    whos RAD3
    clear RT3 NB
    %%% duplicate on RAD2
    RT4 = RAD4(highIWP);
    whos RT4
    NB = repmat(RT4,nbdup);
    RAD4 = [RAD4;NB(:,1)];
    whos RAD4
    clear RT4 NB
    %
    %%% duplicate on RAD1sig
    RT1 = RAD1sig(highIWP);
    whos RT1
    NB = repmat(RT1,nbdup);
    RAD1sig = [RAD1sig;NB(:,1)];
    whos RAD1sig
    clear RT1 NB
    %%% duplicate on RAD2sig
    RT2 = RAD2sig(highIWP);
    whos RT2
    NB = repmat(RT2,nbdup);
    RAD2sig = [RAD2sig;NB(:,1)];
    whos RAD2sig NB
    clear RT2
    %%% duplicate on RAD3sig
    RT3 = RAD3sig(highIWP);
    whos RT3
    NB = repmat(RT3,nbdup);
    RAD3sig = [RAD3sig;NB(:,1)];
    whos RAD3sig 
    clear RT3 NB
    %%% duplicate on RAD4sig
    RT4 = RAD4sig(highIWP);
    whos RT4
    NB = repmat(RT4,nbdup);
    RAD4sig = [RAD4sig;NB(:,1)];
    whos RAD4sig
    clear RT4 NB
    %%% duplicate on IWP
    IWPT = IWP(highIWP);
    whos IWPT
    NB = repmat(IWPT,nbdup);
    IWP = [IWP;NB(:,1)];
    whos IWP
    clear IWPT NB
    % other arrays
    %%% duplicate on Fnumvect
    RT = Fnumvect(highIWP);
    whos RT
    NB = repmat(RT,nbdup);
    Fnumvect = [Fnumvect;NB(:,1)];
    whos Fnumvect
    clear RT NB
    %%% duplicate on MTnumvect
    RT = MTnumvect(highIWP);
    whos RT
    NB = repmat(RT,nbdup);
    MTnumvect = [MTnumvect;NB(:,1)];
    whos MTnumvect
    clear RT NB
    %%% duplicate on RASTAlat
    RASTAlatT = RASTAlat(highIWP);
    whos RASTAlatT
    NB = repmat(RASTAlatT ,nbdup);
    RASTAlat = [RASTAlat;NB(:,1)];
    whos RASTAlat
    clear RASTAlatT NB
    %%% duplicate on RASTAlon
    RASTAlonT = RASTAlon(highIWP);
    whos RASTAlonT  
    NB = repmat(RASTAlonT ,nbdup);
    RASTAlon = [RASTAlon;NB(:,1)];
    whos RASTAlon
    clear RASTAlonT NB
end
%pause

