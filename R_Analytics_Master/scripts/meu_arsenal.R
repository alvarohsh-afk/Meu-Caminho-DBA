
# ============================================================
# SEU ARSENAL PESSOAL - "meu_arsenal.R"
# ============================================================

carregar_pacotes <- function() {
  
  pacotes <- c(
    "tidyverse", "dplyr", "tidyr", "data.table", "sqldf",
    "ggplot2", "plotly", "corrplot", "GGally",
    "psych", "summarytools", "Hmisc",
    "caret", "randomForest", "rpart", "pROC",
    "readxl", "jsonlite", "httr"
  )
  
  faltantes <- pacotes[!pacotes %in% installed.packages()[, "Package"]]
  
  if (length(faltantes) > 0) {
    cat("📦 Instalando:", paste(faltantes, collapse = ", "), "
")
    install.packages(faltantes, quiet = TRUE)
  }
  
  cat("📚 Carregando pacotes...
")
  for (p in pacotes) {
    suppressPackageStartupMessages(library(p, character.only = TRUE, quietly = TRUE))
  }
  cat("✅ Pacotes carregados!
")
}

analise_rapida <- function(dados) {
  cat("
📊 Dimensões:", nrow(dados), "x", ncol(dados), "
")
  cat("
📋 Primeiras linhas:
")
  print(head(dados, 3))
  cat("
📈 Resumo numérico:
")
  numericas <- dados[, sapply(dados, is.numeric)]
  if (ncol(numericas) > 0) print(summary(numericas))
  cat("
✅ Análise concluída!
")
}

criar_dados_teste <- function(n = 100) {
  set.seed(123)
  data.frame(
    id = 1:n,
    valor = runif(n, 10, 1000),
    categoria = sample(c("A", "B", "C"), n, replace = TRUE),
    score = rnorm(n, mean = 500, sd = 100)
  )
}

cat("
╔══════════════════════════════════════════════════════════════╗
║              🎯 ARSENAL PESSOAL CARREGADO!                   ║
║                                                              ║
║  ✅ FUNÇÕES DISPONÍVEIS:                                    ║
║     carregar_pacotes()  # Instala/carrega tudo              ║
║     analise_rapida()    # Análise exploratória              ║
║     criar_dados_teste() # Dados fictícios para testar       ║
╚══════════════════════════════════════════════════════════════╝
")

