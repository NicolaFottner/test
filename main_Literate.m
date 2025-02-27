% Version 1.00
% Code provided by Ruslan Salakhutdinov and Geoff Hinton  
%
% Permission is granted for anyone to copy, use, modify, or distribute this
% program and accompanying programs and documents for any purpose, provided
% this copyright notice is retained and prominently displayed, along with
% a note saying that the original programs are available from our 
% web page. 
% The programs and documents are distributed without any warranty, express or
% implied.  As the programs were written for research purposes only, they have
% not been tested to the degree that would be advisable in any important
% application.  All use of these programs is entirely at the user's own risk.

% This program creates the so-called "Illiterate Network", 
% with 2 stacked-RBMS and an linear classifier in the top/output layer

%%%% INFO outputed files: // for each single "model simulation/run"
% ./g_rbm_2.mat & ./g_rbm_3.mat
% ./err_rbm_2.mat & ./err_rbm_3.mat
% Evals/ --- file with everything - from overfitting measure to CE assesm.

%%%%%%  RUN WITH:
% RBM2 --- SHAPE_POS3 && Letter POS 3
% Class --- LetterWithinStrings (3pos)
%       Assesment:
% LETTER_POS1
% newCE_data_(pos1)


% Code to run the transition from 
% illiterate to literate

% how to implement the 2 phases? -> actually just call
% old readouteval on inside this (litereate) main

% load Illiterate model/participant
addpath("saved_models/illiterate_models/");
sourceDir = 'saved_models/illiterate_models/';
loadData = dir([sourceDir '*.mat']);
literate = true; % for data plotting methods

for ii = 7 : size(loadData,1) % default being the "5 participants"
    for z=1:2 % loop to test on both LS-regrs and MLP
        load([loadData(ii).name],'hidbiases_2','properties','visbiases_2','vishid_2','W2');
        numhid = 1000;
        numhid2 = properties.numhid2;
        numhid3 = properties.numhid3;
        dropout = properties.dropout;
        batchsize = properties.minibatchsize;
        geo_shape_class = 12; % problem with 12 clases (..bad name)
        if z ==1 
            least_square = true;
        else
            least_square = false;
        end
        maxepoch=500; % 500
        if dropout
            p_layer1 = properties.dropout_p1;
            a1=(1-p_layer1)/p_layer1;a2=a1; %see fast dropout 2013 paper: a = (1-p) / p
            p_layer2 = NaN;
            if numhid3 ~= 0
                p_layer2 = 0.5;a3=a1;
            end 
        else
            p_layer1 = 1;
            p_layer2 = 1;
            a1 = 0;a2=0;a3=0;
        end
        no_N_img = false;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        fprintf(1,'\n\nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX\n\n');
        fprintf(1,'Number of Iterations: %d\n',ii);
        fprintf(1,'\n\nXXXXXXXX\n\n');
        addpath("testolin/")
        addpath("data_plotting/")
        addpath("data")
        addpath("data/new04Jl/")
        addpath("eval_methods/")
        
        %% Import Data from testolin
        fprintf(1,'Importing first layer from Testolin:\n');
        load t_model DN
        numdims = 1600;
        numbatches = 80000/160;
        numcases = DN.batchsize;
        
        fprintf(1,'Importing data: GeoShape + Letters \n');
        if batchsize == 12
            load g&L_batchdata_m12.mat
        elseif batchsize == 24
            load g&L_batchdata_m24.mat
        elseif batchsize == 36
            load g&L_batchdata_m36.mat
        end
        g_batchdata = batchdata;
        [g_numcases g_numdims g_numbatches]=size(g_batchdata);

        % create file to access info from eval functions
        save info maxepoch numdims numhid numhid2 numbatches numcases g_numbatches g_numcases
        %%% @todo use the above line in the "plotting methods" for modularity
        
        fprintf(1,'Start Training. \n'); 
        fprintf(1,'Number Epochs: %3i \n', maxepoch);

        %% RBM 1 / fetching it from Testolin
        %%%% first rbm layer
        vishid_1 = DN.L{1,1}.vishid;
        hidbiases_1 = DN.L{1,1}.hidbiases;
        visbiases_1 = DN.L{1,1}.visbiases;
        clear DN
        
        %% RBM 2
        %%%%% second rbm layer
        %%% INIT THE PARAMS FROM THE ILLITERATE MODEL
        
        %%% INCLUDE A VERSION WITH THE PARAMs, for comparison ("restart=1")
        

        fprintf(1,'\nTraining Layer 2 with RBM: %d-%d \n',numhid,numhid2);
        rbm2.maxepoch = maxepoch;
        rbm2.epsilonw      = 0.01;   % Learning rate for weights 
        rbm2.epsilonvb     = 0.01;   % Learning rate for biases of visible units 
        rbm2.epsilonhb     = 0.01;   % Learning rate for biases of hidden units 
        rbm2.weightcost  = 0.000004;   
        rbm2.initialmomentum  = 0.5;
        rbm2.finalmomentum    = 0.9;
        rbm2.earlyStopping = true;
        rbm2.patience = 3;
        rbm_2_lit;
        vishid_2=vishid; hidbiases_2=hidbiases; visbiases_2=visbiases; hid_out_2 = batchposhidprobs_2;
        save l_rbm_2 vishid_2 hidbiases_2 visbiases_2; % hid_out_2;
        
        %         load rbm2_16J11h39.mat vishid_2 hidbiases_2 visbiases_2;
        %         load rbm2_16J11h39_err.mat overfitting_g_2 full_rec_err_g
        %         addpath("Evals/");
        %         load 16Jun_11h39m_H2350_H30.mat properties;
        %         final_epoch = properties.epoch2;
        
        
        %% Classifer and performance measurements
        readOut_and_Eval_Literate;

        %%% save literate model, if z=1 -- LS, z=2 -- MLP
        dd = strsplit(date,'-'); clean_date = strcat(dd(1),dd(2));c=clock; %store date without "-YYYY"
        hour_str = int2str(c(4));
        min_str = int2str(c(5));
        if length(hour_str) == 1
            hour_str = ['0' hour_str(1)];
        end
        if length(min_str) == 1
            min_str = ['0' min_str(1)];
        end
        if least_square
            model_name = "saved_models/literate_models/" + clean_date + "_" + hour_str + "h" + min_str + "m_" + "lit_LS_n" + loadData(ii).name(1,21);
            save(model_name,'vishid_2','hidbiases_2', 'visbiases_2', 'W2','properties');
        else
            model_name = "saved_models/literate_models/" + clean_date + "_" + hour_str + "h" + min_str + "m_" + "lit_MLP_n" + loadData(ii).name(1,21);
            save(model_name,'vishid_2','hidbiases_2', 'visbiases_2', 'net','properties');
        end

        %% restart the run:
        clearvars -except z ii matrix_1 matrix_1_pd matrix_2 matrix_3...
                matrix_1_mlp matrix_1_pd_mlp matrix_2_mlp matrix_3_mlp literate loadData; 
        close all;
        save 

    end
