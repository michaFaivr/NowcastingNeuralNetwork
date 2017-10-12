%20141202 read MTSAT nc and store pos and 4RADS
%use routines from A-ASCII

%20141206 for now process 1! MTimage

%%%% ALGO MT_iwpflag_masking %%%%
%a) readMTSAT image    : readstoreMTSAT/readMTSAT 
%b) store lat,lon, 4RADS in IRAD1,.,4 : readstoreMTSAT
%c) append IRADS to RADS in sample_data: MAIN=CLASSIF_RM_Images_Floop
%d) use classify again for 0/1 clasif IWPflag and extract part

%%% !!!!20141217 correct Fnum2=sprintf('%02d',6); to Fnum !!! was ok in A-Ascii

%%Fnum2=sprintf('%02d',6);  
Fnum2=sprintf('%02d',Fnum);
%///////////////////////////
%1. read MTSAT data 
%///////////////////////////
%# 20140910 moved to leo server and copied MTSAt F01 to leo home
%# 20150421 update path on my antlia
%input_dir=strcat('/data/faivre/data1/Haic/MTSAT/Data/F',Fnum2,'/');
input_dir=strcat('/home/faivre/MTSATdata/F',Fnum2,'/');
%
system(['ls ' input_dir 'MT1*.bz2 > list_file.txt']);
fid = fopen('list_file.txt', 'r');
Clist = textscan(fid, '%s\n');
fclose(fid);
system('rm -fr list_file.txt');
clear fid
MTSAT_files = char(Clist{1});
clear Clist

ind_MTSAT_min=MTnum; ind_MTSAT_max=MTnum;
for ind_MTSAT_file = ind_MTSAT_min, ind_MTSAT_max
    disp( MTSAT_files(ind_MTSAT_file, :));
    system(['cp ' MTSAT_files(ind_MTSAT_file, :) ' .']);
    %20140922 cas  ou dir MTSAT has .NC.BZ.BZ2 and .NC.BZ2
    name_input_file_tmp = MTSAT_files(ind_MTSAT_file, (length(input_dir)+1):(size(MTSAT_files, 2)));
    fprintf('%s\n','name_input_file_tmp start');fprintf('%s\n',name_input_file_tmp);
    %
    name_input_file_tmp2 = MTSAT_files(ind_MTSAT_file, (length(input_dir)+1):length(input_dir)+39)
    fprintf('%s\n','name_input_file_tmp2 start');fprintf('%s\n',name_input_file_tmp2);
    %pause;%ok name without extension
    %---- .nc.gz.bz2 ----
    SUBSTR0 = strfind(MTSAT_files(ind_MTSAT_file, :),'nc');
    SUBSTR1 = strfind(MTSAT_files(ind_MTSAT_file, :),'bz2');
    SUBSTR2 = strfind(MTSAT_files(ind_MTSAT_file, :),'gz');
    %--- cas#1: TMP: .nc.gz.bz2 ---
    if length(SUBSTR0) >=1 & length(SUBSTR1) >=1 & length(SUBSTR2) >=1
       %a) bunzip2 -f name_tmp
       system(['bunzip2 -f -d ' name_input_file_tmp]); %tmp should be .nc.gz now
       fprintf('%s\n','name_input_file_tmp after case .nc.gz.bz2');fprintf('%s\n',name_input_file_tmp);
       name_input_file=[name_input_file_tmp2 '.nc.gz']
       name_input_file_tmp=name_input_file;
       fprintf('%s\n','name_input_file after case .nc.gz.bz2');fprintf('%s\n',name_input_file);
       SUBSTR0 = strfind(name_input_file,'nc');
       SUBSTR1 = strfind(name_input_file,'bz2');
       SUBSTR2 = strfind(name_input_file,'gz');
    end
    %--- cas#2: TMP: .nc.bz2 ---
    if length(SUBSTR0) >=1 & length(SUBSTR1) >=1 & length(SUBSTR2) ==0  %.nc.bz2
       %b) bunzip2 -f name_tmp
       system(['bunzip2 -f -d ' name_input_file_tmp]); %tmp should be .nc now
       fprintf('%s\n','name_input_file_tmp after case .nc.bz2');fprintf('%s\n',name_input_file_tmp);
       name_input_file=[name_input_file_tmp2 '.nc']
       fprintf('%s\n','name_input_file after case .nc.bz2');fprintf('%s\n',name_input_file);
       name_input_file_tmp=name_input_file;
       SUBSTR0 = strfind(name_input_file,'nc');
       SUBSTR1 = strfind(name_input_file,'bz2');
       SUBSTR2 = strfind(name_input_file,'gz');
    end
    %--- cas#2: TMP: .nc.gz ---
    if length(SUBSTR0) >=1 & length(SUBSTR1) ==0 & length(SUBSTR2) >=1 %.nc.gz
       system(['gunzip -f -d ' name_input_file_tmp]);
       fprintf('%s\n','name_input_file_tmp after case .nc.gz');fprintf('%s\n',name_input_file_tmp);
       name_input_file=[name_input_file_tmp2 '.nc']
       fprintf('%s\n','name_input_file after case .nc.gz');fprintf('%s\n',name_input_file);
       name_input_file_tmp=name_input_file;
       SUBSTR0 = strfind(name_input_file,'nc');
       SUBSTR1 = strfind(name_input_file,'bz2');
       SUBSTR2 = strfind(name_input_file,'gz');
    end %now input_name_tmp should be .nc
    fprintf('%s\n','name_input_file_tmp after 3 cases');fprintf('%s\n',name_input_file_tmp);
    fprintf('%s\n','name_input_file after 3 cases');fprintf('%s\n',name_input_file);
    name_input_file_title = name_input_file;
    klist = strfind(name_input_file, '_');
    name_input_file_title(klist) = '-';
    clear klist

    %--- B2.read MTSAT data ----
    try
        read_MTSAT;
    catch ME2
        fprintf('%s\n','read_MTSAT failed')
        continue
    end

    %--- B3. cal ROI_ir_lat,lon wr RASTA loc -----
    %%%lat,max,lonmin,max cal in RASTAascii_id
    ROI_ir_lat=find(ir_latitude  >= latmin-ddegre & ir_latitude  <= latmax+ddegre);
    ROI_ir_lon=find(ir_longitude >= lonmin-ddegre & ir_longitude <= lonmax+ddegre);
 
    disp('latmin,max')
    latmin
    latmax
    disp('lonmin,max')
    lonmin
    lonmax
    %pause
    whos ROI_ir_lat
    whos ROI_ir_lon

