# url

u_chance <- "http://www.chancedegol.com.br/br20.htm"

# requisicao

r_chance <- httr::GET(u_chance); r_chance

# ler arquivo html

xml2::read_html(r_chance, encoding = "latin1")

# coletar tabela

xml2::read_html(r_chance, encoding = "latin1") %>% 
  xml2::xml_find_first("//table")

# transformar os dados .html em um data frame

d_chance <- xml2::read_html(r_chance, encoding = "latin1") %>% 
  xml2::xml_find_first("//table") %>% 
  rvest::html_table(header = TRUE) %>% # parsing
  janitor::clean_names()

d_chance

# coletar nós da tabela em que a cor é igual a vermelho

xml2::read_html(r_chance, encoding = "latin1") %>% 
  xml2::xml_find_first("//table") %>% 
  xml2::xml_find_all(".//font[@color='#FF0000']")

# extrair texto das probabilidades em vermelho

p_verm <- xml2::read_html(r_chance, encoding = "latin1") %>% 
  xml2::xml_find_first("//table") %>% 
  xml2::xml_find_all(".//font[@color='#FF0000']") %>% 
  xml2::xml_text()

p_verm

# manipulacao

d_chance <- d_chance %>% 
  mutate(probs_verm = p_verm, # robabilidades em vermelho coletadas
         realidade = case_when( # resultado real
           probs_verm == vitoria_do_mandante ~ "mandante",
           probs_verm == vitoria_do_visitante ~ "visitante",
           TRUE ~ "empate"),
         prob_max = pmax(vitoria_do_mandante, # probabilidade maxima entre os resultados
                         empate, 
                         vitoria_do_visitante),
         chute = case_when( # 
           prob_max == vitoria_do_mandante ~ "mandante",
           prob_max == vitoria_do_visitante ~ "visitante",
           TRUE ~ "empate"),
         acertou = case_when( # acertos e erros do modelo
           realidade == chute ~ "sim",
           TRUE ~ "não"))

# acuracia

acuracia <- sum(d_chance$acertou == "sim") / length(d_chance$acertou)

round(acuracia, 2)