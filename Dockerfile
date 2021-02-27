FROM rocker/tidyverse:4.0.3@sha256:19535c1284a7d4ab677780998dc3fd4bfc22dd9dd8e1d2767f3c7e9797e7e51b

RUN set -x && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    libmagick++-dev && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

ARG GITHUB_PAT

RUN set -x && \
  echo "GITHUB_PAT=$GITHUB_PAT" >> /usr/local/lib/R/etc/Renviron

RUN set -x && \
  install2.r --error --ncpus -1 --repos 'https://cran.microsoft.com/snapshot/2021-02-26/' \
    arabic2kansuji \
    magick \
    pkgdown \
    rhub \
    roxygen2 && \
  installGithub.r \
    r-lib/revdepcheck && \
  rm -rf /tmp/downloaded_packages/ /tmp/*.rds
