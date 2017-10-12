%%% 21nov2014 module to read globalAscii.txt for CLASSIFY %%%
%%% 28Nov add reading F#
   %%% b) read data ascii %%%
    A = importdata(name_input_file,delimiterIn,headerlinesIn);
    %   rmpath('./INPUTASCIIS/')
    Aset=1:floor(size(A.data,1));
    indIR={1;2;3;4;4;7;8;9;10};
    %%%20141208 add col for MT#,lat,lonRASTA
    if length(strfind(name_input_file,'new'))>=1
        indIR={9;10;11;12;12;15;16;17;18;1;2;4;5};
    elseif length(strfind(name_input_file,'sigmas'))>=1
    %# 20150203 add RASTAspot=col3
        %indIR={9;10;11;12;12;15;16;17;18;19;20;21;22;1;2;4;5};
        indIR={9;10;11;12;12;15;16;17;18;19;20;21;22;1;2;3;4;5};
    end
    Col0=A.data(Aset,indIR{end-4});%3}); %F#
    Col90=A.data(Aset,indIR{end-3});%-2}); %MT#
    Col94=A.data(Aset,indIR{end-2}); %RASTAspot#
    Col91=A.data(Aset,indIR{end-1}); %latRASTA
    Col92=A.data(Aset,indIR{end}); %lonRASTA
    %
    Col1=A.data(Aset,indIR{1}); %RAD1
    Col2=A.data(Aset,indIR{2}); %RAD2
    Col3=A.data(Aset,indIR{3}); %RAD3
    Col4=A.data(Aset,indIR{4}); %RAD4
    Col5=A.data(Aset,indIR{5}+IWPid); %IWPtot or >=9km
    if length(strfind(name_input_file,'new'))>=1 || length(strfind(name_input_file,'sigmas'))>=1
        Col6=A.data(Aset,indIR{6}); %RAD1avgNkm
        Col7=A.data(Aset,indIR{7}); %RAD2avg
        Col8=A.data(Aset,indIR{8}); %RAD3avg
        Col9=A.data(Aset,indIR{9}); %RAD4avg
    end
    if length(strfind(name_input_file,'sigmas'))>=1
        Col10=A.data(Aset,indIR{10}); %RAD1sigNkm
        Col11=A.data(Aset,indIR{11}); %RAD2sigNkm
        Col12=A.data(Aset,indIR{12}); %RAD3sigNkm
        Col13=A.data(Aset,indIR{13}); %RAD4sigNkm
    end
    %%% c) filter IWP <seuilIWP %%%
    Fnumvect=Col0(Col5>=IWPseuil);
    %%% d) 20141208 MTnumvect
    MTnumvect=Col90(Col5>=IWPseuil);
    %# 20150203
    RASTAspot=Col94(Col5>=IWPseuil);
    %%% e) 20141208 RASTA_lat,lon
    RASTAlat=Col91(Col5>=IWPseuil);
    RASTAlon=Col92(Col5>=IWPseuil);
    %
    if useRADavg ~=1
        RAD1=Col1(Col5>=IWPseuil);RAD2=Col2(Col5>=IWPseuil);RAD3=Col3(Col5>=IWPseuil);RAD4=Col4(Col5>=IWPseuil);IWP=Col5(Col5>=IWPseuil);
        %    elseif useRADavg ==1 & length(strfind(name_input_file,'new'))>=1
    else
        RAD1=Col6(Col5>=IWPseuil);RAD2=Col7(Col5>=IWPseuil);RAD3=Col8(Col5>=IWPseuil);RAD4=Col9(Col5>=IWPseuil);IWP=Col5(Col5>=IWPseuil);
    end
    RAD1sig=zeros(size(RAD1));RAD2sig=zeros(size(RAD2));RAD3sig=zeros(size(RAD3));RAD4sig=zeros(size(RAD4));
    Filtered=zeros(size(RAD1));
    %20141118
    if length(strfind(name_input_file,'sigmas'))>=1
        RAD1sig=Col10(Col5>=IWPseuil);RAD2sig=Col11(Col5>=IWPseuil);RAD3sig=Col12(Col5>=IWPseuil);RAD4sig=Col13(Col5>=IWPseuil);
    end





