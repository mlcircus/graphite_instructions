#!/bin/bash
#SBATCH --job-name=jupyterTest
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:0
#SBATCH --mem=8GB
#SBATCH --time=1:00:00

# modified from https://evcu.github.io/notes/port-forwarding/

# Load necessary modules (uncomment when needed)
# module use ~fw245/modulefiles
# module rm cuda cudnn
# module add cuda/9.0 cudnn/v7.0-cuda-9.0

#Go to the folder you wanna run jupyter in
cd $HOME
export XDG_RUNTIME_DIR=""

#Pick a random or predefined port
port=$(shuf -i 6000-9999 -n 1)
# port=8765

#Forward the picked port to the prince on the same port. Here log-x is set to be the prince login node.
/usr/bin/ssh -N -f -R $port:localhost:$port graphite

#Start the notebook
jupyter notebook --no-browser --port $port
