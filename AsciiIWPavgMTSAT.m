%# 20150310 avg IWP for each MTSAT pixel : Rk same,k1,4
%arrays already sorted wr IWP
%IWP
%RAD1-4

%get non duplicated values 
[RAD1unik,index] = unique(RAD1,'stable');
RAD1unik
whos RAD1
whos RAD1unik

RADSMAT = [RAD1  RAD2  RAD3  RAD4];
whos RADSMAT
RADSunik = unique(RADSMAT,'rows');
whos RADSunik
RADSunik(1,1:4)
RADSunik(2,1:4)
RADSunik(3,1:4) %sorted in increase order

%IWP(1000:2000)
%min(min(IWP(1000:2000)))
%max(max(IWP(1000:2000)))
%pause

for N=1:size(RADSunik,1)
    Asubset = find(RAD1==RADSunik(N,1) & RAD2==RADSunik(N,2) & RAD3==RADSunik(N,3) & RAD4==RADSunik(N,4));
    YMP=sum(IWP(Asubset))/max([1 numel(Asubset)]);
    IWP(Asubset)=YMP;
    clear YMP Asubset
end
