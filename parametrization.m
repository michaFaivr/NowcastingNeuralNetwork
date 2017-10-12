%# 20141217 setup parameters
    %********** PARAMETERS ************
%////////////////////////
%1. BASH parameters
%////////////////////////
    %--- read BASH made ascii params
    params_file='paramsNNET.txt'
    DFvalues=dlmread(params_file');
    NbInputs    =DFvalues(1);
    NbseuilsIWP =DFvalues(2);
    IWPid       =DFvalues(3);
    Polyfitorder=DFvalues(4);
    useRADcl    =DFvalues(5);
    settype     =DFvalues(6);
    Fiter       =DFvalues(8);

%# 20141217 attention fnum doit etre en phase avec Frank !!!
    nbRADS      =DFvalues(9);
%# 20150107 add Fnum and Fiter from bash
%# 20150113 restore
   Fnum         =DFvalues(10);
   MTnum        =DFvalues(11);
   CLseuil      =DFvalues(12);
%# 20150120
%# 20150123 if nb lines param.txt==16
   try 
       lonmin       =DFvalues(13);
       lonmax       =DFvalues(14);
       latmin       =DFvalues(15);
       latmax       =DFvalues(16);
   catch ME
       disp('bashascii no latlonminmax')
   end
   outputsuffixe='_IWPtot';
    if IWPid==2
        outputsuffixe='_IWPgt9km';
    end
    strRAD='notRADcl'
    if useRADcl==1
        strRAD='RADcl'
    end
    if DFvalues(7)==1
        Nettype ='NEWPR';
    elseif DFvalues(7)==2
        Nettype = 'FEEDF';
    elseif DFvalues(7)==3
        Nettype = 'CLASSIF';
    elseif DFvalues(7)==4
        Nettype = 'PATTER';
    else
        Nettype = 'none';
        break
    end

%///////////////////////
%2. Training fcn type
%///////////////////////
    %# 20150410 trainFcn new parameter : switch GD or SCG for trainFcn in NNET_proc_plot 
    %# 20150413 test traingda, gdm, gdx
    trainFcn='LM'; %'SCG'; %'GDX';%'SCG'; %'GDM'; %'GDA';%'SCG'; %'GD';%IWPcl_L2ma=14 (POD cut); but 1D fitting overestimates
%# 20150410 restore 'SCG'
    trainFcn='SCG';

%///////////////////////
%3. switches 
%///////////////////////
    polyF=1;
    applypreproc=0;
    applylinfit=0;
    Smallclass=1;
    postclassif=0;
    statstoolicense=1;
    RADsmooth=0;
    MINDISTmethod=0;
    KNNmethod=0;%1
%# 20150227 try with nearest RADS !!!!!
    useRADavg= 0;%1;%0;
%# 20150120 try 15km
%# 20150227 use 05km
%# NB : global ascii files for F RASTA and M MTSAT data have the nearest values MTSAT vs RASTAspot (corrected of Pallax and timedelay of +15mins)
%and avged RADS over lxl km : 05,10,15,20,30km
    RADSneighbor=10;%5;%15;%20;%0;
    decompose='overall';%'byF';
    PredicPixels='Pixeldata';%'Fullsample';%'Pixeldata';

    switch Part
        case 'PartA'
            ClassDepth='partA';%'binary';
        case 'PartB'
            ClassDepth='partB';%'more';
    end
    %# 20150306 : beware : IWPcutoff is a fcn !!!
    %# 20150309 cutoffIWP
    cutoffIWP='Off';%'Off';

    %--- processing types
    %20141125 6pm: for methods 2 nd 3 : trainingffct has to be 'none'
    trainingfct='log';%'none';%'2log';%'log';/// make_training&predic ///
%# 20150415 if trainFcn=='LM'-> try 2log
    if strcmp(trainFcn,'LM')==1
        trainingfct='none';
    end
    Trangecase='full';%'HLM'%'full';%'HLM';
    Prangecase='Floop';
    %# 20141223 use aso Floop for PartB
    %# 20140107 use LMIWP
    %# 20150127 use HIWP : R1<=1.6
    switch Part
        case 'PartA'
            filterIWPflag='Off';%HIWP';%'Off';%'Floop';%'LMIWP';%'Floop';%'LMIWP';%'Floop';
        case 'PartB'
            filterIWPflag='HIWP';%'Floop';%'HIWP';
    end

    setTfilter='Off';%'On'    /// make_trainingset ////
    settingTP='fullpart';%'onlysetP';'partfull';%'fullfull';
    %# 20150203 TESTOPER in make_tr,prFloop
    TESTOPER='Opera'%TEST
    %# 20150526
    IWPtype='Classes';

    %--- physical parameters
    %--- seuil pour cas nuageux
    cloudythresh=2E3;%2E3;%500;%1000;%300;%500;%400;%300;%1000; %used here to define thresholds
    RADsigseuil =1.;          % ///filterIWP///
    IWPseuil    =0;               % ///filterIWP///
    IWPstep     =5E2;%1E3; %500;%200;%500;%1000;        % ///CLASSIF for thresholds///
    IWPstepLow  =400;
    IWPstepHigh =50;
    %%% below not used anyway !!!
    switch trainingfct
        case {'log','2log','3log'}
            maxIWPallowed=1.3E4;%9E3;
        case 'none'
            maxIWPallowed=1.8E4;%1.4E4;
    end
    pivotIWP=5E3;%2E3;
    borneSup=15E3;%1.8E4;%14E3;%12E3;%14E3;%12E3;
    %# 20150324 need IWPclmax>8
    thePODcut=0.5;%0.75;%0.65;
%
    switch ClassDepth
        case 'partA' 
%////////////////////////////////////
%6. NBcla, PODcutoff and threshvect
%////////////////////////////////////
%# 20150416 applyUnif in parametrization
applyUnif = 1;  
         %#//////////////////////////////////////////////////////////////////
         %# 20150326 define clearly here the different acceptable NNET setups
         % params = <NBcla, cutoffIWP(POD>PODcut), fewercls(group IWPcls)>
         % EXP for unif distrib IWP is in unifdistribIWP
applyOutput=1;
%%%% 2 setups work well and stable : patches, big cells, tiny cells detection and close to same results %%%
setupA = 'SCG250e31cl';  %%-->NNETsetup='31c'
setupB = 'LM495e06cl';   %%-->NNETsetup='6'
setupB2 = 'LM495e06clRound';
setupC = 'SCG250e16cl';  %%-->NNETsetup='16c'
setupD = 'SCG250e10cl';  %%-->NNETsetup='10'
setupD = 'LM07';  %%-->NNETsetup='10'
setupF = 'LM05';  %%-->NNETsetup='05'
setupG = 'LM04'
setupH = 'SCG04'
setupCNS = 'SCGcontinuous'
%% setupB is the one : LM06cl03HLlog800expOutputfcn %%%
setup=setupA;
setup=setupB;
setup=setupCNS;
%setup=setupB2; %# 20150526 Input = round(Radj*1E4) no log
%setup=setupD;
%%%setup=setupC;
%setup=setupF;
%setup=setupG;
%setup=setupH;
switch setup
    case setupA
        NNETsetup= '31c';
    case setupB
        NNETsetup= '6';
    case setupB2
        NNETsetup= '6';
    case setupC
        NNETsetup= '16c';
    case setupD
        NNETsetup='7'; %'10';
    case setupF
        NNETsetup='5';
    case setupG
        NNETsetup='4';
    case setupH
        NNETsetup='4';
    case setupCNS
        NNETsetup='1000'; 
end
%        NNETsetup= '6'; %'31c'; %'6';%'31b';%'5';%'4';
         switch NNETsetup
             case '4'
                 NBcla=4;
                 cutoffIWP='Off';
                 cutoffSTR='';
                 fewercls=0;
                 trainFcn='SCG'%%'LM';
                 trainingfct='log';
             case '5'
                 NBcla=5;
                 cutoffIWP='Off';
                 cutoffSTR='';
                 fewercls=0;
                 trainingfct='log';
                 trainFcn='LM';
             %# 20150415;
             case '6'
                 NBcla=6;
                 cutoffIWP='Off';
                 cutoffSTR='';
                 fewercls=0;
                 trainFcn='SCG';%'LM'; %'CGP'; %'LM';
                 %# 20150416-6pm
                %if strcmp(setup,setupB)==1
                %     trainingfct='log';
                % else
                %     trainingfct='round';
                % end
                %# 20150526 to se if improves Training:cancel unifromize IWPdistrib
                 %%%applyUnif=0;  
                 %%applyOutput=0;
             case '7'
                 NBcla=7;
                 cutoffIWP='Off';
                 cutoffSTR='';
                 fewercls=0;
                 trainFcn='SCG'; %'CGP';%'LM';
                 trainingfct='log';
                 %%%%%applyUnif=0;
             %# 20150415;
             case '10'
                 NBcla=10;
                 cutoffIWP='On';
                 cutoffSTR='';
                 fewercls=1;
                 trainFcn='LM';
                 trainingfct='log';
             %# 20150429 '16c'
             case '16c'
                 NBcla=16;
                 cutoffIWP='On';
                 cutoffSTR='PODcutoff';
                 fewercls=1;
                 trainFcns='SCG' ;
             case '31a'
                 NBcla=31;
                 cutoffIWP='Off';
                 cutoffSTR='';
                 fewercls=0;  
             case '31b'
                 NBcla=31;
                 cutoffIWP='On';
                 cutoffSTR='PODcutoff';
                 fewercls=0;
             case '31c'
                 NBcla=31;
                 cutoffIWP='On';
                 cutoffSTR='PODcutoff';
                 fewercls=1;
                 %# 20150417 try other than SCG
                 trainFcns='SCG' ;%'CGB';%'SCG';%'OSS';%'CGB';%'BFG';%'CGF';%'CGP';
                 applyOutput=0;%1;%0; ==0-> output fcn is just round(Y); ==1-> outputfcn is round(Y+alpha) alpha=-0.5 if IWP<4500 & alpha=0.8 if IWP>4500
                 %%applyUnif=0;%it fails 
              case '1000'
                 NBcla=1000;
                 cutoffIWP='On';
                 cutoffSTR='PODcutoff';
                 fewercls=1;
                 %# 20150417 try other than SCG
                 trainFcns='SCG';
                 applyOutput=0;
                 IWPtype='continuous';%'Real';
         end
         %#//////////////////////////////////////////////////////////////////
         cloudythresh=CLseuil; %5kg/m2
         switch NBcla
             case 2
                 threshvect=[0 cloudythresh  4E4];
             case 3
%                threshvect=[0 cloudythresh 5*cloudythresh 2E4];
             case 4
              threshvect=[0 1E3 3E3 6E3 4E4];  
              %threshvect=[0 2E3 4E3 6E3 4E4]; %all between Ã2-4kg on F11MT3
              threshvect=[0 1E3 4E3 8E3 4E4];
              % cutoffIWP='Off';
             case 5
                %threshvect=[0 1E3 2E3 3E3 5E3 4E4];              
                threshvect=[0 1E3 2E3 4E3 8E3 4E4];
             case 6
                %# 20150423 change threshvect from fcn_ecdfIWP result
                threshvect=[0 0.6E3 1.7E3 3E3 4.5E3 6.4E3 4E4];
                %# 20150423 change threshvect
                %threshvect=[0 1E3 2E3 3E3 5E3 8E3 40E3]
                %# 20150428 restore these classes
                %threshvect=[0 1E3 2E3 3E3 4E3 5E3 4E4];
             case 7
             %  threshvect=[0 1E3 2E3 3E3 4E3 5E3 6E3 4E4];
              % threshvect=[0 0.6E3 1.7E3 3E3 5E3 8E3 13E3 4E4];
                threshvect=[0 0.6E3 1.7E3 3E3 5E3 7E3 15E3 4E4];
             case 10
               % threshvect=[0:1E3:12E3 16E3 4E4];
                threshvect=[0 500 1E3 2E3 3E3 5E3 8E3 12E3 4E4];
               %% threshvect=[0:8E3 10E3 12E3 16E3 4E4];
             case 16
                threshvect=[0:1E3:15E3 4E4];
              %  cutoffIWP='Off';
             case 31
%# 20150120 : tt>1.5E4-> CLfinal
                 threshvect=[0:IWPstep:1.5E4 4E4];
              %# 20150513 test on 31c : fails
               %%%threshvect=[0 600 1700 3E3 4.5E3 6.5E3:IWPstep:1.5E4 4E4];
%# 20150227 since POD<75% IWP>4.5kg
%%%                threshvect=[0:IWPstep:5E3 4E4];%pas bon
%# 20150320 : 31cl better     
%                threshvect=[0:1E3:1.5E4 4E4]; 
               %  cutoffIWP='On';%'Off';%'On';
             case 100
                 threshvect=[0:100:1E4 3E4];
             case 1000
                 threshvect=linspace(0,33000,2000);%1000)
                 
         end
         %20150102
           [minloc,AlocpivotIWP]=min(abs(threshvect-pivotIWP));
        case 'partB'
            threshvect=[0:1E3:borneSup];
            [minloc,BlocpivotIWP]=min(abs(threshvect-pivotIWP));
        case 'more'
            threshvect=[0 floor(cloudythresh/2) cloudythresh 1E3:IWPstep:maxIWPallowed];%fails on F06MT23
        case 'binary'
           threshvect=[0 cloudythresh  maxIWPallowed];%0/1 2cl
    end
    NBcla=numel(threshvect)-1;
    thresholds=threshvect
    %%%20141218
    if strcmp(Part,'PartA')==1
        thresholdsA=thresholds;
    elseif strcmp(Part,'PartB')==1
        thresholdsB=thresholds;
    end
    %
    bornesup=2E5;                %NB:bar requires nelet<3E4...
    fullmax=bornesup;            %max range T,Psets used in CLASSIF
    RAD1IWPcut=500;              %used in fitlerIWP to build RefSet
    breakpt1=7.4E3; breakpt2=1E4;%used in make_training and make_predic
    %ROI size around RASTAtrack
    %# 20150413 1->2
    ddegre=1; %2; %1;%0.5;
    %# 20150504 set ddegre to 0 if lonlatminmaxare read in bash.txt
    if exist('lonmax')
        ddegre=0;
    end
    Frank=Fnum;
    %# 20150130 
    nbdup=0;
    dupstring='';
 
    %%%20141218 need to register NBcla to shift PArtB Vgroup--> VPixelR1-4 --> VPixel_data --> MPixel
    if strcmp(Part,'PartA')==1
        NBclaA=NBcla
    end
