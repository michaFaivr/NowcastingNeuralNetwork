%%% 20141215 plot scan IWPflags real and predic along RASTA track F#MTs#
%%% read globalascii and get vlaues @F,MT
%calcul de latmin,latmaxsur globalascii[smaple_set(FMT)]
%# no need to caculate again FMT made in RASTAascii_id
%%FMT=find(Fnumvect(sample_set)==Frank & MTnumvect(sample_set)==MTnum);
min(Fnumvect(sample_set))
min(MTnumvect(sample_set))

%%ALGO :
%%a) F,MT given as params in main
%%b) find in ascii FMT block and get RASTAdata
%%c) find MTSAT pixels from nc
%%d) plot RSTA & MTSAT scans  

%%%scan plot IWP RASTA scan from glbal ascii and corspind MSTAT
%sample_set(FMT)
switch Part
   case 'PartA'
      figPart=40
%# 20150126 use RASTAIWP_track
%     IWPtrackA=IWP(sample_set(FMT))+1;
      IWPtrackA=RASTA_IWPtrack;     
%#20150203 check 
      whos RASTA_IWPtrack
      IWPtrack=IWPtrackA;
      if NBcla==2
          IWPflagtrackA=floor(IWPtrack./cloudythresh);%from RASTA_IWPtrack in RASTAascii_id
          IWPflagtrackA(IWPflagtrackA>1)=1;
      elseif NBcla==3 | NBcla==4
          IWPflagtrackA=nan(size(IWPtrack,1),size(IWPtrack,2));
          for cc=1:numel(threshvect)-1
              IWPlev=find(IWPtrack<threshvect(cc+1) & IWPtrack>=threshvect(cc));
              if numel(IWPlev>0) 
                  IWPflagtrackA(IWPlev)=cc-1;
              end
          end
      else
          IWPflagtrackA=floor(IWPtrack./IWPstep);
      end 
      whos IWPflagtrackA
      %pause
      IWPflagtrack=IWPflagtrackA;
      FMTok=FMT;
      SFMT=sample_set(FMT);
   case 'PartB'
      figPart=43
      IWPtrack=IWPtrackA;
      IWPflagtrack=IWPflagtrackA;
      FMT=FMTok;
end

%RASTA_IWPtrack(120:130)%IWPs
%pause
%%%20141223 fix IWP_flag=-1500 wr IWP ?? fixed:thresholds(IWP_flag) --> IWP
mean_RASTA_IWP=mean(mean(IWPtrack));
min_RASTA_IWP=min(min(IWPtrack));
max_RASTA_IWP=max(max(IWPtrack));

whos FMT
whos IWPflagtrack

figure(figPart)
%%%%FMT --> RASTA_latitude(sample_set(FMT)) 

whos FMT
whos sample_set
whos RASTAlat
whos PixelLon; whos PixelLat
whos MPixelgroup
PixelLat(1:8)
max(max(MPixelgroup))

%%%% for each pos RASTA, find pixel MTSAT
%%---a--- locate MTSAT local max
%[maxIWP0 agmaxIWP0] = max(max(MPixelgroup));
%agmaxIWP0
%[rmax cmax ] = find(MPixelgroup==maxIWP0)
%PixelLon(rmax)
%PixelLat(cmax)
%%---b--- get closer in lat from RASTA track
%[lmin ijmin] = min(min(abs(RASTA_LATtrack-PixelLat(cmax))));
%%---c--- translate RASTA line
%deltaLat=RASTA_LATtrack(ijmin)-PixelLat(cmax);
%%RASTA_LATtrack=RASTA_LATtrack-deltaLat;

%MTSAT image|track
ILAT=ones(size(FMT,1),1); ILON=ones(size(FMT,1),1);
scanMTSAT=ones(size(RASTA_IWPtrack,1),1);
minIWP=zeros(size(RASTA_IWPtrack,1),1);
maxIWP=zeros(size(RASTA_IWPtrack,1),1);
for ij=1:size(RASTA_IWPtrack,1)
    %%%a) find nearest MTSAT PixelLon,PIxelLat vs RASTA current : posLon,Lat for PixelLon,Lat
    [minlav,argminlav] = min(abs(PixelLat-RASTA_LATtrack(ij)));
    Checklat = RASTAlat(sample_set(argminlav));
    [minlov,argminlov] = min(abs(PixelLon-RASTA_LONtrack(ij)));
    Checklon = RASTAlon(sample_set(argminlov));
