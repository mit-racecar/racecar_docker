# Racecar Docker

This code defines a docker image with the minimal code required to interface with the MIT Racecar.
The image is built from a Debian base, includes the latest version of ROS, and the [racecar simulator](https://github.com/mit-racecar/racecar_simulator). It can be interfaced with either through a browser or through a VNC client, allowing it to work on all modern operating systems.

## Building the Image

To build the image run:

    cd racecar_docker
    sudo docker build -t racecar .

## Running the Image

To use interface with the image in the browser, first run:

    sudo docker run -tip 6080:6080 racecar

Then in the browser navigate to [http://localhost:6080/vnc.html](http://localhost:6080/vnc.html). Hit the "Connect" button and you're in!

Alternatively, you can interface with the image using a VNC client with address `localhost:5900` by running:

    sudo docker run -tip 5900:5900 racecar
