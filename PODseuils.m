%#20150225 cal & plot PODS vs seuils IWP ...
PODvect=nan(NBcla,1);
FARvect=nan(NBcla,1);
BIASvect=nan(NBcla,1);
whos PODvect

for refcase=0:NBcla-1
    POD=0; FAR=0; BIAS=0;
    NBcloud=numel(find(IWPcl==refcase));
    NBcs=numel(find(IWPcl~=refcase));
    disp('numel IWP>0')
    numel(IWPcl(IWPcl>0))
    disp('numel lindata>0')
    numel(lindata(lindata>0))
    whos IWPcl; whos lindata
    try
       %IWPcl=targets; lindata=outputs
%      hits=numel(find(IWPcl==refcase & lindata==refcase));%refcase both
%       missed=numel(find(IWPcl==refcase & lindata~=refcase));%yes,no
%       fa=numel(find(IWPcl~=refcase & lindata==refcase));%no,yes
       %# 20150227
       hits=numel(find(IWPcl>=refcase & lindata>=refcase));%refcase both
       missed=numel(find(IWPcl>=refcase & lindata<refcase));%yes,no
       fa=numel(find(IWPcl<refcase & lindata>=refcase));%no,yes
       %
       POD=hits/(hits+missed);
       FAR=fa/(hits+fa);
       BIAS=(hits+fa)/(hits+missed);
       %
       NBCLreal=numel(find(IWPcl==refcase));
       NBCLsimu=numel(find(lindata==refcase));
       CLratio=NBCLsimu/NBCLreal;
       NBcs=numel(find(IWPcl~=refcase));
       %
       PODvect(refcase+1)=POD;
       FARvect(refcase+1)=FAR;
       BIASvect(refcase+1)=BIAS;
    catch ME4
       disp('error in contingency')
    end
end %for
PODvect
%%pause
%--- plot 2x2 panel POD,F,Bvect ---

figure(44)
%--- a) PODvect ---
subplot(4,2,1)
    plot(0:NBcla-1, PODvect,'b','LineWidth',2); hold on
    ylim([0 1]);
    title([sprintf('%02i',Frank) 'PODvariations' ])
%--- b) FARvect ---
subplot(4,2,2)
    plot(0:NBcla-1, FARvect,'b','LineWidth',2); hold on
    ylim([0 1]);
    title([sprintf('%02i',Frank) 'FARvariations' ])
%--- c) BIASvect ---
subplot(4,2,3)
    plot(0:NBcla-1, BIASvect,'b','LineWidth',2); hold on
    ylim([0 1]);
    title([sprintf('%02i',Frank) 'BIASvariations' ])
clear figure
print('-dpng', '-r1000', ['PODFARBIAS' sprintf('%02i',Frank) 'MT' sprintf('%02i',MTnum) ...
                          '_' sprintf('%02i',RADSneighbor) 'km' ...
                          DIVIDER sprintf('%i',round(divid*100)) 'E-2tR70POD'])
