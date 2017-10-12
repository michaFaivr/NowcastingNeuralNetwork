%%%20141217 use NEWPR with 2 parts : (1) 0/1 classif (2) then on 1, more cloudy cases
%%% (1) thesholds_1, data_training_1, net_1, etc
%%% (2) _2 varnames 


   %%%%START BIGPROCS_TRAIN


%////////////////////////
%1. READ GLOBAL ASCII
%////////////////////////
   %fclose(fileID)
    delimiterIn = ' ';
    headerlinesIn = 1;
    %%% 20141121 use module TOOLS/readdata
    addpath('./TOOLS/');
    readdata;

%////////////////////////
%2. AVG IWP PER MTSAT PIXEL
%////////////////////////
%# 20150310 apply IWPavg wr MTSAT pixel
%# 20150421 deactivate for testing
   AsciiIWPavgMTSAT;

    %# 20150128 duplicate RADs & IWP for RAD1<=1.6
    %# 20150130 duplicate off 1pm
%    duplicate_lowRAD1b;
    %# 20150130 duplicate_HIWP 2pm
%   duplicate_HIWP;
    %# 20150130 6pm
    %# 20150225 disable unif for NBcla3
    %# 20150410 for NNET_setup trainFcn='traingd'--> no unifdistrib;
    %# but IWP sorting is made in TOOLS/unifDistribALL.m
    %# so need to call it anyway

%////////////////////////
%3. ADAPT IWP DISTRIBUTION
%////////////////////////
    %# 20150416 applyUnif in parametrization
%   applyUnif=0;
    if NBcla >=3
%        applyUnif=1;
        %attention : cette routine contient aussi le srting des arrays IWP, RADS1-4 etc !!!!!!!!
        %# 20150526 restore original 
        uniform_distribALL; %from pseudo-gaussian to pseudo-uniform distrib of IWP 
                            %(a) plot histoIWP; (b) transfo DB; (c) histo IWPprime  
        %# 20150525
        %uniform_distribALLnewinput
    end


%////////////////////////
%4. HISTOGRAMS IWP and RADS
%////////////////////////
    %# 20150219 histos IWP vs RAD1 as in E-NNET_TEST
    %   plot_histosR1R4IWP
 
%////////////////////////
%5. DEFINE INDICE SETS
%///////////////////////
    %%%%%%% filter out pts with too high sigmas %%%%%%
    %%%20141127
    %%% switch on IWPseuil for Tpart in PARTB
    [TRefset,PRefset,ratiofiltered]=filterIWP_Floop(RAD1,RAD1sig,RADsigseuil,RAD4, ...
        IWP,IWPseuil,filterIWPflag, ...
        cloudythresh,RAD1IWPcut,Fnum,Fnumvect,pivotIWP,borneSup);
    fullmax=min([size(TRefset,1),bornesup]);
    whos Fnumvect
    rmpath('./TOOLS/');
    whos RefSet

%////////////////////////
%6. TRAINING AND SIMU SETS
%////////////////////////
    %%%%%% SAMPLE DATA TO CLASSIFY %%%%%
    %20141121 in module make_predictset
    %here predic_set is setup in Floop
    %20141204 make_predictsetFloop
    %---> predictset, setP
    addpath('./TOOLS/');
    make_predictsetFloop;

    %%%%%% TRAINING SET FOR CLASSIFY %%%%%
    %20141121 in module make_trainingset
    %20141204 make_trainingsetFloop
    %---> trainingset, setT
    make_trainingsetFloop;
    rmpath('./TOOLS/');


%////////////////////////
%7. TRAINING PART
%////////////////////////
    %---------------------------------------------------------------------------------------
    %<<<<<< Part§2: supervised learning classif 0/1 or 0/1/2  from NNET output of IWP >>>>>>
    %---------------------------------------------------------------------------------------
    %------- B. NETWORK MAKING ---------
    %---===  B1.differnciate NNET types ===---
    %--- b) NNET=newpr:1 ---
    license('inuse')
    switch Nettype
        case {'NEWPR','FEED','PATTER'}
            addpath('./TOOLS/')
%           20150113 use new code
                NNET_proc_plot;
            rmpath('./TOOLS/')
        case 'CLASSIF'
            type_classification='mahalanobis';%'diagquadratic';%'linear';
            whos group
            whos data_training
            %pos--> setP
            addpath('./TOOLS/');
            whos training_set; whos sample_set
            sample_set(1:100)
            whos data_sample; whos data_training
            whos setT; whos setP; whos group
            %20141203 loop sur F->data_sample
            disp('setT end-2:end'); setT(end-2:end)
            disp('setP end-2:end'); setP(end-2:end)
            [lindata,errclassif]=classify(data_sample(setP,:), data_training(setT,:), group(setT),...
                type_classification);
            rmpath('./TOOLS/');
            %%%  end %cases NNETS, CLASSIF
            whos lindata
            %------------------------------------------------------------------------
            %<<<<<< Part§3: from supervised learning classif to 0/1 or 0/1/2   >>>>>>
            %------------------------------------------------------------------------
            %20141121 use shrinkclasses.m but not used yet
            addpath('./TOOLS/');

            %----------------------------------------------------------------------
            %<<<<<< Part§4: FAR,PODBIAS from contingency table on "CS" cases >>>>>>
            %----------------------------------------------------------------------
            %20141126 use IWP_flag'
            [POD, FAR, BIAS, NBcloud, NBcs]=contingency(IWP_flag(sample_set(setP))',lindata);

            %---------------------------------------------------------------------------------------------
            %<<<<<< Part§5: outputs Figures (and .mat) from supervised learning classif 0/1 or 1/1/2   >>>>>>
            %---------------------------------------------------------------------------------------------
            %20141121 use plotting module
            %20141204 set Floop there a posteriori de Classify made once!
            whos training_set
            whos data_sample
            Classify_plotsFloop;
            %disp(goodclmask);

            %--------------------------------------------------------------------
            %<<<<<< Part§6: METHOD1 classify IWPhisto|cl works // cl fails >>>>>>
            %--------------------------------------------------------------------
            histosIWP;

            %-----------------------------------------------------------------------
            %<<<<<< Part§7: METHOD1 classify 4RADS histo|cl works // cl fails >>>>>>
            %-----------------------------------------------------------------------
            %20141126 histos for checking classif results
            histosRAD1; histosRAD2; histosRAD3; histosRAD4;
            statsRADSIWP;
            rmpath('./TOOLS/');
    end %switch Nettype CLASSIF   
    disp('end BIGPROCS_T')
    %%% end BIGPROCS_TRAIN

