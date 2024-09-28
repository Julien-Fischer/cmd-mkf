# Contributing to mkf

We are happy to accept community contributions to help mkf become more intuitive,
efficient, and portable.

The objective of this document is to provide newcomers a meaningful way to get engaged and contribute.


## Table of Contents

* [Coding Style](#coding-style)
    * [File Structure](#file-structure)
    * [Documentation](#documentation)
* [Testing](#testing)
    * [Running tests](#running-tests)
    * [Writing tests](#writing-tests)
* [Getting your merge request accepted](#getting-your-merge-request-accepted)


## Coding Style

This section specifies the conventions used in the source code.
We are still in the process of defining mkf development guidelines, so feel free to share any ideas you'd 
like us to consider or revisit.

### File Structure

Each code file should contain, in this order:

- The Apache 2.0 copyright license header, followed by a blank line
- The function definitions (if any)
- The procedural code consuming these functions

#### Indentation

Code is indented using four spaces. Tab characters are not allowed for indenting code.

#### Naming conventions

Identifier names (variables and functions) use snake_case.
Constants and environment variables use UPPER_SNAKE_CASE.

#### Filename conventions

Bash filenames use lower-kebab-case.

### Documentation

Although "good code is self-documenting", it is incredibly easy to forget what your code
(or someone else's) intended.

A function should be commented when their purpose, potential side effects, or parameters
would benefit from being clarified.

## Testing

Before merging a pull request, the tests should pass.

### Running tests

To run the unit tests, verify that `Docker` is installed:

```
docker --version
```

Then execute the following file:

```
./tests/run-tests.sh
```

This script automatically creates a Docker image from the latest version of the software, builds a container from that 
image, and run the tests.

Note that this script is idempotent so you can run it as many times as you like without cluttering your Docker images
and containers or messing with your own file system.

### Writing tests

To test your code, open `tests/tests.sh` and add new tests or update existing ones as needed. This script is the core 
of our testing suite, and your contributions help us identify issues early and maintain a stable and robust application.

Writing a new test is straightforward:

1. Define the test function
```
function feature_expected_result {
    # Given
        # test preconditions
    # When
        # mkf feature under test
    # Then
    if [[ ... failing condition ... ]]; then
        echo "Failed: feature_expected_result"
        exit 1
    fi
}
```

2. Pass your function to the `test` fixture at the bottom of the file
```
test feature_expected_result
```

Changes such as creating files and navigating directories are automatically cleaned by the `test` function, ensuring
that every test runs in isolation. 

## Getting your merge request accepted

To contribute your code:

1. Fork the project from the `master` branch
2. Create a new branch named `feature/branch-name` for a new feature, or `bugfix/branch-name` for fixing a bug
3. Create one or more commits on your branch
4. Submit your merge request back into `master` with a brief description of your contributions
