#!/bin/bash
#PBS -q large
#PBS -l nodes=1:ppn=20
#PBS -j oe
#PBS -o run.log
#PBS -N Brockes

cd /home/hpc/linss01/YuJu/Project/Brockes && free -g > memory.log
cd /home/hpc/linss01/YuJu/Project/Brockes && \
/home/hpc/linss01/CWLu/trinityrnaseq-2.2.0/Trinity \
--CPU 20 --max_memory 500G --seqType fq --SS_lib_type FR --KMER_SIZE 30 \
--left reads/310D0_R1.fastq.gz,reads/310D150_R1.fastq.gz,reads/310D15_R1.fastq.gz,reads/312D0_R1.fastq.gz,reads/312D150_R1.fastq.gz,reads/312D15_R1.fastq.gz,reads/32D0_R1.fastq.gz,reads/32D150_R1.fastq.gz,reads/32D15_R1.fastq.gz,reads/33D0_R1.fastq.gz,reads/33D150_R1.fastq.gz,reads/33D15_R1.fastq.gz,reads/34D0_R1.fastq.gz,reads/34D150_R1.fastq.gz,reads/34D15_R1.fastq.gz \
--right reads/310D0_R2.fastq.gz,reads/310D150_R2.fastq.gz,reads/310D15_R2.fastq.gz,reads/312D0_R2.fastq.gz,reads/312D150_R2.fastq.gz,reads/312D15_R2.fastq.gz,reads/32D0_R2.fastq.gz,reads/32D150_R2.fastq.gz,reads/32D15_R2.fastq.gz,reads/33D0_R2.fastq.gz,reads/33D150_R2.fastq.gz,reads/33D15_R2.fastq.gz,reads/34D0_R2.fastq.gz,reads/34D150_R2.fastq.gz,reads/34D15_R2.fastq.gz \
--output Trinity > brockes.log 2>&1
