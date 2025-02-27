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
g_batchdata_f = [];g_batchtargets_f= [];
for i=1:size(g_batchtargets,3)  % I prefer to use a loop over "reshape" for now
    g_batchdata_f = [g_batchdata_f; g_batchdata(:,:,i)];
    g_batchtargets_f = [g_batchtargets_f; g_batchtargets(:,:,i)];
end
g_batchdata = g_batchdata_f;g_batchtargets = g_batchtargets_f;
hid_out_2 = 1./(1 + exp(-g_batchdata*vishid_2 - repmat(hidbiases_2,size(g_batchtargets,1),1)));
index =floor(size(g_batchtargets,1)*0.2); % 80% for train 20% for test of "g_test_data"
test_l =  g_batchtargets(1:index,:);
train_l = g_batchtargets(index+1 : size(hid_out_2,1) , :);
train_d_2 =hid_out_2(index+1 : size(hid_out_2,1) , :);
test_d_2= hid_out_2(1:index, :);
if numhid3~=0
    hid_out_3 = 1./(1 + exp(-hid_out_2*vishid_3 - repmat(hidbiases_3,size(g_batchtargets,1),1)));
    train_d_3 = hid_out_3(index+1 : size(hid_out_3,1) , :);
    test_d_3 = hid_out_3(1:index, :);
    fprintf(1,'\nTraining Layer 3 - Linear Classifier: %d-%d \n',numhid3,12);
end

%% Classifier Layer: Train and Test 
if numhid3 == 0
    fprintf(1,'\nTraining Layer 3 - Linear Classifier: %d-%d \n',numhid2,12);
    if dropout
        [W2, tr_acc2, te_acc2,tr_loss2,te_loss2] = t_perceptron_d(a2,train_d_2,train_l,test_d_2,test_l);
    else
        [W2, tr_acc2, te_acc2,tr_loss2,te_loss2] = t_perceptron(train_d_2,train_l,test_d_2,test_l);
    end
else 
    if dropout
        [Wmid, tr_acc2, te_acc2,tr_loss2,te_loss2] = t_perceptron_d(a2,train_d_2,train_l,test_d_2,test_l);
        [W2, tr_acc3, te_acc3,tr_loss3,te_loss3] = t_perceptron_d(a3,train_d_3,train_l,test_d_3,test_l);
    else
        [Wmid, tr_acc2, te_acc2,tr_loss2,te_loss2] = t_perceptron(train_d_2,train_l,test_d_2,test_l);
        % @todo change subsequent (assesment-)code using W2 as weights  ... 
        [W2, tr_acc3, te_acc3,tr_loss3,te_loss3] = t_perceptron(train_d_3,train_l,test_d_3,test_l);
    end
end

%%  Plot and Save performance measurements:
fprintf(1,'\n Linear Classifier of "rbm2 output" =\n');
fprintf(1,'\n Train accuracy =  %d\n',tr_acc2);
fprintf(1,'\n Test accuracy =  %d\n',te_acc2);
fprintf(1,'\n Train Loss =  %d\n',tr_loss2);
fprintf(1,'\n Test Loss =  %d\n',te_loss2);
if numhid3 ~= 0
    fprintf(1,'\n Linear Classifier of "rbm3 output" =\n');
    fprintf(1,'\n Train accuracy =  %d\n',tr_acc3);
    fprintf(1,'\n Test accuracy =  %d\n',te_acc3);
    fprintf(1,'\n Train Loss =  %d\n',tr_loss3);
    fprintf(1,'\n Test Loss =  %d\n',te_loss3);
end

if numhid3 == 0
    X = ["Final_layer";"Epochs"];
    tr_acc = [tr_acc2;NaN];
    te_acc = [te_acc2;NaN];
    tr_loss=[tr_loss2;NaN];
    te_loss = [te_loss2;NaN];
    Epoch = [NaN;final_epoch];
    Classifier = table(X,tr_acc,te_acc,tr_loss,te_loss,Epoch);
else   
    X = ["Final_layer";"From_RBM2";"Epochs"];
    tr_acc = [tr_acc3;tr_acc2NaN];
    te_acc = [te_acc3;te_acc2;NaN];
    tr_loss=[tr_loss3;tr_loss2;NaN];
    te_loss = [te_loss3;te_loss2;NaN];
    Epoch = [NaN;NaN;final_epoch];          
    Classifier = table(X,tr_acc,te_acc,tr_loss,te_loss,Epoch);
end
class_specific_output; %compute details of the output and saves them

%% Perform Assesment: Classifaction as Shape Id.

Letter_Assesment_noN_img;
pred_ce_effect_noN_img;
properties.dropout = dropout;
properties.dropout_p1 = p_layer1;
properties.dropout_cl = a1;
properties.minibatchsize = g_batchsize;
properties.epoch2 = final_epoch;
properties.epoch3 = 0;

if numhid3~= 0
    properties.epoch3 = final_epoch_3;
    properties.dropout_p2 = p_layer2;
end
properties.numhid2 = numhid2;
properties.numhid3 = numhid3;

histo;
if numhid3==0
    reco_error = full_rec_err_g;
    Overfitting = overfitting_g_2;
else
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
filename = "Evals/" + clean_date + "_" + hour_str + "h" + min_str+"m_" + "H2"+ int2str(numhid2)+ "_H3"+ int2str(numhid3);
save(filename,'properties','Classifier','Classifier_Details','Id_BasedOnGeoS','histograms', ...
    'CE_eval','Overfitting','reco_error');


%% Plot receptive fields
% create DN struct for facilitating later "plotting the receptive fields"
% for most fields, any number will do
if numhid3 == 0
    DN.layersize   = numhid2;           % network architecture
    DN.nlayers     = length(DN.layersize);
    DN.maxepochs   = 60;                    % unsupervised learning epochs
    DN.batchsize   = 160;                   % mini-batch size
    %set parameters of rbm 2 layer:
    DN.L{1}.hidbiases  = hidbiases_2;
    DN.L{1}.vishid     = vishid_2;
    DN.L{1}.visbiases  = visbiases_2;
else
    DN.layersize   = [numhid2 numhid3];           % network architecture
    DN.nlayers     = length(DN.layersize);
    DN.maxepochs   = 60;                    % unsupervised learning epochs
    DN.batchsize   = 160;                   % mini-batch size
    DN.L{1}.hidbiases  = hidbiases_2;
    DN.L{1}.vishid     = vishid_2;
    DN.L{1}.visbiases  = visbiases_2;
    %set parameters of rbm 3 layer:
    DN.L{2}.hidbiases  = hidbiases_3;
    DN.L{2}.vishid     = vishid_3;
    DN.L{2}.visbiases  = visbiases_3;
end

if ii == 1 && numhid3 == 0
    plot_L1(DN,numhid2);
elseif ii == 1 && numhid3 ~= 0
    plot_L2(DN,numhid3,final_epoch_3);
end
