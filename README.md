# Graphite Instructions
Instructions for using the graphite cluster.

**Help keep this document up to date!** If you have any tips or tricks you want to add, please submit a PR!

## Getting an account
To get an account on Graphite
- You will need permission from either Geoff Pleiss (preferable), Jake Gardner (preferable), or Kilian Weinberger (but please bother someone else first).
- Send a [help-desk ticket](https://it.cornell.edu/coecis) asking for access to Graphite.
  Please cc whoever gave you permission to get an account (Geoff or Jake).
  **Don't directly email Michael for an account.**

## Best practices
- **Copy all datasets over to `/scratch/datasets`.**
  This should be the first step of every job you launch.
  Please do not read a dataset from your home directory or from NFS.
  It slows down the server for everyone.
- **Don't keep more than 10GB of data in your home folder.** 
  The graphite cluster is not intended for long-term storage of files.
- **Remove all files from `/scratch` after your job.** 
  If you frequently use a large dataset, you can keep it in `/scratch/datasets`.
  All other files **MUST** be removed from `/scratch`.
  Space on these drives is limited.
- **Create a personal anaconda environment for your Python libraries.** 
  This isn't required, but recommended.
  This will make it easy to use a specific version of PyTorch, Tensorflow, or whatever library you normally use.
  See [the anaconda docs](https://conda.io/docs/user-guide/tasks/manage-environments.html) for more info.
- **Run non-interactive jobs unless you are debugging your code.** 
  This isn't required, but recommended.
  Interactive jobs require more resources, and you'll be more efficient if you run scripted jobs.

## Launching jobs
All jobs, including interactive jobs, must be submitted to a specific partition (queue). For batch jobs, you should use the “default_gpu” partition.
For interactive jobs, you should use the “interactive” partition.

When submitting a job to either the “default_gpu” or “interactive” partition, there is a possibility that your job may be preempted.
If you use the switch “--requeue" with the sbatch command, your job will be resubmitted if it is preempted.

It is important to tell the scheduler what resources that your job will need.
The scheduler does not necessarily use the numbers that you give it to control your job, but it makes sure that (if each job accurately requests the resources needed) jobs won’t be scheduled on nodes that cannot support them or that are already too busy.

It is also important to tell your application what resources it can use.
For example, if you don’t limit a MATLAB job, it will use every core on every server that it is running on.
You need to either request every core for your job, or you need to tell MATLAB to limit its use.

The cluster scheduler is currently set up to kill a job that tries to use too much memory (more than the job asked for).
This behavior can be changed, but it emphasizes how important it is to know your jobs before you schedule them.

### Example job script
See [the example script](./example_script.sh)
 
## List of useful commands
- `sbatch --requeue <my_job.sh>` - Run a (non-interactive) job. The optional arguments are:

- `srun --partition=interactive <my_job.sh>` - Run an interactive job
- `squeue -l` - Get list of active or recently completed jobs
- `scancel 183` - Cancel job with ID 183
- `scontrol update nodelist=nikola-compute01 jobid=183` change the requested nodelist of the queued job 183 to nikola-compute01
- use a dataset on rtition. For interactive jobs, you should use the `sinfo -o %G,%N,%P` - Get info on GPUs available, the nodelist they are on, and the partition to use.

## If you're moving over from Nikola...
Your directory can be found in `/share/nikola/export`.

## If you need help...
- Use the "#graphite" channel on the MLCircus Slack. **Please don't email Geoff/Jake/Kilian.**


## Unofficial tips that Felix found useful
If the following things don't work, please contact Felix on slack. Don't bother Geoff/Jake/Kilian.

### Switching to Z shell
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
[oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh) with theme "ys" is recommended.

### Launching jupyter notebook on the cluster
The high level picture is to create an ssh tunnel from and end node that runs the jupyter server and the masker node (graphite), and create another ssh tunnel from your local machine to the graphite using the same port. Therefore, the message can flow from your local machine to graphite and then the end node.
To do so, we need an RSA key, so that the scrcipt can ssh to the master node (graphite) without asking for your password.

1. Create your RSA private and public keys on graphite
```sh
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```
Please leave the passkey empty and replace the email address with your own address.

2. Copy the private key to the authenticated key list.
```sh
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys # ensure that this file can only be read and written by yourself
```

3. Launch the first ssh connection from graphite to graphite to add graphite (ECDSA) to the list of known hosts by answering `yes`
```sh
ssh graphite 
```

4. Modify the [jupyter\_slurm.sh](./jupyter_slurm.sh) file and run:
```
sbatch jupyter_slurm.sh

```
The number of CPUs or GPUs, or memory usage can be set in the script.
You may set the port inside the script; otherwise it picks a random port in [6000, 9999].
After the job starts running you'll be able to see the standard output in `slurm-3060.out` if the job id is 3060. You'll be able to find the token you need to login for the first time unless a password has been set.
The port number is in `slurm-3060.out`. Let's say it's running on port 7446, then you can forward the local port by running this on *your desktop or laptop*:
```
ssh -NfL 7446:localhost:7446 graphite
```

Reference: [Utku's post](https://evcu.github.io/notes/port-forwarding/)

### Using older CUDA and CuDNN
This requires access to the nikola NFS `share/nikola/export/fw245`
- Ensure that your environment module works. If you use zsh, please add this line to your `~/.zshrc`.
```sh
module() { eval `/usr/bin/modulecmd zsh $*`; }
```
For bash users:
```sh
module() { eval `/usr/bin/modulecmd bash $*`; }
```
- Use `module avail` to see available modules such as CUDA or CuDNN versions
- Use `module use ~fw245/modulefiles` to use Felix's module files which include serveral versions of CUDA and CuDNN
- Use `module list` to see all module currently loaded
- Use `module add cuda/9.2 cudnn/v7.1-cuda-9.2` to use CUDA 9.2 with CuDNN v7.1 
- Use `module rm cuda cudnn` to remove any CUDA or CuDNN loaded

### For Slurm
#### sinfo
- To show detailed info of all partitions
```sh
sinfo -o "%15P %.5a %.10l %.10s %.4r %.8h %.10g %.6D %.11T %15G %N"
```
- To see how many GPUs on each machine
```sh
sinfo -o "%40N %G"
```

#### Useful aliases
You may add these lines to your `.bashrc` or `.zshrc`.
Due to the current graphite configuration, we are not allowed to see other's jobs `sq` and `sp` doesn't work. 
We rely on `sqa` as an alternative to print the lastest log written by a daemon job.
```sh
alias sq='squeue -o "%.9i %.9P %80j %.15u %.8T %.10M %.9l %.6D %R"' # squeue with some addition info
alias sqm='sq -u $USER' # sq for my jobs only
alias sqmo='squeue -o "%.9i %.9P %80j %.15u %.8T %.10M %.9l %.6D %R %o" -u $USER' # sqm + showing the command as well
alias sp='squeue -t PENDING -o "%.8Q %.10i %.3P %.9j %.6u %.2t %.16S %.10M %.10l %.5D %.12b %.2c %.4m %R" -S -t,-p,i | less -N ' # show all pending jobs
alias sia='sinfo -o "%15P %.5a %.10l %.10s %.4r %.8h %.10g %.6D %.11T %15G %N"'
alias sqa='ls -Art /share/nikola/export/graphite_usage/* | tail -n 1 | xargs cat'
```

#### Launching an interactive shell job
```sh
# launch zsh with 2 CPU, 1 GPU, 50M memory
srun --cpus-per-task 2 --gres=gpu:1 --mem=50M --partition=interactive --pty zsh
```
