clear all
script

% sqlite support for MatLab by http://mksqlite.berlios.de/mksqlite_eng.html
% путь к библиотеке

addpath D:\Work\aspirantura_process\mksqlite-1.11 -end

% рабочая директория
WPath='D:\Work\aspirantura_process';
SqlitePrefix='\sqlite';
database_config_file=strcat(WPath,SqlitePrefix,'\config','\config.sqlite');


dbid_config = mksqlite(1, 'open', database_config_file);

result_config = mksqlite(dbid_config,['SELECT * FROM [config] ']);
n_config=size(result_config);  

%%%%%%%%%%% использовать arrayfun, что бы вычислять правильный ключ, так как нету foreach
% z = arrayfun(@(a)foreach_my_array(a.id), result_config);

id = arrayfun(@(a)a.id, result_config);
n_id=size(id,1);
for i_id=1:n_id
  temp=id(i_id);
  
  ini_file=result_config(temp).ini_file;
  sqlite_file=result_config(temp).sqlite_file;
  raw_data_dir=result_config(temp).raw_data_dir;
  dir_process=result_config(temp).dir_process;
  dir_name_sqlite=result_config(temp).dir_name_sqlite;
  data_sources_name=result_config(temp).data_sources_name;
  last_channel=result_config(temp).last_channel;
  not_calc=result_config(temp).not_calc;
  data_period=result_config(temp).data_period;
  start_date=result_config(temp).start_date;
  stop_date=result_config(temp).stop_date;
  
  if (not_calc==0)
      
        disp(strcat(' ================ calculation of data_period:', data_period,' ========'))
        disp(strcat(' ================                                            ========'))      
        [ output_args ] = Process_by_period( WPath,SqlitePrefix,ini_file,sqlite_file,raw_data_dir,dir_process,dir_name_sqlite,data_sources_name,last_channel,data_period,start_date,stop_date );
  end  
  %z=' ----------------------- '
end


%return


% закрываем соеденение с SQLite
mksqlite(dbid_config, 'close') 