function [RAD1,RAD2,RAD3,RAD4,IWP,IWP_flag,] = readascii(Fnum,useRADcl,NbRADcl)
    addpath('./INPUTASCIIS/');
    name_input_file=['globalAsciiRADS_IWP2_' sprintf('%02i',Fnum) '.txt']
    try
       fileID=fopen(name_input_file,'r');
    catch ME
       fprintf('%s\n','input doesnt exist');
       break;
    end
    %fclose(fileID)
    delimiterIn = ' ';
    headerlinesIn = 1;
    if ~exist(name_input_file)
        break;
    end
    %--- b) read data ascii --- 
    A = importdata(name_input_file,delimiterIn,headerlinesIn);
    rmpath('./INPUTASCIIS/')
    Aset=1:floor(size(A.data,1));
    Col1=A.data(Aset,1) %RAD1
    Col2=A.data(Aset,2) %RAD2
    Col3=A.data(Aset,3) %RAD3
    Col4=A.data(Aset,4) %RAD4
    Col1(1:100)
%   pause
    Col5=A.data(Aset,4+IWPid) %IWPtot or >=9km
    %--- c) filter IWP <=0
    RAD1=Col1(Col5>=0);RAD2=Col2(Col5>=0);RAD3=Col3(Col5>=0);RAD4=Col4(Col5>=0);IWP=Col5(Col5>=0);
    %--- d) PREPROCESS DATASET ! ---
    %--- make 10 classes for each RADS:TRAIN INPUTS=RADclass;TO=IWP2class
    %20141029
    NbRADcl=10;
    maxR1=max(RAD1);maxR2=max(RAD2);maxR3=max(RAD3);maxR4=max(RAD4);
    deltaR1=maxR1/NbRADcl;deltaR2=maxR2/NbRADcl;deltaR3=maxR3/NbRADcl;deltaR4=maxR4/NbRADcl;
    %2014128-6pm RAD1,2 delta=0.5 / RAD3,4:delta=0.2
    deltaR=[deltaR1;deltaR2;deltaR3;deltaR4];
    if useRADcl==1
      RAD1 = floor((RAD1+deltaR(1))/deltaR(1))*deltaR(1);
      RAD2 = floor((RAD2+deltaR(2))/deltaR(2))*deltaR(2);
      RAD3 = floor((RAD3+deltaR(3))/deltaR(3))*deltaR(3);
      RAD4 = floor((RAD4+deltaR(4))/deltaR(4))*deltaR(4);
    end
    fprintf('%s\t','RADcl1');fprintf('%d\n',RAD1);
    %--- 20141029 e) weight the data vs density [IWPcl,k]x[RADcl,l] cells !!
    %---> vectors RADi &IWP_flag already have duplicated cells!!
    %define IWP intermediate classes
    %initialize @0
%   IWPcl=1:numel(IWP);
%   IWPcl(:)=0;
%    classvalues=0:NbseuilsIWP;
%    stepIWP=6E3/NbseuilsIWP;
%    thresholds=0:stepIWP:6E3;thresholds=[thresholds 2E4];
%    NbIWPcl=size(thresholds,1);
%    %--- f) build basic vectors (RADS,rho) for T_IN   
%    %-- IWP T1|--> IWPcl T2|--> IWP_flag {1:NbFlags}
%    cal_IWP_RADdensity %cal IWPl & rhoIWR1-4 & newvectRADj,IWP

    %--- g) subssets for TRAIN and SIM 50/50
    Datasize=size(RAD1,1);
    if settype==2
       INsubset=1:floor(Datasize/2);
       SIMsubset=floor(Datasize/2)+1:floor(Datasize/2)*2
       strsettype='50-50';
    elseif settype==1
       INsubset =1:2:floor(Datasize/2)*2;
       SIMsubset=2:2:floor(Datasize/2)*2;
       strsettype='evenodd';
    end
    %--- h) print IWP ----
    fprintf('%s\t','minIWP');fprintf('%d\n',min(A.data(:,5)));
    fprintf('%s\t','maxIWP');fprintf('%d\n',max(A.data(:,5)));
    fprintf('%s\t','minRAD1');fprintf('%d\n',min(A.data(:,1)));
    fprintf('%s\t','maxRAD1');fprintf('%d\n',max(A.data(:,1)));
    fprintf('%s\t','minRAD2');fprintf('%d\n',min(A.data(:,2)));
    fprintf('%s\t','maxRAD2');fprintf('%d\n',max(A.data(:,2)));
    fprintf('%s\t','minRAD3');fprintf('%d\n',min(A.data(:,3)));
    fprintf('%s\t','maxRAD3');fprintf('%d\n',max(A.data(:,3)));
    fprintf('%s\t','minRAD4');fprintf('%d\n',min(A.data(:,4)));
    fprintf('%s\t','maxRAD4');fprintf('%d\n',max(A.data(:,4)));

    RASTA_IWP=IWP;
    fclose(fileID)
    %initialize @0
    IWP_flag=1:numel(RASTA_IWP);
    IWP_flag(:)=0
    classvalues=0:NbseuilsIWP;
    stepIWP=6E3/NbseuilsIWP;
    thresholds=0:stepIWP:6E3;thresholds=[thresholds 2E4];
    %--- 3.6 replace RASTA_IWP by IWP_fitted: DasInput|IWP |--> classIWP ---
    if Smallclass==1
        for cc=1:numel(classvalues)
            try
                classIWP=find(RASTA_IWP>=thresholds(cc) & RASTA_IWP<thresholds(cc+1));
                IWP_flag(classIWP)=classvalues(cc);
                clear classIWP;
            catch err
                continue
            end
        end
    else %not applied
        IWP_flag=floor(RASTA_IWP/2000);
    end
    if size(IWP_flag,1) > size(IWP_flag,2)
        IWP_flag=IWP_flag';
end
