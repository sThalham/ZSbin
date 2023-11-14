FROM tensorflow/tensorflow:2.10.1-gpu

MAINTAINER Stefan Thalhammer (thalhammer@acin.tuwien.ac.at)
ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

#RUN apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654

#RUN echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list



RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'

RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

RUN apt-get update && apt-get install --no-install-recommends -y --allow-unauthenticated \
      ros-noetic-desktop-full \
      python3-rosinstall \
      python3-rosinstall-generator \
      python3-wstool \
      python3-rosdep \
      && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install --no-install-recommends -y --allow-unauthenticated --fix-missing \
      wget \
      usbutils \
      vim \
      software-properties-common \
      libxext-dev \
      libxrender-dev \
      libxslt1.1 \
      libcanberra-gtk-module \
      tmux \
      python3-pip \
      python3-setuptools \
      python3-virtualenv \
      python3-wheel \
      libopenblas-base \
      numpy-scipy \
      numpy-h5py \
      && apt-get clean \
      && rm -rf /var/lib/apt/lists/*

RUN echo "export QT_X11_NO_MITSHM=1" >> ~/.bashrc

RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install opencv-python
RUN python3 -m pip install transforms3d
RUN python3 -m pip install glumpy
RUN python3 -m pip install open3d
RUN python3 -m pip install opencv-python

RUN rosdep init && \
     rosdep update

RUN apt-get update && apt-get install --no-install-recommends -y --allow-unauthenticated \
     python3-catkin-tools \
     && rm -rf /var/lib/apt/lists/*

RUN pip3 install --upgrade setuptools opencv-contrib-python

RUN echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc
RUN mkdir -p ~/catkin_ws/src
RUN /bin/bash -c "source /opt/ros/noetic/setup.bash \
    && cd ~/catkin_ws \
    && catkin_make -DPYTHON_EXECUTABLE=/usr/bin/python3"
RUN echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc
