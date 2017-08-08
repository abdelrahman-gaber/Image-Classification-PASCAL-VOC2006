function fd = ExtractFeatures(I, type)

if strcmp(type, 'DSIFT-NoOverlap')
    % A spatial bin covers SIZE pixels.
    binSize = 4 ;
    WindowStep = 16; % no overlap
    I = single(rgb2gray(I));
    [~, fd] = vl_dsift(I, 'size', binSize, 'step', WindowStep);
    
    
elseif strcmp(type, 'DSIFT-Overlapped')
    % A spatial bin covers SIZE pixels.
    binSize = 4 ;
    WindowStep = 8; % overlapped
    I = single(rgb2gray(I));
    [~, fd] = vl_dsift(I, 'size', binSize, 'step', WindowStep);
    
    
elseif strcmp(type, 'DSIFT-HOG-Overlapped')
    % SIFT
    binSize = 4 ;
    WindowStep = 8; % overlapped
    I = single(rgb2gray(I));
    [frames, fdSIFT] = vl_dsift(I, 'size', binSize, 'step', WindowStep);
    
    % HOG
    cellSize=(frames(1,1)*2)-1;
    offset=floor(cellSize/2);
    fdHOG=[];
    
    for i=1:size(frames,2)     
        xWindow = frames(1,i);
        yWindow = frames(2,i);
        I = single(I);
        windowHOG = I(yWindow-offset:yWindow+offset, xWindow-offset:xWindow+offset);
        fd_hog = vl_hog(windowHOG, cellSize);
        
        %fd_hog_vec = [];
        fd_hog_vec = reshape(fd_hog, [31,1]);
        fd_hog_vec=round(255*fd_hog_vec);
        fdHOG=[fdHOG, fd_hog_vec];
    end
    
    % Combine them
        fd = [fdSIFT; fdHOG];
  
    
end

end