end
dd = strsplit(date,'-'); clean_date = strcat(dd(1),dd(2));c=clock; %store date without "-YYYY"
hour_str = int2str(c(4));
min_str = int2str(c(5));
if length(hour_str) == 1
    hour_str = ['0' hour_str(1)];
end
if length(min_str) == 1
    min_str = ['0' min_str(1)];
end
filename = "saved_models/literate_models/tf_matrix/" + clean_date + "_" + hour_str + "h" + min_str+"m_" + "trialTF_LS";
save(filename,'matrix_1','matrix_1_pd','matrix_2','matrix_3');
% excel TF matrix
str_l = "lit_";
filename = "excel_files/" + str_l+  "ls_trialData_"+clean_date+hour_str+"h"+min_str+"m." + "xlsx";
writetable(matrix_1,filename,'WriteRowNames',true,'Sheet','Matrix_1')
writetable(matrix_1_pd,filename,'WriteRowNames',true,'Sheet','Matrix_1pd')
writetable(matrix_2,filename,'WriteRowNames',true,'Sheet','Matrix_2')
writetable(matrix_3,filename,'WriteRowNames',true,'Sheet','Matrix_3')

filename = "saved_models/literate_models/tf_matrix/" + clean_date + "_" + hour_str + "h" + min_str+"m_" + "trialTF_MLP";
save(filename,'matrix_1_mlp','matrix_1_pd_mlp','matrix_2_mlp','matrix_3_mlp');
% excel TF matrix
str_l = "lit_";
filename = "excel_files/" + str_l+  "mlp_trialData_"+clean_date+hour_str+"h"+min_str+"m." + "xlsx";
writetable(matrix_1_mlp,filename,'WriteRowNames',true,'Sheet','Matrix_1')
writetable(matrix_1_pd_mlp,filename,'WriteRowNames',true,'Sheet','Matrix_1pd')
writetable(matrix_2_mlp,filename,'WriteRowNames',true,'Sheet','Matrix_2')
writetable(matrix_3_mlp,filename,'WriteRowNames',true,'Sheet','Matrix_3_mlp')
