#!/usr/bin/env bash
set -euo pipefail

# Choose a version from https://github.com/conda-forge/miniforge/releases/
miniforge_version="latest"

arch="$(uname -m)"
os="MacOSX" # or "Linux"
base_url="https://github.com/conda-forge/miniforge/releases"

if [[ $miniforge_version == "latest" ]]; then
  miniforge_fname="Miniforge3-${os}-${arch}.sh"
  source_url="${base_url}/latest/download/${miniforge_fname}"
else
  miniforge_fname="Miniforge3-${miniforge_version}-${os}-${arch}.sh"
  source_url="${base_url}/download/${miniforge_version}/${miniforge_fname}"
fi

if [[ ! -f "${HOME}/Downloads/${miniforge_fname}" ]]; then
  wget -P "${HOME}/Downloads" "$source_url"
else
  echo "File '"${HOME}/Downloads/${miniforge_fname}"' already exists."
fi

bash "${HOME}/Downloads/${miniforge_fname}" -bu
"${HOME}/miniforge3/condabin/conda" init zsh
"${HOME}/miniforge3/condabin/conda" update -yn base conda
"${HOME}/miniforge3/condabin/conda" update -yn base --all
"${HOME}/miniforge3/condabin/conda" install -yn base \
  boto3 \
  jupyter \
  jupyterlab \
  jupyterlab_execute_time \
  matplotlib \
  nb_conda_kernels \
  notebook \
  pandas \
  pip \
  pytest \
  pytest-xdist \
  seaborn \
  tabulate \
  toolz
"${HOME}/miniforge3/condabin/conda" config --add create_default_packages ipykernel
