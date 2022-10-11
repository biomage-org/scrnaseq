process H5AD_TO_10X {
    label 'process_low'

    // conda (params.enable_conda ? "conda-forge::scanpy conda-forge::python-igraph conda-forge::leidenalg" : null)
    // container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
    //     'https://depot.galaxyproject.org/singularity/scanpy:1.7.2--pyhdfd78af_0' :
    //     'quay.io/biocontainers/scanpy:1.7.2--pyhdfd78af_0' }"

    input:
    // inputs from cellranger nf-core module does not come in a single sample dir
    // for each sample, the sub-folders and files come directly in array.
    path h5ad_file
    path t2g_file

    output:
    path "out/*", emit: sample


    script:
    // def file paths for aligners (except cellranger)
    // if (params.aligner == 'kallisto') {
    //     mtx_matrix   = "*count/counts_unfiltered/*.mtx"
    //     barcodes_tsv = "*count/counts_unfiltered/*.barcodes.txt"
    //     features_tsv = "*count/counts_unfiltered/*.genes.txt"
    // } else if (params.aligner == 'alevin') {
    //     mtx_matrix   = "*_alevin_results/af_quant/alevin/quants_mat.mtx"
    //     barcodes_tsv = "*_alevin_results/af_quant/alevin/quants_mat_rows.txt"
    //     features_tsv = "*_alevin_results/af_quant/alevin/quants_mat_cols.txt"
    // } else if (params.aligner == 'star') {
    //     mtx_matrix   = "*.Solo.out/Gene*/filtered/matrix.mtx.gz"
    //     barcodes_tsv = "*.Solo.out/Gene*/filtered/barcodes.tsv.gz"
    //     features_tsv = "*.Solo.out/Gene*/filtered/features.tsv.gz"
    // }
    //
    // run script
    //
    """
    # convert file types
    h5ad_to_10x.py \\
        --h5ad_file ${h5ad_file} \\
        --t2g_file ${t2g_file} \\
        --out out
    """

    stub:
    """
    touch out/matrix.mtx out/features.tsv out/genes.tsv
    """
}
