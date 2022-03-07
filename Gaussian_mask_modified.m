function [Subject]=Gaussian_mask_modified(Subject)

diam=Subject;
bubbles=13;
image_list = {'handblower'};
%  image_list = {'pineapple'};
% image_list = {'elephant','car','fish','hammer','handblower','pineapple','sewingmachine'};

L = sqrt(2*pi);
for i = 1:length(image_list)
    image_name = image_list{i};
    image_file_name = [image_name,'.JPEG'];
    ax=imread(['/group/woolgar-lab/projects/Hamid/Projects/ObjectSegments/orig/',image_file_name]);
    x=1:size(ax,1);
    y=1:size(ax,2);
    for q = 1:1600
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
        imwrite(bubble_coll,['out/' image_name '_' int2str(diam) '_' int2str(q) '_mask.jpg']);
        imwrite(uint8(repmat(bubble_coll,[1 1 3]).*double(ax)), ['out/' image_name '_' int2str(diam) '_' int2str(q) '.jpg']);
        disp([ int2str(q) ' of 1600 in range ' int2str(diam) ' of ' image_name]);
    end
end