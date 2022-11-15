nextflow run . \
-profile test -with-docker biomage/programmatic-interface:0.0.7 \
-with-tower \
--outdir results \
--biomage_email biomage.test.profile@gmail.com \
--biomage_password PASSWORD_HERE
