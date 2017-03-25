%This script is going to build a picture, an all black picture of course,
%and plot the trajectories of 20 arbitrary points on it.
%I chose the picture to be black because trajectories are not necessarily
%going to have a meaning for a specific frame.
%If so, one can choose a frame, and then, from it's row in Mx and My,
%we can go back and draw.

%so, get one frame and make it black:
background = frames{1,1};
% background = zeros(size(background,1),size(background,2),size(background,3));

%choose 20 points:
points = selected_points(1,1:100);

%make the shapeInserter object:
shapeInserter = vision.ShapeInserter('Shape', 'Lines', 'BorderColor', 'Custom', 'CustomBorderColor', [255,0,0], 'LineWidth', 2);

%now for each point in our new point set (including 100 points):
for ii = 1:size(points,2)
    %get the point:
    i=points(1,ii);
    %begin sweeping:
    j = 1;
    while Mx(j,i) == 0
        j = j + 1;
    end
    %when you get to the non-zero, begin to track the path:
    checkpoint = j;
    %now track and plot the tracking:
    while Mx(j,i) ~= 0
        for k=1:size(Mx(checkpoint:j,i))
            if k > 1 && norm([round(Mx(checkpoint+k-1,i)), round(My(checkpoint+k-1,i))]-[round(Mx(checkpoint+k-2,i)), round(My(checkpoint+k-2,i))]) < 20
                background = step(shapeInserter, background, int32( [round(Mx(checkpoint+k-1,i)), round(My(checkpoint+k-1,i)), round(Mx(checkpoint+k-2,i)), round(My(checkpoint+k-2,i))]));
            end
        end
        j = j + 1;
    end
    %display the number of the point which it's trajectory is being
    %plotted.
    disp(ii);
end

%saving the trajectories that are plotted:
imwrite(background, 'trajectories.jpg');










