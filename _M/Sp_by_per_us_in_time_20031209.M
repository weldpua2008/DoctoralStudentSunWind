script
% PROGRAM FOR OBTAINING EXPERIMENTAL POWER SPECTRA BY PERIODOGRAM METHOD and CORRELOGRAM METHOD TOGETHER
pi=3.14;
%%%%%%%%%%%%%%%%%%%%                                  %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%  COMMON BLOCKS FOR BOTH METHODS  %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%                                  %%%%%%%%%%%%%%%%%%%%%%%%%%%  
%                   BLOCK DETERMINATION OF PARAMETERS OF RECORDINGS 
%np - number of points in whole realisations
np=600;
%sampling frequency (in Hz)
fd=20;
%duration of whole realisations
tp=np/fd;
%number of experimental realisation after frequency aweraging
n_realization=3;
%                   BLOCK DETERMINATION OF PARAMETERS OF RECORDINGS 
%                   FORMINING INPUT PROCESSES BLOCK
load dat_011205.yyy
%both channels North-South and West-East on frequency 20 MHz 
%were weaken on 4 dB on input (chennel 4 after multiplication), 
%so it is necessary to do compensation oslablenie=equal 4dB=6.25 in chennel 4
%for chennel 5 (26 MHz) oslablenie=1.
oslablenie=1;
dd1=dat_011205(1501:2100,14);
dd2=dat_011205(25751:26350,14);
dd3=dat_011205(102051:102650,14);
dd4=dat_011205(1501:2100,15);
dd5=dat_011205(25751:26350,15);
dd6=dat_011205(102051:102650,15);
dd7=dat_011205(1501:2100,16);
dd8=dat_011205(25751:26350,16);
dd9=dat_011205(102051:102650,16);
sig(1,1:600)=dd1';
sig(2,1:600)=dd2';
sig(3,1:600)=dd3';
sig(4,1:600)=dd4';
sig(5,1:600)=dd5';
sig(6,1:600)=dd6';
sig(7,1:600)=dd7';
sig(8,1:600)=dd8';
sig(9,1:600)=dd9';
%sig(10,1:600)=dd10';
%sig(11,1:600)=dd11';
%sig(12,1:600)=dd12';
%normalization of time realisations
for i=1:3*n_realization
ps(i)=mean(sig(i,1:np));
sig(i,1:np)=sig(i,1:np)/ps(i);
end;
%normalization of time realisations
%subtraction constant component
for i=1:3*n_realization
ps2(i)=mean(sig(i,1:np));
sig(i,1:np)=sig(i,1:np)-ps2(i);
end;
%subtraction constant component
%frequency averaging
for i=1:n_realization
signal(i,1:np)=(sig(i,1:np)+sig(i+n_realization,1:np)+sig(i+2*n_realization,1:np))/3;
end;
%frequency averaging
%                   FORMINING INPUT PROCESSES BLOCK
%%%%%%%%%%%%%%%%%%%%                                  %%%%%%%%%%%%%%%%%%%%%%%%%%%
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%%%%%%%%%%%%%%%%%%%%  PERIODOGRAM BLOCKS              %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%                                  %%%%%%%%%%%%%%%%%%%%%%%%%%%  
%determination of power spectrum of each experimental realisation by periodograma method (subprogram periodograma_sub)
%chislo - number of parts we will divide whole realisations and n - number of points in each part
%(by another words chislo - determine 3 diferent spectral resolution)
for j=1:3
chislo=2*j-1;
for i=1:n_realization
sr_sper(j,i,1:np)=periodograma_sub(signal(i,1:np),chislo,np,fd,tp);
end;
end;
%determination of power spectrum of each experimental realisation by periodograma method (subprogram periodograma_sub)
%                       PERIODOGRAM BILDING BLOCK
%                       CORRECTION ON RC FILTER BLOCK
fr=fd*(0:np-1)/np;
post=0.01;
hf=1./(1+(2*3.14*fr*post).*(2*3.14*fr*post));
for j=1:3
for i=1:n_realization
    promegutok(1,1:np)=sr_sper(j,i,1:np);
    sdk_kor(j,i,1:np)=promegutok./hf;
