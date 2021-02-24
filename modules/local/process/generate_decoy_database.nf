// Import generic module functions
include {  saveFiles; getSoftwareName } from './functions'

params.options = [:]

//TODO: combine in a subflow --> when needs to be removed
process GENERATE_DECOY_DB {
    conda (params.enable_conda ? "bioconda::openms-thirdparty=2.5.0" : null)
    if (workflow.containerEngine == 'singularity' && !params.singularity_pull_docker_container) {
        container "https://depot.galaxyproject.org/singularity/openms-thirdparty:2.5.0--6"
    } else {
        container "quay.io/biocontainers/openms-thirdparty:2.5.0--6"
    }

    input:
        tuple val(id), val(Sample), file(fastafile)

    output:
        tuple val("$id"), val("$Sample"), file("${fastafile.baseName}_decoy.fasta"), emit: decoy
        path "*.version.txt", emit: version
    
    when:
        !params.skip_decoy_generation

    script:
        """
            DecoyDatabase -in ${fastafile} \\
                -out ${fastafile.baseName}_decoy.fasta \\
                -decoy_string DECOY_ \\
                -decoy_string_position prefix

                FileInfo --help &> openms.version.txt
        """
}