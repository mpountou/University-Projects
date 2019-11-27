function  output_args = filtermaster( input_args )
if input_args == 0 
    output_args = [];
elseif input_args == 1 
    output_args = 2;
elseif input_args == 2
    output_args = [3,2];
elseif input_args == 3
   output_args = [4,5,2];
elseif input_args == 4
   output_args = [8,24,32,16];
end
end