end;
end;
%                       CORRECTION ON RC FILTER BLOCK
%                       SUBSTRACTION NOISE BLOCK
%calculation points of realisation, corresponding to 5 and 10 Hz (i.e. region where there is no signal, only noise)
n_v1=round(1/(fd/np));
n_v2=round(2/(fd/np));
%n_v1=60;
%n_v2=120;
%calculation points of realisation, corresponding to 5 and 10 Hz (i.e. region where there is no signal, only noise)
%determination noise level by meaning this region
for j=1:3
for i=1:n_realization
level_noise(j,i)=mean(sdk_kor(j,i,n_v1:n_v2));
end;
end;
%determination noise level by meaning this region
for j=1:3
for i=1:n_realization
spectr_p_i(j,i,1:np)=sdk_kor(j,i,1:np)-level_noise(j,i);
end;
end;
%                       SUBSTRACTION NOISE BLOCK
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%%%%%%%%%%%%%%%%%%%%    PERIODOGRAM BLOCKS              %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%                                  %%%%%%%%%%%%%%%%%%%%%%%%%%%  
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%%%%                    CALCULATION SCINTILLATIONS INDEX AND SIGNAL TO NOISE RATIO BLOCK 
%%%%                    FROM SPECTRUM WITH MAX RESOLUTION chislo=1                                %%%%%%%%%% 
%%%% calculation dispersion signal and noise by integration corresponding parts of each spectra   %%%%%%%%%%
for i=1:n_realization
spectr_p_i3(i,1:np)=spectr_p_i(1,i,1:np);
end;
for i=1:n_realization
for ji=1:np
%frequency where scintillations spectrum equal noise spectrum determinates here and equal 1Hz
if ji<=round(0.9/(fd/np));
func_signal_noise(i,ji)=spectr_p_i3(i,ji);
end;
if ji>round(0.9/(fd/np));
func_signal_noise(i,ji)=level_noise(1,i)*hf(1,ji);
end;
end;
end;
for i=1:n_realization
st=0;
for ji=1:np
st=st+func_signal_noise(i,ji)*(fd/np);
end;
disp_signal_noise(i)=2*st;
end;
disp_signal_noise_mean=mean(disp_signal_noise);
for i=1:n_realization
func_noise(i,1:np)=level_noise(1,i)*hf;
end;
func_noise_mean(1,1:np)=mean(func_noise);
for i=1:n_realization
nt=0;
for ji=1:np
nt=nt+func_noise(i,ji)*(fd/np);
end;
disp_noise(i)=2*nt;
end;
disp_noise_mean=mean(disp_noise);
for i=1:n_realization
disp_signal(i)=disp_signal_noise(i)-disp_noise(i);
end;
%disp_signal_mean=mean(disp_signal)
%%%% calculation dispersion signal and noise by integration corresponding parts of each spectra   %%%%%%%%%%
%%%% signal to noise rations
%for i=1:n_realization
%std_signal(i)=sqrt(disp_signal(i));
%std_noise(i)=sqrt(disp_noise(i));
%end;
%for i=1:n_realization
%otn_sig_noi(i)=std_signal(i)/std_noise(i);
%end;
%otn_sig_noi_mean=mean(otn_sig_noi)
%%%% signal to noise rations
%%%% scintillations index
%for i=1:n_realization
%    intensity(i)=
%end;
%for i=1:n_realization
%intensity(i)=ps(i)
%scint_index(i)=sqrt((disp_signal_noise(i)-disp_noise(i))/(intensity(i)*intensity(i)))
%end;
%scint_index_mean=mean(scint_index)
%scint_index_max=max(scint_index);
%scint_index_min=min(scint_index);
%abmodality
%mean_plus_this=scint_index_max-scint_index_mean
%mean_minus_this=scint_index_mean-scint_index_min
%abmodality
%%%% scintillations index
%%%%                    CALCULATION SCINTILLATIONS INDEX AND SIGNAL TO NOISE RATIO BLOCK 
%%%%                    FROM SPECTRA WITH MAX RESOLUTION chislo=1                                %%%%%%%%%% 
%%%%                    ENSEMBLE AVERAGING 
% for different resolution with saving real mashtab(To obtain dispersion it's necessary * 2)
for j=1:3
sum_sp(j,1,1:np)=0;
for i=1:n_realization
    sum_sp(j,1,1:np)=sum_sp(j,1,1:np)+sdk_kor(j,i,1:np);
end;
spectr_p(j,1:np)=sum_sp(j,1,1:np)/n_realization;
end;
% for different resolution with saving real mashtab(To obtain dispersion it's necessary * 2)
% for resolution =1 with normalization on individual dispersion (For final visualisation)
sum_sp(1,1,1:np)=0;
for i=1:n_realization
    sum_sp(1,1,1:np)=sum_sp(1,1,1:np)+sdk_kor(1,i,1:np);
%    sum_sp(1,1,1:np)=sum_sp(1,1,1:np)+sdk_kor(1,i,1:np)/disp_signal(i);
end;
spectr_p_norm(1,1:np)=sum_sp(1,1,1:np)/n_realization;
% for resolution =1 with normalization on individual dispersion (For final visualisation)
%%%%                    ENSEMBLE AVERAGING 
%                       CONFIDENCE LIMITS BLOCK
%generation 60 noise
for k=1:30
noise(k,1:np)=randn(1,np);
end;
%generation 60 noise
%convolution noise with one experimental realisation
for k=1:30
svertka(k,1:2*np-1)=conv(noise(k,1:np),signal(1,1:np));
signal_m(k,1:np)=svertka(k,1:np);
end;
%convolution noise with one experimental realisation
%bild up model power spectra
for k=1:30
sp(k,1:np)=periodograma_sub(signal_m(k,1:np),1,np,fd,tp);
end;
%bild up model power spectra
%ensemble averaging
sum_sp(1,1:np)=0;
for i=1:30
    sum_sp(1,1:np)=sum_sp(1,1:np)+sp(k,1:np);
end;
sr_sp(1,1:np)=sum_sp(1,1:np)/30;
%ensemble averaging
%subtraction noise
level_sn=mean(sr_sp(1,n_v1:n_v2));
for k=1:30
s(k,1:np)=sp(k,1:np)-level_sn;
end;
%subtraction noise
%averaging after subtraction noise
sum_s(1,1:np)=0;
for k=1:30
sum_s(1,1:np)=sum_s(1,1:np)+s(k,1:np);
end;
sr(1,1:np)=sum_s(1,1:np)/30;
%averaging after subtraction noise
%input experimental spectrum
sreal(1,1:np)=spectr_p(1,1:np);
gropa=sr(1)/sreal(1);
sreal=sreal*gropa;
%input experimental spectrum
%determination confidence limits of one experimental realization
for k=1:30   
rkv(k,1:np)=(s(k,1:np)-sr(1,1:np)).*(s(k,1:np)-sr(1,1:np));
end;
sum_rkv(1,1:np)=0;
for k=1:30
    sum_rkv(1,1:np)=sum_rkv(1,1:np)+rkv(k,1:np);
end;
sr_rkv(1,1:np)=sum_rkv(1,1:np)/30;
sigma=sqrt(sr_rkv);
disp_p=sigma./sr;
smesh_p=(sr-sreal)./sr;
pogresh_p=sqrt(disp_p.*disp_p+smesh_p.*smesh_p);
%determination confidence limits of one experimental realization
%determination confidence limits of n_realization experimental realization
pogresh_p=pogresh_p/sqrt(n_realization);
%determination confidence limits of n_realization experimental realization
%%%% VISUALISATION BLOCK
figure(1)
loglog(fr(1:0.5*np),spectr_p(1,1:0.5*np),'-b')
title('Power spectrum of scintillations (resolution - all time realisation divided on 1 part + 1 part obtained by 50% shifting)','FontSize',8)
figure(2)
loglog(fr(1:0.5*np),spectr_p(2,1:0.5*np),'ob'),grid
title('Power spectrum of scintillations (resolution - all time realisation divided on 3 parts + 2 parts obtained by 50% shifting)','FontSize',8)
figure(3)
loglog(fr(1:0.5*np),spectr_p(3,1:0.5*np),'ob',fr(1:0.5*np),func_noise_mean(1,1:0.5*np),'or'),grid
title('Power spectrum of scintillations (resolution - all time realisation divided on 5 parts + 4 parts obtained by 50% shifting)','FontSize',8)
figure(4)
loglog(fr(1:0.5*np),spectr_p_norm(1,1:0.5*np)/spectr_p_norm(1,2),'-b','LineWidth',2),grid
axis([0.01 5 0.0001 10])
title('3C144 00.00 01.30  01.12.2005  e=+165.3  ks=0.7 m=0.19 N=3','FontSize',10)
figure(5)
for i=1:n_realization
if i==3
loglog(fr(1:0.5*np),spectr_p_i3(1,1:0.5*np)/(disp_signal(1)*spectr_p_i3(1,1)),'-b',fr(1:0.5*np),spectr_p_i3(2,1:0.5*np)/(disp_signal(2)*spectr_p_i3(2,2)),'-r',fr(1:0.5*np),spectr_p_i3(3,1:0.5*np)/(disp_signal(3)*spectr_p_i3(3,2)),'-g'),grid
%loglog(fr(1:0.5*np),spectr_p_i3(1,1:0.5*np)/(disp_signal(1)*spectr_p_i3(1,1)),'-b',fr(1:0.5*np),spectr_p_i3(2,1:0.5*np)/(disp_signal(2)*spectr_p_i3(2,1)),'-r',fr(1:0.5*np),spectr_p_i3(3,1:0.5*np)/(disp_signal(3)*spectr_p_i3(3,1)),'-g',fr(1:0.5*np),spectr_p_i3(4,1:0.5*np)/(disp_signal(4)*spectr_p_i3(4,1)),'-k',fr(1:0.5*np),spectr_p_i3(5,1:0.5*np)/(disp_signal(5)*spectr_p_i3(5,1)),'ob',fr(1:0.5*np),spectr_p_i3(6,1:0.5*np)/(disp_signal(6)*spectr_p_i3(6,1)),'or',fr(1:0.5*np),spectr_p_i3(7,1:0.5*np)/(disp_signal(7)*spectr_p_i3(7,1)),'og',fr(1:0.5*np),spectr_p_i3(8,1:0.5*np)/(disp_signal(8)*spectr_p_i3(8,1)),'ok',fr(1:0.5*np),spectr_p_i3(9,1:0.5*np)/(disp_signal(9)*spectr_p_i3(9,1)),'.b',fr(1:0.5*np),spectr_p_i3(10,1:0.5*np)/(disp_signal(10)*spectr_p_i3(10,1)),'.r'),grid
end;
%axis([0.01 5 0.0001 10])
end;
figure(6)
semilogx(fr(1:25),pogresh_p(1:25),'-b'),grid
title('Confidence limits','FontSize',8)
figure(7)
loglog(fr(1:np),func_signal_noise(1,1:np),'-b',fr(1:np),func_signal_noise(2,1:np),'-b',fr(1:np),func_signal_noise(3,1:np),'-b')
%%%%  VISUALISATION BLOCK%                   
%%%%% MAKING RECORD BLOCK
for i=1:n_realization
sdk_kor_res1(i,1:np)=sdk_kor(1,i,1:np);
end;
z=[fr(1:0.5*np);spectr_p_norm(1,1:0.5*np);pogresh_p(1,1:0.5*np);sdk_kor_res1(1,1:0.5*np);sdk_kor_res1(2,1:0.5*np);sdk_kor_res1(3,1:0.5*np)];
%z=[fr(1:0.5*np);spectr_p_norm(1,1:0.5*np);pogresh_p(1,1:0.5*np);sdk_kor_res1(1,1:0.5*np);sdk_kor_res1(2,1:0.5*np);sdk_kor_res1(3,1:0.5*np);sdk_kor_res1(4,1:0.5*np);sdk_kor_res1(5,1:0.5*np);sdk_kor_res1(6,1:0.5*np);sdk_kor_res1(7,1:0.5*np);sdk_kor_res1(8,1:0.5*np);sdk_kor_res1(9,1:0.5*np);sdk_kor_res1(10,1:0.5*np);sdk_kor_res1(11,1:0.5*np);sdk_kor_res1(12,1:0.5*np);sdk_kor_res1(13,1:0.5*np);sdk_kor_res1(14,1:0.5*np);sdk_kor_res1(15,1:0.5*np);sdk_kor_res1(16,1:0.5*np);sdk_kor_res1(17,1:0.5*np);sdk_kor_res1(18,1:0.5*np);sdk_kor_res1(19,1:0.5*np);sdk_kor_res1(20,1:0.5*np)];
fid=fopen('dat_011205_ind3.yyy','w');
fprintf(fid,'%18.8f%18.8f%18.8f%18.8f%18.8f%18.8f\r',z);
fclose(fid);
%%%% 
%from time realisation without substraction noise
for i=1:n_realization/3
   YYYY20_25=corrcoef(signal(1,1:np),signal(2,1:np));
   YYYY20_30=corrcoef(signal(1,1:np),signal(3,1:np));
   YYYY25_30=corrcoef(signal(2,1:np),signal(3,1:np));
   kt20_25=YYYY20_25(2,1)
   kt20_30=YYYY20_30(2,1)
   kt25_30=YYYY25_30(2,1)
   kt_mean=(kt20_25+kt20_30+kt25_30)/3;
end;
scint_index_20=sqrt(cov(signal(1,1:600)))/intensity(1)
scint_index_23=sqrt(cov(signal(2,1:600)))/intensity(2)
scint_index_25=sqrt(cov(signal(3,1:600)))/intensity(3)
%%%%
%                   MAKING RECORD BLOCK
clear














