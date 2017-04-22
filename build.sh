#! /usr/bin/env bash

ROOT=`pwd`

# Pull the data for the experiment

pushd data
wget -O gdrive "https://docs.google.com/uc?id=0B3X9GlR6EmbnQ0FtZmJJUXEyRTA&export=download"
chmod +x gdrive
./gdrive download 0B9t_F6MeU1IcTXZMMGpQNDFGQU0
unzip -P J34#PP3_MelbDatathon2017 MelbDatathon2017.zip
mv -f MelbDatathon2017 raw
popd

# Pull and install miniconda

wget https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh
bash Miniconda3-latest-Linux-x86_64.sh -b -p $HOME/conda
$HOME/conda/bin/conda config --add channels conda-forge
$HOME/conda/bin/conda update conda --yes
export PATH=$PATH:$HOME/conda/bin

# Switch to the setup directory, create the conda env and build the database.
pushd setup
$HOME/conda/bin/conda env create -f environment.yml
bash database.sh
popd

# Start the jupyter notebook
$HOME/conda/envs/kaggle/bin/jupyter notebook --generate-config
# password: bomfire
echo "c.NotebookApp.password = u'sha1:0c7fecc29fdf:4be26cf9954721c3d36a6d48781e85c94ce078f7'" >> ~/.jupyter/jupyter_notebook_config.py

$HOME/conda/envs/kaggle/bin/jupyter notebook --no-browser -y --ip=*
