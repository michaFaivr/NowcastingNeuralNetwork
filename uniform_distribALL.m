%#20150202 uniform_dstribIWP

%///////////////////////////////////
% 1) histo IWP x=IWPbins; y=freq
%///////////////////////////////////

[IWPbins,myHistoIWP] = make_histo(IWP);
whos IWPbins
whos myHistoIWP
myHistoIWP
[maxcounts,argmax]=max(myHistoIWP) 
sumcounts = sum(myHistoIWP);  
%--- histo origin ---
subplot(2,1,1)
bar(1:numel(IWPbins)-1,myHistoIWP./sumcounts)
title('IWP histo origin');
    clear maxcounts,argmax;
%--- cumulated density fct ---
disp('cancel TOOLS/unif_distribIWP_ALL.m cdfplot if MatlabStatstoolbox unavailable')
subplot(2,1,2)
    cdfplot(IWP); hold on
    xlim([IWPbins(1) IWPbins(end)])
    ylim([0 1])

print('-dpng', '-r1000',  'HISTO_IWP_origin' )

%--- calculate inverse pdf of .2:.8 ---
%%Xinvpdf = icdf('Generalized Pareto',)

%--- 20150202 (b) uniformize histo IWP ---
maxcounts = max(myHistoIWP)

%--- 20150423 change maxcounts to myHistoIWP(2) ---
%%maxcounts = myHistoIWP(2)


%///////////////////////////////////
%2. pseudo-uniformize IWP distrib
%///////////////////////////////////

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%# 20150410 add condition on applyUnif
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if applyUnif==1
IWP_T=[];RAD1_T=[];RAD2_T=[];RAD3_T=[];RAD4_T=[];RAD1sig_T=[];RAD2sig_T=[];RAD3sig_T=[];RAD4sig_T=[];
Fnumv_T=[];Mnumv_T=[];RASTAspot_T=[];RASTAlon_T=[];RASTAlat_T=[];
%# 20150416 test 'sqrt' & norm
%# 20150421 linear is convexe : repmat(floor((1-a)*(3*h(N)) - a*h(1) )/h(n))
DIVIDER= 'exp'; %'norm';%'linear';%'exp';%'sqrt';%'nthroot';%'log';%'sqrt';%'exp'; %'norm'; %'sqrt';  %'exp'; %'norm';
%20150303 : EXP3.5 done for F06,10,15,16
%20150303 :EXP4 in same conditions (divideint)
%divid=5&divideint ~ divide4&divideran 
%fine tuning between 4 and 5 wr 1D RASTA track fitting 
%/////////////////////////////////////////////
%divid high => more correction=>POD&FAR higher
%/////////////////////////////////////////////

%%% NB : resultats in 2D are more stable in 06cl wr changing expCoef 
%%% vs 31cl : stronger changes wr exp coef 250 ok, 300: backgd artefacts 

if NBcla<=4
    %# 20150415 2.5-->250
    divid=250;%4.5;%4;%3.5;%4;%6;%5;%2;%4;%3;%4:divid high => more correction=>POD&FAR higher
    %# 20150526 250--> 400
    divid=400;
elseif NBcla==5
%   divid=4;
    %# 20150415 4-->400
    divid=390; %350;%almost good %400;too artefacts
elseif NBcla<15 & NBcla~=8
    divid=800; %740; %800; %900;%700;%800; %740; %660;%510; %495;%460 %420; %500; %490; %460; %400; %200; %350; %495; %490; %450;
elseif NBcla==8
    divid=900;
else
    %%%%%%%%% NEW 20150410 : use divid/100 in calculation of unif !!! %%%%%%%
    %# 20150309 3-->2.5 as for 04clIWP
    if strcmp(trainFcn,'SCG')==1
        divid=250; %250; %260;%250; %246.22; %250;2.5; %%NB : 260 fails / 242fails
    elseif strcmp(trainFcn,'GDA')==1
        divid=248; %258;
    elseif strcmp(trainFcn,'GDM')==1
        divid=269;
    else
            divid= 360; %380; %340; %250;  %for LM09HL 
    end
