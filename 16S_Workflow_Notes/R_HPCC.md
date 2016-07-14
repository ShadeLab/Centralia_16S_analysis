##adephylo on R, on the HPCC
#log on to the HPCC, navigate to the directory
#load different compilers

```
module load GNU/4.9 OpenMPI/1.10.0
module load R/3.2.3
```


qsub

#!/bin/sh -login
#Example PBS script to run R
#PBS -l nodes=1:ppn=1,walltime=00:10:00,mem=1gb
#PBS -N Adephylo_28Mar16

cd $PBS_O_WORKDIR
module load GNU/4.9 OpenMPI/1.10.0
module load R/3.2.3
export R_LIBS_USER=~/R/library

#Save output
Rscript adephylo2.R --save


#PBS stats
cat ${PBS_NODEFILE}
env | grep PBS
# capture details of job for diagnostics
qstat -f $PBS_JOBID
