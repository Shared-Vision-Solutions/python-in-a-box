#!/bin/bash

git init
git stage .
git commit -m "Cookiecutter: Initial Generation"
git checkout -b main
git symbolic-ref HEAD refs/heads/main
git tag v0.0.0
