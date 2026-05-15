
# ============================================
# AGENTE IA NO R (API Google Gemini)
# ============================================

library(httr)
library(jsonlite)

perguntar_gemini <- function(pergunta, chave_api) {
  
  resposta <- POST(
    url = "https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateContent",
    query = list(key = chave_api),
    body = list(
      contents = list(
        list(
          parts = list(
            list(text = pergunta)
          )
        )
      )
    ),
    encode = "json"
  )
  
  conteudo <- content(resposta)
  texto <- conteudo$candidates[[1]]$content$parts[[1]]$text
  return(texto)
}

cat("Agente IA carregado! Use: perguntar_gemini(sua pergunta, sua chave)
")

