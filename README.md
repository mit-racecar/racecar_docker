# Racecar Docker

This code defines a docker image to interface with the MIT Racecar.
The image is built from a Debian base, includes the latest version of ROS, and the [racecar simulator](https://github.com/mit-racecar/racecar_simulator). It can be interfaced through a terminal or graphically through a browser.

## Running the Image

If you do not already have docker, follow the install instructions for your OS [here](https://docs.docker.com/install/).

Then download this docker image and build it:

    git clone https://github.com/mit-racecar/racecar_docker.git
    cd racecar-docker
    sudo docker-compose up --build

The first time you build it will take a little while, but in the future it should be almost instantaneous.

Once the image has been built, follow the instructions in the command prompt to connect via either a terminal or your browser.
If you're using the browser interface, click "Connect" then right click anywhere on the black background to launch a terminal.

### Example Usage

Connect via the graphical interface, open up a terminal and enter:

    roslaunch racecar_simulator simulate.launch

Then right click on the background and select `rviz`.
A graphical interface should pop up that shows a blue car on a monochrome background (a map) and some colorful dots (simulated lidar).
If you click the green "2D Pose Estimate" arrow on the top and then drag on the map you can change the position of the car.

### Shutting Down

To stop the image, run:

    sudo docker-compose down

You might get strange errors if you try to relaunch the image without properly shutting it down.

## Local Storage

**WARNING**: any changes made to the `~/racecar_ws/src` folder will be saved to `racecar_docker/src` on your local machine but ANY OTHER CHANGES WILL BE DELETED WHEN YOU RESTART THE DOCKER IMAGE.
The only changes you will ever need to make for your labs will be in the `~/racecar_ws/src` folder, so ideally this should never be a problem, *just be careful*.

## Connecting to a specific car

By default the image is set up to use ROS locally. If you want to connect the image to another `rosmaster` (e.g. a racecar) you need to change some ROS variables. You can do this automatically by running:

    sudo docker run -ti --net=host racecar/racecar CAR_NUMBER

This sets the correct `ROS_IP`, `ROS_MASTER_URI`, and `/etc/hosts` variables, assuming that the car's IP is `192.168.1.CAR_NUMBER`. When you launch `rviz` it will display topics published on the racecar. Note that this won't work on macOS due to the networking issues described above.

You will also be able to `ssh` into the racecar from within the docker image by typing:

    ssh racecar@racecar

## Customization

Feel free to fork this repository to customize the image with your own editors, key commands, window managers, themes, etc.
