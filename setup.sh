#!/bin/bash

## Remove standard directories placed as a default by Colab
rm -rf /content/sample_data
mkdir example_data
mkdir source/
bash -c "$(wget https://github.com/RIVM-bioinformatics/HERA-Bioinformatics-Training/tarball/main -O - | tar -xz -C source_material/ --strip-components=1)" > /dev/null 2>&1

## install miniconda and get some basic tools
wget -q https://repo.anaconda.com/miniconda/Miniconda3-py37_4.11.0-Linux-x86_64.sh
chmod +x Miniconda3-py37_4.11.0-Linux-x86_64.sh
./Miniconda3-py37_4.11.0-Linux-x86_64.sh -b -f -p /usr/local > /dev/null 2>&1
rm Miniconda3-py37_4.11.0-Linux-x86_64.sh

echo "Conda is installed."
echo "Installing and preparing source material, this may take a while..."

# setup the necessary channels
conda config --add channels conda-forge
conda config --add channels bioconda
conda config --add channels intel
conda config --add channels anaconda


# install mamba as a base package on the VM
conda install -q mamba==0.24.0 python=3.8 -y > /dev/null 2>&1

# make a dedicated environment for every course section
mamba create -n Data_cleanup ampligone fastp -y > /dev/null 2>&1
mamba create -n Alignments minimap2 bwa-mem2 bowtie2 samtools -y >/dev/null 2>&1
mamba create -n Consensus_seq longshot medaka bcftools pip -y >/dev/null 2>&1; conda activate Consensus_seq; pip install git+https://github.com/RIVM-bioinformatics/TrueConsense.git@rewrite > /dev/null 2>&1; conda deactivate > /dev/null 2>&1


# sample fastq file from ENA
# wget -q ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR118/078/SRR11844878/SRR11844878_1.fastq.gz -O example_data/sars-cov-2_hong_kong_example.fastq.gz & 

## fetch the reference genome from NCBI
# wget -q https://raw.githubusercontent.com/RIVM-bioinformatics/SARS2seq/main/SARS2seq/workflow/files/MN908947.fasta -O example_data/sars-cov-2_reference.fasta &