whos sample_set
whos RASTAlon
%pause
    %%%b) save closest position
    %-- ir
            ILAT(ij) =argminlav; ILON(ij) =argminlov;
            scanMTSAT(ij)=MPixelgroup(ILON(ij),ILAT(ij));
    %# 20140128 min,maxIWP in neighbor RASTA track
    deltaLat=1E-1;%5E-5; %50km; %1E-1;
    deltaLon=1E-1;%2E-1; %1E-1;
    try 
        %min,max deltaLat appart 
        Lat1 = find(abs(PixelLat-RASTA_LATtrack(ij))<=deltaLat);
        whos Lat1
        Amin=min(min(MPixelgroup(ILON(ij),Lat1)));
        Amax=max(max(MPixelgroup(ILON(ij),Lat1)));
        %min,max deltaLon appart 
        Lon1 = find(abs(PixelLon-RASTA_LONtrack(ij))<=deltaLon);
        whos Lon1
        Bmin=min(min(MPixelgroup(Lon1,ILAT(ij))));
        Bmax=max(max(MPixelgroup(Lon1,ILAT(ij))));
        %
        whos PixelLat
        whos MPixelgroup
        minIWP(ij)=min([Amin;Bmin]) %min(min(MPixelgroup(ILON(ij),Lat1)))
        maxIWP(ij)=max([Amax;Bmax]) %max(max(MPixelgroup(ILON(ij),Lat1)))
        %whos minIWP
        %whos maxIWP
        clear Lat1
    catch ME
        continue
    end
end

%%%20141223 IWP_flag takes thresholds values => no thresholds appled to scanMTSAT
mean_MTSAT_IWP=mean(mean(scanMTSAT));
min_MTSAT_IWP=min(min(scanMTSAT));
max_MTSAT_IWP=max(max(scanMTSAT));

%%20141223 !!!!! fix IWP_flag !!!!!
%%201412226 IWP_flag(sample_set(FMT))->IWPflagtrack
whos scanMTSAT
whos IWPflagtrack
   %# 20150204 sort abscisse wr RASTAspot
   FMTT= find(Fnumvect==Frank & MTnumvect==MTnum);
   [~,index] = unique(RASTAspot(FMTT),'first');
   clear FMT
   FMT=FMTT(sort(index));
   [SRASTAspot,Ispotsort] = sort(RASTAspot(FMT));

%# 20150102 use IWPtrack
%# 20150204 cancel if else
   X=SRASTAspot;
%# 20150204 use Ispotsort
%   Y1=minIWP';
%   Y2=maxIWP';
   Y1=minIWP(Ispotsort);
   Y2=maxIWP(Ispotsort);
   whos X
   whos Y1
   whos Y2

   C=[0,0,0]+0.7;
   %fill_between_lines = @(X,Y1,Y2,C) fill( [X fliplr(X)],  [Y1 fliplr(Y2)], C );
%  fill( [X fliplr(X)],  [Y1 fliplr(Y2)], C ); hold on 
   clear X Y Y2 C
