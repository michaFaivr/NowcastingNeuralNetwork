%201410227 read thru F# and MT#
%make obver all Ascii : RADS + IWP

%********** PARAMETERS ********
%read bash made ascii params 
params_file='bashF.txt'
DFvalues=dlmread(params_file');
Fnum  =DFvalues(1);

%Fmin=6; Fmax=6
%Fmin=5; Fmax=10
Fmin=Fnum; Fmax=Fnum;
cumulate=1;
filescount=0
Fstring='';

for Fiter=Fmin:Fmax
    Fnum2=sprintf('%02d',Fiter);
    %list ascii_F_MT in dir
%    Input_ascii_dir=['/home/faivre/Ascii_RASTA_MTSAT/BT_IWP_heightLevels_PALX_15min_FSF' Fnum2 '/'];
    Input_ascii_dir=['/home/faivre/Ascii_RASTA_MTSAT/BT_IWP2_heightLevels_PALX_15minfixed_FSF' Fnum2 '/'];
    if ~exist(Input_ascii_dir)
        fprintf('%s\n',['not this MTSAT dir' Input_ascii_dir]);
        continue
    end
    system(['ls ' Input_ascii_dir 'RASTA_MT*matchingRef*' '.txt > list_matchingfiles.txt']);
    fid = fopen('list_matchingfiles.txt', 'r');
    Clist = textscan(fid, '%s\n');
    fclose(fid);
    system('rm -fr list_matchingfiles.txt');
    clear fid
    Ascii_matching_files = char(Clist{1});
    clear Clist
    disp(Ascii_matching_files);
%   pause;
    Nb_MTSATfiles=size(Ascii_matching_files,1);
    fprintf('%s\n','Nb_MTSATfiles');fprintf('%d\n',Nb_MTSATfiles);
%   pause;

     
%    MTstring=['\_MT' sprintf('%02i',ind_MTSAT_file)];
    if cumulate==1
        MTstring='allMT'
    end
    
    fprintf('%s\t','size(Ascii_matching_files)');fprintf('%d\n','size(Ascii_matching_files)');
    if size(Ascii_matching_files,1)==0
        continue
    end    
    indIR={5;17;18;19;20};
    if length(strfind(Input_ascii_dir,'IWP2'))>=1
      indIR={5;6;18;19;20;21};
    end
    for ind_matching_files=1:size(Ascii_matching_files,1)
         %1---read matching.txt files for this RASTA flight
            disp( Ascii_matching_files(ind_matching_files, :));
            system(['cp ' Ascii_matching_files(ind_matching_files, :) ' .']);
            name_input_file =Ascii_matching_files (ind_matching_files, (length(Input_ascii_dir)+1):(size(Ascii_matching_files, 2)));
            %read file
            %http://www.mathworks.fr/fr/help/matlab/ref/importdata.html#btldf1f-1
            delimiterIn = ' ';
            headerlinesIn = 4;
            %2---read Rasta_pos and calculated IWP from iwc_ret(z)
            %if exist()
            %//////// rads from mathcing "closest MTSAT from RASTA" file
            if ~exist(name_input_file)
                continue;
            end
         %  MTcount=MTcount+1;
         %  NbRastapaths=NbRastapaths+1;
            A = importdata(name_input_file,delimiterIn,headerlinesIn);
        filescount=filescount+1;
        if filescount==1
            RASTA_IWP1=A.data(:,indIR{1});
            RASTA_IWP2=A.data(:,indIR{2});
            RASTA_RAD1=A.data(:,indIR{3});
            RASTA_RAD2=A.data(:,indIR{4});
            RASTA_RAD3=A.data(:,indIR{5});
            RASTA_RAD4=A.data(:,indIR{6});
        else
            RASTA_IWP1=[RASTA_IWP1;A.data(:,indIR{1})];
            RASTA_IWP2=[RASTA_IWP2;A.data(:,indIR{2})];
            RASTA_RAD1=[RASTA_RAD1;A.data(:,indIR{3})];
            RASTA_RAD2=[RASTA_RAD2;A.data(:,indIR{4})];
            RASTA_RAD3=[RASTA_RAD3;A.data(:,indIR{5})];
            RASTA_RAD4=[RASTA_RAD4;A.data(:,indIR{6})];
        end
    end %for ind_mathcing
Fstring=[Fstring sprintf('%02d',Fiter)];
end %F#
fprintf('%s\n',Fstring)
%pause;

%---=== B. write arrays in ascii ===---
outputAscii=['globalAsciiRADS_IWP2_' Fstring '.txt'];
fileID= fopen(outputAscii, 'w');
hformat='%s\n';
header='RADS1 2 3 4 IWPtot IWPz>=9km '
fprintf(fileID,hformat,header);
%print data
dataformat='%8.4f %8.4f %8.4f %8.4f %8.4f %8.4f\n'
fprintf('%s\t','RASTAIWP size');fprintf('%d\n',size(RASTA_IWP1,1));
for ij=1:size(RASTA_IWP1,1)
  if RASTA_IWP1(ij)>=0
     fprintf(fileID,dataformat,RASTA_RAD1(ij), ...
             RASTA_RAD2(ij), ...
             RASTA_RAD3(ij), ...
             RASTA_RAD4(ij), ...
             RASTA_IWP1(ij), RASTA_IWP2(ij))
  end
end
fclose(fileID);
