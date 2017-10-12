%%%%% 21Nov2014 fct to cal POD and FAR on CS detection %%%
%function [POD,FAR]=contingency(IWPcl,lindata)
%function [POD,FAR,BIAS,NBcloud,NBcs]=contingency(IWPcl,lindata)
function [POD,FAR,BIAS,NBCLreal,NBCLsimu,CLratio,NBcs]=contingency(IWPcl,lindata)
refcase=1  %Cloudy cases for binary distrib %=refcase%CS cases
POD=0; FAR=0; BIAS=0;
NBcloud=numel(find(IWPcl==refcase));
NBcs=numel(find(IWPcl~=refcase));
disp('numel IWP>0')
numel(IWPcl(IWPcl>0))
disp('numel lindata>0')
numel(lindata(lindata>0))
whos IWPcl; whos lindata
try 
    hits=numel(find(IWPcl==refcase & lindata==refcase));%cloudy,cloudy
    missed=numel(find(IWPcl==refcase & lindata~=refcase));%CLOU,CS
    fa=numel(find(IWPcl~=refcase & lindata==refcase));%CS,CLOUD
    POD=hits/(hits+missed);
    FAR=fa/(hits+fa);
    BIAS=(hits+fa)/(hits+missed);
%23050113 make ratio
    NBCLreal=numel(find(IWPcl==refcase));
    NBCLsimu=numel(find(lindata==refcase));
    CLratio=NBCLsimu/NBCLreal;
    NBcs=numel(find(IWPcl~=refcase));
catch ME4
    disp('error in contingency')
end
