process CELLENICS_PREPROCESS {
    input:
    path txp2gene
    tuple val(id), path(results_path)
    val matrix
    val features
    val barcodes

    output:
    path 'cellenics_*', emit: sample

    script:
    """
    cellenics_preprocess.py --t2g $txp2gene --matrix $results_path/$matrix --features $results_path/$features --barcodes $results_path/$barcodes
    mkdir cellenics_$results_path
    mv matrix.mtx features.tsv barcodes.tsv cellenics_$results_path
    """

    // stub:
    // """
    // mkdir index
    // touch index/seq.bin
    // touch index/info.json
    // touch index/refseq.bin
    // """

}