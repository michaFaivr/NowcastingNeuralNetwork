%# 20150505
%%%plot boxplots for IWPclOutput vs IWPclTargets
%# 20150519 plot diffs target-out 


whos Xinputs  %% inputs log(radiances+epsi)  4x235962
whos lindata  %% output IWP classes          1x235962
whos IWPcl    %% input IWPclasses            1x235962
%X=NaN(NBcla,size(IWPcl,2)); %%6x235962
X=NaN(size(IWPcl,2),NBcla);  %%235962x6
whos X
for CLS=0:NBcla-1
    whos X
    IWPset=find(IWPcl==CLS);
    whos IWPset
    min(min(IWPset))
    max(max(IWPset))
    X(IWPset,CLS+1) = lindata(1,IWPset); %%pb here
    clear IWPset
end
whos X
G = 0:NBcla-1;
%GT = G';
%G=GT;
whos G
%
figure(10)
boxplot(X,G)
print('-depsc','-r1000','BoxplotIWPclTargetOutput')
hold off
clear figure
