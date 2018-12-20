%% Loading the testing Data

files1 = dir('deploy/test/*/*_image.jpg'); %% Change 'deploy/test/*/*_image.jpg' to the folder containing the test images

testdataset = [files1(1).folder, '/', files1(1).name];
s1 = {char(testdataset)};
testDataset = table(s1);
for j = 2:numel(files1)
    testdataset = [files1(j).folder, '/', files1(j).name];
    s1 = {char(testdataset)};
    testDataset = [testDataset; table(s1)];
end

save('Test.mat','testDataset');