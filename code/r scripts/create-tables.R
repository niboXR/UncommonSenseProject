
#########
# SETUP #
#########
library(tidyverse)
library(yaml)


# Function to Extract YAML as table
extract_yaml <- function(path) {
  lines <- readLines(path, warn = FALSE)
  if (length(lines) == 0 || lines[1] != "---") return(NULL)
  
  end_idx <- which(lines == "---")[2]
  if (is.na(end_idx)) return(NULL)
  
  yaml_content <- paste(lines[2:(end_idx - 1)], collapse = "\n")
  metadata <- yaml.load(yaml_content)
  
  html_path <- str_replace(path, "\\.md$", ".html") #get html path
  markdown_link <- sprintf("[%s](%s)", metadata$title %||% "", html_path)
  
  tibble(
    Title = metadata$title,
    SummaryMD = metadata$summary,
    SummaryHTML = map_chr(metadata$summary, ~markdown::markdownToHTML(text = .x, fragment.only = TRUE)),
    Link = html_path,
    Publish = metadata$publish,
    Category = str_split_fixed(Link, "/", 3)[,  2],
    Right = metadata$right
  )
}

##########################################
# Build the main archive table from YAML #
##########################################

folders <- c("md/Rights", "md/Issues", "md/Solutions")
files <- unlist(lapply(folders, function(folder) {
  list.files(folder, pattern = "\\.md$", full.names = TRUE)
}))

archive <- map_dfr(files, extract_yaml) %>%
  relocate(Category, .before = Title)

rm(folders, files, extract_yaml)


#####################
# Additional tables #
#####################

# Build the rights table from archive
rights <- archive %>%
  filter(Category == "Rights" & Publish == TRUE & Title != "Example rights") %>%
  select(-Category, -Publish, -Right) %>%
  rename(Right = Title) %>%
  rename(DefinitionMD = SummaryMD) %>% rename(DefinitionHTML = SummaryHTML) %>%
  mutate(
    order = case_when(
      Right == "Voter rights" ~ 1,
      Right == "Health rights" ~ 2,
      Right == "Education rights" ~ 3,
      Right == "Economic rights" ~ 4,
      Right == "Data rights" ~ 5
    )) %>%
  arrange(order) %>% select(-order)


# ISSUES #
issues <- archive %>%
  filter(Category == "Issues" & Publish == TRUE) %>%
  select(-Category)


# Solutions
solutions <- archive %>%
  filter(Category == "Solutions" & Publish == TRUE) %>%
  select(-Category)
