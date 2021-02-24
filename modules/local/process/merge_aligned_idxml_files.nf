// Import generic module functions
include { initOptions; saveFiles; getSoftwareName } from './functions'

params.options = [:]

//TODO: combine in a subflow --> when needs to be removed
process MERGE_ALIGNED_IDMXL_FILES {
    conda (params.enable_conda ? "bioconda::openms-thirdparty=2.5.0" : null)
    if (workflow.containerEngine == 'singularity' && !params.singularity_pull_docker_container) {
        container "https://depot.galaxyproject.org/singularity/openms-thirdparty:2.5.0--6"
    } else {
        container "quay.io/biocontainers/openms-thirdparty:2.5.0--6"
    }

    input:
        tuple val(id), val(Sample), val(Condition), file(ids_aligned)

    output:
        tuple val("$id"), val("$Sample"), val(Condition), file("${Sample}_all_ids_merged.idXML"), emit: idxml   
        path  "*.version.txt", emit: version

    script:
    """
        IDMerger -in $ids_aligned \\
        -out ${Sample}_all_ids_merged.idXML \\
        -threads ${task.cpus}  \\
        -annotate_file_origin  \\
        -merge_proteins_add_PSMs

        FileInfo --help &> openms.version.txt
    """
}