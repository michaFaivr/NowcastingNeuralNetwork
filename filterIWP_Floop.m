%# 20141127 filter IWP to se impact on classif quality
%# 20150130 added ratiofiltered in outputs
function [TRefset,PRefset,ratiofiltered] = filterIWP(RAD1,RAD1sig,RADsigseuil,RAD4,IWP,IWPseuil,filterIWPflag,cloudythresh,RAD1IWPcut,Fnum,Fnumvect,pivotIWP,borneSup)
%suite etude faite sur full range avec statsRADSIWP :set used domain RAD1xIWP={[0,2]xR+}v{[2,+]x[0,500]} !!!
%RAD1IWPcut=500;%200;%600;%300;%;400;
%%%20141211 for NEWPR use F07,13,21 !!!
%%%20150113 RADSeuil/2
%i lfaudrait avoir un sellage dynamique de RAD1sigma suivant RAD1 !!!
% RAD high --> CS condition 
%RADsigseuil=RADsigseuil*5E-2; %NB il faudrait le faire sur les images MTSAT pour coherence
%RADsigseuil=RADsigseuil*4E-1;
%# 20150126
%RADsigseuil=1E-1;  %2E-2;  %3E-2;  %4E-2;
%# 20150120 keep RADseuil=1
%--> see F10MT26 to see why filtering on RADsigma1 needed

%# 20150128 : repmat(RAD1<=1.6)
whos RAD1
whos IWP
%lowRAD1 = find(RAD1<=1.6);
%% concatenate then !
%%%duplicate_lowRAD1
max(max(RAD1sig))
%RADsigseuil=10.; %1.7%not as good as 1.6;%1.5 not good
%# 20150129 6pm
RADseuil=2.3;%3
ratiofiltered=0

    switch filterIWPflag 
        case 'Floop'
           %20141205 filter F07,13,21
%           TRefset=find(RAD1sig<RADsigseuil & Fnumvect~=7 & Fnumvect~=13 & Fnumvect<21);
            %PRefset=find(RAD1sig<RADsigseuil & Fnumvect<22 & Fnumvect==Fnum);
%           PRefset=find(RAD1sig<RADsigseuil & Fnumvect~=7 & Fnumvect~=13 & Fnumvect<21);
%# 2015
            TRefset=find(RAD1sig<=RAD1.*RADsigseuil & Fnumvect~=7 & Fnumvect~=13 & Fnumvect<=22);
            PRefset=TRefset;
%           TRefset=find(RAD1sig<RADsigseuil & Fnumvect<22);
%%% 20150108
%           PRefset=find(RAD1sig<RADsigseuil & Fnumvect<22);
        case 'Off'
%           TRefset=find(RAD1sig<RADsigseuil); PRefset=TRefset;
%# 20150126
%           TRefset=find(RAD1sig<RAD1.*RADsigseuil);
%# 20150128 
            TRefset=find(RAD1>0);
            PRefset=TRefset;
            ratiofiltered=100-floor(100*numel(TRefset)/numel(RAD1>0));
        case 'Fnum'
            TRefset=find(RAD1sig<RADsigseuil & Fnumvect<22); PRefset=TRefset;
        case 'IWPOnRAD4Off'
            TRefset=find(RAD1sig<RADsigseuil & ...
                       ~(IWP>=200 & IWP<=400)); PRefset=TRefset;
        case 'IWPOnRAD4On'
            TRefset=find(RAD1sig<RADsigseuil & ...
                       ~(IWP>=200 & IWP<=400) & ...
                       ~(RAD4>=5E-2 & RAD4<=4E-1));%peak bad classif IWP=300g/m2
            PRefset=TRefset;
        case 'IWPOnRAD1On'
            TRefset=find(RAD1<2. | (RAD1>=2 & IWP<RAD1IWPcut));
            PRefset=TRefset;
        case 'HIWP'
            %20141205 keep IWP>cloudythresh
%           TRefset=find(IWP>cloudythresh & (RAD1<2. | (RAD1>=2 & IWP<RAD1IWPcut)));
%           TRefset=find(RAD1sig<RADsigseuil & IWP>cloudythresh & Fnumvect~=7 & Fnumvect~=13 & Fnumvect<21);
%           TRefset=find(RAD1sig<RADsigseuil & IWP>pivotIWP & Fnumvect~=7 & Fnumvect~=13 & Fnumvect<21);
%           TRefset=find(RAD1sig<RADsigseuil & IWP>pivotIWP & IWP<borneSup);
%# 20150127 new condition o: R1<=1.6 ;then in Pixel image : leave pixels with R1>1.6 in white as unflagged !!!
%# 20150130 filter on IWP 
%            TRefset=find(RAD1>=0. & RAD1<=RADseuil);
%            PRefset=TRefset;
%           ratiofiltered=100-floor(100*numel(TRefset)/numel(RAD1>=0.));        
            TRefset=find(IWP>=cloudythresh/2);
            PRefset=TRefset;
            ratiofiltered=100-floor(100*numel(TRefset)/numel(IWP>=cloudythresh/2));
        case 'LMIWP'
            %20150107 keep IWP<cloudythresh
%           TRefset=find(RAD1sig<RADsigseuil & IWP>pivotIWP & IWP<borneSup & Fnumvect~=7 & Fnumvect~=13 & Fnumvect<21);
            TRefset=find(RAD1sig<RADsigseuil & IWP<pivotIWP);
            PRefset=TRefset;
    end
end
