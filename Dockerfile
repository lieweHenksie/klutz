FROM rocker/verse:3.6.2

# INSTALL MINICONDA3 ----
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 ca-certificates curl git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-4.5.11-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

ENV PASSWORD="hello"
ENV ROOT=TRUE

# update conda 
RUN conda update --all

# install python packages
ADD environment.yml /tmp/environment.yml
RUN cd /tmp/ && conda env update --file environment.yml

# install base conda env
RUN python -m ipykernel install --name base


# install r packages
ADD .Renviron /root/.Renviron
ADD installs.R /tmp/installs.R
RUN Rscript /tmp/installs.R && rm /root/.Renviron

# SETUP RSTUDIO USER STUFF
USER rstudio

RUN pip install awscli --user

USER root

# CONTAINER STARTUP ----

# add reticulate python to R startup
RUN echo '\nRETICULATE_PYTHON=/opt/conda/bin/python' >> /usr/local/lib/R/etc/Renviron

# start jupyter hub 
RUN mkdir -p /etc/services.d/jupyter && \
  echo '#!/usr/bin/with-contenv bash\n \
        ## load /etc/environment vars first:\n \
  		  for line in $( cat /etc/environment ) ; do export $line ; done\n \
        jupyter lab --ip=0.0.0.0 --port=8888 --allow-root --NotebookApp.token='' --notebook-dir='/home/rstudio'' \
          > /etc/services.d/jupyter/run