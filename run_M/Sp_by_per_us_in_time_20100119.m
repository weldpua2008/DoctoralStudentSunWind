%%% function [out_scint_index_mean,out_mean_minus_this,out_mean_plus_this,out_scint_index_mean2,out_mean_minus_this2,out_mean_plus_this2]=Sp_by_per_us_in_time_20100119(dots_array,only_2channel_array,channel_array,start_channel,different_channel_array,dat_,TableName,dbid,path,FileName,FileRegexprName)
% out_scint_index_mean='';out_mean_minus_this='';out_mean_plus_this='';out_scint_index_mean2='';out_mean_minus_this2='';out_mean_plus_this2='';
% out_scint_index_mean=java.util.Hashtable;
 % PROGRAM FOR OBTAINING EXPERIMENTAL POWER SPECTRA BY PERIODOGRAM METHOD and CORRELOGRAM METHOD TOGETHER

 
 % ScintPrefix= [05all 0507 07all]
 
function [ out_scint_index_mean,out_mean_minus_this,out_mean_plus_this,out_scint_index_mean2,out_mean_minus_this2,out_mean_plus_this2]=Sp_by_per_us_in_time_20100119(dots_array,only_2channel_array,channel_array,start_channel,different_channel_array,dat_,TableName,ScintTableName,dbid,path,FileName,FileRegexprName,ScintPrefix)

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
 n_realization=size(dots_array);
 
 %                   BLOCK DETERMINATION OF PARAMETERS OF RECORDINGS 
 %                   FORMINING INPUT PROCESSES BLOCK
 % load dat_141107.yyy
 %both channels North-South and West-East on frequency 20 MHz 
 %were weaken on 4 dB on input (chennel 4 after multiplication), 
 %so it is necessary to do compensation oslablenie=equal 4dB=6.25 in chennel 4
 %for chennel 5 (26 MHz) oslablenie=1.
 oslablenie=1;
 
n=size(dots_array);
 z_index=0;
 %big='';
 for i=1:n
    channel_array.put(i,start_channel);        
        value=different_channel_array.get(i);
        if(value>0)
            channel_array.put(i,value);
        end   
    only_2_channel=only_2channel_array.get(i);
    [token, remain] = strtok(only_2_channel);
    fchnl=str2num(token);
    schnl=str2num(remain);
    
    
    channel=channel_array.get(i);
    % значение для начального канала для случая с 2-я каналами
    channel_=channel; 
    one_dot=dots_array.get(i);
    
    %one_dot
    
    one_dot600=one_dot+599;
    
    z_index=z_index+1;
    %eval(['dd' num2str(z_index) '=dat_(' one_dot ':' one_dot600 ',14);']);
    %eval(['dd' num2str(z_index) '=dat_(' one_dot ':' one_dot600 ',' channel ');']);
    x=one_dot : one_dot600;
   
    
    %sttttttr=strcat('dd',num2str(z_index),'=dat_(', num2str(one_dot), ':', num2str(one_dot600), ',', num2str(channel), ');');     big=strcat(big,sttttttr);     sttttttr=strcat('sig(', num2str(z_index), ',1:600)=rotatematrix(dd', num2str(z_index), ');')     big=strcat(big,sttttttr);

    eval(['dd' num2str(z_index) '=dat_(' num2str(one_dot) ':' num2str(one_dot600) ',' num2str(channel) ');']);
    eval(['sig(' num2str(z_index) ',1:600)=rotatematrix(dd' num2str(z_index) ');']);    
    channel=channel+1;    
    
    
    z_index=z_index+1;
    %sttttttr=strcat('dd',num2str(z_index),'=dat_(', num2str(one_dot), ':', num2str(one_dot600), ',', num2str(channel), ');');    big=strcat(big,sttttttr);    sttttttr=strcat('sig(', num2str(z_index), ',1:600)=rotatematrix(dd', num2str(z_index), ');');    big=strcat(big,sttttttr)

    eval(['dd' num2str(z_index) '=dat_(' num2str(one_dot) ':' num2str(one_dot600) ',' num2str(channel) ');']);
    eval(['sig(' num2str(z_index) ',1:600)=rotatematrix(dd' num2str(z_index) ');']);
    channel=channel+1;    
    
    z_index=z_index+1;    
    %sttttttr=strcat('dd',num2str(z_index),'=dat_(', num2str(one_dot), ':', num2str(one_dot600), ',', num2str(channel), ');');    big=strcat(big,sttttttr);        sttttttr=strcat('sig(', num2str(z_index), ',1:600)=rotatematrix(dd', num2str(z_index), ');');        big=strcat(big,sttttttr);

    eval(['dd' num2str(z_index) '=dat_(' num2str(one_dot) ':' num2str(one_dot600) ',' num2str(channel) ');']);
    eval(['sig(' num2str(z_index) ',1:600)=rotatematrix(dd' num2str(z_index) ');']);
    
    if((fchnl>0) & (schnl>0))       
        fchnl=channel_-1+fchnl
        schnl=channel_-1+schnl
        z_index=z_index-2;
        
        eval(['dd' num2str(z_index) '=dat_(' num2str(one_dot) ':' num2str(one_dot600) ',' num2str(fchnl) ');']);
        eval(['sig(' num2str(z_index) ',1:600)=rotatematrix(dd' num2str(z_index) ');']);
        
        z_index=z_index+1;        
        eval(['dd' num2str(z_index) '=dat_(' num2str(one_dot) ':' num2str(one_dot600) ',' num2str(fchnl) ');']);
        eval(['sig(' num2str(z_index) ',1:600)=rotatematrix(dd' num2str(z_index) ');']);
        
        z_index=z_index+1;        
        eval(['dd' num2str(z_index) '=dat_(' num2str(one_dot) ':' num2str(one_dot600) ',' num2str(schnl) ');']);
        eval(['sig(' num2str(z_index) ',1:600)=rotatematrix(dd' num2str(z_index) ');']);
    end
 



 end
