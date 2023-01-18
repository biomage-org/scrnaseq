process BIOMAGE_UPLOAD {
    label 'process_low'
    container 'biomage/programmatic-interface:0.0.27'
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
    import concurrent.futures
    import biomage_programmatic_interface as bpi
    import os


    email = os.getenv('BIOMAGE_EMAIL')
    password = os.getenv('BIOMAGE_PASSWORD')

    if not email or not password:
        raise Exception("Missing email or password")

    connection = bpi.Connection(email, password, '$instance_url', verbose=False)
    experiment = connection.create_experiment()
    print(f"Project {experiment.name} successfuly created. You can view it at https://$instance_url/")

    # Create a list of samples to upload
    samples = '$samples'.split()

    print("Uploading samples...")

    with concurrent.futures.ThreadPoolExecutor() as executor:
        # Submit the upload_samples function for each sample to the executor
        results = [executor.submit(experiment.upload_samples, sample) for sample in samples]
        # Wait for all uploads to complete
        concurrent.futures.wait(results)
    print("Samples uploaded successfully.")

    """
}
