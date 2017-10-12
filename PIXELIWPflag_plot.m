%%% 20141209 plot  classified dataset  PIXELdata
%%%Vgroup defined in BIGPROCS_SIMU
whos Vgroup %0/1 vector dim=(setP)+(VPixelR1)
%%%20141218
switch Part
    case 'PartA'
        clear shiftVgroup
        shiftVgroup=0;
    case 'PartB'  %%not used anymore
        shiftVgroup=AlocpivotIWP-BlocpivotIWP;
        thresholds=[thresholdsA(1:AlocpivotIWP-1) thresholdsB(BlocpivotIWP:end)];
end
%%%20141223 noshiftVgroup
VPixelgroup = Vgroup(end-Sz1+1:end,1);
if strcmp(Part,'PartB')
   whos VPixelgroup
   min(min(VPixelgroup)) 
   max(max(VPixelgroup))
   %pause
end
%%%20141218
switch Part
    case 'PartA'
        VPixelgroupA=VPixelgroup;
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
        %pause
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
%%%%%%%%
end

whos VPixelgroup
N1=size(PixelRAD1,1); N2=size(PixelRAD1,2);
whos VPixelgroup
whos PixelRAD1
MPixelgroup=reshape(VPixelgroup,[N1,N2]);
whos PixelLat
whos PixelLon
whos MPixelgroup

%%% plot PIXELgroup image
thefield = flipud(rot90(MPixelgroup));

switch Part
    case 'PartA'
    fignum=20
    case 'PartB'
    fignum=27
end

figure(fignum)
%%%20141223 change zscale
        maxIWPsim=max(max(VPixelgroup));
%       VPixelgroup(10:100);
%        PixelLon(1:10);
        %pause
%        PixelLat(1:10);
%        MPixelgroup(1:10,1:10);
        whos thefield
        A=find(isnan(MPixelgroup));
        if numel(A)>1
           A=-1;
        end
if NBcla<5
    thefield(1,1)=NBcla-1;
end

%# 20150505 LM06cl03HLoutfcn correction for F09M05 and F02M15 white spots in HIWP areas
%# 20150506 proper correction is made in BIGPRCOS_SIMU
%whos PixelRAD1
%flipPRAD1 = flipud(rot90(PixelRAD1));
%whos flipPRAD1
%min(min(flipPRAD1)) 
%max(max(flipPRAD1))
%pause
%[IPIX,JPIX]=find((flipPRAD1 < R1seuil) & (thefield <=1) )
%%[Ibad,Jbad] = find(thefield([IPIX,JPIX]) <=1);
%disp('I,J')
%[IPIX,JPIX]
%whos thefield
%min(min(thefield))
%max(max(thefield))
%thefield(IPIX,JPIX) = NBcla-1; %%not correct yet ...
%pause
%if ~isempty(BADpixels)
%    thefield(BADpixels) = NBcla-1;
%    clear BADpixels
%end


%# 20150415 0-1&1-2--> 0-2=cl0
if NBcla<10
    TP=thefield
    thefield(TP<=1)=0;
end
%
switch Nettype
   case {'FEEDF';'NEWPR';'PATTER'}
        imagesc(PixelLon, PixelLat, thefield)
   case 'CLASSIF'
        imagesc(PixelLon, PixelLat, thefield)
end
        set(gca, 'ydir', 'normal'); hold on
        %--- plot RSTA trajectory ---
        plot(RASTA_LONtrack, RASTA_LATtrack, 'w.', 'linewidth', 1.);
        xlim([lonmin-ddegre lonmax+ddegre])
        ylim([latmin-ddegre latmax+ddegre])
        title([name_input_file_title '%filtered=' sprintf('%i',ratiofiltered) 'PO=' sprintf('%3.2f',POD) 'FA=' sprintf('%3.2f',FAR) 'BI=' sprintf('%3.2f',BIAS) ])
%# 20150121 add coastline
        load coast;
        plot(long, lat, 'k-','linewidth', 1.);

%%%20141212 define proper colorscale
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
        %--- colormap ---
        caxis([0 NBcla])                    %(7)
        ca = colorbar;   
        set(ca,'yTickMode','manual')
        ytop=NBcla ;                        %(6)
        set(ca,'ylim',[0 ytop])
        if NBcla==6
        %%   currentMap=colormap(hsv(NBcla-1));
        %% own's 4colors (NBcla-2)
        currentMap=[1,1,1                   % white
                    135/255,206/255,250/255 % blue-green
                    1,215/255,0             % gold
                    205/255,92/255, 92/255  % indian red
                    0,0,0];
        %# 20150331 white backgd 1st IWPcl
        currentMap(1,:)=[1 1 1];
        colormap(currentMap);              %(5)
        %--- colorbar ---                  %(4)
        set(ca,'ytick',[0.31*ytop 0.51*ytop 0.71*ytop 0.9*ytop])
        %# 20150423 express wr threshvect
        set(ca,'yTickLabel',{[sprintf('%5.1f',floor(threshvect(3)/1E2)/10 ) '-' sprintf('%5.1f',floor(threshvect(4)/1E2)/10 ) ]; ...
                             [sprintf('%5.1f',floor(threshvect(4)/1E2)/10 ) '-' sprintf('%5.1f',floor(threshvect(5)/1E2)/10 ) ]; ...
                             [sprintf('%5.1f',floor(threshvect(5)/1E2)/10 ) '-' sprintf('%5.1f',floor(threshvect(6)/1E2)/10 ) ]; ...
                             [sprintf('%5.1f',floor(threshvect(6)/1E2)/10 ) '-' sprintf('%5.1f',floor(threshvect(7)/1E2)/10 ) ]})
