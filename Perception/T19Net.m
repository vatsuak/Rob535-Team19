%% Get the training images 
allImages = imageDatastore('all/deploy/Image', 'IncludeSubfolders', true,...
    'LabelSource', 'foldernames');
[trainingImages, ~] = splitEachLabel(allImages, 0.8, 'randomize');

%% Load pretrained VGG Net
net = vgg19(); 
layers = net.Layers; 

%% Modify the Net to match problem requirements
layers(1) = imageInputLayer([224,224, 3],'Name','input'); %%Image input layer with 224x224 RGB Image
layers(39) = fullyConnectedLayer(4096,'Name','fc3'); %% First Fully connected layer with 4096 output neurons
layers(40) = reluLayer('Name','relu_10');
layers(41) = dropoutLayer(0.5,'Name','drop3');
layers(42) = fullyConnectedLayer(64,'Name','fc4'); %% Second fully connected layer with 64 output neurons
layers(43) = reluLayer('Name','relu_11');
layers(44) = dropoutLayer(0.5,'Name','drop4');
layers(45) = fullyConnectedLayer(3,'Name','fc_last'); %% Final fully connected layer with 3 output neurons
layers(46) = softmaxLayer('Name','softmax');
layers(47) = classificationLayer('Name','classification'); %% Final classification layer.

%% Set the training options
opts = trainingOptions('sgdm', 'InitialLearnRate', 0.001,...
    'MaxEpochs', 5, 'MiniBatchSize', 64);

%% Use the custom function to resize input images for training 
trainingImages.ReadFcn = @readFunctionTrain;

%% Train the net
myNet = trainNetwork(trainingImages, layers, opts);