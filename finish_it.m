%%%%%%%%%%%%%%%%%%%%%%%%
%% Question 2 - HW1   %%
%% Shayan Fazeli      %%
%% 91102171           %%
%%%%%%%%%%%%%%%%%%%%%%%%
%in this script, we want to demonstrate the points on the final video:

%so, for each selected point, we track the whole thing:
frames_1=frames;
shapeInserter = vision.ShapeInserter('Shape', 'Lines', 'BorderColor', 'Custom', 'CustomBorderColor', [255,0,0], 'LineWidth', 2);
 for ii = 1:500  
      i=selected_points(1,ii);
    j = 1;
    while Mx(j,i) == 0
       j = j + 1;
    end
    checkpoint = j;
    while Mx(j,i) ~= 0
        
        for k=1:size(Mx(checkpoint:j,i))
             frames_1{j,1}=insertShape(frames_1{j,1}, 'circle', [round(Mx(checkpoint+k-1,i)), round(My(checkpoint+k-1,i)) 3]);
             if k > 1 && norm([round(Mx(checkpoint+k-1,i)), round(My(checkpoint+k-1,i))]-[round(Mx(checkpoint+k-2,i)), round(My(checkpoint+k-2,i))]) < 20
                frames_1{j,1} = step(shapeInserter, frames_1{j,1}, int32( [round(Mx(checkpoint+k-1,i)), round(My(checkpoint+k-1,i)), round(Mx(checkpoint+k-2,i)), round(My(checkpoint+k-2,i))]));
             end
        end
        frames_1{j,1}=insertShape(frames_1{j,1}, 'circle', [round(Mx(j,i)), round(My(j,i)) 10]);
       j = j + 1;

    end
    disp(ii);
 end


mkdir newframes;
cd newframes;
for i = 1:1523
    imwrite(frames_1{i,1}, ['frame', sprintf('%.3d', i), '.bmp']);
end

cd ..;

%THE END
