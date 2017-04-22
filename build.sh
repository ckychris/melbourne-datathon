#! /usr/bin/env bash

ROOT=`pwd`

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

# Build the database
bash database.sh

# Retrieve the dataset
python retrieve.py

popd

pushd data

# Unzip the password protected zipfile
unzip -P J34#PP3_MelbDatathon2017 raw_data.zip

popd
