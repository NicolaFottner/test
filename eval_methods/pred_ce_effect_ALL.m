
weights = W2;
addpath("data/new04Jl/");
%load openCV_CE_data.mat 
load openCV_CE_data.mat cong_pl_d cong_pl_t cong_pl_s inc_pl_d inc_pl_t inc_pl_s 
load openCV_newL_CE.mat cong_l_d cong_l_t cong_l_s inc_l_d inc_l_t inc_l_s 

%% Prep and convert openCV_CE_data from uint8 to double:
shapedata = zeros(size(cong_l_d));
for i=1:size(cong_l_d,1)
    shapedata(i,:) = reshape(im2double(reshape(cong_l_d(i,:),[40 40 1])), [1 1600]);
end
cong_l_d = shapedata;
cong_l_t =  double(cong_l_t);
cong_l_s = double(cong_l_s);
%%%
shapedata = zeros(size(cong_pl_d));
for i=1:size(cong_pl_d,1)
    shapedata(i,:) = reshape(im2double(reshape(cong_pl_d(i,:),[40 40 1])), [1 1600]);
end
cong_pl_d = shapedata;
cong_pl_t =  double(cong_pl_t);
cong_pl_s = double(cong_pl_s);
%%%
shapedata = zeros(size(inc_l_d));
for i=1:size(inc_l_d,1)
    shapedata(i,:) = reshape(im2double(reshape(inc_l_d(i,:),[40 40 1])), [1 1600]);
end
inc_l_d = shapedata;
inc_l_t =  double(inc_l_t);
inc_l_s = double(inc_l_s);
%%%
shapedata = zeros(size(inc_pl_d));
for i=1:size(inc_pl_d,1)
    shapedata(i,:) = reshape(im2double(reshape(inc_pl_d(i,:),[40 40 1])), [1 1600]);
end
inc_pl_d = shapedata;
inc_pl_t =  double(inc_pl_t);
inc_pl_s = double(inc_pl_s);

%load rbm data
load t_model DN
vishid_1 = DN.L{1,1}.vishid;
hidbiases_1 = DN.L{1,1}.hidbiases;
clear DN
if literate
    load l_rbm_2.mat vishid_2 hidbiases_2
else
    load g_rbm_2.mat vishid_2 hidbiases_2
end
%load rbm2_16J11h39.mat vishid_2 hidbiases_2

