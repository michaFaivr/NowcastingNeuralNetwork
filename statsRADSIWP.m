%%%20141127 plot RAD1 [0,2] step 0.5 --> RAD2,3,4avg classifOK/Bad
%steprad1=0.5:0.25:6; N=numel(steprad1)-1; 
%%20141128 reduce step RAD1
steprad1=0.5:0.1:6; N=numel(steprad1)-1;
%steprad2=steprad1;
%steprad3=
goodclAvg= zeros(nbRADS+1,2*N);
badclAvg = zeros(nbRADS+1,2*N);
A1=RAD1(sample_set(setP(goodclmask==1)));
A2=RAD2(sample_set(setP(goodclmask==1)));
A3=RAD3(sample_set(setP(goodclmask==1)));
A4=RAD4(sample_set(setP(goodclmask==1)));
A5=IWP(sample_set(setP(goodclmask==1)));
B1=RAD1(sample_set(setP(goodclmask~=1)));
B2=RAD2(sample_set(setP(goodclmask~=1)));
B3=RAD3(sample_set(setP(goodclmask~=1)));
B4=RAD4(sample_set(setP(goodclmask~=1)));
B5=IWP(sample_set(setP(goodclmask~=1)));
numelA=zeros(N,1);numelB=zeros(N,1);
for  ii=1:N
    %%%good classif
    setA=find(A1>=steprad1(ii) & A1<steprad1(ii+1));
    numelA(ii)=numel(setA);
    if numel(setA)>1
       %avg
       goodclAvg(1,ii)=mean(mean(A1(setA)));
       goodclAvg(2,ii)=mean(mean(A2(setA)));
       goodclAvg(3,ii)=mean(mean(A3(setA)));
       goodclAvg(4,ii)=mean(mean(A4(setA)));
       goodclAvg(5,ii)=mean(mean(A5(setA)));
       %sigma
       goodclAvg(1,ii+N)=std(A1(setA));
       goodclAvg(2,ii+N)=std(A2(setA));
       goodclAvg(3,ii+N)=std(A3(setA));
       goodclAvg(4,ii+N)=std(A4(setA));
       goodclAvg(5,ii+N)=std(A5(setA));
    end
    clear setA;
    %%%bad classif
    setB=find(B1>=steprad1(ii) & B1<steprad1(ii+1));
    numelB(ii)=numel(setB);
    if numel(setB)>1
       %avg
       badclAvg(1,ii)=mean(mean(B1(setB)));
       badclAvg(2,ii)=mean(mean(B2(setB)));
       badclAvg(3,ii)=mean(mean(B3(setB)));
       badclAvg(4,ii)=mean(mean(B4(setB)));
       badclAvg(5,ii)=mean(mean(B5(setB)));
       %sig
       badclAvg(1,ii+N)=std(B1(setB));
       badclAvg(2,ii+N)=std(B2(setB));
       badclAvg(3,ii+N)=std(B3(setB));
       badclAvg(4,ii+N)=std(B4(setB));
       badclAvg(5,ii+N)=std(B5(setB));
    end
    clear setB;
