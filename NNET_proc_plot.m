%%%20141205 cal Train & Simu on training_data (4RADS) & group (known IWP_flags) and simu part.
   %%%% 1) define network type
clear net
clear POD; clear BIAS; clear FAR
clear lindata;

%/////////////////////////////////
%1. 20150423 use fcn_ecdfIWP
%/////////////////////////////////
%%cut IWP in regularly space intervals
%IWPthreshs = fcn_ecdfIWP(IWP,NBcla)
%pause

%/////////////////////////////////
%2. define neuralnetwork : 
%   trainFcn, type, nbHL,
%   nbepochs 
%/////////////////////////////////

switch Nettype
    case 'FEEDF'
        Nbhidden=1;
        net.trainParam.min_grad=1E-5;
        net = feedforwardnet(Nbhidden);
    case 'NEWPR'
%       net = newpr(DasInput,TrainOutput,NbInputs);
%# 20150115 use #neurones in HL 
        NbInputs=4;
        nbHL=4;%opt value = nbIN
        net = newpr(data_training(setT,:)',group(setT)',nbHL);
        net.divideFcn = '';                       %# use the entire input for training
        %net = init(net);                          %# init
%# 20150126 increase min_grad
        net.trainParam.min_grad=1E-4;
        %net.trainFcn='trainlm';%ower vals simu
        %net.trainFcn='trainbr';
        %net.trainFcn='trainrp';
    case 'PATTER'
        %# 20150108 test nbHL 8,12
        %# 20150224 6->10 testing 
        %# 20150407 6->9 CV@479/500; ~same cells 3>=kg as with 6HL; lot of artefacts <=2kg/m2
        %# 20150409 add condition on nbRADS
        %% http://www.mathworks.com/matlabcentral/answers/196799-how-to-simulate-default-patternnet-with-feedforwardnet-in-matlab
        %% The code below shows, that patternnet is systemtically outperforms feedforwardnet.
        if nbRADS==4  %%% NB INPUTS %%%
        %# 20150429 test nbHL = 10 for new output
            nbHL= 8; %6 ;%8 ;%6;%8;%6;%16;%8;%12;%10 %actually nb neurones in 1 HL
            if NBcla==16
                nbHL=5;
            end
            %# 20150415 change nbHL if trzainFcn=='LM'
            trainFcn
            if strcmp(trainFcn,'CGP')==1
                nbHL= 8; %works also for 06cl
                if NBcla<10
                    nbHL=8;  %6; %5;  %4;   %3%fails
                end
            end
            if strcmp(trainFcn,'LM')==1 | strcmp(trainFcn,'SCG')==1
                 if NBcla<15
                    %# 20150429 : nbHL =2
                    %nbHL=2;  %%fails on F11,35% 3; %2; %cells>=3kg ok bt Bckgd=1-2 instead of 0-1
                    %nbHL=5; %#20150525 to improve Training 1D T vs O
                    %nbHL=5;
                    nbHL=3;
                    %%%nbHL=4;
                else
                    nbHL=8;   
                end
            end
        elseif nbRADS ==5
            nbHL=6;%7;
            if NBcla==4 | NBcla==5
                nbHL=5;
            end
        else
            break
        end
%       net = patternnet([nbHL nbHL]);
%# 20150423 try (cascad)eforwardnet
       net = patternnet(nbHL);
%       net = feedforwardnet(nbHL);
%# 20150505 try cascadeforwardnet(nbHL)
%%%        net = cascadeforwardnet(10);
        %# 20150415 restore init
        net = init(net);                         %# init
%# 20150203 use odd/even indices
%# 20150226 restore : test 70 50, 30%for Trainratio
%NB : start to see difference in results from trainRatio<60/100
%# having less and less variation and missing Target trends as trainRatio decreases 
%# 20150304 deactive for testing
%# 20150410 Hinton's paper "Improving neural networks by preventing co-adaptation of features detectors
%        net.divideParam.trainRatio = 70/100;%80/100; %50/100; %70/100;
%        net.divideParam.valRatio   = 15/100;%10/100; %25/100; %15/100;
%        net.divideParam.testRatio  = 15/100;%10/100; %25/100; %15/100;
%# 20150414 80,7,13 --> 70,10,20
%# fix this part http://www.mathworks.com/matlabcentral/answers/14510-setting-input-data-division-ratio
        net.divideParam.trainRatio = 70/100; %80/100;
        net.divideParam.valRatio   = 15/100; %7/100;
        net.divideParam.testRatio  = 15/100; %13/100;
        tRatio = net.divideParam.trainRatio*100;
