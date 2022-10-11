process H5AD_TO_10X {
    label 'process_low'

    input:
    path h5ad_file
    path t2g_file

    output:
    path "out/*", emit: sample


    script:
    """
    # convert file types
    sampleName=`basename ${h5ad_file} .h5ad`
    mkdir -p "out/\${sampleName}"
    h5ad_to_10x.py \\
        --h5ad_file ${h5ad_file} \\
        --t2g_file ${t2g_file} \\
        --out out/\${sampleName}
    """

    stub:
    """
    touch out/matrix.mtx out/features.tsv out/genes.tsv
    """
}
