# Graphite Instructions
Instructions for using the graphite cluster.

## Getting an account
To get an account on Graphite
- You will need permission from either Geoff Pleiss (preferable), Jake Gardner (preferable), or Kilian Weinberger (but please bother someone else first.)
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

 
## List of useful commands
- `sbatch --requeue <my_job.sh>` - Run a (non-interactive) job. The optional arguments are:

- `srun --partition=interactive <my_job.sh>` - Run an interactive job
- `squeue -l` - Get list of active or recently completed jobs
- `scancel 183` - Cancel job with ID 183
- use a dataset on rtition. For interactive jobs, you should use the `sinfo -o %G,%N,%P` - Get info on GPUs available, the nodelist they are on, and the partition to use.

## Example job script
See [the example script](./example_script.sh)

## If you need help...
- Use the "#graphite" channel on the MLCircus Slack. **Please don't email Geoff/Jake/Kilian.**
