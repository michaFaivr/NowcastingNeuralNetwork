%%%20141217 use NEWPR with 2 parts : (1) 0/1 classif (2) then on 1, more cloudy cases
%%% (1) thesholds_1, data_training_1, net_1, etc
%%% (2) _2 varnames 
    
    %%% start BIGPROCS_SIMU %%%
    %--------------------------------------------
    %<<<<<< Part§8: SIMU PART A 0/1 >>>>>>
    %--------------------------------------------

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %20141202 apply mask to MTSAT images
    % A. read and store pixels pos and 4RADS in arrays
    % B. training set still=training_set
    % C. image: (overlap) black=0/white=1
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    addpath('./TOOLS/');
    %Frank=1; MTnum=2;
    %--> a) cal lon,latmin,max for F,MT spot 
    RASTAascii_id;
    %%% 20141222 save lon,latmin,max
    switch Part
        case 'PartA'
        latminA=latmin;latmaxA=latmax;lonminA=lonmin; lonmaxA=lonmax;
        case 'PartB'
        latmin=latminA;latmax=latmaxA;lonmin=lonminA; lonmax=lonmaxA;
    end
    disp('end RASTAascii_id')

    %--> b) pixel_sample
    %%%20141211 attention : PixeldataRAD=log...log(RADS) as for data_training !
    readstoreMTSAT; %build pixel_sample over selected <F,MT>
    disp('end freadstroreMTSAT')

    %--> c) plot ROI [RASTAmin,max <F,MT>-/+0.5°] RAD1
    MTSAT_plot; %lat,lon,min,max -/+0.5  seems ok
    disp('end MTSAT_plot')

    %--> d) Fullsample = F[(data_sample) Pixel_data]
    %%% PixelRADi --> PixelRADS in readstroreMTSAT
    whos PixelRAD1
    [Fullsample,Pixel_data,Sz1] = make_pixeldata(data_sample, setP, PixelRADS, nbRADS,PredicPixels,Part);
    disp('end make_pixeldata')
    PixelRADS_plot;
    disp('end PixeRADS_plot')

    %--> e) CLASSIFY with Fullsample
    %Classify_MTSATdata;
    whos Fullsample
    whos setT
    whos group
    whos data_training
    whos setP
    whos Pixel_data
    switch Nettype
        case 'CLASSIF'
            switch PredicPixels
                case 'Fullsample'
                    [Vgroup] = classify(Fullsample(setP,:),data_training(setT,:),group(setT));
                case 'Pixeldata'
                    [Vgroup] = classify(Pixel_data',data_training(setT,:),group(setT));
             end
%           whos Vgroup
            disp([min(min(Vgroup)) max(max(Vgroup))])
            whos group
            disp([min(min(group)) max(max(group))])
            whos data_training
            disp([min(min(data_training(setT,:))) max(max(data_training(setT,:)))])
            whos Pixel_data
%            disp([min(Pixel_data(1,:)) max(Pixel_data(1,:))])
%            whos Fullsample
%            disp([min(min(Fullsample(setP,:))) max(max(Fullsample(setP,:)))])
        
        case {'FEEDF','NEWPR','PATTER'}
            %             net.layers{1}.size
            whos Fullsample
            switch PredicPixels
                case 'Fullsample'
                    Vgroup = sim(net,Fullsample);
                case 'Pixeldata'
                    %# 20150402 add datatype==double (not complex) condition
                    if isreal(Pixel_data)
                        Vgroup = sim(net,Pixel_data);
                    else
                        disp('Pixel_data is complex:break')
                        break
                    end
            end 
            AA=Vgroup';
            %%%% APPLY same OUTPUT fcn as in NNET_proc_plot 20150423 %%%%
            %%applyOutput=1;
            %if (strcmp(trainFcn,'LM')==1 & NBcla==6) & applyOutput==1
%            if NBcla==6 & applyOutput==1
%                whos AA
%                VgT = round(AA);
%                VgT(VgT<0)=0;
%                %# 20150504 !!!!
%                VgT(VgT>NBcla-1)=NBcla-1;
%                disp('minVgT maxAA')
%                min(AA)
%                max(AA)
%                whos VgT
%                Aset = find(threshvect(round(VgT+1))<IWPpivot);    
%                %AA(Aset)=round(VgT(Aset)-0.5);
%                AA(Aset)=round(AA(Aset)-0.5);
%                Bset = find(threshvect(round(VgT+1))>=IWPpivot);
%                %AA(Bset)=round(VgT(Bset)+0.8);
%                AA(Bset)=round(AA(Bset)+0.8);
%                Vgroup=round(AA);
%                whos Vgroup
%                %pause
%                Vgroup(Vgroup<0)=0; 
%                Vgroup(Vgroup>NBcla-1)=NBcla-1;  %!!! 20150430
%               clear VgT Aset Bset
            if NBcla<=10 & applyOutput==1
                VgT = round(AA);
                VgT(VgT<0)=0;
                VgT(VgT>NBcla-1)=NBcla-1;
                disp('minVgT maxAA')
                min(AA)
                max(AA)
                whos VgT
                Aset = find(threshvect(round(VgT+1))<IWPpivot);
                AA(Aset)=round(AA(Aset)-Outshift1);
                Bset = find(threshvect(round(VgT+1))>=IWPpivot);
                AA(Bset)=round(AA(Bset)+Outshift2);
                Vgroup=round(AA);
                whos Vgroup
                Vgroup(Vgroup<0)=0;
                Vgroup(Vgroup>NBcla-1)=NBcla-1;  %!!! 20150430
                %# 20150505
                %fix badpts : Vgroup==0 & Pixel_data<=1.
                whos Pixel_data
                %Badpts=find(Vgroup(Pixel_data(1,:)<=log(R1seuil+1E-5))<=1)
                min(min(Pixel_data(1,:)))
                max(max(Pixel_data(1,:)))
                %# 20150506 ok cette methode marche enfin et pas besoin de faire de modifs dans PIXEL_.m
                PTMP=Pixel_data';
                Badpts=find((PTMP(:,1)<=log(R1seuil+1E-5)) & (Vgroup(:,1)<=1) )
                if numel(Badpts)>1
                    Vgroup(Badpts)=NBcla-1
                end
                clear PTMP VgT Aset Bset 
                clear Badpts
            elseif NBcla==31 & applyOutput==1
                YT=round(AA);
                YT(YT<0)=0;
                Ypivot = 8;
                AA = round(AA + (YT-Ypivot)/(NBcla-Ypivot)*OutCoef);
                Vgroup=round(AA);
                whos Vgroup
                Vgroup(Vgroup<0)=0;
                clear YT
            elseif NBcla==16 & applyOutput==1
                YT=round(AA);
                YT(YT<0)=0;
               %Ypivot = 4;
                AA = round(AA + (YT-Ypivot)/(NBcla-Ypivot)*OutCoef);
                Vgroup=round(AA);
                whos Vgroup
                Vgroup(Vgroup<0)=0;
                clear YT
            else
               Vgroup=round(AA);
            end   
            whos Vgroup
            %Vgroup(500:600,1)
            min(min(Vgroup(:,1)))
            max(max(Vgroup(:,1)))
    end
    disp('end sim part')
    %      [Vgroup] = classify(Pixel_data',data_training(setT,:),group);
    %%% SUBIMAGE MTSAT IWP flags
    %--> f) reshape Pixelgroup as PixelRAD1 and plot result
    %# 20150227 use IWPcutoff
    %# 20150320 cancel here
    %if NBcla<10
    %    cutoffIWP='On'
    %end
%# 20150320
%# 20150326 fewercls indirectly set in parametrization
%    fewercls=0;
    switch cutoffIWP
        case 'On'
%            fewercls=1;
            PIXELIWPflag_plotcutoff;
        case 'Off'
%            fewercls=0;
            %# 20150325 use _plot
            PIXELIWPflag_plot;
%            %PIXELIWPflag_plotcutoff;
%            %PIXELIWPflag_plotcontour;
    end

    disp('end PIXELIWPflag')
    %%% plot scan RASTA/MTSAT IWPflag
    %# 20150126
    %# 20150223 C
    %# 20150227 D:IWPcutoff
    switch cutoffIWP
        case 'On'
        %# 20150323 D-->F
        ONED_realpredicF;
        case 'Off'
        %# 20150323 C-->D
        ONED_realpredicD;
    end
    disp('end ONED_rp')
    rmpath('./TOOLS/');
    disp('end BIGPROC_S')
    %%% end BIGPROCS_SIMU partA
    
