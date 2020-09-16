# Angular Docker


## Usage

Here are some example snippets to help you get started creating a container.

### docker

```
docker create \
  --name=angular \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Europe/London \
  -p 4200:4200 \
  -v </path/to/appdata>:/app \
  -v </path/to/config>:/config \
  --restart unless-stopped \
  joinapis/angular
```

## Parameters

Container images are configured using parameters passed at runtime (such as those above). These parameters are separated by a colon and indicate `<external>:<internal>` respectively. For example, `-p 8080:4200` would expose port `4200` from inside the container to be accessible from the host's IP on port `8080` outside the container.

| Parameter | Function |
| :----: | --- |
| `-p 4200` | default angular port |
| `-e PUID=1000` | for UserID - see below for explanation |
| `-e PGID=1000` | for GroupID - see below for explanation |
| `-e TZ=Europe/London` | Specify a timezone to use EG Europe/London |
| `-v /app` | Contains your content and all relevant app files. |
| `-v /config` | Contains your content and all relevant config files. |

## Environment variables from files (Docker secrets)

You can set any environment variable from a file by using a special prepend `FILE__`.

As an example:

```
-e FILE__PASSWORD=/run/secrets/mysecretpassword
```

Will set the environment variable `PASSWORD` based on the contents of the `/run/secrets/mysecretpassword` file.

## Umask for running applications

For all of our images we provide the ability to override the default umask settings for services started within the containers using the optional `-e UMASK=022` setting.
Keep in mind umask is not chmod it subtracts from permissions based on it's value it does not add. Please read up [here](https://en.wikipedia.org/wiki/Umask) before asking for support.

## User / Group Identifiers

When using volumes (`-v` flags) permissions issues can arise between the host OS and the container, we avoid this issue by allowing you to specify the user `PUID` and group `PGID`.

Ensure any volume directories on the host are owned by the same user you specify and any permissions issues will vanish like magic.

In this instance `PUID=1000` and `PGID=1000`, to find yours use `id user` as below:

```
  $ id username
    uid=1000(dockeruser) gid=1000(dockergroup) groups=1000(dockergroup)
```


&nbsp;
## Support Info

* Shell access whilst the container is running: `docker exec -it angular /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f angular`
* container version number
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' angular`
* image version number
  * `docker inspect -f '{{ index .Config.Labels "build_version" }}' joinapis/angular`

## Updating Info

Most of our images are static, versioned, and require an image update and container recreation to update the app inside. With some exceptions (ie. nextcloud, plex), we do not recommend or support updating apps inside the container.

Below are the instructions for updating containers:

### Via Docker Run/Create
* Update the image: `docker pull joinapis/angular`
* Stop the running container: `docker stop angular`
* Delete the container: `docker rm angular`
* Recreate a new container with the same docker create parameters as instructed above (if mapped correctly to a host folder, your `/data` folder and settings will be preserved)
* Start the new container: `docker start angular`
* You can also remove the old dangling images: `docker image prune`

### Via Watchtower auto-updater (especially useful if you don't remember the original parameters)
* Pull the latest image at its tag and replace it with the same env variables in one run:
  ```
  docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  containrrr/watchtower \
  --run-once angular
  ```

**Note:** We do not endorse the use of Watchtower as a solution to automated updates of existing Docker containers. In fact we generally discourage automated updates. However, this is a useful tool for one-time manual updates of containers where you have forgotten the original parameters. In the long term, we highly recommend using Docker Compose.

* You can also remove the old dangling images: `docker image prune`