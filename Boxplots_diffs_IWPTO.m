%# 20150505
%%%plot boxplots for IWPclOutput vs IWPclTargets
%# 20150519 plot diffs target-out 


whos Xinputs  %% inputs log(radiances+epsi)  4x235962
whos lindata  %% output IWP classes          1x235962
whos IWPcl    %% input IWPclasses            1x235962
%X=NaN(NBcla,size(IWPcl,2)); %%6x235962
X=NaN(size(IWPcl,2),NBcla);  %%235962x6
IWPdiff_avg = NaN(NBcla);
whos X
for CLS=0:NBcla-1
    whos X
    IWPset=find(IWPcl==CLS);
    whos IWPset
    whos IWPcl
    whos lindata
    min(min(IWPset))
    max(max(IWPset))
    X(IWPset,CLS+1) = IWPcl(1,IWPset)-lindata(1,IWPset); %%pb here
    IWPdiff_avg(CLS+1)=mean(X(IWPset,CLS+1)); 
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
%print('-depsc','-r1000','BoxplotIWPclTargetOutput')
for ind = 1:NBcla
text(ind,0,sprintf('%5.2f',IWPdiff_avg(ind)) )
end
print('-depsc','-r1000',['BoxplotIWPclTargetOutput' trainFcn '_' sprintf('%i',NBcla) 'cl_' DIVIDER sprintf('%i',round(divid*100)) 'E-2' Alphastr ])
hold off
clear figure
