
# git log --oneline --since="YYYY-MM-DD" > new_commits.txt

library(Rmonize)
# usethis::use_pkgdown()

devtools::document(roclets = c('rd', 'collate', 'namespace', 'vignette'))
devtools::build_rmd('NEWS.Rmd')

devtools::build_readme()
fs::dir_delete("docs")
pkgdown::build_site()


file.edit("docs/index.html")
# replace ligne 168
<li><a href="authors.html#authors">Citing Rmonize</a></li>



file.edit("docs/authors.html")

# replace ligne 63
        <h1 id="authors">Authors</h1>
  
# insert after ligne 75

     <div class="section level2 aknowledgment-section">
       <div>
       <h1 id="aknowledgment">Acknowledgment</h1>
  
  
  We extend our heartfelt appreciation to all the members of the
  Maelstrom Research team and our valued partners who have played a role in
  making this project possible. 

  <br><br>
  Special thanks go to

  <strong>Zishu Chen</strong>,
  <strong>Samuel El-Bouzaidi Tiali</strong>,
  <strong>Anouar Nechba</strong>,
  <strong>Alexandre Trottier</strong>,
  <strong>Tina Wey</strong>,
  <strong>Rita Wissa</strong> and
  all of your github beta-testers for their contributions to the documentation 
  of the package, input in aligning the package with scientific guidelines and 
  Maelstrom standards and for their dedicated efforts in testing the package and 
  providing insightful enhancements.
  
  <br><br>
    
  Thank you for your outstanding contributions.
  <br><br>
  
       </div>
     </div>


fs::file_move(
  "../Rmonize-documentation/docs/reference/index.html",
  "../Rmonize-documentation/index.html")

fs::dir_delete("../Rmonize-documentation/docs")
fs::dir_copy(
  "../Rmonize/docs",
  "../Rmonize-documentation/docs",
  overwrite = TRUE)

file.edit("../Rmonize-documentation/docs/reference/index.html")
file.edit("../Rmonize-documentation/index.html")

# remplacer from 60-241 to 60-195

fs::file_delete("../Rmonize-documentation/index.html")

browseURL('docs/index.html')

# switch to Rmonize-documentation
source('template_script.R')

# push to git
'update documentation following latest version of the package'

browseURL("https://github.com/maelstrom-research/Rmonize-documentation/actions/")
madshapR_website()
