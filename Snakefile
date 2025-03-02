__maintainer__ = ""
__email__ = ""


import os
from os.path import join
import sys
import glob
import pandas as pd
import csv

configfile: "config.yaml" 

# Directory structure
DATA_DIR = "data" #config['data']  
preprocessing_dir = "00_preprocessing"
assembly_dir = "01_assembly"
binning_dir = "02_binning"
binning_analyses = "03_binning_analyses"
if not os.path.exists("logs"):
    os.makedirs("logs")
os.system("chmod +x scripts/*")
os.system("chmod +x scripts/plotting/*")

# LOAD METADATA
df_run = pd.read_csv("runs.txt")
RUN = df_run["Run"]

df_coas = pd.read_csv("coassembly_runs.txt", sep="\t")
COAS = df_coas["coassembly"]


all_outfiles = [
     # Figure 2
     join(DATA_DIR,preprocessing_dir, "raw_qc/multiqc/raw_multiqc_report.html"),
     join(DATA_DIR,preprocessing_dir, "postprocessing_qc/multiqc/post_multiqc_report.html"),
     # Figure 3a
     join(DATA_DIR,"figures/cmseq_plot.png"),
     join(DATA_DIR,"figures/checkm_contam.png"),
     join(DATA_DIR,"figures/checkm_completeness.png"),
     # Figure 3b
     join(DATA_DIR, "figures/dnadiff.png"),
     # Figure 3c
     join(DATA_DIR,"figures/gtdb_bacteria.png"),
     # Figure 4
     join(DATA_DIR,"figures/perassemb_perref.png")
]

rule all:
   input: all_outfiles


include: "modules/sra_download.Snakefile"
include: "modules/preprocessing.Snakefile"
include: "modules/coas.Snakefile"
include: "modules/assembly.Snakefile"
include: "modules/binning.Snakefile"
include: "modules/refine.Snakefile"
include: "modules/dRep_GTDB.Snakefile"
include: "modules/framework.Snakefile"
include: "modules/refine_coas.Snakefile"
include: "modules/cmseq.Snakefile"
include: "modules/dnadiff.Snakefile"