%        set(ca,'yTickLabel', {'2-3';'3-4';'4-5';'5-40'})
        elseif NBcla==7
        currentMap=[1,1,1                   % white
                    135/255,206/255,250/255 % blue-green
                    1,215/255,0             % gold
                    205/255,92/255, 92/255  % indian red
                    139/255,69/255,19/255   % saddle brown
                    0 0 0];
        %# 20150331 white backgd 1st IWPcl
        currentMap(1,:)=[1 1 1];
        colormap(currentMap);              %(5)
        %--- colorbar ---                  %(4)
        set(ca,'ytick',[0.26*ytop 0.42*ytop 0.55*ytop 0.74*ytop 0.93*ytop])
        set(ca,'yTickLabel', {'2-3';'3-4';'4-5';'5-6';'6-40'})
     else 
         h_bar=colorbar('YTick',0:1E3:maxIWPsim,'YTickLabel',0:1E3:maxIWPsim,'YGrid','on');
         grid on
         colorbar
         %# 20150415
         currentMap=colormap(jet);
         %# 20150331 white backgd 1st IWPcl
         currentMap(1,:)=[1 1 1];
         %# 20150415 NBcla==6 : plot from IWPcl>=2kg/m2
         colormap(currentMap);
     end
end        

switch Nettype
   case {'FEEDF';'NEWPR';'PATTER'}
   %# 20150225
   %# 20150326 dvider string
   if applyUnif==1
        print('-depsc', '-r2000',['NNET_PIXELgroupF' sprintf('%02i',Frank) 'MT' sprintf('%02i',MTnum) ...
              '-' sprintf('%i',cloudythresh) 'g' sprintf('%02i',NBcla) 'cl' Nettype trainFcn...
              sprintf('%02i',nbHL) PredicPixels trainingfct 'C' Part sprintf('%02i',RADSneighbor) 'km' ...
              dupstring 'filter' filterIWPflag DIVIDER sprintf('%i',round(divid*100)) 'E-2tR70' Alphastr ])
   else
        print('-depsc', '-r2000',['NNET_PIXELgroupF' sprintf('%02i',Frank) 'MT' sprintf('%02i',MTnum) '-' sprintf('%i',cloudythresh) 'g' sprintf('%02i',NBcla) 'cl' Nettype sprintf('%02i',nbHL) PredicPixels trainingfct 'C' Part sprintf('%02i',RADSneighbor) 'km' dupstring 'filter' filterIWPflag Alphastr])
   end
   case 'CLASSIF'
        print('-depsc', '-r2000',['NNET_PIXELgroupF' sprintf('%02i',Frank) 'MT' sprintf('%02i',MTnum) '-' sprintf('%i',cloudythresh) 'g' sprintf('%02i',NBcla) 'cl' Nettype PredicPixels trainingfct 'C' Part])
end

%# 20150130 a posteriori classes 0/1
whos thefield
if NBcla>3
binthresh=[2E3:2E3:8E3];
figure(111)
for ll=1:numel(binthresh)
    %scanMTSAT    %MTimage
    %IWPflagtrack %RASTA track
    BPIXEL = floor((thefield.*5E2)./binthresh(ll)); %cf 5E2 in threshvect parametrization
    BPIXEL(BPIXEL>1)=1;
    N1=numel(thefield);
    N2=numel(BPIXEL==1);
    pcHIWP=floor(100*N2/N1);
    subplot(2,2,ll)
    imagesc(PixelLon, PixelLat, BPIXEL)
    set(gca, 'ydir', 'normal'); hold on
    title([sprintf('%02i',Frank) 'MT' sprintf('%02i',MTnum) ' MTSAT IWPflag 0/1 . binary class ' ...
           ' % pixels>' sprintf('%i',binthresh(ll)) 'kg/m2' sprintf('%i',pcHIWP) '%' ])
    clear BPIXEL
end
print('-dpng', '-r1000', ['BinaryNNET_PIXELgroupF' sprintf('%02i',Frank) 'MT' sprintf('%02i',MTnum) '-' sprintf('%i',cloudythresh) 'g' sprintf('%02i',NBcla) 'cl' Nettype PredicPixels trainingfct Part sprintf('%02i',RADSneighbor) 'km' filterIWPflag 'EXPunifTucana'])

end
