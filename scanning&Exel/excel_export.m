%% export to excel spreadsheets
addpath("Evals/mean/")

%% test error
C  = {};
sourceDir =  'Evals/mean/';
x =repmat("XXX",[8 1]);
% add legends to C
param = "Parameters";
strg = "Test Error";
legend_strg = [param;strg;"Epoch2";"Epoch3";param;strg;"Epoch2";"Epoch3"];
C(:,end+1) = cellstr(legend_strg);

for i=1:6
    sourceDir = [sourceDir int2str(i) '/'];
    loadData = dir([sourceDir '*.mat']);
    te_err=[];
    load(convertCharsToStrings(sourceDir) + convertCharsToStrings(loadData(1).name),"mean_properties");
    ss = "D" + int2str(mean_properties.dropout)+ "_M" +int2str(mean_properties.minibatch) + ...
        "_h"+int2str(mean_properties.numhid2)+"-"+int2str(mean_properties.numhid3);
    te_err = [te_err;ss];
    te_err = [te_err;num2str(mean_properties.test_error)];
    te_err = [te_err;num2str(mean_properties.epoch2)];
    te_err = [te_err;num2str(mean_properties.epoch3)];
    load(convertCharsToStrings(sourceDir) + convertCharsToStrings(loadData(2).name),"mean_properties");
    ss = "D" + int2str(mean_properties.dropout)+ "_M" +int2str(mean_properties.minibatch) + ...
        "_h"+int2str(mean_properties.numhid2)+"-"+int2str(mean_properties.numhid3);
    te_err = [te_err;ss];
    te_err = [te_err;num2str(mean_properties.test_error)];
    te_err = [te_err;num2str(mean_properties.epoch2)];
    te_err = [te_err;num2str(mean_properties.epoch3)];
    C(:,end+1) = cellstr(te_err);
    
    te_err=[];
    load(convertCharsToStrings(sourceDir) + convertCharsToStrings(loadData(3).name),"mean_properties");
    ss = "D" + int2str(mean_properties.dropout)+ "_M" +int2str(mean_properties.minibatch) + ...
        "_h"+int2str(mean_properties.numhid2)+"-"+int2str(mean_properties.numhid3);
    te_err = [te_err;ss];
    te_err = [te_err;num2str(mean_properties.test_error)];
    te_err = [te_err;num2str(mean_properties.epoch2)];
    te_err = [te_err;num2str(mean_properties.epoch3)];
    
    load(convertCharsToStrings(sourceDir) + convertCharsToStrings(loadData(4).name),"mean_properties");
    ss = "D" + int2str(mean_properties.dropout)+ "_M" +int2str(mean_properties.minibatch) + ...
        "_h"+int2str(mean_properties.numhid2)+"-"+int2str(mean_properties.numhid3);
    te_err = [te_err;ss];
    te_err = [te_err;num2str(mean_properties.test_error)];
    te_err = [te_err;num2str(mean_properties.epoch2)];
    te_err = [te_err;num2str(mean_properties.epoch3)];
    C(:,end+1) = cellstr(te_err);
    C(:,end+1) = cellstr(x);
    sourceDir ='Evals/mean/';
end
Test_Error = C;


%% Classifier Details
C  = {};
sourceDir =  'Evals/mean/';
x =repmat("XXX",[16 1]);
x_m ="XXXXXXXXXX";
% add legends to C
param = "Parameters";
legend_strg = [param;"1/Cross";"2/Elipse";"3/Hexagon";"4/Rectangle";"5/Square";"6/Triangle";...
    "----";"----";param;"1/Cross";"2/Elipse";"3/Hexagon";"4/Rectangle";"5/Square";"6/Triangle";];
C(:,end+1) = cellstr(legend_strg);