%
%# 20150410 add mu
        net.trainParam.min_grad=1E-5;

    %--- b) sampling type ---
        %# 20150303
       if NBcla>1000
           net.divideFcn='dividerand';  %valeur par defaut 
       else
           net.divideFcn='divideint';  %ce choix impacte les résultats!! ran:IWPhigher but noisy; int: IWPloaer but regular patches in images
       end
end

   %--- c) nb epochs ---
   %# 20150413 500-->1000
   net.trainParam.Epochs=1000; %500 ;%100;%50%1000;
   clear Y
%%%20150109 add case classify 


%/////////////////////////////////
%3. TRAINING 
%/////////////////////////////////
switch Nettype
   case {'FEEDF';'NEWPR';'PATTER'} 
   %# 20150410 change trainFcn
   %%%TrainFcn='GD'; %defined in parametrization
   switch trainFcn
       case 'GD'
           net.trainFcn='traingd';
       case 'SCG'
           net.trainFcn='trainscg';
       case 'GDA'
           %# 20150413
           net.trainFcn='traingda';
           net.trainParam.lr_inc=1.02;%1.5;
           net.trainParam.lr_dec=0.9;%0.5;
       case 'GDM'
           %# 20150413
           net.trainFcn='traingdm';
           net.trainParam.min_grad=1E-6;
       case 'GDX'
           %# 20150413
           net.trainFcn='traingdx';
           net.trainParam.min_grad=1E-6;
       case 'LM'
           %# 20150413
           net.trainFcn='trainlm';
       case 'CGP'
           %# 20150417
           net.trainFcn='traincgp';
       case 'CGF'
           %# 20150417
           net.trainFcn='traincgf';
       case 'CGB'
           %# 20150417
           net.trainFcn='traincgp';
    end

       %# 20150414 introduce the sampling here for training
       %subset=1:size(setT);
       clear subset
       subset=1:size(setT);
       numel(subset)
       whos setT
       %# 20150415
       %setTP = setT(1:2:numel(setT));
       %# 20150423 use setTP to filter IWP>12kg
       %setTP=setT;
      whos group
       clear setTP
       setTP = setT;
       whos setT
       whos setTP  
%%%%%%%%%%%%%%%%%
       %# group conformant avec data_training training with error=1E-1
       %# 20150423 setT-->setTP
       [net,tr,Y,E]=train(net, data_training(setTP,:)', group(setTP)');
%%%%%%%%%%%%%%%%%
       %# 20150415--> setTPneed to change all following occurancies of setT afterwards !!!
       %# 20150303 check indices
       %# 20150414
       net.divideParam
       tr.trainInd(1:100)
       tr.valInd(1:100)
       tr.testInd(1:100)
       numel(tr.trainInd) %->70%
       numel(tr.valInd)   %->15%
       numel(tr.testInd)  %->15%
       %to be used in 5. Testing part!

%/////////////////////////////////
%3. X and TARGET renamed 
%/////////////////////////////////         
       Xinputs = data_training(setTP,:)';
       %# 20150227 IWPcl used in PODseuils
       %# 20150423 setT-->setTP
       IWPcl=group(setTP)';
       whos IWPcl


%# 20150522 initialize outshift1,2,beta
Outshift1=0.; Outshift2=0.; Beta=0.;
IWPpivot=0;  R1seuil=0;

%/////////////////////////////////
%4. OUTPUT with activation fcn 
%/////////////////////////////////
       %--- b) ---
%# 20150417 write and use output_function
%      YTP = output_function(Y);
%       Y = YTP;
       %if strcmp(trainFcn,'LM')==0
       %    Y(Y<0)=0;
       %    Y=round(Y);
       %# 20140423 Y->E(Y+alpha) output fct
       %% Y=IWPcl <--> IWP vals : threshvect(Y)  
       %# 20150429 just for testing
       %applyOutput=1; %defnied in parametrization
       %if (strcmp(trainFcn,'LM')==1 & NBcla==6) & applyOutput==1
       %# 20150504 add NBcla==10
       %%%
       %# 20150522 Outfcn for 05cl 0-1/1-2/2-4/4-8/8-40kg.m-2
       %%%
       %2D and 1D results better when not applying out fcn !!!!!
       %%%
       if NBcla==99 & applyOutput==1  %%very noisy Training O T on 5E4-6E4 and cells much smaller
            YT=round(Y);
            YT(YT<0)=0;
            YT(YT>NBcla-1)=NBcla-1;
            IWPpivot=7.E3;
            Outshift1=0.45;  
            Outshift2=0.50;
            %%-- a) IWPlevel below IWPpivot
            %%Aset = find(threshvect(YT+1)<IWPpivot);
            %%Y(Aset)=round(Y(Aset)-Outshift1);
            %%-- b) IWPlevel above IWPpivot
            Bset = find(threshvect(YT+1)>=IWPpivot)
            Y(Bset)=round(Y(Bset)+Outshift2);
            Y=round(Y);
            Y(Y<0) = 0;
            Y(Y>NBcla-1)=NBcla-1;
      %# 20150522
      %# 20150525 donot apply ecdf correction
      elseif (NBcla==6 | NBcla==7) & applyOutput==1
      %elseif (NBcla==99 | NBcla==7) & applyOutput==1
            YT=round(Y);
            YT(YT<0)=0;
            %# 20150504 !!!
            YT(YT>NBcla-1)=NBcla-1; 
