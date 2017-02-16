
## Ref :https://www.kaggle.com/neerakr/d/benhamner/nips-2015-papers/find-similar-papers-knn
## http://blogs.mathworks.com/loren/2016/08/08/text-mining-machine-learning-research-papers-with-matlab/

## Reading the data

PaperAuthors <- read.csv("release-2016-02-29-02-26-09/output/PaperAuthors.csv",header = TRUE)
Authors <- read.csv("release-2016-02-29-02-26-09/output/Authors.csv",header = TRUE)


# The data comes as the raw data files, a transformed CSV file, and a SQLite database

library(readr)
library(RSQLite)

# You can read in the SQLite datbase like this
db <- dbConnect(dbDriver("SQLite"), "release-2016-02-29-02-26-09/output/database.sqlite")
Papers <- dbGetQuery(db, "
                     SELECT *
                     FROM Papers
                     ")
## We have 403 papers with their content in Papers dataframe

## Defining some functions that
# A function that takes paper_id and papers_data as input and gives its index
# A function that takes index as input and gives its paper_id

givenPaperID_giveIndex <- function(id,text){
  return(text[text['Id'] == id][1])
}

Ex_paper_id = 5941
Ex_paper_index = givenPaperID_giveIndex(Ex_paper_id, Papers)
Papers[1,'PaperText']


##  Clean Abstract and PaperText:
# Clean text from \n \x and things like that by
# Replace \n and \x0c with space
# Apply unicode
# Make everything lower case

library(stringi)
clean_text <- function(text){
  list_of_cleaning_signs = c('\x0c', '\n','†')
  for (x in list_of_cleaning_signs){
    text = gsub(x," ",text)
  }
  text = gsub("[[:punct:]]"," ",text)
  text = gsub("[[:space:]]"," ",text)
  #text = stringi::stri_unescape_unicode(text)
  text = tolower(text)
  text = 
  return(text)
}

## Applying the functions on the data frame
Papers <- as.data.frame(Papers)
Papers$PaperText_Clean <- apply(Papers['PaperText'],2,clean_text)
Papers$Abstract_clean <- apply(Papers['Abstract'],2,clean_text)
