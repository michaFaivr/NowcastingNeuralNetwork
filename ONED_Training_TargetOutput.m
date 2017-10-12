%# 20150511 in training part compare scan Target vs Output restricted to F#,MT#


%////////////////////////////////
%1. get IWPcl and Y over F#,MT# 
%////////////////////////////////
%Fnumvect=
disp('Frank')
Frank
disp('MTnum')
MTnum
whos Fnumvect
whos MTnumvect
min(Fnumvect)
max(Fnumvect)
min(MTnumvect)
max(MTnumvect)

%FMTT= find(Fnumvect==Frank & MTnumvect==MTnum);
%FMTT= find(Fnumvect==Frank & MTnumvect==MTnum);
FMTT= find(Fnumvect==Frank)
whos FMTT
%pause
[RASTA_spotsort, Isort]=sort(RASTAspot(FMTT))
%pause
clf
whos RASTA_spotsort
whos Isort
whos FMTT
whos RASTAspot

RASTA_spotsort
FMTT(Isort)
%pause

figure(2)
hold off
%%use RASTAspot to sort correctly
%RASTA_spotsort = xaxis
%%1-  Y     = Output fcn 
%%2-  IWPcl = Target
%%--> plot (x, Y, x, lindata)

%%plot(RASTA_spotsort, IWPcl(FMTT(Isort)), 'k-', RASTA_spotsort, Y(FMTT(Isort)),'b-')
x=1:numel(FMTT);
plot(x,IWPcl(FMTT),'k--', x,Y(FMTT),'r-' )
print('-depsc', '-r1000', 'TraingingVerif1D')
clear Isort
