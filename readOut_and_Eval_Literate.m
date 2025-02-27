% Code does the following
% 1. Compute supervised read-out with perceptron
%       a. Prepare geo-shape Data for perceptron
%       b. Traing and evaluation perceptron
% 2. Compute performance measures 
%       a. all the data from training and testing
%       b. 
%       b. Plotting of Receptive fields of rbm 1 and rbm2
%       b. call methods to make more measures:
%          overfitting, reco-error, histograms 

dd = strsplit(date,'-'); clean_date = strcat(dd(1),dd(2));c=clock; %store date without "-YYYY"

%% Create train and test set for perceptron:

addpath("data/new04Jl/")
load 50_50_TrainTestData
rbm1_pass_train = 1./(1 + exp(-trainData*vishid_1 - repmat(hidbiases_1,size(trainData,1),1)));
rbm1_pass_test = 1./(1 + exp(-testData*vishid_1 - repmat(hidbiases_1,size(testData,1),1)));
rbm2_pass_train = 1./(1 + exp(-rbm1_pass_train*vishid_2 - repmat(hidbiases_2,size(rbm1_pass_train,1),1)));
rbm2_pass_test = 1./(1 + exp(-rbm1_pass_test*vishid_2 - repmat(hidbiases_2,size(rbm1_pass_test,1),1)));
p = 0.2;
if least_square == true
    %% if classifier = multivariate least square regression
    p = 0.2;% train / test -- dataDivision
    [W1, tr_acc1, te_acc1,tr_loss1,te_loss1] = lit_t_perceptron(a1,rbm1_pass_train,train_t,rbm1_pass_test,test_t);
    [W2, tr_acc2, te_acc2,tr_loss2,te_loss2] = lit_t_perceptron(a2,rbm2_pass_train,train_t,rbm2_pass_test,test_t);
