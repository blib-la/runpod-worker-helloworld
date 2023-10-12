# runpod-worker-helloworld

> "Hello World" on [RunPod](https://www.runpod.io/) serverless

---

<!-- toc -->

- [Setup](#setup)
- [Local testing](#local-testing)
- [Deploy to Dockerhub](#deploy-to-dockerhub)
  * [Automatically deploy with Github Actions](#automatically-deploy-with-github-actions)
- [Use your Docker image on RunPod serverless](#use-your-docker-image-on-runpod-serverless)
- [Interact with your RunPod API](#interact-with-your-runpod-api)
  * [Health status](#health-status)
  * [Access the API: async](#access-the-api-async)
  * [Access the API: synchronous](#access-the-api-synchronous)
- [Acknowledgements](#acknowledgements)

<!-- tocstop -->

---

## Setup

* Clone the repo to your computer
* Create an env with [conda](https://www.anaconda.com/download): `conda create --name runpod-helloworld python=3.10`
* Activate the env: `conda activate runpod-helloworld`
* Install the `runpod` lib: `pip install runpod`
* Make sure to have [Docker installed on your computer](https://www.docker.com/get-started/)

## Local testing

Execute `python rp_handler.py`, which will then output something like this:

```
--- Starting Serverless Worker |  Version 1.2.6 ---
INFO   | Using test_input.json as job input.
DEBUG  | Retrieved local job: {'input': {'greeting': 'world'}, 'id': 'local_test'}
INFO   | local_test | Started
DEBUG  | local_test | Handler output: Hello world
DEBUG  | local_test | run_job return: {'output': 'Hello world'}
INFO   | Job local_test completed successfully.
INFO   | Job result: {'output': 'Hello world'}
INFO   | Local testing complete, exiting.
```

## Deploy to Dockerhub

* Create an account on [Dockerhub](https://hub.docker.com/) if you don't have one already
* Login to your account: `docker login`
* Build your Docker image like this `docker build -t <dockerhub_username>/<repository_name>:<tag> --platform linux/amd64 .`, in this case: `docker build -t timpietruskyblibla/runpod-worker-helloworld:latest --platform linux/amd64.`
  * Note: We need to specify the platform here, as this is what RunPod requires. If you don't do this, you might see an error like `exec python failed: Exec format error` when you run your worker on RunPod
* After the image was created, you can see it when you run `docker images`, which provides a list of all images that exist on your computer
* Push your Docker image to Dockerhub like this `docker push <dockerhub_username>/<repository_name>:<tag>`, in this case: `docker push timpietruskyblibla/runpod-worker-helloworld:latest`
* Once this is done, you can check your Dockerhub account to find the image

### Automatically deploy with Github Actions

The repo contains two workflows that publishes the image to Docker hub using Github Actions:

* [docker-dev.yml](.github/workflows/docker-dev.yml): Creates the image and pushes it to Docker hub with the `dev` tag on every push to the `main` branch
* [docker-release.yml](.github/workflows/docker-release.yml): Creates the image and pushes it to Docker hub with the `latest` and the release tag. It will only be triggered when you create a release on GitHub

If you want to use this, you should add these secrets to your repository:

| Configuration Variable | Description                                                  | Example Value              |
| ---------------------- | ------------------------------------------------------------ | -------------------------- |
| `DOCKERHUB_USERNAME`   | Your Docker Hub username.                                    | `your-username`            |
| `DOCKERHUB_TOKEN`      | Your Docker Hub token for authentication.                    | `your-token`               |
| `DOCKERHUB_REPO`       | The repository on Docker Hub where the image will be pushed. | `timpietruskyblibla`       |
| `DOCKERHUB_IMG`        | The name of the image to be pushed to Docker Hub.            | `runpod-worker-helloworld` |

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
  * Active Workers: `0` (keep this low, as we just want to test the hello world)
  * Max Workers: `1` (also keep this low, we just want to test the bare minimum)
  * Idle Timeout: `5` (leave the default)
  * Flash Boot: `enabled` (doesn't cost more, but provides faster boot of our worker, which is good)
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

This endpoint will wait until the job is done and provides the output of our API as the response:

```bash
curl -X POST -H "Authorization: Bearer <api_key>" -H "Content-Type: application/json" -d '{"input": {"greeting": "world"}}' https://api.runpod.ai/v2/<endpoint_id>/runsync

# {"delayTime":2218,"executionTime":138,"id":"<job_id>","output":"Hello world","status":"COMPLETED"}
```


## Acknowledgements

* Thanks to [Justin Merrell](https://github.com/justinmerrell) from RunPod for [this nice getting started guide](https://blog.runpod.io/serverless-create-a-basic-api/) that was used to create this hello-world guide
