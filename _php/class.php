<?php 
class StartUp{

	private static $all_ini_pregmatch="/\ball.ini\b/i";
	private static $today; 
	public static $ini_array;
	/*
	 * поиск ини файла
	 */
	public static function init($argv){
		self::$today=date("Ymd");
		
		if(is_file('.\all.ini')){
		self::$ini_array = parse_ini_file(".\all.ini",true);
		}elseif(is_file('..\all.ini')){	
			self::$ini_array = parse_ini_file("..\all.ini",true);
		}elseif(is_file('..\_ini\all.ini')){
			self::$ini_array = parse_ini_file("..\_ini\all.ini",true);
		}else{
			$all_ini=false;
				foreach($argv as $key=>$val){
					if($all_ini==false){
							if(  preg_match(self::$all_ini_pregmatch,$val)){
								self::$ini_array = parse_ini_file($val,true);
								if(self::$ini_array['main']['all_ini']==true){
										$all_ini=true;
								}else{
									self::$ini_array='';
								}
							}
					}
				}
				
				if($all_ini==false){
					die("there is no all.ini file \n");
				}
		}
		
		//print_r(self::$ini_array);
	}


	public static function gen_ini(){
		foreach(self::$ini_array['ini_files'] as $key=>$val){
			$file_path=trim(self::$ini_array['main']['WORK_ROOT']).'\\'.trim(self::$ini_array['ini_files'][$key]);
			if( strlen($file_path)>3){
				if( !(is_file($file_path))){
					 //gen_ini($file_path,$key,&self::$ini_array);		 
				}
			}
		}
	}
	
	
	/* 
	 * удаляем и создаём новые файлы для запуска
	 */
	public static function prepere(){
		rm(trim(self::$ini_array['main']['WORK_ROOT']).'\\'.trim(self::$ini_array['name']['backup']).'\\all.rar');
		rm(trim(self::$ini_array['main']['WORK_ROOT']).'\\'.trim(self::$ini_array['name']['backup']).'\\all_'.self::$today.'.rar');
		rm(trim(self::$ini_array['main']['WORK_ROOT']).'\\'.trim(self::$ini_array['name']['backup']).'\\all_little_'.self::$today.'.rar');
		rm(trim(self::$ini_array['main']['WORK_ROOT']).'\\run_*.M');
		rm(trim(self::$ini_array['main']['WORK_ROOT'])."\\dots.txt");
		rm(trim(self::$ini_array['main']['WORK_ROOT'])."\\rar.bat");
		/* записываем файлы для запуска всей обработки */
		file_openclose("".trim(self::$ini_array['main']['WORK_ROOT'])."\\run_all_decor.M","script\r\n","w+");
		file_openclose("".trim(self::$ini_array['main']['WORK_ROOT'])."\\run_all_sp.M","script\r\n","w+");
		file_openclose("".trim(self::$ini_array['main']['WORK_ROOT'])."\\run_DONTEXIST.M","script\r\n","w+");
		file_openclose("".trim(self::$ini_array['main']['WORK_ROOT'])."\\rar.bat","del all.rar\r\n del all.rar\r\n","w+");
		file_openclose("".trim(self::$ini_array['main']['WORK_ROOT'])."\\rar.log.txt","Начало в: ".date("F j, Y, g:i a")."","w+");
		file_openclose("".trim(self::$ini_array['main']['WORK_ROOT'])."\\run_sp_fill_datafile2.M","script\r\n","w+");
	}
	
	
	public static function bacup_all(){
		$ini_array=&self::$ini_array;	
		$today = date("Ymd");
		
		$workroot_backup=(trim($ini_array['main']['WORK_ROOT'])).'\\'.(trim($ini_array['name']['backup']));
		$workroot=$workroot_backup;
		$rar=trim($ini_array['main']['WORK_ROOT']).'\\'.trim($ini_array['main']['RAR']);
		$arguments=' a -r -m5 ';
		rm (trim($workroot).'\\backup_'.$today.'.rar');	
		echo "backup to file ".trim($workroot).'\\backup_'.$today.".rar\n";
		foreach($ini_array['files'] as $key=>$val){
			$output = shell_exec( $rar.$arguments.' '.trim($workroot_backup).'\\backup_'.$today.'.rar '.trim($ini_array['main']['WORK_ROOT']).'\\'.trim($val).'');
			//echo $output."\n";
		}
		
		if(strlen(trim($ini_array['main']['FILE_TO_BACKUP_AT_WORK_ROOT']))>0){
				$line=trim($ini_array['main']['FILE_TO_BACKUP_AT_WORK_ROOT']);
				$filez=explode(",",$line);
				foreach($filez as $key=>$val){
					if(strlen(trim($val))>0){
						$output = shell_exec( $rar.$arguments.' '.trim($workroot_backup).'\\backup_'.$today.'.rar '.trim($ini_array['main']['WORK_ROOT']).'\\'.trim($val).'');
						//echo $output."\n";
						}
				
				
				}
		}
		
		foreach($ini_array['main'] as $key=>$val){
			$txt_pregmatch="/\b.txt\b/i";
			$M_pregmatch="/\b.M\b/i";
					if(  preg_match($M_pregmatch,$val)|| preg_match($txt_pregmatch,$val) ){
						$output = shell_exec( $rar.$arguments.' '.trim($workroot_backup).'\\backup_'.$today.'.rar '.trim($ini_array['main']['WORK_ROOT']).'\\'.trim($val).'');
						//echo $output."\n";
						}
				
				
			}
				
		
		
	
	}
	
