# Use the R base image
FROM rocker/r-ver:4.4.2

# Install system dependencies required for the R packages
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libxml2-dev \
    libssl-dev \
    && apt-get clean

# Install the required R packages from CRAN 
# Unfortunately, taxize and bold are not available on CRAN anymore so installation from remote is required
RUN R -e "install.packages('plumber')"
RUN R -e "install.packages('remotes')" 
RUN R -e "remotes::install_github('ropensci/bold')"
RUN R -e "remotes::install_github('ropensci/taxize')"

# Copy the API script into the container
COPY api.R /api.R

# Expose port 8000 for the API
EXPOSE 8000

# Set environment variables for API keys (optional, set during container run)
ENV TROPICOS_KEY=""
ENV IUCN_REDLIST_KEY=""
ENV ENTREZ_KEY=""

# Start the API using the plumber package
CMD ["R", "-e", "pr <- plumber::plumb('/api.R'); pr$run(host='0.0.0.0', port=8000)"]
