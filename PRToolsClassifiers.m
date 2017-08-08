function W = PRToolsClassifiers(Atrain, Choise)
  
if strcmp(Choise, 'SVM')
    W = classc(svc(Atrain));
    %W = classc(svc(Atrain, proxm(Atrain, 'p',3) ));
    %W = classc(Atrain*svc(proxm('p', 3)));    
    
elseif strcmp(Choise, 'Neural-Net')
    W = classc(bpxnc(Atrain));
    
elseif strcmp(Choise, 'AdaBoost')
    W = classc(adaboostc(Atrain));

elseif strcmp(Choise, 'RandomForest')
    W = classc(randomforestc(Atrain));
end