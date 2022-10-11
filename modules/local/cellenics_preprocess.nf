process CELLENICS_PREPROCESS {
    input:
    path t2g
    path matrix
    path features
    path barcodes

    output:
    path 'cellenics_*', emit: sample

    script:
    """
    cellenics_preprocess.py --t2g $t2g --matrix $matrix --features $features --barcodes $barcodes
    mkdir cellenics_sample
    mv matrix.mtx features.tsv barcodes.tsv cellenics_sample
    """
}