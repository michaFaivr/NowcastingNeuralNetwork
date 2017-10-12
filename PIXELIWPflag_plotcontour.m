%%% 20141209 plot  classified dataset  PIXELdata
%%%Vgroup defined in BIGPROCS_SIMU
whos Vgroup %0/1 vector dim=(setP)+(VPixelR1)
%%%20141218
switch Part
    case 'PartA'
        clear shiftVgroup
        shiftVgroup=0;
    case 'PartB'
%       shiftVgroup=NBclaA-1;
%%%20141219 shiftV partA->B = AlocpivotIWP-BlocpivotIWP
        shiftVgroup=AlocpivotIWP-BlocpivotIWP;
%       thresholds=[thresholdsA(1:numel(thresholdsA)-1) thresholdsB(2:numel(thresholdsB))];
%%%20141219 shiftV partA->B = AlocpivotIWP-BlocpivotIWP
        thresholds=[thresholdsA(1:AlocpivotIWP-1) thresholdsB(BlocpivotIWP:end)];
%       disp('thresholds');
%       thresholds
        %pause
end
%%%20141223 noshiftVgroup
%VPixelgroup = Vgroup(end-Sz1+1:end,1)+shiftVgroup;
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
%      PW=find(thresholdsA==pivotIWP);
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
        VPixelgroup(10:100);
        PixelLon(1:10);
        %pause
        PixelLat(1:10);
        MPixelgroup(1:10,1:10);
        whos thefield
        A=find(isnan(MPixelgroup));
        if numel(A)>1
           A=-1;
        end
switch Nettype
   case {'FEEDF';'NEWPR';'PATTER'}
%       imagesc(PixelLon, PixelLat, thefield, [0 maxIWPsim])
%# 20150306       imagesc(PixelLon, PixelLat, thefield)
        contourf(PixelLon, PixelLat, thefield,[4 8 12]);
   case 'CLASSIF'
       imagesc(PixelLon, PixelLat, MPixelgroup)
end
        set(gca, 'ydir', 'normal'); hold on
        %%plot RSTA trajectory
%# 20150126
%        plot(RASTAlon(sample_set(FMT)), RASTAlat(sample_set(FMT)), 'w.', 'linewidth', 1.);
        plot(RASTA_LONtrack, RASTA_LATtrack, 'w.', 'linewidth', 1.);
        xlim([lonmin-ddegre lonmax+ddegre])
        ylim([latmin-ddegre latmax+ddegre])
        title([name_input_file_title '%filtered=' sprintf('%i',ratiofiltered) 'PO=' sprintf('%3.2f',POD) 'FA=' sprintf('%3.2f',FAR) 'BI=' sprintf('%3.2f',BIAS) ])
%# 20150121 add coastline
        load coast;
        plot(long, lat, 'w-','linewidth', 1.);

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
         h_bar=colorbar('YTick',0:1E3:maxIWPsim,'YTickLabel',0:1E3:maxIWPsim,'YGrid','on');
         grid on
         colorbar
end        

%# 20150310
if useRADavg==0
   RADSneighbor=0;
end

switch Nettype
   case {'FEEDF';'NEWPR';'PATTER'}
   %#20150225
   if applyUnif==1
        print('-dpng', '-r2000',['NNET_PIXELgroupF' sprintf('%02i',Frank) 'MT' sprintf('%02i',MTnum) '-' sprintf('%i',cloudythresh) 'g' sprintf('%02i',NBcla) 'cl' Nettype sprintf('%02i',nbHL) PredicPixels trainingfct 'C' Part sprintf('%02i',RADSneighbor) 'km' dupstring 'filter' filterIWPflag DIVIDER sprintf('%i',round(divid*100)) 'E-2tR70contours3'])
   else
        print('-dpng', '-r2000',['NNET_PIXELgroupF' sprintf('%02i',Frank) 'MT' sprintf('%02i',MTnum) '-' sprintf('%i',cloudythresh) 'g' sprintf('%02i',NBcla) 'cl' Nettype sprintf('%02i',nbHL) PredicPixels trainingfct 'C' Part sprintf('%02i',RADSneighbor) 'km' dupstring 'filter' filterIWPflag])
   end
   case 'CLASSIF'
        print('-dpng', '-r2000',['NNET_PIXELgroupF' sprintf('%02i',Frank) 'MT' sprintf('%02i',MTnum) '-' sprintf('%i',cloudythresh) 'g' sprintf('%02i',NBcla) 'cl' Nettype PredicPixels trainingfct 'C' Part])
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
%print('-dpng', '-r1000', ['BinaryNNET_PIXELgroupF' sprintf('%02i',Frank) 'MT' sprintf('%02i',MTnum) '-' sprintf('%i',cloudythresh) 'g' sprintf('%02i',NBcla) 'cl' Nettype PredicPixels trainingfct Part sprintf('%02i',RADSneighbor) 'km' 'rep' sprintf('%i',nbdup) '_' sprintf('%03i',floor(RAD1seuil*100)) 'E-2' filterIWPflag]);
print('-dpng', '-r1000', ['BinaryNNET_PIXELgroupF' sprintf('%02i',Frank) 'MT' sprintf('%02i',MTnum) '-' sprintf('%i',cloudythresh) 'g' sprintf('%02i',NBcla) 'cl' Nettype PredicPixels trainingfct Part sprintf('%02i',RADSneighbor) 'km' filterIWPflag 'EXPunifTucana'])

end
