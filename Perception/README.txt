%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Self Drving cars: Controls and Perception 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Team 19 Percepion project Readme

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


Members:Shruthi Ambekar, Mukundhan Narasimhan, Kaustav Chakraborty, Adheenthar Ragunathaswamy, Swapnil Ghiya, Dhanush Dinesan, Mohieddine Amine, Henry Kim.


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