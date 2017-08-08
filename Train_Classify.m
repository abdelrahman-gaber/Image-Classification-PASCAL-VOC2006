function Train_Classify

% change this path if you install the VOC code elsewhere
addpath([cd '/VOCcode']);

% initialize VOC options
VOCinit;

% train and test classifier for each class
for i=1:VOCopts.nclasses
    cls = VOCopts.classes{i};
    classifier = train(VOCopts,cls);                % train classifier
    test(VOCopts,cls,classifier);                   % test classifier
    [fp,tp,auc]=VOCroc(VOCopts,'comp1',cls,true);   % compute and display ROC
    % write the results to text file
    
    FileName = fopen('RDF-SIFT-Overlap1000.txt', 'a');
    formatSpec = 'Class %8s: auc = %4.4f \n';
    fprintf(FileName, formatSpec, cls, auc);
    fclose(FileName);
    
    %if i<VOCopts.nclasses
    %    fprintf('press any key to continue with next class...\n');
    %    pause;
    %end
end

% train classifier
function classifier = train(VOCopts, cls)

% load 'train' image set for class
[ids, classifier.gt] = textread(sprintf(VOCopts.clsimgsetpath, cls, 'train'),'%s %d');

% extract features for each image
classifier.FD = zeros(0, length(ids));

tic;
for i=1:length(ids)
    % display progress
    if toc>1
        fprintf('%s: train: %d/%d\n',cls,i,length(ids));
        drawnow;
        tic;
    end

    try
        % try to load features
        load(sprintf(VOCopts.exfdpath,ids{i}),'fd');
    catch
        % compute and save features
        I=imread(sprintf(VOCopts.imgpath,ids{i}));
        fd=extractfd(VOCopts,I);
        save(sprintf(VOCopts.exfdpath,ids{i}),'fd');
    end
    
    %classifier.FD(1:length(fd),i)=fd;
    Feats = GetHistogramOfWords(fd);
    classifier.FD(1:length(Feats), i) = Feats';
end


% if We already saved the histogram 
%load('HistogramSIFT500x256.mat');
%Feats = Histograms;

%for i=1:length(ids) 
 %   fd = Feats(:, i);
 %  classifier.FD(1:length(fd), i) = fd;
%end


% run classifier on test images
function test(VOCopts, cls, classifier)

% load test set ('val' for development kit)
[ids, gt]=textread(sprintf(VOCopts.clsimgsetpath,cls, VOCopts.testset),'%s %d');

% create results file
fid=fopen(sprintf(VOCopts.clsrespath,'comp1',cls),'w');

% classify each image
tic;
for i=1:length(ids)
    % display progress
    if toc>1
        fprintf('%s: test: %d/%d\n',cls,i,length(ids));
        drawnow;
        tic;
    end
    
    try
        % try to load features
        load(sprintf(VOCopts.exfdpath,ids{i}),'fd');
    catch
        % compute and save features
        I = imread(sprintf(VOCopts.imgpath,ids{i}));
        fd = extractfd(I);
        save(sprintf(VOCopts.exfdpath,ids{i}),'fd');
    end
    
    Feats = GetHistogramOfWords(fd);

    % compute confidence of positive classification
    c = classify(classifier, Feats);
    
    % write to results file
    fprintf(fid,'%s %f\n',ids{i}, c);
end

% close results file
fclose(fid);

% trivial feature extractor: compute mean RGB
function fd = extractfd(I)
% Possible Feature choice: 
% 'DSIFT-NoOverlap' , 'DSIFT-Overlapped', 'DSIFT-HOG-Overlapped'
type = 'DSIFT-Overlapped';
fd = ExtractFeatures(I, type);


function c = classify(classifier, fd)

% Possible PRTools classifiers:
% 'SVM' , 'Neural-Net' , 'AdaBoost' , 'RandomForest'
UseClassifier = 'RandomForest';

prwarning off;
prwaitbar off;

train = classifier.FD;
Atrain = prdataset(train', classifier.gt);
Atrain = setprior(Atrain, getprior(Atrain));
Atest = prdataset(fd);

W = PRToolsClassifiers(Atrain, UseClassifier);

P = Atest*W;
c = P(2);


%train = classifier.FD;
%d=sum(fd'.*fd')+sum(train.*train)-2*fd*train;
%dp=min(d(classifier.gt>0));
%dn=min(d(classifier.gt<0));
%c=dn/(dp+eps);
