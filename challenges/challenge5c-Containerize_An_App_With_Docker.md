# Containerize an application with Docker 

## Expected Outcome

In this lab we'll deploy a variety of different applications with Docker EE. We'll start with a traditional build, ship, run workflow of a Linux application. We'll then use Image2Docker to extract a Windows application from an existing VHD. And, finally, we'll use Docker Compose to deploy an application that includes both Windows and Linux components.

## Process

> **Difficulty**: Beginner

> **Time**: Approximately 60 minutes

> * [Task 1: Configure Docker Trusted Registry](#task1)
>   * [Task 1.1: Create a Repository](#task1.1)
> * [Task 2: Deploy  Linux Web App](#task2)
>   * [Task 2.1: Clone the Demo Repo](#task2.1)
>   * [Task 2.2: Build and Test the Dockerized Application](#task2.2)
>   * [Task 2.3: Push the Application Image to Docker Trusted Registry](#task2.3)
>   * [Task 2.4: Deploy the Application to Production](#task2.4)
> * [Task 3: Upgrade the application](#task3)
>   * [Task 3.1: Build a New Version of the Application](#task3.1)
>   * [Task 3.2: Upgrade the running application](#task3.2)


## Understanding the Play With Docker Interface

![](./images/pwd_screen.png)

For these labs you will be using Play-With-Docker, a web-based environment for running Docker Enterprise Edition. 

There are three main components to the Play With Docker (PWD) interface.

### 1. Console Access
Play with Docker provides access to the three Docker EE hosts in your Cluster. These machines are:

* A Linux-based Docker EE 17.06 Manager node
* A Linux-based Docker EE 17.06 Worker node
* A Windows Server 2016-based Docker EE 17.06 Worker Node (Note: For this lab you will not be using the Windows node)

By clicking a name on the left, the console window will be connected to that node.

### 2. Access to your Universal Control Plane (UCP) and Docker Trusted Registry (DTR) servers

Additionally, the PWD screen provides you one-click access to the Universal Control Plane (UCP)
web-based management interface as well as the Docker Trusted Registry (DTR) web-based management interface. Click on either the `UCP` or `DTR` button will bring up the respective server web interface in a new tab.

### 3. Session Information

Throughout the lab you will be asked to provide either hosntnames or login credentials that are unique to your environment. These are displayed for you at the bottom of the screen.

## Document conventions

- When you encounter a phrase in between `<` and `>`  you are meant to substitute in a different value.

	For instance if you see `<dtr domain>` you would actually type something like `ip172-18-0-7-b70lttfic4qg008cvm90.direct.microsoft.play-with-docker.com`

## <a name="task1"></a>Task 1: Configure Docker Trusted Registry

The first step in the demo will be to prepare a place for your Docker application image to live. Docker uses a specific type of server (referred to as a registry) to hold your Docker images. Docker provides multiple types of registries. There is a SaaS-base offering, Docker Hub, an open source registry, and a registry included with certain Docker EE versions. This last registry is called Docker Trusted Registry, and it's what you'll be using today. 

### <a name="task 1.1"></a>Task 1.1: Accessing PWD

1. Open the PWD environment **in a new tab or window** by right-clicking [the PWD environment sign-in page](https://goto.docker.com/2017PWDonMicrosoftAzure_MTALP.html).

	> **Note**: You might want to right click the above link and open it in an incognito window.

2. Fill out the form, and click `submit`. You will then be redirected to the PWD environment.

3. Click `Access`

	It will take a few minutes to provision out your PWD environment. After this step completes, you'll be ready to move on to the next step.


Docker Trusted Registry (DTR) is an enterprise-grade registry designed to store and manage your Docker images. In this lab we're going to create a Docker image and push it to DTR. But before we can do that, we need to setup a repository in which the image will reside.

1. In the PWD web interface click the `DTR` button on the left side of the screen.

	> **Note**: DTR is using self-signed certs. It's safe to click through any browser warning you might encounter.

1. Login to DTR using the credentials found at the bottom of the main PWD screen. 

2. From the main DTR page click `New Repository`. This brings up the new repository dialog.

	![](./images/create_repository.png)

3. Under `REPOSITORY NAME`, type `linux_tweet_app`. Leave the rest of the values the same, and click `Save`.

Congratulations you have created a new repository on your DTR server.

## <a name="task2"></a>Task 2: Deploy a Linux Web App

Now that created a repository, let's deploy a simple Linux-based web app, a web pages that allows you to send a tweet. This application built on Linux using NGINX.


### <a name="task2.1"></a> Task 2.1: Clone the Demo Repo

1. Move back to the PWD interface, and click on on the `worker1` link on the left to connect your web console to the UCP Linux worker node.

    Note: If the screen is blank, you simply need to hit `enter` to get a command prompt.

2. Use `git` to clone the workshop repository.

	```
	$ git clone https://github.com/dockersamples/linux_tweet_app.git
	```

	You should see something like this as the output:

	```
	Cloning into 'linux_tweet_app'...
	remote: Counting objects: 13, done.
	remote: Compressing objects: 100% (10/10), done.
	remote: Total 13 (delta 1), reused 10 (delta 1), pack-reused 0
	Unpacking objects: 100% (13/13), done.
	Checking connectivity... done.
	```

	You now have the necessary demo code on your Linux worker host.

### <a name="task2.2"></a> Task 2.2: Build and the Dockerized Application

1. Change into the `linux_tweet_app` directory.

	```
	$ cd ./linux_tweet_app/
	```

2. Export a new environment variable to make some of the commands that follow more "copy / paste" friendly.

	1. Copy the `DTR Hostname` from the bottom of the main PWD screen.

	2. Use the following command to assign that to the `DTR_HOST` environment variable. Remember to substitute the real value from your environment.

		```
		export DTR_HOST=<dtr hostname>
		```
        Note: Sometimes copy / paste commands get mangled by PWD, but they still work. Just paste the command, ignore any mangling, and press `enter`

	3. Create another environment variable, this time containing your username.

		Copy the user name from the bottom of the PWD screen (under credentials it's the first of the two listed).

		```
		export USER=<user name>
		```

	4. Echo both back to ensure they're set.

		```
		echo $DTR_HOST && echo $USER
		```
Docker images are build from something called a `Dockerfile`. Dockerfiles look a lot like any other Linux-based script, except they include a handful of keywords to tell Docker how to process the file. 

Here is the Dockerfile for our tweet app:

    FROM nginx:latest

    COPY index.html /usr/share/nginx/html
    COPY linux.png /usr/share/nginx/html

    EXPOSE 80 443

    CMD ["nginx", "-g", "daemon off;"]

Let's see what each of these lines in the Dockerfile do.

* [FROM](https://docs.docker.com/engine/reference/builder/#from) specifies the base image to use as the starting point for this new image you're creating. For this example we're starting from `nginx:latest`.
* [COPY](https://docs.docker.com/engine/reference/builder/#copy) copies files from the host into the image, at a known location. In our case it copies `index.html` and a graphic that will be used on our webpage.
* [EXPOSE](https://docs.docker.com/engine/reference/builder/#expose) documents which ports the application uses.
* [CMD](https://docs.docker.com/engine/reference/builder/#cmd) specifies what command to run when a container is started from the image. Notice that we can specify the command, as well as run-time arguments.

Docker images are built using the `docker build` command. 

2. Use `docker image build` to build your Linux Tweet web app Docker image. Be sure to include the period (`.`) at the end of the command.

        $ docker image build -t $DTR_HOST/$USER/linux_tweet_app:1.0 .

* The `-t` flag tags the image with a name. In our case the name indicates which DTR server and under which user's repository the image will live. The `1.0` after the image name is referred to as an `image tag` - in this case we've tagged our image with a `1.0` version number. 

* The `.` tells Docker to use the current directory as the build context. 

Your output should be similar to what is shown below.

        Sending build context to Docker daemon  4.096kB
        Step 1/4 : FROM nginx:latest
        latest: Pulling from library/nginx
        ff3d52d8f55f: Pull complete
        b05436c68d6a: Pull complete
        961dd3f5d836: Pull complete
        Digest: sha256:12d30ce421ad530494d588f87b2328ddc3cae666e77ea1ae5ac3a6661e52cde6
        Status: Downloaded newer image for nginx:latest
            ---> 3448f27c273f
        Step 2/4 : COPY index.html /usr/share/nginx/html
            ---> 72d22997a765
        Removing intermediate container e262b9220942
        Step 3/4 : EXPOSE 80 443
            ---> Running in 54e4ff1b39a6
            ---> 2b5bd87894cd
        Removing intermediate container 54e4ff1b39a6
        Step 4/4 : CMD nginx -g daemon off;
            ---> Running in 54020cdec942
            ---> ed5f550fc339
        Removing intermediate container 54020cdec942
        Successfully built ed5f550fc339
        Successfully tagged  $DTR_HOST/$USER/linux_tweet_app:1.0

6. Use the `docker container run` command to start a new container from the image you created.

    Because the host we are using has already allocated port 80 to the Universal Control Plane server,you need to use the `--publish` flag to redirect the web traffic coming in. 
    
    Speccifically, you will publish port 80 inside the container onto port 8088 on the host. This will allow traffic coming in to the Docker host on port 8088 to be directed to port 80 in the container. The format of the `--publish` flag is `host_port`:`container_port`.

    ```
    $ docker container run \
    --detach \
    --publish 8088:80 \
    --name linux_tweet_app \
    $DTR_HOST/$USER/linux_tweet_app:1.0
    ```

    Any external traffic coming into the server on port 8088 will now be directed into the container's web server

7. In a real-world example, a developer would run their application locally on their development machine to check if it's working. Here you will use `curl` to see if you can access the running containerized web app locally since we're in a command line terminal. Later we'll deploy the web app to an Azure server, and you will access it via  your web browser. 

        $ curl localhost:8088

    You should see some HTML output come across your screen. This indicates that your local container is running correctly.

8. Remove the running container

    $ docker container rm --force linux_tweet_app

### <a name="task2.3"></a> Task 2.3: Push the Application Image to Docker Trusted Registry

Now that you have your application built and tested, we'll push it to the Docker Trusted Registry server so it can be deployed onto our Azure-based servers. 

1. Log into your DTR server from the command line.

    ```
    $ docker login $DTR_HOST
    Username: <your username>
    Password: <your password>
    Login Succeeded
    ```

4. Use `docker image push` to upload your image up to Docker Trusted Registry. 

    ```
    $ docker image push $DTR_HOST/$USER/linux_tweet_app:1.0
    ```

    The output should be similar to the following:

    ```
    The push refers to a repository [$DTR_HOST/$USER/linux_tweet_app:1.0]
    feecabd76a78: Pushed
    3c749ee6d1f5: Pushed
    af5bd3938f60: Pushed
    29f11c413898: Pushed
    eb78099fbf7f: Pushed
    latest: digest: sha256:9a376fd268d24007dd35bedc709b688f373f4e07af8b44dba5f1f009a7d70067 size: 1363
    ```

5. In your web browser, head back to your DTR server and click `View Details` next to your `linux_tweet_app` repo to see the details of the repo.

	> **Note**: If you've closed the tab with your DTR server, just click the `DTR` button from the PWD page.

6. Click on `Images` from the horizontal menu. Notice that your newly pushed image is now on your DTR.

### <a name="task2.3"></a> Task 2.4: Deploy the Application to Production

Now you're going to put your application "into production" by creating a new service using Docker Universal Control Plane.

Services are application building blocks (although in many cases an application will only have one service, such as this example). Services are based on a single Docker image. When you create a new service you instantiate at least one container automatically, but you can scale the number up and down to meet the needs of your service.

1. Switch to your UCP server in your web browser by clicking the `UCP` button on the left side of the PWD interface.

    > **Note**: The red warning bar can safely be ignored.  This is an artifact of running in a learning lab envrionment
    >
    > **Note**: If prompted DO NOT upgrade UCP. 

2. In the left hand menu click `Services`.

3. In the upper right corner click `Create Service`.

4. Enter `linux_tweet_app` for the name.

4. Under `Image` enter the path to your image which should be `<DTR hostname>/<your username>/linux_tweet_app:1.0`.

	> **Note**: You need to copy the `DTR hostname`  and `username` from the bottom of the main PWD screen. 

8. From the left hand menu click `Network`.

9. Click `Publish Port+`.

	We need to open a port for our web server. Since port 80 is already used by UCP on one node, and DTR on the other, we'll need to pick an alternate port. We'll go with 8088.

10. Fill out the port fields as shown below.

	![](./images/linux_ports.png)

11. Click `Confirm`.

12. Click `Create` near the bottom right of the screen.

After a few seconds you should see a green dot next to your service name. 
Once you see a green dot move onto the next step

1. Click on the service in the PWD interface. Ths will bring up some information about our service on the right hand side of the screen. 

2. Click on the `Published Endpoints` link a few lines down on the right. This will bring up your running web application

The `linux_tweet_app` is now running as a Docker service. In the next section you will simulate an upgrade to that application. 

## <a name="task3"></a> Task 3: Upgrade the application

In the final section of the lab you will simulate an applicationg upgrade. First you will create a new version of your tweet app and push that to Docker Trusted Registry. Then you will upgrade the production version of the application to this new version

### <a name="task3.1"></a>Task 3.1: Build a New Version of the Application

1. Move back into the console for `worker1` in the PWD interface.

2. Make sure you're in the `linux_tweet_app` directory

        $ cd ~/linux_tweet_app

3. To simulate an update to our application we're going to copy over a new `index.html` file for our web app. In "the real world" a developer would simply  modify whatever source code they needed to change. 

        $ cp index-new.html index.html

4. With the application source code update, you will need to build a new version of the docker image.

        $ docker image build -t $DTR_HOST/$USER/linux_tweet_app:2.0 .

    > **Note**: You tagged the image with `2.0` this time to note it as a new version.
    >
    > **Note**: The build process was much faster this time because Docker only rebuilt the portions of the image that were changed. 

4. Use `docker image push` to upload your image up to Docker Trusted Registry. 

    ```
    $ docker image push $DTR_HOST/$USER/linux_tweet_app:2.0
    ```
    > **Note**: The image push was much faster this time because Docker only needs to push up the modified portions of the application 

5. In your web browser, head back to your DTR server and click `View Details` next to your `linux_tweet_app` repo to see the details of the repo.

	> **Note**: If you've closed the tab with your DTR server, just click the `DTR` button from the PWD page.

6. Click on `Images` from the horizontal menu. Notice that your newly pushed image is now on your DTR alongside your original version.

### <a name="task3.2"></a>Task 3.2: Upgrade the running application

With the new version staged on the DTR server, it's now time to upgrade the currently deployed version. 

1. Move back to UCP in your web browser

2. From the left-hand menu click `Services`

3. Click the `linux_tweet_app` service

4. From the top of the right hand information pane click the `Configure` drop down and select `Details`

5. In order to upgrade the application, you simply need to tell docker to use the `2.0` image. Modify the `Image` field so that the image ends with `2.0` instead of `1.0`

    > **Note**: You'll see that Docker has appended a hash to the end of the originally deployed image name. This ensures the image name is unique. It's safe to remove the has so that your image name simply ends with `/linux_tweet_app2.0`

6. Click `Update` on the bottom right

7. Click on teh service and notice on the right side the `Update Status` is set to `updating`. After a few seconds it will change to `completed`.

8. Click on the link under `Published Endpoints` to see the new version of the web app running. 

    > **Note**: You may need to refresh your web browser to see the updated application.

This concludes our lab, thanks for taking the time to run through it th is afternoon. For more information on how Docker can help modernize your traditional Linux applications, visit https://www.docker.com 
