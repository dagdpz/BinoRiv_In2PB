function showImage(img,x,y)

if ~exist('x','var');
    x = 1:size(img,2);
end

if ndims(x)==2
    x = x(1,:);
end

if ~exist('y','var');
    y = 1:size(img,1);
end

if ndims(y) ==2
    y = y(:,1)';
end

imagesc(x,y,img)
axis equal
axis tight
colormap(gray);
