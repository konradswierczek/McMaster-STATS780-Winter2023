"""
Konrad Swierczek
Extract PCD from .mid files.
"""
# Requires music21
import os
import fnmatch
import pandas as pd
from music21 import *

########################################################################
# recursive file parse
def folder_parse(folder_path):
    """
    """
    filepaths = []
    sub_paths = os.listdir(folder_path)
    for path in sub_paths:
        if "." not in path:
            filepaths.append([path + "/" + filename for filename in os.listdir(folder_path + "/" + path)])
        else:
            continue
    return [item for sublist in filepaths for item in sublist]

########################################################################
# music21 method.
def music21_pcd(filepath, output = 'proportion'):
    """ Pitch Class Distribution weighted with quarter length durations. 
    """
    try:
        sStream = converter.parse(filepath)
        a = analysis.discrete.KrumhanslSchmuckler()
        flatstream = sStream.flatten().notesAndRests
        pcd = a._getPitchClassDistribution(flatstream)
        if output == 'quarterLength':
            return {key: pcd[key] for key in range(0,12)}
        elif output == 'proportion':
            pcd = [key/sum(pcd) for key in pcd]
            return {key: round(pcd[key],3) for key in range(0,12)}
        else:
            # make an error
            return "Specify method 'proportion' or 'quarterLength'"
    except:
        return {key: "NA" for key in range(0,12)}

########################################################################
def pcd_dataframe(path, outpath, pcd_output = "proportion"):
    # Extract file paths. 
    corpus_filepaths = [path + "/" + filename for filename in folder_parse(path)]
    # Create DataFrame.
    data = pd.DataFrame([music21_pcd(filepath, output = pcd_output) for filepath in corpus_filepaths], index = [corpus_filepaths])
    data.to_csv(outpath, index=True)

########################################################################