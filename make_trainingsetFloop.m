%%%% 21Nov2014 module to create training set for CLASSIFY.m
%%%%%   disp(sample_set(end))
    %%20141128 filter IWP>seuil sur RAD1>=2

%//////////////////////////
%1. BUILD Training set
%//////////////////////////
    switch Trangecase
        case 'HLM'
            training_set=TRefset([1:breakpt1 breakpt2:fullmax]);%pas mal:12% erreurs
        case 'full'
            %# 20150202 dont use fullmax and keep even indices
            %%%%training_set=TRefset([1:fullmax]); %set of indices from globalAscii
            if strcmp(TESTOPER,'TEST')==1
                training_set=TRefset(mod(1:floor(end/2)*2,2)==0);
            else
            %# 20150423 test impact filter IWP>12kg/m2
            %% to be done in previous level in unif_distribIWP
                training_set=TRefset;
                %%%%training_set=TRefset(IWP<12.E3);
            end
    end


%//////////////////////////
%2. INDICES
%//////////////////////////
    %%% 20141128 filtered subset 
    switch setTfilter
        case 'On'
          setT=find(RAD1(training_set)<2 | (RAD1(training_set)>=2 & IWP(training_set)<RAD1IWPcut));
        case 'Off' %THE OPTION TO SELECT
%         setT=find(RAD1(training_set)<10);
          %# 20150126 
%         setT=find(RAD1(training_set)>=0. & RAD1(training_set)<12);
          %# 20150203
          %# 20150423 test IWP<10kg
          setT = 1:numel(training_set);
%          setT=find(IWP(training_set)<12E3)
    end
    disp('max IWP in make_training')
    max(IWP)
    disp('whos setT in make_training')
    whos setT
    %%%% expect data_training rowsxNBRADS %%%
%# 20150129 HOW T MAKE THE CODE FLEXIBLE WR NBRADS?
%**************************************************
%# 20150409 add case nbRADS=5 : RAD1 duplicated
%**************************************************


%//////////////////////////
%3. INPUTS building
%//////////////////////////
if nbRADS==4
    data_trainingT=[RAD1(training_set)';RAD2(training_set)';RAD3(training_set)';RAD4(training_set)'; ...
                    RAD1sig(training_set)';RAD2sig(training_set)';RAD3sig(training_set)'];%matnbRADSxN
elseif nbRADS==5
%   data_trainingT=[RAD1(training_set)';RAD1(training_set)';RAD2(training_set)';RAD3(training_set)';RAD4(training_set)'; ...
%                    RAD1sig(training_set)';RAD2sig(training_set)';RAD3sig(training_set)'];
%# 20150525  use WEIGHTS =flag from uniformdistribALLnewinput
    whos RAD1
    whos WEIGHTS_IwpRad1
    whos training_set
    data_trainingT=[RAD1(training_set)';RAD2(training_set)';RAD3(training_set)';RAD4(training_set)'; ...
                    WEIGHTS_IwpRad1(training_set)'; ...
                    RAD1sig(training_set)';RAD2sig(training_set)';RAD3sig(training_set)'];
end
    if RADsmooth==1
        if nbRADS==4
            data_training=[RAD1smoo(training_set)';RAD2smoo(training_set)';RAD3smoo(training_set)';RAD4smoo(training_set)']; %mat4xN
        elseif nbRADS==3
            data_training=[RAD1smoo(training_set)';RAD2smoo(training_set)';RAD3smoo(training_set)']; %mat4xN
        end
    else
%# 20150129 add R1sig
        data_training=data_trainingT(1:nbRADS,:);
        clear data_trainingT
    end %RADsmoo
    %20141119 *2 for testing
    %data_training=sqrt(log(data_training'+1E-5)+20);%matNx4

%//////////////////////////
%4. LOG PREPROCESSING
%//////////////////////////
    switch trainingfct
        case '3log'
            data_training=log(data_training'+1E-5);%matNx4
            mindata=min(min(data_training));
            data_training=log(data_training-mindata+1);
            clear mindata;
            mindata=min(min(data_training));
            data_training=log(data_training-mindata+1);
        case '2log'
            data_training=log(data_training'+1E-5);%matNx4
            mindata=min(min(data_training));
            data_training=log(data_training-mindata+5)%1;
        case 'log'
            data_training=log(data_training'+1E-5);%matNx4
         %  if strcmp(trainFcn,'LM')==1
         %       data_training=log10(data_training'+1E-5);
         %   end
         case 'round'
             %# 20150526 round
              data_training=round(data_training'*1E4);
        case 'none'
            data_training=data_training';
    end
  
%//////////////////////////
%5. BUILD IWP CLASSES 
%//////////////////////////
  whos data_training
    %training classif set 0/1 IWP vs 0.5kg/m2
    group=zeros(size(training_set))';
    %%%%% build classes for IWPflag %%%%
    %20141118 5pm 0/1 direct
    classvalues=0:length(thresholds)-1;
    %%%20141223 change classvlaues to thersholds
    %%%20150108 go back to previous
%   classvalues=thresholds;
    %NB : IWPcl starts @ 0 !!
    %%% 
    whos thresholds
    whos classvalues
if strcmp(IWPtype,'Real')==1
    IWP_flag(training_set)=IWP(training_set);
    group = IWP_flag(training_set)';

%# 20150526 --- IWPCLASSES --- 
else
    if length(thresholds)>=2
        for cc=1:numel(classvalues)
            try
                classIWP=find(IWP>=thresholds(cc) & IWP<thresholds(cc+1));
                IWP_flag(classIWP)=classvalues(cc);
                clear classIWP;
            catch err
                continue
            end %try
        end%for classes
        %IWP_flag=floor(IWP/1000)*1000;
        %%%20141128 group = TRefset
        %group=IWP_flag(sample_set)';
        group=IWP_flag(training_set)';
        whos group
        %pause
    else
        %where IWP>=500g/m2
        cloudycases=find(IWP(training_set)>=cloudythresh)
        if numel(cloudycases)>=1
            group(cloudycases)=1;
        end
    end %if
%%%
end  %IWPtype
%%%

%//////////////////////////
%6. setT 
%//////////////////////////
    ST=size(training_set,1);%SP=size(sample_set,1);
        switch settingTP
            case 'fullfull'
               %%%full setT & setP
               setT=1:ST; %setP=1:SP;
            case 'partfull'
               %%%opt Tset & Pfullrange
               setT=5E3:ST-1E3; %setP=1:SP; %11.8% diff
            case 'partpart'
               %%%optTset & Prestricted range
               setT=5E3:ST-1E3; %setP=5E3:SP; %11% diff 400g
               %setT=1:ST; setP=5E3:SP;
            case 'predic'
               %%%optTset & Pset /C Tset
               setT=5E3:ST-1E3; %setP=1:8E3; 
            case 'test'
               %%%test
               setT=5E3:ST-1E3; %setP=6E3:8.7E3; %11.8% diff
            case 'onlysetP'
               setP=1:SP;
            case 'fullpart'
               setT=1:ST; %setP=1:floor(SP/2);
            case 'halfhalf'
               setT=floor(ST/2):ST; %setP=5000:floor(SP/2);
        end

