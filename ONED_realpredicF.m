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
%     elseif NBcla==3 | NBcla==4 | NBcla==5
      elseif NBcla>=3 & NBcla<8
          IWPflagtrackA=nan(size(IWPtrack,1),size(IWPtrack,2));
          for cc=1:numel(threshvect)-1
              IWPlev=find(IWPtrack<threshvect(cc+1) & IWPtrack>=threshvect(cc));
              if numel(IWPlev>0) 
                  IWPflagtrackA(IWPlev)=cc-1;
              end
          end
      else
          IWPflagtrackA=floor(IWPtrack./IWPstep);
          %# 20150313
          IWPflagtrackA(IWPflagtrackA>NBcla-1)=NBcla-1; 
      end 
      whos IWPflagtrackA
      %pause
%      IWPflagtrack=IWPflagtrackA;
      %# 20150227 apply IWPcutoff
      whos IWPflagtrackA
      max(IWPflagtrackA)
      disp('before IWPcutoff')
      max(IWPflagtrackA)
      %# 20150323 flag fewercls as in PIXELPLOT
      if fewercls==0
          [IWPflagtrack,I] = IWPcutoff(IWPflagtrackA,PODvect,thePODcut); 
          IWPflagtrack(IWPflagtrack>I)=I+1; %cf IWPcutoff
      elseif fewercls==1
          [IWPflagtrack,I,newRefIWP] = IWPcutoff_fewercls(IWPflagtrackA,PODvect,threshvect,thePODcut,NBcla); 
          I=3;
      end
      disp('IWPcutoff applied')
      max(IWPflagtrack)

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

%# 20150325 add condition on SRASTAspot size
%# 20150327 add condition on Ispotsort
if numel(SRASTAspot)>2 & numel(Ispotsort)>2 & numel(scanMTSAT)>2

%# 20150102 use IWPtrack
%# 20150204 cancel if else
   X=SRASTAspot;
%# 20150204 use Ispotsort
   Y1=minIWP(Ispotsort);
   Y2=maxIWP(Ispotsort);
   whos X
   whos Y1
   whos Y2

   C=[0,0,0]+0.7;
   %fill_between_lines = @(X,Y1,Y2,C) fill( [X fliplr(X)],  [Y1 fliplr(Y2)], C );
   clear X Y Y2 C
   SRASTAspot
   whos SRASTAspot
   whos Ispotsort
   whos scanMTSAT
   whos IWPflagtrack
%# 20150215 subplot(2,1,2) here
   %--- plot SIMU IWPclasses on RASTA track ---
   %# 20150227 apply IWPcutoff to Net outputs
   AA = scanMTSAT(Ispotsort)';
   %AA(AA>=I+1)=I+1; %???
   %# 20150324 cf IWPcutoff
   AA(AA>I)=I+1;
   subplot(2,1,1)
%   plot(SRASTAspot,scanMTSAT(Ispotsort)','b')
   plot(SRASTAspot,AA,'b') 
   xlim([SRASTAspot(1) SRASTAspot(end)]);
%  ylim([0 NBcla]);
   ylim([0 I+2]);
   title([name_input_file_title ' IWPclmax=' sprintf('%i',Iref) '  IWPmax='  sprintf('%i',threshvect(Iref+1)) 'g/m2' ])
   %--- plot SIMU IWPclasses on RASTA track--- 
   subplot(2,1,2)
   x=1:numel(SRASTAspot);
%#20150225
%  if NBcla<=3
   if NBcla<=2
       plot(x,IWPflagtrack(Ispotsort),'k');hold on
   else
        plot(x,IWPflagtrack(Ispotsort),'k','LineWidth',2); hold on
        whos IWPflagtrack
        whos Ispotsort
        %# 20150227 AA(AA>I)=I+1
%       plot(x,scanMTSAT(Ispotsort)','b');hold on
        plot(x,AA,'b');hold on
        ylim([0 I+1]);
   end
   %# 20150204 use SRASTA
   plot([x(1) x(end) ],[mean_MTSAT_IWP mean_MTSAT_IWP],'--b'); hold on
   plot([x(1) x(end) ],[mean(mean(IWPflagtrack)) mean(mean(IWPflagtrack))],'--k'); hold on
  %# 20150120
   SRASTAspot
   xlim([x(1) x(end)]);
%  ylim([0 NBcla]);
   ylim([0 I+1]);
   %# 20150326 if
   if fewercls==1
       ytop=numel(newRefIWP)-1;
   else
       ytop=0;
   end
   %--- ylabels
%   ax=gca
%   ax.YTickLabel = {[ '[' sprintf('%i',thresholds(1)),sprintf('%i',thresholds(2)) '[', ...
%                      '[' sprintf('%i',thresholds(3)),sprintf('%i',thresholds(4)) '[', ... 
%                      '[' sprintf('%i',thresholds(5)),sprintf('%i',thresholds(6)) '[', ... 
%                      '[' sprintf('%i',thresholds(7)),sprintf('%i',thresholds(8)) '[', ...  
%                      '[' sprintf('%i',thresholds(9)),sprintf('%i',thresholds(10)) '[', ... 
%                      '[' sprintf('%i',thresholds(11)),sprintf('%i',thresholds(12)) '[' ]} 
   %--- title
   title({['mean simu IWP' sprintf('%4i',floor(mean_MTSAT_IWP)) '; mean real IWP' sprintf('%4i',floor(mean_RASTA_IWP))]; ...
       ['min simu IWP' sprintf('%4i',floor(min_MTSAT_IWP)) '; min real IWP' sprintf('%4i',floor(min_RASTA_IWP))]; ...
       ['max simu IWP' sprintf('%4i',floor(max_MTSAT_IWP)) '; max real IWP' sprintf('%4i',floor(max_RASTA_IWP))]})
%# 20150409 replace '4000g' --> nbRADS 
if applyUnif==1   
    print('-dpng', '-r1000', ['RastaMTSATscan' sprintf('%02i',Frank) 'MT' sprintf('%02i',MTnum) '-nbRADS' sprintf('%02i',nbRADS) '-' sprintf('%02i',NBcla) 'cl' ...
          sprintf('%02i',ytop) 'cl' Nettype trainFcn sprintf('%02i',nbHL) PredicPixels trainingfct Part sprintf('%02i',RADSneighbor) 'km' dupstring ... 
          'filter' filterIWPflag DIVIDER sprintf('%i',round(divid*100)) 'E-2tR' sprintf('%i',tRatio) 'PODcutoff' strfewer Alphastr]);
else
    print('-dpng', '-r1000', ['RastaMTSATscan' sprintf('%02i',Frank) 'MT' sprintf('%02i',MTnum) '-nbRADS' sprintf('%02i',nbRADS) '-' sprintf('%02i',NBcla) 'cl' Nettype PredicPixels trainingfct Part sprintf('%02i',RADSneighbor) 'km' dupstring 'filter' filterIWPflag Aplhastr]);
end

end %numel(SRASTAspot)
