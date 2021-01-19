/*
 * Runs MethylDackel extract and mbias
 */

params.methyldackel_mbias_options = [:]
params.methyldackel_extract_options = [:]

include { METHYLDACKEL_MBIAS } from '../software/methyldackel/mbias/main'         addParams( options: params.methyldackel_mbias_options )
include { METHYLDACKEL_EXTRACT } from '../software/methyldackel/extract/main'         addParams( options: params.methyldackel_extract_options )

workflow METHYLDACKEL {
    take:
    bam   // channel: [ val(meta), [ bam ] ]
    bai   // channel: [ val(meta), [ bai ] ]
    fasta // channel: [ val(meta), [ fasta ] ]
    fai   // channel: [ val(meta), [ fai ] ]

    main:
    /*
     * MethylDackel
     */
    bam.join(bai).join(fasta).join(fai) | (METHYLDACKEL_MBIAS & METHYLDACKEL_EXTRACT)

    emit:
    consensus  = METHYLDACKEL_EXTRACT.out.consensus     // channel: [ val(meta), [ consensus ] ]
    mbias      = METHYLDACKEL_MBIAS.out.mbias // channel: [ val(meta), [ mbias ] ]
    version    = METHYLDACKEL_MBIAS.out.version //    path: *.version.txt
}