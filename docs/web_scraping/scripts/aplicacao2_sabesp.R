u_base <- "https://mananciais.sabesp.com.br/api/Mananciais/ResumoSistemas/"
endpoint_data_consulta <- "2022-05-09"

# url valida

u_sabesp <- paste0(u_base, endpoint_data_consulta)

# requisicao

r_sabesp <- httr::GET(u_sabesp); r_sabesp

# ler dados .json e transformar em um data frame

httr::content(r_sabesp, simplifyDataFrame = TRUE)

# selecionar a lista 'sistemas' dentro da lista 'ReturnObj'

httr::content(r_sabesp, simplifyDataFrame = TRUE) %>% 
  purrr::pluck("ReturnObj", "sistemas")

# transformar a lista 'sistemas' em um data frame

d_sabesp <- httr::content(r_sabesp, simplifyDataFrame = TRUE) %>%
  purrr::pluck("ReturnObj", "sistemas") %>% 
  janitor::clean_names() %>% 
  tibble::as_tibble()

d_sabesp
