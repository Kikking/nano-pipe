#~!/bin/bash 

 ./gffcompare -R -r /mnt/d/refData/lrgasp_gencode_v38_sirvs.gtf -o  /mnt/d/SGNEX/gffcmp/stringtie/A_d_r1r3 /mnt/d/SGNEX/GTF_files/stringtie/A_d_r1r3.gtf
 gffcompare -R -r mm10.gff -o strtcmp stringtie_asm.gtf

 #!/bin/bash

test_gtf=/mnt/d/SGNEX/GTF_files/isoquant/novel/sd4_100_1500-2000_0.75/sd4_100_1500-2000_0.75.filt.gtf
./gffcompare -r ~/pbsim3-3.0.4/sample/gencode45_SIM1001.gtf -o ./novel/test $test_gtf
