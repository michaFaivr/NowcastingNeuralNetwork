%%%20141208 et RASTA read and proc in routine

%   %------ define lat,lon ROI from RSTA flight positions min,max +/-1°
%    lonmin = min(RASTA_longitude(RASTA_longitude>-999))-1;
%    lonmax = max(RASTA_longitude(RASTA_longitude>-999))+1;
%    latmin = min(RASTA_latitude(RASTA_longitude>-999))-1;
%    latmax = max(RASTA_latitude(RASTA_longitude>-999))+1;
%    if (latmax-latmin) > (lonmax-lonmin)
%        tempo = (lonmax+lonmin)/2.0;
%        lonmin = tempo - (latmax-latmin)/2.0;
%        lonmax = lonmin + (latmax-latmin);
%        clear tempo
%    else
%        tempo = (latmax+latmin)/2.0;
%        latmin = tempo - (lonmax-lonmin)/2.0;
%        latmax = latmin + (lonmax-lonmin);
%        clear tempo
%    end


%calcul de latmin,latmaxsur globalascii[smaple_set(FMT)]
FMT=find(Fnumvect(sample_set)==Frank & MTnumvect(sample_set)==MTnum);
min(Fnumvect(sample_set));
min(MTnumvect(sample_set));
disp('FMT in RASTAascii_id')
whos FMT
whos sample_set
%pause

%# 20150120 use lon,latmin,max from bash !
%# otherwise, calcuate from RASTA
if  ~exist('latmin','var') & numel(FMT)>2
    latmin=min(RASTAlat(sample_set(FMT)));
    lonmin=min(RASTAlon(sample_set(FMT))); 
    latmax=max(RASTAlat(sample_set(FMT)));
    lonmax=max(RASTAlon(sample_set(FMT)));
elseif  ~exist('latmin','var') & numel(FMT)<=2
    disp('bad F,MT selection')
    disp(numel(FMT))
    break
end
disp('lat lon min max in RASTAascii')
latmin
latmax
lonmin
lonmax
%%pause
%# 20150126 calculate RASTA full track IWP
%whos RASTAlon
%whos Fnumvect
%whos MTnumvect
%whos IWP
%min(min(IWP))
%max(max(IWP))
%pause
FMTT= find(Fnumvect==Frank & MTnumvect==MTnum);
%# 20150129 cancel redundancies
% unique indices are contiguous
%# 20150203 cancel this and use unique
%Nstop=numel(FMTT);
%%for nn=2:size(FMTT,1) 
%    dd=FMTT(nn)-FMTT(nn-1);
%    if dd>1
%        Nstop=nn-1;
%        break
%    end
%end
%%%FMT=FMTT(1:Nstop)
[~,index] = unique(RASTAspot(FMTT),'first');
clear FMT
FMT=FMTT(sort(index));
disp('get RASTAspot in right order')
RASTAspot(FMT)
%pause
IWPset = find(RASTAlon(FMT) >= lonmin-0.5 & RASTAlon(FMT) <= lonmax+0.5 & ...
              RASTAlat(FMT) >= latmin-0.5 & RASTAlat(FMT) <= latmax+0.5 );
whos FMT
whos IWPset
whos IWP
disp('before RASTA_IWPtrack')
%pause
%#avoid redundancies due to duplicate
RASTA_IWPtrack = IWP(FMT(IWPset));
RASTA_LONtrack = RASTAlon(FMT(IWPset));
RASTA_LATtrack = RASTAlat(FMT(IWPset));
whos RASTA_IWPfull
whos RASTA_LONtrack
whos RASTA_LATtrack
%pause


