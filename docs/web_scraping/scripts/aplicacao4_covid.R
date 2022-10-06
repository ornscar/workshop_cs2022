# requisicao

r <- httr::GET("https://covid.saude.gov.br/"); r

# extrair conteudo da requisicao em formato de texto

httr::content(r, "text") # nenhuma informacao relevante

# url

link_rar <- "https://mobileapps.saude.gov.br/esus-vepi/files/unAFkcaNDeXajurGB7LChj8SgQYS2ptm/a1f358a1398a995f1e4d45b1803e91dd_HIST_PAINEL_COVIDBR_15set2022.rar"

# requisicao

r_rar <- httr::GET(
  link_rar, 
  write_disk("dados_covid.rar", overwrite = TRUE)
); r_rar

# url portal geral

u_portal_geral <- "https://qd28tcd6b5.execute-api.sa-east-1.amazonaws.com/prod/PortalGeral"

# requisicao

r <- httr::GET(u_portal_geral)

httr::content(r)

# requisicao com headers 

r_portal_geral <- httr::GET(
  u_portal_geral, 
  add_headers("x-parse-application-id" = "unAFkcaNDeXajurGB7LChj8SgQYS2ptm")
); r_portal_geral

# ler conteudo da requisicao

httr::content(r_portal_geral)

# acessar a url do arquivo mais atual

link_atual <- httr::content(r_portal_geral) %>% 
  purrr::pluck("results", 1, "arquivo", "url")

# requisicao 

r_covid <- httr::GET(
  link_atual,
  write_disk("dados_covid.rar", overwrite = TRUE)
); r_covid

# url que contem o x-parse

u_js <- "https://covid.saude.gov.br/main-es2015.js"

# requisicao

r_js <- httr::GET(u_js); r_js

# ler conteudo da requisicao em formato de texto

httr::content(r_js, as = "text")


# extrair texto que nao é aspas simples que vem depois de PARSE_APP_ID

codigo <- r_js %>% 
  httr:: content("text", encoding = "UTF-8") %>% 
  stringr::str_extract("(?<=PARSE_APP_ID = ')[^']+") # expressao regular

codigo

# requisicao com x-parse automatico

r_portal_parse <- httr::GET(
  u_portal_geral,
  add_headers("x-parse-application-id" = codigo)
); r_portal_parse

# acessar link mais atual

link_parse <- httr::content(r_portal_parse) %>% 
  purrr::pluck("results", 1, "arquivo", "url")

# requisicao 

r_covid_parse <- httr::GET(
  link_parse,
  write_disk("dados_covid.rar", overwrite = TRUE)
); r_covid_parse






