%201410227 read thru F# and MT#
%make obver all Ascii : RADS + IWP

%********** PARAMETERS ********
%read bash made ascii params 
params_file='bashF.txt';
DFvalues=dlmread(params_file');
RADavgbloc=DFvalues(3)
%Fnum  =DFvalues(1);
%Fmin=10; Fmax=10
Fmin=1; Fmax=23;
cumulate=1;
filescount=0;
Fstring='';
numBlock=[1,2,4];%1

for Fiter=Fmin:Fmax
    %=== A.get files list ===
    Fnum2=sprintf('%02d',Fiter);
    %list ascii_F_MT in dir
    Input_ascii_dir=['/home/faivre/Ascii_RASTA_MTSAT/BT_IWP2_heightLevels_PALX_15minfixed_FSF' Fnum2 '/'];
    if ~exist(Input_ascii_dir)
        fprintf('%s\n',['not this MTSAT dir' Input_ascii_dir]);
        continue
    end
    %--- A2.get list of mathing.txt files ---
    system(['ls ' Input_ascii_dir 'RASTA_MT*matchingRef*' '.txt > list_matchingfiles.txt']);
    fid = fopen('list_matchingfiles.txt', 'r');
    Clist = textscan(fid, '%s\n');
    fclose(fid);
    system('rm -fr list_matchingfiles.txt');
    clear fid
    Ascii_matching_files = char(Clist{1});
    clear Clist
    disp(Ascii_matching_files);
    Nb_MTSATfiles=size(Ascii_matching_files,1);
    fprintf('%s\n','Nb_MTSATfiles');fprintf('%d\n',Nb_MTSATfiles);
%  
    if cumulate==1
        MTstring='allMT'
    end
    fprintf('%s\t','size(Ascii_matching_files)');fprintf('%d\n','size(Ascii_matching_files)');
    if size(Ascii_matching_files,1)==0
        continue
    end    
    indIR={1;5;17;18;19;20};
    if length(strfind(Input_ascii_dir,'IWP2'))>=1
      indIR={1;5;6;18;19;20;21};
    end

    %=== B.loop on MT ascii and neighbor IR1-4 files ===
   for ind_matching_files=1:size(Ascii_matching_files,1)
            %---=== B1.read matching.txt files for this RASTA flight ===---
            disp( Ascii_matching_files(ind_matching_files, :));
            system(['cp ' Ascii_matching_files(ind_matching_files, :) ' .']);
            name_input_file =Ascii_matching_files (ind_matching_files, (length(Input_ascii_dir)+1):(size(Ascii_matching_files, 2)));
            %read file
            %http://www.mathworks.fr/fr/help/matlab/ref/importdata.html#btldf1f-1
            delimiterIn = ' ';
            headerlinesIn = 4;
            %2---read Rasta_pos and calculated IWP from iwc_ret(z)
            %//////// rads from mathcing "closest MTSAT from RASTA" file
            if ~exist(name_input_file)
                continue;
            end
            %get MT num
            refstrlgth=length('RASTA_MTSAT_matchingRef_F')+5;%F++_MT
            MTnum=name_input_file(refstrlgth+1:refstrlgth+2);
            MTnum
%20141215 correction de thisMT
%            thisMT=ind_matching_files;
%           thisMT=str2num(name_input_file(end-6:end-4))
            %thisMT=str2num(MTnum)
            thisMT=str2num(MTnum)

            %---===B2. et ascii matcing data===---
            A = importdata(name_input_file,delimiterIn,headerlinesIn);
        filescount=filescount+1;
        if filescount==1
            %pause;
            RASTA_indice=A.data(:,indIR{1});
            RASTA_IWP1=A.data(:,indIR{2});
            RASTA_IWP2=A.data(:,indIR{3});
            RASTA_RAD1=A.data(:,indIR{4});
            RASTA_RAD2=A.data(:,indIR{5});
            RASTA_RAD3=A.data(:,indIR{6});
            RASTA_RAD4=A.data(:,indIR{7});
            RASTA_Fnum=Fiter*ones(size(A.data,1),1);
            RASTA_MTnum=thisMT*ones(size(A.data,1),1);
            RASTA_lat=A.data(:,3);RASTA_lon=A.data(:,4);
        else
            RASTA_indice=[RASTA_indice;A.data(:,indIR{1})];
            RASTA_IWP1=[RASTA_IWP1;A.data(:,indIR{2})];
            RASTA_IWP2=[RASTA_IWP2;A.data(:,indIR{3})];
            RASTA_RAD1=[RASTA_RAD1;A.data(:,indIR{4})];
            RASTA_RAD2=[RASTA_RAD2;A.data(:,indIR{5})];
            RASTA_RAD3=[RASTA_RAD3;A.data(:,indIR{6})];
            RASTA_RAD4=[RASTA_RAD4;A.data(:,indIR{7})];
            RASTA_Fnum=[RASTA_Fnum;Fiter*ones(size(A.data,1),1)];
            RASTA_MTnum=[RASTA_MTnum;thisMT*ones(size(A.data,1),1)];
            RASTA_lat=[RASTA_lat;A.data(:,3)];RASTA_lon=[RASTA_lon;A.data(:,4)];
        end
        %---===B3.neighbor ascii read IRchan neighbor avg RADS@5km ===---
        for IRchan=1:4
            %disp(class(MTnum))
            system(['ls ' Input_ascii_dir 'RASTA_MT*neighborStat*' MTnum '*ir' sprintf('%1d',IRchan) '.txt > list_neighborfiles.txt']);
            fid = fopen('list_neighborfiles.txt', 'r');
            Clist = textscan(fid, '%s\n');
            fclose(fid);
            system('rm -fr list_neighborfiles.txt');
            clear fid
            Ascii_neighbor_files = char(Clist{1});
            clear Clist
            if ~exist(Ascii_neighbor_files)       
               disp('pas de neighbor file');
               continue
            else
               system(['cp ' Ascii_neighbor_files(1, :) ' .']);
               neighbor_file =Ascii_neighbor_files (1, (length(Input_ascii_dir)+1):(size(Ascii_neighbor_files, 2)));
            end
            disp('neigh file');disp(neighbor_file);
            if ~exist(neighbor_file)
              disp('neighbor file doesnt exist')
              break
            end
            fid = fopen(neighbor_file, 'r');
            C = textscan(fid, '%s', 'Delimiter', '\n');
            fclose(fid);
            %ok all values txt and data aare read in the C{1,1} cell <710x1>
            Nlines_neighbor=size(C{1},1);
            Nlines_block=Nlines_neighbor/5 %5,10,15,20,30km
            %transform C from cell-array to array of strings
            C=[C{:}];
            TMP_Npos=[]; TMP_meanIR=[]; TMP_sigmaIR=[];
            TMP_lat =[]; TMP_lon=[]; TMP_Fnum=[]; TMP_MTnum=[];
            if RADavgbloc<=20
                indstart=(floor(RADavgbloc/5)-1)*Nlines_block+5;
            else
                indstart=4*Nlines_block+5;
            end
            for ll=indstart:indstart-5+Nlines_block
                   numerical=strread(C{ll},'%15.7f');
                   %disp(numerical);
                   TMP_Npos   =[TMP_Npos;numerical(1)];
                   TMP_lat    =[TMP_lat;numerical(3)];
                   TMP_lon    =[TMP_lon;numerical(4)];
                   TMP_meanIR =[TMP_meanIR;numerical(8)];
                   TMP_sigmaIR=[TMP_sigmaIR;numerical(9)];
            end
            TMP_Fnum   =Fiter*ones(Nlines_block-4,1);
            TMP_MTnum  =thisMT*ones(Nlines_block-4,1);
            %series graphs eachF#
            if filescount==1  %& cc==Fmin 
                 if IRchan==1
                   MTSAT_indice   = TMP_Npos;
		   MTSAT_lat      = TMP_lat;MTSAT_lon=TMP_lon;
                   MTSAT_Fnum     = TMP_Fnum;MTSAT_MTnum=TMP_MTnum;
                   MTSAT_meanIR1  = TMP_meanIR; 
                   MTSAT_sigmaIR1 = TMP_sigmaIR;
                 elseif IRchan==2
                   MTSAT_meanIR2  = TMP_meanIR;
                   MTSAT_sigmaIR2 = TMP_sigmaIR;
                 elseif IRchan==3
                   MTSAT_meanIR3  = TMP_meanIR;
                   MTSAT_sigmaIR3 = TMP_sigmaIR;
                 elseif IRchan==4
                   MTSAT_meanIR4  = TMP_meanIR;
                   MTSAT_sigmaIR4 = TMP_sigmaIR;
                 end 
            else
                 if IRchan==1 
                 MTSAT_indice     = [MTSAT_indice;TMP_Npos];
                 MTSAT_lat        = [MTSAT_lat;TMP_lat];
                 MTSAT_lon        = [MTSAT_lon;TMP_lon];
                 MTSAT_Fnum       = [MTSAT_Fnum;TMP_Fnum];
                 MTSAT_MTnum      = [MTSAT_MTnum;TMP_MTnum];
                   MTSAT_meanIR1  = [MTSAT_meanIR1;TMP_meanIR];
                   MTSAT_sigmaIR1 = [MTSAT_sigmaIR1;TMP_sigmaIR];
                 elseif IRchan==2
                   MTSAT_meanIR2  = [MTSAT_meanIR2;TMP_meanIR];
                   MTSAT_sigmaIR2 = [MTSAT_sigmaIR2;TMP_sigmaIR];
                 elseif IRchan==3
                   MTSAT_meanIR3  = [MTSAT_meanIR3;TMP_meanIR];
                   MTSAT_sigmaIR3 = [MTSAT_sigmaIR3;TMP_sigmaIR];
                 elseif IRchan==4 
                   MTSAT_meanIR4  = [MTSAT_meanIR4;TMP_meanIR];
                   MTSAT_sigmaIR4 = [MTSAT_sigmaIR4;TMP_sigmaIR];
                 end
            end
            %---- compare Nlines/block neighbor vs matching ---
            if size(MTSAT_Fnum,1) ~= size(RASTA_Fnum,1)
               disp('pb:matching and blockneighbor not the same lines#');
               disp(size(MTSAT_Fnum,1));disp(size(RASTA_Fnum,1));
               disp(Fiter);disp(ind_matching_files);
               %pause;
            end
        end%IRchan
    end %for ind_matching
%%compare rasta&mtsat

Fstring=[Fstring sprintf('%02d',Fiter)];
end %F#
fprintf('%s\n',Fstring)
%pause;

%---=== B. write arrays in ascii ===---
outputAscii=['globalAsciiRADS_IWP2_F' Fstring '_'  sprintf('%02i',RADavgbloc) 'km_sigmas.txt'];
fileID= fopen(outputAscii, 'w');
hformat='%s\n';
header='ind F MT RASlat lon RADS1 2 3 4 nearestIWPtot nearestIWPz>=9km '
fprintf(fileID,hformat,header);

%
dataformat='%i %i %i %8.4f %8.4f %i %8.4f %8.4f %8.4f %8.4f %8.4f %8.4f %8.4f %8.4f %8.4f %8.4f %8.4f %8.4f %8.4f  %8.4f %8.4f %8.4f\n'
fprintf('%s\t','RASTAIWP size');fprintf('%d\n',size(RASTA_IWP1,1));
for ij=1:size(RASTA_IWP1,1)
  if RASTA_IWP1(ij)>=0
      whos MTSAT_indice; whos MTSAT_lon; whos MTSAT_lat; 
      K=find(MTSAT_indice==RASTA_indice(ij) & MTSAT_Fnum==RASTA_Fnum(ij) & MTSAT_MTnum==RASTA_MTnum(ij));
      whos K; whos RASTA_Fnum;
      %disp(MTSAT_indice); disp(MTSAT_MTnum); disp(MTSAT_Fnum);      
      if numel(K)>=1
          kl=K(1);
          fprintf(fileID,dataformat, ...
             RASTA_Fnum(ij), RASTA_MTnum(ij), ...
             RASTA_indice(ij), ...
             RASTA_lat(ij), RASTA_lon(ij),...
             MTSAT_indice(kl), ...
             MTSAT_lat(kl), MTSAT_lon(kl),...
             RASTA_RAD1(ij), ...
             RASTA_RAD2(ij), ...
             RASTA_RAD3(ij), ...
             RASTA_RAD4(ij), ...
             RASTA_IWP1(ij), ... 
             RASTA_IWP2(ij), ...
             MTSAT_meanIR1(kl), ...
             MTSAT_meanIR2(kl), ...
             MTSAT_meanIR3(kl), ...
             MTSAT_meanIR4(kl), ...
             MTSAT_sigmaIR1(kl), ...
             MTSAT_sigmaIR2(kl), ...
             MTSAT_sigmaIR3(kl), ...
             MTSAT_sigmaIR4(kl))
      end
  end
end
fclose(fileID);
system('rm -f RASTA*txt')
