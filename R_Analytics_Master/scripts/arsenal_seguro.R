
# ============================================
# ARSENAL SEGURO (sem pacotes problemáticos)
# ============================================

carregar_pacotes <- function() {
  
  pacotes <- c(
    "dplyr", "ggplot2", "tidyr", "data.table", "sqldf",
    "plotly", "corrplot", "psych", "Hmisc",
    "caret", "randomForest", "rpart", "pROC",
    "readxl", "jsonlite", "httr"
  )
  
  cat("📚 Carregando pacotes...
")
  for (p in pacotes) {
    suppressPackageStartupMessages(
      library(p, character.only = TRUE, quietly = TRUE)
    )
  }
  cat("✅", length(pacotes), "pacotes carregados!
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
  if (ncol(numericas) > 0) {
    print(psych::describe(numericas, fast = TRUE))
  }
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
║              🎯 ARSENAL SEGURO CARREGADO!                    ║
║                                                              ║
║  ✅ FUNÇÕES DISPONÍVEIS:                                    ║
║     carregar_pacotes()  # Carrega todos os pacotes          ║
║     analise_rapida()    # Análise exploratória              ║
║     criar_dados_teste() # Dados fictícios                   ║
║                                                              ║
║  📌 PACOTES USADOS: dplyr, ggplot2, sqldf, psych, caret     ║
╚══════════════════════════════════════════════════════════════╝
")

