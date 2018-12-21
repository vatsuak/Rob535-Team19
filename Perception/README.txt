%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Self Drving cars: Controls and Perception 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Team 19 Percepion project Readme

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





Members:Shruti Ambekar, Mukundhan Narasimhan, Kaustav Chakraborty, Adheenthar Ragunathasamy, Swapnil Ghiya, Dhanush Dinesan, Mohieddine Amine, Henry Kim.





&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&



Procedure/Methodology/Approach





VGG is a family of Series Convolution Neural Network.

The popular ones are VGG16 and VGG19 that has

16 and 19 sequential convolutional and fully connected

layers. In our testing, we found the VGG19 to be more

effective and used this network as a base for our new

neural network. VGG 19 consists of 47 layers and 144

million parameters. The image input size is 244x244x3

(RGB image). The next few layers are 5 convolution

layer groups with 2 to 4 layers in each group, amounting

to a total of 16 convolutional layers. Each convolutional

layer is followed by a ReLU activation layer and a maxpooling

layer at the end of each group. The final few

layers consist of 3 fully connected layers. The first two

fully connected layers have 4096 output neurons, while

the last fully connected layer has 1000 output neurons.

Finally, it has a 1000 way softmax layer for classification

of the images.



In our version of VGG, the convolutional layers were

not modified as it was found that any modification to

the convolutional layers made the network not classify

any images. However, it was found through trial and

error that having 64 output neurons for the second

classification layer increased the accuracy of the net by

about 5%. Hence, the second fully connected layer was

modified to have 64 output neurons and the final fully

connected layer to have 3 output neurons for each of

the 3 classes to be classified into. The softmax layer

is hence 3-way. Similar modifications were attempted

on AlexNet and Faster R-CNN. However, they did not

achieve similar accuracy levels as the modified VGG

Net.



When tested on 2631 test images and the network

achieved an accuracy of 69.25%. 


Contents
Requirements: software
Preparation for Training
Training the Net
Preparation for Testing
Testing the Net


Requirements: software
1. MATLAB R2018a or later
1.1 Deeplearning Toolbox
1.2 Deeplearning Toolbox Model for VGG-19 Net.
2. Microsoft Excel or Office 365 Suite.

Preparation for Training
1. Get the training images
2. Store the training images in the folder 'all/deploy/trainval/*/*_image.jpg'
2. Run 'T19TrainingImagesLoad.m' file
3. The sorted images are placed in the directory 'all/deploy/Image/'. 

Training the Net
1. Run T19.m file. Training will take about 1 hour to complete on a desktop with GPU.
2. The variable 'myNet.m' holds the trained network.

Preparation for Testing
1. Place the test images in the folder 'all/deploy/Test'
2. Run the 'T19TestImagesLoad.m' file

Testing the Net
1. Run T19Test.m file
2. The variable 'testDataset' contains the classified images. 
3. Copy and paste the contents of the variable into an excelworkbook and save it as "Results.csv".


.............Folder organisation................
Perception
|-all
  |-deploy
    |-test
    |-trainval
|-T19Net.m
|-T19Test.m
|-T19TestImagesLoad.m
|-T19TrainingImagesLoad.m

