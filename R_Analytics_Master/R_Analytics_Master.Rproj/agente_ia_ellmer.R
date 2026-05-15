
library(ellmer)

# Conectar ao Gemini
chat <- chat_google_gemini()

# Função para perguntar rapidamente
perguntar <- function(pergunta) {
  resposta <- chat$chat(pergunta)
  cat(resposta)
}

cat("✅ Agente IA carregado! Use: perguntar("sua pergunta")
")

