


sudo docker run -it -v nanopore_data:/input -v nanopore_data:/output longqc sampleqc -x ont-ligation -p $(nproc) -o /output/mount/lqc_data/QC_A549_cDNAStranded_replicate3_run3 /input/mount/nanopore_data/SGNex_A549_directcDNA_replicate1_run3.fastq.gz

$ git config --global user.name "Kikking"
$ git config --global user.email kikkingkeenan@gmail.com

conda create -n lqc -y python=3.7 numpy scipy matplotlib scikit-learn pandas jinja2 h5py
conda activate lqc
conda install -c bioconda pysam
conda install -c bioconda edlib
conda install -c bioconda python-edlib

git clone https://github.com/yfukasawa/LongQC.git
cd LongQC/minimap2-coverage
sudo apt-get install libz-dev
make



python longQC.py sampleqc -x ont-rapid -o rapid_test SGNex_A549_directcDNA_replicate1_run3.fastq.gz