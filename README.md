# Image-Classification-PASCAL-VOC2006

In this project, we developed a system that can recognize objects from a number of visual object classes in realistic scenes. This project follow the same philosophy of the well known PASCAL Challenge 2006, in which ten object classes have to be recognized: bicycle, bus, car, motorbike, cat, cow, dog, horse, sheep, person. For each of the ten object classes, the goal is to predict the presence/absence of at least one object of that class in a test image.

To solve this problem, we used the approach of Bag of features, also known as Bag of visual words, with SIFT and HOG features. In addition, we tried 5 different classiffiers, Nearest Neighbor, SVM, Neural Networks, AdaBoost, and Randomized Decision Forests (RDF). This project uses the PASCAL Visual Object Classes (VOC2006) dataset. the 255 training images were used as training set, and the 268 validation set were used in testing.
