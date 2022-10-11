process CELLENICS_UPLOAD {
    input:
    val email
    val password
    path sample

    output:
    stdout

    script:
    """
    #!/usr/bin/env python
    import cellenics_api

    connection = cellenics_api.Connection('$email', '$password')
    experiment_id = connection.create_experiment()
    connection.upload_samples(experiment_id, '$sample')
    """
}