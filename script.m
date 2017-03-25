%%%%%%%%%%%%%%%%%%%%%%%%
%% FP TRACKING        %%
%% Shayan Fazeli      %%
%% 91102171           %%
%%%%%%%%%%%%%%%%%%%%%%%%

%preparing the script:
clear all;
close all;
clc;

%moving to the folder of the images:
cd all_frames;

%reading the frames into a huge cell array:
frames = cell(1523,1);

for i = 1:1523
    frames{i,1} = imread(['frame', sprintf('%.3d',i), '.bmp']);
end

%%%%%%%%%%%%%%%%%% BUILDING MX AND MY %%%%%%%%%%%%%%%%%%%%
%For the sake of speed, this section can be commented.


%now, we have to work with the frames. let's run the sift, using an
%appropriate value (selected empirically) for the PeakThresh, on frame 1:
[F1, D1] = vl_sift(im2single(rgb2gray(frames{1,1})), 'PeakThresh',0.05);

%okay, now we need to construct the matrix which was talked about in the
%class. to do so, we define, two matrices. MX, and MY. each one will
%contain one portion of the coordinates of the feature points. each
%element, if non-zero, indicates the existence of one feature point in our
%view.

%x coordinates:
Mx = F1(1,:);
%y coordinates:
My = F1(2,:);
%descriptors superset:
super_descriptor = D1;

%now, we have to read all the frames, perform sift, then update the
%dimensions and containings of these two matrices.

%build a waitbar:
prcnt = 0;
h=waitbar(prcnt, 'Please wait...');

for i = 1:1523
    if mod(i,50)==1
        prcnt = (i)/(1523);
        waitbar(prcnt, h, sprintf('Please wait... \n%d%%',floor(100*prcnt) ));
    end
    if mod(i,1)==0
        [Fnew, Dnew] = vl_sift(im2single(rgb2gray(frames{i,1})),'PeakThresh', 0.05);
        [Mx, My, super_descriptor]=update_everything(Mx, My, super_descriptor, Fnew, Dnew);
    end
end
waitbar(1, h, sprintf('Done. \n%d%%',floor(100) ));
close(h);


%There's no need to rerun the code above. Matrices are saved as
%'MxAll.mat' and 'MyAll.mat'. load them and continue.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cd ..;

%time to demonstrate...
selected_points = 1:122393;
temp = Mx(:,1:122393);
temp = (temp~=0);
temp = sum(temp,1);
a = or((temp > 17),(temp<4));
selected_points = selected_points(1,~a);

finish_it;

%THE END

