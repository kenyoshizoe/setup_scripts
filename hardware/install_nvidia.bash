echo "--- install nvidia driver ---"
nvidia-smi &> /dev/null
if [ $? -ne 0 ] ; then
    sudo ubuntu-drivers install
    sudo apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu200>
    echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" | sudo t>
    sudo apt update
    sudo apt install -y "linux-headers-$(uname -r)" build-essential
    sudo apt install -y cuda-drivers
    echo "[notice] you need reboot. to apply nvidia driver."
else
    echo "skip."
fi