end
if strcmp(DIVIDER,'exp')==0
    divid=0;
end

for NBI=1:length(IWPbins)-1
     if myHistoIWP(NBI)>0
        Ind = find(IWP>=IWPbins(NBI) & IWP<IWPbins(NBI+1));
        numel(Ind)
        %# 20150216 /sqrt(NBI)
        switch DIVIDER
        case 'sqrt'
        HTP=repmat(IWP(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/sqrt(NBI))),1);
        %# 20150202 apply repmat to NNET IN  :R1-4, Rsigs
        R1T=repmat(RAD1(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/sqrt(NBI))),1); 
        R2T=repmat(RAD2(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/sqrt(NBI))),1);
        R3T=repmat(RAD3(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/sqrt(NBI))),1);
        R4T=repmat(RAD4(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/sqrt(NBI))),1);
        R1ST=repmat(RAD1sig(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/sqrt(NBI))),1);
        R2ST=repmat(RAD2sig(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/sqrt(NBI))),1);
        R3ST=repmat(RAD3sig(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/sqrt(NBI))),1);
        R4ST=repmat(RAD4sig(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/sqrt(NBI))),1);
        FnumvT=repmat(Fnumvect(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/sqrt(NBI))),1);
        MnumvT=repmat(MTnumvect(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/sqrt(NBI))),1);
        RASTAspotT=repmat(RASTAspot(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/sqrt(NBI))),1);
        RASTAlonT=repmat(RASTAlon(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/sqrt(NBI))),1);
        RASTAlatT=repmat(RASTAlat(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/sqrt(NBI))),1);
        %# 20150219 replace sqrt by exp
        %# 20150417 case 'log'
        case 'log'
        HTP=repmat(IWP(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/log(NBI+1))),1);
        %# 20150202 apply repmat to NNET IN  :R1-4, Rsigs
        R1T=repmat(RAD1(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/log(NBI+1))),1);
        R2T=repmat(RAD2(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/log(NBI+1))),1);
        R3T=repmat(RAD3(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/log(NBI+1))),1);
        R4T=repmat(RAD4(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/log(NBI+1))),1);
        R1ST=repmat(RAD1sig(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/log(NBI+1))),1);
        R2ST=repmat(RAD2sig(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/log(NBI+1))),1);
        R3ST=repmat(RAD3sig(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/log(NBI+1))),1);
        R4ST=repmat(RAD4sig(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/log(NBI+1))),1);
        FnumvT=repmat(Fnumvect(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/log(NBI+1))),1);
        MnumvT=repmat(MTnumvect(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/log(NBI+1))),1);
        RASTAspotT=repmat(RASTAspot(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/log(NBI+1))),1);
        RASTAlonT=repmat(RASTAlon(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/log(NBI+1))),1);
        RASTAlatT=repmat(RASTAlat(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/log(NBI+1))),1);
%
        case 'nthroot'
        HTP=repmat(IWP(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/nthroot(NBI*NBI,3))),1);
        %# 20150202 apply repmat to NNET IN  :R1-4, Rsigs
        R1T=repmat(RAD1(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/nthroot(NBI*NBI,3))),1);
        R2T=repmat(RAD2(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/nthroot(NBI*NBI,3))),1);
        R3T=repmat(RAD3(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/nthroot(NBI*NBI,3))),1);
        R4T=repmat(RAD4(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/nthroot(NBI*NBI,3))),1);
        R1ST=repmat(RAD1sig(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/nthroot(NBI*NBI,3))),1);
        R2ST=repmat(RAD2sig(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/nthroot(NBI*NBI,3))),1);
        R3ST=repmat(RAD3sig(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/nthroot(NBI*NBI,3))),1);
        R4ST=repmat(RAD4sig(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/nthroot(NBI*NBI,3))),1);
        FnumvT=repmat(Fnumvect(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/nthroot(NBI*NBI,3))),1);
        MnumvT=repmat(MTnumvect(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/nthroot(NBI*NBI,3))),1);
        RASTAspotT=repmat(RASTAspot(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/nthroot(NBI*NBI,3))),1);
        RASTAlonT=repmat(RASTAlon(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/nthroot(NBI*NBI,3))),1);
        RASTAlatT=repmat(RASTAlat(Ind),floor(maxcounts/myHistoIWP(NBI)*(1/nthroot(NBI*NBI,3))),1);
