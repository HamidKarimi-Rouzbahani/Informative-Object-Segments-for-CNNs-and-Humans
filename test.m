

clear
clc
%addpath('/group/woolgar-lab/software/decoding_toolbox_v3.991/decoding_toolbox_v3.991');
image_list = {'hammer' 'pot' 'sewingmachine' 'elephant' 'handblower' 'pineapple' 'fish' 'violin' 'car' 'iron'};
for ax = 1:length(image_list)    
     disp(image_list(ax))
     [subject] = Gaussian_mask_modified(image_list(ax));    
end

delete(gcp('nocreate'));


