# Exemplo 1 ---------------------------------------------------------------

# url

u_ghibli <- "https://pt.wikipedia.org/wiki/Studio_Ghibli"

# requisicao

r_ghibli <- httr::GET(u_ghibli); r_ghibli

# ler pagina em html

r_ghibli %>% 
  xml2::read_html()

# coletar tabela cuja classe é 'wikitable unsortable'

r_ghibli %>% 
  xml2::read_html() %>%
  xml2::xml_find_all("//table[@class='wikitable unsortable']")

# transformar dados .html em um data frame

tabela_ghibli <- r_ghibli %>% 
  xml2::read_html() %>%
  xml2::xml_find_all("//table[@class='wikitable unsortable']") %>%
  rvest::html_table(header = TRUE) %>% # parsing
  purrr::pluck(1) # acessar tabela da lista

tabela_ghibli

# grafico ano

totoro <- "img/totoro.png" # carregando imagem

tabela_ghibli %>% 
  janitor::clean_names() %>% 
  dplyr::filter(ano != "ASA") %>% # removendo o ano 'asa'
  dplyr::mutate(ano = as.numeric(ano),
                titulo = forcats::fct_reorder(titulo, ano)) %>% # reodernando os filmes por ano
  ggplot(aes(x = ano, y = titulo)) + # grafico #<<
  geom_image(image = totoro, size = .04) + #<<
  theme_classic() + #<<
  theme_light() + #<<
  labs(title = "Ano de lançamento dos filmes do Studio Ghibli", #<<
       x = "", y = "Filme")

# grafico quantidade

tabela_ghibli %>% 
  group_by(diretor) %>% 
  summarise(n = n()) %>% 
  mutate(diretor = forcats::fct_reorder(diretor, -n)) |> 
  ggplot(aes(x = diretor, y = n, fill = diretor)) + # grafico #<<
  geom_bar(stat = "identity") + #<<
  scale_y_continuous(breaks = seq(0, 10, by = 2)) + #<<
  theme_classic() + #<<
  theme_light() + #<<
  scale_fill_ghibli_d("MononokeMedium") + #<<
  geom_label(aes(label = n), position = position_dodge(width = 1), show.legend = FALSE,  color = "white") + #<<
  labs(title = "Número de filmes do Studio Ghibli, por diretor", #<<
       x = "", y = "", color = "diretor") + #<<
  theme(legend.title = element_blank(), #<<
        legend.position = "bottom", #<<
        axis.text.x = element_blank(), #<<
        axis.ticks.x = element_blank())

# Exemplo 2 ---------------------------------------------------------------

# coletar links da tabela cuja classe é 'wikitable unsortable'

links_filmes <- r_ghibli %>% 
  xml2::read_html() %>% # ler arquivo HTML
  xml2::xml_find_all("//table[@class='wikitable unsortable']//a") %>% # coletar todos os nos da tabela dentro das tags <a>
  xml2::xml_attr("href") # coletar atributos href

links_filmes

# validar links

links_filmes <- paste0("https://pt.wikipedia.org", links_filmes); links_filmes

# funcao para obter requisicoes de todos os filmes

get_links <- function(links, ids) {
  arquivo <- paste0("output/", ids, ".html")
  r <- httr::GET(links, write_disk(arquivo, overwrite = TRUE))
  arquivo
}

# funcao para obter as requisicoes com erro

get_progresso <- function(links, ids, progresso) {
  # progresso
  progresso()
  # mapear erros nas requisicoes
  get_erro <- purrr::possibly(get_links, otherwise = "ERRO NA REQUISIÇÃO")
  get_erro(links, ids)
}

# barra de progresso

progressr::with_progress({
  # barra de progresso
  progresso <- progressr::progressor(length(links_filmes))
  purrr::map2(links_filmes, seq_along(links_filmes), 
              get_progresso, p = progresso)
})

# parsing

# transformar dados .html em um data frame

tumulo_vagalumes <- xml2::read_html("output/5.html") %>% 
  rvest::html_table()

tumulo_vagalumes <- tumulo_vagalumes %>% 
  .[[1]] %>% 
  .[c(-1, -2), ]

colnames(tumulo_vagalumes) <- c("categoria", "descricao")

tumulo_vagalumes <- tumulo_vagalumes %>% 
  tidyr::pivot_wider(names_from = "categoria", values_from = "descricao") %>%
  janitor::clean_names() %>% 
  dplyr::rename(
    titulo_br = no_brasil,
    titulo_pt = em_portugal,
    duracao_min = japao1988_cor_89_4_min,
    produtora = companhia_s_produtora_s,
    receita_milhoes = receita
  ) %>% 
  dplyr::mutate(
    titulo_br = stringr::str_sub(titulo_br, end = 22),
    titulo_pt = stringr::str_sub(titulo_pt, end = 23),
    duracao_min = stringr::str_sub(duracao_min, start = 21, end = 22),
    elenco = dplyr::recode(elenco, `Tsutomu TatsumiAyano ShiraishiYoshiko ShinoharaAkemi Yamaguchi` = "Tsutomu Tatsumi, Ayano Shiraishi, Yoshiko Shinohara, Akemi Yamaguchi"),
    genero = dplyr::recode(genero, `drama[5]guerra[6]` = "drama, guerra"),
    lancamento = stringr::str_sub(lancamento, start = 22, end = 31),
    receita_milhoes = stringr::str_sub(receita_milhoes, start = 2, end = 5)
  ) %>% 
  dplyr::select(titulo_br, titulo_pt, duracao_min, direcao, producao, 
                roteiro, baseado_em, genero, lancamento, receita_milhoes)

# tabela

tumulo_vagalumes %>% 
  pivot_longer(
    cols = 1:10, 
    names_to = "categoria", values_to = "descricao"
  ) %>% 
  gt::tab_header(
    title = "Túmulo de Vagalumes", 
    subtitle = "Ficha do filme"
  )





