function HistOfWords = GetHistogramOfWords(ImageFeats)

% This uses the bag of words where features are integers
load('Dictionaries/BagOfSIFT_ikmOVerlap1000.mat');
Dictionary = centers;
size(Dictionary);
DictionaryLength = size(Dictionary, 2);

HistOfWords = zeros(1, DictionaryLength);

AT = vl_ikmeanspush(ImageFeats, Dictionary);
%size(AT)

for i = 1: size(AT, 2)
    HistOfWords(AT(i)) = HistOfWords(AT(i)) + 1;
end


%I = imread('000001.png');
%[~, ImageFeats] = ExtractDenseSIFT(I);
%ImageFeats = ImageFeats;

% size(ImageFeats)
%Dictionary = uint8(Dictionary);

%class(Dictionary)
%class(ImageFeats)
% AT = vl_ikmeanspush(ImageFeats, Dictionary);
% size(AT)
% 
% for i = 1: size(AT, 2)
%     HistOfWords(AT(i)) = HistOfWords(AT(i)) + 1;
% end
%HistOfWords

%size(AT)
%size(Dictionary)
%size(ImageFeats)
%H = vl_ikmeanshist(ImageFeats, Dictionary)
% for i = 1 : size(ImageFeats, 2)
%     Word = ImageFeats(:, i);
%     RepWord = repmat(Word, 1, DictionaryLength);
%     size(RepWord)
%     %class(Dictionary)
%     %class(RepWord)
%     Diff = Dictionary - RepWord;
%     Distances = sum(Diff);
%     size(Distances)
%     [~, idx] = min(Distances);
%     
%     HistOfWords(idx) = HistOfWords(idx) + 1;
%     
% end

%HistOfWords
%size(HistOfWords)

%size(frames)
% draw sift points
%imshow(I); hold on;
%h1 = vl_plotframe(frames);
%set(h1, 'color','r','linewidth',5) ;

% 
% 
% function [frames, fd] = ExtractDenseSIFT (I)
% 
% % A spatial bin covers SIZE pixels.
% binSize = 4 ;
% WindowStep = 16; % no overlap
% %magnif = 4 ;
% %Is = vl_imsmooth(I, sqrt((binSize/magnif)^2 - .25)) ;
% I = single(rgb2gray(I));
% [frames, fd] = vl_dsift(I, 'size', binSize, 'step', WindowStep) ;
