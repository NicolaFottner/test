%% concatenate shape and letter-in-string data:

%%% Percentage of shape data?, for equal part: perc = 1
perc = 1;
%%%

load open_CV_trainData12_dbl.mat data target_l target_pos
xdata = data;

load openCV_shapePOS3.mat data target_s
perc = perc * size(xdata,1) / size(data,1);

shapedata = zeros(size(data));
for i=1:size(data,1)
    shapedata(i,:) = reshape(im2double(reshape(data(i,:),[40 40 1])), [1 1600]);
end
data = shapedata;
target_s = double(target_s);

% proportion for test set
div_prop = 0.2;

%% SHAPE
% take equal amount of each shape:
class1_data = [];class2_data = [];class3_data = [];
class4_data = [];class5_data = [];class6_data = [];
for i=1:size(data,1)
    if find(target_s(i,:)) == 1
        class1_data = [class1_data;data(i,:)];
    end
    if find(target_s(i,:)) == 2
        class2_data = [class2_data;data(i,:)];
    end
    if find(target_s(i,:)) == 3
        class3_data = [class3_data;data(i,:)];
    end
    if find(target_s(i,:)) == 4
        class4_data = [class4_data;data(i,:)];
    end
    if find(target_s(i,:)) == 5
        class5_data = [class5_data;data(i,:)];
    end
    if find(target_s(i,:)) == 6
        class6_data = [class6_data;data(i,:)];
    end
end

minus = size(class1_data,1) - perc * size(class1_data,1);
class1_data(1:minus,:)=[];
class2_data(1:minus,:)=[];
class3_data(1:minus,:)=[];
class4_data(1:minus,:)=[];
class5_data(1:minus,:)=[];
class6_data(1:minus,:)=[];

% train targets
%%% 'ind2vec' would be cleaner here
targets1 = repmat([0 0 0 0 0 0 1 0 0 0 0 0],size(class1_data,1)*(1-div_prop),1);
targets2 = repmat([0 0 0 0 0 0 0 1 0 0 0 0],size(class1_data,1)*(1-div_prop),1);
targets3 = repmat([0 0 0 0 0 0 0 0 1 0 0 0],size(class1_data,1)*(1-div_prop),1);
targets4 = repmat([0 0 0 0 0 0 0 0 0 1 0 0],size(class1_data,1)*(1-div_prop),1);
targets5 = repmat([0 0 0 0 0 0 0 0 0 0 1 0],size(class1_data,1)*(1-div_prop),1);
targets6 = repmat([0 0 0 0 0 0 0 0 0 0 0 1],size(class1_data,1)*(1-div_prop),1);
% test targets
targets1l = repmat([0 0 0 0 0 0 1 0 0 0 0 0],size(class1_data,1)*(div_prop),1);
targets2l = repmat([0 0 0 0 0 0 0 1 0 0 0 0],size(class1_data,1)*(div_prop),1);
targets3l = repmat([0 0 0 0 0 0 0 0 1 0 0 0],size(class1_data,1)*(div_prop),1);
targets4l = repmat([0 0 0 0 0 0 0 0 0 1 0 0],size(class1_data,1)*(div_prop),1);
targets5l = repmat([0 0 0 0 0 0 0 0 0 0 1 0],size(class1_data,1)*(div_prop),1);
targets6l = repmat([0 0 0 0 0 0 0 0 0 0 0 1],size(class1_data,1)*(div_prop),1);

pre_div_size = size(class1_data,1);

test_c1 = class1_data(1:div_prop*pre_div_size,:);
test_c2 = class2_data(1:div_prop*pre_div_size,:);
test_c3 = class3_data(1:div_prop*pre_div_size,:);
test_c4 = class4_data(1:div_prop*pre_div_size,:);
test_c5 = class5_data(1:div_prop*pre_div_size,:);
test_c6 = class6_data(1:div_prop*pre_div_size,:);
class1_data = class1_data(div_prop*pre_div_size + 1:pre_div_size,:);
class2_data = class2_data(div_prop*pre_div_size + 1:pre_div_size,:);
class3_data = class3_data(div_prop*pre_div_size + 1:pre_div_size,:);
class4_data = class4_data(div_prop*pre_div_size + 1:pre_div_size,:);
class5_data = class5_data(div_prop*pre_div_size + 1:pre_div_size,:);
class6_data = class6_data(div_prop*pre_div_size + 1:pre_div_size,:);


s_train_data = [class1_data;class2_data;class3_data;class4_data;class5_data;class6_data];
s_train_target = [targets1;targets2;targets3;targets4;targets5;targets6];
s_test_data = [test_c1;test_c2;test_c3;test_c4;test_c5;test_c6];
s_test_target = [targets1l;targets2l;targets3l;targets4l;targets5l;targets6l];


