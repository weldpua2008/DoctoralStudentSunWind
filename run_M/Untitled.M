script
dots_array = java.util.Hashtable;
filename='dat_141107.yyy';
%ReletivePath путь где происходит текущая работа
ReletivePath='D:\Work\aspirantura_process\processing\data_20071112_20071122\3C144\14-11-07\';
filename=strcat(ReletivePath,filename);


 STRING = 'ab_c d e fgh';
      DELIMITERS = ' ';
      [SPLIT,NUMPIECES] = EXPLODE(STRING,DELIMITERS)

%dat_ = load(filename);

dots_array.put(1,7653);
dots_array.put(2,12860);
dots_array.put(3,18856);

n=size(dots_array);
% dd1=dat_(7653:8252,14)
%dd2=dat_(7653:8252,15)


%dd3=dat_(7653:8252,16)







start=14;
for i=1:3
%eval(['dd' num2str(i) '=dat_(' a ': ' b ',' num2str(start) ');']);
%eval(['sig(' num2str(i) ',1:600)=dd' num2str(i) ''');']);
%eval(['sig(' num2str(i) ',1:600)=dd1'' ;']);
z=i;
%eval(['dd=dd' num2str(z) ';']);

%eval(['d=rotatematrix(dd' num2str(z) ');']);

%eval(['sig(' num2str(z) ',1:600)=rotatematrix(dd' num2str(z) ');']);        
start=start+1;
end


%dd3
%sig
%[keys,sections,subsections] = inifile('D:\Work\aspirantura_process\_ini\all.ini','readall')


%readKeys = {'main',    'ini_files',    'parse_ini_or_dat'};
%[keys,sections,subsections] = inifile('D:\Work\aspirantura_process\_ini\all.ini','read',readKeys)

%ml_GetPrivateProfileString('ini_files','', 'D:\Work\aspirantura_process\_ini\all.ini')