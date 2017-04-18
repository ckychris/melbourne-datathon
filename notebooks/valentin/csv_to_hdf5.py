"""
Program used to create a unique HDF5 file from all the transaction csv files.
"""
# Standard library
import os
import glob
import time
from multiprocessing import Pool

# Not standard library 
import pandas as pd


def read_file(filename):
    """
    A function to read the patient csv files (so I can use multiprocessing on it).
    """
    print("Reading: {}".format(filename))
    datafr = pd.read_csv(filename,  sep = '\t', parse_dates = ['Dispense_Week', 'Prescription_Week'], index_col=[0, 1, 2, 3])
    return datafr


def main():
    fdir = os.path.join(DATA_DIR, 'patients_*.txt')
    # Generating a list of files.
    flist = glob.glob(fdir)

    st_time = time.time()

    # Using multiprocessing to read files.
    with Pool(8) as pool:
        trans_frame_list = pool.map(read_file, flist)

    rd_time = time.time()
    print("Reading took {} s.".format(rd_time - st_time))

    # One dataframe to rull them all and in the darkness bind them.
    megaframe = trans_frame_list[0]
    for trans_frame in trans_frame_list[1:]:
        megaframe = megaframe.append(trans_frame)

    mg_time = time.time()
    print("Merging took {} s.".format(mg_time - rd_time))

    # Saving all the data in HDF5 (I'm more comfortable with h5, but pandas allow you to export a SQL database.
    # Requires pytables
    data_output = os.path.join(DATA_DIR, "Transactions.h5")
    with pd.HDFStore(data_output, 'w', complevel=9, complib='blosc') as store:
        store['transactions'] = megaframe

    wr_time = time.time()
    print("Writing took {} s.".format(wr_time - mg_time))
    print("Everything done in {} s.".format(wr_time - st_time))
    
    return None
        
    
if __name__ == '__main__':
    # Path to the data directory.
    DATA_DIR = "/short/rr5/vhl548/data/Transactions/"
    
    main()
    
