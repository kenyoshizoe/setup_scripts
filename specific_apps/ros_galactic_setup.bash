#!/bin/env bash -eu
​
ROS_DISTRO=galactic
​
# Install develop environment
sudo apt update
sudo apt install -y build-essential python3-dev python3-pip
​
# Install ROS2
sudo apt install software-properties-common
sudo add-apt-repository universe
sudo apt update && sudo apt install -y curl gnupg2 lsb-release
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu focal main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
sudo apt update
​
sudo apt install -y ros-${ROS_DISTRO}-desktop python3-rosdep
sudo rosdep init
rosdep update
​
# Install ROS tools
sudo apt install -y python3-rosinstall \
    python3-catkin-tools \
    python3-vcstool \
    python3-colcon-common-extensions
​
grep -F "source /opt/ros/${ROS_DISTRO}/setup.bash" ~/.bashrc ||
echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> ~/.bashrc
​
grep -F "/usr/lib/python3/dist-packages/catkin_tools/verbs/catkin_shell_verbs.bash" ~/.bashrc ||
echo "/usr/lib/python3/dist-packages/catkin_tools/verbs/catkin_shell_verbs.bash" >> ~/.bashrc
​
grep -F "ROS_HOSTNAME" ~/.bashrc ||
echo "export ROS_HOSTNAME=\$(hostname).local" >> ~/.bashrc
​
. ~/.bashrc
mkdir -p ~/ros2_ws/src
cd ~/ros2_ws
colcon build
catkin init
catkin build
​
grep -F "export ROS_WORKSPACE=~/ros2_ws" ~/.bashrc ||
echo "export ROS_WORKSPACE=~/ros2_ws" >> ~/.bashrc
​
grep -F "source ${ROS_WORKSPACE}/devel/setup.bash" ~/.bashrc ||
echo "source ${ROS_WORKSPACE}/devel/setup.bash" >> ~/.bashrc
​
# argcomplete for ros2 & colcon
echo 'eval "$(register-python-argcomplete3 ros2)"' >> ~/.bashrc
echo 'eval "$(register-python-argcomplete3 colcon)"' >> ~/.bashrc
​
​
echo "########################################"
echo "ROS install completed!"
echo "Please execute 'source ~/.bashrc'"
echo "########################################"