%% EVAL - Letter congruent
hid_out_1_d = 1./(1 + exp(-cong_l_d*vishid_1 - repmat(hidbiases_1,size(cong_l_d,1),1)));
rbms_pass = 1./(1 + exp(-hid_out_1_d*vishid_2 - repmat(hidbiases_2,size(hid_out_1_d,1),1)));
ONES = ones(size(rbms_pass, 1), 1);rbms_pass = [rbms_pass ONES]; 
pred_cl = rbms_pass*weights;
softmax_pred_cl = softmax(dlarray(pred_cl','CB'));
pred_cl = extractdata(softmax_pred_cl)';
[~, max_act] = max(pred_cl,[],2); 
[r2,~] = find(cong_l_s');
acc_s_cong_l = (max_act == r2);
inner_cong_l_s = inner_targets_f(cong_l_t);
[r1,~] = find(inner_cong_l_s');
acc_s_cong_l_inner = (max_act == r1);


%% EVAL - Pseudo Letter congruent
hid_out_1_d = 1./(1 + exp(-cong_pl_d*vishid_1 - repmat(hidbiases_1,size(cong_pl_d,1),1)));
rbms_pass = 1./(1 + exp(-hid_out_1_d*vishid_2 - repmat(hidbiases_2,size(hid_out_1_d,1),1)));
ONES = ones(size(rbms_pass, 1), 1);  
rbms_pass = [rbms_pass ONES];
pred_cpl = rbms_pass*weights;
softmax_pred_cpl = softmax(dlarray(pred_cpl','CB'));
pred_cpl = extractdata(softmax_pred_cpl)';
[~, max_act] = max(pred_cpl,[],2); 
[r2,~] = find(cong_pl_s'); 
acc_s_cong_pl = (max_act == r2);
inner_cong_pl_s = inner_targets_f(cong_pl_t);
[r1,~] = find(inner_cong_pl_s');
acc_s_cong_pl_inner = (max_act == r1);

%% EVAL - Letter Incongruent
hid_out_1_d = 1./(1 + exp(-inc_l_d*vishid_1 - repmat(hidbiases_1,size(inc_l_d,1),1)));
rbms_pass = 1./(1 + exp(-hid_out_1_d*vishid_2 - repmat(hidbiases_2,size(hid_out_1_d,1),1)));
ONES = ones(size(rbms_pass, 1), 1);  
rbms_pass = [rbms_pass ONES];
pred_il = rbms_pass*weights;
softmax_pred_il = softmax(dlarray(pred_il','CB'));
pred_il = extractdata(softmax_pred_il)';
[~, max_act] = max(pred_il,[],2); 
[r2,~] = find(inc_l_s'); 
acc_s_inc_l = (max_act == r2);
inner_inc_l_s = inner_targets_f(inc_l_t);
[r1,~] = find(inner_inc_l_s');
acc_s_inc_l_inner = (max_act == r1);
%% EVAL - Pseudo-Letter Incongruent
hid_out_1_d = 1./(1 + exp(-inc_pl_d*vishid_1 - repmat(hidbiases_1,size(inc_pl_d,1),1)));
rbms_pass = 1./(1 + exp(-hid_out_1_d*vishid_2 - repmat(hidbiases_2,size(hid_out_1_d,1),1)));
ONES = ones(size(rbms_pass, 1), 1);  
rbms_pass = [rbms_pass ONES];
pred_ipl = rbms_pass*weights;
softmax_pred_ipl = softmax(dlarray(pred_ipl','CB'));
pred_ipl = extractdata(softmax_pred_ipl)';
[~, max_act] = max(pred_ipl,[],2); 
[r2,~] = find(inc_pl_s'); 
acc_s_inc_pl = (max_act == r2);
inner_inc_pl_s = inner_targets_f(inc_pl_t);
[r1,~] = find(inner_inc_pl_s');
acc_s_inc_pl_inner = (max_act == r1);

%% Store the Evaluation Data
if ii == 1
    subj_str = "Subject 1";
elseif ii == 2
    subj_str = "Subject 2 ";
elseif ii == 3
    subj_str = "Subject 3 ";
elseif ii == 4
    subj_str = "Subject 4 ";
elseif ii == 5
    subj_str = "Subject 5 ";
end

% acc matrix - decision based on CONTOUR shape
accs = cat(1,acc_s_cong_l,acc_s_cong_pl);
accs = cat(1,accs,acc_s_inc_l);
accs = cat(1,accs,acc_s_inc_pl);
% acc matrix - decision based on INNER shape
accs_i = cat(1,acc_s_cong_l_inner,acc_s_cong_pl_inner);
accs_i = cat(1,accs_i,acc_s_inc_l_inner);
accs_i = cat(1,accs_i,acc_s_inc_pl_inner);
%inner-nature:
prep_l =  letter_int2str(cong_l_t);
prep_l1 = psletter_int2str(cong_pl_t);
prep_l2 = letter_int2str(inc_l_t);
prep_l3 = psletter_int2str(inc_pl_t);
Letter = cat(1,prep_l,prep_l1);
Letter = cat(1,Letter,prep_l2);
Letter = cat(1,Letter,prep_l3);
%outer:
s_targets = cat(1,cong_l_s,cong_pl_s);
s_targets = cat(1,s_targets,inc_l_s);
s_targets = cat(1,s_targets,inc_pl_s);

%% matrix 1 & 1-pd
Subjects = repmat(subj_str,size(accs,1),1);
% to store full predictions:
cross = cat(1,pred_cl(:,1),pred_cpl(:,1));
cross = cat(1,cross,pred_il(:,1));
cross = cat(1,cross,pred_ipl(:,1));
elipse = cat(1,pred_cl(:,2),pred_cpl(:,2));
elipse = cat(1,elipse,pred_il(:,2));
elipse = cat(1,elipse,pred_ipl(:,2));
hexa = cat(1,pred_cl(:,3),pred_cpl(:,3));
hexa = cat(1,hexa,pred_il(:,3));
hexa = cat(1,hexa,pred_ipl(:,3));
rect = cat(1,pred_cl(:,4),pred_cpl(:,4));
rect = cat(1,rect,pred_il(:,4));
rect = cat(1,rect,pred_ipl(:,4));
square = cat(1,pred_cl(:,5),pred_cpl(:,5));
square = cat(1,square,pred_il(:,5));
square = cat(1,square,pred_ipl(:,5));
trian = cat(1,pred_cl(:,6),pred_cpl(:,6));
trian = cat(1,trian,pred_il(:,6));
trian = cat(1,trian,pred_ipl(:,6));
%
Contour = shape_int2str(s_targets);
accs = int2str(accs);
accs_i = int2str(accs_i);
if ii==1
    matrix_1 = table(Subjects,Letter,Contour,accs,accs_i);
    matrix_1_pd = table(Subjects,Letter,Contour,cross,elipse,hexa,rect,square,trian);
else
    m = table(Subjects,Letter,Contour,accs,accs_i);
    m_p =  table(Subjects,Letter,Contour,cross,elipse,hexa,rect,square,trian);
    matrix_1 = cat(1,matrix_1,m);
    matrix_1_pd = cat(1,matrix_1_pd,m_p);
end

%% matrix 3 outer
Acc_Cong = cat(1,acc_s_cong_l,acc_s_cong_pl);
Outer_Inc_Acc = cat(1,acc_s_inc_l,acc_s_inc_pl);

%now: 1 cross, 2 elipse, ....
% 1a = m, 1b=x, 2a=a 2b=h, 3a=m, 3b=t,4a=a,4b=u,
% 5a = t,5b= x,6a=h, 6b= u
inc_1a=[];inc_1b=[];inc_2a=[];inc_2b=[];
inc_3a=[];inc_3b=[];inc_4a=[];inc_4b=[];
inc_5a=[];inc_5b=[];inc_6a=[];inc_6b=[];
for i=1:size(inc_l_s)
    if find(inc_l_s(i,:)) == 1
        if find(inc_l_t(i,:)) == 3
            inc_1a=[inc_1a;acc_s_inc_l(i)];
        elseif find(inc_l_t(i,:)) == 6
            inc_1b=[inc_1b;acc_s_inc_l(i)];
        end
    end
    if find(inc_l_s(i,:)) == 2
        if find(inc_l_t(i,:)) == 1
            inc_2a=[inc_2a;acc_s_inc_l(i)];
        elseif find(inc_l_t(i,:)) == 2
            inc_2b=[inc_2b;acc_s_inc_l(i)];
        end
    end
    if find(inc_l_s(i,:)) == 3
        if find(inc_l_t(i,:)) == 3
            inc_3a=[inc_3a;acc_s_inc_l(i)];
        elseif find(inc_l_t(i,:)) == 4
            inc_3b=[inc_3b;acc_s_inc_l(i)];
        end
    end
    if find(inc_l_s(i,:)) == 4
        if find(inc_l_t(i,:)) == 1
            inc_4a=[inc_4a;acc_s_inc_l(i)];
        elseif find(inc_l_t(i,:)) == 5
            inc_4b=[inc_4b;acc_s_inc_l(i)];
        end
    end
    if find(inc_l_s(i,:)) == 5
        if find(inc_l_t(i,:)) == 4
            inc_5a=[inc_5a;acc_s_inc_l(i)];
        elseif find(inc_l_t(i,:)) == 6
            inc_5b=[inc_5b;acc_s_inc_l(i)];
        end
    end
    if find(inc_l_s(i,:)) == 6
        if find(inc_l_t(i,:)) == 2
            inc_6a=[inc_6a;acc_s_inc_l(i)];
        elseif find(inc_l_t(i,:)) == 5
            inc_6b=[inc_6b;acc_s_inc_l(i)];
        end
    end
end
letter_inc_a = [inc_1a;inc_2a;inc_3a;inc_4a;inc_5a;inc_6a];
letter_inc_b = [inc_1b;inc_2b;inc_3b;inc_4b;inc_5b;inc_6b];
% for pseudo:
inc_1a=[];inc_1b=[];inc_2a=[];inc_2b=[];
inc_3a=[];inc_3b=[];inc_4a=[];inc_4b=[];
inc_5a=[];inc_5b=[];inc_6a=[];inc_6b=[];
for i=1:size(inc_pl_s)
    if find(inc_pl_s(i,:)) == 1
        if find(inc_pl_t(i,:)) == 3
            inc_1a=[inc_1a;acc_s_inc_pl(i)];
        elseif find(inc_pl_t(i,:)) == 6
            inc_1b=[inc_1b;acc_s_inc_pl(i)];
        end
    end
    if find(inc_pl_s(i,:)) == 2
        if find(inc_pl_t(i,:)) == 1
            inc_2a=[inc_2a;acc_s_inc_pl(i)];
        elseif find(inc_pl_t(i,:)) == 2
            inc_2b=[inc_2b;acc_s_inc_pl(i)];
        end
    end
    if find(inc_pl_s(i,:)) == 3
        if find(inc_pl_t(i,:)) == 3
            inc_3a=[inc_3a;acc_s_inc_pl(i)];
        elseif find(inc_pl_t(i,:)) == 4
            inc_3b=[inc_3b;acc_s_inc_pl(i)];
        end
    end
    if find(inc_pl_s(i,:)) == 4
        if find(inc_pl_t(i,:)) == 1
            inc_4a=[inc_4a;acc_s_inc_pl(i)];
        elseif find(inc_pl_t(i,:)) == 5
            inc_4b=[inc_4b;acc_s_inc_pl(i)];
        end
    end
    if find(inc_pl_s(i,:)) == 5
        if find(inc_pl_t(i,:)) == 4
            inc_5a=[inc_5a;acc_s_inc_pl(i)];
        elseif find(inc_pl_t(i,:)) == 6
            inc_5b=[inc_5b;acc_s_inc_pl(i)];
        end
    end
    if find(inc_pl_s(i,:)) == 6
        if find(inc_pl_t(i,:)) == 2
            inc_6a=[inc_6a;acc_s_inc_pl(i)];
        elseif find(inc_pl_t(i,:)) == 5
            inc_6b=[inc_6b;acc_s_inc_pl(i)];
        end
    end
end
psletter_inc_a = [inc_1a;inc_2a;inc_3a;inc_4a;inc_5a;inc_6a];
psletter_inc_b = [inc_1b;inc_2b;inc_3b;inc_4b;inc_5b;inc_6b];
%now: 1 cross, 2 elipse, ....
% 1a = m, 1b=x, 2a=a 2b=h, 3a=m, 3b=t,4a=a,4b=u,
% 5a = t,5b= x,6a=h, 6b= u
a1 = repmat("M",100,1);
a2 = repmat("A",100,1);
a3 = repmat("M",100,1);
a4= repmat("A",100,1);
a5= repmat("T",100,1);
a6= repmat("H",100,1);
b1 = repmat("X",100,1);
b2 = repmat("H",100,1);
b3 = repmat("T",100,1);
b4= repmat("U",100,1);
b5= repmat("X",100,1);
b6= repmat("U",100,1);

pa1 = repmat("pM",100,1);
pa2 = repmat("pA",100,1);
pa3 = repmat("pM",100,1);
pa4= repmat("pA",100,1);
pa5= repmat("pT",100,1);
pa6= repmat("pH",100,1);
pb1 = repmat("pX",100,1);
pb2 = repmat("pH",100,1);
pb3 = repmat("pT",100,1);
pb4= repmat("pU",100,1);
pb5= repmat("pX",100,1);
pb6= repmat("pU",100,1);
a = [a1;a2;a3;a4;a5;a6;pa1;pa2;pa3;pa4;pa5;pa6];
b = [b1;b2;b3;b4;b5;b6;pb1;pb2;pb3;pb4;pb5;pb6];

Acc_inc_a = [letter_inc_a;psletter_inc_a];
Acc_inc_b= [letter_inc_b;psletter_inc_b];

stargets = cat(1,cong_l_s,cong_pl_s);
Shape = shape_int2str(stargets);
Subjects = repmat(subj_str,size(Shape,1),1);



if ii==1
    matrix_3_outer = table(Subjects,Shape,Acc_Cong,Acc_inc_a,Acc_inc_b,a,b);
else
    m3 = table(Subjects,Shape,Acc_Cong,Acc_inc_a,Acc_inc_b,a,b);
    matrix_3_outer = cat(1,matrix_3_outer,m3);
end


%% matrix 3 inner
Cong_Acc = cat(1,acc_s_cong_l_inner,acc_s_cong_pl_inner);
Inner_Inc_Acc = cat(1,acc_s_inc_l_inner,acc_s_inc_pl_inner);
str_target_l = letter_int2str(cong_l_t);
str_target_pl = psletter_int2str(cong_pl_t);
Letter = cat(1,str_target_l,str_target_pl);


% 1a = rect, 1b=elip, 2a=tria 2b=elip, 3a=hex, 3b=cros,4a=hex,4b=squ,
% 5a = rec 5b= trian,6a=cross, 6b= squa
inc_1a=[];inc_1b=[];inc_2a=[];inc_2b=[];
inc_3a=[];inc_3b=[];inc_4a=[];inc_4b=[];
inc_5a=[];inc_5b=[];inc_6a=[];inc_6b=[];
for i=1:size(inc_l_t)
    if find(inc_l_t(i,:)) == 1
        if find(inc_l_s(i,:)) == 4
            inc_1a=[inc_1a;acc_s_inc_l_inner(i)];
        elseif find(inc_l_s(i,:)) == 2
            inc_1b=[inc_1b;acc_s_inc_l_inner(i)];
        end
    end
    if find(inc_l_t(i,:)) == 2
        if find(inc_l_s(i,:)) == 6
            inc_2a=[inc_2a;acc_s_inc_l_inner(i)];
        elseif find(inc_l_s(i,:)) == 2
            inc_2b=[inc_2b;acc_s_inc_l_inner(i)];
        end
    end
    if find(inc_l_t(i,:)) == 3
        if find(inc_l_s(i,:)) == 3
            inc_3a=[inc_3a;acc_s_inc_l_inner(i)];
        elseif find(inc_l_s(i,:)) == 1
            inc_3b=[inc_3b;acc_s_inc_l_inner(i)];
        end
    end
    if find(inc_l_t(i,:)) == 4
        if find(inc_l_s(i,:)) == 3
            inc_4a=[inc_4a;acc_s_inc_l_inner(i)];
        elseif find(inc_l_s(i,:)) == 5
            inc_4b=[inc_4b;acc_s_inc_l_inner(i)];
        end
    end
    if find(inc_l_t(i,:)) == 5
        if find(inc_l_s(i,:)) == 4
            inc_5a=[inc_5a;acc_s_inc_l_inner(i)];
        elseif find(inc_l_s(i,:)) == 6
            inc_5b=[inc_5b;acc_s_inc_l_inner(i)];
        end
    end
    if find(inc_l_t(i,:)) == 6
        if find(inc_l_s(i,:)) == 1
            inc_6a=[inc_6a;acc_s_inc_l_inner(i)];
        elseif find(inc_l_s(i,:)) == 5
            inc_6b=[inc_6b;acc_s_inc_l_inner(i)];
        end
    end
end
letter_inc_a = [inc_1a;inc_2a;inc_3a;inc_4a;inc_5a;inc_6a];
letter_inc_b = [inc_1b;inc_2b;inc_3b;inc_4b;inc_5b;inc_6b];
% for pseudo:
inc_1a=[];inc_1b=[];inc_2a=[];inc_2b=[];
inc_3a=[];inc_3b=[];inc_4a=[];inc_4b=[];
inc_5a=[];inc_5b=[];inc_6a=[];inc_6b=[];
for i=1:size(inc_pl_t)
    if find(inc_pl_t(i,:)) == 1
        if find(inc_pl_s(i,:)) == 4
            inc_1a=[inc_1a;acc_s_inc_pl_inner(i)];
        elseif find(inc_pl_s(i,:)) == 2
            inc_1b=[inc_1b;acc_s_inc_pl_inner(i)];
        end
    end
    if find(inc_pl_t(i,:)) == 2
        if find(inc_pl_s(i,:)) == 6
            inc_2a=[inc_2a;acc_s_inc_pl_inner(i)];
        elseif find(inc_pl_s(i,:)) == 2
            inc_2b=[inc_2b;acc_s_inc_pl_inner(i)];
        end
    end
    if find(inc_pl_t(i,:)) == 3
        if find(inc_pl_s(i,:)) == 3
            inc_3a=[inc_3a;acc_s_inc_pl_inner(i)];
        elseif find(inc_pl_s(i,:)) == 1
            inc_3b=[inc_3b;acc_s_inc_pl_inner(i)];
        end
    end
    if find(inc_pl_t(i,:)) == 4
        if find(inc_pl_s(i,:)) == 3
            inc_4a=[inc_4a;acc_s_inc_pl_inner(i)];
        elseif find(inc_pl_s(i,:)) == 5
            inc_4b=[inc_4b;acc_s_inc_pl_inner(i)];
        end
    end
    if find(inc_pl_t(i,:)) == 5
        if find(inc_pl_s(i,:)) == 4
            inc_5a=[inc_5a;acc_s_inc_pl_inner(i)];
        elseif find(inc_pl_s(i,:)) == 6
            inc_5b=[inc_5b;acc_s_inc_pl_inner(i)];
        end
    end
    if find(inc_pl_t(i,:)) == 6
        if find(inc_pl_s(i,:)) == 1
            inc_6a=[inc_6a;acc_s_inc_pl_inner(i)];
        elseif find(inc_pl_s(i,:)) == 5
            inc_6b=[inc_6b;acc_s_inc_pl_inner(i)];
        end
    end
end
psletter_inc_a = [inc_1a;inc_2a;inc_3a;inc_4a;inc_5a;inc_6a];
psletter_inc_b = [inc_1b;inc_2b;inc_3b;inc_4b;inc_5b;inc_6b];
% 1a = rect, 1b=elip, 2a=tria 2b=elip, 3a=hex, 3b=cros,4a=hex,4b=squ,
% 5a = rec 5b= trian,6a=cross, 6b= squa
a1 = repmat("rectangle",100,1);
a2 = repmat("triangle",100,1);
a3 = repmat("hexagon",100,1);
a4= repmat("hexagon",100,1);
a5= repmat("rectangle",100,1);
a6= repmat("cross",100,1);
b1 = repmat("elipse",100,1);
b2 = repmat("elipse",100,1);
b3 = repmat("cross",100,1);
b4= repmat("square",100,1);
b5= repmat("triangle",100,1);
b6= repmat("square",100,1);
a = [a1;a2;a3;a4;a5;a6;a1;a2;a3;a4;a5;a6];
b = [b1;b2;b3;b4;b5;b6;b1;b2;b3;b4;b5;b6];

Acc_inc_a = [letter_inc_a;psletter_inc_a];
Acc_inc_b= [letter_inc_b;psletter_inc_b];
Subjects = repmat(subj_str,size(Acc_inc_a,1),1);

if ii==1
    matrix_3_inner = table(Subjects,Letter,Cong_Acc,Acc_inc_a,Acc_inc_b,a,b);
else
    m3i = table(Subjects,Letter,Cong_Acc,Acc_inc_a,Acc_inc_b,a,b);
    matrix_3_inner = cat(1,matrix_3_inner,m3i);
end

%% functions

function [inner_t] = inner_targets_f(letter_id)
    inner_t = zeros(size(letter_id,1));
    for i=1:size(letter_id,1)
        if find(letter_id(i,:)) == 1
            inner_t(i) = 6;
        elseif find(letter_id(i,:))  == 2
            inner_t(i) = 4;
        elseif find(letter_id(i,:))  == 3
            inner_t(i) = 5;
        elseif find(letter_id(i,:))  == 4 
            inner_t(i) = 1;
        elseif find(letter_id(i,:))  == 5
            inner_t(i) = 2;
        elseif find(letter_id(i,:))  == 6
            inner_t(i) = 3;
        end
    end
end

function [str_letter] = letter_int2str(letter_id)
    str_letter = strings(size(letter_id,1),1);
    for i=1:size(letter_id,1)
        if find(letter_id(i,:))  == 1
            str_letter(i) = "A";
        elseif find(letter_id(i,:))  == 2
            str_letter(i) = "H";
        elseif find(letter_id(i,:))  == 3
            str_letter(i) = "M";
        elseif find(letter_id(i,:))  == 4 
            str_letter(i) = "T";
        elseif find(letter_id(i,:))  == 5
            str_letter(i) = "U";
        elseif find(letter_id(i,:))  == 6
            str_letter(i) = "X";
        end
    end
end

function [str_shape] = shape_int2str(shape_id)
    str_shape = strings(size(shape_id,1),1);
    for i=1:size(shape_id,1)
        if find(shape_id(i,:)) == 1
            str_shape(i) = "cross";
        elseif find(shape_id(i,:)) == 2
            str_shape(i) = "elips";
        elseif find(shape_id(i,:)) == 3
            str_shape(i) = "hexagon";
        elseif find(shape_id(i,:)) == 4 
            str_shape(i) = "rectangle";
        elseif find(shape_id(i,:)) == 5
            str_shape(i) = "square";
        elseif find(shape_id(i,:)) == 6
            str_shape(i) = "triangle";
        end
    end
end
function [str_letter] = psletter_int2str(letter_id)
    str_letter = strings(size(letter_id,1),1);
    for i=1:size(letter_id,1)
        if find(letter_id(i,:))  == 1
            str_letter(i) = "psA";
        elseif find(letter_id(i,:))  == 2
            str_letter(i) = "psH";
        elseif find(letter_id(i,:))  == 3
            str_letter(i) = "psM";
        elseif find(letter_id(i,:))  == 4 
            str_letter(i) = "psT";
        elseif find(letter_id(i,:))  == 5
            str_letter(i) = "psU";
        elseif find(letter_id(i,:))  == 6
            str_letter(i) = "psX";
        end
    end
end