	/* $sqlite_dir_reletive - относительный путь к папкам с базами  */
	public static function ini2sqlite($sqlite_dir_reletive){

	$sqlite_dir=trim( (self::$ini_array['main']['WORK_ROOT']).'\\'.$sqlite_dir_reletive);
	$schema = new SQLite3($sqlite_dir.'\\config.sqlite');
	
	$q="  CREATE TABLE IF NOT EXISTS config ( 
		    id           INTEGER  PRIMARY KEY  ON CONFLICT REPLACE,
		    ini_file     TEXT,
		    sqlite_file  TEXT,
		    raw_data_dir TEXT,
		    dir_process  TEXT,
		    dir_name_sqlite TEXT,
		    data_sources_name TEXT DEFAULT ( '3C144' ),
		    last_channel TEXT     NOT NULL
		                          DEFAULT ( 14 ),
		    not_calc     BOOLEAN  NOT NULL
		                          DEFAULT ( 0 ),
		    data_period  TEXT,
		    start_date   DATETIME,
		    stop_date   DATETIME		    
	);";
	
	
	//datetime: 2012-03-31 15:18:20  
	// SELECT * FROM [config] WHERE [start_date]<'2012-03-31 15:18:20' AND [start_date]>'2009-12-31 15:18:20' ;
	
	
	$schema ->exec($q);	
	foreach(self::$ini_array['path'] as $key=>$val_of_path){
				
				$ini=trim( (self::$ini_array['ini_files'][$key]) );
				$sqlite_filename=$sqlite_dir_reletive.'\\'.trim(self::$ini_array['sqlite'][$key]);
				$raw_data_dir=trim( (self::$ini_array['path'][$key]) );
				$dir_process=trim( (self::$ini_array['dir_process'][$key]) );
				$dir_name_sqlite=trim( (self::$ini_array['dir_name_sqlite'][$key]) );
				$data_period=trim( (self::$ini_array['data_period'][$key]) );
				$data_sources_name=trim( (self::$ini_array['data_sources_name'][$key]) );
				
				$temp=explode(" ",$data_period);
				$temp_date=explode(".", $temp[0]);
					
				$d=$temp_date[0];$m=$temp_date[1];$y=$temp_date[2];
				$start_date=date("Y-m-d H:i:s",mktime(0, 0, 0, $temp_date[1], $temp_date[0], $temp_date[2]) );
					
				$temp_date=explode(".", $temp[1]);
				$stop_date=date("Y-m-d H:i:s",mktime(0, 0, 0, $temp_date[1], $temp_date[0], $temp_date[2]));
				/*
				*	$sqlite_filename=$sqlite_dir.'\\'.trim(self::$ini_array['sqlite'][$key]);	
				*	$raw_data_dir=trim( (self::$ini_array['main']['WORK_ROOT']).'\\'.(self::$ini_array['path'][$key]) );
				*	$dir_process=trim( (self::$ini_array['main']['WORK_ROOT']).'\\'.(self::$ini_array['dir_process'][$key]) );
				*/
				
				$wr_ini=trim( (self::$ini_array['main']['WORK_ROOT']).'\\'.(self::$ini_array['ini_files'][$key]) );
				$wr_sqlite_filename=trim( (self::$ini_array['main']['WORK_ROOT']).'\\'.$sqlite_filename);
				
				$last_channel=trim(self::$ini_array['main']['last_channel'] );
				$lc_temp=self::$ini_array['last_channel'];
				if( array_key_exists  ($key,$lc_temp )  ) {
							$last_channel=trim(self::$ini_array['last_channel'][$key] );
				}

				$key_not_calc=self::$ini_array['key_not_calc'];
				if(array_key_exists  ($key,$key_not_calc )  ) {
						// не считать
						$not_calc=1;
				}else{
						// считать
						$not_calc=0;
				}
				
				$q="DELETE FROM  [config] WHERE [id]='".$key."'";
				$schema ->exec($q);
				$q="INSERT INTO [config] 
					([id], [ini_file], [sqlite_file], [raw_data_dir], [dir_process], [last_channel], [not_calc], [data_period], [start_date], [stop_date],[data_sources_name],[dir_name_sqlite]) 
					VALUES ('".$key."','".$ini."' , '".$sqlite_filename."', '".$raw_data_dir."', '".$dir_process."', '".$last_channel."', '".$not_calc."', '".$data_period."', '".$start_date."', '".$stop_date."','".$data_sources_name."','".$dir_name_sqlite."');	";
				
				$schema ->exec($q);
				
				if(is_file($wr_ini)) {
					$date_data_ini=parse_ini_file($wr_ini,true);
					//print_r($date_data_ini);
					
					foreach ($date_data_ini as $source =>$val_ini){
						$db = new SQLite3($wr_sqlite_filename);
						$query="CREATE TABLE IF NOT EXISTS [".(trim($source))."] ( 
										    id       INTEGER PRIMARY KEY,
										    date     TEXT,
										    files    TEXT  UNIQUE ON CONFLICT REPLACE,
										    dots     TEXT,
										    chennels TEXT,
										    time_period  TEXT,
			    							time_middle  TEXT, 
			    							last_channel TEXT,
			    							file_complex INTEGER NOT NULL
			                         						DEFAULT ( 0 ) ,
			                         		file_complex_parent INTEGER NOT NULL
			                         						DEFAULT ( 0 ) ,
										    not_calc BOOLEAN NOT NULL
										                     DEFAULT ( 0 ) 
										                     
						);	";
						
						$db->exec($query);
						foreach ($val_ini['date'] as $key_source_ini =>$date_key_value_for_source){
							echo $dir_process.': '.$source.':'.$key_source_ini." ==>".$date_key_value_for_source."\n";
						
							$files_for_source=trim($val_ini['files'][$date_key_value_for_source]);
							
							$test_is_array=explode(' ',$files_for_source);
							if(count($test_is_array)>1){
								$file_complex_for_source=1;
							}else{
								$file_complex_for_source=0;
							}
							
							$file_no_dotDAT=trim(str_replace(".dat","",str_replace(".DAT","",$files_for_source)));
							
							$path_to_day_dir_adc_view=trim((self::$ini_array['main']['WORK_ROOT'])."\\".$source."\\".$file_no_dotDAT);
							echo $path_to_day_dir_adc_view;
							$adc_view_file=$files_for_source;
							
							adc_view_convert($adc_view_file,$path_to_day_dir_adc_view,&self::$ini_array,$key);
							
							self::source_data_parse($source,&$db,&$val_ini,$key_source_ini,$date_key_value_for_source,$files_for_source,$file_complex_for_source,$last_channel);
							if($file_complex_for_source==1){
								foreach($test_is_array as $files_for_source){
									echo $files_for_source."\n";
									self::source_data_parse($source,&$db,&$val_ini,$key_source_ini,$date_key_value_for_source,$files_for_source,$file_complex_for_source,$last_channel);
								}
								
							}
							
							
							/*			
								$query="INSERT INTO
									[".(trim($source))."] ( [date], [files], [dots], [chennels], 
									[time_period], [time_middle], [file_complex], [not_calc]) 
									VALUES ('".trim($date_key_value_for_source)."', '".$files_for_source."', '".$dots_for_source."', '".$chennels_for_source."',
									 '".$time_period."', '".$time_middle."', '".$file_complex_for_source."', '".$not_calc."');
								";
								$db->exec($query); */
						}
					}
					
					
							
							
							
							
							//$i_maintertion++;	
							if( $not_calc===1 ){
								
							}else{
								echo "Pass\n";
							}
						}
						//if
		}
	
	
	}
	
	public static function source_data_parse($source,&$db,&$val_ini,$key_source_ini,$date_key_value_for_source,$files_for_source,$file_complex_for_source,$last_channel){
	
							//echo $dir_process.': '.$source.':'.$key_source_ini." =>".$date_key_value_for_source."\n";
							/*
							 *  Тут можно извлечь из data_20091123_20091214.ini для отдельного источника свой канал
							 *  
							  $last_channel=trim(self::$ini_array['main']['last_channel'] );
							$lc_temp=self::$ini_array['last_channel'];
							if( array_key_exists  ($key,$lc_temp )  ) {
									$last_channel=trim(self::$ini_array['last_channel'][$key] );
							}
							*/
							$not_calc=0;
							$time_middle=trim($val_ini['time_middle']);
							$time_period=trim($val_ini['time']);
							//$files_for_source=trim($val_ini['files'][$datafilename]);
							if(array_key_exists ($files_for_source,$val_ini['dots'])){
								$dots_for_source=trim($val_ini['dots'][$files_for_source]);
							}else{
								$dots_for_source='';
							}
							$chennels_for_source='';
							if(array_key_exists('chennels',$val_ini)){
								if(  array_key_exists ($files_for_source,$val_ini['chennels'])){
									$chennels_for_source=trim($val_ini['chennels'][$files_for_source]);;
								}
							}	
							if(!(strlen($files_for_source)>0)){
									$not_calc=1;
							
							}
							$test_is_array=explode(' ',$files_for_source);
							if(count($test_is_array)>1){
								$file_complex_parent=1;
								//$file_complex_for_source=1;
							}else{
								$file_complex_parent=0;
							}
														
										
								$query="INSERT INTO
									[".(trim($source))."] ( [date], [files], [dots], [chennels], 
									[time_period], [time_middle], [file_complex],[file_complex_parent], [not_calc]
									,[last_channel]) 
									VALUES ('".trim($date_key_value_for_source)."', '".$files_for_source."', '".$dots_for_source."', '".$chennels_for_source."',
									 '".$time_period."', '".$time_middle."', '".$file_complex_for_source."','".$file_complex_parent."', '".$not_calc."'
									 , '".$last_channel."');
								";
								$db->exec($query); 
								
						
	}
	
	public static function run(){
			$i_maintertion=0;
			/* 
			* цикл в котором из ini-файла берём значения для обрабатываемых директорий и файл ипередаём на обработку 
			* функции обработки complex_function()
			*/
			foreach(self::$ini_array['path'] as $key=>$val_of_path){
					$dir_process=trim( self::$ini_array['dir_process'][$key] );					
					if(strlen($dir_process)>0){
									
							if(!(is_dir($dir_process))){
									mkdir($dir_process, 0700);
							}
							//записываем файлы run_*.М
							file_openclose(trim(self::$ini_array['main']['WORK_ROOT'])."\\run_all_decor.M","clear variables\r\n	clear all\r\n  run ".$dir_process."\\run_decor.M\r\n","a+");
							file_openclose(trim(self::$ini_array['main']['WORK_ROOT'])."\\run_all_sp.M","clear variables\r\n clear all\r\n	run ".$dir_process."\\run_sp.M\r\n","a+");
							file_openclose(trim(self::$ini_array['main']['WORK_ROOT'])."//run_sp_fill_datafile2.M","clear variables\r\n clear all\r\n	run ".$dir_process."\\run_sp_fill_datafile2.M\r\n","a+");
							
						$i_maintertion++;	
						/*
						 if( (self::$ini_array['key_not_calc'][$key])!=true ){
							//complex_function($key,&self::$ini_array,$i_maintertion);
							echo "key:".$key." i_maintertion:".$i_maintertion."\n";
						}else{
							echo "Pass path: ".trim(self::$ini_array['main']['WORK_ROOT'])."\\".$val_of_path." \n\n--------------------------------------------------------------\n\n";
						}
						 
						 */
					}
			}
			
			file_openclose("".trim(self::$ini_array['main']['WORK_ROOT'])."\\rar.bat","pause\r\n","a+");
			file_openclose("".trim(self::$ini_array['main']['WORK_ROOT'])."\\rar.log.txt","\r\nКонец в: ".date("F j, Y, g:i a")."\r\n","a+");
			$ini_array=self::$ini_array;
			self::bacup_all();
	}
}





