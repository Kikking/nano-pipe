#!/bash/bin

sudo apt update
sudo apt install build-essential
sudo apt-get install libz-dev
conda install -c anaconda make

git clone --recursive https://github.com/lbcb-sci/racon.git racon
cd racon
mkdir build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -Dracon_enable_cuda=ON ..
make