%%retrouver param of CDDF_...ADBseets.png 17:20 23april
%           clear Aset Bset Cset YT
     %%%%% GOOD output function ! %%%%
%# 20150520 change IWPpivot 4.5E3->3E3
            IWPpivot=4.5E3;%4.5E3;
            %# 20150504
            %IWPpivot=4E3;
            if applyUnif==0
                IWPpivot=600.;
            end
%%%# 20150513 reduce alpha to have HISTplot_diffs better in middle class 1-5kg
            Outshift1=0.15; %goodwith fiormula 1 
            Outshift1=0.20; %0.5;
            Outshift2=0.55; %0.45; %0.8  %0.8;
            %# 20150520
            Outshift1=0.18;
            Outshift2=0.6;
            %# 20150521
            Outshift1=0.48;
            Outshift2=0.6;
            %# 20150522
            Outshift1=0.2;
            Beta=0.5;
            Outshift2=0.6;
            %# 20150522-6pm
            Outshift1=0.18;
            Beta=0.;
            Outshift2=0.6;

            if NBcla==7
                IWPpivot=4E3;
                Outshift1=0.5;
                Outshift2=0.8;
            end
            %%-- a) IWPlevel below IWPpivot
            Aset = find(threshvect(YT+1)<IWPpivot);
            for ind=1:numel(Aset)
                %# 20150519 formula 1%
                IWPOtmp = threshvect(YT(Aset(ind))+1);
                %% IWPlevel below IWPpivot
                Y(Aset(ind))=round(Y(Aset(ind)) - (IWPpivot-IWPOtmp)*1E-3*Outshift1 );
                %Y(Aset(ind))=round(Y(Aset(ind)) - (Beta+(IWPpivot-IWPOtmp)*1E-3)*Outshift1 );
                %Y(Aset(ind))=round(Y(Aset(ind)) - (Beta+(IWPpivot-IWPOtmp)*0.5*1E-3)*Outshift1 );
            %    Y(Aset(ind))=round(Y(Aset(ind)) - (1+(Beta+(IWPpivot-IWPOtmp)*1E-3))*Outshift1 ); %--> all median diffs Boxplot =0
                %% Y(Aset(ind))=round(threshvect(Y(Aset(ind))+1)-(IWPpivot-threshvect(Y(Aset(ind))+1)/1000*Outshift1));
            end
            %# 20150521 test again
            %# 20150522 use alpha*(1+(beta+(Iref-I)/1E3))
         %  Y(Aset)=round(Y(Aset)-Outshift1);

            %%-- b) IWPlevel above IWPpivot
            Bset = find(threshvect(YT+1)>=IWPpivot)
            Y(Bset)=round(Y(Bset)+Outshift2);
%            disp('Bset')
%            Bset
%            for ind=1:numel(Bset)
%                clear IWPOtmp
%                IWPOtmp = threshvect(YT(Bset(ind))+1);
%                disp('min max IWPOtmp')
%                %min(IWPOtmp)
%                %max(IWPOtmp)
%                %pause
%                %Y(Bset(ind))=round(Y(Bset(ind)) - (IWPOtmp-IWPpivot)*1E-3*Outshift2 );
%                Y(Bset(ind))=round(Y(Bset(ind)) + (IWPOtmp-IWPpivot)*1E-3*Outshift2 ); 
%            end
            Y=round(Y);
            Y(Y<0) = 0;
            Y(Y>NBcla-1)=NBcla-1;%20150429
            %# 20150505 correction fr pts : IWPclO==0 & Xinputs<1. 
            whos Y        %1xsize2
            whos Xinputs  %4xsize2
            %# 20150505 
            R1seuil=0.9 ;%0.7;
            %Badpts = find(Y(Xinputs(1,:)<=log(R1seuil+1E-5))<=1)
            Badpts = find((Y(1,:)<=1) & (Xinputs(1,:)<=log(R1seuil+1E-5)) )
