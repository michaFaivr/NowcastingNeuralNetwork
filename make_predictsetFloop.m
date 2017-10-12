%%%% 21nov2014 fo CALSSIFY.m  %%%%
    %%%%%% SAMPLE DATA TO CLASSIFY %%%%%

%/////////////////////
%1. TRAININGSET	
%/////////////////////
    switch Prangecase
        case 'HLM'
           theSubset=[1:breakpt1 breakpt2:fullmax];
           sample_set=PRefset(theSubset);
        case 'full'
           theSubset=[1:fullmax]; sample_set=PRefset(theSubset);
        case 'Floop'
            %20141204 6pm take same as 'HLM'
            if strcmp(Trangecase,'HLM')==1
               theSubset=[1:breakpt1 breakpt2:fullmax];
            else
               theSubset=[1:fullmax];
            end
             %# 20150203 no use of fullmax !
%           sample_set=PRefset(theSubset);
            if strcmp(TESTOPER,'TEST')==1  
                sample_set=PRefset(mod(1:floor(end/2)*2,2)==1);
            else
                sample_set=PRefset;
            end
    end
    %20141203 get subset from MAIN! for Floop
    %sample_set=RefSet(theSubset);   
    %sample_set=PRefset;
    SP=numel(sample_set);
%   setP=size(sample_set,1);
    setP=1:SP;
    whos sample_set
    whos setP
    disp('SP');SP

%# 20150129 1 global vector, then select on 1st dim with nbRADS
%# 20150409 add condition nbRADS ==4 or 5
if nbRADS==4
    data_sampleT = [RAD1(sample_set)';RAD2(sample_set)';RAD3(sample_set)';RAD4(sample_set)'; ...
                    RAD1sig(sample_set)';RAD2sig(sample_set)';RAD3sig(sample_set)'];%mat nbRADSxN
elseif nbRADS==5
    data_sampleT = [RAD1(sample_set)';RAD1(sample_set)';RAD2(sample_set)';RAD3(sample_set)';RAD4(sample_set)'; ...
                    RAD1sig(sample_set)';RAD2sig(sample_set)';RAD3sig(sample_set)'];%mat nbRADSxN
end
    if RADsmooth==1
        %20141120 use RADsmoo 
        if nbRADS==4
            data_sample=[RAD1smoo(sample_set)';RAD2smoo(sample_set)';RAD3smoo(sample_set)';RAD4smoo(sample_set)']; %mat4xN
        elseif nbRADS==3
            data_sample=[RAD1smoo(sample_set)';RAD2smoo(sample_set)';RAD3smoo(sample_set)']; %mat4xN
        end
    else
        data_sample=data_sampleT(1:nbRADS,:); 
        clear data_sampleT 
    end %RADsmooth
    %20141119 *2 
    switch trainingfct
        case '4log'
            data_sample=log(data_sample'+1E-5);%matNx4
            mindata=min(min(data_sample));
            data_sample=log(data_sample-mindata+1);
            clear mindata;
            mindata=min(min(data_sample));
            data_sample=log(data_sample-mindata+1);
            clear mindata;
            mindata=min(min(data_sample));
            data_sample=log(data_sample-mindata+1);
            clear mindata;
        case '3log'
            data_sample=log(data_sample'+1E-5);%matNx4
            mindata=min(min(data_sample));
            data_sample=log(data_sample-mindata+1);
            clear mindata;
            mindata=min(min(data_sample));
            data_sample=log(data_sample-mindata+1);
        case '2log'
            data_sample=log(data_sample'+1E-5);%matNx4 
            mindata=min(min(data_sample));
            data_sample=log(data_sample-mindata+5);%+1
        case 'log'
            data_sample=log(data_sample'+1E-5);%matNx4
        %   if strcmp(trainFcn,'LM')==1
        %        data_sample=log10(data_sample'+1E-5);
        %    end
        case 'round'
             %# 20150526 round
              data_sample=round(data_sample'*1E4);
        case 'none'
            data_sample=data_sample';%matNx4
    end
