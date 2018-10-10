# Unofficial tips that Felix found usefull

## Switching to z shell
Put these lines in your `~/.profile`.
```sh
# if running bash
# execute zsh
if [ "$SHELL" != "/bin/zsh"  ]
then
    export SHELL="/bin/zsh"
    exec /bin/zsh -l    # -l: login shell again
fi
```
[oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) with theme "ys" is highly recommended.

## Launching jupyter notebook on the cluster
Modify the [jupyter\_slurm.sh](./jupyter_slurm.sh) file and run
```
sbatch jupyter_slurm.sh
```
After the job starts running you'll be able to see the standard output in `slurm-3060.out` if the job id is 3060. You'll be able to find the token you need to login for the first time unless a password has been set.
You'll be able to see the port number in `slurm-3060.out`. Let's say it's running on port 7446, then you can forward the local port by
```
ssh -NfL 7446:localhost:7446 graphite
```


Reference: [Utku's post](https://evcu.github.io/notes/port-forwarding/)

## Using older CUDA and CuDNN
This requires access to the nikola NFS `share/nikola/export/fw245`
- Ensure that your environment module works. If you use zsh, please add this line to your `~/.zshrc`.
```
module() { eval `/usr/bin/modulecmd zsh $*`; }
```
- Use `module avail` to see available modules such as CUDA or CuDNN versions
- Use `module use ~fw245/modulefiles` to use Felix's module files which include serveral versions of CUDA and CuDNN
- Use `module list` to see all module currently loaded
- Use `module add cuda/9.2 cudnn/v7.3-cuda-9.2` to use CUDA 9.2 with CuDNN v7.3 
- Use `module rm cuda cudnn` to remove any CUDA or CuDNN loaded

## For Slurm
### sinfo
```
# to show detailed info of all partitions
sinfo -o "%15P %.5a %.10l %.10s %.4r %.8h %.10g %.6D %.11T %15G %N"
# to see how many GPUs on each machine
sinfo -o "%40N %G"
```

### Launching an interactive shell job
```
# launch zsh with 2 CPU, 1 GPU, 50M memory
srun --cpus-per-task 2 --gres=gpu:1 --mem=50M --partition=interactive --pty zsh
```
