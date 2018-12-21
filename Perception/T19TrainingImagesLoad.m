function [data,testDataset] = T19TrainingImagesLoad()

%%
files = dir('all/deploy/trainval/*/*_image.jpg'); %%Change the directory to the location of the training images.

% First row
snapshot = [files(1).folder, '/', files(1).name];

try
    bbox = read_bin(strrep(snapshot, '_image.jpg', '_bbox.bin'));
catch
    disp('[*] no bbox found.')
    bbox = single([]);
end
bbox = reshape(bbox, [] , 11);

for k = 1:size(bbox, 1)
    
    c = int64(bbox(k, 10)) + 1;

    I = imread(snapshot);
    
    switch c
        case 1
            imwrite(I,'deploy/Image/0/1.jpg');
        case 2
            imwrite(I,'deploy/Image/1/1.jpg');
        case 3
            imwrite(I,'deploy/Image/1/1.jpg');
        case 4
            iimwrite(I,'deploy/Image/1/1.jpg');
        case 5
            imwrite(I,'deploy/Image/1/1.jpg');
        case 6
            imwrite(I,'deploy/Image/1/1.jpg');
        case 7
            imwrite(I,'deploy/Image/1/1.jpg');
        case 8
            imwrite(I,'deploy/Image/1/1.jpg');
        case 9
            imwrite(I,'deploy/Image/1/1.jpg');
        case 10
            imwrite(I,'deploy/Image/2/1.jpg');
        case 11
            imwrite(I,'deploy/Image/2/1.jpg');
        case 12
            imwrite(I,'deploy/Image/2/1.jpg');
        case 13
            imwrite(I,'deploy/Image/2/1.jpg');
        case 14
            imwrite(I,'deploy/Image/2/1.jpg');
        case 15
            imwrite(I,'deploy/Image/2/1.jpg');
        case 16
            imwrite(I,'deploy/Image/0/1.jpg');
        case 17
            imwrite(I,'deploy/Image/0/1.jpg');
        case 18
            imwrite(I,'deploy/Image/0/1.jpg');
        case 19
            imwrite(I,'deploy/Image/0/1.jpg');
        case 20
            imwrite(I,'deploy/Image/0/1.jpg');
        case 21
            imwrite(I,'deploy/Image/0/1.jpg');
        case 22
            imwrite(I,'deploy/Image/0/1.jpg');
        case 23
            imwrite(I,'deploy/Image/0/1.jpg');
    end
    
end

for i = 2:numel(files)

    snapshot = [files(i).folder, '/', files(i).name];

try
    bbox = read_bin(strrep(snapshot, '_image.jpg', '_bbox.bin'));
catch
    disp('[*] no bbox found.')
    bbox = single([]);
end
bbox = reshape(bbox, [] , 11);

for k = 1:size(bbox)
    
    c = int64(bbox(k, 10)) + 1;
    
    I = imread(snapshot);
    
    switch c
        case 1
            filename = char(strcat('deploy/Image/0/',string(i),'.jpg'));
            imwrite(I,filename);
        case 2
            filename = char(strcat('deploy/Image/1/',string(i),'.jpg'));
            imwrite(I,filename);
        case 3
            filename = char(strcat('deploy/Image/1/',string(i),'.jpg'));
            imwrite(I,filename);
        case 4
            filename = char(strcat('deploy/Image/1/',string(i),'.jpg'));
            imwrite(I,filename);
        case 5
            filename = char(strcat('deploy/Image/1/',string(i),'.jpg'));
            imwrite(I,filename);
        case 6
            filename = char(strcat('deploy/Image/1/',string(i),'.jpg'));
            imwrite(I,filename);
        case 7
            filename = char(strcat('deploy/Image/1/',string(i),'.jpg'));
            imwrite(I,filename);
        case 8 
            filename = char(strcat('deploy/Image/1/',string(i),'.jpg'));
            imwrite(I,filename);
        case 9
            filename = char(strcat('deploy/Image/1/',string(i),'.jpg'));
            imwrite(I,filename);
        case 10
            filename = char(strcat('deploy/Image/2/',string(i),'.jpg'));
            imwrite(I,filename);
        case 11
            filename = char(strcat('deploy/Image/2/',string(i),'.jpg'));
            imwrite(I,filename);
        case 12
            filename = char(strcat('deploy/Image/2/',string(i),'.jpg'));
            imwrite(I,filename);
        case 13
            filename = char(strcat('deploy/Image/2/',string(i),'.jpg'));
            imwrite(I,filename);
        case 14
            filename = char(strcat('deploy/Image/2/',string(i),'.jpg'));
            imwrite(I,filename);
        case 15
            filename = char(strcat('deploy/Image/2/',string(i),'.jpg'));
            imwrite(I,filename);
        case 16
            filename = char(strcat('deploy/Image/0/',string(i),'.jpg'));
            imwrite(I,filename);
        case 17
            filename = char(strcat('deploy/Image/0/',string(i),'.jpg'));
            imwrite(I,filename);
        case 18
            filename = char(strcat('deploy/Image/0/',string(i),'.jpg'));
            imwrite(I,filename);
        case 19
            filename = char(strcat('deploy/Image/0/',string(i),'.jpg'));
            imwrite(I,filename);
        case 20
            filename = char(strcat('deploy/Image/0/',string(i),'.jpg'));
            imwrite(I,filename);
        case 21
            filename = char(strcat('deploy/Image/0/',string(i),'.jpg'));
            imwrite(I,filename);
        case 22
            filename = char(strcat('deploy/Image/0/',string(i),'.jpg'));
            imwrite(I,filename);
        case 23
            filename = char(strcat('deploy/Image/0/',string(i),'.jpg'));
            imwrite(I,filename);
    end

end

end
end


%%
function data = read_bin(file_name)
id = fopen(file_name, 'r');
data = fread(id, inf, 'single');
fclose(id);
end
