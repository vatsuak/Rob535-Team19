%% Testing the Neural net

D = load('Test.mat'); %% Load the Test.mat file created by running T19TestImagesLoad.m dile
testDataset = D.testDataset;

for i = 2:height(testDataset)
    s = char(testDataset.s1(i));
    I = imread(s);
    I = imresize(I, [224,224]);
    testDataset.label(i) = char(classify(myNet,I)); %%Classifying the images. Note that the labels will have the ASCII code for the respective classes
    % ASCII Code in our test case: 0 - 48; 1 - 49; 2 - 50.
end
save('Test.mat','testDataset'); %% Output will be a table with first column having the path of the image and the second column containing the ASCII code of the class of image