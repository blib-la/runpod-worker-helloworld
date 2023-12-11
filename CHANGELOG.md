# [1.6.0](https://github.com/blib-la/runpod-worker-helloworld/compare/1.5.0...1.6.0) (2023-12-11)


### Bug Fixes

* "bash" doesn't exist in "alpine", so use "sh" ([fcb1c3a](https://github.com/blib-la/runpod-worker-helloworld/commit/fcb1c3af01625764077cdbd7edbffebd9b849974))
* added "gcc libc-dev libdffi-dev" to enable builds for mac ([807c377](https://github.com/blib-la/runpod-worker-helloworld/commit/807c3777e88177a06e1da554346da80b9b5a7e1f))
* removed libtcmalloc detection as this is not needed for this basic example ([b6fb8b1](https://github.com/blib-la/runpod-worker-helloworld/commit/b6fb8b1861712e96731f9bef244180952f2f35ca))


### Features

* added "__pycache__" ([4bcee8b](https://github.com/blib-la/runpod-worker-helloworld/commit/4bcee8b27f8f01064e9cabe9a10862136ef1c58a))
* added labels, combined commands, moved installation for requirements before adding the src ([a93e16f](https://github.com/blib-la/runpod-worker-helloworld/commit/a93e16f1af1b3b5c519d341daf3c2bf9fbb2e22f))
* create image for "linux/amd64" and "linux/arm64/v8" during development, to make it testable on MacOS ([73bde20](https://github.com/blib-la/runpod-worker-helloworld/commit/73bde20eeb674ca3e5242b5e20ac1781f8da5271))
* install dependencies from requirements.txt ([d16f2c6](https://github.com/blib-la/runpod-worker-helloworld/commit/d16f2c664dd0a5a4e1a7c3cd8b328190323b14bc))
* moved everything into "src", split "handler" and "hello_world" into two, added "start.sh", added unit tests, added requirements to handle dependencies, BREAKING CHANGE ([5329d4a](https://github.com/blib-la/runpod-worker-helloworld/commit/5329d4a7645961e695e364814950c31a02b15b24))
* provide an easy way to run the docker image locally with compose ([655eaa7](https://github.com/blib-la/runpod-worker-helloworld/commit/655eaa78de3515789cba4407e89408a27c99cb46))
* removed "linux/arm64/v8" as people should build this locally if they need it ([ad30c76](https://github.com/blib-la/runpod-worker-helloworld/commit/ad30c76326dae5d37a1739702ce8c253dc27bc15))
* run unit tests automatically ([2610411](https://github.com/blib-la/runpod-worker-helloworld/commit/26104117b4231f6b66d9f4cdb44b26603a60e32b))
* use "pip3" instead of "pip", updated description ([4b617d3](https://github.com/blib-la/runpod-worker-helloworld/commit/4b617d3d603d32c7d037f9f8192dd17cdf0233b5))
* use bash instead of sh ([83067b7](https://github.com/blib-la/runpod-worker-helloworld/commit/83067b79338007eb92ec9a38d0431ca513db8efe))

# [1.5.0](https://github.com/blib-la/runpod-worker-helloworld/compare/1.4.0...1.5.0) (2023-12-09)


### Features

* update ToC in README.md ([7686519](https://github.com/blib-la/runpod-worker-helloworld/commit/76865192518cbd354b67c20351dd6095fe92df5a))

# [1.4.0](https://github.com/blib-la/runpod-worker-helloworld/compare/1.3.0...1.4.0) (2023-12-09)


### Features

* added "README.md" to get updated ToC into release ([ad00ca3](https://github.com/blib-la/runpod-worker-helloworld/commit/ad00ca36854b05f988e300a60d6fc30e78e3c3d7))
* renamed workflow from "docker-dev" to "dev" ([5800b10](https://github.com/blib-la/runpod-worker-helloworld/commit/5800b102ebb0d45543ea2c56be43d650dd36845e))

# [1.3.0](https://github.com/blib-la/runpod-worker-helloworld/compare/1.2.1...1.3.0) (2023-12-09)


### Features

* generate CHANGELOG.md, added permission "pull-requests" for semantic-release, renamed a few steps to make them more clear ([69d4c35](https://github.com/blib-la/runpod-worker-helloworld/commit/69d4c35ce8d90ef83a07b263ec5b5a9f38e95403))
