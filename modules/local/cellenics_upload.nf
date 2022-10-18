process CELLENICS_UPLOAD {
    // container 'biomage/programmatic-interface:0.0.3'

    input:
    val email
    val password
    path samples

    output:
    stdout

    script:
    """
    #!/usr/bin/env python
    import biomage_programmatic_interface as bpi

    connection = bpi.Connection('$email', '$password')
    experiment_id = connection.create_experiment()
    for sample in '$samples'.split():
        connection.upload_samples(experiment_id, sample)
    """
}