function sr_sper=periodograma_sub(sg,chislo,np,fd,tp)
n=np/chislo;
obsh_chislo=chislo+chislo-1;
for q=1:obsh_chislo
   tnach=0.5*n*q-0.5*n+1;
   tconech=tnach+n-1;
   ts(q,1:n)=sg(1,tnach:tconech);
end;
% dividing whole experimental realisations on chislo parts with  (np/chislo)*(1/fd) seconds durations
% and moving them on 50% to obtain another chislo-1 (sum total chislo+chislo-1 short parts)
%Blackmann window
for qqqk=1:n
    qqqq=qqqk-1;
%    window(qqqk)=1.63*sin((pi*qqqq)/n)*sin((pi*qqqq)/n);
   window(1,qqqk)=1.81*(0.42323-0.49755*cos((2*pi*qqqq)/n)+0.07922*cos((4*pi*qqqq)/n));
end;
%Blackmann window
%windowing in time region
for qqqqq=1:obsh_chislo
   fff=qqqqq;
   tsw(qqqqq,1:n)=ts(qqqqq,1:n).*window;
end;
%windowing in time region
%adding to all shorts parts zeroes (nulei) to obtain whole durations tp
for qq=1:obsh_chislo
for qqq=1:np
if qqq<n+1
   tss(qq,qqq)=tsw(qq,qqq);
end;
if qqq>n
   tss(qq,qqq)=0;
end;
end;
end;
%adding to all shorts parts zeroes (nulei) to obtain whole durations tp
%Fourier transformaton
for kk=1:obsh_chislo
sss(kk,1:np)=(1/fd)*abs(fft(tss(kk,1:np),np));
end;
%Furier transformation
%obtaining periodograms all parts
for kv=1:obsh_chislo
sper(kv,1:np)=(1/tp)*sss(kv,1:np).*sss(kv,1:np);
end;
%obtaining periodograms all parts
%meaning obsh_chislo parts to obtain total periodogramma
sum_sper_s(1,1:np)=0;
for ssssss=1:obsh_chislo
   sum_sper_s(1,1:np)=sum_sper_s(1,1:np)+sper(ssssss,1:np);
end;
sr_sper(1,1:np)=sum_sper_s(1,1:np)*(chislo/obsh_chislo);
%   ATTENTION, please!
%!!!!!!!!!!!!!!!!!!! domnogenie na chislo/obsh_chislo uchituvaet chto real'no signal
%!!!!!!!!!!!!!!!!!!! sostoit iz chislo otrezkov a ne obsh_chislo (obsh_chislo-1 polucheni iskusstvenno by moving to 50%)
%
%meaning obsh_chislo parts to obtain total periodogramma