else
    %% íf MLP
    
    %%%
    units = 256; % number of units in hidden layer of MLP
    %%%

    % DataDivision for now:
    % as defineed in 50_50_TrainTestData
    % 80% training
    % 20% test
    %%%% BUT as defined MLP
    % 0.8*0.1 = 8% for validation
    %  ==> 72% for Training

    [net1, tr_acc1, tr_loss1, trainPerf1, valPerf1] = MLP(units,rbm1_pass_train,train_t);
    [net, tr_acc2, tr_loss2, trainPerf2, valPerf2] = MLP(units,rbm2_pass_train,train_t);
            
    %%% Eval MLPs on TestData
    testPred_1 = net1(rbm1_pass_test');
    softmax_pred = softmax(dlarray(testPred_1,'CB'));
    te_loss1 = extractdata(crossentropy(softmax_pred,test_t'));
    tind = vec2ind(test_t');
    yind = vec2ind(testPred_1);
    te_acc1 = 1 - sum(tind ~= yind)/numel(tind);

    testPred_2 = net(rbm2_pass_test');
    softmax_pred = softmax(dlarray(testPred_2,'CB'));
    te_loss2 = extractdata(crossentropy(softmax_pred,test_t'));
    tind = vec2ind(test_t');
    yind = vec2ind(testPred_2);
    te_acc2 = 1 - sum(tind ~= yind)/numel(tind);
end

%%  Plot and Save performance measurements:
fprintf(1,'\n Linear Classifier of "rbm1 output" = \n');
fprintf(1,'\n Train accuracy =  %d\n',tr_acc1);
fprintf(1,'\n Test accuracy =  %d\n',te_acc1);
fprintf(1,'\n Train Loss =  %d\n',tr_loss1);
fprintf(1,'\n Test Loss =  %d\n\n',te_loss1);
fprintf(1,'\n Linear Classifier of "rbm2 output" =\n');
fprintf(1,'\n Train accuracy =  %d\n',tr_acc2);
fprintf(1,'\n Test accuracy =  %d\n',te_acc2);
fprintf(1,'\n Train Loss =  %d\n',tr_loss2);
fprintf(1,'\n Test Loss =  %d\n',te_loss2);

if numhid3 == 0
    X = ["Final_layer";"From_RBM1";"Epochs"];
    tr_acc = [tr_acc2;tr_acc1;NaN];
    te_acc = [te_acc2;te_acc1;NaN];
    tr_loss=[tr_loss2;tr_loss1;NaN];
    te_loss = [te_loss2;te_loss1;NaN];
    Epoch = [NaN;NaN;final_epoch];
    Classifier = table(X,tr_acc,te_acc,tr_loss,te_loss,Epoch);
else   
    fprintf(1,'\n Linear Classifier of "rbm3 output" =\n');
    fprintf(1,'\n Train accuracy =  %d\n',tr_acc3);
    fprintf(1,'\n Test accuracy =  %d\n',te_acc3);
    fprintf(1,'\n Train Loss =  %d\n',tr_loss3);
    fprintf(1,'\n Test Loss =  %d\n',te_loss3);
    X = ["Final_layer";"From_RBM2";"From_RBM1";"Epochs"];
    tr_acc = [tr_acc3;tr_acc2;tr_acc1;NaN];
    te_acc = [te_acc3;te_acc2;te_acc1;NaN];
    tr_loss=[tr_loss3;tr_loss2;tr_loss1;NaN];
    te_loss = [te_loss3;te_loss2;te_loss1;NaN];
    Epoch = [NaN;NaN;NaN;final_epoch];          
    Classifier = table(X,tr_acc,te_acc,tr_loss,te_loss,Epoch);
end

%% Perform Assesment: Classifier Details & Classifaction as Shape Id.
% this is needed for the following funciton, "making it all easier"
hid_out_2 = rbm2_pass_test;
g_batchtargets = test_t;
if least_square
    class_specific_output; %compute details of the output and saves them
    Letter_Assesment;
    Letter_3posAssesment;
    % to get all the matrix data for the stat analysis
    ii=1;
    lit_pred_ce_effect;
    lit_pred_ce_effect_ALL;
    ii=7;
else
    ii=1;
    class_specific_output_MLP;
    Letter_Assesment_MLP;
    Letter_3posAssesment;
    lit_pred_ce_effect_MLP;
    lit_pred_ce_effect_ALL_MLP;
    ii=7;
end

properties.dropout = dropout;
properties.dropout_p1 = p_layer1;
properties.dropout_cl = a1;
properties.minibatchsize = batchsize;
properties.epoch2 = final_epoch;

properties.numhid2 = numhid2;
properties.numhid3 = numhid3;

histo;
if numhid3 == 0
    reco_error = full_rec_err_g;
    Overfitting = overfitting_g_2;
else
    properties.epoch3 = final_epoch_3;
    properties.dropout_p2 = p_layer2;
    Overfitting.layer2 = overfitting_g_2;
    Overfitting.layer3 = overfitting_g_3; 
    reco_error.layer2 = full_rec_err_g;
    reco_error.layer3 = full_rec_err_3;
end
% save data into single file:
% /clock string to better scan the eval files
hour_str = int2str(c(4));
min_str = int2str(c(5));
if length(hour_str) == 1
    hour_str = ['0' hour_str(1)];
end
if length(min_str) == 1
    min_str = ['0' min_str(1)];
end
%%% save file
if least_square
    filename = "Evals/" + clean_date + "_" + hour_str + "h" + min_str+"m_" + "H2"+ int2str(numhid2)+ "_LS";
    save(filename,'properties','Classifier','Classifier_Details','Id_BasedOnGeoS','histograms', ...
        'CE_eval','Overfitting','reco_error');
else
    filename = "Evals/" + clean_date + "_" + hour_str + "h" + min_str+"m_" + "H2"+ int2str(numhid2)+ "_MLP";
    save(filename,'properties','Classifier','Classifier_Details','Id_BasedOnGeoS','histograms', ...
        'CE_eval','Overfitting','reco_error');
end

%% Plot receptive fields
% create DN struct for facilitating later "plotting the receptive fields"
% for most fields, any number will do
if numhid3 == 0
    DN.layersize   = [1000 numhid2];           % network architecture
    DN.nlayers     = length(DN.layersize);
    DN.maxepochs   = 60;                    % unsupervised learning epochs
    DN.batchsize   = 160;                   % mini-batch size
    %set parameters of rbm 1 layer:
    DN.L{1}.hidbiases  = hidbiases_1;
    DN.L{1}.vishid     = vishid_1;
    DN.L{1}.visbiases  = visbiases_1;
    %set parameters of rbm 2 layer:
    DN.L{2}.hidbiases  = hidbiases_2;
    DN.L{2}.vishid     = vishid_2;
    DN.L{2}.visbiases  = visbiases_2;
else
    DN.layersize   = [1000 numhid2 numhid3];           % network architecture
    DN.nlayers     = length(DN.layersize);
    DN.maxepochs   = 60;                    % unsupervised learning epochs
    DN.batchsize   = 160;                   % mini-batch size
    %set parameters of rbm 1 layer:
    DN.L{1}.hidbiases  = hidbiases_1;
    DN.L{1}.vishid     = vishid_1;
    DN.L{1}.visbiases  = visbiases_1;
    %set parameters of rbm 2 layer:
    DN.L{2}.hidbiases  = hidbiases_2;
    DN.L{2}.vishid     = vishid_2;
    DN.L{2}.visbiases  = visbiases_2;
    %set parameters of rbm 3 layer:
    DN.L{3}.hidbiases  = hidbiases_3;
    DN.L{3}.vishid     = vishid_3;
    DN.L{3}.visbiases  = visbiases_3;
end

%plot_L1(DN,1000);

 
if ii == 1 && numhid3 == 0
    plot_L2(DN,numhid2,final_epoch);
elseif ii == 1 && numhid3 ~= 0
    plot_L2(DN,numhid2,final_epoch);
    plot_L3(DN,numhid3,final_epoch_3);
end
