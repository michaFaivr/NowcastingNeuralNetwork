%%% 20141209 plot  classified dataset  PIXELdata
%%%Vgroup defined in BIGPROCS_SIMU
whos Vgroup %0/1 vector dim=(setP)+(VPixelR1)
%# 20150316
%# 20150320 fewercls in BIGPROC_SIMU!
%fewercls=1%0


%////////////////////////////////////
% 1. parameters
%////////////////////////////////////
strfewer='';
if fewercls==1
  strfewer='strfewer';
end

clear h_bar

%%%20141218
switch Part
    case 'PartA'
        clear shiftVgroup
        shiftVgroup=0;
    case 'PartB'
%%%20141219 shiftV partA->B = AlocpivotIWP-BlocpivotIWP
        shiftVgroup=AlocpivotIWP-BlocpivotIWP;
%%%20141219 shiftV partA->B = AlocpivotIWP-BlocpivotIWP
        thresholds=[thresholdsA(1:AlocpivotIWP-1) thresholdsB(BlocpivotIWP:end)];
end

%////////////////////////////////////
% 2. build VPixelgroup array
%////////////////////////////////////
%%%20141223 noshiftVgroup
%VPixelgroup = Vgroup(end-Sz1+1:end,1)+shiftVgroup;
%%--- a) NBcla classes ---%%
VPixelgroup = Vgroup(end-Sz1+1:end,1);
if strcmp(Part,'PartB')
   whos VPixelgroup
   min(min(VPixelgroup)) 
   max(max(VPixelgroup))
end
%%%20141218
%

%%--- b) cut IWPclasses wr POD>PODseuil ---
switch Part
    case 'PartA'
    %# 20150227 apply IWPcutoff using namelike fcn 
        whos VPixelgroup 
%       VPixelgroupA=VPixelgroup;
        %# 20150316 replace IWPcutoff by fewercls
        if fewercls==0
            [VPixelgroupA,I]=IWPcutoff(VPixelgroup,PODvect,thePODcut);
        else
            %# 20150324 add thePODcut
            [VPixelgroupA,I,newRefIWP]=IWPcutoff_fewercls(VPixelgroup,PODvect,threshvect,thePODcut,NBcla);
        end
        %# 20150324 Iref before grouping IWPcls
        Iref=I;
        PODvect
        if fewercls==1
        %# 20150324 3-->numel(newRefIWP)-1
            I=numel(newRefIWP)-1; %3
        end
        max(VPixelgroupA)
        VPixelgroup=VPixelgroupA;
    %# 20150227 end
    %////////////////////////////
    case 'PartB'
        VPixelgroupB=VPixelgroup;
        clear VPixelgroup;
        %%(a) LIWP filling
        VPixelgroup=VPixelgroupA;
    %%% to adapt when more then 0/1 in PartA: ok
        K=numel(thresholdsA)-2;
        whos VPixelgroupA
        whos VPixelgroup
        whos VPixelgroupB
%%%%%%%%
        %%(b) HIWP fill @ VPA==NBcla-1; 0/1--> 0/{1:10}
%       PW=find(thresholdsA==pivotIWP);
%       FD=find(VPixelgroupA>=PW(1));
%%%20141223 correct here:
       FD=find(VPixelgroupA>=pivotIWP);
       if numel(FD>2)
           VPixelgroup(FD)=VPixelgroupB(FD);
       end
       clear PW,FD
     %////////////////////////////
end %switch

whos VPixelgroup

%////////////////////////////////////
% 3. build MPixelgroup
%////////////////////////////////////
N1=size(PixelRAD1,1); N2=size(PixelRAD1,2);
whos VPixelgroup
whos PixelRAD1
MPixelgroup=reshape(VPixelgroup,[N1,N2]);
whos PixelLat
whos PixelLon
whos MPixelgroup


%////////////////////////////////////
% 4. build thefield
%////////////////////////////////////
%%% plot PIXELgroup image
thefield = flipud(rot90(MPixelgroup));

switch Part
    case 'PartA'
    fignum=20
    case 'PartB'
    fignum=27
end

