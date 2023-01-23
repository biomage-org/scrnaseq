process BIOMAGE_UPLOAD {
    label 'process_low'
    container 'biomage/programmatic-interface:0.0.35'
    secret 'BIOMAGE_EMAIL'
    secret 'BIOMAGE_PASSWORD'

    input:
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
    import os

    connection = bpi.Connection(os.getenv('BIOMAGE_EMAIL'), os.getenv('BIOMAGE_PASSWORD'), '$instance_url', verbose=False)
    experiment = connection.create_experiment()
    for sample in '$samples'.split():
        experiment.upload_samples(sample)

    print(f"Project {experiment.name} successfuly created!")
    print(f'You can view it at https://$instance_url/')
    """
}
