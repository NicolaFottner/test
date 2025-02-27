
function excel_TF_export(least_square, literate)
dd = strsplit(date,'-'); clean_date = strcat(dd(1),dd(2));c=clock; %store date without "-YYYY"
hour_str = int2str(c(4));min_str = int2str(c(5));

if literate
    str_l = "lit_";
else
    str_l = "illit_";
end
if least_square
    filename = "excel_files/" + str_l+  "trialData_"+clean_date+hour_str+"h"+min_str+"m." + "xlsx";
    writetable(matrix_1,filename,'WriteRowNames',true,'Sheet','Matrix_1')
    writetable(matrix_1_pd,filename,'WriteRowNames',true,'Sheet','Matrix_1pd')
    writetable(matrix_2,filename,'WriteRowNames',true,'Sheet','Matrix_2')
    writetable(matrix_3_inner,filename,'WriteRowNames',true,'Sheet','Matrix_3_inner')
    writetable(matrix_3_outer,filename,'WriteRowNames',true,'Sheet','Matrix_3_outer')
else
    filename = "excel_files/" + str_l+  "mlp_trialData_"+clean_date+hour_str+"h"+min_str+"m." + "xlsx";
    writetable(matrix_1_mlp,filename,'WriteRowNames',true,'Sheet','Matrix_1')
    writetable(matrix_1_pd_mlp,filename,'WriteRowNames',true,'Sheet','Matrix_1pd')
    writetable(matrix_2_mlp,filename,'WriteRowNames',true,'Sheet','Matrix_2')
    writetable(matrix_3_inner_mlp,filename,'WriteRowNames',true,'Sheet','Matrix_3_inner')
    writetable(matrix_3_outer_mlp,filename,'WriteRowNames',true,'Sheet','Matrix_3_outer')
end

end