/**
 * rm() -- Vigorously erase files and directories.
 * 
 * @param $fileglob mixed If string, must be a file name (foo.txt), glob pattern (*.txt), or directory name.
 *                        If array, must be an array of file names, glob patterns, or directories.
 */
function rm($fileglob)
{
    if (is_string($fileglob)) {
        if (is_file($fileglob)) {
            return unlink($fileglob);
        } else if (is_dir($fileglob)) {
            $ok = rm("$fileglob/*");
            if (! $ok) {
                return false;
            }
            return rmdir($fileglob);
        } else {
            $matching = glob($fileglob);
            if ($matching === false) {
                trigger_error(sprintf('No files match supplied glob %s', $fileglob), E_USER_WARNING);
                return false;
            }       
            $rcs = array_map('rm', $matching);
            if (in_array(false, $rcs)) {
                return false;
            }
        }       
    } else if (is_array($fileglob)) {
        $rcs = array_map('rm', $fileglob);
        if (in_array(false, $rcs)) {
            return false;
        }
    } else {
        trigger_error('Param #1 must be filename or glob pattern, or array of filenames or glob patterns', E_USER_ERROR);
        return false;
    }

    return true;
}
/* rm */

function file_openclose($path,$string,$arg){
	
	$f=fopen($path,$arg);
	fwrite($f,$string);
	
	/*if (!$f=fopen($path,$arg) ){  echo "Cannot open file ($path) \n"; }
	if( !fwrite($f,$string)) { 	echo "Cannot write file (($path) , ($arg))  \n"; exit; }
	*/
	if(!fclose($f)){
		echo "Cannot close file ($path) \n";
	}
	
}


