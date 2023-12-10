<div align="center">
  <h1>runpod-worker-helloworld</h1>

  <blockquote>Getting started with a serverless API on <a href="https://www.runpod.io/">RunPod</a></blockquote>

  <img src="assets/construction_site_with_banner_reading_runpod_worker_hello_world.jpg" title="Construction site with a large banner that reads RunPod Worker Hello World RunPod Worker" />
</div>

---

<!-- toc -->

- [Features](#features)
- [Setup](#setup)
- [Local testing](#local-testing)
  * [Run the handler](#run-the-handler)
  * [Unit Tests](#unit-tests)
- [Deploy your image](#deploy-your-image)
  * [Automatically deploy with GitHub Actions](#automatically-deploy-with-github-actions)
    + [Configuration](#configuration)
    + [dev workflow](#dev-workflow)
    + [release workflow](#release-workflow)
  * [Manually](#manually)
- [Use your Docker image on RunPod serverless](#use-your-docker-image-on-runpod-serverless)
- [Interact with your RunPod API](#interact-with-your-runpod-api)
  * [Health status](#health-status)
  * [Access the API: async](#access-the-api-async)
  * [Access the API: synchronous](#access-the-api-synchronous)
- [Acknowledgments](#acknowledgments)
- [Credits](#credits)

<!-- tocstop -->

---

## Features

To help you get started creating your serverless worker on [RunPod](https://www.runpod.io/), we packed some basics and opinions into this "Hello World":
 
* GitHub [dev workflow](#dev-workflow) during development
* GitHub [release workflow](#release-workflow) when you want to publish a fully automated new version
* Foundation for unit testing in [tests](/tests)

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

## Deploy your image

To use your Docker image on [RunPod](https://www.runpod.io/), it must exist in a Docker image registry. We are using [Docker Hub](https://hub.docker.com) for this, but feel free to choose whatever you want. 

### Automatically deploy with GitHub Actions

The repo contains two workflows that publish the image to [Docker Hub](https://hub.docker.com) using GitHub Actions: [dev.yml](.github/workflows/dev.yml) and [release.yml](.github/workflows/release.yml)

#### Configuration

If you want to use this, you should add these secrets to your repository:

| Configuration Variable | Description                                                  | Example Value              |
| ---------------------- | ------------------------------------------------------------ | -------------------------- |
| `DOCKERHUB_USERNAME`   | Your Docker Hub username.                                    | `your-username`            |
| `DOCKERHUB_TOKEN`      | Your Docker Hub token for authentication.                    | `your-token`               |
| `DOCKERHUB_REPO`       | The repository on Docker Hub where the image will be pushed. | `timpietruskyblibla`       |
| `DOCKERHUB_IMG`        | The name of the image to be pushed to Docker Hub.            | `runpod-worker-helloworld` |

#### dev workflow

When you work on your project and want to provide bug fixes or features to your community, you can put them into [dev](.github/workflows/dev.yml). This will do these steps: 

* Build the image
* Push the image to [Docker Hub](https://hub.docker.com) using the `dev` tag

The workflow will be triggered by commits in the `dev` branch.

#### release workflow

When everything is done and you want to create a [release](.github/workflows/release.yml) of your image, it will do these steps:

* Update "Table of Contents" in the `README.md`
* Create a release on GitHub using [Semantic Versioning](https://semver.org) based on [semantic-release](https://semantic-release.gitbook.io) (which only works if you follow one of the [commit message formats](https://semantic-release.gitbook.io/semantic-release/#commit-message-format), the default are the [Angular Commit Message Conventions](https://github.com/angular/angular/blob/main/CONTRIBUTING.md#-commit-message-format) as you can also see in this repo)
* Update the `CHANGELOG.md`
* Build the image
* Push the image to [Docker Hub](https://hub.docker.com) using the release-version and the `latest` tag
* Update the description of the image on [Docker Hub](https://hub.docker.com)

The workflow will be triggered by commits in the `main` branch. 

### Manually

* Create an account on [Dockerhub](https://hub.docker.com/) if you don't have one already
* Login to your account: `docker login`
* Build your Docker image like this `docker build -t <dockerhub_username>/<repository_name>:<tag> --platform linux/amd64 .`, in this case: `docker build -t timpietruskyblibla/runpod-worker-helloworld:latest --platform linux/amd64.`
  * Note: We need to specify the platform here, as this is what RunPod requires. If you don't do this, you might see an error like `exec python failed: Exec format error` when you run your worker on RunPod
* After the image was created, you can see it when you run `docker images`, which provides a list of all images that exist on your computer
* Push your Docker image to Dockerhub like this `docker push <dockerhub_username>/<repository_name>:<tag>`, in this case: `docker push timpietruskyblibla/runpod-worker-helloworld:latest`
* Once this is done, you can check your Dockerhub account to find the image


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
* Your endpoint will be created, you can click on it to see the dashboard and also the different API methods that are available:
  * runsync
  * run
  * status
  * cancel
  * health

## Interact with your RunPod API

* In the [User Settings](https://www.runpod.io/console/serverless/user/settings) click on `API Keys` and then on the `API Key` button
* Save the generated key somewhere, as you will not be able to see it again when you navigate away from the page
* Use cURL or any other tool to access the API using the API key and your Endpoint-ID:
  * Replace `<api_key>` with your key
  * Replace `<endpoint_id>` with the ID of the endpoint, you find that when you click on your endpoint, it's part of the URLs shown at the bottom of the first box

### Health status

```bash
curl -H "Authorization: Bearer <api_key>" https://api.runpod.ai/v2/<endpoint_id>/health
```

### Access the API: async

This will return an `id` that you can then use in the `status` endpoint to find out if your job was processed. 

```bash
# Returns a JSON with the id of the job (<job_id>), use that in the status endpoint
curl -X POST -H "Authorization: Bearer <api_key>" -H "Content-Type: application/json" -d '{"input": {"greeting": "world"}}' https://api.runpod.ai/v2/<endpoint_id>/run

# Returns the output of our script, in this case {"delayTime":17956,"executionTime":137,"id":"<job_id>","output":"Hello world","status":"COMPLETED"}
curl -H "Authorization: Bearer <api_key>" https://api.runpod.ai/v2/<endpoint_id>/status/<job_id>
```

### Access the API: synchronous

This endpoint will wait until the job is done and provide the output of our API as the response:

```bash
curl -X POST -H "Authorization: Bearer <api_key>" -H "Content-Type: application/json" -d '{"input": {"greeting": "world"}}' https://api.runpod.ai/v2/<endpoint_id>/runsync

# {"delayTime":2218,"executionTime":138,"id":"<job_id>","output":"Hello world","status":"COMPLETED"}
```


## Acknowledgments

* Thanks to [Justin Merrell](https://github.com/justinmerrell) from RunPod for [this nice getting started guide](https://blog.runpod.io/serverless-create-a-basic-api/) that was used to create this hello-world guide

## Credits

* The [title image](/assets/construction_site_with_banner_reading_runpod_worker_hello_world.jpg) was generated with [Broom](https://broom.blib.la) (which runs on RunPod using [runpod-worker-comfy](https://github.com/blib-la/runpod-worker-comfy) to generate images with text in [ComfyUI](https://github.com/comfyanonymous/ComfyUI) using SDXL 1.0)