process BIOMAGE_UPLOAD {
    label 'process_low'
    cache false
    container 'biomage/programmatic-interface:0.0.38'
    secret 'BIOMAGE_EMAIL'
    secret 'BIOMAGE_PASSWORD'

    input:
    val instance_url
    val verbose
    path samples

    output:
    stdout

    when:
    task.ext.when == null || task.ext.when

    script:
    """
    #!/usr/bin/env python3
    import biomage_programmatic_interface as bpi
    import os

    connection = bpi.Connection(
        os.getenv('BIOMAGE_EMAIL'),
        os.getenv('BIOMAGE_PASSWORD'),
        '$instance_url',
        verbose = '$verbose' == 'true')
    experiment = connection.create_experiment()
    for sample in '$samples'.split():
        experiment.upload_samples(sample)

    print(f"Project {experiment.name} successfuly created!")
    experiment.run()
    """
}
