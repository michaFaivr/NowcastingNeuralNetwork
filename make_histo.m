%# 20150202
function [IWPbins,myHistoIWP] =  make_histo(IWP)
binstep=1E3;
 IWPmin=0;
 IWPinterm=12E3;
 IWPmax=4E4;
 IWPbins=[ IWPmin:binstep:IWPinterm IWPmax ];
 IWPbins
 
 myHistoIWP = zeros(numel(IWPbins)-1,1);
 whos myHistoIWP
 for hh=1:numel(IWPbins)-1
     Hind=find(IWP>=IWPbins(hh) & IWP<IWPbins(hh+1));
     myHistoIWP(hh)=numel(Hind);
 end
whos IWPbins
whos myHistoIWP
myHistoIWP