%
        case 'linear'
        h_1 = myHistoIWP(1);
        h_n = myHistoIWP(NBI);
        h_N = myHistoIWP(end);
        alpha = (NBI-1)/(length(IWPbins)-1 -1);
        Coef=1.5; %5;
        beta  = alpha*Coef*h_N + (1.-alpha)*h_1;
        HTP=repmat(IWP(Ind),floor(beta/h_n),1);
        R1T=repmat(RAD1(Ind),floor(beta/h_n),1);
        R2T=repmat(RAD2(Ind),floor(beta/h_n),1);
        R3T=repmat(RAD3(Ind),floor(beta/h_n),1);
        R4T=repmat(RAD4(Ind),floor(beta/h_n),1);
        R1ST=repmat(RAD1sig(Ind),floor(beta/h_n),1);
        R2ST=repmat(RAD2sig(Ind),floor(beta/h_n),1);
        R3ST=repmat(RAD3sig(Ind),floor(beta/h_n),1);
        R4ST=repmat(RAD4sig(Ind),floor(beta/h_n),1);
        FnumvT=repmat(Fnumvect(Ind),floor(beta/h_n),1);
        MnumvT=repmat(MTnumvect(Ind),floor(beta/h_n),1);
        RASTAspotT=repmat(RASTAspot(Ind),floor(beta/h_n),1);
        RASTAlonT=repmat(RASTAlon(Ind),floor(beta/h_n),1);
        RASTAlatT=repmat(RASTAlat(Ind),floor(beta/h_n),1);
%
        case 'exp'
%********************
%# 20150410 
%replace floor by fix
%********************
        disp('theCOEF')
        theCOEF = 1/exp(NBI/divid-1) %exp=2.5 NBI=8-> 0.11 / exp=1.5 NBI=8-> 0.01
        fix(maxcounts/myHistoIWP(NBI)*(1/exp(NBI/divid-1))) %%exp=2.5 NBI=8->3 / %exp=1.5 NBI=8->0
