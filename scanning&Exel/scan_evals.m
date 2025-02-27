function [] = scan_evals(sourceDir)

%%% with sourceDir == cell
num_sim = 3; % num of max sim 
list_sourceDir = strings(num_sim,length(sourceDir{1,1}));
for i=1:size(sourceDir,1)
    elem = sourceDir(1);
    elem = elem{1};
    list_sourceDir(i) = convertCharsToStrings(elem);
end
sourceDir = list_sourceDir;

%%%% Classifier
te_acc = [];
%%%% ClassifierDetails
acc1 = [];acc2 = [];acc3 = [];
acc4 = [];acc5 = [];acc6 = [];
%%%% Id__BasedOnGeoS
acc_shape =[];acc_letter = [];acc_pletter = [];
mode_l=zeros(size(sourceDir,1),6);mode_pl=zeros(size(sourceDir,1),6);
accId_l =zeros(size(sourceDir,1),6);accId_pl =zeros(size(sourceDir,1),6);
l_pdf_a = [];l_pdf_h = [];l_pdf_m = [];l_pdf_u = [];l_pdf_t = [];l_pdf_x = [];     
pl_pdf_a = [];pl_pdf_h = [];pl_pdf_m = [];pl_pdf_u = [];pl_pdf_t = [];pl_pdf_x = [];     
%%%% Properties
f_epoch2 = [];f_epoch3 = [];
for i=1:size(sourceDir,1)
    load([sourceDir(i)],"Classifier","Classifier_Details", ...
        "Id_BasedOnGeoS","properties");
    %%% Classifier
    te_acc = [te_acc;Classifier.te_acc(1)];
    %%% ClassifierDetails
    acc = Classifier_Details.Accuracy;
    acc1 = [acc1;acc(1)];acc2 = [acc1;acc(2)];
    acc3 = [acc1;acc(3)];acc4 = [acc1;acc(4)];
    acc5 = [acc1;acc(5)];acc6 = [acc1;acc(6)];
    %%% Id_BasedOnGeoS
    acc_shape = [acc_shape;Id_BasedOnGeoS.accuracy_s];
    acc_letter = [acc_letter;Id_BasedOnGeoS.accuracy_l];
    acc_pletter= [acc_pletter;Id_BasedOnGeoS.accuracy_pl];
    accId_l(i,:) = Id_BasedOnGeoS.table_letter.Acc;
    accId_pl(i,:) = Id_BasedOnGeoS.table_pletter.Acc;
    mode_l(i,:) = Id_BasedOnGeoS.table_letter.Mode;
    mode_pl(i,:)=Id_BasedOnGeoS.table_pletter.pMode;
    l_pdf_a = [l_pdf_a;Id_BasedOnGeoS.letter_pdr(1,:)];
    l_pdf_h = [l_pdf_h;Id_BasedOnGeoS.letter_pdr(2,:)];
    l_pdf_m = [l_pdf_m;Id_BasedOnGeoS.letter_pdr(3,:)];
    l_pdf_u = [l_pdf_u;Id_BasedOnGeoS.letter_pdr(4,:)];
    l_pdf_t = [l_pdf_t;Id_BasedOnGeoS.letter_pdr(5,:)];
    l_pdf_x = [l_pdf_x;Id_BasedOnGeoS.letter_pdr(6,:)];
    pl_pdf_a = [pl_pdf_a;Id_BasedOnGeoS.pletter_pdr(1,:)];
    pl_pdf_h = [pl_pdf_h;Id_BasedOnGeoS.pletter_pdr(2,:)];
    pl_pdf_m = [pl_pdf_m;Id_BasedOnGeoS.pletter_pdr(3,:)];
    pl_pdf_u = [pl_pdf_u;Id_BasedOnGeoS.pletter_pdr(4,:)];
    pl_pdf_t = [pl_pdf_t;Id_BasedOnGeoS.pletter_pdr(5,:)];
    pl_pdf_x = [pl_pdf_x;Id_BasedOnGeoS.pletter_pdr(6,:)];   
    f_epoch2 = [f_epoch2;properties.epoch2]; 
    if properties.numhid3 ~= 0
        f_epoch3 = [f_epoch3;properties.epoch3];
    end
    numhid2 = properties.numhid2;
    numhid3 = properties.numhid3;
    d_dropout = properties.dropout;
    d_minibatch = properties.minibatchsize;
