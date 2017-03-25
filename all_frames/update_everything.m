function [Mx, My, super_descriptor]=update_everything(Mx, My, super_descriptor, Fnew, Dnew)
%in this function, we take the step forward. let's do this:

%first, we have to perform a matching, to do so, we do this:
indices = find(Mx(end,:));

%now we extract the subset of the super_descriptor, that we want
%to match using that.
descriptor_to_compare = super_descriptor(:,indices);

%find the matches, and map the indices back to the real ones:
matches = vl_ubcmatch(descriptor_to_compare, Dnew);
matches(1,:) = indices(matches(1,:));

%compute a shift:
shift = size(Mx,2);

%now, it's time to extend the matrix:
Mx = [Mx, zeros(size(Mx,1), size(Fnew,2)-size(matches,2))];
My = [My, zeros(size(My,1), size(Fnew,2)-size(matches,2))];
%and the new line, for the new frame:
Mx = [Mx; zeros(1,size(Mx,2))];
My = [My; zeros(1,size(My,2))];

%time to add the new things:
Mx(end, matches(1,:)) = Fnew(1, matches(2,:));
My(end, matches(1,:)) = Fnew(2, matches(2,:));

%now wipe the Fnew and Dnew of the matched points, add up the extra
%points to our set:
Fnew(:, matches(2,:))=[];
Mx(end, shift+1:shift+size(Fnew,2)) = Fnew(1,:);
My(end, shift+1:shift+size(Fnew,2)) = Fnew(2,:);

%wrap it up, end this:
Dnew(:, matches(2,:))=[];
super_descriptor = [super_descriptor, Dnew];


end