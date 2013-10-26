<?php
/*
* 28.03.2012 
* 15.02.2011
* Квндидатская работа
* Аспирант:
* Соловьёв Валерий Валерьевич
* valeranew@ukr.ner
* 
*/
date_default_timezone_set('Europe/Kiev');
//include_once('functions.php');
include_once('class.php');

StartUp::init($argv);

$sqlite_dir='D:\\Work\\aspirantura_process\\sqlite\\config';
$sqlite_dir_reletive='sqlite\\config';

StartUp::ini2sqlite($sqlite_dir_reletive);

StartUp::gen_ini();
StartUp::prepere();
StartUp::run();


/*
 * продолжение start.php:
 * обработка данных для аспирантуры
 * автор Соловьёв Валерий Валерьевич
 * 17.09.10 07-57
*/


/*
$today = date("Ymd");
$all_ini_pregmatch="/\ball.ini\b/i";
if(is_file('.\all.ini')){
	$ini_array = parse_ini_file(".\all.ini",true);
}elseif(is_file('..\all.ini')){	
	$ini_array = parse_ini_file("..\all.ini",true);
}elseif(is_file('..\_ini\all.ini')){
	$ini_array = parse_ini_file("..\_ini\all.ini",true);
}else{
	$all_ini=false;
		foreach($argv as $key=>$val){
			if($all_ini==false){
					if(  preg_match($all_ini_pregmatch,$val)){
						$ini_array = parse_ini_file($val,true);
						if($ini_array['main']['all_ini']==true){
								$all_ini=true;
						}else{
							$ini_array='';
						}
					}
			}
		}
		
		if($all_ini==false){
			die("there is no all.ini file \n");
		}
}
*/

/*
foreach($ini_array['ini_files'] as $key=>$val){
	$file_path=trim($ini_array['main']['WORK_ROOT']).'\\'.trim($ini_array['ini_files'][$key]);
	if( strlen($file_path)>3){
		if( !(is_file($file_path))){
			 gen_ini($file_path,$key,&$ini_array);		 
		}
	}
}
*/

/*
  
 foreach($ini_array['files'] as $key=>$val){
	if(!(is_file(trim($ini_array['main']['WORK_ROOT']).'\\'.trim($val))) ){
			gen_dat($key,&$ini_array);	
	}
}

*/
/*
 * 
 rm(trim($ini_array['main']['WORK_ROOT']).'\\'.trim($ini_array['name']['backup']).'\\all.rar');
rm(trim($ini_array['main']['WORK_ROOT']).'\\'.trim($ini_array['name']['backup']).'\\all_'.$today.'.rar');
rm(trim($ini_array['main']['WORK_ROOT']).'\\'.trim($ini_array['name']['backup']).'\\all_little_'.$today.'.rar');
rm(trim($ini_array['main']['WORK_ROOT']).'\\run_*.M');
rm(trim($ini_array['main']['WORK_ROOT'])."\\dots.txt");
rm(trim($ini_array['main']['WORK_ROOT'])."\\rar.bat");
*/
/* записываем файлы для запуска всей обработки */

/*
file_openclose("".trim($ini_array['main']['WORK_ROOT'])."\\run_all_decor.M","script\r\n","w+");
file_openclose("".trim($ini_array['main']['WORK_ROOT'])."\\run_all_sp.M","script\r\n","w+");
file_openclose("".trim($ini_array['main']['WORK_ROOT'])."\\run_DONTEXIST.M","script\r\n","w+");
file_openclose("".trim($ini_array['main']['WORK_ROOT'])."\\rar.bat","del all.rar\r\n del all.rar\r\n","w+");
file_openclose("".trim($ini_array['main']['WORK_ROOT'])."\\rar.log.txt","Начало в: ".date("F j, Y, g:i a")."","w+");
file_openclose("".trim($ini_array['main']['WORK_ROOT'])."\\run_sp_fill_datafile2.M","script\r\n","w+");
*/

/* 
* цикл в котором из ini-файла берём значения для обрабатываемых директорий и файл ипередаём на обработку 
* функции обработки complex_function()
*/
/*
$i_maintertion=0;
foreach($ini_array['path'] as $key=>$val_of_path){
		$dir_process=trim( $ini_array['dir_process'][$key] );

		if(strlen($dir_process)>0){
						
				if(!(is_dir($dir_process))){
						mkdir($dir_process, 0700);
				}
				//записываем файлы run_*.М
				file_openclose(trim($ini_array['main']['WORK_ROOT'])."\\run_all_decor.M","clear variables\r\n	clear all\r\n  run ".$dir_process."\\run_decor.M\r\n","a+");
				file_openclose(trim($ini_array['main']['WORK_ROOT'])."\\run_all_sp.M","clear variables\r\n clear all\r\n	run ".$dir_process."\\run_sp.M\r\n","a+");
				file_openclose(trim($ini_array['main']['WORK_ROOT'])."//run_sp_fill_datafile2.M","clear variables\r\n clear all\r\n	run ".$dir_process."\\run_sp_fill_datafile2.M\r\n","a+");
				
			$i_maintertion++;	
			if( ($ini_array['key_not_calc'][$key])!=true ){
				//complex_function($key,&$ini_array,$i_maintertion);
				echo "key:".$key." i_maintertion:".$i_maintertion."\n";
			}else{
				echo "Pass path: ".trim($ini_array['main']['WORK_ROOT'])."\\".$val_of_path." \n\n--------------------------------------------------------------\n\n";
			}
		}
}

file_openclose("".trim($ini_array['main']['WORK_ROOT'])."\\rar.bat","pause\r\n","a+");
file_openclose("".trim($ini_array['main']['WORK_ROOT'])."\\rar.log.txt","\r\nКонец в: ".date("F j, Y, g:i a")."\r\n","a+");
bacup_all(&$ini_array);
*/
?>