disp('numel badpts')
numel(Badpts)
            if numel(Badpts)>1
                whos IWPcl
                Y(1,Badpts)=IWPcl(1,Badpts);%%%%Xinputs(1,Badpts);  %NBcla-1;
            end
            clear Aset Bset Cset YT Badpts
       elseif NBcla==8  & applyOutput==1
            YT=round(Y);
            YT(YT<0)=0;
            YT(YT>NBcla-1)=NBcla-1;
            IWPpivot=3.5E3;
            if applyUnif==0
                IWPpivot=600.;
            end
            Outshift1=0.6;%0.5;
            Outshift2=1.  %0.8;
            Aset = find(threshvect(YT+1)<IWPpivot)
            Y(Aset)=round(Y(Aset)-Outshift1);
            Bset = find(threshvect(YT+1)>=IWPpivot)
            Y(Bset)=round(Y(Bset)+Outshift2);
            Y=round(Y);
            Y(Y<0) = 0;
            Y(Y>NBcla-1)=NBcla-1;
            clear Aset Bset Cset YT
       elseif NBcla==31 & applyOutput==1
            OutCoef = 2.5; %1.5; %4.2;
            YT=round(Y);
            YT(YT<0)=0;
            %# 20150504 !!!
            YT(YT>NBcla-1)=NBcla-1;
            Ypivot = 8; %9
            Y = round(Y + (YT-Ypivot)/(NBcla-Ypivot)*OutCoef);
            %Y = round(Y + (YT-Ypivot)/(20-Ypivot)*OutCoef);
            Y(Y<0) = 0;
            Y(Y>NBcla-1)=NBcla-1;%20150430
            clear YT
       elseif NBcla==16 & applyOutput==1
            OutCoef = 4;
            YT=round(Y);
            YT(YT<0)=0;
            Ypivot = 4;
            Y = round(Y + (YT-Ypivot)/(NBcla-Ypivot)*OutCoef);
            Y(Y<0) = 0;
            Y(Y>NBcla-1)=NBcla-1;%20150511
            clear YT
       else
            Y(Y<0)=0;
            Y(Y>NBcla-1)=NBcla-1;%20150511
            Y=round(Y);
       end
       %%NB : le code fonctionnen qd meme si on garde Y sans prendre round(Y)
       lindata=Y;
       %# 20150409
       %--- c) stats-_ONED_training : scatter plot IWPcl_L0 0:30 real  output ---
       whos Y
       whos IWPcl
       Y(1:100)
       IWPcl(1:100)
       %pause


%////////////////////////////////
%4. A posteriori Y correction
%////////////////////////////////
%# 20150525
%alpha=1;
%%%%
%for NN=1,NBcla
%%%%%
%   %%%thisIWPclass = find(threshvect(Y)>=NN & threshvect(Y)<NN+1 );
%    thisIWPclSet = find( Y==NN-1 );
%    whos Y
%    whos IWPcl
%    whos RAD1
%    whos thisIWPclSet
%%   AA = Y(thisIWPclSet);
%%    BB = IWPcl(thisIWPclSet);
%%    CC = RAD1(thisIWPclSet);
%    AA = Y'
%    BB = IWPcl'
%    whos BB
%    whos AA
%    whos CC
%    RAD1_mean(NN,1)
%    RAD1_sigma(NN,1)
%%   Badpoints = find( (AA'~= BB') & ...
%%                      (CC<RAD1_mean(NN,1)-alpha*RAD1_sigma(NN,1) | CC>RAD1_mean(NN,1)+alpha*RAD1_sigma(NN,1)) )
%        %             (RAD1(thisIWPclSet) < RAD1_mean(NN,1) - alpha*RAD1_sigma(NN,1) | ...
%        %              RAD1(thisIWPclSet) > RAD1_mean(NN,1) + alpha*RAD1_sigma(NN,1) ));
%    Badpoints = find( (AA ~= BB) & ...
%                        ));
%
%
%    whos Badpoints
%    if numel(Badpoints)>2
%       for KL = 1:numel(Badpoints)
%          %[MinRaddiff argminRad1 ]=min(abs(RAD1(thisIWPclSet(KL)) - RAD1_mean(:,1) ));
%          %[MinRaddiff argminRad1 ]=min(abs(RAD1(thisIWPclSet(KL)) - RAD1_mean(:,1) ));
%          [MinRaddiff argminRad1 ]=min(abs(CC(Badpoints(KL)) - RAD1_mean(:,1)) );
%          Y(thisIWPclSet(Badpoints(KL))) = argminRad1;
%          clear Badpoints thisIWPclSet argminRad1 MinRaddiff
%       end
%    end 
%%%%%
%end
%%%
     