for i=1:6
    sourceDir = [sourceDir int2str(i) '/'];
    loadData = dir([sourceDir '*.mat']);
    te_err=[];
    load(convertCharsToStrings(sourceDir) + convertCharsToStrings(loadData(1).name),"Classifier_Details","mean_properties");
    ss = "D" + int2str(mean_properties.dropout)+ "_M" +int2str(mean_properties.minibatch) + ...
        "_h"+int2str(mean_properties.numhid2)+"-"+int2str(mean_properties.numhid3);
    te_err = [te_err;ss];
    te_err = [te_err;num2str(Classifier_Details.Accuracy)];
    te_err = [te_err;x_m];
    te_err = [te_err;x_m];
    load(convertCharsToStrings(sourceDir) + convertCharsToStrings(loadData(2).name),"Classifier_Details","mean_properties");
    ss = "D" + int2str(mean_properties.dropout)+ "_M" +int2str(mean_properties.minibatch) + ...
        "_h"+int2str(mean_properties.numhid2)+"-"+int2str(mean_properties.numhid3);
    te_err = [te_err;ss];
    te_err = [te_err;num2str(Classifier_Details.Accuracy)];
    C(:,end+1) = cellstr(te_err);
    
    te_err=[];
    load(convertCharsToStrings(sourceDir) + convertCharsToStrings(loadData(3).name),"Classifier_Details","mean_properties");
    ss = "D" + int2str(mean_properties.dropout)+ "_M" +int2str(mean_properties.minibatch) + ...
        "_h"+int2str(mean_properties.numhid2)+"-"+int2str(mean_properties.numhid3);
    te_err = [te_err;ss];
    te_err = [te_err;num2str(Classifier_Details.Accuracy)];
    te_err = [te_err;x_m];
    te_err = [te_err;x_m];
    load(convertCharsToStrings(sourceDir) + convertCharsToStrings(loadData(4).name),"Classifier_Details","mean_properties");
    ss = "D" + int2str(mean_properties.dropout)+ "_M" +int2str(mean_properties.minibatch) + ...
        "_h"+int2str(mean_properties.numhid2)+"-"+int2str(mean_properties.numhid3);
    te_err = [te_err;ss];
    te_err = [te_err;num2str(Classifier_Details.Accuracy)];
    C(:,end+1) = cellstr(te_err);
    C(:,end+1) = cellstr(x);
    sourceDir ='Evals/mean/';
end
Classifier_details = C;

%% Id Based on Shape
C  = {};
sourceDir =  'Evals/mean/';
x =repmat("XXX",[8 1]);
% add legends to C
param = "Parameters";
legend_strg = [param;"Geoshape";"Letters";"Ps-Letters";param;"Geoshape";"Letters";"Ps-Letters"];
C(:,end+1) = cellstr(legend_strg);

