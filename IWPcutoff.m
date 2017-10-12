%# 20150227 IWPcutoff
%1) get IWPcl0 corresponding to POD<75%
%2) aposteriori cutoff of IWPcl>IWPcl0 for targets and outputs

function [IWPtrust,I] = IWPcutoff(IWPcl,PODvect,thePODcut)
    [IWPlimit,I] = min(abs(PODvect-thePODcut));
    IWPtrust = IWPcl;
%    BAD = find(IWPcl>I+1)
    I
%   try
%        TWPtrust(BAD)=I+1;
%    catch ME4
%        a=1;
%    end
    IWPtrust(IWPcl>I)=I+1; 
    max(IWPtrust)
end 



