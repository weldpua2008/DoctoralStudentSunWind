% здесь Мы расчитываем для всех точек одного дня значения:
    %kt20_25
    %kt20_30
    %kt25_30
    %ks20_25
    %ks20_30
    %ks25_30
    %scint_index_20
    %scint_index_23
    %scint_index_25
%и записываем в базу SQLite    

% dots_array -массив точек
% only_2channel_array - массив (назначаем отдельным точкам только два
% канала) only_2channel_array.put(2,'14 15');
% channel_array -  массив содержащий начальный канал для той же программы
% different_channel_array - назначаем отдельным точкам другое значение для начального канала
% different_channel_array.put(2,10);
% start_channel - начальный канал для всех
% n_realization
% dat_ - загруженнный файл
% TableName - таблица для SQLite куда будет происходить запись
% dbid - ресурс SQLite куда будет происходить запись
% ReletivePath путь к папке где происходит текущая работа %Например: 'D:\Work\aspirantura_process\processing\data_20071112_20071122\3C144\14-11-07\'



function [dots_05all_array,dots_0507_array,dots_07all_array]=calc_4one_day_dots(dots_array,only_2channel_array,channel_array,different_channel_array,start_channel,n_realization,dat_,TableName,dbid,ReletivePath)
% точки, которые отвечают 0.5-all
dots_05all_array=java.util.Hashtable;
% точки, которые отвечают 0.5-0.7
dots_0507_array=java.util.Hashtable;
% точки, которые отвечают 0.7-all
dots_07all_array=java.util.Hashtable;