%dd1=dat_(7653:8252,14);sig(1,1:600)=rotatematrix(dd1);dd2=dat_(7653:8252,15);sig(2,1:600)=rotatematrix(dd2);dd3=dat_(7653:8252,16);sig(3,1:600)=rotatematrix(dd3);dd4=dat_(12860:13459,14);sig(4,1:600)=rotatematrix(dd4);dd5=dat_(12860:13459,15);sig(5,1:600)=rotatematrix(dd5);dd6=dat_(12860:13459,16);sig(6,1:600)=rotatematrix(dd6);dd7=dat_(18856:19455,14);sig(7,1:600)=rotatematrix(dd7);dd8=dat_(18856:19455,15);sig(8,1:600)=rotatematrix(dd8);dd9=dat_(18856:19455,16);sig(9,1:600)=rotatematrix(dd9);dd10=dat_(28263:28862,14);sig(10,1:600)=rotatematrix(dd10);dd11=dat_(28263:28862,15);sig(11,1:600)=rotatematrix(dd11);dd12=dat_(28263:28862,16);sig(12,1:600)=rotatematrix(dd12);dd13=dat_(31650:32249,14);sig(13,1:600)=rotatematrix(dd13);dd14=dat_(31650:32249,15);sig(14,1:600)=rotatematrix(dd14);dd15=dat_(31650:32249,16);sig(15,1:600)=rotatematrix(dd15);dd16=dat_(36300:36899,14);sig(16,1:600)=rotatematrix(dd16);dd17=dat_(36300:36899,15);sig(17,1:600)=rotatematrix(dd17);dd18=dat_(36300:36899,16);sig(18,1:600)=rotatematrix(dd18);dd19=dat_(46100:46699,14);sig(19,1:600)=rotatematrix(dd19);dd20=dat_(46100:46699,15);sig(20,1:600)=rotatematrix(dd20);dd21=dat_(46100:46699,16);sig(21,1:600)=rotatematrix(dd21);dd22=dat_(56251:56850,14);sig(22,1:600)=rotatematrix(dd22);dd23=dat_(56251:56850,15);sig(23,1:600)=rotatematrix(dd23);dd24=dat_(56251:56850,16);sig(24,1:600)=rotatematrix(dd24);dd25=dat_(66300:66899,14);sig(25,1:600)=rotatematrix(dd25);dd26=dat_(66300:66899,15);sig(26,1:600)=rotatematrix(dd26);dd27=dat_(66300:66899,16);sig(27,1:600)=rotatematrix(dd27);dd28=dat_(75553:76152,14);sig(28,1:600)=rotatematrix(dd28);dd29=dat_(75553:76152,15);sig(29,1:600)=rotatematrix(dd29);dd30=dat_(75553:76152,16);sig(30,1:600)=rotatematrix(dd30);dd31=dat_(80100:80699,14);sig(31,1:600)=rotatematrix(dd31);dd32=dat_(80100:80699,15);sig(32,1:600)=rotatematrix(dd32);dd33=dat_(80100:80699,16);sig(33,1:600)=rotatematrix(dd33);dd34=dat_(84534:85133,14);sig(34,1:600)=rotatematrix(dd34);dd35=dat_(84534:85133,15);sig(35,1:600)=rotatematrix(dd35);dd36=dat_(84534:85133,16);sig(36,1:600)=rotatematrix(dd36);dd37=dat_(89522:90121,14);sig(37,1:600)=rotatematrix(dd37);dd38=dat_(89522:90121,15);sig(38,1:600)=rotatematrix(dd38);dd39=dat_(89522:90121,16);sig(39,1:600)=rotatematrix(dd39);dd40=dat_(94571:95170,14);sig(40,1:600)=rotatematrix(dd40);dd41=dat_(94571:95170,15);sig(41,1:600)=rotatematrix(dd41);dd42=dat_(94571:95170,16);sig(42,1:600)=rotatematrix(dd42);dd43=dat_(99764:100363,14);sig(43,1:600)=rotatematrix(dd43);dd44=dat_(99764:100363,15);sig(44,1:600)=rotatematrix(dd44);dd45=dat_(99764:100363,16);sig(45,1:600)=rotatematrix(dd45);dd46=dat_(104267:104866,14);sig(46,1:600)=rotatematrix(dd46);dd47=dat_(104267:104866,15);sig(47,1:600)=rotatematrix(dd47);dd48=dat_(104267:104866,16);sig(48,1:600)=rotatematrix(dd48);dd49=dat_(109700:110299,14);sig(49,1:600)=rotatematrix(dd49);dd50=dat_(109700:110299,15);sig(50,1:600)=rotatematrix(dd50);dd51=dat_(109700:110299,16);sig(51,1:600)=rotatematrix(dd51);dd52=dat_(113679:114278,14);sig(52,1:600)=rotatematrix(dd52);dd53=dat_(113679:114278,15);sig(53,1:600)=rotatematrix(dd53);dd54=dat_(113679:114278,16);sig(54,1:600)=rotatematrix(dd54);dd55=dat_(118686:119285,14);sig(55,1:600)=rotatematrix(dd55);dd56=dat_(118686:119285,15);sig(56,1:600)=rotatematrix(dd56);dd57=dat_(118686:119285,16);sig(57,1:600)=rotatematrix(dd57);dd58=dat_(128047:128646,14);sig(58,1:600)=rotatematrix(dd58);dd59=dat_(128047:128646,15);sig(59,1:600)=rotatematrix(dd59);dd60=dat_(128047:128646,16);sig(60,1:600)=rotatematrix(dd60);dd61=dat_(133175:133774,14);sig(61,1:600)=rotatematrix(dd61);dd62=dat_(133175:133774,15);sig(62,1:600)=rotatematrix(dd62);dd63=dat_(133175:133774,16);sig(63,1:600)=rotatematrix(dd63);dd64=dat_(137902:138501,14);sig(64,1:600)=rotatematrix(dd64);dd65=dat_(137902:138501,15);sig(65,1:600)=rotatematrix(dd65);dd66=dat_(137902:138501,16);sig(66,1:600)=rotatematrix(dd66);


 
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
 intensity(i)=(ps2(i)+ps2(i+n_realization)+ps2(i+2*n_realization))/3;
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
 %intensity(i)=ps(i);
 %scint_index(i)=sqrt((disp_signal_noise(i)-disp_noise(i))/(intensity(i)*intensity(i)));
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
 
 % figure(1)
 % loglog(fr(1:0.5*np),spectr_p(1,1:0.5*np),'-b')
 % title('Power spectrum of scintillations (resolution - all time realisation divided on 1 part + 1 part obtained by 50% shifting)','FontSize',8)
 % figure(2)
 % loglog(fr(1:0.5*np),spectr_p(2,1:0.5*np),'ob'),grid
 % title('Power spectrum of scintillations (resolution - all time realisation divided on 3 parts + 2 parts obtained by 50% shifting)','FontSize',8)
 % figure(3)
 % loglog(fr(1:0.5*np),spectr_p(3,1:0.5*np),'ob',fr(1:0.5*np),func_noise_mean(1,1:0.5*np),'or'),grid
 % title('Power spectrum of scintillations (resolution - all time realisation divided on 5 parts + 4 parts obtained by 50% shifting)','FontSize',8)
 % figure(4)
 % loglog(fr(1:0.5*np),spectr_p_norm(1,1:0.5*np)/spectr_p_norm(1,2),'-b','LineWidth',2),grid
 % axis([0.01 5 0.0001 10])
 % title('3C144 00.00 01.30  01.12.2005  e=+165.3  ks=0.7 m=0.19 N=3','FontSize',10)
 % figure(5)
 
 for i=1:n_realization
 if i==3
 % loglog(fr(1:0.5*np),spectr_p_i3(1,1:0.5*np)/(disp_signal(1)*spectr_p_i3(1,1)),'-b',fr(1:0.5*np),spectr_p_i3(2,1:0.5*np)/(disp_signal(2)*spectr_p_i3(2,2)),'-r',fr(1:0.5*np),spectr_p_i3(3,1:0.5*np)/(disp_signal(3)*spectr_p_i3(3,2)),'-g'),grid
 % %loglog(fr(1:0.5*np),spectr_p_i3(1,1:0.5*np)/(disp_signal(1)*spectr_p_i3(1,1)),'-b',fr(1:0.5*np),spectr_p_i3(2,1:0.5*np)/(disp_signal(2)*spectr_p_i3(2,1)),'-r',fr(1:0.5*np),spectr_p_i3(3,1:0.5*np)/(disp_signal(3)*spectr_p_i3(3,1)),'-g',fr(1:0.5*np),spectr_p_i3(4,1:0.5*np)/(disp_signal(4)*spectr_p_i3(4,1)),'-k',fr(1:0.5*np),spectr_p_i3(5,1:0.5*np)/(disp_signal(5)*spectr_p_i3(5,1)),'ob',fr(1:0.5*np),spectr_p_i3(6,1:0.5*np)/(disp_signal(6)*spectr_p_i3(6,1)),'or',fr(1:0.5*np),spectr_p_i3(7,1:0.5*np)/(disp_signal(7)*spectr_p_i3(7,1)),'og',fr(1:0.5*np),spectr_p_i3(8,1:0.5*np)/(disp_signal(8)*spectr_p_i3(8,1)),'ok',fr(1:0.5*np),spectr_p_i3(9,1:0.5*np)/(disp_signal(9)*spectr_p_i3(9,1)),'.b',fr(1:0.5*np),spectr_p_i3(10,1:0.5*np)/(disp_signal(10)*spectr_p_i3(10,1)),'.r'),grid
 end;
 % %axis([0.01 5 0.0001 10])
 end;
 % figure(6)
 % semilogx(fr(1:25),pogresh_p(1:25),'-b'),grid
 % title('Confidence limits','FontSize',8)
 % figure(7)
 % loglog(fr(1:np),func_signal_noise(1,1:np),'-b',fr(1:np),func_signal_noise(2,1:np),'-b',fr(1:np),func_signal_noise(3,1:np),'-b')
 %%%%  VISUALISATION BLOCK%                   
 
 %%%%% MAKING RECORD BLOCK
 for i=1:n_realization
 sdk_kor_res1(i,1:np)=sdk_kor(1,i,1:np);
 end;
 z=[fr(1:0.5*np);spectr_p_norm(1,1:0.5*np);pogresh_p(1,1:0.5*np);sdk_kor_res1(1,1:0.5*np);sdk_kor_res1(2,1:0.5*np);sdk_kor_res1(3,1:0.5*np)];
 %z=[fr(1:0.5*np);spectr_p_norm(1,1:0.5*np);pogresh_p(1,1:0.5*np);sdk_kor_res1(1,1:0.5*np);sdk_kor_res1(2,1:0.5*np);sdk_kor_res1(3,1:0.5*np);sdk_kor_res1(4,1:0.5*np);sdk_kor_res1(5,1:0.5*np);sdk_kor_res1(6,1:0.5*np);sdk_kor_res1(7,1:0.5*np);sdk_kor_res1(8,1:0.5*np);sdk_kor_res1(9,1:0.5*np);sdk_kor_res1(10,1:0.5*np);sdk_kor_res1(11,1:0.5*np);sdk_kor_res1(12,1:0.5*np);sdk_kor_res1(13,1:0.5*np);sdk_kor_res1(14,1:0.5*np);sdk_kor_res1(15,1:0.5*np);sdk_kor_res1(16,1:0.5*np);sdk_kor_res1(17,1:0.5*np);sdk_kor_res1(18,1:0.5*np);sdk_kor_res1(19,1:0.5*np);sdk_kor_res1(20,1:0.5*np)];
 %%%%%%
 %fid=fopen('dat_141107.yyy_ind22.yyy','w');
 %%%%%
 
 % %del3%mkdir('..\datafile2');
 FilePath=strcat(path,'\','datafile\',FileName);
 dirp=strcat(path,'\','datafile\');
 tf = isdir(dirp);
 if(tf==0)        mkdir(dirp);    end
 FilePath2Remove=strcat(path,'\','datafile\',FileRegexprName);
 
 delete(FilePath2Remove);
 
 %del3%delete('..\datafile2\dat_141107_3C144_ind*.yyy');
 
 %del3%fid=fopen('..\datafile2\dat_141107_3C144_ind16_0507.yyy','w');
 %del3%fprintf(fid,'%18.8f%18.8f%18.8f%18.8f%18.8f%18.8f\r',z);
 %del3%fclose(fid);
 
 
 
 %FilePath
 fid=fopen(FilePath,'w');
 fprintf(fid,'%18.8f%18.8f%18.8f%18.8f%18.8f%18.8f\r',z);
 fclose(fid);
 
 
 FilePath=strcat(path,FileName);
 if exist(FilePath, 'file')
     
     delete(FilePath);
 end
 
 fid=fopen(FilePath,'w');
 fprintf(fid,'%18.8f%18.8f%18.8f%18.8f%18.8f%18.8f\r',z);
 fclose(fid);
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 %                   MAKING RECORD BLOCK
 %from time
 for i=1:n_realization
 scint_index(i)=sqrt(cov(signal(i,1:np)))/intensity(i);
 end;
 
 %I
 FilePath=strcat(path,FileName,'scint_index.txt');
 fid=fopen(FilePath,'w+');
   
   
 scint_index_mean=mean(scint_index);
 
 scint_index_max=max(scint_index);
 scint_index_min=min(scint_index);
 mean_plus_this=scint_index_max-scint_index_mean;
 mean_minus_this=scint_index_mean-scint_index_min;
 %I
   fprintf(fid,'%01.4f|%01.4f|%01.4f|',scint_index_mean,mean_minus_this,mean_plus_this);
 %from time
     out_scint_index_mean=scint_index_mean;
     out_mean_minus_this=mean_minus_this;
     out_mean_plus_this=mean_plus_this;
 %from time
  
 %from spectra
 for i=1:n_realization
 scint_index(i)=sqrt((disp_signal_noise(i)-disp_noise(i))/(intensity(i)*intensity(i)));
 end;
 scint_index_mean=mean(scint_index);
 scint_index_max=max(scint_index);
 scint_index_min=min(scint_index);
 mean_plus_this=scint_index_max-scint_index_mean;
 mean_minus_this=scint_index_mean-scint_index_min;
 
 %from spectra
 fprintf(fid,'%01.4f|%01.4f|%01.4f',scint_index_mean,mean_minus_this,mean_plus_this);
%scint_index_mean,mean_minus_this,mean_plus_this
%from spectra
     out_scint_index_mean2=scint_index_mean;
     out_mean_minus_this2=mean_minus_this;
     out_mean_plus_this2=mean_plus_this;
 %from spectra
 fclose(fid);
 
 %SQLite block
 % создаём таблицу
 mksqlite(dbid,['CREATE TABLE IF NOT EXISTS ''' ScintTableName '''  ( id INTEGER PRIMARY KEY , filename NOT NULL UNIQUE ON CONFLICT REPLACE , m_t_05all REAL , m_t_0507 REAL , m_t_07all REAL , m_minus_t_05all REAL , m_plus_t_05all REAL , m_minus_t_0507 REAL , m_plus_t_0507 REAL , m_minus_t_07all REAL , m_plus_t_07all REAL , m_s_05all REAL , m_s_0507 REAL , m_s_07all REAL , m_minus_sp_05all REAL , m_plus_sp_05all REAL , m_minus_sp_0507 REAL , m_plus_sp_0507 REAL , m_minus_sp_07all REAL , m_plus_sp_07all REAL )']);
 
 
 % заполняем таблицу, если пусто
  res = mksqlite(dbid,['select count(*) as num from ''' ScintTableName ''' WHERE [filename]= ''' TableName  ''' ']);
% fprintf ('select count(*) liefert als Ergebnis %d\n', res.anzahl);
 if(res.num==0)
    mksqlite(dbid,['INSERT INTO [' ScintTableName '] ( [filename] ) VALUES  ( ''' TableName  ''' ) ']);
 end   
 switch ScintPrefix
    case '05all' 
        mksqlite(dbid,['UPDATE ''' ScintTableName ''' SET [m_t_05all]= ''' num2str(out_scint_index_mean2) ''' , [m_minus_t_05all]= ''' num2str(out_mean_minus_this) ''' , [m_plus_t_05all]= ''' num2str(out_mean_plus_this) ''' , [m_s_05all]= ''' num2str(out_scint_index_mean2) ''' , [m_minus_sp_05all]= ''' num2str(out_mean_minus_this2) ''' , [m_plus_sp_05all]= ''' num2str(out_mean_plus_this2) '''    WHERE [filename]= ''' TableName  ''' ']);
    case '0507' 
        mksqlite(dbid,['UPDATE ''' ScintTableName ''' SET [m_t_0507]= ''' num2str(out_scint_index_mean2) ''' , [m_minus_t_0507]= ''' num2str(out_mean_minus_this) ''' , [m_plus_t_0507]= ''' num2str(out_mean_plus_this) ''' , [m_s_0507]= ''' num2str(out_scint_index_mean2) ''' , [m_minus_sp_0507]= ''' num2str(out_mean_minus_this2) ''' , [m_plus_sp_0507]= ''' num2str(out_mean_plus_this2) '''    WHERE [filename]= ''' TableName  ''' ']);
    case '07all' 
        mksqlite(dbid,['UPDATE ''' ScintTableName ''' SET [m_t_07all]= ''' num2str(out_scint_index_mean2) ''' , [m_minus_t_07all]= ''' num2str(out_mean_minus_this) ''' , [m_plus_t_07all]= ''' num2str(out_mean_plus_this) ''' , [m_s_07all]= ''' num2str(out_scint_index_mean2) ''' , [m_minus_sp_07all]= ''' num2str(out_mean_minus_this2) ''' , [m_plus_sp_07all]= ''' num2str(out_mean_plus_this2) '''    WHERE [filename]= ''' TableName  ''' ']);        
 end
end