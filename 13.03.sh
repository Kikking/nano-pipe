#!/bin/bash 


podTar /mnt/d/gcp/tardata/SGNex_Hct116_cDNA_replicate4_run2.tar.gz Hc_c_r4r2
cd ~/darter
bash ~/nano-pipe/Basecall/dorado.sh Hc_c_r4r2
bash ~/nano-pipe/Mapping/minisam.sh Hc_c_r4r2

talon --f /mnt/e/refData/talon_config1.csv --db /mnt/e/refData/tal_fin.db --build hg38 --o talon_test1  


bash ~/nano-pipe/ID/sqantiscript.sh Hc_c_r3r3

bash ~/nano-pipe/ID/sqantiscript.sh Hc_d_r3r2.1 i
bash ~/nano-pipe/ID/sqantiscript.sh Hc_d_r3r2.1 b
bash ~/nano-pipe/ID/sqantiscript.sh Hc_d_r3r2.1 s
bash ~/nano-pipe/ID/sqantiscript.sh Hc_d_r4r1.1 i
bash ~/nano-pipe/ID/sqantiscript.sh Hc_d_r4r1.1 b
bash ~/nano-pipe/ID/sqantiscript.sh Hc_d_r4r1.1 s
bash ~/nano-pipe/ID/sqantiscript.sh Hc_d_r5r1.1 i
bash ~/nano-pipe/ID/sqantiscript.sh Hc_d_r5r1.1 b
bash ~/nano-pipe/ID/sqantiscript.sh Hc_d_r5r1.1 s
bash ~/nano-pipe/ID/sqantiscript.sh Hc_c_r3r3 i
bash ~/nano-pipe/ID/sqantiscript.sh Hc_c_r3r3 b
bash ~/nano-pipe/ID/sqantiscript.sh Hc_c_r3r3 s
