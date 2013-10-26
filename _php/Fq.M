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



%%%%%%%% Example %%%%%%%%%%%%%%%%%%%%
% databasedir D:\Work\aspirantura_process\sqlite\data_20071112_20071122\
% databasefile D:\Work\aspirantura_process\sqlite\data_20071112_20071122\3C144.sqlite
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% create path for SQLite file
databasedir=strcat(WPath,SqlitePrefix,DirName);
databasefile=strcat(databasedir,Source,'.sqlite')

% create dir for SQLite
tf = isdir(databasedir);    if(tf==0)         mkdir(databasedir);     end

% удаление из имени файла "-" и ".", что бы так "141107DAT" именовать таблицу Sqlite
TableName=regexprep(DatFile, '\.', '');
TableName=regexprep(TableName,'-', '' );
    

dbid = mksqlite(0, 'open', databasefile) 

mksqlite(dbid,'begin');
mksqlite(dbid,['CREATE TABLE IF NOT EXISTS ''' TableName ''' (id INTEGER      PRIMARY KEY ASC ON CONFLICT FAIL AUTOINCREMENT NOT NULL, dot      TEXT( 128 )  UNIQUE ON CONFLICT REPLACE, [05all]        INTEGER      NOT NULL   DEFAULT ( 0 ), [0507]         INTEGER      NOT NULL  DEFAULT ( 0 ),    [07all]        INTEGER      NOT NULL DEFAULT ( 0 ), scint_spectr   REAL         NOT NULL DEFAULT ( 0 ), scint_time     REAL         NOT NULL                                DEFAULT ( 0 ),    kt20_25 REAL NOT NULL DEFAULT ( 0 ),    kt20_30        REAL         NOT NULL                                DEFAULT ( 0 ),    kt25_30        REAL         NOT NULL DEFAULT ( 0 ),    ks20_25        REAL         NOT NULL DEFAULT ( 0 ),    ks20_30        REAL         NOT NULL DEFAULT ( 0 ),    ks25_30        REAL         NOT NULL DEFAULT ( 0 ),    scint_index_20 REAL         NOT NULL DEFAULT ( 0 ),    scint_index_23 REAL         NOT NULL DEFAULT ( 0 ),    scint_index_25 REAL         NOT NULL DEFAULT ( 0 ), only_2_channel BOOLEAN      NOT NULL DEFAULT ( 0 ),[2channels]    TEXT  )']);
mksqlite(dbid,'commit');

NumOfSamples=10;
try
    for idx=1:NumOfSamples
        %mksqlite(dbid,['insert into  table  (Eintrag, GrosserFloat, VieleZeichen) values (''' sprintf('Eintrag_%d', idx) ''', ' num2str(idx) ', ''' VieleZeichen ''')']);
        
        %INSERT INTO [141107DAT] ([id], [dot], [05all], [0507], [07all], [scint_spectr], [scint_time], [kt20_25], [kt20_30], [kt25_30], [ks20_25], [ks20_30], [ks25_30], [scint_index_20], [scint_index_23], [scint_index_25], [only_2_channel]) VALUES (2, 1, 0, 0, 0, '0.0', '0.0', '0.0', '0.0', '0.0', '0.0', '0.0', '0.0', '0.0', '0.0', '0.0', 0);
        
    end
catch
end


tables = mksqlite(dbid,['SELECT * FROM ''' TableName '''  ']);
       for idx1=1:length(tables)
           % tables(idx1).baz
        end
%res = mksqlite(dbid,['select count(*) as anzahl from  ''' TableName ''' ']);
%fprintf ('select count(*) liefert als Ergebnis %d\n', res.anzahl);



% массив точек для расчёта в  PROGRAM FOR OBTAINING COEFFICIENT CORRELATIONS OF SCINTILLATIONS ON THREE FREQUENCIES
% BY THREE METHODS.
dots_array = java.util.Hashtable;

% массив содержащий начальный канал для той же программы
channel_array=java.util.Hashtable;
% массив для точек, где другой начальный канал
different_channel_array=java.util.Hashtable;

% если у нас только 2-а канала из 3-х
only_2channel_array=java.util.Hashtable;

%%%%%%%%%%%%%%% Тут вносятся изменения
% change
filename='dat_141107.yyy';
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

%  назначаем отдельным точкам только два канала
%only_2channel_array.put(2,'14 15');

% назначаем отдельным точкам другое значение для начального канала
% different_channel_array.put(2,10);

%определяем начальный канал для всех
start_channel=14;
n_realization=3;

%%%%% работа
dat_ = load(filename);
dat_2=dat_;
n=size(dots_array); 



for i =1:n  
    channel_array.put(i,start_channel);        
    value=different_channel_array.get(i);
    if(value>0)
        channel_array.put(i,value);
    end   
    one_dot=dots_array.get(i);
    %dat_=dat_2;
    [kt20_25,kt20_30,kt25_30,ks20_25,ks20_30,ks25_30,scint_index_20,scint_index_23,scint_index_25]=fq_(dat_,one_dot, channel_array.get(i),n_realization, only_2channel_array.get(i));
    %mksqlite(dbid,['INSERT INTO ''' TableName ''' ([dot],[kt20_25], [kt20_30], [kt25_30], [ks20_25], [ks20_30], [ks25_30], [scint_index_20], [scint_index_23], [scint_index_25], [only_2_channel])   values ( ''' one_dot ''',''' kt20_25 ''', ''' kt20_30 ''', ''' kt25_30 ''', ''' ks20_25 ''', ''' ks20_30 ''', ''' ks25_30 ''', ''' scint_index_20 ''', ''' scint_index_23 ''', ''' scint_index_25 ''', ''' only_2channel_array.get(i) ''' )   ']);
    only_2_channel_bool=0;
    if(length(num2str(only_2channel_array.get(i)))>0)
            only_2_channel_bool=1;
    end
    mksqlite(dbid,['INSERT INTO ''' TableName ''' ([dot],[kt20_25], [kt20_30], [kt25_30], [ks20_25], [ks20_30], [ks25_30], [scint_index_20], [scint_index_23], [scint_index_25], [only_2_channel],[2channels])   values ( ''' num2str(one_dot)  ''' , ''' num2str(kt20_25)  ''' , ''' num2str(kt20_30)  ''', ''' num2str(kt25_30)  ''', ''' num2str(ks20_25)  ''', ''' num2str(ks20_30)  ''', ''' num2str(ks25_30)  ''' , ''' num2str(scint_index_20)  ''', ''' num2str(scint_index_23)  ''', ''' num2str(scint_index_25)  ''' ,  ''' num2str(only_2_channel_bool) ''' , '''  num2str(only_2channel_array.get(i))  ''' )   ']);
    %one_dot=num2str(one_dot)
    %kt20_25
    %kt20_30
    %kt25_30
    %ks20_25
    %ks20_30
    %ks25_30
    %scint_index_20
    %scint_index_23
    %scint_index_25
  %  channel_array.get(i)
end


% закрываем соеденение с SQLite
mksqlite(dbid, 'close') 