#!/bin/bash
#SBATCH -J pbe_delta    # Job name
#SBATCH -o pbe_delta.o%j    # Name of stdout output file (%j expands to jobId)
#SBATCH -e pbe_delta.o%j    # Name of stderr output file
#SBATCH -N 1   # Total number of CPU nodes requested
#SBATCH -n 1   # Total number of CPU cores requrested
#SBATCH --mem=15000    # CPU Memory pool for all cores
#SBATCH -t 48:00:00    # Run time (hh:mm:ss)
#SBATCH --partition=default_gpu --gres=gpu:1   # Which queue to run on, and what resources to use
                                               # --partition=<queue> - Use the `<queue>` queue
                                               # --gres=gpu:1 - Use 1 GPU of any type
                                               # --gres=gpu:1080ti:1 - Use 1 GTX 1080TI GPU


# OPTIONAL: uncomment this if you're using an anaconda environment named <my_env_name>
# . /share/apps/anaconda3/5.2.0/etc/profile.d/conda.sh
# conda activate <my_env_name>


# OPTIONAL: uncomment this if you need to copy a dataset over to scratch
#    This checks to see if the dataset already exists
# if [ ! -d /scratch/datasets/<my_dataset> ]; then
#    cp -r </path/to/dataset/on/nfs/> /scratch/datasets/<my_dataset>
# fi

./<my_job.sh>
