function [Subject]=create_gaussian_mask(Subject)
diam=Subject;
bubbles=13;
Num_images=1600;
image_list = {'iron'};
% image_list = {'iron','hat','violin','pot'};

for i = 1:length(image_list)
    clearvars -except Num_images i diam bubbles image_list Subject
    image_name = image_list{i};
    image_file_name = [image_name,'.JPEG'];
    ax=imread(['/group/woolgar-lab/projects/Hamid/Projects/ObjectSegments/orig/',image_file_name]);
    x=1:size(ax,1);
    y=1:size(ax,2);
    for q = 1:Num_images
        clearvars bubble f
        covari=diam.*eye(2,2);
        bubble_coll=zeros(size(ax,1),size(ax,2));
        for bub=1:bubbles
            mu(1,1) = randi([0 size(ax,1)]);
            mu(2,1) = randi([0 size(ax,2)]);
            for i=1:size(ax,1)
                for j=1:size(ax,2)
                    f(i,j)=(1./(sqrt(2*pi)*sqrt(norm(covari))))*exp(-0.5*[[x(1,i);y(1,j)]-mu]'*inv(covari)*[[x(1,i);y(1,j)]-mu]);
                end
            end
            bubble=(f-min(min(f)))/(max(max(f))-min(min(f)));
            bubble_coll=bubble_coll+bubble;
        end
        bubble_coll=(bubble_coll-min(min(bubble_coll)))./((max(max(bubble_coll)))-min(min(bubble_coll)));
        
        [num2str(diam) image_name ' ' int2str(q) ' of ',num2str(Num_images)]
        imwrite(bubble_coll, ['out/' image_name '_' int2str(diam) '_' int2str(q) '.jpg']);
    end
end
end

