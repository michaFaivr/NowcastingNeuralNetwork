RAD1seuil=1; %0.9; %1 ;%1.6 as in filterIWP_Fl : same result as no duplicate
nbdup=1;
lowRAD1 = find(RAD1<=RAD1seuil);
dupstring=['rep' sprintf('%i',nbdup) '_' sprintf('%03i',floor(RAD1seuil*100)) 'E-2'];

%# 2015128
if numel(lowRAD1>1)
    %%% duplicate on RAD1
    whos RAD1
    RT1 = RAD1(lowRAD1);
    whos RT1
    NB = repmat(RT1,nbdup);
    whos NB
%   RT1(1:4)
%   NB(6554:6557)
%   pause
    RAD1 = [RAD1;NB(:,1)];
    whos RAD1
    clear RT1 NB
    %%% duplicate on RAD2
    RT2 = RAD2(lowRAD1);
    whos RT2
    NB = repmat(RT2,nbdup);
    RAD2 = [RAD2;NB(:,1)];
    whos RAD2
    clear RT2 NB
    %%% duplicate on RAD2
    RT3 = RAD3(lowRAD1);
    whos RT3
    NB = repmat(RT3,nbdup);
    RAD3 = [RAD3;NB(:,1)];
    whos RAD3
    clear RT3 NB
    %%% duplicate on RAD2
    RT4 = RAD4(lowRAD1);
    whos RT4
    NB = repmat(RT4,nbdup);
    RAD4 = [RAD4;NB(:,1)];
    whos RAD4
    clear RT4 NB
    %
    %%% duplicate on RAD1sig
    RT1 = RAD1sig(lowRAD1);
    whos RT1
    NB = repmat(RT1,nbdup);
    RAD1sig = [RAD1sig;NB(:,1)];
    whos RAD1sig
    clear RT1 NB
    %%% duplicate on RAD2sig
    RT2 = RAD2sig(lowRAD1);
    whos RT2
    NB = repmat(RT2,nbdup);
    RAD2sig = [RAD2sig;NB(:,1)];
    whos RAD2sig NB
    clear RT2
    %%% duplicate on RAD3sig
    RT3 = RAD3sig(lowRAD1);
    whos RT3
    NB = repmat(RT3,nbdup);
    RAD3sig = [RAD3sig;NB(:,1)];
    whos RAD3sig 
    clear RT3 NB
    %%% duplicate on RAD4sig
    RT4 = RAD4sig(lowRAD1);
    whos RT4
    NB = repmat(RT4,nbdup);
    RAD4sig = [RAD4sig;NB(:,1)];
    whos RAD4sig
    clear RT4 NB
    %%% duplicate on IWP
    IWPT = IWP(lowRAD1);
    whos IWPT
    NB = repmat(IWPT,nbdup);
    IWP = [IWP;NB(:,1)];
    whos IWP
    clear IWPT NB
    % other arrays
    %%% duplicate on Fnumvect
    RT = Fnumvect(lowRAD1);
    whos RT
    NB = repmat(RT,nbdup);
    Fnumvect = [Fnumvect;NB(:,1)];
    whos Fnumvect
    clear RT NB
    %%% duplicate on MTnumvect
    RT = MTnumvect(lowRAD1);
    whos RT
    NB = repmat(RT,nbdup);
    MTnumvect = [MTnumvect;NB(:,1)];
    whos MTnumvect
    clear RT NB
    %%% duplicate on RASTAlat
    RASTAlatT = RASTAlat(lowRAD1);
    whos RASTAlatT
    NB = repmat(RASTAlatT ,nbdup);
    RASTAlat = [RASTAlat;NB(:,1)];
    whos RASTAlat
    clear RASTAlatT NB
    %%% duplicate on RASTAlon
    RASTAlonT = RASTAlon(lowRAD1);
    whos RASTAlonT  
    NB = repmat(RASTAlonT ,nbdup);
    RASTAlon = [RASTAlon;NB(:,1)];
    whos RASTAlon
    clear RASTAlonT NB
end
%pause