%% Letters
class1_data = [];class2_data = [];class3_data = [];
class4_data = [];class5_data = [];class6_data = [];
pos1 = [];pos2 = [];pos3 = [];pos4 = [];pos5 = [];pos6 = [];
for i=1:size(xdata,1)
    if find(target_l(i,:)) == 1
        class1_data = [class1_data;xdata(i,:)];
        pos1 = [pos1;target_pos(i,:)];
    end
    if find(target_l(i,:)) == 2
        class2_data = [class2_data;xdata(i,:)];
        pos2 = [pos2;target_pos(i,:)];
    end
    if find(target_l(i,:)) == 3
        class3_data = [class3_data;xdata(i,:)];
        pos3 = [pos3;target_pos(i,:)];
    end
    if find(target_l(i,:)) == 4
        class4_data = [class4_data;xdata(i,:)];
        pos4 = [pos4;target_pos(i,:)];
    end
    if find(target_l(i,:)) == 5
        class5_data = [class5_data;xdata(i,:)];
        pos5 = [pos5;target_pos(i,:)];
    end
    if find(target_l(i,:)) == 6
        class6_data = [class6_data;xdata(i,:)];
        pos6 = [pos6;target_pos(i,:)];
    end
end
% train targets
targets1 = repmat([1 0 0 0 0 0 0 0 0 0 0 0],size(class1_data,1)*(1-div_prop),1);
targets2 = repmat([0 1 0 0 0 0 0 0 0 0 0 0],size(class1_data,1)*(1-div_prop),1);
targets3 = repmat([0 0 1 0 0 0 0 0 0 0 0 0],size(class1_data,1)*(1-div_prop),1);
targets4 = repmat([0 0 0 1 0 0 0 0 0 0 0 0],size(class1_data,1)*(1-div_prop),1);
targets5 = repmat([0 0 0 0 1 0 0 0 0 0 0 0],size(class1_data,1)*(1-div_prop),1);
targets6 = repmat([0 0 0 0 0 1 0 0 0 0 0 0],size(class1_data,1)*(1-div_prop),1);
% test targets
targets1l = repmat([1 0 0 0 0 0 0 0 0 0 0 0],size(class1_data,1)*(div_prop),1);
targets2l = repmat([0 1 0 0 0 0 0 0 0 0 0 0],size(class1_data,1)*(div_prop),1);
targets3l = repmat([0 0 1 0 0 0 0 0 0 0 0 0],size(class1_data,1)*(div_prop),1);
targets4l = repmat([0 0 0 1 0 0 0 0 0 0 0 0],size(class1_data,1)*(div_prop),1);
targets5l = repmat([0 0 0 0 1 0 0 0 0 0 0 0],size(class1_data,1)*(div_prop),1);
targets6l = repmat([0 0 0 0 0 1 0 0 0 0 0 0],size(class1_data,1)*(div_prop),1);

pre_div_size = size(class1_data,1);

test_c1 = class1_data(1:div_prop*pre_div_size,:);
test_c2 = class2_data(1:div_prop*pre_div_size,:);
test_c3 = class3_data(1:div_prop*pre_div_size,:);
test_c4 = class4_data(1:div_prop*pre_div_size,:);
test_c5 = class5_data(1:div_prop*pre_div_size,:);
test_c6 = class6_data(1:div_prop*pre_div_size,:);
class1_data = class1_data(div_prop*pre_div_size + 1:pre_div_size,:);
class2_data = class2_data(div_prop*pre_div_size + 1:pre_div_size,:);
class3_data = class3_data(div_prop*pre_div_size + 1:pre_div_size,:);
class4_data = class4_data(div_prop*pre_div_size + 1:pre_div_size,:);
class5_data = class5_data(div_prop*pre_div_size + 1:pre_div_size,:);
class6_data = class6_data(div_prop*pre_div_size + 1:pre_div_size,:);

test_pos = [pos1(1:div_prop*pre_div_size,:);pos2(1:div_prop*pre_div_size,:)
            pos3(1:div_prop*pre_div_size,:);pos4(1:div_prop*pre_div_size,:)
            pos5(1:div_prop*pre_div_size,:);pos6(1:div_prop*pre_div_size,:)];

train_pos = [pos1(div_prop*pre_div_size + 1:pre_div_size,:);pos2(div_prop*pre_div_size + 1:pre_div_size,:)
            pos3(div_prop*pre_div_size + 1:pre_div_size,:);pos4(div_prop*pre_div_size + 1:pre_div_size,:)
            pos5(div_prop*pre_div_size + 1:pre_div_size,:);pos6(div_prop*pre_div_size + 1:pre_div_size,:)];

l_train_data = [class1_data;class2_data;class3_data;class4_data;class5_data;class6_data];
l_train_target = [targets1;targets2;targets3;targets4;targets5;targets6];
l_test_data = [test_c1;test_c2;test_c3;test_c4;test_c5;test_c6];
l_test_target = [targets1l;targets2l;targets3l;targets4l;targets5l;targets6l];

%% Combine & shuffle
idx1 = randperm(size(s_train_data,1));
idx2 = randperm(size(l_train_data,1));
trainData = [s_train_data(idx1,:);l_train_data(idx2,:)];
train_t = [s_train_target(idx1,:);l_train_target(idx2,:)];
train_pos = train_pos(idx2,:);
idx1 = randperm(size(s_test_data,1));
idx2 = randperm(size(l_test_data,1));
testData = [s_test_data(idx1,:);l_test_data(idx2,:)];
test_t = [s_test_target(idx1,:);l_test_target(idx2,:)];
test_pos = test_pos(idx2,:);

save data/new04Jl/50_50_TrainTestData.mat trainData train_t train_pos testData test_t test_pos