%///////////////////////////
%2. BUILD PIXELarrays
%///////////////////////////
%####### unflexible code : designed for 4RADS only ... #####
%# Howabout when adding RADsigma???
    %--- B4. store lat,lon,4RADS on ROI around RASTA flight ---
    %cf A-ASCII codes
%%%   clear PixelLat, PixelLon, PixelRAD1, PixelRAD2, PixelRAD3, PixelRAD4
    PixelLat= ir_latitude(ROI_ir_lat) ;
    PixelLon= ir_longitude(ROI_ir_lon);
    PixelRAD1=ir1_count_radiance(ROI_ir_lon,ROI_ir_lat) ;
    PixelRAD2=ir2_count_radiance(ROI_ir_lon,ROI_ir_lat) ;
    PixelRAD3=ir3_count_radiance(ROI_ir_lon,ROI_ir_lat) ;
    PixelRAD4=ir4_count_radiance(ROI_ir_lon,ROI_ir_lat) ;   
    whos PixelRAD2
    whos PixelRAD4
 %%pause
    %%20141211  1 matrix
    Nsize1=numel(PixelRAD1)
    Nsize2=numel(PixelRAD2)
    Nsize3=numel(PixelRAD3)
    Nsize4=numel(PixelRAD4)
    %
    Sz1=[Nsize1,1];
    Sz2=[Nsize2,1];
    Sz3=[Nsize3,1];
    Sz4=[Nsize4,1];
    %
    VPixelR1=reshape(PixelRAD1,Sz1);
    VPixelR2=reshape(PixelRAD2,Sz2);
    VPixelR3=reshape(PixelRAD3,Sz3);
    VPixelR4=reshape(PixelRAD4,Sz4);
    disp('readstoreMTSAT VPixelR4')
    whos VPixelR4
%%pause
%   disp('VPIR1')
%   VPixelR1(200:300)
%   disp('VPIR2')
%   VPixelR2(200:300)
%   disp('VPIR3')
%   VPixelR3(200:300)
%   disp('VPIR4')
%   VPixelR4(200:300)
%   %pause  %ok here

    PixelRADS=[VPixelR1';VPixelR2';VPixelR3';VPixelR4'];
    PP=PixelRADS';
    PixelRADS=PP;
    whos PixelRADS
%    disp('PRADS1 bef logs')
%    PixelRADS(300:400,1);
%    disp('PRADS2 bef logs')
%    PixelRADS(300:400,2);
%    disp('PRADS3 bef logs')
%    PixelRADS(300:400,3);
%    disp('PRADS4 bef logs')
%    PixelRADS(300:400,4);
%    %pause %ok here too

    %%pause
    %%%20141211 appluy log fct to PixelRASD !!!
%%%20141216 toke trainingfct from main
%trainingfct='none'
switch trainingfct
        case '4log'
            PixelRADS=log(PixelRADS'+1E-5);%matNx4
            mindata=min(min(PixelRADS));
            PixelRADS=log(PixelRADS-mindata+1);
            clear mindata;
            mindata=min(min(PixelRADS));
            PixelRADS=log(PixelRADS-mindata+1);
            clear mindata;
            mindata=min(min(PixelRADS));
            PixelRADS=log(PixelRADS-mindata+1);
            clear mindata;
        case '3log'
            PixelRADS=log(PixelRADS'+1E-5);%matNx4
            mindata=min(min(PixelRADS));
            PixelRADS=log(PixelRADS-mindata+1);
            clear mindata;
            mindata=min(min(PixelRADS));
            PixelRADS=log(PixelRADS-mindata+1);
        case '2log'
            PixelRADS=log(PixelRADS'+1E-5);%matNx4 
            mindata=min(min(PixelRADS));
            PixelRADS=log(PixelRADS-mindata+1);
        case 'log'
        %# 20150403 take abs !! --> avoid VPixelR4 & PixelData complex in makepixeldata
            PixelRADS=log(abs(PixelRADS'+1E-5));%matNx4
            %# 20150415 try log10 instead
        %   if strcmp(trainFcn,'LM')==1
        %        PixelRADS=log10(abs(PixelRADS'+1E-5));%matNx4
        %    end
        case 'none'
            PixelRADS=PixelRADS';%matNx4
    end
    RR=PixelRADS';
    PixelRADS=RR;
%    disp('PixelRADS after logs')
%    whos PixelRADS
%    PixelRADS(200:300,1)
%    disp('PiR2')
%    PixelRADS(200:300,2)
%    disp('PiR3')
%    PixelRADS(200:300,3)
%    disp('PiR4')
%    PixelRADS(200:300,4)
    %pause

end %for ind_MTSAT_file
