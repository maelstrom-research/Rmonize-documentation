library(Rmonize)
# usethis::use_pkgdown()

# devtools::document(roclets = c('rd', 'collate', 'namespace', 'vignette'))
# devtools::build_readme()
# devtools::build_rmd('NEWS.Rmd')

fs::dir_delete("docs")
pkgdown::build_site()

fs::file_move(
  "../Rmonize-documentation/docs/reference/index.html",
  "../Rmonize-documentation/index.html")

fs::dir_delete("../Rmonize-documentation/docs")
fs::dir_copy(
  "../Rmonize/docs",
  "../Rmonize-documentation/docs",
  overwrite = TRUE)

fs::file_move(
  "../Rmonize-documentation/index.html",
  "../Rmonize-documentation/docs/reference/index.html")

file.edit("../Rmonize-documentation/docs/reference/index.html")

# switch to documentation
source('template_script.R')

# push to git
"https://github.com/maelstrom-research/Rmonize-documentation/actions/"
Rmonize_help()
