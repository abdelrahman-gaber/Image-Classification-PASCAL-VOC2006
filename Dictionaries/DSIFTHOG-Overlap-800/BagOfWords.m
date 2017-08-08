function BagOfWords

% change this path if you install the VOC code elsewhere
addpath([cd '/VOCcode']);

% initialize VOC options
VOCinit;

% Loop for all classes and extract features of the files
for i = 1 : VOCopts.nclasses
    cls=VOCopts.classes{i};
    Feats = ExtractFeats(VOCopts,cls);  
end

% Get the Bag of words
GetTheBag(VOCopts, cls);


% Get features of all images
function Feats = ExtractFeats(VOCopts, cls)
% Call SIFT and HOG extractors and concatinate them here
% load 'train' image set for class
[ids, Feats.gt] = textread(sprintf(VOCopts.clsimgsetpath, cls,'train'),'%s %d');

%Histograms = [];
% extract features for each image
tic;

for i=1:length(ids)
    % display progress
    if toc>1
        fprintf('%s: train: %d/%d\n', cls, i, length(ids));
        drawnow;
        tic;
    end
    
    try
        % try to load features
        load(sprintf(VOCopts.exfdpath,ids{i}),'fd');
    catch
        % compute and save features
        I = imread(sprintf(VOCopts.imgpath,ids{i}));
        fd = ExtractFeatures(I, 'DSIFT-HOG-Overlapped');
        %fd = ExtractDenseSIFT(I);
        save(sprintf(VOCopts.exfdpath,ids{i}),'fd');
    end  
       % Save the histogram of them in another file
       %HistOfWords = GetHistogramOfWords(fd);
       %Histograms = [Histograms, HistOfWords'];       
end
%save('HistogramSIFT500x256.mat', 'Histograms');

% here get all words and make the k-means clustring
function GetTheBag(VOCopts, cls)

[ids,classifier.gt] = textread(sprintf(VOCopts.clsimgsetpath, cls,'train'),'%s %d');

FeaturesD = [];

for i=1:length(ids)
%for i= 1:5 % use only part of training at the beginning
    % display progress
    if toc>1
        fprintf('%s: Bag of words: %d/%d\n', cls, i, length(ids));
        drawnow;
        tic;
    end
    
    try
        % try to load features
        load(sprintf(VOCopts.exfdpath,ids{i}),'fd');
    catch
        % compute and save features
        I = imread(sprintf(VOCopts.imgpath,ids{i}));        
        fd = ExtractFeatures(I, 'DSIFT-HOG-Overlapped');
        %fd = ExtractDenseSIFT(VOCopts, I);
        save(sprintf(VOCopts.exfdpath,ids{i}),'fd');
    end
    FeaturesD = [FeaturesD, fd];
    %classifier.FD(1:length(fd),i)=fd;
    %size(FeaturesD)
end

fprintf('Starting K-means .. wait forever ...... ');
data = single(FeaturesD);
%size(data)
numClusters = 800 ;
%[centers, ~] = vl_ikmeans(uint8(data), numClusters);
[centers, ~] = vl_ikmeans(uint8(data), numClusters);
%size(centers)

save('BagOfSIFTHOG_Overlap1000_ikm.mat', 'centers');