%////////////////////////////////////
% 5. plot thefield and RASTA track
%////////////////////////////////////
figure(fignum)
%%%20141223 change zscale
        maxIWPsim=max(max(VPixelgroup));
        VPixelgroup(10:100);
        PixelLon(1:10);
        PixelLat(1:10);
        MPixelgroup(1:10,1:10);
        whos thefield
        A=find(isnan(MPixelgroup));
        if numel(A)>1
           A=-1;
        end
maxIWPsim
%# 20150306 thefield(1,1)=NBcla-1 for colorscale full
%# 20150309 disable
%# 20150413 <=5
if NBcla<=5
    thefield(1,1)=NBcla-1
end
switch Nettype
   case {'FEEDF';'NEWPR';'PATTER'}
%# 
        imagesc(PixelLon, PixelLat, thefield)
   case 'CLASSIF'
        imagesc(PixelLon, PixelLat, thefield)
end
        %# 20150413 add caxis
        %caxis([0,NBcla-1])
        set(gca, 'ydir', 'normal'); hold on
        %%plot RSTA trajectory
%# 20150126
        plot(RASTA_LONtrack, RASTA_LATtrack, 'w.', 'linewidth', 1.);
        xlim([lonmin-ddegre lonmax+ddegre])
        ylim([latmin-ddegre latmax+ddegre])
        title([name_input_file_title ' IWPclmax=' sprintf('%i',Iref) '  IWPmax='  sprintf('%i',threshvect(Iref+1)) 'g/m2' ])
%# 20150121 add coastline
%# 20150401 coast line on black
        load coast;
        plot(long, lat, 'k-','linewidth', 1.);

%////////////////////////////////////
% 6. colorbar 
%////////////////////////////////////
maxIWPsim =I ;%I calculated in IWPcutoff

% need to do with plot_map_patch, not with imagesc!!!!
switch trainingfct
    case {'log','2log','3log'}
        cscale='dynacscale';%'fixedcscale';
    case 'none' 
        cscale='dynacscale';
end
switch cscale
     case 'fixedcscale' 
        N=numel(thresholds)
        cmap=colormap(jet(N-6));
        b=cmap
        c=b;
        c=[zeros(1,3);c;ones(1,3)]; %RGB:3cols
        c
        colormap(c);
        h_bar=colorbar('YTick',thresholds(1:end),'YTickLabel',thresholds(1:end),'YGrid','on');
        axis square
        grid on
     case 'dynacscale'
        %--- colorbar ---
        ytop=0;
        if fewercls==1
        %# 20150416 colormap and colorabar as in PIXEL_...plot.m 
        ytop=numel(newRefIWP)-1;  %--1;                      %(5)
        caxis([0 ytop]);  %-1])                %(6)
        ca = colorbar;
        set(ca,'yTickMode','manual')  
        set(ca,'ylim',[0 ytop])
