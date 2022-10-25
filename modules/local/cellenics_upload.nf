process CELLENICS_UPLOAD {
    container 'biomage/programmatic-interface:0.0.9'

    input:
    val email
    val password
    val instance
    path samples

    output:
    stdout

    script:
    """
    #!/usr/bin/env python
    import biomage_programmatic_interface as bpi

    connection = bpi.Connection('$email', '$password', '$instance')
    experiment_id = connection.create_experiment()
    for sample in '$samples'.split():
        connection.upload_samples(experiment_id, sample)
    """
}