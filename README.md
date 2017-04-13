# melbourne-datathon
Melbourne datathon notebooks and data processing scripts.

Manual Setup Steps:
  1. Visit https://conda.io/miniconda.html and download the Python 3.6 installer
  2. Run the installer, but don't set up the environment. Instead follow these instructions.

Automated Setup Scripts:
  1. 'sh basic.sh' <-- this will create the "dthon" Python environment with the
                       basic libraries to load and visualise the data

  2. 'sh advanced.sh' <-- this will add more comple scientific and data science
                          libraries for statistical modelling

Using the Environment:
  1. Run 'source activate dthon'. This will start you using the environment we just set up.
  2. Run 'jupyter notebook'. This will launch a web-based Python environment.


Working with the example notebooks:

Tennessee, Ioanna and Nathan will maintain a set of basic example notebooks in
the  directory 'notebooks/examples/' to demonstrate basic techniques.

About the directory layout:
-      scripts/ <-- command-line tools to execute a process
-      src/ <-- handy methods and functions for re-use
-      notebooks/
-         examples/ <-- showing based techniques
-         <name>/ <-- personal working directories
-      submissions/
-         <name>/  <-- put your submission files from your experiments here

Suggestions for good work practises:
   1. Whenever you make a submission that's an improvement, create a copy of
      that notebook and put a version number on it.