/* adc_view_convert - заполнение бат-файла */
function adc_view_convert($file,$path_to_day_dir,$ini_array,$key){
	$adc_view_path=trim($ini_array['main']['WORK_ROOT']).'\\'.trim($ini_array['main']['ADC_VIEW']);
	$bat_file=bat_file_for_data(&$ini_array,$key);
	$bat_file_dont=bat_file_for_data2(&$ini_array,$key);

	$f=fopen($bat_file,"a+");
	$f_dont=fopen($bat_file_dont,"a+");

	fwrite($f,"del /F /Q record.txt \r\n\n del /F /Q record.txt \r\n".$adc_view_path." -t ".$file." \r\n\n del /F /Q ".$path_to_day_dir."\\".str_replace(".dat",".yyy",str_replace(".DAT",".yyy",str_replace("-","","dat_".$file)))." \r\n\n 
copy record.txt ".$path_to_day_dir."\\".str_replace(".dat",".yyy",str_replace(".DAT",".yyy",str_replace("-","","dat_".$file)))." \r\n\n 
del /F /Q record.txt \r\n\n");
	fclose($f);
	if(!(is_file("".$path_to_day_dir."\\".str_replace(".dat",".yyy",str_replace(".DAT",".yyy",str_replace("-","","dat_".$file)))))){
		fwrite($f_dont,"del /F /Q record.txt \r\n\n del /F /Q record.txt \r\n".$adc_view_path." -t ".$file." \r\n\n del /F /Q ".$path_to_day_dir."\\".str_replace(".dat",".yyy",str_replace(".DAT",".yyy",str_replace("-","","dat_".$file)))." \r\n\n 
copy record.txt ".$path_to_day_dir."\\".str_replace(".dat",".yyy",str_replace(".DAT",".yyy",str_replace("-","","dat_".$file)))." \r\n\n 
del /F /Q record.txt \r\n\n");
	}
	fclose($f_dont);

}
/* возвращает имя бат файла, для данных */
function bat_file_for_data(&$ini_array,$key){
	$path=trim($ini_array['main']['WORK_ROOT']).'\\'.$ini_array['path'][$key];
	$t=get_parametr_patch("bat_file_default","undef.bat",&$ini_array,$key,$path);
	return $t;
	
}
/* возвращает имя бат файла, для данных */
function bat_file_for_data2(&$ini_array,$key){
	$path=trim($ini_array['main']['WORK_ROOT']).'\\'.$ini_array['path'][$key];
	$t=get_parametr_patch("bat_file_default_dont_exists","bat_file_default_dont_exists.bat",&$ini_array,$key,$path);
	return $t;
}


function get_parametr_patch($parametr,$default,$ini_array,$key,$path){

	
	if( array_key_exists( $parametr,$ini_array) ){
	$a=$ini_array[$parametr];
	
		if(is_array($a)){
			if(  array_key_exists( $key,$a ) ){
				$temp=trim($ini_array[$parametr][$key]);
				if( strlen($temp)>0 ){
							$t=trim($temp);
				}
			}
		}
	}	
	if( array_key_exists( $parametr,$ini_array['main'] ) ){
	
		$temp=trim($ini_array['main'][$parametr]);
		if( strlen($temp)>0 ){
					$t=trim($temp);
		}else{
					$t=$default;
		}
	}else{	$t=$default; }	
	return $path."\\".$t;
}


?>