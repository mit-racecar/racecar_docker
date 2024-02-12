# Racecar Docker

This code defines a docker image to interface with the MIT Racecar.
The image is built from a Debian base, includes the latest version of ROS, and the [racecar simulator](https://github.com/mit-racecar/racecar_simulator). It can be interfaced through a terminal or graphically through a browser.

## Installation

First install `git` and Docker according to your OS:

- macOS: Make sure command line tools are installed by running `xcode-select --install` in a terminal and then [install and launch Docker Desktop](https://docs.docker.com/desktop/mac/install/). Open your [Docker preferences](https://docs.docker.com/desktop/mac/#preferences) and make sure Docker Compose V2 is enabled.
- Windows: [Install git](https://git-scm.com/download/win) and then [install and launch Docker Desktop](https://docs.docker.com/desktop/windows/install/).
- Linux: Make sure you have [git installed](https://git-scm.com/download/linux) and then [install Docker Engine for your distro](https://docs.docker.com/engine/install/#server) and install [Docker Compose V2](https://docs.docker.com/compose/cli-command/#install-on-linux).

Once everything is installed and running, if you're on macOS or Linux open a terminal and if you're on Windows open a PowerShell. Then clone and pull the image (NOTE: If using a Mac, after cloning the repository, you must go into the docker compose yaml file and change the image from "sebagarc/racecar2", to "sebagarc/racecarmac"):

    git clone https://github.com/mit-racecar/racecar_docker.git
    cd racecar_docker
    docker compose pull

Linux users may need to use `sudo` to run `docker compose`. The image is about 1GB compressed so this can take a couple minutes. Fortunately, you only need to do it once.

## Starting Up

Once the image is pulled you can start it by running the following in your `racecar_docker` directory:

    docker compose up

Follow the instructions in the command prompt to connect via either a terminal or your browser.
If you're using the browser interface, click "Connect" then right click anywhere on the black background to launch a terminal.

## Example Usage

First, connect via the graphical interfacce, right click on the background and select `RViz`. Note: Rviz can also be launched by typing 'rviz2' in the terminal. 

Next, right click on the background and select `Terminal`, then enter:

    ros2 launch racecar_simulator simulate.launch.xml


A graphical interface should pop up that shows a blue car on a monochrome background (a map) and some colorful dots (simulated lidar).
If you click the green "2D Pose Estimate" arrow on the top and then drag on the map you can change the position of the car. Note: when launching most scripts to be visualized, make sure that you launch Rviz first, otherwise certain features might not appear. 

Close RViz and type <kbd>Ctrl</kbd>+<kbd>C</kbd> in the terminal running the simulator (in your graphical interface that is on the browser) to stop it. Now we're going to try to install some software. In any terminal run:

    sudo apt update
    sudo apt install cmatrix

To use `sudo` you will need to enter the user password which is `racecar@mit`.
Once the software is installed, run

    cmatrix

You're in!

## Shutting Down

To stop the image, run:

    docker compose down

If you try to rerun `docker compose up` without first running `docker compose down` the image may not launch properly.

## Local Storage

Any changes made to the your home folder in the docker image (`/home/racecar`) will be saved to the `racecar_docker/home` directory your local machine but **ANY OTHER CHANGES WILL BE DELETED WHEN YOU RESTART THE DOCKER IMAGE**.
The only changes you will ever need to make for your labs will be in your home folder, so ideally this should never be a problem --- *just be careful* not to keep any important files outside of that folder.

## Tips

- In the graphical interface, you can move windows around by holding <kbd>Alt</kbd> or <kbd>Command</kbd> (depending on your OS) then clicking and dragging *anywhere* on a window. Use this to recover your windows if the title bar at the top of a window goes off screen.
- You can't copy and paste into the graphical interface but you can copy and paste into a terminal interface, opened by running `docker compose exec racecar bash`. You can also edit files that are in the shared `home` directory using an editor on your host OS.


## Connecting to a physical racecar

(To be changed and edited. Coming soon!
)
To connect your docker image to a ROS master running on a physical racecar, open the `docker-compose.yml` and change the `racecar` hostname under the `extra_hosts` field from `127.0.0.1` to your car's IP. For example, for car number 100 you would put:

    extra_hosts:
      racecar: 192.168.1.100

Then restart the docker image. This does not require the image to be rebuilt. You should be able to `ssh` into your racecar by simply typing:

    ssh racecar

If you publish to topics on the racecar you should be able to print them via `ros2 topic echo <topic name>` or visualize them in RViz on your docker image.


## Custom Builds

If you want to change the docker image and rebuild locally, all you need to do is add a `--build` flag:

    docker compose up --build


