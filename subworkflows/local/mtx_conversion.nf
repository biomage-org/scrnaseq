/* --    IMPORT LOCAL MODULES/SUBWORKFLOWS     -- */
include { MTX_TO_H5AD   }             from '../../modules/local/mtx_to_h5ad.nf'
include { CONCAT_H5AD   }             from '../../modules/local/concat_h5ad.nf'
include { MTX_TO_SEURAT }             from '../../modules/local/mtx_to_seurat.nf'
include { H5AD_TO_10X   }             from '../../modules/local/h5ad_to_10x.nf'
include { GENE_MAP      }             from '../../modules/local/gene_map.nf'
include { KALLISTOBUSTOOLS_REF }        from '../../modules/nf-core/kallistobustools/ref/main'

workflow MTX_CONVERSION {

    take:
    mtx_matrices
    samplesheet
    gtf
    txp2gene
    genome_fasta


    main:
        ch_versions = Channel.empty()
        // Convert matrix do h5ad
        //

        MTX_TO_H5AD (
            mtx_matrices
        )

        //
        // Convert h5ad files to 10x counts format
        //
        // if (!txp2gene) {
        //     GENE_MAP( gtf )
        //     txp2gene = GENE_MAP.out.gene_map
        // }
        KALLISTOBUSTOOLS_REF( genome_fasta, gtf, 'standard' )
        txp2gene = KALLISTOBUSTOOLS_REF.out.t2g.collect()

        H5AD_TO_10X (
            MTX_TO_H5AD.out.h5ad, // gather all sample-specific files
            txp2gene
        )

        //
        // Concat sample-specific h5ad in one
        //
        CONCAT_H5AD (
            MTX_TO_H5AD.out.h5ad.collect(), // gather all sample-specific files
            samplesheet
        )

        //
        // Convert matrix do seurat
        //
        MTX_TO_SEURAT (
            mtx_matrices
        )



        //TODO CONCAT h5ad and MTX to h5ad should also have versions.yaml output
        ch_version = ch_versions.mix(MTX_TO_SEURAT.out.versions)

    emit:
    ch_versions
    sample = H5AD_TO_10X.out.sample

}