%       if NBI==8
%           pause
%        end
        %# 20150410 divid-->(divid/100)
        HTP=repmat(IWP(Ind),fix(maxcounts/myHistoIWP(NBI)*(1/exp(NBI/(divid/100)-1))),1);
        R1T=repmat(RAD1(Ind),fix(maxcounts/myHistoIWP(NBI)*(1/exp(NBI/(divid/100)-1))),1);
        R2T=repmat(RAD2(Ind),fix(maxcounts/myHistoIWP(NBI)*(1/exp(NBI/(divid/100)-1))),1);
        R3T=repmat(RAD3(Ind),fix(maxcounts/myHistoIWP(NBI)*(1/exp(NBI/(divid/100)-1))),1);
        R4T=repmat(RAD4(Ind),fix(maxcounts/myHistoIWP(NBI)*(1/exp(NBI/(divid/100)-1))),1);
        R1ST=repmat(RAD1sig(Ind),fix(maxcounts/myHistoIWP(NBI)*(1/exp(NBI/(divid/100)-1))),1);
        R2ST=repmat(RAD2sig(Ind),fix(maxcounts/myHistoIWP(NBI)*(1/exp(NBI/(divid/100)-1))),1);
        R3ST=repmat(RAD3sig(Ind),fix(maxcounts/myHistoIWP(NBI)*(1/exp(NBI/(divid/100)-1))),1);
        R4ST=repmat(RAD4sig(Ind),fix(maxcounts/myHistoIWP(NBI)*(1/exp(NBI/(divid/100)-1))),1);
        FnumvT=repmat(Fnumvect(Ind),fix(maxcounts/myHistoIWP(NBI)*(1/exp(NBI/(divid/100)-1))),1);
        MnumvT=repmat(MTnumvect(Ind),fix(maxcounts/myHistoIWP(NBI)*(1/exp(NBI/(divid/100)-1))),1);
        RASTAspotT=repmat(RASTAspot(Ind),fix(maxcounts/myHistoIWP(NBI)*(1/exp(NBI/(divid/100)-1))),1);
        RASTAlonT=repmat(RASTAlon(Ind),fix(maxcounts/myHistoIWP(NBI)*(1/exp(NBI/(divid/100)-1))),1);
        RASTAlatT=repmat(RASTAlat(Ind),fix(maxcounts/myHistoIWP(NBI)*(1/exp(NBI/(divid/100)-1))),1);
        whos HTP
        whos IWP
        %# 20150219 rplace sqrt by exp
        %%%%%divid=4;
        case 'norm'
        HTP=repmat(IWP(Ind),floor(maxcounts/myHistoIWP(NBI)),1);
        R1T=repmat(RAD1(Ind),floor(maxcounts/myHistoIWP(NBI)),1);
        R2T=repmat(RAD2(Ind),floor(maxcounts/myHistoIWP(NBI)),1);
        R3T=repmat(RAD3(Ind),floor(maxcounts/myHistoIWP(NBI)),1);
        R4T=repmat(RAD4(Ind),floor(maxcounts/myHistoIWP(NBI)),1);
        R1ST=repmat(RAD1sig(Ind),floor(maxcounts/myHistoIWP(NBI)),1);
        R2ST=repmat(RAD2sig(Ind),floor(maxcounts/myHistoIWP(NBI)),1);
        R3ST=repmat(RAD3sig(Ind),floor(maxcounts/myHistoIWP(NBI)),1);
        R4ST=repmat(RAD4sig(Ind),floor(maxcounts/myHistoIWP(NBI)),1);
        FnumvT=repmat(Fnumvect(Ind),floor(maxcounts/myHistoIWP(NBI)),1);
        MnumvT=repmat(MTnumvect(Ind),floor(maxcounts/myHistoIWP(NBI)),1);
        RASTAspotT=repmat(RASTAspot(Ind),floor(maxcounts/myHistoIWP(NBI)),1);
        RASTAlonT=repmat(RASTAlon(Ind),floor(maxcounts/myHistoIWP(NBI)),1);
        RASTAlatT=repmat(RASTAlat(Ind),floor(maxcounts/myHistoIWP(NBI)),1);
        whos HTP
        whos IWP
 end 
        %pause
        IWP_T=[IWP_T;HTP(:,1)];
        RAD1_T=[RAD1_T;R1T(:,1)];
        RAD2_T=[RAD2_T;R2T(:,1)];
        RAD3_T=[RAD3_T;R3T(:,1)];
        RAD4_T=[RAD4_T;R4T(:,1)];
        RAD1sig_T=[RAD1sig_T;R1ST(:,1)];
        RAD2sig_T=[RAD2sig_T;R2ST(:,1)];
        RAD3sig_T=[RAD3sig_T;R3ST(:,1)];
        RAD4sig_T=[RAD4sig_T;R4ST(:,1)];
        Fnumv_T=[Fnumv_T;FnumvT(:,1)];
        Mnumv_T=[Mnumv_T;MnumvT(:,1)];
        RASTAspot_T=[RASTAspot_T;RASTAspotT(:,1)];
        RASTAlon_T=[RASTAlon_T;RASTAlonT(:,1)];
        RASTAlat_T=[RASTAlat_T;RASTAlatT(:,1)];
        clear HTP R1T R2T R3T R4T R1ST R2ST R3ST R4ST FnumvT MnumvT RASTAspotT RASTAlonT RASTAlatT Ind
    end