for i=1:6
    sourceDir = [sourceDir int2str(i) '/'];
    loadData = dir([sourceDir '*.mat']);
    te_err=[];
    load(convertCharsToStrings(sourceDir) + convertCharsToStrings(loadData(1).name),"Id_BasedonS","mean_properties");
    ss = "D" + int2str(mean_properties.dropout)+ "_M" +int2str(mean_properties.minibatch) + ...
        "_h"+int2str(mean_properties.numhid2)+"-"+int2str(mean_properties.numhid3);
    te_err = [te_err;ss];
    id_gAcc = Id_BasedonS.Accuracy;
    id_gAcc(1) =  1 - mean_properties.test_error;
    te_err = [te_err;num2str(id_gAcc)];
    load(convertCharsToStrings(sourceDir) + convertCharsToStrings(loadData(2).name),"Id_BasedonS","mean_properties");
    ss = "D" + int2str(mean_properties.dropout)+ "_M" +int2str(mean_properties.minibatch) + ...
        "_h"+int2str(mean_properties.numhid2)+"-"+int2str(mean_properties.numhid3);
    te_err = [te_err;ss];
    id_gAcc = Id_BasedonS.Accuracy;
    id_gAcc(1) =  1 - mean_properties.test_error;
    te_err = [te_err;num2str(id_gAcc)];
    C(:,end+1) = cellstr(te_err);
    
    te_err=[];
    load(convertCharsToStrings(sourceDir) + convertCharsToStrings(loadData(3).name),"Id_BasedonS","mean_properties");
    ss = "D" + int2str(mean_properties.dropout)+ "_M" +int2str(mean_properties.minibatch) + ...
        "_h"+int2str(mean_properties.numhid2)+"-"+int2str(mean_properties.numhid3);
    te_err = [te_err;ss];
    id_gAcc = Id_BasedonS.Accuracy;
    id_gAcc(1) =  1 - mean_properties.test_error;
    te_err = [te_err;num2str(id_gAcc)];
    
    load(convertCharsToStrings(sourceDir) + convertCharsToStrings(loadData(4).name),"Id_BasedonS","mean_properties");
    ss = "D" + int2str(mean_properties.dropout)+ "_M" +int2str(mean_properties.minibatch) + ...
        "_h"+int2str(mean_properties.numhid2)+"-"+int2str(mean_properties.numhid3);
    te_err = [te_err;ss];
    id_gAcc = Id_BasedonS.Accuracy;
    id_gAcc(1) =  1 - mean_properties.test_error;
    te_err = [te_err;num2str(id_gAcc)];
    C(:,end+1) = cellstr(te_err);
    C(:,end+1) = cellstr(x);
    sourceDir ='Evals/mean/';
end
Id_BasedOnShape = C;

%% Id Based on Shape --- Details
C  = {};
sourceDir =  'Evals/mean/';
x =repmat("XXX",[20 1]);
%add legends to C
param = "Parameters";
legend_strg = [param;"Target";"(p)/A" ; "(p)/H"; "(p)/M";"(p)/U"; "(p)/T";"(p)/X";
"-----";"-----";param;"Target";"(p)/A" ; "(p)/H"; "(p)/M";"(p)/U"; "(p)/T";"(p)/X";"-----";"-----"];
C(:,end+1) = cellstr(legend_strg);

