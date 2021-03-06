FROM python:3.7-slim AS base
MAINTAINER {{cookiecutter.email}}
ENV PYTHONUNBUFFERED 1
ENV PROJECT_NAME "{{cookiecutter.project_slug}}"
ENV PIB_CONFIG_FILE_LOCATION "/app/assets/cli.yml"
ENV POETRY_VIRTUALENVS_CREATE "false"
LABEL PROJECT={{cookiecutter.project_slug}}

# Mark Container
RUN echo "{{cookiecutter.project_slug}}" > /etc/container_release

# Install Base Dependencies
RUN apt-get update      && \
    apt-get upgrade -y  && \
    apt-get install -y     \
    bash                   \
    build-essential

# Setup directories
RUN mkdir -p /home/user /app
WORKDIR /app

# Create the runtime user, and enforce permissions
RUN useradd user -d /home/user        \
                 -s /bin/bash         \
                 -M                   \
 && chown -R user:user /home/user     \
 && chown -R user:user /app

# Install Latest Poetry
RUN pip install poetry

# Include the local binary folder in PATH
ENV PATH "/home/user/.local/bin/:${PATH}"

# ======================================================

# Development Environment
FROM base AS development
LABEL ENVIRONMENT=DEVELOPMENT
ENV ENVIRONMENT=DEVELOPMENT
ENV GITLEAKSVERSION="v7.2.0"

# Install Dev Dependencies
RUN apt-get install -y              \
    curl                            \
    fish                            \
    golang-github-pelletier-go-toml \
    jq                              \
    openssh-client                  \
    shellcheck                      \
    sudo                            \
    tig                             \
    vim

# Install Git Leaks
RUN curl --fail -sL "https://github.com/zricethezav/gitleaks/releases/download/${GITLEAKSVERSION}/gitleaks-linux-amd64"    \
    -o /usr/bin/gitleaks                                                                                                && \
    chmod +x /usr/bin/gitleaks

# Add user to sudoers, and make the default user
RUN echo "user ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Set the runtime user
USER user

# Copy the codebase
COPY . /app

# Create A Symlink For the Bash Customizations
RUN ln -sf /app/assets/.bash_customize /home/user/.bash_customize

# Setup The Dev CLI
RUN poetry lock                                                 && \
    poetry export --without-hashes --dev -f requirements.txt |     \
    pip install -r /dev/stdin                                   && \
    dev setup-bash

CMD ["./{{cookiecutter.project_slug}}/container_init.sh"]

# ======================================================

# Production Environment
FROM base as production
LABEL ENVIRONMENT=PRODUCTION
ENV ENVIRONMENT=PRODUCTION

# Set the runtime user
USER user

# Copy the codebase
COPY . /app

# Install Production Packages Only
RUN poetry lock                                                 && \
    poetry export --without-hashes -f requirements.txt |           \
    pip install -r /dev/stdin

CMD ["./{{cookiecutter.project_slug}}/container_init.sh"]
