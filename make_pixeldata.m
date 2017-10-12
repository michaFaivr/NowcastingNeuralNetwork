%%%20141209 from mats PixelRADi to Fullsample
%function [Fullsample,Pixel_data,Sz1] = make_pixeldata(data_sample, setP, PixelRAD1, PixelRAD2, PixelRAD3, PixelRAD4,nbRADS,PredicPixels)
%%20141211 use PixeRADS 4x2n,nnnn
function [Fullsample,Pixel_data,Sz1] = make_pixeldata(data_sample, setP, PixelRADS,nbRADS,PredicPixels,Part)
%a) linearize PIxelRADi 
%Nsize1=size(PixelRAD1,1)*size(PixelRAD1,2);
%Nsize2=size(PixelRAD2,1)*size(PixelRAD2,2);
%Nsize3=size(PixelRAD3,1)*size(PixelRAD3,2);
%Nsize4=size(PixelRAD4,1)*size(PixelRAD4,2);
%####### 20150129 flexibility on nbRADS ######
%# for Rsigma : how to do?
disp('PixelRADS in make_pixeldata')
whos PixelRADS

Nsize = zeros(nbRADS,numel(PixelRADS(:,1)));
Nsize1=numel(PixelRADS(:,1))
Nsize2=numel(PixelRADS(:,2))
Nsize3=numel(PixelRADS(:,3))
Nsize4=numel(PixelRADS(:,4))
whos Nsize
%
Sz1=[Nsize1,1];
Sz2=[Nsize2,1];
Sz3=[Nsize3,1];
Sz4=[Nsize4,1];
Sz = Nsize
%
VPixelR1=reshape(PixelRADS(:,1),Sz1);
VPixelR2=reshape(PixelRADS(:,2),Sz2);
VPixelR3=reshape(PixelRADS(:,3),Sz3);
VPixelR4=reshape(PixelRADS(:,4),Sz4);

VPixelR = reshape(PixelRADS(:,1),Sz1);
%
whos data_sample
whos setP
whos VPixelR1
whos VPixelR2
whos VPixelR3
whos VPixelR4
%pause
%
Sz1
N=numel(setP)
NN=N+Sz1(:,1)
%
Fullsample=zeros(NN,nbRADS);
%
switch PredicPixels
    case 'Fullsample'
    %concatenation des RADS pixels aux RADS ascii qui a servi au training du NNET
       BigRAD1=zeros(NN);
       BigRAD2=zeros(NN);
       BigRAD3=zeros(NN);
       BigRAD4=zeros(NN);
       A1=data_sample(setP,1)';
       A2=data_sample(setP,2)';
       A3=data_sample(setP,3)';
       A4=data_sample(setP,4)';
       BigRAD1=[A1 VPixelR1'];
       BigRAD2=[A2 VPixelR2'];
       BigRAD3=[A3 VPixelR3'];
       BigRAD4=[A4 VPixelR4'];
       whos BigRAD1
       Fullsample = [BigRAD1;BigRAD2;BigRAD3;BigRAD4];
       whos Fullsample
       Pixel_data=Fullsample(:,end-Sz1+1:end);
       whos Pixel_data
   case 'Pixeldata'
   %seult les RADS pixels
       BigRAD1=VPixelR1';
       BigRAD2=VPixelR2';
       BigRAD3=VPixelR3';
       BigRAD4=VPixelR4';
       whos BigRAD1
       whos BigRAD2
       whos BigRAD3
       whos BigRAD4
       whos PixelRADS
       BigRAD1(1:20)
       BigRAD2(1:20)
       BigRAD3(1:20)
       BigRAD4(1:20)
       PixelRADS(1:10,1)
       PixelRADS(1:10,2)
       PixelRADS(1:10,3)
       PixelRADS(1:10,4)
       %pause
%# 20150409 add condition on nbRADS !
       if nbRADS==4 %R1,R2,R3,R4
           Pixel_data = [BigRAD1;BigRAD2;BigRAD3;BigRAD4];
       elseif nbRADS==5
           Pixel_data = [BigRAD1;BigRAD1;BigRAD2;BigRAD3;BigRAD4];
       end
       whos Pixel_data
%pause
end %switch PredicPixel
%
%%%% CLASSIFY %%%%
%[Pixelgoup] = classify(training(Fullsample,data_training(setT,:),group);

%%%% reshape as matrix %%%%%
%
end

