function [data,Data1] = demo1()
classes = {'Unknown', 'Compacts', 'Sedans', 'SUVs', 'Coupes', ...
    'Muscle', 'SportsClassics', 'Sports', 'Super', 'Motorcycles', ...
    'OffRoad', 'Industrial', 'Utility', 'Vans', 'Cycles', ...
    'Boats', 'Helicopters', 'Planes', 'Service', 'Emergency', ...
    'Military', 'Commercial', 'Trains'};

%%
files = dir('deploy/trainval/*/*_image.jpg');
files1 = dir('deploy/test/*/*_image.jpg');

% First row
snapshot = [files(1).folder, '/', files(1).name];

% xyz = read_bin(strrep(snapshot, '_image.jpg', '_cloud.bin'));
% xyz = reshape(xyz, [], 3)';


proj = read_bin(strrep(snapshot, '_image.jpg', '_proj.bin'));
proj = reshape(proj, [4, 3])';

try
    bbox = read_bin(strrep(snapshot, '_image.jpg', '_bbox.bin'));
catch
    disp('[*] no bbox found.')
    bbox = single([]);
end
bbox = reshape(bbox, [] , 11);

% uv = proj * [xyz; ones(1, size(xyz, 2))];
% uv = uv ./ uv(3, :);

%%
% clr = vecnorm(xyz);
% figure(1)
% clf()
% imshow(img)
% axis on
% hold on
% scatter(uv(1, :), uv(2, :), 1, clr, '.')
% 
% set(gcf, 'position', [100, 100, 800, 400])

