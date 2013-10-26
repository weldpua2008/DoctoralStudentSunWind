% ��� ������� ��������� ��������� ��� ����������

%%%%%%%%%%%%%%%%%% example of data
% ini_file =_ini\data_20110215_20110221.ini
% sqlite_file =sqlite\config\data_20110215_20110221.sqlite
% raw_data_dir =_dat_raw\data_20110215_20110221
% dir_process =processing\data_20110215_20110221
% dir_name_sqlite = \data_20071112_20071122
% data_sources_name = 3C144 3C154 3C175 3C196 3C208 3C245 3C254 3C273 3C280 3C295 3C303 3C336
% last_channel = 10
% not_calc =     0
% data_period =15.02.2011 21.02.2011
% start_date = 2011-02-15 00:00:00
% stop_date = 2011-02-21 00:00:00
%%%%%%%%%%%%%%%%%% example of data

function [ output_args ] = Process_by_period( WPath,SqlitePrefix,ini_file,sqlite_file,raw_data_dir,dir_process,dir_name_sqlite, data_sources_name,last_channel,data_period,start_date,stop_date )
% addpath mksqlite_matlab_path -end

% ����������� � database_period_config_file [data_20071112_20071122.sqlite]
database_period_config_file=strcat(WPath,'\',sqlite_file);
dbid_period = mksqlite(3, 'open', database_period_config_file);
%
% SOURCES_ARRAY �������� ����� ����������:   '3C144','3C154'... �� database_period_config_file
% NUMPIECES ���������� ��������� � �������
DELIMITERS = ' ';
[SOURCES_ARRAY,NUMPIECES]=explode(data_sources_name,DELIMITERS );

for table_source_index=1:NUMPIECES
    SOURCE=char(SOURCES_ARRAY(table_source_index));
    result_source = mksqlite(dbid_period,['SELECT * FROM [' SOURCE '] ORDER BY [date] asc ' ]);    
    n_source=size(result_source);  
    
    %%%%%% ���� ��� ����� ������
    for date_idx=1:n_source
        %%%% Example of data
        % date =2011.02.15
        % files =15-02-13.DAT
        % dots =3274 3878 4587
        % chennels =     '1 3'  (�� 1 -> 3)
        % time_period =18:30----20:30
        % time_middle =19:00
        % file_complex =     0
        % file_complex_parent =     0
        % not_calc =     0
        % disp (' ================ ');
        %%%
        date=result_source(date_idx).date;
        files=result_source(date_idx).files;
        dots=result_source(date_idx).dots;
        chennels=result_source(date_idx).chennels;
        time_period=result_source(date_idx).time_period;
        time_middle=result_source(date_idx).time_middle;
        file_complex=result_source(date_idx).file_complex;
        file_complex_parent=result_source(date_idx).file_complex_parent;
        not_calc=result_source(date_idx).not_calc;
        start_channel=str2num(char(result_source(date_idx).last_channel)) + 1;
        if(not_calc==0)
            % ������ ���������� ��������� ����� ��� ��� �� ���������
            channel_array=java.util.Hashtable;
            % ������ ��� �����, ��� ������ ��������� �����
            different_channel_array=java.util.Hashtable;
            % ���� � ��� ������ 2-� ������ �� 3-�
            only_2channel_array=java.util.Hashtable;
            
            only_2channel_arraySp='';
            only_2channel_arraySp=java.util.Hashtable;
            channel_arraySp=channel_array;

            %  ��������� ��������� ������ ������ ��� ������
            %only_2channel_array.put(2,'14 15');

            % ��������� ��������� ������ ������ �������� ��� ���������� ������
            % TODO
            % different_channel_array.put(2,10);
            
            
            
            % ��������� ������ �����
            dots_array=''; dots_array = java.util.Hashtable;            
            [dots_array_temp,num_dots_array]=explode(dots,' ');
            for idx_dots_array_temp=1:num_dots_array
                dots_array.put(idx_dots_array_temp,str2num(char(dots_array_temp(idx_dots_array_temp))));
                
                %��������� ��� Sp_... ������ � ������ ����� ��������
                %idx_dots_array_temp
                if(length(chennels)>2)
                    %chennels
                    only_2channel_arraySp.put(idx_dots_array_temp,char(chennels));  %(idx_dots_array_temp,chennels)
                end
                
                %dots_array.get(idx_dots_array_temp)            
            end
            % ���������  ������ �����

            % basename='141107';
            basename=regexprep(files, '\.', ''); basename=regexprep(basename,'-', '' ); basename=regexprep(basename,'DAT', '' );basename=regexprep(basename,' ', '_' );
            filename_dir=regexprep(files, '\.', ''); filename_dir=regexprep(filename_dir,'DAT', '' );filename_dir=regexprep(filename_dir,' ', '_' );
            % filename='dat_141107.yyy';

            %ReletivePath ���� ��� ���������� ������� ������ 'D:\Work\aspirantura_process\processing\data_20071112_20071122\3C144\14-11-07\';
            ReletivePath=strcat(WPath,'\',dir_process,'\');
            filename=strcat('dat_',basename,'.yyy');
            filename=regexprep(filename,' ', '_' );
            
            filename=strcat(ReletivePath,SOURCE,'\',filename_dir,'\',filename);

            ReletivePath2=strcat(ReletivePath,SOURCE,'\',filename_dir,'\');

            %DatFile='14-11-07.DAT';
            DatFile=files;
            %DirName='\data_20071112_20071122';
            DirName=dir_name_sqlite;
            %Source='\3C144';
            Source=strcat('\',SOURCE);

            % ���������� ������� ��� ���������� 
            % �������� �������� ����� ������ �� ����
            ScintTableName='scint';         
            % databasedir D:\Work\aspirantura_process\sqlite\data_20071112_20071122\
            % databasefile D:\Work\aspirantura_process\sqlite\data_20071112_20071122\3C144.sqlite
            % create path for SQLite file
            databasedir=strcat(WPath,SqlitePrefix,DirName);
            databasefile=strcat(databasedir,Source,'.sqlite');
            % create dir for SQLite
            tf = isdir(databasedir);    if(tf==0)         mkdir(databasedir);     end
            % ������ ����� ��� ������� �  PROGRAM FOR OBTAINING COEFFICIENT CORRELATIONS OF SCINTILLATIONS ON THREE FREQUENCIES
            % BY THREE METHODS.

            
            
            % �����, ������� �������� 0.5-all
            dots_05all_array=java.util.Hashtable;
            % �����, ������� �������� 0.5-0.7
            dots_0507_array=java.util.Hashtable;
            % �����, ������� �������� 0.7-all
            dots_07all_array=java.util.Hashtable;
            %%%%%%%%%%%%%%% 

            n_realization=3;
            % �������� �� ����� ����� "-" � ".", ��� �� ��������� ������� Sqlite ���: "141107DAT" 
            TableName=regexprep(DatFile, '\.', ''); TableName=regexprep(TableName,'-', '' ); TableName=regexprep(TableName,' ', '_' );

            % �������� ���������� � ����� ������
            dbid = mksqlite(5, 'open', databasefile);

            %
            % TODO: ����� ��������� ��� ������ � ������� � ������� 2-� �
            % ����� ����� � ����������
            %
            
            if(file_complex_parent==0)
                %%%%% ������
                dat_ = load(filename);

                [dots_05all_array,dots_0507_array,dots_07all_array]=calc_4one_day_dots(dots_array,only_2channel_array,channel_array,different_channel_array,start_channel,n_realization,dat_,TableName,dbid,ReletivePath2);

                n_real_05all=size(dots_05all_array);
                n_real_0507=size(dots_0507_array);
                n_real_07all=size(dots_07all_array);


                %������ ��� Sp_by_per_us_in_time_20100119()
                dots_arraySp=dots_05all_array;
                % ScintPrefix= [05all 0507 07all]
                ScintPrefix='05all';
                %FileRegexprName=regexprep('dat_141107_3C144_ind/ScintPrefix/*.yyy','/ScintPrefix/',ScintPrefix);

                %FileName=regexprep('dat_141107_3C144_ind/n_real//ScintPrefix/_.yyy','/ScintPrefix/',ScintPrefix);
                %FileName=regexprep(FileName,'/n_real/',num2str(size(dots_arraySp)));
                FileRegexprName=strcat('dat_',basename,'_',SOURCE,'ind',ScintPrefix,'*.yyy');
                FileName=strcat('dat_',basename,'_',SOURCE,'ind',num2str(size(dots_arraySp)),'_',ScintPrefix,'.yyy');


                % 05 - all
                if(n_real_05all>2)
                    [m_from_time_05all,m_from_time_minus_05all,m_from_time_plus_5all,m_from_spectra_05all,m_from_spectra_minus_05all,m_from_spectra_plus_5all]=Sp_by_per_us_in_time_20100119(dots_arraySp,only_2channel_arraySp,channel_arraySp,start_channel,different_channel_array,dat_,TableName,ScintTableName,dbid,ReletivePath,FileName,FileRegexprName,ScintPrefix);
                end

                %������ ��� Sp_by_per_us_in_time_20100119()
                dots_arraySp=dots_0507_array;
                % ScintPrefix= [05all 0507 07all]
                ScintPrefix='0507';
                FileRegexprName=strcat('dat_',basename,'_',SOURCE,'ind',ScintPrefix,'*.yyy');
                FileName=strcat('dat_',basename,'_',SOURCE,'ind',num2str(size(dots_arraySp)),'_',ScintPrefix,'.yyy');


                % 05 - 07
                if(n_real_0507>2)
                    [m_from_time_0507,m_from_time_minus_0507,m_from_time_plus_5all,m_from_spectra_0507,m_from_spectra_minus_0507,m_from_spectra_plus_5all]=Sp_by_per_us_in_time_20100119(dots_arraySp,only_2channel_arraySp,channel_arraySp,start_channel,different_channel_array,dat_,TableName,ScintTableName,dbid,ReletivePath,FileName,FileRegexprName,ScintPrefix);
                end
                %������ ��� Sp_by_per_us_in_time_20100119()
                dots_arraySp=dots_07all_array;
                % ScintPrefix= [05all 0507 07all]
                ScintPrefix='07all';
                FileRegexprName=strcat('dat_',basename,'_',SOURCE,'ind',ScintPrefix,'*.yyy');
                FileName=strcat('dat_',basename,'_',SOURCE,'ind',num2str(size(dots_arraySp)),'_',ScintPrefix,'.yyy');


                % 07 - all
                if(n_real_07all>2)
                    [m_from_time_07all,m_from_time_minus_07all,m_from_time_plus_5all,m_from_spectra_07all,m_from_spectra_minus_07all,m_from_spectra_plus_5all]=Sp_by_per_us_in_time_20100119(dots_arraySp,only_2channel_arraySp,channel_arraySp,start_channel,different_channel_array,dat_,TableName,ScintTableName,dbid,ReletivePath,FileName,FileRegexprName,ScintPrefix);
                end
                
            
            elseif (file_complex_parent==1)   
            %%%%%%%% ������ ��� ������������� �����
                
                [PARENT_FILESOURCES_ARRAY,NUMPIECES_PARENT]=explode(files,DELIMITERS );
                PARENT_FILESOURCES_ARRAY

                % �����, ������� �������� 0.5-all
                dots_05all_array=0; %java.util.Hashtable;
                % �����, ������� �������� 0.5-0.7
                dots_0507_array=0; %java.util.Hashtable;
                % �����, ������� �������� 0.7-all
                dots_07all_array=0; %java.util.Hashtable;
                %%%%%%%%%%%%%%% 
                n_real_05all_complex=0;
                n_real_0507_complex=0;
                n_real_07all_complex=0;
               for complex_source_array_index=1:NUMPIECES_PARENT
                    %%% �������� ����� ������ 
                    ONE_OF_COMPLEXSOURCE=char(PARENT_FILESOURCES_ARRAY(complex_source_array_index));
                    
                     
                    
                    %ONE_OF_COMPLEXSOURCE='16-02-16.DAT'
                    %������� �� ������� ������ ���������� ����������
                    TempTableName=regexprep(ONE_OF_COMPLEXSOURCE, '\.', ''); TempTableName=regexprep(TempTableName,'-', '' ); TempTableName=regexprep(TempTableName,' ', '_' );
                    temp_count=mksqlite(dbid,['SELECT count(*) AS count FROM [' TempTableName '] WHERE [05all]=1']);
                    
                    n_real_0507_complex=n_real_0507_complex+temp_count.count;
                    temp_count=mksqlite(dbid,['SELECT count(*) AS count FROM [' TempTableName '] WHERE [07all]=1']);
                    n_real_07all_complex=n_real_07all_complex+temp_count.count;
                    
                    n_real_05all_complex=n_real_05all_complex+temp_count.count;
                    temp_count=mksqlite(dbid,['SELECT count(*) AS count FROM [' TempTableName '] WHERE [0507]=1']);
                    
               end
               %%%%%% ������������ ������ - ����� ������� 
               n_real_05all_complex
                n_real_0507_complex
                n_real_07all_complex
                
                
                
                
                
               
               
               
            %%%%%%%% ������ ��� ������������� �����
            end 
            
            % ��������� ���������� � SQLite
            mksqlite(dbid, 'close') 
        
        end 
        
    end
    %%%%%% ���� ��� ����� ������
    
end



 
 
output_args=1;


% ��������� ���������� � SQLite
mksqlite(dbid_period, 'close') 

end

