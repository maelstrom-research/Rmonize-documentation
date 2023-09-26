
library(harmonizR)
library(madshapR)
library(fabR)
library(fs)
# usethis::use_pkgdown()

devtools::document(roclets = c('rd', 'collate', 'namespace', 'vignette'))
devtools::build_readme()
devtools::build_rmd('NEWS.Rmd')
fs::dir_delete("docs")
pkgdown::build_site()

fs::dir_delete("../Rmonize-documentation/docs")
fs::dir_copy(
  "docs",
  "../Rmonize-documentation/docs",
  overwrite = TRUE)

# switch to documentation
source('template_script.R')

# push to git
"https://github.com/maelstrom-research/Rmonize-documentation/actions/"
harmonizR_help()
