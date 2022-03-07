function [Subject]=Gaussian_mask_modified_new(Subject)
image_name = Subject;
image_file_name = [image_name,'.JPEG'];
ax=imread(['orig/',image_file_name]);
x=1:size(ax,1);
y=1:size(ax,2);
bubbles=13;
L = sqrt(2*pi);
numberOfSamples = 900;
dict = containers.Map({ 'hammer' 'pot' 'sewingmachine' 'elephant' 'handblower' 'pineapple' 'fish' 'violin' 'car' 'iron' }, { [3000 4000 20000], [900 1400 1850], [1300 1950 2850], [5800 7800 12000], [3200 4900 9500], [1950 3200 5100], [600 850 1200], [6200 14000 22000], [2700 4100 6200], [2500 3100 4000] });
diam_list = dict(Subject);

for i = 1:length(diam_list)
    diam = diam_list(i);
    clear f;
    for q = 1:numberOfSamples
        covari=diam.*eye(2,2);
        Q = sqrt(norm(covari));
        b = inv(covari);
        bubble_coll=zeros(size(ax,1),size(ax,2));
        for bub=1:bubbles
            mu(1,1) = randi([0 size(ax,1)]);
            mu(2,1) = randi([0 size(ax,2)]);
            for i=1:size(ax,1)
                for j=1:size(ax,2)
                    m = [x(1,i);y(1,j)];
                    a = [m-mu]';
                    c = [[x(1,i);y(1,j)]-mu];
                    temp = exp(-0.5*a*b*c);
                    f(i,j)=(1./(L*Q))*temp;
                end
            end
            bubble=(f-min(min(f)))/(max(max(f))-min(min(f)));
            bubble_coll=bubble_coll+bubble;
        end
        bubble_coll=(bubble_coll-min(min(bubble_coll)))./((max(max(bubble_coll)))-min(min(bubble_coll)));
%         [mean(mean(bubble_coll)) median(median(bubble_coll)) max(max(bubble_coll)) min(min(bubble_coll))];
        imwrite(bubble_coll,['out_lower_sizes/' image_name '_' int2str(diam) '_' int2str(q) '_mask.jpg']);
        imwrite(uint8(repmat(bubble_coll,[1 1 3]).*double(ax)), ['out_lower_sizes/' image_name '_' int2str(diam) '_' int2str(q) '.jpg']);
        disp([ int2str(q) ' of ' int2str(numberOfSamples) ' in range ' int2str(diam) ' of ' image_name]);
    end
end