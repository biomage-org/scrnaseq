process BIOMAGE_UPLOAD {
    label 'process_low'
    container 'biomage/programmatic-interface:0.0.27'

    input:
    val email
    val password
    val instance_url
    path samples

    output:
    stdout

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    #!/usr/bin/env python
    import biomage_programmatic_interface as bpi

    connection = bpi.Connection('$email', '$password', '$instance_url', verbose=False)
    experiment = connection.create_experiment()
    for sample in '$samples'.split():
        experiment.upload_samples(sample)

    print(f"Project {experiment.name} successfuly created!")
    print(f'You can view it at https://$instance_url/')
    """
}