newRefIWP %5levels
        if numel(newRefIWP)==5 %04IWPgps:1st gpe is in white  **** current version
         %% currentMap=colormap(hsv(NBcla-1));
         %% own's 5colors (ytop-1) %# 20150430 chnge saddle brown ot black
            currentMap=[1,1,1                    % white
                        135/255,206/255,250/255  % blue-green
                        1,215/255,0              % gold
                        0,0,0 ];
            colormap(currentMap);                          %(4)
            set(ca,'ytick',[0.42*I  0.65*ytop 0.9*ytop])   %(3)
            set(ca,'yTickLabel', {[sprintf('%4.1f',round(newRefIWP(2)/1E2)/10 ) '-' sprintf('%4.1f',round(newRefIWP(3)/1E2)/10 ) 'kg/m2']; ...
                [sprintf('%4.1f',round(newRefIWP(3)/1E2)/10 ) '-' sprintf('%4.1f',round(newRefIWP(4)/1E2)/10 ) 'kg/m2']; ...
                [sprintf('%4.1f',round(newRefIWP(4)/1E2)/10 ) '-40kg/m2'] })
           %set(ca,'yTickLabel', {'2-3kg/m2';['3-' sprintf('%4.1f',threshvect(Iref+1)/1E3 ) 'kg/m2']; ...
           %                       [sprintf('%4.1f',threshvect(Iref+1)/1E3) '-40kg/m2'] })
        elseif numel(newRefIWP)==6 %05IWPgps:1st gpe is in white
            currentMap=[1,1,1 
                        30/255,144/255,255/255
                        1,215/255,0
                        205/255,92/255, 92/255
                        128/255, 0, 0 ];
            colormap(currentMap);
            set(ca,'ytick',[0.22*ytop 0.41*ytop 0.65*ytop 0.92*ytop])
            %set(ca,'yTickLabel', {'0-1kg/m2';'1-2kg/m2';'2-3kg/m2';['3-' sprintf('%i',round(threshvect(Iref+1)/1E3) ) 'kg/m2']; ...
            set(ca,'yTickLabel', {[sprintf('%4.1f',round(newRefIWP(2)/1E2)/10 ) '-' sprintf('%4.1f',round(newRefIWP(3)/1E2)/10 ) 'kg/m2']; ...
                [sprintf('%4.1f',round(newRefIWP(3)/1E2)/10 ) '-' sprintf('%4.1f',round(newRefIWP(4)/1E2)/10 ) 'kg/m2']; ...
                [sprintf('%4.1f',round(newRefIWP(4)/1E2)/10 ) '-' sprintf('%4.1f',round(newRefIWP(5)/1E2)/10 ) 'kg/m2']; ...
                [sprintf('%4.1f',round(newRefIWP(5)/1E2)/10 ) '-40kg/m2'] })
        %# 20150413 case 4IWPgps
        elseif numel(newRefIWP)==4 %03cls:1st gpe is in white
            currentMap=[1,1,1
                        135/255,206/255,250/255
                        1,215/255,0             
                        0,0,0 ];
            colormap(currentMap); 
            set(ca,'ytick',[ 0.31*ytop 0.6*ytop 0.85*ytop])
            set(ca,'yTickLabel', {'2-3kg/m2';['3-' sprintf('%i',round(threshvect(Iref+1)/1E3) ) 'kg/m2']; ...
                                  [sprintf('%i',round(threshvect(Iref+1)/1E3)) '-40kg/m2'] })
           end  %if numel
           set(ca,'yTickLabelMode','manual')
        %# 20150326 address case fwercls==0
        else 
            h_bar=colorbar('YTick',0:maxIWPsim,'YTickLabel',0:maxIWPsim,'YGrid','on');
            grid on
            colorbar
        end %if fewercls
        grid on
end %switch       

%# 20150310
if useRADavg==0
   RADSneighbor=0;
end


%////////////////////////////////////
% 7. save figure 
%////////////////////////////////////
switch Nettype
   case {'FEEDF';'NEWPR';'PATTER'}
   %# 20150225
   %# 20150326 cutoffSTR in parametrization 
   %# 20150403 change format dpn to depsc
   %# 20150409 name 4000g --> nbRADS'04' or '05'
   if strcmp(IWPtype,'Real')==1
       Alphastr='0';
   end

   if applyUnif==1
        print('-depsc', '-r2000',['NNET_PIXELgroupF' sprintf('%02i',Frank) 'MT' sprintf('%02i',MTnum) '-' 'nbRADS' sprintf('%02i',nbRADS) ...
              '-' sprintf('%02i',NBcla) 'cl' sprintf('%02i',ytop) 'gpes' Nettype trainFcn sprintf('%02i',nbHL) PredicPixels trainingfct 'C' Part ...
              sprintf('%02i',RADSneighbor) 'km' dupstring 'filter' filterIWPflag DIVIDER sprintf('%i',round(divid*100)) 'E-2tR' sprintf('%i',tRatio) cutoffSTR strfewer Alphastr])
   else
        print('-depsc', '-r2000',['NNET_PIXELgroupF' sprintf('%02i',Frank) 'MT' sprintf('%02i',MTnum) '-' sprintf('%i',cloudythresh) 'g' ...
              sprintf('%02i',NBcla) 'cl' Nettype sprintf('%02i',nbHL) PredicPixels trainingfct 'C' Part sprintf('%02i',RADSneighbor) 'km' dupstring 'filter' filterIWPflag  Aplhastr ])
   end
   case 'CLASSIF'
        print('-depsc', '-r2000',['NNET_PIXELgroupF' sprintf('%02i',Frank) 'MT' sprintf('%02i',MTnum) '-' sprintf('%i',cloudythresh) 'g' ...
              sprintf('%02i',NBcla) 'cl' Nettype PredicPixels trainingfct 'C' Part])
end
