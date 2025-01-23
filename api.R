# install.packages("plumber") if not already installed
library(plumber)
library(taxize)

# Retrieve API keys from environment variables
tropicos_key <- Sys.getenv("TROPICOS_KEY", unset = "")
iucn_key <- Sys.getenv("IUCN_REDLIST_KEY", unset = "")
entrez_key <- Sys.getenv("ENTREZ_KEY", unset = "")

#* Convert a list of common names to scientific names
#* @param common_names A JSON array of common species names
#* @param db The data source to use for species lookup (optional)
#* @post /comm2sci
#* @serializer json
function(req, res) {
  # Parse the incoming JSON data from the request body
  body <- jsonlite::fromJSON(req$postBody)
  
  # Extract common names and db parameter
  common_names <- body$common_names
  db <- body$db %||% "ncbi"  # Default to "ncbi" if no db is provided
  
  # Ensure that the input is a list (check for JSON array)
  if (is.null(common_names) || length(common_names) == 0) {
    res$status <- 400
    return(list(error = "No common names provided"))
  }
  
  # Get scientific names for the common names using taxize with API keys if available
  tryCatch({
    sci_names <- comm2sci(common_names, db = db)
    
    # Return the result directly as a named vector (mapping common names to scientific names)
    return(sci_names)
  }, error = function(e) {
    # Handle errors if there's an issue with the API or the request
    res$status <- 500
    return(list(error = e$message))
  })
}
