<?php
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
/* сохранение файлов  */
function bacup_all($ini_array){
	$today = date("Ymd");
	$workroot_backup=(trim($ini_array['main']['WORK_ROOT'])).'\\'.(trim($ini_array['name']['backup']));
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

/* удаление лишних файлов и создание новых */
function prepare_files($key,$ini_array){
	$dir_process=trim($ini_array['main']['WORK_ROOT']).'\\'.trim($ini_array['dir_process'][$key]);
	$dir_process_results=$dir_process.'\\'.trim($ini_array['name']['dataresults']);
	$temp_dir_process_n_realization=$dir_process_results.'\\'.trim($ini_array['name']['n_realization']);
	$temp_dir_process_n_realization_review=$dir_process_results.'\\'.trim($ini_array['name']['n_realization_review']);
	$bat_file=bat_file_for_data(&$ini_array,$key);
	$bat_file_dont=bat_file_for_data2(&$ini_array,$key);
	
	if(!is_dir($dir_process_results))
		@mkdir($dir_process_results);
	rm($dir_process_results."\\*.yyy");
	rm($dir_process."\\*.csv");
	rm($dir_process."\\*.yyy");
	rm($dir_process."\\spectr*.M");
	rm($dir_process."\\*.yyy*");
	rm($dir_process."\\run_*.M");
	@rm($dir_process."\\fig_*.M");
	@rm($dir_process."\\ch*ck.M");
	@rm($dir_process."\\data_now*.txt");
	@rm(trim($ini_array['main']['WORK_ROOT']).'\\'.$ini_array['path'][$key]."\\*.bat");
	
	file_openclose($dir_process."\\run_decor.M","script\r\n","w+");
	file_openclose($dir_process."\\run_sp.M","script\r\n","w+");
	file_openclose($dir_process."\\run_sp_fill_datafile2.M","script\r\n","w+");
	file_openclose($temp_dir_process_n_realization,"File; realization ; Source\n\t","w+");
	file_openclose($temp_dir_process_n_realization,"; 0.5-1;0.5-0.7;0.7-1;\n\t","a+");

	file_openclose($bat_file,"","w+");
	file_openclose($bat_file_dont,"","w+");

	file_openclose($temp_dir_process_n_realization_review,"File; realization ; Source\n\t","w+");
	file_openclose($temp_dir_process_n_realization_review,"; 0.5-1;0.5-0.7;0.7-1;\n\t","a+");
	
}

/* основная функция вызывающая всё */
function complex_function($key,$ini_array,$i_maintertion){
	//обьявление переменных
	$work_root=trim($ini_array['main']['WORK_ROOT']);
	$dir_process=$work_root.'\\'.trim($ini_array['dir_process'][$key]);
	$d_process_a=explode('\\',trim($ini_array['dir_process'][$key]));
	$t=trim($d_process_a['1']);
	$d_process_a=str_replace('\\','_',$t);
	$dir_process_results=$dir_process.'\\'.trim($ini_array['name']['dataresults']);
	$temp_dir_process_n_realization=$dir_process_results.'\\'.trim($ini_array['name']['n_realization']);
	$temp_dir_process_n_realization_review=$dir_process_results.'\\'.trim($ini_array['name']['n_realization_review']);
	$fig_index=array();
	$bat_file=bat_file_for_data(&$ini_array,$key);
	$bat_file_dont=bat_file_for_data2(&$ini_array,$key);
	$complex=false;
	
	$data_now=$work_root.'\\'.trim($ini_array['files'][$key]);
	$data_path=$work_root.'\\'.trim($ini_array['path'][$key]);
	$rar_line='';
	$rar_line_exec='';

	$figures_path=$ini_array['main']['figures'];
	$space_pregmatch="/\b \b/i";
				

	//удаление лишних файлов и создание новых
	prepare_files($key,&$ini_array);

	$today = date("Ymd"); 
	if( (is_file( $work_root.'\\'.trim($ini_array['ini_files'][$key]) ))&&($ini_array['parse_ini_or_dat'][$key]!=false)  ){
		$ini_file=parse_ini_file($work_root.'\\'.trim($ini_array['ini_files'][$key]),true);
		$file_number=0;
		foreach( $ini_file as $dir_name_source=>$val){			 
			foreach($ini_file[$dir_name_source]['files'] as $key1=>$val1){
				$val10=explode(" ",$val1);
				if(  preg_match($space_pregmatch,$val1) ){
								echo "complex $val1 \n";
								$complex=true;
								$complex_files=$val1;
				}else{
					$complex=false;
				}
				


				foreach($val10 as $file){
					$file_number++;				
									
						if(strlen(trim($file))>1){
							$data_line=$ini_file[$dir_name_source]['dots'][$file];
							$file_no_dotDAT=trim(str_replace(".dat","",str_replace(".DAT","",$file)));
							$path_to_source_core_dir=$dir_process."\\".$dir_name_source;
							$path_to_day_dir=trim($path_to_source_core_dir."\\".$file_no_dotDAT);
									if( !(is_dir($path_to_source_core_dir) ) )
										@mkdir($path_to_source_core_dir,700);
								//rm ($path_to_source_core_dir."\\*.M");	
									if( !(is_dir($path_to_source_core_dir."\\datafile") ) )	
										@mkdir($path_to_source_core_dir."\\datafile",700);
									if( !(is_dir($path_to_source_core_dir."\\datafile2") ) )		
										@mkdir($path_to_source_core_dir."\\datafile2",700);
												
									@mkdir($path_to_day_dir,700);
									@mkdir($path_to_day_dir."\\txt",700);
									rm($path_to_day_dir."\\dat_*.M");
									rm($path_to_day_dir."\\Fq_*.M");	
									rm($path_to_day_dir."\\spectr_*.M");
									
						$rar_line.=$work_root.'\\'.trim($ini_array['main']['RAR']).' a -r -m0 '.$work_root.'\\all_little_'.$today.'.rar '.$dir_process.'\\dataresults\\*.*'."\r\n";
						$rar_line.=$work_root.'\\'.trim($ini_array['main']['RAR']).' a -r -m0 '.$work_root.'\\all_little_'.$today.'.rar '.$path_to_source_core_dir.'\\datafile2\\*.*'."\r\n";
						$rar_line.=$work_root.'\\'.trim($ini_array['main']['RAR']).' a -r -m0 '.$work_root.'\\all_'.$today.'.rar '.$dir_process.'\\dataresults\\*.*'."\r\n";
						$rar_line.=$work_root.'\\'.trim($ini_array['main']['RAR']).' a -r -m0 '.$work_root.'\\all_'.$today.'.rar '.$path_to_source_core_dir.'\\datafile\\*.*'."\r\n";
	
						$rar_line_exec[]=$work_root.'\\'.trim($ini_array['main']['RAR']).' a -r -m0 '.$work_root.'//'.trim($ini_array['name']['backup']).'//all_little_'.$today.'_'.$d_process_a.''.'.rar '.$dir_process.'\\dataresults\\*.*'."\r\n";
						$rar_line_exec[]=$work_root.'\\'.trim($ini_array['main']['RAR']).' a -r -m0 '.$work_root.'//'.trim($ini_array['name']['backup']).'//all_little_'.$today.'_'.$d_process_a.''.'.rar '.$path_to_source_core_dir.'\\datafile2\\*.*'."\r\n";
						$rar_line_exec[]=$work_root.'\\'.trim($ini_array['main']['RAR']).' a -r -m0 '.$work_root.'//'.trim($ini_array['name']['backup']).'//all_'.$today.'_'.$d_process_a.''.'.rar '.$dir_process.'\\dataresults\\*.*'."\r\n";
						$rar_line_exec[]=$work_root.'\\'.trim($ini_array['main']['RAR']).' a -r -m0 '.$work_root.'//'.trim($ini_array['name']['backup']).'//all_'.$today.'_'.$d_process_a.''.'.rar '.$path_to_source_core_dir.'\\datafile\\*.*'."\r\n";
						
						//заполняем массив что бы в последствии построить рисунки
							if((strlen(trim($dir_name_source)>0))&& ($complex==false) ){
								$fig_index[$dir_name_source]=(int)$fig_index[$dir_name_source]+1;
							}
							//($complex==false) нужно что бы не выполнялось один раз для первого файла из набора "комплексного" файла
							if( (strlen($file)>2) &&($complex==false)){
								echo "[".$file_number."] parse ini: ".$key."--> ".$dir_name_source." =>".$file."\n";
									copy_need_files($path_to_day_dir,&$ini_array,$key);
									adc_view_convert($file,$path_to_day_dir,&$ini_array,$key);
									gen_matlab_file($data_line,$file,&$ini_array,$key,$dir_process,$dir_name_source,$complex,&$ini_file);									
							}
							
						
						
						} //end if
					} //end foreach
					
					
				//$complex==true В этом случае надо обрабатывать и создавать один большой файл
				if($complex==true){
					$file_number++;	
					$complex_name=str_replace(" ","_",$complex_files);
					
					$file_no_dotDAT=trim(str_replace(".dat","",str_replace(".DAT","",$complex_name)));
					$path_to_day_dir=trim($path_to_source_core_dir."\\".$file_no_dotDAT);
					echo "[".$file_number."] parse ini: ".$key."--> ".$dir_name_source." =>".$complex_files."\n";
					copy_need_files($path_to_day_dir,&$ini_array,$key);
					gen_matlab_file_complex(&$ini_array,$key,$dir_process,$dir_name_source,$complex_files,&$ini_file);	
					
				}

				
				}
		}
	
		file_openclose($work_root."\\rar.bat",$rar_line,"a+");
		rm($work_root."\\".trim($ini_array['name']['backup'])."\\all_little_".$today."*.rar");
		rm($work_root."\\".trim($ini_array['name']['backup'])."\\all_".$today."*.rar");
		foreach($rar_line_exec as $rar_exec){
			$output= shell_exec($rar_exec);
		}
		foreach($fig_index as $dir_name_source=>$n_days){
			main_fig_gen($figures_path,$dir_name_source,$n_days,$dir_process_results);
		}
	
	
	}else{
		/* old style: работа с файлом содержащим точки	*/
		if((strlen($data_now)>0)&&(is_file($data_now))){
			$f=file($data_now);
			$rar_line='';
			$rar_line_exec='';
			foreach($f as $line){
				//if
				if(strlen( trim($line) )>0){
					$i++;
					$a=explode(":",$line);
					$file1=str_replace(":","",$a['0']);
					$file2=explode("=",$file1);
					$file=trim($file2['0']); //	$file - 17-12-09.DAT из data_now.txt				
					$dir_name_source=trim($file2['1']);  //$dir_name_source - Название директирии с источником из data_now.txt
					if(!(strlen($dir_name_source)>1))
							$dir_name_source="none";
					$data_line=trim($a[1]);
					$file_no_dotDAT=trim(str_replace(".dat","",str_replace(".DAT","",$file))); //$file_no_dotDAT - файл без .DAT 				
					//$path_to_source_core_dir - путь к корневой директории источника 
					$path_to_source_core_dir=$dir_process."\\".$dir_name_source;
					//$path_to_day_dir - путь к корневой директории текущего дня источника 
					$path_to_day_dir=trim($path_to_source_core_dir."\\".$file_no_dotDAT);
					
					if( !(is_dir($path_to_source_core_dir) ) )
						@mkdir($path_to_source_core_dir,700);	
					if( !(is_dir($path_to_source_core_dir."\\datafile") ) )	
						@mkdir($path_to_source_core_dir."\\datafile",700);
					if( !(is_dir($path_to_source_core_dir."\\datafile2") ) )		
						@mkdir($path_to_source_core_dir."\\datafile2",700);
					@mkdir($path_to_day_dir,700);
					@mkdir($path_to_day_dir."\\txt",700);
					rm($path_to_day_dir."\\dat_*.M");
					rm($path_to_day_dir."\\Fq_*.M");	
					rm($path_to_day_dir."\\spectr_*.M");
									
					$rar_line.=$work_root.'\\'.trim($ini_array['main']['RAR']).' a -r -m0 '.$work_root.'\\all_little_'.$today.'.rar '.$dir_process.'\\dataresults\\*.*'."\r\n";
					$rar_line.=$work_root.'\\'.trim($ini_array['main']['RAR']).' a -r -m0 '.$work_root.'\\all_little_'.$today.'.rar '.$path_to_source_core_dir.'\\datafile2\\*.*'."\r\n";
					$rar_line.=$work_root.'\\'.trim($ini_array['main']['RAR']).' a -r -m0 '.$work_root.'\\all_'.$today.'.rar '.$dir_process.'\\dataresults\\*.*'."\r\n";
					$rar_line.=$work_root.'\\'.trim($ini_array['main']['RAR']).' a -r -m0 '.$work_root.'\\all_'.$today.'.rar '.$path_to_source_core_dir.'\\datafile\\*.*'."\r\n";

					$rar_line_exec[]=$work_root.'\\'.trim($ini_array['main']['RAR']).' a -r -m0 '.$work_root.'//'.trim($ini_array['name']['backup']).'//all_little_'.$today.'_'.$d_process_a.''.'.rar '.$dir_process.'\\dataresults\\*.*'."\r\n";
					$rar_line_exec[]=$work_root.'\\'.trim($ini_array['main']['RAR']).' a -r -m0 '.$work_root.'//'.trim($ini_array['name']['backup']).'//all_little_'.$today.'_'.$d_process_a.''.'.rar '.$path_to_source_core_dir.'\\datafile2\\*.*'."\r\n";
					$rar_line_exec[]=$work_root.'\\'.trim($ini_array['main']['RAR']).' a -r -m0 '.$work_root.'//'.trim($ini_array['name']['backup']).'//all_'.$today.'_'.$d_process_a.''.'.rar '.$dir_process.'\\dataresults\\*.*'."\r\n";
					$rar_line_exec[]=$work_root.'\\'.trim($ini_array['main']['RAR']).' a -r -m0 '.$work_root.'//'.trim($ini_array['name']['backup']).'//all_'.$today.'_'.$d_process_a.''.'.rar '.$path_to_source_core_dir.'\\datafile\\*.*'."\r\n";
					
					//заполняем массив что бы в последствии построить рисунки
					if(strlen(trim($dir_name_source)>0)){
						$fig_index[$dir_name_source]=(int)$fig_index[$dir_name_source]+1;
					}
					

						if(strlen($file)>2){
							echo "data in txt: ".$key."--> $dir_name_source =>".$file."\n";
								copy_need_files($path_to_day_dir,&$ini_array,$key);
								adc_view_convert($file,$path_to_day_dir,&$ini_array,$key);
								gen_matlab_file($data_line,$file,&$ini_array,$key,$dir_process,$dir_name_source,$complex,&$ini_file);										
						}
						
						
				} //end if
		    } //end foreach
			
			file_openclose($work_root."\\rar.bat",$rar_line,"a+");
			rm($work_root."\\".trim($ini_array['name']['backup'])."\\all_little_".$today."*.rar");
			rm($work_root."\\".trim($ini_array['name']['backup'])."\\all_".$today."*.rar");

			foreach($rar_line_exec as $rar_exec){
				$output= shell_exec($rar_exec);
			}
			foreach($fig_index as $dir_name_source=>$n_days){
				main_fig_gen($figures_path,$dir_name_source,$n_days,$dir_process_results);
			}
	  }
	  //if
	  
	}
			
}
function last_channel($ini_array,$key){
	if(strlen(trim($ini_array['last_channel'][$key]))>0){
						return trim($ini_array['last_channel'][$key]);
	}elseif(strlen(trim($ini_array['main']['last_channel']))>0){
						return trim($ini_array['main']['last_channel']);
	}else{
						return "13";
	}

}
function Sp_by_per_us_in_time($ini_array,$key){
	$Sp_by_per_us_in_time=get_parametr("Sp_by_per_us_in_time","Sp_by_per_us_in_time_20100119.M.txt",&$ini_array,$key);
	return $Sp_by_per_us_in_time;


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
	$temp=trim($ini_array[$parametr][$key]);
	if( strlen($temp)>0 ){
				$t=trim($temp);
	}
	$temp=trim($ini_array['main'][$parametr]);
	if( strlen($temp)>0 ){
				$t=trim($temp);
	}else{
				$t=$default;
	}
	return $path."\\".$t;
}

function get_parametr($parametr,$default,$ini_array,$key){
$temp=$parametr;	
$t=trim( $ini_array[$parametr][$key]);
	if(strlen( $t)>0){
			$temp=trim($ini_array['main']['WORK_ROOT']).'\\'.$t;
	}
$t=trim($ini_array['main'][$parametr]);
	if(strlen($t)>0){
			$temp=trim($ini_array['main']['WORK_ROOT']).'\\'.trim($t);
	}else{ 
			$temp=trim($ini_array['main']['WORK_ROOT']).'\\'.$default;			
	}

return $temp;
	
	
}
function gen_matlab_file_complex($ini_array,$key,$dir_process,$dir_name_source,$complex_files,$ini_file){
	$complex_files_array=explode(" ",$complex_files);
	$complex_name=str_replace(" ","_",$complex_files);
	$file_no_dotDAT_complex=trim(str_replace(".dat","",str_replace(".DAT","",$complex_name)));
	
	$file_read_decor=get_parametr("file_read_decor","decor_between_3_freq_ind.M.txt",&$ini_array,$key);
	$file_read_decor_check=get_parametr("file_read_decor_check","decor_between_3_freq_ind_check.M.txt",&$ini_array,$key);
	$Sp_by_per_us_in_time=get_parametr("Sp_by_per_us_in_time","Sp_by_per_us_in_time_20100119.M.txt",&$ini_array,$key);
	$last_channel=last_channel(&$ini_array,$key);
	$z=0;$z1=0;$z2=0;$dd_05='';$dd_0507='';$dd_07='';$sig_05='';$sig_0507='';$sig_07='';
	$n_all_realization=0;
	$load_filename_yyy='';	
	echo "\n";
	foreach($complex_files_array as $file){
		echo "==>	complex file process ".$file." \n";
		
	
		$data_line=$ini_file[$dir_name_source]['dots'][$file];
		
		
		$data_line_array=explode(" ",trim($data_line));
		$file_no_dotDAT=trim(str_replace(".dat","",str_replace(".DAT","",$file))); 
		$n_real_static=3;
		$path_to_source_core_dir=$dir_process."\\".$dir_name_source;
		$path_to_day_dir=trim($path_to_source_core_dir."\\".$file_no_dotDAT);
		$file_yyy="dat_".str_replace("-","",$file_no_dotDAT).".yyy";
		$file_for_decor=str_replace("-","",$file_no_dotDAT);
		$load_filename_yyy.="load ".$file_yyy."\t\n";	
			
		rm($path_to_source_core_dir."\\".$file_no_dotDAT_complex."\\".$file_yyy);
		$what_copy=trim($path_to_day_dir."\\".$file_yyy);
		$where_copy=trim($path_to_source_core_dir)."\\$file_no_dotDAT_complex\\".$file_yyy;
		if(!(is_file($where_copy)) ){
			if(!copy($what_copy,$where_copy)){
				echo "can't copy ".$what_copy." to ".$where_copy."\n";
			}
		}
	// Для тех файлов где нужно учитывать только 2 из 3-х каналов 		
				$chennels=trim(str_replace("  "," ",$ini_file[$dir_name_source]['chennels'][$file]));
				$chennels_array=explode(" ",$chennels);
				$full_channels=array("1","2","3");
				$lost_channel_array=array_diff($full_channels,$chennels_array);
				$lost_channel=$lost_channel_array['0'];
				if (strlen($chennels)>1){
					$no_full_chennels=true;
				}else{
					$no_full_chennels=false;
				}
	//			
	
		foreach($data_line_array as $numbers){					
				$temp=explode("kt",trim($numbers));
				$dot=trim($temp['0']); // $dot - точка для file_read_decor
				$k0=0;$k1=0;$k2=0; $ks0=0;$ks1=0;$ks2=0;

							
				if( ($dot>0) ){
					$file_dot=$path_to_day_dir."\\txt\\".$dot;						
					if(is_file($file_dot)){
						//echo $file_dot."\n";
							$n_all_realization++;
							$temp_fq_dot=file($file_dot);
							$t_l_d='';
							foreach($temp_fq_dot as $temp_fq_dot_l){
									$t_l_d.=$temp_fq_dot_l;
							}
							$t_l_d_ar=explode("kt",trim($t_l_d));$t_l_d_ar2=explode("|",trim($t_l_d_ar['1']));$k0=$t_l_d_ar2['0'];
							$k1=$t_l_d_ar2['1'];$k2_=$t_l_d_ar2['2']; $k2__=explode(" ",$k2_);$k2=trim($k2__['0']);
							$t_l_d_ar=explode("ks",trim($t_l_d));$t_l_d_ar2=explode("|",trim($t_l_d_ar['1']));$ks0=$t_l_d_ar2['0'];
							$ks1=$t_l_d_ar2['1'];$ks2_=$t_l_d_ar2['2'];$ks2__=explode(" ",$ks2_);$ks2=trim($ks2__['0']);	
									
						// Для тех файлов где нужно учитывать только 2 из 3-х каналов 		
							if ($no_full_chennels==true){
								switch($lost_channel){
								// Как идёт запись	
								//ks20_25 = $ks0  ks20_30 = $ks1 ks25_30 = $k2s kt20_25 = $k0 kt20_30 = $k1 kt25_30 = $k2
									case 1: 
										$ks0=0.9; $ks1=0.9; $k0=0.9; $k1=0.9;
									break;
									case 2: 
										$ks0=0.9; $ks2=0.9; $k0=0.9; $k2=0.9;
									break;
									case 3: 
										$ks1=0.9; $ks2=0.9; $k1=0.9; $k2=0.9;
									break;
								}
										//		echo 	"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! LOST channel====".$lost_channel." LAST channel==== ".$last_channel."";
							}
							
							//	
							
	
							$array_05=comparison($dot,&$z,1,$k0,$k1,$k2,$file_no_dotDAT,$last_channel,$lost_channel,$ks0,$ks1,$ks2,"".$dir_process."//check.M",$path_to_day_dir."\\Fq_ind_".$dot.".M"); 
							$dd_05.=$array_05['dd'];$sig_05.=$array_05['sig'];
							
							$array0507=comparison($dot,&$z1,2,$k0,$k1,$k2,$file_no_dotDAT,$last_channel,$lost_channel,$ks0,$ks1,$ks2,"".$dir_process."//check.M",$path_to_day_dir."\\Fq_ind_".$dot.".M");
							$dd_0507.=$array0507['dd'];$sig_0507.=$array0507['sig'];
							$array_07=comparison($dot,&$z2,3,$k0,$k1,$k2,$file_no_dotDAT,$last_channel,$lost_channel,$ks0,$ks1,$ks2,"".$dir_process."//check.M",$path_to_day_dir."\\Fq_ind_".$dot.".M");
							$dd_07.=$array_07['dd'];$sig_07.=$array_07['sig'];						
						}
				}  //if
		}//foreach

	} //foreach $file
	echo "\n";
	
		$date_for_scint_gen=$complex_files;
	foreach($ini_file[$dir_name_source]['files'] as $key_date=>$val_filename){
			$d1=trim($val_filename);
			$val_filename=$d1;
			//$d1=trim($file);
			//$file=$d1;
			
			if($val_filename==$complex_files){
				$temp_scint_gen=explode(".",$key_date);
				$date_for_scint_gen=$temp_scint_gen[2]."".$temp_scint_gen[1].$temp_scint_gen[0];
				//echo 	"*************** $val_filename==$complex_files  $date_for_scint_gen ;;;+ $key_date \n";	
			}
			
		}


	
	$file_no_dotDAT=trim(str_replace(".dat","",str_replace(".DAT","",$complex_name)));
	$path_to_day_dir=trim($path_to_source_core_dir."\\".$file_no_dotDAT);
	rm($path_to_day_dir."\\dat*.M");				
	write_all_file_dat_m(&$Sp_by_per_us_in_time,&$path_to_day_dir,$z,$z1,$z2,&$file_no_dotDAT,$dd_07,$sig_07,$dd_0507,$sig_0507,$dd_05,$sig_05,$dir_name_source,$dir_process,&$ini_array,false,$load_filename_yyy);
	
	if($n_all_realization>0)
		echo "complex realization: [". ($z/3)."/".$n_all_realization."] [". ($z1/3)."/".$n_all_realization."] [". ($z2/3)."/".$n_all_realization."]\n\n";
	
	spectr_gen(($z/3),($z1/3 ),($z2/3),$path_to_day_dir,$file_no_dotDAT,&$ini_array,$key,$dir_name_source,$dir_process);
	scint_gen(($z/3),($z1/3 ),($z2/3),$ini_array,$key,$ini_file, $path_to_day_dir,$path_to_source_core_dir,$dir_name_source,$dir_process,$date_for_scint_gen);
	
	file_openclose(trim($ini_array['dir_process'][$key])."\\dataresults\\n_realization.csv",$complex_name."; ".($z/3).";".($z1/3).";".($z2/3).";".$dir_name_source."\n\t","a+");
	if( ($z2/3)<5)
	file_openclose(trim($ini_array['dir_process'][$key])."\\dataresults\\n_realization_review.csv",$complex_name."; ".($z/3).";".($z1/3).";".($z2/3).";".$dir_name_source."\n\t","a+");
	
}

/*
* $data_line - строка с точками для данного дня
* $file - 17-12-09.DAT из data_now.txt
* $file_no_dotDAT -  файл без .DAT 
* $file_read_decor - расположение файла decor_between_3_freq_ind.M.txt
* */
function gen_matlab_file($data_line,$file,$ini_array,$key,$dir_process,$dir_name_source,$complex,$ini_file){

	$file_read_decor=get_parametr("file_read_decor","decor_between_3_freq_ind.M.txt",&$ini_array,$key);
	$file_read_decor_check=get_parametr("file_read_decor_check","decor_between_3_freq_ind_check.M.txt",&$ini_array,$key);
	$Sp_by_per_us_in_time=get_parametr("Sp_by_per_us_in_time","Sp_by_per_us_in_time_20100119.M.txt",&$ini_array,$key);
	$last_channel=last_channel(&$ini_array,$key);


	$data_line_array=explode(" ",trim($data_line));

	$file_no_dotDAT=trim(str_replace(".dat","",str_replace(".DAT","",$file))); 
	$n_real_static=3;
	$path_to_source_core_dir=$dir_process."\\".$dir_name_source;
	$path_to_day_dir=trim($path_to_source_core_dir."\\".$file_no_dotDAT);
	$file_yyy="dat_".str_replace("-","",$file_no_dotDAT).".yyy";
	$file_for_decor=str_replace("-","",$file_no_dotDAT);
	$z=0;$z1=0;$z2=0;$dd_05='';$dd_0507='';$dd_07='';$sig_05='';$sig_0507='';$sig_07='';
	
	file_openclose($dir_process."\\data_now.txt","\r\n".$file.":","a+");
	file_openclose($dir_process."\\data_now_plain.txt","\r\n".$file.":","a+");
	
	
	file_openclose($path_to_day_dir."\\fq_plain.txt","".$file.":","w+");
	file_openclose($path_to_day_dir."\\fq.txt","".$file.":","w+");
	$run_decor_line='';
	$n_all_realization=0;
	// Для тех файлов где нужно учитывать только 2 из 3-х каналов 		
				$chennels=trim(str_replace("  "," ",$ini_file[$dir_name_source]['chennels'][$file]));
				$chennels_array=explode(" ",$chennels);
				$full_channels=array("1","2","3");
				$lost_channel_array=array_diff($full_channels,$chennels_array);
				$lost_channel=$lost_channel_array['0'];
				if (strlen($chennels)>1){
					$no_full_chennels=true;
				}else{
					$no_full_chennels=false;
				}
	//							
	foreach($data_line_array as $numbers){					
			$temp=explode("kt",trim($numbers));
			$dot=trim($temp['0']); // $dot - точка для file_read_decor
			$k0=0;$k1=0;$k2=0; $ks0=0;$ks1=0;$ks2=0;
			if( ($dot>0) ){
				$file_dot=$path_to_day_dir."\\txt\\".$dot;
			
				file_openclose($path_to_day_dir."\\fq_plain.txt"," ".$dot,"a+"); //заполнение файла fq.txt
				@rm($path_to_day_dir."\\Fq_ind_".$dot.".M"); 
				@rm($path_to_day_dir."\\FQ_*".$dot.".M"); 
				@rm($path_to_day_dir."\\Fq_check*".$dot.".M");
				write_endfile_based_on_decor($path_to_day_dir,$dot,$file_read_decor,$n_real_static,$file_yyy,$file_for_decor,$last_channel);
				$run_decor_line.="clear all \r\n run ".$path_to_day_dir."\\Fq_ind_".$dot.".M\r\n";
				
				if(is_file($file_dot)){
						$n_all_realization++;
						$temp_fq_dot=file($file_dot);
						$t_l_d='';
						foreach($temp_fq_dot as $temp_fq_dot_l){
								$t_l_d.=$temp_fq_dot_l;
						}
						$t_l_d_ar=explode("kt",trim($t_l_d));$t_l_d_ar2=explode("|",trim($t_l_d_ar['1']));$k0=$t_l_d_ar2['0'];
						$k1=$t_l_d_ar2['1'];$k2_=$t_l_d_ar2['2']; $k2__=explode(" ",$k2_);$k2=trim($k2__['0']);
						$t_l_d_ar=explode("ks",trim($t_l_d));$t_l_d_ar2=explode("|",trim($t_l_d_ar['1']));$ks0=$t_l_d_ar2['0'];
						$ks1=$t_l_d_ar2['1'];$ks2_=$t_l_d_ar2['2'];$ks2__=explode(" ",$ks2_);$ks2=trim($ks2__['0']);	
				
						// Для тех файлов где нужно учитывать только 2 из 3-х каналов 		
							if ($no_full_chennels==true){
								switch($lost_channel){
								// Как идёт запись	
								//ks20_25 = $ks0  ks20_30 = $ks1 ks25_30 = $k2s kt20_25 = $k0 kt20_30 = $k1 kt25_30 = $k2
									case 1: 
										$ks0=0.9; $ks1=0.9; $k0=0.9; $k1=0.9;
									break;
									case 2: 
										$ks0=0.9; $ks2=0.9; $k0=0.9; $k2=0.9;
									break;
									case 3: 
										$ks1=0.9; $ks2=0.9; $k1=0.9; $k2=0.9;
									break;
								}
									//			echo 	"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! LOST channel====".$lost_channel." LAST channel==== ".$last_channel."";
							}
							
							//	
							
						$array_05=comparison($dot,&$z,1,$k0,$k1,$k2,$file_no_dotDAT,$last_channel,$lost_channel,$ks0,$ks1,$ks2,"".$dir_process."//check.M",$path_to_day_dir."\\Fq_ind_".$dot.".M"); 
						$dd_05.=$array_05['dd'];$sig_05.=$array_05['sig'];
						
						$array0507=comparison($dot,&$z1,2,$k0,$k1,$k2,$file_no_dotDAT,$last_channel,$lost_channel,$ks0,$ks1,$ks2,"".$dir_process."//check.M",$path_to_day_dir."\\Fq_ind_".$dot.".M");
						$dd_0507.=$array0507['dd'];$sig_0507.=$array0507['sig'];
						$array_07=comparison($dot,&$z2,3,$k0,$k1,$k2,$file_no_dotDAT,$last_channel,$lost_channel,$ks0,$ks1,$ks2,"".$dir_process."//check.M",$path_to_day_dir."\\Fq_ind_".$dot.".M");
						$dd_07.=$array_07['dd'];$sig_07.=$array_07['sig'];
						
						
						file_openclose($path_to_day_dir."\\fq.txt"," [ ".$dot."kt:".$k0."|".$k1."|".$k2."| ks:".$ks0."|".$ks1."|".$ks2."| ]\r\n","a+");
						
						file_openclose($dir_process."\\data_now.txt"," ".$dot."","a+");
						file_openclose($dir_process."\\data_now_plain.txt"," ".$dot."","a+");
										
						if(!(strlen($array_07['dd'])>2)  &&( ($ks0>="0.6")&&($ks1>="0.6")&&($ks2>="0.6")&&($ks0<="1.45")&&($ks1<="1.45")&&($ks2<="1.45")  ))
							write_endfile_based_on_decor_check($path_to_day_dir,$dot,$file_read_decor_check,$n_real_static,$file_yyy,$file_for_decor,$last_channel);
					}else{ 	
							file_openclose("".trim($ini_array['main']['WORK_ROOT'])."\\run_DONTEXIST.M","run ".$path_to_day_dir."\\Fq_ind_".$dot.".M"."\r\n","a+");
							echo "dont exist ".$file_dot."\n"; 	
					}
			}  //if
	}//foreach

	file_openclose($dir_process."\\run_decor.M",$run_decor_line,"a+");	
	if( !(is_dir($path_to_day_dir."\\txt")) )
		@mkdir($path_to_day_dir."\\txt",700);
	$load_filename_yyy="load ".$file_yyy;
	
	write_all_file_dat_m(&$Sp_by_per_us_in_time,&$path_to_day_dir,$z,$z1,$z2,&$file_no_dotDAT,$dd_07,$sig_07,$dd_0507,$sig_0507,$dd_05,$sig_05,$dir_name_source,$dir_process,&$ini_array,$complex,$load_filename_yyy);
	
	if($n_all_realization>0)
		echo " realization: [". ($z/3)."/".$n_all_realization."] [". ($z1/3)."/".$n_all_realization."] [". ($z2/3)."/".$n_all_realization."]\n\n";
	
	spectr_gen(($z/3),($z1/3),($z2/3),$path_to_day_dir,$file_no_dotDAT,&$ini_array,$key,$dir_name_source,$dir_process);
	
	$date_for_scint_gen=$file_no_dotDAT;
	foreach($ini_file[$dir_name_source]['files'] as $key_date=>$val_filename){
			$d1=trim($val_filename);
			$val_filename=$d1;
			//$d1=trim($file);
			//$file=$d1;
			
			if($val_filename==$file){
				$temp_scint_gen=explode(".",$key_date);
				$date_for_scint_gen=$temp_scint_gen[2]."".$temp_scint_gen[1].$temp_scint_gen[0];
				//echo 	"*************** $val_filename==$file  $date_for_scint_gen ;;;+ $key_date \n";	
			}
			
		}

	scint_gen(($z/3),($z1/3 ),($z2/3),$ini_array,$key,$ini_file,$path_to_day_dir,$path_to_source_core_dir,$dir_name_source,$dir_process,$date_for_scint_gen);
	
	
	//$temp_dir_process_n_realization=trim($ini_array['dir_process'][$key])."\\dataresults\\n_realization.csv";

	file_openclose(trim($ini_array['dir_process'][$key])."\\dataresults\\n_realization.csv",$file."; ".($z/3).";".($z1/3).";".($z2/3).";".$dir_name_source."\n\t","a+");
	if( ($z2/3)<5)
	file_openclose(trim($ini_array['dir_process'][$key])."\\dataresults\\n_realization_review.csv",$file."; ".($z/3).";".($z1/3).";".($z2/3).";".$dir_name_source."\n\t","a+");
	
}

/* записываем все dat_*.M файлы */
function write_all_file_dat_m($Sp_by_per_us_in_time,$path_to_day_dir,$z,$z1,$z2,$file_no_dotDAT,$dd_07,$sig_07,$dd_0507,$sig_0507,$dd_05,$sig_05,$dir_name_source,$dir_process,$ini_array,$complex,$load_filename_yyy){
	$n07all=($z2/3);
	$n0507=($z1/3);
	$n05all=($z/3);

	write_dat_M_file($Sp_by_per_us_in_time,1,$path_to_day_dir,$z,$file_no_dotDAT,str_replace("-","",$dd_05."\n\n\r".$sig_05."\n\n\r"),$dir_name_source,$dir_process,&$ini_array,$complex,$load_filename_yyy,$n05all,$n0507,$n07all);
	
	write_dat_M_file($Sp_by_per_us_in_time,2,$path_to_day_dir,$z1,$file_no_dotDAT,str_replace("-","",$dd_0507."\n\n\r".$sig_0507."\n\n\r"),$dir_name_source,$dir_process,&$ini_array,$complex,$load_filename_yyy,$n05all,$n0507,$n07all);
	


	write_dat_M_file($Sp_by_per_us_in_time,3,$path_to_day_dir,$z2,$file_no_dotDAT,str_replace("-","",$dd_07."\n\n\r".$sig_07."\n\n\r"),$dir_name_source,$dir_process,&$ini_array,$complex,$load_filename_yyy,$n05all,$n0507,$n07all);

}

/* 
*	write_dat_M_file - создаёт файл для расчёта
*	$key=> 1 = от 0.5-1, 2 = от 0.5-0.7, 3 = 0.7-1
*/
function write_dat_M_file($Sp_by_per_us_in_time,$key,$path_to_day_dir,$z,$file_no_dotDAT,$data_full,$source,$dir_process,$ini_array,$complex,$load_filename_yyy,$n05all,$n0507,$n07all){
/*	$n07all=($z2/3);
	$n0507=($z1/3);
	$n05all=($z/3);
*/

	$del3="%del3%";
		switch($key){
		case "1": $k1=0.5; $k2=1; $kname="05all"; $n_realization=$n05all;
				break;
		case "2": $k1=0.5; $k2=0.7; $kname="0507"; $n_realization=$n0507;
				break;
		case "3": $k1=0.7;$k2=1; $kname="07all"; $n_realization=$n07all;
				break;					
	}
	if( ($n07all>2)){
				$path_to_file_write_gt=$path_to_day_dir."\\dat_".str_replace("-","",$file_no_dotDAT)."_".$source."_ind".$n07all."_07all.M";
				if($key==3)
					$del3="";
				else
					$del3="%del3%";
	}elseif( ($n0507>2)  ){
				$path_to_file_write_gt=$path_to_day_dir."\\dat_".str_replace("-","",$file_no_dotDAT)."_".$source."_ind".$n0507."_0507.M";
				if($key==2)
					$del3="";
				else
					$del3="%del3%";	
		
	}elseif( $n05all>2 ){
			$path_to_file_write_gt=$path_to_day_dir."\\dat_".str_replace("-","",$file_no_dotDAT)."_".$source."_ind".$n05all."_05all.M";
			if($key==1)
					$del3="";
			else
				 $del3="%del3%";
	}else{
			$path_to_file_write_gt=$path_to_day_dir."\\dat_".str_replace("-","",$file_no_dotDAT)."_".$source."_ind".$n05all."_05all.M";
			$del3="%del3%";
	}
	if($complex==true){
			$del3="%del3%";
	}
	
	if( (($n07all>2) || ($n0507>2) || ($n05all>2)) && ($key==3) ){
		echo " (($n07all>2) || ($n0507>2) || ($n05all>2)) ".$path_to_file_write_gt."\n";
		
		write_script_run_sp_file2($path_to_file_write_gt,$dir_process);
	}	

	$file_write_filter_yyy="dat_".str_replace("-","",$file_no_dotDAT)."_".$source."_ind".$n_realization."_".$kname.".yyy";
	$file_write_filter_yyy_delete="dat_".str_replace("-","",$file_no_dotDAT)."_".$source."_ind*_".$kname.".yyy";
	$file_write_filter_yyy_delete2="dat_".str_replace("-","",$file_no_dotDAT)."_".$source."_ind*.yyy";

	if(($n_realization>2) ){ //|| (($complex==true)&&($n_realization>0)) ){
		$path_to_file_write=$path_to_day_dir."\\dat_".str_replace("-","",$file_no_dotDAT)."_".$source."_ind".$n_realization."_".$kname.".M";
		
		write_script_run_sp_file($path_to_file_write,$dir_process);
		
		$Sp_by_per_us_in_time_ar=file($Sp_by_per_us_in_time);
		//echo $Sp_by_per_us_in_time."\n";
		$line_sp_all='';
		foreach($Sp_by_per_us_in_time_ar as $line_sp){
			$line_sp_all.=" ".str_replace("%load_filename_yyy%",$load_filename_yyy,str_replace("%del3%",$del3,str_replace("%filename_yyy_to_delete%",$file_write_filter_yyy_delete,str_replace("%filename_yyy_to_delete2%",$file_write_filter_yyy_delete2,str_replace("%scint_index%","scint_index_".$kname."",str_replace("%data_%",$data_full, str_replace("%n_realization%",$n_realization,str_replace("%filename_yyy%","dat_".str_replace("-","",$file_no_dotDAT).".yyy",str_replace("%filename_yyy_%",$file_write_filter_yyy,$line_sp)))))))));
		}
		file_openclose($path_to_file_write,$line_sp_all,"a+");
		
		if(!(is_file($path_to_day_dir."\\".$file_write_filter_yyy))){
			file_openclose("".trim($ini_array['main']['WORK_ROOT'])."\\run_DONTEXIST.M","run ".$path_to_file_write."\r\n","a+");
		}
	}
	




}

/* записывает конечный файл Fq_check_ */
function write_endfile_based_on_decor_check($path_to_day_dir,$dot,$file_read_decor,$n_real_static,$file_yyy,$file_for_decor,$last_channel){
				
				$f_decor=file($file_read_decor);
				$datas=gen_data_line($dot,&$n_real_static,$file_for_decor,$last_channel);
				$n_real_static=$n_real_static*3;
				$line='';
				foreach($f_decor as $temp_line_of_decor){
					
					$line.=str_replace("%data_fprint%",$dot,str_replace("%info_freq_txt%","check/".$dot, str_replace("%data%",$datas, str_replace("%file_yyy%",$file_yyy,str_replace("%n_realization%",$n_real_static,	$temp_line_of_decor)))));

				}
				file_openclose($path_to_day_dir."//Fq_check_".$dot.".M",$line,"a+");
	
}
/* записывает конечный файл на основнии decor */
function write_endfile_based_on_decor($path_to_day_dir,$dot,$file_read_decor,$n_real_static,$file_yyy,$file_for_decor,$last_channel){
				$f_decor=file($file_read_decor);
				$datas=gen_data_line($dot,&$n_real_static,$file_for_decor,$last_channel);
				$n_real_static=$n_real_static*3;
				$line='';
				foreach($f_decor as $temp_line_of_decor){
						$line.=str_replace("%data_fprint%",$dot,str_replace("%info_freq_txt%","txt/".$dot, str_replace("%data%",$datas, str_replace("%file_yyy%",$file_yyy,str_replace("%n_realization%",$n_real_static,	$temp_line_of_decor)))));
				}
				file_openclose($path_to_day_dir."//Fq_ind_".$dot.".M",$line,"a+");
				
}

/* генерируется строчка для конечного файла */
function gen_data_line($dot_array,&$n_realization,$filename,$last_channel){
	$sig='';
	$dd='';
	$n_realization=0;
	if(!(is_array($dot_array))){
				$t=$dot_array;	$dot_array=array($t);
	}
			$i=0;
	if(is_array($dot_array)){
		foreach($dot_array as $dot){
			$n_realization++;
			$i++;
			$sig.="signal(".$i.",1:600)=dd".$i."';\r\n";
			$dd.="dd".$i."=dat_".$filename."(".$dot.":".($dot+599).",".($last_channel+1).");\r\n";
			$i++;
			$sig.="signal(".$i.",1:600)=dd".$i."';\r\n";
			$dd.="dd".$i."=dat_".$filename."(".$dot.":".($dot+599).",".($last_channel+2).");\r\n";
			$i++;
			$sig.="signal(".$i.",1:600)=dd".$i."';\r\n";
			$dd.="dd".$i."=dat_".$filename."(".$dot.":".($dot+599).",".($last_channel+3).");\r\n";			
		}
	}
	return $dd.$sig;
}


/*
* comparison() - нужна для того что бы сравнить
*	$key=> 1 = от 0.5-1, 2 = от 0.5-0.7, 3 = 0.7-1
*	$last_channel - какой последний канал, ели в файле меньше каналов
*/
function comparison($dot,&$z,$key,$kt0,$kt1,$kt2,$filename_yyy,$last_channel,$lost_channel,$ks0,$ks1,$ks2,$check_path,$path_write){
		

	$last_channel++;
	$dd_line='';$sig_line='';
		switch($key){
			case "1": $k1=0.5; $k2=10;
					break;
			case "2": $k1=0.496; $k2=0.8;
					break;
			case "3": $k1=0.65;$k2=10;
					break;					
		}
	
		$ch_20=$last_channel;
		$ch_25=$last_channel+1;
		$ch_30=$last_channel+2;
		switch($lost_channel){
			case 1:
				$ch_20=$last_channel+1;
			break;
			case 2:
				$ch_25=$last_channel+2;
			break;
			case 3:
				$ch_30=$last_channel+1;
			break;
				
		}
	if( ($kt0<=$k2)&&($kt0>=$k1)&&($kt1<=$k2)&&($kt1>=$k1)&&($kt2<=$k2)&&($kt2>=$k1) ){			
			$one_sixh=$dot+599;	
			
			
			$z++;		
			$dd_line.="dd".$z."=dat_".$filename_yyy."(".$dot.":".$one_sixh.",".$ch_20.");\r\n";$sig_line.="sig(".$z.",1:600)=dd".$z."';\r\n";
			$z++;
			$dd_line.="dd".$z."=dat_".$filename_yyy."(".$dot.":".$one_sixh.",".$ch_25.");\r\n";$sig_line.="sig(".$z.",1:600)=dd".$z."';\r\n";
			$z++;
			$dd_line.="dd".$z."=dat_".$filename_yyy."(".$dot.":".$one_sixh.",".$ch_30.");\r\n";$sig_line.="sig(".$z.",1:600)=dd".$z."';\r\n";	
	
		return array("dd"=>$dd_line,"sig"=>$sig_line);
		
	}elseif( ($ks0>="0.69")&&($ks1>="0.69")&&($ks2>="0.69")&&($ks0<="1.31")&&($ks1<="1.31")&&($ks2<="1.31") ){
			$one_sixh=$dot+599;				
			$z++;		
			$dd_line.="dd".$z."=dat_".$filename_yyy."(".$dot.":".$one_sixh.",".$ch_20.");\r\n";$sig_line.="sig(".$z.",1:600)=dd".$z."';\r\n";
			$z++;
			$dd_line.="dd".$z."=dat_".$filename_yyy."(".$dot.":".$one_sixh.",".$ch_25.");\r\n";$sig_line.="sig(".$z.",1:600)=dd".$z."';\r\n";
			$z++;
			$dd_line.="dd".$z."=dat_".$filename_yyy."(".$dot.":".$one_sixh.",".$ch_30.");\r\n";$sig_line.="sig(".$z.",1:600)=dd".$z."';\r\n";	
		return array("dd"=>$dd_line,"sig"=>$sig_line);
	}elseif($key==3){ 
			file_openclose($check_path,"".$path_write."\r\n","a+");
		return array("dd"=>"","sig"=>""); 
	}else{
		return array("dd"=>"","sig"=>""); 
	}
}



/* */
function write_script_run_sp_file($path_to_file_write,$dir_process){
	$f=fopen($dir_process."\\run_sp.M","a+");
	//echo $path_to_file_write."\r\n";
	fwrite($f,"run ".$path_to_file_write."\r\n");
	fclose($f);
	
}
function write_script_run_sp_file2($path_to_file_write,$dir_process){
	$f=fopen($dir_process."\\run_sp_fill_datafile2.M","a+");
	//echo $path_to_file_write."\r\n";
	fwrite($f,"run ".$path_to_file_write."\r\n");
	fclose($f);
	
}

/* генерация файла спектров: spectr_131107_3C144.M */
function spectr_gen($z,$z1,$z2,$path_to_day_dir,$file_no_dotDAT,&$ini_array,$key,$dir_process,$dir_process2){

	//если у нас больше 2-х реализаций для 0.5-1, 0.5-07, 0.7-1
	if( ($z>2)&&($z1>2)&&($z2>2) ){
		$f_sp=file(trim($ini_array['main']['spectr_05_0507_071']));
	}elseif(($z>2)&&($z1>2)){
	//если у нас больше 2-х реализаций для 0.5-1, 0.5-07
		$f_sp=file(trim($ini_array['main']['spectr_0507']));
	}elseif(($z>2)&&($z2>2)){
	//если у нас больше 2-х реализаций для 0.5-1, 0.7-1
			$f_sp=file(trim($ini_array['main']['spectr_051_071']));
	}elseif(($z1>2)&&($z2>2)){
	//если у нас больше 2-х реализаций для 0.5-0.7, 0.7-1
			$f_sp=file(trim($ini_array['main']['spectr_051_071']));
	}else{
		
		//echo "think! \n";
		return 0;	
	}
	@rm($path_to_day_dir."\\spectr_*.M");
	//@rm($dir_process2."\\dataresults\\spectr_*.M");
	//@rm($dir_process2."\\".$dir_process."\\datafile\\spectr_*.M");
	$f=fopen($path_to_day_dir."\\spectr_".str_replace("-","",$file_no_dotDAT)."_".$dir_process.".M","w+");
	$f2=fopen($dir_process2."\\".$dir_process."\\datafile\\spectr_".str_replace("-","",$file_no_dotDAT)."_".$dir_process.".M","w+");
	
	foreach($f_sp as $line){
		fwrite($f,str_replace("%date%",str_replace("-","",$file_no_dotDAT),str_replace("%dir%",$dir_process,str_replace("%n_r05%",$z,str_replace("%n_r07%",$z2,str_replace("%n_r0507%",$z1,$line))))));	
		fwrite($f2,str_replace("%date%",str_replace("-","",$file_no_dotDAT),str_replace("%dir%",$dir_process,str_replace("%n_r05%",$z,str_replace("%n_r07%",$z2,str_replace("%n_r0507%",$z1,$line))))));	
	}
	
	fclose($f);
		fclose($f2);
}


/* функция генерирующая данные для рисунков индексов */
function scint_gen($z,$z1,$z2,$ini_array,$key,$ini_file,$path_to_day_dir,$path_to_source_core_dir,$dir_name_source,$dir_process,$file_no_dotDAT){
	//$fw2=fopen($path_to_source_core_dir."\\".$dir_name_source.".yyy","a+");
	//$time_middle=str_replace(":","",$ini_file[$dir_name_source]['time_middle']);
	$time_middle=trim($ini_file[$dir_name_source]['time_middle']);
	$time_middle_a=explode(":",$time_middle);
	$time_middle=$time_middle_a['0'];
	//echo "TIME MIDLE!!!!!!!!:::: ".$time_middle."\n";
		
	$fw2=fopen($dir_process."\\dataresults\\dat_".$dir_name_source.".yyy","a+");
	/*
	$fw2_05all=fopen($dir_process."\\".$dir_name_source."_05all.yyy","a+");
	$fw2_0507=fopen($dir_process."\\".$dir_name_source."_0507.yyy","a+");
	$fw2_07all=fopen($dir_process."\\dat_".$dir_name_source."_07all.yyy","a+");
	*/
	$n_05all=0;
	$n_0507=0;
	$n_07all=0;
	//18.05.2010

	
	//18.07.2011
	
	
	
	if(is_file($path_to_day_dir."\scint_index_05all.txt")){
			$f=file($path_to_day_dir."\scint_index_05all.txt");
				foreach($f as $line){
					$numbers=explode('|',$line);
				}
			@fclose($f);
	}else{
			$numbers=array('0','0','0','0','0','0');
			//echo "else \n";
	}
	
	if(is_file($path_to_day_dir."\scint_index_07all.txt")){
			$f=file($path_to_day_dir."\scint_index_07all.txt");
				foreach($f as $line){
					$numbers2=explode('|',$line);
				}
			@fclose($f);
	}else{
		$numbers2=array('0','0','0','0','0','0');
	}
	
	if(is_file($path_to_day_dir."\scint_index_0507.txt")){
			$f=file($path_to_day_dir."\scint_index_0507.txt");
				foreach($f as $line){
					$numbers1=explode('|',$line);
				}
			@fclose($f);
	}else{
		$numbers1=array('0','0','0','0','0','0');
	}
//number 0 to 100
//0.0961


for($i=0;$i<6;$i++){
		if( !( (float)$numbers[$i]>0.0001) )
			$numbers[$i]=0;
		if( !( (float)$numbers1[$i]>0.0001) )
			$numbers1[$i]=0;
		if( !( (float)$numbers2[$i]>0.0001) )
			$numbers2[$i]=0;
		
}

	if($z2>2) {
		$numbers_end=$numbers2;
		
	}elseif($z1>2){
				$numbers_end=$numbers1;
	}elseif($z>2){
					$numbers_end=$numbers;
	}else{
		
		$numbers_end=array('0','0','0','0','0','0');	
	}
	



				///file data for figure 
			if(strlen($file_no_dotDAT)>0)
			// %from time  scint_index_mean,mean_minus_this,mean_plus_this  %from spectra scint_index_mean,mean_minus_this,mean_plus_this
				fwrite($fw2, "".(float)$numbers_end['0']." ".(float)$numbers_end['1']." ".(float)$numbers_end['2']." ".(float)$numbers_end['3']." ".(float)$numbers_end['4']." ".(float)$numbers_end['5']." ".str_replace("-","",$file_no_dotDAT).$time_middle."\r\n");
		//18.05.2010			
		$date_ar=explode("-",$date);
		$date=$date_ar[0];
	

	@fclose($fw2);
		
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


/* генерирует основные рисунки */
function main_fig_gen($figures_path,$dir_name_source,$n_days,$path_to_source_core_dir){
	if(is_file(trim($figures_path))){
		$fw=fopen($path_to_source_core_dir."\\fig_".$dir_name_source.".M","w+");
		$f=file(trim($figures_path));
			foreach($f as $line){
				fwrite($fw,str_replace("%n_days%",$n_days,str_replace("%dat_yyy%",$dir_name_source,$line)));		
			}
	
		@fclose($fw);
	}
	
}
/* копирует нужные файлы в папку с днями */
function copy_need_files($path_where_copy,&$ini_array,$key){
	if(is_file(trim( $ini_array['periodograma_sub'][$key])) ){
			$periodograma_sub=trim( $ini_array['main']['WORK_ROOT']).'\\'.trim( $ini_array['periodograma_sub'][$key]);
	}elseif(is_file(trim( $ini_array['main']['periodograma_sub'])) ){
			$periodograma_sub=trim( $ini_array['main']['WORK_ROOT']).'\\'.trim( $ini_array['main']['periodograma_sub']);
	}
	if(! (is_dir($path_where_copy)) ){
		mkdir($path_where_copy);
	}
	if (!copy($periodograma_sub, $path_where_copy."\\periodograma_sub.M")) {
    	echo "failed to copy ".$periodograma_sub." to ".$path_where_copy."\n";
	}
}




function gen_dat($key,$ini_array){
	$i=parse_ini_file(trim($ini_array['main']['WORK_ROOT']).'\\'.trim($ini_array['ini_files'][$key]),true);
		$line='';

	foreach( $i as $key0=>$val){
		
		 
		foreach($i[$key0]['files'] as $key1=>$val1){
			$val10=explode(" ",$val1);
			foreach($val10 as $key100){
				if(strlen(trim($key100))>1){
				//if($key0=="3C175")
				//echo "key1: $key1 val1: ".$val1." key100: ".$key100."=".$key0."\n "; //: ".$i[$key0]['dots'][$key100]."\r\n";
					$line.=$key100."=".$key0.": ".$i[$key0]['dots'][$key100]."\r\n";
				}
			}
		}
	}
	file_openclose(trim($ini_array['main']['WORK_ROOT']).'\\'.trim($ini_array['files'][$key]),$line,"w+");
	
}
/* */
function gen_ini($file_path,$key,$ini_array){
	$temp=trim($ini_array['data_period'][$key]);
	$t=explode(" ",$temp);
	$start=strtotime(trim($t['0']." 00:00:00"));
	$stop=strtotime(trim($t['1']." 00:00:00"));
	$temp=explode(".",$start);
	
	$temp= ($stop - $start)/60/60/24;
	$n=round( abs ( $temp) )+1;


	$write_line=";automaticali generate at: ".date("Y.m.d H:m:s")."\r\n";
	$data_sources=trim($ini_array['data_sources_name'][$key]);
	if(strlen($data_sources)>1){
		$temp=explode(" ",$data_sources);
		$data_sources=$temp;
	}else{
		$data_sources[]='3C144';
	}

		$timestamp=$start;
		$file_string='';
		$dat_pregmatch="/\b.dat\b/i";


				
	if( is_file(trim($ini_array['main']['WORK_ROOT'])."\\".trim($ini_array['files'][$key]))){
		$data_now=file(trim($ini_array['main']['WORK_ROOT'])."\\".trim($ini_array['files'][$key]));
		$write_line='';
		$all_array='';
		file_openclose($file_path,";automaticali generate at: ".date("Y.m.d H:m:s")."\r\n","w+");
		foreach($data_now as $line1){
			if(trim(strlen($line1)>2)){
				$l=explode(":",$line1);
				$f=explode("=",$l['0']);
				$source=trim($f['1']);
				$all_array[$source][]=$line1;
				//echo "$source => $line1 \n";
			}
		}
		$file_string='';
		$write_line='';
		foreach($all_array as $key=>$val){
			
			$write_line.="[$key]\r\n";
			$write_line.=";dots[filename]=\"\" - точки для файла \r\n";
			$date_line='';
			$file_line='';
			$dots='';
			foreach($val as $key1=>$line){
				$l=explode(":",$line);
				$f=explode("=",$l['0']);
				$file_dat=trim($f['0']);
				$dot_file=$f['0'];
				$source=$key;
				
				$line2=explode(" ",trim($l['1']));
				
				$f='';
				foreach($line2 as $val){
					$line1=explode("kt",trim($val));
					
					$f.=" ".$line1['0'];
				}
				$line=trim($f);
				$file_string.=" $file_dat";
				$dots.="dots[".$file_dat."]=\"".$line."\"\r\n";
			}
		
				$timestamp=$start;
				for($i=0;$i<$n;$i++){
					$date_line.="date[]=".date("Y.m.d",$timestamp).""."\r\n";

					if($i==0){
						$file_line.="files[".date("Y.m.d",$timestamp)."]=\"".trim($file_string)."\"\r\n";
					}else{
						$file_line.="files[".date("Y.m.d",$timestamp)."]=\"\"\r\n";
					}
					
					$t=strtotime("+1 day" ,$timestamp);
					$timestamp=$t;
			
				}
				$write_line.=$date_line."\r\n".$file_line."\r\n ;file_not_calc[]=\"".$file_dat."\"  \r\n".$dots."\r\n";
		}
		
		file_openclose($file_path,$write_line,"a+");
		
	}else{	
		$temp=trim($ini_array['main']['WORK_ROOT'])."\\".trim($ini_array['path'][$key]);
		
		$dots=';dots[filename]="" - точки для файла'."\r\n";
		$file_not_calc='';
		if ($handle = opendir($temp)){
				while (false !== ($file = readdir($handle))) {
					if(  preg_match($dat_pregmatch,$file) ){
						$file_string.=$file." ";
						$dots.="dots[".$file."]=\"\"\r\n";
						$file_not_calc=";Те файлы которые не надо обрабатывать\r\n;file_not_calc[]=".$file."\r\n";
					}
				}
				$temp=trim($file_string);
				$file_string=$temp;
		}
		foreach($data_sources as $source){
			$write_line.="[".$source."]"."\r\n";
			$date_line='';
			$file_line='';
			$timestamp=$start;
				for($i=0;$i<$n;$i++){
					$date_line.="date[]=".date("Y.m.d",$timestamp).""."\r\n";

					if($i==0){
						$file_line.="files[".date("Y.m.d",$timestamp)."]=".$file_string."\r\n";
					}else{
						$file_line.="files[".date("Y.m.d",$timestamp)."]=\r\n";
					}
					
					$t=strtotime("+1 day" ,$timestamp);
					$timestamp=$t;
			
				}
			$write_line.=$date_line."\r\n".$file_line."\r\n".$file_not_calc."\r\n".$dots."\r\n";
			
	}
		file_openclose($file_path,$write_line,"w+");
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

?>