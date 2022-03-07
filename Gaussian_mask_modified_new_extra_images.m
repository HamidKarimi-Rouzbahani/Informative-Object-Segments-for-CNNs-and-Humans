function [Subject]=Gaussian_mask_modified_new_extra_images(Subject)
image_name = Subject;
image_file_name = [image_name,'.JPEG'];
ax=imread(['Selected_mine/hammer/',image_file_name]);
x=1:size(ax,1);
y=1:size(ax,2);
bubbles=13;
L = sqrt(2*pi);
numberOfSamples = 400;
dict = containers.Map({ '1' '2' '3' '4' '5' '6' '7' '8' '9' '10' '11' '12' '13' '14' '15' }, {[1200 1900 2950] [800 1300 2400] [1500 5400 24000] [2300 3900 6200] [1400 2300 11100] [1600 7200 29000], [1200 1900 5000], [1400 2100 3400], [2300 4100 6600], [2100 2900 4100], [800 1300 1900], [700 1100 1950], [1300 1950 2600], [1100 1500 1900], [700 1300 1700] });
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
        imwrite(bubble_coll,['out_lower_sizes/' image_name '_' int2str(diam) '_' int2str(q) '_mask.jpg']);
        imwrite(uint8(repmat(bubble_coll,[1 1 3]).*double(ax)), ['out_lower_sizes/' image_name '_' int2str(diam) '_' int2str(q) '.jpg']);
        disp([ int2str(q) ' of ' int2str(numberOfSamples) ' in range ' int2str(diam) ' of ' image_name]);
    end
end