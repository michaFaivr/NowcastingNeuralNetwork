%# 20150227 IWPcutoff
%1) get IWPcl0 corresponding to POD<75%
%2) aposteriori cutoff of IWPcl>IWPcl0 for targets and outputs
%# 20150324 get thePODcut in args !!!
%# 20150504 add NBcla in args
%function [IWPtrust,I] = IWPcutoff(IWPcl,PODvect,threshvect,thePODcut)
function [IWPtrust,I,newRefIWP] = IWPcutoff_fewercls(IWPcl,PODvect,threshvect,thePODcut,NBcla)
    %/////////////////////
    %1. POD cut off
    %/////////////////////
    %--- final nb IWPgroups ---%
    %# 20150331 nbIWPgps
    nbIWPgps=5;
    nbIWPgps=4; 
    %nbIWPgps=2;
    %%%% 1) detection de IWPmax for POD<=thePODcut %%%
    [IWPlimit,I] = min(abs(PODvect-thePODcut));
    IWPtrustTMP = IWPcl;
    I
    IWPtrustTMP(IWPcl>I)=I+1; 
    max(IWPtrustTMP)
    IWPtrust=IWPtrustTMP.*0;

    %/////////////////////
    % 2. group classes
    %/////////////////////
    %# 20150320 use kg.m-2
    IWPlevs=convertClasses_to_IWP(IWPtrustTMP,threshvect);
    whos IWPlevs
    switch nbIWPgps
        case 5
        %# 20150324 --- 05cls ---
        newRefIWP = [0 1E3 2E3 3E3 threshvect(I+1) 40E3];
        if NBcla==8
            newRefIWP=[0 2E3 3E3 6E3 threshvect(I+1) 4E4];
        end
        case 2
        %# 20150331 --- 02cls ---
        newRefIWP = [0 2E3 40E3];
        %# 20150413 case 4 : 0-2;2-3;3-IWPclmax;IWPclmax-40kg/m2
        case 4
        newRefIWP = [0 2E3 3E3 threshvect(I+1) 40E3];
    end
    if nbIWPgps>2
    for nri=1:numel(newRefIWP)-1
        class= find( IWPlevs>=newRefIWP(nri) & IWPlevs<newRefIWP(nri+1))
        if ~isempty(class)
            IWPtrust(class)=nri-1;
        end
        clear class
    end %for
    else
    IWPtrust(IWPlevs<newRefIWP(2))=0;
    IWPtrust(IWPlevs>=newRefIWP(2))=1;
    end %if
end 
