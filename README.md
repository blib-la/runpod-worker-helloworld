<div align="center">
  <h1>runpod-worker-helloworld</h1>

  <blockquote>Getting started with a serverless endpoint on <a href="https://www.runpod.io/">RunPod</a> by creating a custom worker</blockquote>

  <img src="assets/construction_site_with_banner_reading_runpod_worker_hello_world.jpg" title="Construction site with a large banner that reads 'RunPod Worker Hello World'" />
</div>

---

<!-- toc -->

- [Features](#features)
- [Setup](#setup)
- [Local testing](#local-testing)
  * [Run the handler](#run-the-handler)
  * [Unit Tests](#unit-tests)
  * [Run the Docker image](#run-the-docker-image)
- [Build and release your Docker image](#build-and-release-your-docker-image)
  * [Automatically with GitHub Actions](#automatically-with-github-actions)
    + [Configuration](#configuration)
    + [Dev Workflow](#dev-workflow)
    + [Release Workflow](#release-workflow)
  * [Manually](#manually)
    + [Build the Docker image](#build-the-docker-image)
    + [Push the Docker image to Docker Hub](#push-the-docker-image-to-docker-hub)
- [Use your Docker image on RunPod serverless](#use-your-docker-image-on-runpod-serverless)
- [Interact with your RunPod endpoint](#interact-with-your-runpod-endpoint)
  * [Health status of your endpoint](#health-status-of-your-endpoint)
  * [Start an async job](#start-an-async-job)
  * [Start a sync job](#start-a-sync-job)
  * [Get the status of a specific job](#get-the-status-of-a-specific-job)
- [Where to go from here?](#where-to-go-from-here)
- [Acknowledgments](#acknowledgments)
- [Credits](#credits)

<!-- tocstop -->

---

## Features

This project provides a set of starting points for creating your worker (= Docker image) to create a custom serverless endpoint on [RunPod](https://www.runpod.io/):

* Simple [start script](src/start.sh) that makes sure to start the handler and whatever you need your worker to have, so that it can do its work (like starting [ComfyUI](https://github.com/comfyanonymous/ComfyUI))
* Basic [handler]([src/rp_handler.py](src/rp_handler.py)), that you can extend with the business logic that you need for your use case
* GitHub [dev](#dev-workflow) workflow during the development of your Docker image
* GitHub [release](#release-workflow) workflow when you want to publish a fully automated new version of your Docker image
* Foundation for [unit tests](/tests) to get started with Test-driven development (TDD)

## Setup

* Clone the repo to your computer
* Create a virtual environment: `python -m venv venv`
* Activate the virtual environment: 
  * Windows: `.\venv\Scripts\activate` 
  * Mac / Linux: `source ./venv/bin/activate`
* Install the dependencies: `pip install -r requirements.txt`
* Make sure to have [Docker installed on your computer](https://www.docker.com/get-started/) if you want to build the image locally

## Local testing

### Run the handler

Execute `python src/rp_handler.py`, which will then output something like this:

```bash
--- Starting Serverless Worker |  Version 1.3.7 ---
INFO   | Using test_input.json as job input.
DEBUG  | Retrieved local job: {'input': {'greeting': 'world'}, 'id': 'local_test'}
INFO   | local_test | Started
DEBUG  | local_test | Handler output: Hello world
DEBUG  | local_test | run_job return: {'output': 'Hello world'}
INFO   | Job local_test completed successfully.
INFO   | Job result: {'output': 'Hello world'}
INFO   | Local testing complete, exiting.
```

### Unit Tests

Run all tests: `python -m unittest discover`, which will then output something like this:

```bash
...
----------------------------------------------------------------------
Ran 3 tests in 0.000s

OK
```

### Run the Docker image

We included a [docker-compose.yml](docker-compose.yml) which makes it possible to easily run the Docker image locally: `docker-compose up`

This will only work for Linux-based systems, as we only create an image for Linux, as this is what RunPod requires. To do this for Mac or Windows, you have to follow the steps to [build the image manually](#build-the-docker-image). Make sure to build the image with the `dev` tag, as this is used in the [docker-compose.yml](docker-compose.yml).  


## Build and release your Docker image

To use your Docker image on [RunPod](https://www.runpod.io/), it must exist in a Docker image registry. We are using [Docker Hub](https://hub.docker.com) for this, but feel free to choose whatever you want. 

### Automatically with GitHub Actions

The repo contains two workflows that publish the image to [Docker Hub](https://hub.docker.com) using GitHub Actions: [dev.yml](.github/workflows/dev.yml) and [release.yml](.github/workflows/release.yml). 

This process is highly opinionated and you should adapt it to what you are used to. 

#### Configuration

If you want to use these workflows, you have to add these secrets to your repository:

| Configuration Variable | Description                                                  | Example Value              |
| ---------------------- | ------------------------------------------------------------ | -------------------------- |
| `DOCKERHUB_USERNAME`   | Your Docker Hub username.                                    | `your-username`            |
| `DOCKERHUB_TOKEN`      | Your Docker Hub token for authentication.                    | `your-token`               |
| `DOCKERHUB_REPO`       | The repository on Docker Hub where the image will be pushed. | `timpietruskyblibla`       |
| `DOCKERHUB_IMG`        | The name of the image to be pushed to Docker Hub.            | `runpod-worker-helloworld` |

#### Dev Workflow

When you are developing your image and want to provide bug fixes or features to your community, you can put them into the `dev` branch. This will trigger the [dev](.github/workflows/dev.yml) workflow, which runs these steps: 

* Execute the unit tests
* Build the image
* Push the image to [Docker Hub](https://hub.docker.com) using the `dev` tag

#### Release Workflow

When development is done and you are ready for a new release of your image, you can put all your changes into the `main` branch. This will trigger the [release](.github/workflows/release.yml) workflow, which runs these steps:

* Execute the unit tests
* Update "Table of Contents" in the `README.md`
* Create a release on GitHub using [Semantic Versioning](https://semver.org) based on [semantic-release](https://semantic-release.gitbook.io) (which only works if you follow one of the [commit message formats](https://semantic-release.gitbook.io/semantic-release/#commit-message-format), the default are the [Angular Commit Message Conventions](https://github.com/angular/angular/blob/main/CONTRIBUTING.md#-commit-message-format) as you can also see in this repo)
* Update the `CHANGELOG.md`
* Build the image
* Push the image to [Docker Hub](https://hub.docker.com) and tag it with both the release version and `latest`
* Update the description of the image on [Docker Hub](https://hub.docker.com)

### Manually

#### Build the Docker image

* Build your Docker image like this `docker build -t <dockerhub_username>/<repository_name>:<tag> --platform linux/amd64 .`, in this case: `docker build -t timpietruskyblibla/runpod-worker-helloworld:latest --platform linux/amd64 .`
  * We need to specify the platform here, as this is what RunPod requires. If you don't do this, you might see an error like `exec python failed: Exec format error` when you run your worker on RunPod, depending on the OS you are using locally
  * If you want to run your image locally and you are not using a Linux-based OS, then you have to use the appropriate platform:
    * Windows: `docker build -t <dockerhub_username>/<repository_name>:<tag> --platform windows/amd64 .`
    * MacOS with Apple Silicon: `docker build -t <dockerhub_username>/<repository_name>:<tag> --platform linux/arm64 .`
* After the image is created, you can see it when you run `docker images`, which provides a list of all images that exist on your computer

#### Push the Docker image to Docker Hub

* Create an account on [Docker Hub](https://hub.docker.com/) if you don't have one already
* Login to your account: `docker login`
* Push your Docker image to [Docker Hub](https://hub.docker.com/) like this `docker push <dockerhub_username>/<repository_name>:<tag>`, in this case: `docker push timpietruskyblibla/runpod-worker-helloworld:latest`
* Once this is done, you can check your [Docker Hub](https://hub.docker.com/) account to find the image


## Use your Docker image on RunPod serverless

* Create a [new template](https://runpod.io/console/serverless/user/templates) by clicking on `New Template` 
* In the dialog, configure:
  * Template Name: `runpod-worker-helloworld` (it can be anything you want)
  * Container Image: `<dockerhub_username>/<repository_name>:tag`, in this case: `timpietruskyblibla/runpod-worker-helloworld:latest`
* You can leave everything as it is, as this repo is public
* Click on `Save Template`
* Navigate to [`Serverless > Endpoints`](https://www.runpod.io/console/serverless/user/endpoints) and click on `New Endpoint`
* In the dialog, configure:
  * Endpoint Name: `hellworld`
  * Select Template: `runpow-worker-helloworld` (or what ever name you gave your template)
  * Active Workers: `0` (keep this low, as we just want to test the Hello World)
  * Max Workers: `3` (recommended default is 3)
  * Idle Timeout: `5` (leave the default)
  * Flash Boot: `enabled` (doesn't cost more, but provides faster boot for our worker, which is good)
  * Advanced: Leave the defaults
  * Select a GPU that has some availability
  * GPUs/Worker: `1` (keep this low as we are just testing, we don't need multiple GPUs for a hello world)
* Click `deploy`
* Your endpoint will be created, you can click on it to see the dashboard and also the available API methods:
  * `runsync`: Sync request to start a job, where you can wait for the job result
  * `run`: Async request to start a job, where you receive an `id` immediately
  * `status`: Sync request to find out what the status of a job is, given `id`
  * `cancel`: Sync request to cancel a job, given `id`
  * `health`: Sync request to check the health of the endpoint to see if everything is fine

## Interact with your RunPod endpoint

* In the [User Settings](https://www.runpod.io/console/serverless/user/settings) click on `API Keys` and then on the `API Key` button
* Save the generated key somewhere, as you will not be able to see it again when you navigate away from the page
* Use cURL or any other tool to access the API using the API key and your Endpoint-ID:
  * Replace `<api_key>` with your key
  * Replace `<endpoint_id>` with the ID of the endpoint, you find that when you click on your endpoint, it's part of the URLs shown at the bottom of the first box

### Health status of your endpoint

```bash
curl -H "Authorization: Bearer <api_key>" https://api.runpod.ai/v2/<endpoint_id>/health
```

### Start an async job

This will return an `id` that you can then use in the `status` endpoint to find out if your job was completed. 

```bash
# Returns a JSON with the id of the job (<job_id>), use that in the status endpoint
curl -X POST -H "Authorization: Bearer <api_key>" -H "Content-Type: application/json" -d '{"input": {"greeting": "world"}}' https://api.runpod.ai/v2/<endpoint_id>/run

# {"id":"<job_id>","status":"IN_QUEUE"}
```

### Start a sync job

This endpoint will wait until the job is done and provide the output of our API as the response.

If you do a sync request to an endpoint that has no free workers to pick up the job, you will wait for some time. Either your job will be picked up if a worker gets free or the job gets added to the queue (provided by the endpoint), which will result in you receiving an `id`. You then have to manually ask the `/status` endpoint to get information about when the job was completed. 

```bash
curl -X POST -H "Authorization: Bearer <api_key>" -H "Content-Type: application/json" -d '{"input": {"greeting": "world"}}' https://api.runpod.ai/v2/<endpoint_id>/runsync

# {"delayTime":2218,"executionTime":138,"id":"<job_id>","output":"Hello world","status":"COMPLETED"}
```

### Get the status of a specific job

```bash
curl -H "Authorization: Bearer <api_key>" https://api.runpod.ai/v2/<endpoint_id>/status/<job_id>

# {"delayTime":3289,"executionTime":1054,"id":"<job_id>","output":"Hello world","status":"COMPLETED"}
```

## Where to go from here?

* [RunPod Workers](https://github.com/runpod-workers): A list of workers provided by RunPod

## Acknowledgments

* Thanks to [Justin Merrell](https://github.com/justinmerrell) from RunPod for [this nice getting started guide](https://blog.runpod.io/serverless-create-a-basic-api/) that was used to create this hello-world guide

## Credits

* The [title image](/assets/construction_site_with_banner_reading_runpod_worker_hello_world.jpg) was generated with [Broom](https://broom.blib.la) (which runs on RunPod using [runpod-worker-comfy](https://github.com/blib-la/runpod-worker-comfy) to generate images with text in [ComfyUI](https://github.com/comfyanonymous/ComfyUI) using SDXL 1.0)