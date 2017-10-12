%%%scan plot IWP RASTA scan from glbal ascii and corspind MSTAT
%sample_set(FMT)
switch Part
   case 'PartA'
      figPart=40
      IWPtrackA=IWP(sample_set(FMT))+1;
      IWPtrack=IWPtrackA;
      IWPflagtrackA=IWP_flag(sample_set(FMT));
      IWPflagtrack=IWPflagtrackA;
      FMTok=FMT;
      SFMT=sample_set(FMT);
   case 'PartB'
      figPart=43
      IWPtrack=IWPtrackA;
      IWPflagtrack=IWPflagtrackA;
      FMT=FMTok;
end
%20150102 match (IWP,RASTAlon,lat|[lon,lat,mon,max]) to (MPIXELgroup,PixelLon,lat)
%a) get RASTAlat,lon in [lon,lat,mon,max]
SETLON=find(ir_longitude<=lonmax & ir_longitude>=lonmin);
SETLAT=find(ir_latitude<=latmax & ir_latitude>=latmin);
RASLONLAT=find(RASTAlon<=lonmax & RASTAlon>=lonmin & ...
            RASTAlat<=latmax & RASTAlat>=latmin);
%b) get RASTA_track_lon,lat on seg
IWPtrack = IWP(RASLONLAT);
%c) MPIXELgroup <-- RASTAtrack pos
ILAT=ones(size(RASLONLAT,1),1); ILON=ones(size(RASLONLAT,1),1);
scanMTSAT=ones(size(RASLONLAT,1),1);
for ll=1:size(RASLONLAT)
    %%%a) find nearest MTSAT PixelLon,PIxelLat vs RASTA current : posLon,Lat for PixelLon,Lat
    [minlav,argminlav] = min(abs(PixelLat-RASTAlat(RASLONLAT(ll))));
    Checklat = RASTAlat(RASLONLAT(argminlav));
    [minlov,argminlov] = min(abs(PixelLon-RASTAlat(RASLONLAT(ll))));
    Checklon = RASTAlon(RASLONLAT(argminlov));
    %%%b) save closest position
    %-- ir
    ILAT(ll) =argminlav; ILON(ll) =argminlov;
    scanMTSAT(ll)=MPixelgroup(ILON(ll),ILAT(ll));
end%for        
%%%%%%%%%


%%%20141223 fix IWP_flag=-1500 wr IWP ?? fixed:thresholds(IWP_flag) --> IWP
mean_RASTA_IWP=mean(mean(IWPtrack));
min_RASTA_IWP=min(min(IWPtrack));
max_RASTA_IWP=max(max(IWPtrack));
whos FMT
whos IWPflagtrack

figure(figPart)
subplot(2,1,1)
%plot(thresholds(IWP_flag(sample_set(FMT))+1)) %%ok RASTA ascii IWPflag
%%%20141218 plpot RASTA_IWP as in global ascii !!
plot(IWPtrack); hold on
%plot(1:numel(FMT),IWPflagtrack,'b'); hold on
%plot([1 numel(FMT)],[mean_RASTA_IWP mean_RASTA_IWP],'r') 
%%%20141228
plot(1:numel(IWPflagtrack),IWPflagtrack,'b'); hold on
plot([1 numel(IWPflagtrack)],[mean_RASTA_IWP mean_RASTA_IWP],'r') 
ylim([0 1.2E4]);
%FMT --> RASTAlat(sample_set(FMT)) 

whos FMT
whos sample_set
whos RASTAlat
whos PixelLon; whos PixelLat
whos MPixelgroup
%RASTAlat(sample_set(FMT(1:10)))
PixelLat(1:8)
max(max(MPixelgroup))


%%%20141223 IWP_flag takes thresholds values => no thresholds appled to scanMTSAT
mean_MTSAT_IWP=mean(mean(scanMTSAT+1));
min_MTSAT_IWP=min(min(scanMTSAT+1));
max_MTSAT_IWP=max(max(scanMTSAT+1));

%%% plot MTSAT(PixelLon,Lat(pos(ij)))
subplot(2,1,2)
%%20141223 !!!!! fix IWP_flag !!!!!
%%201412226 IWP_flag(sample_set(FMT))->IWPflagtrack
%plot(1:numel(FMT),scanMTSAT','b',1:numel(FMT),IWPflagtrack,'k');hold on
%plot([1 numel(FMT)],[mean_MTSAT_IWP mean_MTSAT_IWP],'r')
%%%20141228
whos scanMTSAT
whos IWPflagtrack
%20150102 useIWPtrack
plot(1:numel(IWPtrack),scanMTSAT','b',1:numel(IWPtrack),IWPtrack,'k');hold on
plot([1 numel(IWPtrack)],[mean_MTSAT_IWP mean_MTSAT_IWP],'r')
ylim([0 1.2E4]);
title({['mean simu IWP' sprintf('%4i',floor(mean_MTSAT_IWP)) '; mean real IWP' sprintf('%4i',floor(mean_RASTA_IWP))]; ...
       ['min simu IWP' sprintf('%4i',floor(min_MTSAT_IWP)) '; min real IWP' sprintf('%4i',floor(min_RASTA_IWP))]; ...
       ['max simu IWP' sprintf('%4i',floor(max_MTSAT_IWP)) '; max real IWP' sprintf('%4i',floor(max_RASTA_IWP))]})

print('-dpng', '-r1000', ['RastaMTSATscan' sprintf('%02i',Frank) 'MT' sprintf('%02i',MTnum) '-' sprintf('%i',cloudythresh) 'g' sprintf('%02i',NBcla) 'cl' Nettype PredicPixels trainingfct Part]);

%%% 20141219 plot histos image IWP real/retrieved