%%
% figure(2)
% clf()
% pcshow(xyz.', clr)
% hold on
% axis equal
% axis([-50, 50. -40, 10, -10, 90])
% xlabel('x')
% ylabel('y')
% zlabel('z')
% view(gca, [-30, 15])
% 
% colors = [
%     0, 0.4470, 0.7410
%     0.8500, 0.3250, 0.0980
%     0.9290, 0.6940, 0.1250
%     0.4940, 0.1840, 0.5560
%     0.4660, 0.6740, 0.1880
%     0.3010, 0.7450, 0.9330
%     0.6350, 0.0780, 0.1840
% ];

for k = 1:size(bbox, 1)
    R = rot(bbox(k, 1:3));
    t = reshape(bbox(k, 4:6), [3, 1]);

    sz = bbox(k, 7:9);
    [vert_3D, edges] = get_bbox(-sz / 2, sz / 2);
    vert_3D = R * vert_3D + t;

    vert_2D = proj * [vert_3D; ones(1, size(vert_3D, 2))];
    vert_2D = vert_2D ./ vert_2D(3, :);

%     clr = colors(mod(k - 1, size(colors, 1)) + 1, :);
    for i = 1:size(edges, 2)
%         e = edges(:, i);

%         figure(1)
%         plot(vert_2D(1, e), vert_2D(2, e), 'color', clr)

%         figure(2)
%         plot3(vert_3D(1, e), vert_3D(2, e), vert_3D(3, e), 'color', clr)
        
    end
    
%     I = imread(snapshot);
    minx = min(vert_2D(1,:));
    miny = min(vert_2D(2,:));
    maxx = max(vert_2D(1,:));
    maxy = max(vert_2D(2,:));
    
%     figure(1)
%     plot(minx,miny,'o')
%     plot(maxx,miny,'o')
%     plot(maxx,maxy,'o')
%     plot(minx,maxy,'o')
    
    bbox2D = [minx miny maxx-minx maxy-miny];
    
%     I = insertShape(I,'Rectangle',bbox2D);
%     
%     figure(3)
%     imshow(I)
    
%     t = double(t);  % only needed for `text()`
    c = int64(bbox(k, 10)) + 1;
%     bbox(k,11) = 0;
%     ignore_in_eval = logical(bbox(k, 11));
%     if ignore_in_eval
%         text(t(1), t(2), t(3), c, 'color', 'r')
%     else
%         text(t(1), t(2), t(3), c)
%     end
    
%     Unknown = {[]};
%     Compacts = {[]};
%     Sedans  = {[]};
%     SUVs = {[]};
%     Coupes = {[]};
%     Muscle = {[]};
%     SportsClassics = {[]};
%     Sports = {[]};
%     Super = {[]};
%     Motorcycles = {[]};
%     OffRoad = {[]};
%     Industrial = {[]};
%     Utility = {[]};
%     Vans = {[]};
%     Cycles = {[]};
%     Boats = {[]};
%     Helicopters = {[]};
%     Planes = {[]};
%     Service = {[]};
%     Emergency = {[]};
%     Military = {[]};
%     Commercial = {[]};
%     Trains = {[]};
%     
%     
%     switch c
%         case 1
%             Unknown = {bbox2D};
%         case 2
%             Compacts = {bbox2D};
%         case 3
%             Sedans = {bbox2D};
%         case 4
%             SUVs = {bbox2D};
%         case 5
%             Coupes = {bbox2D};
%         case 6
%             Muscle = {bbox2D};
%         case 7
%             SportsClassics = {bbox2D};
%         case 8 
%             Sports = {bbox2D};
%         case 9
%             Super = {bbox2D};
%         case 10
%             Motorcycles = {bbox2D};
%         case 11
%             OffRoad = {bbox2D};
%         case 12
%             Industrial = {bbox2D};
%         case 13
%             Utility = {bbox2D};
%         case 14
%             Vans = {bbox2D};
%         case 15
%             Cycles = {bbox2D};
%         case 16
%             Boats = {bbox2D};
%         case 17
%             Helicopters = {bbox2D};
%         case 18
%             Planes = {bbox2D};
%         case 19
%             Service = {bbox2D};
%         case 20
%             Emergency = {bbox2D};
%         case 21
%             Military = {bbox2D};
%         case 22
%             Commercial = {bbox2D};
%         case 23
%             Trains = {bbox2D};
%     end


    x = {[]};
    y = {[]};
    z = {[]};
    
    I = imread(snapshot);
%     I = rgb2gray(I);
    
    switch c
%         case 1
%             Unknown = {bbox2D};
        case 2
            x = {bbox2D};
            imwrite(I,'deploy/Image/1/1.jpg');
        case 3
            x = {bbox2D};
            imwrite(I,'deploy/Image/1/1.jpg');
        case 4
            x = {bbox2D};
            iimwrite(I,'deploy/Image/1/1.jpg');
        case 5
            x = {bbox2D};
            imwrite(I,'deploy/Image/1/1.jpg');
        case 6
            x = {bbox2D};
            imwrite(I,'deploy/Image/1/1.jpg');
        case 7
            x = {bbox2D};
            imwrite(I,'deploy/Image/1/1.jpg');
        case 8 
            x = {bbox2D};
            imwrite(I,'deploy/Image/1/1.jpg');
        case 9
            x = {bbox2D};
            imwrite(I,'deploy/Image/1/1.jpg');
        case 10
            y = {bbox2D};
            imwrite(I,'deploy/Image/2/1.jpg');
        case 11
            y = {bbox2D};
            imwrite(I,'deploy/Image/2/1.jpg');
        case 12
            y = {bbox2D};
            imwrite(I,'deploy/Image/2/1.jpg');
        case 13
            y = {bbox2D};
            imwrite(I,'deploy/Image/2/1.jpg');
        case 14
            y = {bbox2D};
            imwrite(I,'deploy/Image/2/1.jpg');
        case 15
            y = {bbox2D};
            imwrite(I,'deploy/Image/2/1.jpg');
        case 16
            z = {bbox2D};
            imwrite(I,'deploy/Image/0/1.jpg');
        case 17
            z = {bbox2D};
            imwrite(I,'deploy/Image/0/1.jpg');
        case 18
            z = {bbox2D};
            imwrite(I,'deploy/Image/0/1.jpg');
        case 19
            z = {bbox2D};
            imwrite(I,'deploy/Image/0/1.jpg');
        case 20
            z = {bbox2D};
            imwrite(I,'deploy/Image/0/1.jpg');
        case 21
            z = {bbox2D};
            imwrite(I,'deploy/Image/0/1.jpg');
        case 22
            z = {bbox2D};
            imwrite(I,'deploy/Image/0/1.jpg');
        case 23
            z = {bbox2D};
            imwrite(I,'deploy/Image/0/1.jpg');
    end
    
    
end

%%
% figure(2)
% I = eye(3);
% for k = 1:3
%     plot3([0, I(1, k)], [0, I(2, k)], [0, I(3, k)], 'color', I(:, k))
% end
s = {char(snapshot)};
% b = {bbox2D};
data = table(s,x,y,z);

for i = 2:numel(files)
%     i
    snapshot = [files(i).folder, '/', files(i).name];



% xyz = read_bin(strrep(snapshot, '_image.jpg', '_cloud.bin'));
% xyz = reshape(xyz, [], 3)';


proj = read_bin(strrep(snapshot, '_image.jpg', '_proj.bin'));
proj = reshape(proj, [4, 3])';

try
    bbox = read_bin(strrep(snapshot, '_image.jpg', '_bbox.bin'));
catch
    disp('[*] no bbox found.')
    bbox = single([]);
end
bbox = reshape(bbox, [] , 11);

% uv = proj * [xyz; ones(1, size(xyz, 2))];
% uv = uv ./ uv(3, :);

%%
% clr = vecnorm(xyz);
% figure(1)
% clf()
% imshow(img)
% axis on
% hold on
% scatter(uv(1, :), uv(2, :), 1, clr, '.')
% 
% set(gcf, 'position', [100, 100, 800, 400])

%%
% figure(2)
% clf()
% pcshow(xyz.', clr)
% hold on
% axis equal
% axis([-50, 50. -40, 10, -10, 90])
% xlabel('x')
% ylabel('y')
% zlabel('z')
% view(gca, [-30, 15])

% colors = [
%     0, 0.4470, 0.7410
%     0.8500, 0.3250, 0.0980
%     0.9290, 0.6940, 0.1250
%     0.4940, 0.1840, 0.5560
%     0.4660, 0.6740, 0.1880
%     0.3010, 0.7450, 0.9330
%     0.6350, 0.0780, 0.1840
% ];

for k = 1:size(bbox)
    R = rot(bbox(k, 1:3));
    t = reshape(bbox(k, 4:6), [3, 1]);

    sz = bbox(k, 7:9);
    [vert_3D, ~] = get_bbox(-sz / 2, sz / 2);
    vert_3D = R * vert_3D + t;

    vert_2D = proj * [vert_3D; ones(1, size(vert_3D, 2))];
    vert_2D = vert_2D ./ vert_2D(3, :);
    
%     I = imread(snapshot);
    minx = min(vert_2D(1,:));
    miny = min(vert_2D(2,:));
    maxx = max(vert_2D(1,:));
    maxy = max(vert_2D(2,:));
    
%     figure(1)
%     plot(minx,miny,'o')
%     plot(maxx,miny,'o')
%     plot(maxx,maxy,'o')
%     plot(minx,maxy,'o')
    
    bbox2D = [minx miny maxx-minx maxy-miny];
    
    s = {char(snapshot)};
%     b = {bbox2D};

    
%     I = insertShape(I,'Rectangle',bbox2D);
%     
%     figure(3)
%     imshow(I)
    
%     t = double(t);  % only needed for `text()`
%     bbox(k, 10) + 1
    c = int64(bbox(k, 10)) + 1;
%     bbox(k,11) = 0;
%     ignore_in_eval = logical(bbox(k, 11));
    

%     Unknown = {[]};
%     Compacts = {[]};
%     Sedans  = {[]};
%     SUVs = {[]};
%     Coupes = {[]};
%     Muscle = {[]};
%     SportsClassics = {[]};
%     Sports = {[]};
%     Super = {[]};
%     Motorcycles = {[]};
%     OffRoad = {[]};
%     Industrial = {[]};
%     Utility = {[]};
%     Vans = {[]};
%     Cycles = {[]};
%     Boats = {[]};
%     Helicopters = {[]};
%     Planes = {[]};
%     Service = {[]};
%     Emergency = {[]};
%     Military = {[]};
%     Commercial = {[]};
%     Trains = {[]};
%     
%     
%     switch c
%         case 1
%             Unknown = {bbox2D};
%         case 2
%             Compacts = {bbox2D};
%         case 3
%             Sedans = {bbox2D};
%         case 4
%             SUVs = {bbox2D};
%         case 5
%             Coupes = {bbox2D};
%         case 6
%             Muscle = {bbox2D};
%         case 7
%             SportsClassics = {bbox2D};
%         case 8 
%             Sports = {bbox2D};
%         case 9
%             Super = {bbox2D};
%         case 10
%             Motorcycles = {bbox2D};
%         case 11
%             OffRoad = {bbox2D};
%         case 12
%             Industrial = {bbox2D};
%         case 13
%             Utility = {bbox2D};
%         case 14
%             Vans = {bbox2D};
%         case 15
%             Cycles = {bbox2D};
%         case 16
%             Boats = {bbox2D};
%         case 17
%             Helicopters = {bbox2D};
%         case 18
%             Planes = {bbox2D};
%         case 19
%             Service = {bbox2D};
%         case 20
%             Emergency = {bbox2D};
%         case 21
%             Military = {bbox2D};
%         case 22
%             Commercial = {bbox2D};
%         case 23
%             Trains = {bbox2D};
%     end


    x = {[]};
    y = {[]};
    z = {[]};
    
    I = imread(snapshot);
%     I = rgb2gray(I);
%     
%     strcat('deploy/Image/1/',string(i),'.jpg');
    
    switch c
%         case 1
%             Unknown = {bbox2D};
        case 2
            x = {bbox2D};
            filename = char(strcat('deploy/Image/1/',string(i),'.jpg'));
            imwrite(I,filename);
        case 3
            x = {bbox2D};
            filename = char(strcat('deploy/Image/1/',string(i),'.jpg'));
            imwrite(I,filename);
        case 4
            x = {bbox2D};
            filename = char(strcat('deploy/Image/1/',string(i),'.jpg'));
            imwrite(I,filename);
        case 5
            x = {bbox2D};
            filename = char(strcat('deploy/Image/1/',string(i),'.jpg'));
            imwrite(I,filename);
        case 6
            x = {bbox2D};
            filename = char(strcat('deploy/Image/1/',string(i),'.jpg'));
            imwrite(I,filename);
        case 7
            x = {bbox2D};
            filename = char(strcat('deploy/Image/1/',string(i),'.jpg'));
            imwrite(I,filename);
        case 8 
            x = {bbox2D};
            filename = char(strcat('deploy/Image/1/',string(i),'.jpg'));
            imwrite(I,filename);
        case 9
            x = {bbox2D};
            filename = char(strcat('deploy/Image/1/',string(i),'.jpg'));
            imwrite(I,filename);
        case 10
            y = {bbox2D};
            filename = char(strcat('deploy/Image/2/',string(i),'.jpg'));
            imwrite(I,filename);
        case 11
            y = {bbox2D};
            filename = char(strcat('deploy/Image/2/',string(i),'.jpg'));
            imwrite(I,filename);
        case 12
            y = {bbox2D};
            filename = char(strcat('deploy/Image/2/',string(i),'.jpg'));
            imwrite(I,filename);
        case 13
            y = {bbox2D};
            filename = char(strcat('deploy/Image/2/',string(i),'.jpg'));
            imwrite(I,filename);
        case 14
            y = {bbox2D};
            filename = char(strcat('deploy/Image/2/',string(i),'.jpg'));
            imwrite(I,filename);
        case 15
            y = {bbox2D};
            filename = char(strcat('deploy/Image/2/',string(i),'.jpg'));
            imwrite(I,filename);
        case 16
            z = {bbox2D};
            filename = char(strcat('deploy/Image/0/',string(i),'.jpg'));
            imwrite(I,filename);
        case 17
            z = {bbox2D};
            filename = char(strcat('deploy/Image/0/',string(i),'.jpg'));
            imwrite(I,filename);
        case 18
            z = {bbox2D};
            filename = char(strcat('deploy/Image/0/',string(i),'.jpg'));
            imwrite(I,filename);
        case 19
            z = {bbox2D};
            filename = char(strcat('deploy/Image/0/',string(i),'.jpg'));
            imwrite(I,filename);
        case 20
            z = {bbox2D};
            filename = char(strcat('deploy/Image/0/',string(i),'.jpg'));
            imwrite(I,filename);
        case 21
            z = {bbox2D};
            filename = char(strcat('deploy/Image/0/',string(i),'.jpg'));
            imwrite(I,filename);
        case 22
            z = {bbox2D};
            filename = char(strcat('deploy/Image/0/',string(i),'.jpg'));
            imwrite(I,filename);
        case 23
            z = {bbox2D};
            filename = char(strcat('deploy/Image/0/',string(i),'.jpg'));
            imwrite(I,filename);
    end
    
    T2 = table(s,x,y,z);
    data = [data; T2];
%     if ignore_in_eval
%         text(t(1), t(2), t(3), c, 'color', 'r')
%     else
%         text(t(1), t(2), t(3), c)
%     end
    
    
    
end

%%
% figure(2)
% I = eye(3);
% for k = 1:3
%     plot3([0, I(1, k)], [0, I(2, k)], [0, I(3, k)], 'color', I(:, k))
% end



end

snapshot2 = [files1(1).folder, '/', files1(1).name];
s1 = {char(snapshot2)};
Data1 = table(s1);
for j = 2:numel(files1)
    snapshot2 = [files1(j).folder, '/', files1(j).name];
    s1 = {char(snapshot2)};
    Data1 = [Data1; table(s1)];
end

%     save('demodata.mat','data','-append');
%     save('demodata.mat','Data1','-append');
end


%%
function [v, e] = get_bbox(p1, p2)
v = [p1(1), p1(1), p1(1), p1(1), p2(1), p2(1), p2(1), p2(1)
    p1(2), p1(2), p2(2), p2(2), p1(2), p1(2), p2(2), p2(2)
    p1(3), p2(3), p1(3), p2(3), p1(3), p2(3), p1(3), p2(3)];
e = [3, 4, 1, 1, 4, 4, 1, 2, 3, 4, 5, 5, 8, 8
    8, 7, 2, 3, 2, 3, 5, 6, 7, 8, 6, 7, 6, 7];
end

%%
function R = rot(n)
theta = norm(n, 2);
if theta
  n = n / theta;
  K = [0, -n(3), n(2); n(3), 0, -n(1); -n(2), n(1), 0];
  R = eye(3) + sin(theta) * K + (1 - cos(theta)) * K^2;
else
  R = eye(3);
end
end

%%
function data = read_bin(file_name)
id = fopen(file_name, 'r');
data = fread(id, inf, 'single');
fclose(id);
end
