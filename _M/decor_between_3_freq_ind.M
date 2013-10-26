
script
% PROGRAM FOR OBTAINING COEFFICIENT CORRELATIONS OF SCINTILLATIONS ON THREE FREQUENCIES
% BY THREE METHODS.
% used two subprograms.
pi=3.14;
%                   DIFFERENCE FROM OTHER PROGRAM:
% decor_between_3_freq.m 
% in this program when the correlation calculates from time realisations
% the first, the mean noise dispersion for all realisation is obtained.
% and than it is subtructed from siganl+noise dispersions in each realisations
%
% decor_between_3_freq_ind.m 
% in this program when the correlation calculates from time realisations
% the first, the noise dispersions for each realisations are obtained.
% and than they are subtructed from siganl+noise dispersions in each realisations.
%                   DIFFERENCE FROM OTHER PROGRAM:
%                   BLOCK DETERMINATION OF PARAMETERS OF RECORDINGS 
%np - number of points in whole realisations
np=600;
%sampling frequency (in Hz)
fd=20;
%duration of whole realisations
tp=np/fd;
%number of experimental realisation on source
n_realization=3;
%number of experimental realisation out of source
%                   BLOCK DETERMINATION OF PARAMETERS OF RECORDINGS 
%                   FORMINING INPUT PROCESSES BLOCK
load dat_011205.yyy
%on source
%dd1=dat_281007(49101:49700,10);
%dd1=dat_281007(121601:122200,10);
%dd1=dat_281007(193801:194400,10);
%dd1=dat_281007(212501:213100,10);
dd1=dat_011205(1501:2100,14);
dd2=dat_011205(1501:2100,15);
dd3=dat_011205(1501:2100,16);
% on source
signal(1,1:600)=dd1';
signal(2,1:600)=dd2';
signal(3,1:600)=dd3';
%subtraction constant component
for i=1:n_realization
ps(i)=mean(signal(i,1:np));
signal(i,1:np)=signal(i,1:np)-ps(i);
end;
%subtraction constant component
%                     FORMINING INPUT PROCESSES BLOCK
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
%                      PERIODOGRAM BILDING BLOCK
%                      CORRECTION ON RC FILTER BLOCK
fr=fd*(0:np-1)/np;
post=0.01;
hf=1./(1+(2*3.14*fr*post).*(2*3.14*fr*post));
for j=1:3
for i=1:n_realization
    promegutok(1,1:np)=sr_sper(j,i,1:np);
    sdk_kor(j,i,1:np)=promegutok./hf;
end;
end;
%                      CORRECTION ON RC FILTER BLOCK
%                      SUBSTRACTION NOISE BLOCK
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
%ensemble averaging (if experimental realisations more then one) 
for j=1:3
sum_sp(j,1,1:np)=0;
for i=1:n_realization
    sum_sp(j,1,1:np)=sum_sp(j,1,1:np)+spectr_p_i(j,i,1:np);
end;
spectr_p(j,1:np)=sum_sp(j,1,1:np)/n_realization;
end;
%ensemble averaging (if experimental realisations more then one) 
%                      SUBSTRACTION NOISE BLOCK
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%%%%%%%%%%%%%%%%%%%%   PERIODOGRAM BLOCKS              %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%                                  %%%%%%%%%%%%%%%%%%%%%%%%%%%  
%!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
%%%%                   CALCULATION DISPERSIONS, SCINTILATIONS INDEX, SIGNAL TO NOISE RATIO %%%%%% 
%%%%                   FROM MAX SMOOTHING SPECTRUM chislo=3 BLOCK                                %%%%%% 
%%%% calculation dispersion signal and noise by integration corresponding parts of each spectra   %%%%%%%%%%
for i=1:n_realization
%!!!!!!For more precise integration of spectra it takes the spectra with
%!!!!!!the list frequency resolution(1- the highest and 3 the list frequency resolution)
spectr_p_i3(i,1:np)=spectr_p_i(3,i,1:np);
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
%Dispersiya ravna ydvoennomy integraly ot spectra
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
%Dispersiya ravna ydvoennomy integraly ot spectra
disp_noise(i)=2*nt;
end;
disp_noise_mean=mean(disp_noise);
for i=1:n_realization
disp_signal(i)=disp_signal_noise(i)-disp_noise(i);
end;
disp_signal_mean=mean(disp_signal);
%%%% calculation dispersion signal and noise by integration corresponding parts of each spectra   %%%%%%%%%%
%%%% signal to noise rations
for i=1:n_realization
std_signal(i)=sqrt(disp_signal(i));
std_noise(i)=sqrt(disp_noise(i));
end;
for i=1:n_realization
otn_sig_noi(i)=std_signal(i)/std_noise(i);
end;
otn_sig_noi_mean=mean(otn_sig_noi);
%%%% signal to noise rations
%%%% scintillations index
for i=1:n_realization
intensity(i)=ps(i);
scint_index(i)=sqrt((disp_signal_noise(i)-disp_noise(i))/(intensity(i)*intensity(i)));
viz_scint_index(i)=scint_index(i);
end;
scint_index_mean=mean(scint_index);
scint_index_max=max(scint_index);
scint_index_min=min(scint_index);
%abmodality
mean_plus_this=scint_index_max-scint_index_mean;
mean_minus_this=scint_index_mean-scint_index_min;
%abmodality
%%%% scintillations index
%%%% calculation dispersion signal and noise by integration corresponding parts of each spectra   %%%%%%%%%%
%%%%                   CALCULATION DISPERSIONS, SCINTILATIONS INDEX, SIGNAL TO NOISE RATIO %%%%%% 
%                      CORRELATION COEFFICIENTS BLOCK
%with using dispersions from spectra for subtraction of noise
    chis20_25=mean(signal(1,1:np).*signal(2,1:np));
    chis20_30=mean(signal(1,1:np).*signal(3,1:np));
    chis25_30=mean(signal(2,1:np).*signal(3,1:np));
    znam20_25=sqrt(disp_signal(1)*disp_signal(2));
    znam20_30=sqrt(disp_signal(1)*disp_signal(3));
    znam25_30=sqrt(disp_signal(2)*disp_signal(3));
    ks20_25=chis20_25/znam20_25
    ks20_30=chis20_30/znam20_30
    ks25_30=chis25_30/znam25_30
    ks_mean=(ks20_25+ks20_30+ks25_30)/3;
%with using dispersions from spectra for subtraction of noise
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
scint_index_20=sqrt(cov(signal(1,1:600)))/intensity(1);
scint_index_23=sqrt(cov(signal(2,1:600)))/intensity(2);
scint_index_25=sqrt(cov(signal(3,1:600)))/intensity(3);
figure(1)
loglog(fr(1:0.5*10/(fd/np)),func_noise(1,1:0.5*10/(fd/np)),'-b',fr(1:0.5*10/(fd/np)),func_signal_noise(1,1:0.5*10/(fd/np)),'-r')
figure(2)
loglog(fr(1:0.5*10/(fd/np)),func_noise(2,1:0.5*10/(fd/np)),'-b',fr(1:0.5*10/(fd/np)),func_signal_noise(2,1:0.5*10/(fd/np)),'-r')
figure(3)
loglog(fr(1:0.5*10/(fd/np)),func_noise(3,1:0.5*10/(fd/np)),'-b',fr(1:0.5*10/(fd/np)),func_signal_noise(3,1:0.5*10/(fd/np)),'-r')














