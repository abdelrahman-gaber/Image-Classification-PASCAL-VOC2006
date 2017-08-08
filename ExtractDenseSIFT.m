function fd = ExtractDenseSIFT(I)

% A spatial bin covers SIZE pixels.
binSize = 4 ;
WindowStep = 16; % no overlap
%magnif = 4 ;
%Is = vl_imsmooth(I, sqrt((binSize/magnif)^2 - .25)) ;
I = single(rgb2gray(I));
[~, fd] = vl_dsift(I, 'size', binSize, 'step', WindowStep) ;

end