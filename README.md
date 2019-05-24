# Racecar Docker

This code defines a docker image with the minimal code required to interface with the MIT Racecar.
The image is built from a Debian base, includes the latest version of ROS, and the [racecar simulator](https://github.com/mit-racecar/racecar_simulator). It can be interfaced with either through a browser or through a VNC client, allowing it to work on all modern operating systems.

## Building the Image

To build the image run:

    cd racecar_docker
    sudo docker build -t racecar .

## Running the Image

Start the docker image by running:

    sudo docker run -ti --net=host racecar

To view the image in the browser, navigate to [http://localhost:6080/vnc.html](http://localhost:6080/vnc.html). Hit the "Connect" button and you're in!

Alternatively, you can interface with the image using any VNC client with address `localhost:5900`.

### Mounting a local drive

Docker images do not save changes made to them by default.
Plus, you may be more comfortable using a text editor you already have installed on your computer.
To solve both of these issues, you can mount a local folder into the docker image.
We recommend that you mount into the `/racecar_ws/src` folder.
This is typically where all of your code will live while working with the racecar or the racecar simulator.
You can do this by adding the following to your docker run command:

    sudo docker run -tiv /full/path/to/local/folder:/racecar_ws/src --net=host racecar

### Using a Joystick

To use a joystick in the image (e.g. to use with the simulator),
you need to forward inputs from that USB device into docker.
Most joysticks map to `/dev/input/js0` by default, so you can add that device with:

    sudo docker run -ti --net=host --device=/dev/input/js0 racecar
