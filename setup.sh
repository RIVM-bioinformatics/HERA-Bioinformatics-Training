#!/bin/bash

# Remove standard directories placed as a default by Colab
rm -rf /content/sample_data
mkdir -p example_data
mkdir -p source/
mkdir -p output_data/alignments output_data/adapter_removal output_data/quality_control output_data/primer_removal
bash -c "$(wget -q https://github.com/RIVM-bioinformatics/HERA-Bioinformatics-Training/tarball/main -O - | tar -xz -C source/ --strip-components=1)"

# get sample fastq file from ENA
wget -q ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR990/007/ERR9900947/ERR9900947.fastq.gz -O example_data/nanopore_fastq.fastq.gz & 
wget -q ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR408/008/ERR4082808/ERR4082808_1.fastq.gz -O example_data/illumina_fastq_1.fastq.gz &
wget -q ftp://ftp.sra.ebi.ac.uk/vol1/fastq/ERR408/008/ERR4082808/ERR4082808_2.fastq.gz -O example_data/illumina_fastq_2.fastq.gz &

## install miniconda and get some basic tools
wget -q https://repo.anaconda.com/miniconda/Miniconda3-py37_4.11.0-Linux-x86_64.sh
chmod +x Miniconda3-py37_4.11.0-Linux-x86_64.sh
./Miniconda3-py37_4.11.0-Linux-x86_64.sh -b -f -p /usr/local > /dev/null 2>&1
rm Miniconda3-py37_4.11.0-Linux-x86_64.sh

# setup the necessary channels
conda config --add channels anaconda
conda config --add channels intel
conda config --add channels conda-forge
conda config --add channels bioconda

# install mamba as a base package on the VM
conda install -q mamba==0.24.0 python=3.8 pip -y > /dev/null 2>&1

echo "Conda is installed as well as some fundamentals"
echo "Installing and preparing source material, this may take a while..."

# make a dedicated environment for every course section
mamba create -n Data_cleanup ampligone fastp -y > /dev/null 2>&1
mamba create -n Alignments minimap2 samtools bedtools pysam -y >/dev/null 2>&1
mamba create -n Consensus_seq longshot medaka bcftools pip -y >/dev/null 2>&1; source activate Consensus_seq; pip install git+https://github.com/RIVM-bioinformatics/TrueConsense.git@rewrite > /dev/null 2>&1; conda deactivate > /dev/null 2>&1

pip install igv-jupyter --quiet > /dev/null 2>&1


echo -e "\e[1m\e[32mDone with installing everything, you can now continue with the rest of the course.\e[39m"