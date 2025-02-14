#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { UNZIP      } from '../../../../../modules/nf-core/unzip/main.nf'
include { MALT_BUILD } from  '../../../../../modules/nf-core/malt/build/main.nf'
include { MALT_RUN   } from '../../../../../modules/nf-core/malt/run/main.nf'

workflow test_malt_run {

    fastas        = file(params.test_data['sarscov2']['genome']['genome_fasta'], checkIfExists: true)
    seq_type      = "DNA"
    map_accession = [ [], file("http://software-ab.cs.uni-tuebingen.de/download/megan6/nucl_acc2tax-Jul2019.abin.zip", checkIfExists: true) ]
    mapping_type  = 'ref'
    mapping_db    = 'taxonomy'
    input = [
        [ id:'test', single_end:false ], // meta map
        file(params.test_data['sarscov2']['illumina']['test_1_fastq_gz'], checkIfExists: true)
    ]
    mode = "BlastN"

    UNZIP ( map_accession )
    MALT_BUILD ( fastas, seq_type, UNZIP.out.unzipped_archive.map{ it[1] }, "ref", "taxonomy" )
    MALT_RUN ( input, mode, MALT_BUILD.out.index )
}