%////////////////////////////////////////
%5. APPLY DOWNSCALLING ON Y AND IWPcl
%////////////////////////////////////////
%# 20150526 use now downscalled IWP classes :
%% 0-1;1-3;3-6;6-40 = 4classes

%%change threshvect, Y and IWPcl !!!
%IWPgpsref = [0 1E3 4E3 8E3 40E3];
%INDiter=1;
%for GP=1:numel(IWPgpsref)-1
%    currentIWPgpTar = find(IWPgpsref(GP)<=threshvect(IWPcl+1) & IWPgpsref(GP+1)>threshvect(IWPcl+1));
%    currentIWPgpOut = find(IWPgpsref(GP)<=threshvect(Y+1)     & IWPgpsref(GP+1)>threshvect(Y+1));
%    currentN = numel(currentIWPgpOut);
%    whos currentIWPgpTar
%    whos currentIWPgpOut
%    whos IWPcl
%    whos Y
%    whos IWPclgpsTar
%    whos IWPclgpsOut
%%pause
%%   IWPclgpsTar(INDiter + currentN) = IWPcl(currentIWPgpTar);
%%   IWPclgpsOut(INDiter + currentN) = Y(currentIWPgpOut);
%    IWPclgpsTar(currentIWPgpTar)=GP-1;
%    IWPclgpsOut(currentIWPgpOut)=GP-1;
%    INDiter = INDiter + currentN;
%    clear currentN currentIWPgpOut currentIWPgpTar
%end
%whos IWPcl
%whos Y
%whos IWPclgpsOut
%whos IWPclgpsTar
%threshvect = IWPgpsref;
%IWPcl=IWPclgpsTar;
%Y=IWPclgpsOut;
%pause

%/////////////////////////////////
%5. 20150505 STATS1D & BOXPLOTS Y vs Xinputs
%/////////////////////////////////
%%%5.1--- Boxplots_per_IWPclTarget ---
%/////////////////////////////////
if strcmp(IWPtype,'Real')==0
    stats_ONEDtraining;

%# 20150519 BOXPLOTS diff Y vs Xinputs
%per actual IWPlevels
%/////////////////////////////////
    Boxplots_diffs_IWPTO
end

%/////////////////////////////////
%6. TESTING RESULT
%/////////////////////////////////
%http://fr.mathworks.com/help/nnet/examples/wine-classification.html
addpath('./TOOLS/NNET_routines/')
    NNET_rout_tests
rmpath('./TOOLS/NNET_routines/')

%%% switch NNETtype
end
%%%

%# 20150227 call PODseuils : PODvect, FARvect,BIASvect cal & plots
PODseuils;

  
%/////////////////////////////////
%7. PERFS net
%/////////////////////////////////
%#20150108 plot NNET perfs
addpath('./TOOLS/NNET_routines/')
    NNET_rout_perfs
rmpath('./TOOLS/NNET_routines/')


%/////////////////////////////////
%8. OUTPUT 
%/////////////////////////////////
%# 20150428 set this in 4.
%  Y=round(Y);
%  20141210 <0 => 0
%  Y(Y<0) = 0;
   view(net);
   lindata=Y';
   disp('NNET training part completed')
   whos sample_set
   whos Fnumvect
   Fsubset=find(Fnumvect(sample_set)<25);
   nbpts=numel(Fsubset);



%/////////////////////////////
%8. SCORES
%/////////////////////////////
%# 20141217 cal POD when 0/1 classif
       [POD, FAR, BIAS, NBCLreal,NBCLsimu,CLratio, NBcs]=contingency(IWP_flag(sample_set(setP))',lindata);
       disp('Classdpeth binary')
       whos lindata;whos setP; whos sample_set; 
       POD


%/////////////////////////////
%9. PLOT TRAINING T, O, T-O,log(Rads) 
%/////////////////////////////
%# 20150522 call NNET_rout_plot --> plot (1) training "time series" IWPcl & Y on 4 segments : 1-2000; 50,000-52; 120-122; 200-202 
%%%
addpath('./TOOLS/NNET_routines/');
    NNET_rout_plot;  
rmpath('./TOOLS/NNET_routines/');
%%%
disp('end NNET_procs');
