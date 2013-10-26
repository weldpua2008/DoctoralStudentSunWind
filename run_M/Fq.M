clear all
script

% sqlite support for MatLab by http://mksqlite.berlios.de/mksqlite_eng.html
% путь к библиотеке
addpath D:\Work\aspirantura_process\mksqlite-1.11 -end


WPath='D:\Work\aspirantura_process';
SqlitePrefix='\sqlite';
DirName='\data_20071112_20071122';
Source='\3C144';
DatFile='14-11-07.DAT';

% определяем таблицу для содержания 
% индексов мерцания наших файлов по дням
ScintTableName='scint'; 


%%%%%%%% Example %%%%%%%%%%%%%%%%%%%%
% databasedir D:\Work\aspirantura_process\sqlite\data_20071112_20071122\
% databasefile D:\Work\aspirantura_process\sqlite\data_20071112_20071122\3C144.sqlite
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create path for SQLite file
databasedir=strcat(WPath,SqlitePrefix,DirName);
databasefile=strcat(databasedir,Source,'.sqlite');

% create dir for SQLite
tf = isdir(databasedir);    if(tf==0)         mkdir(databasedir);     end




% массив точек для расчёта в  PROGRAM FOR OBTAINING COEFFICIENT CORRELATIONS OF SCINTILLATIONS ON THREE FREQUENCIES
% BY THREE METHODS.
dots_array = java.util.Hashtable;
% массив содержащий начальный канал для той же программы
channel_array=java.util.Hashtable;
% массив для точек, где другой начальный канал
different_channel_array=java.util.Hashtable;
% если у нас только 2-а канала из 3-х
only_2channel_array=java.util.Hashtable;

% точки, которые отвечают 0.5-all
dots_05all_array=java.util.Hashtable;
% точки, которые отвечают 0.5-0.7
dots_0507_array=java.util.Hashtable;
% точки, которые отвечают 0.7-all
dots_07all_array=java.util.Hashtable;
%%%%%%%%%%%%%%% Тут вносятся изменения
% change
filename='dat_141107.yyy';
%ReletivePath путь где происходит текущая работа
ReletivePath='D:\Work\aspirantura_process\processing\data_20071112_20071122\3C144\14-11-07\';
filename=strcat(ReletivePath,filename);

dots_array.put(1,7653);
dots_array.put(2,12860);
dots_array.put(3,18856);
dots_array.put(4,28263);
dots_array.put(5,31650);
dots_array.put(6,36300);
dots_array.put(7,46100);
dots_array.put(8,56251);
dots_array.put(9,61464);
dots_array.put(10,66300);
dots_array.put(11,75553);
dots_array.put(12,80100);
dots_array.put(13,84534);
dots_array.put(14,89522);
dots_array.put(15,94571);
dots_array.put(16,99764);
dots_array.put(17,104267);
dots_array.put(18,109700);
dots_array.put(19,113679);
dots_array.put(20,118686);
dots_array.put(21,123922);
dots_array.put(22,128047);
dots_array.put(23,133175);
dots_array.put(24,137902);






only_2channel_arraySp=only_2channel_array;
channel_arraySp=channel_array;

%  назначаем отдельным точкам только два канала
%only_2channel_array.put(2,'14 15');

% назначаем отдельным точкам другое значение для начального канала
% different_channel_array.put(2,10);

%определяем начальный канал для всех
start_channel=14;
n_realization=3;

% удаление из имени файла "-" и ".", что бы именовать таблицу Sqlite так: "141107DAT" 
TableName=regexprep(DatFile, '\.', ''); TableName=regexprep(TableName,'-', '' );
    
% открытие соеденения с Базой данных
dbid = mksqlite(0, 'open', databasefile);

%%%%% работа
dat_ = load(filename);

[dots_05all_array,dots_0507_array,dots_07all_array]=calc_4one_day_dots(dots_array,only_2channel_array,channel_array,different_channel_array,start_channel,n_realization,dat_,TableName,dbid,ReletivePath);

n_real_05all=size(dots_05all_array);
n_real_0507=size(dots_0507_array);
n_real_07all=size(dots_07all_array);


%данные для Sp_by_per_us_in_time_20100119()
dots_arraySp=dots_05all_array;
% ScintPrefix= [05all 0507 07all]
ScintPrefix='05all';
FileRegexprName=regexprep('dat_141107_3C144_ind/ScintPrefix/*.yyy','/ScintPrefix/',ScintPrefix);
FileName=regexprep('dat_141107_3C144_ind/n_real//ScintPrefix/_.yyy','/ScintPrefix/',ScintPrefix);
FileName=regexprep(FileName,'/n_real/',num2str(size(dots_arraySp)));



% 05 - all
if(n_real_05all>2)
    [m_from_time_05all,m_from_time_minus_05all,m_from_time_plus_5all,m_from_spectra_05all,m_from_spectra_minus_05all,m_from_spectra_plus_5all]=Sp_by_per_us_in_time_20100119(dots_arraySp,only_2channel_arraySp,channel_arraySp,start_channel,different_channel_array,dat_,TableName,ScintTableName,dbid,ReletivePath,FileName,FileRegexprName,ScintPrefix);
end

%данные для Sp_by_per_us_in_time_20100119()
dots_arraySp=dots_0507_array;
% ScintPrefix= [05all 0507 07all]
ScintPrefix='0507';
FileRegexprName=regexprep('dat_141107_3C144_ind/ScintPrefix/*.yyy','/ScintPrefix/',ScintPrefix);
FileName=regexprep('dat_141107_3C144_ind/n_real//ScintPrefix/_.yyy','/ScintPrefix/',ScintPrefix);
FileName=regexprep(FileName,'/n_real/',num2str(size(dots_arraySp)));


% 05 - 07
if(n_real_0507>2)
    [m_from_time_0507,m_from_time_minus_0507,m_from_time_plus_5all,m_from_spectra_0507,m_from_spectra_minus_0507,m_from_spectra_plus_5all]=Sp_by_per_us_in_time_20100119(dots_arraySp,only_2channel_arraySp,channel_arraySp,start_channel,different_channel_array,dat_,TableName,ScintTableName,dbid,ReletivePath,FileName,FileRegexprName,ScintPrefix);
end
%данные для Sp_by_per_us_in_time_20100119()
dots_arraySp=dots_07all_array;
% ScintPrefix= [05all 0507 07all]
ScintPrefix='07all';
FileRegexprName=regexprep('dat_141107_3C144_ind/ScintPrefix/*.yyy','/ScintPrefix/',ScintPrefix);
FileName=regexprep('dat_141107_3C144_ind/n_real//ScintPrefix/_.yyy','/ScintPrefix/',ScintPrefix);
FileName=regexprep(FileName,'/n_real/',num2str(size(dots_arraySp)));


% 07 - all
if(n_real_07all>2)
    [m_from_time_07all,m_from_time_minus_07all,m_from_time_plus_5all,m_from_spectra_07all,m_from_spectra_minus_07all,m_from_spectra_plus_5all]=Sp_by_per_us_in_time_20100119(dots_arraySp,only_2channel_arraySp,channel_arraySp,start_channel,different_channel_array,dat_,TableName,ScintTableName,dbid,ReletivePath,FileName,FileRegexprName,ScintPrefix);
end
% закрываем соеденение с SQLite
mksqlite(dbid, 'close') 

%проверка на удаление переменных
% n=size(dots_array) for i =1:n           dots_array.get(i) end