% создаём таблицу
mksqlite(dbid,['CREATE TABLE IF NOT EXISTS ''' TableName ''' (id INTEGER      PRIMARY KEY ASC ON CONFLICT FAIL AUTOINCREMENT NOT NULL, dot      TEXT( 128 )  UNIQUE ON CONFLICT REPLACE, [05all]        INTEGER      NOT NULL   DEFAULT ( 0 ), [0507]         INTEGER      NOT NULL  DEFAULT ( 0 ),    [07all]        INTEGER      NOT NULL DEFAULT ( 0 ), scint_spectr   REAL         NOT NULL DEFAULT ( 0 ), scint_time     REAL         NOT NULL                                DEFAULT ( 0 ),    kt20_25 REAL NOT NULL DEFAULT ( 0 ),    kt20_30        REAL         NOT NULL                                DEFAULT ( 0 ),    kt25_30        REAL         NOT NULL DEFAULT ( 0 ),    ks20_25        REAL         NOT NULL DEFAULT ( 0 ),    ks20_30        REAL         NOT NULL DEFAULT ( 0 ),    ks25_30        REAL         NOT NULL DEFAULT ( 0 ),    scint_index_20 REAL         NOT NULL DEFAULT ( 0 ),    scint_index_23 REAL         NOT NULL DEFAULT ( 0 ),    scint_index_25 REAL         NOT NULL DEFAULT ( 0 ), only_2_channel BOOLEAN      NOT NULL DEFAULT ( 0 ),[2channels]    TEXT  )']);
%mksqlite(dbid,'begin');%mksqlite(dbid,'commit');


n=size(dots_array); 
ind05all=0;
ind0507=0;
ind07all=0;


    for i =1:n  
        channel_array.put(i,start_channel);        
        value=different_channel_array.get(i);
        if(value>0)
            channel_array.put(i,value);
        end   
        one_dot=dots_array.get(i);  
        [kt20_25,kt20_30,kt25_30,ks20_25,ks20_30,ks25_30,scint_index_20,scint_index_23,scint_index_25]=fq_(dat_,one_dot, channel_array.get(i),n_realization, only_2channel_array.get(i),ReletivePath); 
        % если у нас два канала вместо трёх
        only_2_channel_bool=0; if(length(num2str(only_2channel_array.get(i)))>0) only_2_channel_bool=1;     end

        %удаляем записи для точек, так как могли произойти изменения
        mksqlite(dbid,['DELETE FROM  ''' TableName ''' WHERE [dot]= ''' num2str(one_dot) ''' ']);
        % заполнение таблицы
        mksqlite(dbid,['INSERT INTO ''' TableName ''' ([dot],[kt20_25], [kt20_30], [kt25_30], [ks20_25], [ks20_30], [ks25_30], [scint_index_20], [scint_index_23], [scint_index_25], [only_2_channel],[2channels])   values ( ''' num2str(one_dot)  ''' , ''' num2str(kt20_25)  ''' , ''' num2str(kt20_30)  ''', ''' num2str(kt25_30)  ''', ''' num2str(ks20_25)  ''', ''' num2str(ks20_30)  ''', ''' num2str(ks25_30)  ''' , ''' num2str(scint_index_20)  ''', ''' num2str(scint_index_23)  ''', ''' num2str(scint_index_25)  ''' ,  ''' num2str(only_2_channel_bool) ''' , '''  num2str(only_2channel_array.get(i))  ''' )   ']);
        
        if( (kt20_25 >0.49)&(kt20_30>0.49)&(kt25_30>0.49))                        
                    % заполнение таблицы
                    mksqlite(dbid,['UPDATE  ''' TableName ''' SET [05all]=1 WHERE [dot]= ''' num2str(one_dot) ''' ']);            
                    ind05all=ind05all+1;
                    % заполнение масива точек для реализации 0.5-все
                    dots_05all_array.put(ind05all,one_dot);           
        end    
        if( (kt20_25 >=0.496)&(kt20_30>=0.496)&(kt25_30>=0.496)& (kt20_25 <0.8)&(kt20_30<0.8)&(kt25_30<0.8))
                    % заполнение таблицы
                    mksqlite(dbid,['UPDATE  ''' TableName ''' SET [0507]=1 WHERE [dot]= ''' num2str(one_dot) ''' ']);
                    ind0507=ind0507+1;
                    % заполнение масива точек для реализации 0.5-0.7
                    dots_0507_array.put(ind0507,one_dot);
        elseif( (ks20_25 >=0.689)&(ks20_30>=0.689)&(ks25_30>=0.689)& (ks20_25 <=1.31)&(ks20_30<=1.31)&(ks25_30<=1.31))
                    % заполнение таблицы
                    mksqlite(dbid,['UPDATE  ''' TableName ''' SET [0507]=1 WHERE [dot]= ''' num2str(one_dot) ''' ']);            
                    ind0507=ind0507+1;                
                    % заполнение масива точек для реализации 0.5-0.7 
                    dots_0507_array.put(ind0507,one_dot);                       
        end        
        if( (ks20_25 >=0.689)&(ks20_30>=0.689)&(ks25_30>=0.689)& (ks20_25 <=1.31)&(ks20_30<=1.31)&(ks25_30<=1.31))
                    % заполнение таблицы            
                    mksqlite(dbid,['UPDATE  ''' TableName ''' SET [07all]=1 WHERE [dot]= ''' num2str(one_dot) ''' ']);                
                    ind07all=ind07all+1;            
                    % заполнение масива точек для реализации 0.7-все
                    dots_07all_array.put(ind07all,one_dot);            
        elseif( (kt20_25 >=0.65)&(kt20_30>=0.65)&(kt25_30>=0.65))
                    %заполнение таблицы
                    mksqlite(dbid,['UPDATE  ''' TableName ''' SET [07all]=1 WHERE [dot]= ''' num2str(one_dot) ''' ']);    
                    ind07all=ind07all+1;
                    % заполнение масива точек для реализации 0.7-все
                    dots_07all_array.put(ind07all,one_dot);
        end 
        
        
        % очистка массива
        dots_array.remove(i);
        channel_array.remove(i);
        only_2channel_array.remove(i);
        different_channel_array.remove(i);
        
    end
    
    %количество реализаций
    %ind05all
    %ind0507
    %ind07all

end