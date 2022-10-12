#!/usr/bin/env python
import scanpy as sc
import pandas as pd
from scipy import io
import os
import argparse

def h5ad_to_10x(
    h5ad_file: str,
    t2g_file: str,
    out: str,
):

    ad = sc.read_h5ad(h5ad_file)

    t2g = pd.read_table(t2g_file, header=None)
    id2name = {e[1]: e[2] for _, e in t2g.iterrows()}

    features = pd.DataFrame()
    features['id'] = ad.var.index
    features['name'] = ad.var.index.map(id2name)

    features.to_csv(os.path.join(out, "features.tsv" ),   sep = "\t", index = False, header=None)
    pd.DataFrame(ad.obs.index).to_csv(os.path.join(out, "barcodes.tsv"), sep = "\t", index = False, header=None)
    io.mmwrite(os.path.join(out, "matrix.mtx"), ad.X.T, field='integer')

    print("Wrote features.tsv, barcodes.tsv, and matrix.mtx files to {}".format(args["out"]))




if __name__ == "__main__":

    parser = argparse.ArgumentParser(description="Converts h5ad to 10x counts.")

    parser.add_argument("--h5ad_file", dest="h5ad_file", help="Path to h5ad matrix file.")
    parser.add_argument("--t2g_file", dest="t2g_file", help="Transcript to gene (t2g) file.")
    parser.add_argument("-v", "--verbose", dest="verbose", help="Toggle verbose messages", default=False)
    parser.add_argument("-s", "--sample", dest="sample", help="Sample name")
    parser.add_argument("-o", "--out", dest="out", help="Output path.")
    parser.add_argument("-a", "--aligner", dest="aligner", help="Which aligner has been used?")

    args = vars(parser.parse_args())

    adata = h5ad_to_10x(
        args["h5ad_file"],
        args["t2g_file"],
        args["out"]
    )


