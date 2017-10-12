function [NbInputs,NbseuilsIWP,IWPid,Polyfitorder,useRADcl,settype,Fnum,outputsuffixe,strRAD,Nettype]   = readparams(params_file)
    %********** PARAMETERS ********
    %read bash made ascii params 
    %params_file='paramsNNET.txt'
    DFvalues=dlmread(params_file');
    NbInputs    =DFvalues(1);
    NbseuilsIWP =DFvalues(2);
    IWPid       =DFvalues(3);
    Polyfitorder=DFvalues(4);
    useRADcl    =DFvalues(5);
    settype     =DFvalues(6);
    Fnum        =DFvalues(8);
    %%Nettype     =DFvalues(7);
    outputsuffixe='_IWPtot';
    if IWPid==2
      outputsuffixe='_IWPgt9km';
    end
    strRAD='notRADcl'
    if useRADcl==1
      strRAD='RADcl'
    end
    Nettype     ='newpr';
    if DFvalues(7)==2
       Nettype = 'feedforward';
    end
end
