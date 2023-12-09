import runpod


def hello_world(greeting):
    if not isinstance(greeting, str):
        return {"error": "Please provide a String"}

    return f"Hello {greeting}"


def handler(job):
    job_input = job["input"]
    greeting = job_input["greeting"]

    return hello_world(greeting)


# Start the handler only if this script is run directly
if __name__ == "__main__":
    runpod.serverless.start({"handler": handler})
