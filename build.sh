#! /usr/bin/env bash

ROOT=`pwd`

# Pull the datasets

pushd data
wget -O gdrive https://docs.google.com/uc?id=0B3X9GlR6EmbnQ0FtZmJJUXEyRTA&export=download
chmod +x gdrive
./gdrive download 0B9t_F6MeU1IcTXZMMGpQNDFGQU0
# Unzip the password protected zipfile
unzip -P J34#PP3_MelbDatathon2017 MelbDatathon2017.zip
mkdir -p raw
mv MelbDatathon2017/* raw/
rm -rf MelbDatathon2017*

popd

# Pull and install miniconda

wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/conda
$HOME/conda/bin/conda config --add channels conda-forge
$HOME/conda/bin/conda update conda --yes
export PATH=$PATH:$HOME/conda/bin

# Switch to the setup directory
pushd setup

# Build and then activate the conda environment
conda env create -f environment.yml

# Activate the python environment
source activate kaggle

bash database.sh

popd
