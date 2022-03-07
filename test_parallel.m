
clear
clc
% addpath('/group/woolgar-lab/software/decoding_toolbox_v3.991/decoding_toolbox_v3.991');
% subs = [600 800 1000 1200 1400 1600 1800 2000 2200 2400 2600 2800 3000];
% subs = [100:500:5000 6000:2000:40000];

% subs = [3200 4900 9500];
subs = {'hammer','pot','sewingmachine','elephant','handblower','pineapple','fish','violin','car','iron'};

% open pool with right number of workers
nworkers = length(subs);
% open cbu parallel pool
P=cbupool(nworkers);
walltime_req = '15:00:00'; % good idea to check how long one iteration takes
%P.ResourceTemplate='-l nodes=^N^,mem=16GB,walltime=1:00:00'; %check whether increasing memory makes any difference to speed - it doesn't, and seems to be OK to prespecify the output matrix with just 4GB, so going with that
try
    P.ResourceTemplate=['-l nodes=^N^,mem=8GB,walltime=' walltime_req];
catch %for SLURM (new cluster), it's a different field...
    P.SubmitArguments=['--ntasks=' num2str(nworkers) ...
        ' --mem-per-cpu=8G --time=' walltime_req];
end
parpool(P,nworkers);


% send job for each sub to a different worker using parfor
tic();
% ax=imread('/group/woolgar-lab/projects/Hamid/Projects/ObjectSegments/orig/ILSVRC2012_test_00006710.JPEG');
parfor c = 1:length(subs)    
%      [subject] = create_gaussian_mask(subs(c))   
%      [subject] = Gaussian_mask_modified(subs(c))   
     [subject] = Gaussian_mask_modified_new(subs{c})
end
toc();

% close pool now
% matlabpool('close');
delete(gcp('nocreate'));
