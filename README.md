# Laravel On Shared Host

This is a small open-source tool to let developers mimic shared/vhosts for development.

## Philosophy & Reason

Many would like to use Laravel but without huge infrastructure (e.g.: no Kubernetes, no EKS, no GCP, no AWS) just a good old LAMP stack & shared hosting (or host).
There are cheap shared hosting providers where the user has one directory, and all subdomains are shared on it. Usually, these services provide PHP and MySQL but without any CD/CI tool.
This directory contains the simulation of such an environment, where the virtual host or shared host provides one directory. 
Laravel can not be on the root to avoid routing, and directory hell (Imagine if you try to create an `app` subdomain, that points to the `./app` directory and collides with Laravel's app directory)  

To avoid this scenario and all headaches, the best thing to do is to move Laravel into a directory.  

## Project Structure

| Directory               | Desc                                                 | Details link                                    |
| ----------------------- | ---------------------------------------------------- | ----------------------------------------------- |
| `src`                   | Laravel (example) directory                          | [example doc](src/README.md)                    |
| `config`                | Docker and LAMP related config files (env, htaccess) |                                                 |



## Supported Laravel versions  

| Version    | Tested            | Note       |
| ---------- | ----------------- | ---------- |
| 5.x        | No                |            |
| 8.x        | Yes               |            |
| 10.x       | Yes               |            |
| 11.x       | No                |            |
| Lumen 5    | No


## How it works

There is an example configuration file (.env) and htaccess file in the /config directory. The /src directory represents the Laravel sub-directory. 
The docker container shall copy the source files into its /var/www/html directory, create a `my-laravel` directory, then copy the env and htaccess files and finally, it shall fix the permissions for a few directories to ensure caching and logging working as intended.

<br>

## Usage

### Build the image


```bash
sudo docker build --no-cache -t laravel-on-vhost-1 .
```

### Run the container

Run and attach  

```bash
sudo docker run -p 80:80 -v src:/var/www/html/my-laravel laravel-on-vhost-1
```

Just run as-is  

```bash
sudo docker run -p 80:80 laravel-on-vhost-1
```


### Cleanup

After usage sometime have to clean up  

List containers & remove  

```bash
sudo docker ps -a
sudo docker rm <container-id>
```

List images and remove  

```bash
sudo docker images
sudo docker rmi <image-id>
```

<br>

## GitHub Workflows

The project implements an automatic docker publisher (starter set) workflow file.  A few env should be predefined for the workflow.

| ENV name             |    Note                  |
| -------------------- | ------------------------ |
| `DOCKERHUB_TOKEN`    | For publishing           |
| `DOCKERHUB_USERNAME` | For publishing           |
| `TOKEN`              | For GH                   |

You might have to login into docker

```bash
docker login
```
> Note: a token needed not a password

```bash
docker login ghcr.io
```
> Note the password is a GitHub Access Token!


<br>

## Future features

- [ ] Laravel 11.x version
- [ ] GitHub Action for testing
- [ ] Example aka working minimalistic code
- [ ] Add instructions for Laravel

<br>

## Contribution

Feel free to start a new `issue` or create a Pull-Request with changes.

### Usage & License
- This project is open-source and under `MIT` [license](LICENSE) therefore there are no limitations
- If you used this project somewhere, consider to ping me and share your experience


