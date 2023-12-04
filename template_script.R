#### templates ####

library(tidyverse)
library(fabR)
library(madshapR)
library(Rmonize)
library(fs)

#### data_proc_elem_template ####
data_proc_elem_template <- 
  Rmonize_DEMO$`data_processing_elements - final` %>% 
  as_data_proc_elem() %>%
  slice(27,28) %>%
  mutate(
    index = c(1,2) ,
    input_dataset = c('STUDY_1','STUDY_1'),
    `Mlstr_harmo::algorithm` = c("id_creation","'study_1'"))

#### dataschema_template ####
dataschema_template <- 
  list(Variables = 
         Rmonize_DEMO$`dataschema - final`$Variables %>%
         select(name, `label:en`,valueType) %>% slice(1,2),
       Categories = 
         Rmonize_DEMO$`dataschema - final`$Categories %>%
         select(variable, name, `label:en`, missing) %>% slice(1) %>%
         mutate(variable = 'adm_study', `label:en` = 'Study n. 1', name = 'study_1', missing = FALSE)) %>%
  as_data_dict_mlstr()

#### data_dict_template ####
data_dict_template <- 
  list(Variables = 
         Rmonize_DEMO$data_dict_TOKYO$Variables %>%
         select(name, `label:en`,valueType) %>% slice(1) %>%
         add_row(name = 'cat_example', 
                 `label:en` = "Categorical variable. See 'Categories'", 
                 valueType = 'integer'),
       Categories = 
         Rmonize_DEMO$data_dict_TOKYO$Categories %>%
         select(variable, name, `label:en`, missing) %>% slice(0) %>%
         add_row(variable = 'cat_example', 
                 `label:en` = 'First category' , 
                 name = '1'   , missing = FALSE) %>%
         add_row(variable = 'cat_example', 
                 `label:en` = 'Second category', 
                 name = '2'   , missing = FALSE) %>%
         add_row(variable = 'cat_example', 
                 `label:en` = 'Missing category (Do not want to answer, skip pattern, etc.)', 
                 name = '-77' , missing = TRUE)) %>%
  as_data_dict_mlstr()

#### dataset_template ####
dataset_template <- 
  Rmonize_DEMO$dataset_TOKYO %>%
  select(1) %>%
  slice(1) %>%
  add_column(cat_example = 1L) %>%
  as_dataset(col_id = 'part_id') 

#### dossier_template ####
dossier_template <- 
  dossier_create(list(
    STUDY_1 = data_dict_apply(dataset_template, data_dict_template)))

#### harmonized_dossier_template ####
harmonized_dossier_template <- harmo_process(
  dossier = dossier_template,
  dataschema = dataschema_template,
  data_proc_elem = data_proc_elem_template)

#### test harmonization ####
show_harmo_error(harmonized_dossier_template)

#### ss_dataschema_template ####
ss_dataschema_template <- 
  data_dict_extract(harmonized_dossier_template$STUDY_1)

#### pooled_harmonized_dataset_template ####
pooled_harmonized_dataset_template <- 
  pooled_harmonized_dataset_create(harmonized_dossier_template)

#### harmonized_dataset_template ####
harmonized_dataset_template <- harmonized_dossier_template$STUDY_1

path = "C:/Users/guill/OneDrive/Bureau/R/Rmonize-documentation/"
try(dir_delete(paste0(path,'docs/templates/')),silent = TRUE)

write_excel_allsheets( dataschema_template,                paste0(path,"docs/templates/dataschema - template.xlsx"))
write_excel_allsheets( ss_dataschema_template,             paste0(path,"docs/templates/ss_dataschema - template.xlsx"))
write_excel_allsheets( data_dict_template,                 paste0(path,"docs/templates/data_dictionary - template.xlsx"))
write_excel_allsheets( dossier_template,                   paste0(path,"docs/templates/dossier - template.xlsx"))
write_excel_allsheets( harmonized_dossier_template,        paste0(path,"docs/templates/harmonized_dossier - template.xlsx"))
write_excel_csv2(na = '',   data_proc_elem_template,            paste0(path,"docs/templates/data_processing_elements - template.csv"))
write_excel_csv2(na = '',   dataset_template,                   paste0(path,"docs/templates/dataset - template.csv"))
write_excel_csv2(na = '',   harmonized_dataset_template,        paste0(path,"docs/templates/harmonized_dataset - template.csv"))
write_excel_csv2(na = '',   pooled_harmonized_dataset_template, paste0(path,"docs/templates/pooled_harmonized_dataset - template.csv"))  

dataschema_demo          <- as_dataschema_mlstr(Rmonize_DEMO$`dataschema - final`)
data_proc_elem_demo      <- as_data_proc_elem(Rmonize_DEMO$`data_processing_elements - final`)
data_dict_MELBOURNE_demo <- as_data_dict_mlstr(Rmonize_DEMO$data_dict_MELBOURNE)
data_dict_PARIS_demo     <- as_data_dict_mlstr(Rmonize_DEMO$data_dict_PARIS)
data_dict_TOKYO_demo     <- as_data_dict_mlstr(Rmonize_DEMO$data_dict_TOKYO)
dataset_MELBOURNE_demo   <- Rmonize_DEMO$dataset_MELBOURNE
dataset_PARIS_demo       <- Rmonize_DEMO$dataset_PARIS
dataset_TOKYO_demo       <- Rmonize_DEMO$dataset_TOKYO
input_dossier_demo       <- 
  dossier_create(list(
    dataset_MELBOURNE = dataset_MELBOURNE_demo,
    dataset_PARIS     = dataset_PARIS_demo,
    dataset_TOKYO     = dataset_TOKYO_demo))

write_excel_allsheets(    dataschema_demo,             paste0(path,"demo-files/dataschema - demo.xlsx"))
write_excel_allsheets(    data_dict_MELBOURNE_demo,    paste0(path,"demo-files/data dictionary MELBOURNE - demo.xlsx"))
write_excel_allsheets(    data_dict_PARIS_demo,        paste0(path,"demo-files/data dictionary PARIS - demo.xlsx"))
write_excel_allsheets(    data_dict_TOKYO_demo,        paste0(path,"demo-files/data dictionary TOKYO - demo.xlsx"))
write_excel_allsheets(    input_dossier_demo,          paste0(path,"demo-files/input dossier - demo.xlsx"))
write_excel_csv2(na = '', data_proc_elem_demo,         paste0(path,"demo-files/data_processing_elements - demo.csv"))
write_excel_csv2(na = '', dataset_MELBOURNE_demo,      paste0(path,"demo-files/dataset MELBOURNE - demo.csv"))
write_excel_csv2(na = '', dataset_PARIS_demo,          paste0(path,"demo-files/dataset PARIS - demo.csv"))
write_excel_csv2(na = '', dataset_TOKYO_demo,          paste0(path,"demo-files/dataset TOKYO - demo.csv"))

files2zip <- dir('demo-files', full.names = TRUE)
zip(zipfile = 'demo-files', files = files2zip)
dir_delete('demo-files')
file_copy('demo-files.zip','docs/demo-files.zip',overwrite = TRUE)
file_delete('demo-files.zip')
