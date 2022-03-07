clc;
clear all;
close all;

diam=20000;
% for diam=[600 2000 5000 10000 20000]
for diam=[100 300 600 1000 3000:4000:20000]
    clearvars -except diam
    bubbles=13;
    ax=imread('ILSVRC2012_test_00095564.JPEG');
    x=1:size(ax,1);
    y=1:size(ax,2);
    for q = 1:1
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
        
        figure
        subplot(131)
        imshow(ax)
        subplot(132)
        imshow(uint8(bubble_coll*255))
        subplot(133)
        imshow(uint8(repmat(bubble_coll,[1 1 3]).*double(ax)))
        [mean(mean(bubble_coll)) median(median(bubble_coll)) max(max(bubble_coll)) min(min(bubble_coll))]
        
    end
end
