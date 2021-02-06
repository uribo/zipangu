FROM rocker/tidyverse:4.0.3@sha256:1ce8340f3deee657a5c9cb6005762211880a11fc3ead1539ef8aa48d462146bb

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
  install2.r --error --ncpus -1 --repos 'https://cran.microsoft.com/snapshot/2021-02-05/' \
    arabic2kansuji \
    magick \
    pkgdown \
    rhub \
    roxygen2 && \
  installGithub.r \
    r-lib/revdepcheck && \
  rm -rf /tmp/downloaded_packages/ /tmp/*.rds