for i=1:6
    sourceDir = [sourceDir int2str(i) '/'];
    loadData = dir([sourceDir '*.mat']);
    te_err=[]; % for letters
    te_err1 = []; % for p-letters
    load(convertCharsToStrings(sourceDir) + convertCharsToStrings(loadData(1).name),"Id_BasedonS_details","mean_properties");
    ss = "D" + int2str(mean_properties.dropout)+ "_M" +int2str(mean_properties.minibatch) + ...
        "_h"+int2str(mean_properties.numhid2)+"-"+int2str(mean_properties.numhid3);
    te_err = [te_err;ss];
    % for letters
    te_err = [te_err;"letter"];
    te_err = [te_err;num2str(Id_BasedonS_details.letter_Acc)];
    te_err = [te_err;x_m];te_err = [te_err;x_m];
    %for p-letters
    te_err1 = [te_err1;"XXXXXX"];
    te_err1 = [te_err1;"p-letter"];
    te_err1 = [te_err1;num2str(Id_BasedonS_details.pletter_Acc)];
    te_err1 = [te_err1;x_m];te_err1 = [te_err1;x_m];
    
    load(convertCharsToStrings(sourceDir) + convertCharsToStrings(loadData(2).name),"Id_BasedonS_details","mean_properties");
    ss = "D" + int2str(mean_properties.dropout)+ "_M" +int2str(mean_properties.minibatch) + ...
        "_h"+int2str(mean_properties.numhid2)+"-"+int2str(mean_properties.numhid3);
    te_err = [te_err;ss];
    % for letters
    te_err = [te_err;"letter"];
    te_err = [te_err;num2str(Id_BasedonS_details.letter_Acc)];
    te_err = [te_err;x_m];te_err = [te_err;x_m];
    %for p-letters
    te_err1 = [te_err1;"XXXXXX"];
    te_err1 = [te_err1;"p-letter"];
    te_err1 = [te_err1;num2str(Id_BasedonS_details.pletter_Acc)];
    te_err1 = [te_err1;x_m];te_err1 = [te_err1;x_m];

    C(:,end+1) = cellstr(te_err);
    C(:,end+1) = cellstr(te_err1);
    C(:,end+1) = cellstr(x);

    % changing the Dropout boolean case
        
    te_err=[];
    te_err1 = [];
    load(convertCharsToStrings(sourceDir) + convertCharsToStrings(loadData(3).name),"Id_BasedonS_details","mean_properties");
    ss = "D" + int2str(mean_properties.dropout)+ "_M" +int2str(mean_properties.minibatch) + ...
        "_h"+int2str(mean_properties.numhid2)+"-"+int2str(mean_properties.numhid3);
    te_err = [te_err;ss];
    % for letters
    te_err = [te_err;"letter"];
    te_err = [te_err;num2str(Id_BasedonS_details.letter_Acc)];
    te_err = [te_err;x_m];te_err = [te_err;x_m];
    %for p-letters
    te_err1 = [te_err1;"-----"];
    te_err1 = [te_err1;"p-letter"];
    te_err1 = [te_err1;num2str(Id_BasedonS_details.pletter_Acc)];
    te_err1 = [te_err1;x_m];te_err1 = [te_err1;x_m];

    load(convertCharsToStrings(sourceDir) + convertCharsToStrings(loadData(4).name),"Id_BasedonS_details","mean_properties");
    ss = "D" + int2str(mean_properties.dropout)+ "_M" +int2str(mean_properties.minibatch) + ...
        "_h"+int2str(mean_properties.numhid2)+"-"+int2str(mean_properties.numhid3);
    te_err = [te_err;ss];
    % for letters
    te_err = [te_err;"letter"];
    te_err = [te_err;num2str(Id_BasedonS_details.letter_Acc)];
    te_err = [te_err;x_m];te_err = [te_err;x_m];
    %for p-letters
    te_err1 = [te_err1;"-----"];
    te_err1 = [te_err1;"p-letter"];
    te_err1 = [te_err1;num2str(Id_BasedonS_details.pletter_Acc)];
    te_err1 = [te_err1;x_m];te_err1 = [te_err1;x_m];
    C(:,end+1) = cellstr(te_err);
    C(:,end+1) = cellstr(te_err1);
    C(:,end+1) = cellstr(x);
    sourceDir ='Evals/mean/';
end
Id_BasedonS_Details =C;

%% writeOut
filename = "excel_files/08J_sim5.xlsx";
writecell(Test_Error,filename,'Sheet','Test_Error');
writecell(Classifier_details,filename,'Sheet','Classifier_details');
writecell(Id_BasedOnShape,filename,'Sheet','Id_BasedOnShape');
writecell(Id_BasedonS_Details,filename,'Sheet','Id_BasedonS_Details');


%% old export -- with write tabel:

% for i=1:size(filenames,1)
%     s = loadData(i).name;
%     f = strcat(convertCharsToStrings(sourceDir) + convertCharsToStrings(s));
%     s(size(s,2)) = [];s(size(s,2)) = [];s(size(s,2)) = [];
%     filenames(i) = "excel_files/" +  s + "xlsx";
%     load(f);
%     writetable(Classifier_Details,filenames(i),'WriteRowNames',true,'Sheet','Classifier_DetailedOutput')
%     writetable(Id_BasedonS,filenames(i),'WriteRowNames',true,'Sheet','ShapeId_Output')
%     writetable(Id_BasedonS_details,filenames(i),'WriteRowNames',true,'Sheet','ShapeId_DetailedOutput')
%     writetable(Id_BasedonS_PDFs,filenames(i),'WriteRowNames',true,'WriteVariableNames',false,'Sheet','ShapeId_PDFs')
%     writetable(struct2table(mean_properties),filenames(i),'WriteRowNames',true,'WriteVariableNames',false,'Sheet','Properties')
% end