end
% classifier
test_err = 1- mean(te_acc);
% class_details
acc1 = mean(acc1);
acc2 = mean(acc2);
acc3 = mean(acc3);
acc4 = mean(acc4);
acc5 = mean(acc5);
acc6 = mean(acc6);
% id_b
mean_acc_s  = mean(acc_shape);mean_acc_l  = mean(acc_letter);mean_acc_pl  = mean(acc_pletter);
modes_of_mode_L = mode(mode_l);modes_of_mode_pL = mode(mode_pl);
letter_Acc = mean(accId_l,1)';pletter_Acc = mean(accId_pl,1)';
mean_l_pdf_a = mean(l_pdf_a,1);mean_l_pdf_h = mean(l_pdf_h,1);
mean_l_pdf_m = mean(l_pdf_m,1);mean_l_pdf_u = mean(l_pdf_u,1);
mean_l_pdf_t = mean(l_pdf_t,1);mean_l_pdf_x = mean(l_pdf_x,1);
mean_pl_pdf_a = mean(pl_pdf_a,1);mean_pl_pdf_h = mean(pl_pdf_h,1);
mean_pl_pdf_m = mean(pl_pdf_m,1);mean_pl_pdf_u = mean(pl_pdf_u,1);
mean_pl_pdf_t = mean(pl_pdf_t,1);mean_pl_pdf_x = mean(pl_pdf_x,1);
% properties
epoch2 = mean(f_epoch2);
epoch3 = mean(f_epoch3);


Output = ["1";"2";"3";"4";"5";"6"];
Accuracy = [acc1;acc2;acc3;acc4;acc5;acc6];
Classifier_Details = table(Output,Accuracy);

mean_properties.epoch2 = epoch2;
mean_properties.epoch3 = epoch3;
mean_properties.test_error = test_err;
mean_properties.runs = size(sourceDir,1);
mean_properties.numhid2 = numhid2;
mean_properties.numhid3 = numhid3;
mean_properties.dropout = d_dropout;
mean_properties.minibatch = d_minibatch;

Targets = ["GeoShape";"Letter";"PLetter"];
Accuracy = [mean_acc_s;mean_acc_l;mean_acc_pl];
Modes = [[1,2,3,4,5,6];modes_of_mode_L;modes_of_mode_pL];
lTargets = ["(p/)A" ; "(p/)H"; "(p/)M"; "(p/)U"; "(p/)T"; "(p/)X"];
Modes_L=modes_of_mode_L';Modes_pL=modes_of_mode_pL';
pdf_Targets = ["A" ; "H"; "M"; "U"; "T"; "X";"pA" ; "pH"; "pM"; "pU"; "pT"; "pX"];
Models_Output_PDF = [mean_l_pdf_a;mean_l_pdf_h;mean_l_pdf_m;mean_l_pdf_u;mean_l_pdf_t;mean_l_pdf_x; ...
    mean_pl_pdf_a;mean_pl_pdf_h;mean_pl_pdf_m;mean_pl_pdf_u;mean_pl_pdf_t;mean_pl_pdf_x];

Id_BasedonS = table(Targets,Accuracy,Modes);
Id_BasedonS_details = table(lTargets,letter_Acc,pletter_Acc,Modes_L,Modes_pL);
Id_BasedonS_PDFs = table(pdf_Targets,Models_Output_PDF);
if d_dropout
    d = "dT_";
else
    d = "dF_";
end
m = "m" + int2str(d_minibatch);
filename = "Evals/mean/mean_n" + int2str(size(sourceDir,1)) +"_"+ int2str(numhid2) +"_"+ int2str(numhid3) + d + m;
save(filename,'mean_properties','Classifier_Details','Id_BasedonS','Id_BasedonS_details','Id_BasedonS_PDFs');

end