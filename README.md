# Racecar Docker

This code defines a docker image with the minimal code required to interface with the MIT Racecar.
The image is built from a Debian base, includes the latest version of ROS, and the [racecar simulator](https://github.com/mit-racecar/racecar_simulator). It can be interfaced through a terminal or graphically through a browser or VNC client.

## Building the Image

To build the image run:

    cd racecar_docker
    sudo docker build -t racecar .

## Running the Image

Start the docker image by running:

    sudo docker run -ti --net=host racecar

See the [Additional Docker Options](https://github.com/mit-racecar/racecar_docker#additional-docker-options) section for more useful flags.

## Using the Image

When you run the command above, you will be presented with a new bash shell in the folder `racecar_ws`.
This shell has ROS installed (e.g. try running `roscore`).
It also has the programs `screen` and `tmux` installed.
These programs allow you to run many shells from within the same window.

In addition to the terminal interface, you can interact with the image visually through either your browser or through VNC.
This allows you to use programs like `rviz`.

To use the image in the browser, navigate to [http://localhost:6080/vnc.html](http://localhost:6080/vnc.html). Hit the "Connect" button and you're in!

Alternatively, you can interface with the image using any VNC client with address `localhost:5900`.

The visual interface has two buttons that launch a terminal and `rviz` respectively.
By default, clicking on the terminal button when a terminal is already minimizes the window.
To open multiple terminals, type <kbd>CTRL</kbd> and then click on the terminal icon.

### Running the Racecar Simulator

To get started with the simulator, first run the following in any shell:

    roslaunch racecar_simulator simulate.launch

Then open `rviz`.
You should see a blue car on a black and white background (a map) and some colorful dots (simulated lidar).
If you click the green 2D Pose Estimate arrow on the top you can change the position of the car.
Alternatively use a joystick to drive the car as described below.

## Additional Docker Options

### Mounting a local drive

Docker images do not save changes made to them by default which can be dangerous when writing lots of code.
Plus, the docker image may not have your favorite text editor, window manager, etc. installed.
To solve both of these issues, you can mount a local folder into the docker image.
This will make sure your changes are written and give you the freedom to edit the code in whatever environment you would like.

We recommend that you mount into the `/racecar_ws/src` folder.
This is typically where all of your code will live while working with the racecar or the racecar simulator.
You can do this by adding the following to your docker run command:

    sudo docker run -tiv /full/path/to/local/folder:/racecar_ws/src --net=host racecar

### Using a Joystick

To use a joystick in the image (e.g. to use with the simulator),
you need to forward inputs from that USB device into docker.
Most joysticks map to `/dev/input/js0` by default, so you can add that device with:

    sudo docker run -ti --net=host --device=/dev/input/js0 racecar