end
whos IWP_T

%///////////////////////////////////
%3. SORT uniformized IWP
%///////////////////////////////////

%--- 20150202 (c) sort IWP & others accordingly ---
% update I arrays sorting wr IWP !!!s
%# 20150423 add filtering : IWP<12kg
[IWP,Isorted] = sort(IWP_T);
%%%[IWP,Isorted] = sort(IWP_T(IWP_T<12E3));
disp('minmax IWP sorted')
min(IWP)
max(IWP)
IWP(1)
IWP(end)
disp('min max above')
%pause
RAD1 = RAD1_T(Isorted);
RAD2 = RAD2_T(Isorted);
RAD3 = RAD3_T(Isorted);
RAD4 = RAD4_T(Isorted);
RAD1sig = RAD1sig_T(Isorted);
RAD2sig = RAD2sig_T(Isorted);
RAD3sig = RAD3sig_T(Isorted);
RAD4sig = RAD4sig_T(Isorted);
Fnumvect= Fnumv_T(Isorted);
MTnumvect= Mnumv_T(Isorted);
RASTAspot=RASTAspot_T(Isorted);
RASTAlon=RASTAlon_T(Isorted);
RASTAlat=RASTAlat_T(Isorted);
%pause

%%end %case applyUnif==1
%%case applyUnif==0
else 
DIVIDER='none';
divid=1;
RAD1_T=RAD1; RAD2_T=RAD2; RAD3_T=RAD3; RAD4_T=RAD4;
RAD1sig_T=RAD1sig; RAD2sig_T=RAD2sig; RAD3sig_T=RAD3sig; RAD4sig_T=RAD4sig;
IWP_T = IWP;
Fnumv_T=Fnumvect; Mnumv_T=MTnumvect; 
RASTAspot_T=RASTAspot; RASTAlon_T=RASTAlon; RASTAlat_T=RASTAlat;
%sort wr IWP
[IWP_T,Isorted] = sort(IWP);
RAD1 = RAD1_T(Isorted);
RAD2 = RAD2_T(Isorted);
RAD3 = RAD3_T(Isorted);
RAD4 = RAD4_T(Isorted);
RAD1sig = RAD1sig_T(Isorted);
RAD2sig = RAD2sig_T(Isorted);
RAD3sig = RAD3sig_T(Isorted);
RAD4sig = RAD4sig_T(Isorted);
Fnumvect= Fnumv_T(Isorted);
MTnumvect= Mnumv_T(Isorted);
RASTAspot=RASTAspot_T(Isorted);
RASTAlon=RASTAlon_T(Isorted);
RASTAlat=RASTAlat_T(Isorted);
%pause

end %end applyUnif

disp('check if RAD4 complex')
whos RAD4
%%pause

%# 20150403 boxplot 4RADS
RadsIWP_boxplot


%////////////////////////////////////////
%4. CHECK and PLOT uniformized distrib
%////////////////////////////////////////
%--- 20150202 (d) check uniformized histo IWP ---
[IWPbins,myHistoIWP] =  make_histo(IWP_T)
sumcounts=sum(myHistoIWP);
clear figure
figure(2)
%--- histo pseudo unif ---
subplot(2,1,1)
bar(1:numel(IWPbins)-1,myHistoIWP./sumcounts)
title('IWP histo uniform');
    clear maxcounts,argmax;
%--- cumulated density fct ---
subplot(2,1,2)
    cdfplot(IWP)
    ylim([0 1])
print('-dpng', '-r1000',[ 'HISTO_IWP_uniformized' trainFcn trainingfct sprintf('%i',round(divid)) ])
clear figure
