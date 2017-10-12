%%%20141217 use NEWPR with 2 parts : (1) 0/1 classif (2) then on 1, more cloudy cases
%%% (1) thesholds_1, data_training_1, net_1, etc
%%% (2) _2 varnames 
%%% 2 PARTS A = focus on Low_MidIWP; PartB=focus on Mid_HighIWP

%%%%% Part§A : Newpr (later classify) 0/1 classif net_1 image %%%%%
Part = 'PartA' %0/1 classif
addpath('./TOOLS/');
    parametrization;
%
%    %--------------------------------------------------------
%    %<<<<<< Part§1: DATA,INPUTS,OUTPUTS preprocessings >>>>>>
%    %--------------------------------------------------------
%    %----- 1.read Inputs =RAD1,RAD2,IWP ----
    select_asciInput;
rmpath('./TOOLS/');

        %%% PART A %%%
        BIGPROCS_TRAIN;
        %%%
        BIGPROCS_SIMU;
  
%%   %%% PART§B keep pts only >thresholds_1(2) %%%
%%   cloudycases=find()   
%   Part = 'PartB' %1--> {1,..,20} classif
%   parametrization;  
%Part='PartB';
%addpath('./TOOLS/');
%    parametrization;
%
%    %%%% a) name file:made by build_ascii.m %%%%%
%    select_asciInput;
%rmpath('./TOOLS/');
%
%%%20141219 @6pm:deactive since pb with F06M23 'none'
%       %%% PART B %%%
%       BIGPROCS_TRAIN;
%       %%% 
%       BIGPROCS_SIMU;
%%% 
    clear all
    system('rm -f *nc')