end %for ii
figure(11)
%%%plot avg,sigs
%x=RADS1 steps; y=RAD1 good/bad +/-sigma
%legendstr={'RAD1avg goodclassif';'RAD1avg badclassif';'RAD2avg goodclassif';'RAD2avg badclassif'}
%for jj=1:N
%legendstr={'RAD1avg goodclassif';'RAD1avg badclassif';'RAD2avg goodclassif';'RAD2avg badclassif'}
%end
subplot(2,3,1)
errorbar(steprad1(1:N),goodclAvg(1,1:N),goodclAvg(1,N+1:N+N),'rx');hold on
xlabel('Rad1 steps');
errorbar(steprad1(1:N), badclAvg(1,1:N), badclAvg(1,N+1:N+N),'kx');
title('RAD1avg red=goodcl,black=badcl')
%legend('RAD1avg goodclassif','RAD1avg badclassif','Location','southwest')
%legend('boxoff')
ylim([0 steprad1(end)]);
%x=RADS1 steps; y=RAD2 good/bad +/-sigma
subplot(2,3,2)
errorbar(steprad1(1:N),goodclAvg(2,1:N),goodclAvg(2,N+1:N+N),'rx');hold on
errorbar(steprad1(1:N), badclAvg(2,1:N), badclAvg(2,N+1:N+N),'kx');
title('RAD2avg red=goodcl,black=badcl')
%legend('RAD2avg goodclassif','RAD2avg badclassif','Location','southwest')
%legend('boxoff')
ylim([0 steprad1(end)]);
%x=RADS1 steps; y=RAD3 good/bad +/-sigma
subplot(2,3,3)
errorbar(steprad1(1:N),goodclAvg(3,1:N),goodclAvg(3,N+1:N+N),'rx');hold on
errorbar(steprad1(1:N), badclAvg(3,1:N), badclAvg(3,N+1:N+N),'kx');
title('RAD3avg red=goodcl,black=badcl')
%x=RADS1 steps; y=RAD4 good/bad +/-sigma
subplot(2,3,4)
errorbar(steprad1(1:N),goodclAvg(4,1:N),goodclAvg(4,N+1:N+N),'rx');hold on
errorbar(steprad1(1:N), badclAvg(4,1:N), badclAvg(4,N+1:N+N),'kx');
title('RAD4avg red=goodcl,black=badcl')
%x=IWP steps; y=RAD4 good/bad +/-sigma
subplot(2,3,5)
errorbar(steprad1(1:N),goodclAvg(5,1:N),goodclAvg(5,N+1:N+N),'rx');hold on
errorbar(steprad1(1:N), badclAvg(5,1:N), badclAvg(5,N+1:N+N),'kx');
%set(gca, 'YScale', 'log');
ylim([0 5E3])
title('IWPavg red=goodcl,black=badcl')
%legend('IWPavg goodclassif','IWPavg badclassif','Location','southwest')
%legend('boxoff')
%x=NBpts; y=RAD4 good/bad +/-sigma
subplot(2,3,6)
plot(steprad1(1:N),numelA,'rx');hold on
plot(steprad1(1:N),numelB,'kx');
set(gca, 'YScale', 'log');
title('NB pts per R1 range')
%
print('-dpng', '-r2000','classify_CheckingStatsRADSIWP')
%
%%% plot diffs
figure(14)
%Rad1 good-badclassif
subplot(2,3,1)
plot(steprad1(1:N),goodclAvg(1,1:N)-badclAvg(1,1:N),'rx');hold on
hline = refline([0 0]);
xlabel('Rad1 steps');
title('RAD1avg good-bad classif')
%Rad2 good-badclassif
subplot(2,3,2)
plot(steprad1(1:N),goodclAvg(2,1:N)-badclAvg(2,1:N),'rx');hold on
hline = refline([0 0]);
xlabel('Rad1 steps');
title('RAD2avg good-bad classif')
%Rad3 good-badclassif
subplot(2,3,3)
plot(steprad1(1:N),goodclAvg(3,1:N)-badclAvg(3,1:N),'rx');hold on
hline = refline([0 0]);
xlabel('Rad1 steps');
title('RAD3avg good-bad classif')
%Rad3 good-badclassif
subplot(2,3,4)
plot(steprad1(1:N),goodclAvg(4,1:N)-badclAvg(4,1:N),'rx');hold on
hline = refline([0 0]);
xlabel('Rad1 steps');
title('RAD4avg good-bad classif')
%IWP good-badclassif
subplot(2,3,5)
plot(steprad1(1:N),goodclAvg(5,1:N)-badclAvg(5,1:N),'rx');hold on
hline = refline([0 0]);
xlabel('Rad1 steps');
title('IWPavg good-bad classif')
%
print('-dpng', '-r2000','classify_CheckingStatsRADSIWPdiffs')

