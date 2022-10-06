#usethis::edit_r_environ(scope = "project")
#Sys.getenv("API_VAGALUME")

# token de acesso

api_key <- Sys.getenv("API_VAGALUME")

# definir artista

artista <- "mukeka-di-rato"

musicas <- artista %>% 
  vagalumeR::songNames()

musicas

musicas_aleatorias <- musicas %>% 
  dplyr::sample_n(60) %>%      # selecionar 60 musicas aleatoriamente
  pull(song.id) %>%            # acessar coluna 'song.id'
  map_dfr(vagalumeR::lyrics,   # obter data frame que tem a letra das musicas
          artist = "Mukeka di Rato", 
          type = "id", 
          key = api_key,
          message = FALSE)

musicas_aleatorias


# Mineracao de texto ------------------------------------------------------

lyrics <- musicas_aleatorias %>%
  select(text)

# stopwords

stop_words <- c(
  stopwords::stopwords("pt"),
  c("é", 
    "ta", 
    "la", 
    "tá", 
    "lá", 
    "to", 
    "el", 
    "in", 
    "pra", 
    "il", 
    "in", 
    "i", 
    "3x", 
    "2x", 
    "of", 
    "x",
    "the")
)

# analise

analise <- tibble(text = lyrics$text) %>% 
  unnest_tokens(word, text, to_lower = TRUE) %>%
  count(word, sort = TRUE) %>% 
  anti_join(tibble(word = stop_words)) 

# Wordcloud -----------------------------------------

nuvem_musicas <- wordcloud(
  analise$word, 
  analise$n,
  max.words = 100, 
  colors = c("red", "blue", "black"),
  random.order = FALSE, 
  scale = c(2, .5)
)

nuvem_musicas

