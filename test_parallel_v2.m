
clear
clc

% subs = { '1' ,'2' ,'3' ,'4' ,'5' ,'6' ,'7' ,'8' ,'9' ,'10' ,'11' ,'12' ,'13' ,'14' ,'15'};
subs = { '1' ,'2' ,'3' ,'4' ,'5' ,'6' ,'7' ,'8' ,'9' ,'10' ,'11' ,'12' ,'13' ,'14' ,'15'};

% open pool with right number of workers
nworkers = length(subs);
% open cbu parallel pool
P=cbupool(nworkers);
walltime_req = '10:00:00'; % good idea to check how long one iteration takes
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
     [subject] = Gaussian_mask_modified_new_extra_images(subs{c})
end
toc();

% close pool now
% matlabpool('close');
delete(gcp('nocreate'));