%   plot(1:numel(IWPtrack),scanMTSAT','b',1:numel(IWPtrack),minIWP','r',1:numel(IWPtrack),maxIWP','r',1:numel(IWPflagtrack),IWPflagtrack,'k');hold on
   SRASTAspot
   whos SRASTAspot
   whos Ispotsort
   whos scanMTSAT
   whos IWPflagtrack
%# 20150215 subplot(2,1,2) here
   %--- plot SIMU IWPclasses on RASTA track---
   subplot(2,1,1)
   plot(SRASTAspot,scanMTSAT(Ispotsort)','b')
   xlim([SRASTAspot(1) SRASTAspot(end)]);
   ylim([0 NBcla]);
   title([name_input_file_title '%filtered=' sprintf('%i',ratiofiltered) 'PO=' sprintf('%3.2f',POD) 'FA=' sprintf('%3.2f',FAR) 'BI=' sprintf('%3.2f',BIAS) ])
   %--- plot SIMU IWPclasses on RASTA track--- 
   subplot(2,1,2)
   if NBcla<=3
       plot(SRASTAspot,IWPflagtrack(Ispotsort),'k');hold on
   else
%       plot(SRASTAspot,IWPflagtrack(Ispotsort),'k',SRASTAspot,scanMTSAT(Ispotsort)','b');hold on
        plot(SRASTAspot,IWPflagtrack(Ispotsort),'k','LineWidth',2); hold on
        whos IWPflagtrack
        whos Ispotsort
        plot(SRASTAspot,scanMTSAT(Ispotsort)','b');hold on
   end
   %# 20150204 use SRASTA
   plot([SRASTAspot(1) SRASTAspot(end)],[mean_MTSAT_IWP mean_MTSAT_IWP],'--b'); hold on
   plot([SRASTAspot(1) SRASTAspot(end)],[mean(mean(IWPflagtrack)) mean(mean(IWPflagtrack))],'--k'); hold on
  %# 20150120
   SRASTAspot
   pause
   xlim([SRASTAspot(1) SRASTAspot(end)]);
   ylim([0 NBcla]);
   title({['mean simu IWP' sprintf('%4i',floor(mean_MTSAT_IWP)) '; mean real IWP' sprintf('%4i',floor(mean_RASTA_IWP))]; ...
       ['min simu IWP' sprintf('%4i',floor(min_MTSAT_IWP)) '; min real IWP' sprintf('%4i',floor(min_RASTA_IWP))]; ...
       ['max simu IWP' sprintf('%4i',floor(max_MTSAT_IWP)) '; max real IWP' sprintf('%4i',floor(max_RASTA_IWP))]})

print('-dpng', '-r1000', ['RastaMTSATscan' sprintf('%02i',Frank) 'MT' sprintf('%02i',MTnum) '-' sprintf('%i',cloudythresh) 'g' sprintf('%02i',NBcla) 'cl' Nettype PredicPixels trainingfct Part sprintf('%02i',RADSneighbor) 'km' dupstring 'filter' filterIWPflag ]);

%# 20150130 --- a posteriori 0/1 classif thresholds 2,4,6,8,10kg
if NBcla>2
binthresh=[2E3:2E3:12E3];
figure(111)
for ll=1:numel(binthresh)
    %scanMTSAT    %MTimage
    %IWPflagtrack %RASTA track
    BMT = floor((scanMTSAT.*5E2)./binthresh(ll)); %cf 5E2 in threshvect parametrization
    BMT(BMT>1)=1;
    BRT = floor((IWPflagtrack.*5E2)./binthresh(ll));
    BRT(BRT>1)=1;
    subplot(3,2,ll)
    plot(1:numel(BMT),BMT','b.',1:numel(BRT),BRT,'k^'); hold on
    ylim([-1 2]);
    title([sprintf('%02i',Frank) 'MT' sprintf('%02i',MTnum) 'RASTA ^ & MTSAT . binary class ' sprintf('%i',binthresh(ll)) 'kg/m2'])
    clear BMT BRT
end
%print('-dpng', '-r1000', ['BinaryRastaMTSATscan' sprintf('%02i',Frank) 'MT' sprintf('%02i',MTnum) '-' sprintf('%i',cloudythresh) 'g' sprintf('%02i',NBcla) 'cl' Nettype PredicPixels trainingfct Part sprintf('%02i',RADSneighbor) 'km' 'rep' sprintf('%i',nbdup) '_' sprintf('%03i',floor(RAD1seuil*100)) 'E-2' filterIWPflag]);
print('-dpng', '-r1000', ['BinaryRastaMTSATscan' sprintf('%02i',Frank) 'MT' sprintf('%02i',MTnum) '-' sprintf('%i',cloudythresh) 'g' sprintf('%02i',NBcla) 'cl' Nettype PredicPixels trainingfct Part sprintf('%02i',RADSneighbor) 'km' filterIWPflag 'EXPunifTucana']);

end
