%%%%%%%%%%%%%%%%%%%%%%%%%
% используется, для получения значения любого поля масива в виде массива
% берём результат запроса в базу данных
% result_config.id - это поле с id [PK]
% вызываем с помощью такого z = arrayfun(@(a)foreach_my_array(a.id), result_config)
% результат - z массив значений поля result_config.id
%%% 

function [ output_array ] = foreach_my_array( my_array)
         output_array=my_array;
end

