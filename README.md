# Racecar Docker

This code defines a docker image to interface with the MIT Racecar.
The image is built from a Debian base, includes the latest version of ROS, and the [racecar simulator](https://github.com/mit-racecar/racecar_simulator). It can be interfaced through a terminal or graphically through a browser.

## Installation

If you do not already have docker, follow the install instructions for your OS [here](https://docs.docker.com/install/).

Once docker is installed and running, open up a terminal and pull the image:

    git clone https://github.com/mit-racecar/racecar_docker.git
    cd racecar_docker
    docker-compose pull

The image is about 1GB compressed so this can take a couple minutes. Fortunately, you only need to do it once.

## Starting Up

Once the image is pulled you can start it by running the following in your `racecar_docker` directory:

    docker-compose up

Follow the instructions in the command prompt to connect via either a terminal or your browser.
If you're using the browser interface, click "Connect" then right click anywhere on the black background to launch a terminal.

## Example Usage

Connect via the graphical interface, right click on the background and select `Terminal`, then enter:

    roslaunch racecar_simulator simulate.launch

Then right click on the background and select `RViz`.
A graphical interface should pop up that shows a blue car on a monochrome background (a map) and some colorful dots (simulated lidar).
If you click the green "2D Pose Estimate" arrow on the top and then drag on the map you can change the position of the car.

Close RViz and type <kbd>Ctrl</kbd>+<kbd>C</kbd> in the terminal running the simulator to stop it. Now we're going to try to install some software. In any terminal run:

    sudo apt update
    sudo apt install cmatrix

To use `sudo` you will need to enter the user password which is `racecar@mit`.
Once the software is installed, run

    cmatrix

You're in!

## Shutting Down

To stop the image, run:

    docker-compose down

If you try to rerun `docker-compose up` without first running `docker-compose down` the image may not launch properly.

## Local Storage

Any changes made to the `~/racecar_ws/src` folder will be saved to `racecar_docker/src` on your local machine but **ANY OTHER CHANGES WILL BE DELETED WHEN YOU RESTART THE DOCKER IMAGE**.
The only changes you will ever need to make for your labs will be in the `~/racecar_ws/src` folder, so ideally this should never be a problem --- *just be careful* not to keep any important files outside of that folder.

## Custom Builds

If you want to change the docker image and rebuild locally, all you need to do is add a `--build` flag:

    docker-compose up --build

To publish to Docker Hub you need to build a multi-architecture image so that it works on AMD and ARM platforms. If you have write access to the `racecar/racecar` repo, you can use these commands to build and push:

    docker buildx create --name mybuilder --use
    docker login
    sudo docker buildx build . --platform linux/arm64,linux/amd64 --tag racecar/racecar:latest --push 
