# ============================================================
# ANÁLISE PLENO: AMAZON REVIEWS
# Nível: Pleno Profissional
# O que você vai entregar:
#   - Análise exploratória completa
#   - NLP básico (sentimento, palavras-chave)
#   - Modelagem preditiva (nota do review)
#   - Insights de negócio
#   - Visualizações profissionais
# ============================================================

# ============================================================
# PARTE 1: CONFIGURAÇÃO (roda uma vez)
# ============================================================

# Limpar ambiente
rm(list = ls())
gc()

# Carregar arsenal seguro
if (file.exists("arsenal_seguro.R")) {
  source("arsenal_seguro.R")
} else {
  # Se não tiver o arsenal, carrega os pacotes necessários
  pacotes <- c("tidyverse", "ggplot2", "dplyr", "tidyr", "sqldf",
               "textdata", "tidytext", "wordcloud", "reshape2",
               "caret", "randomForest", "rpart", "pROC")
  
  for (p in pacotes) {
    if (!require(p, character.only = TRUE, quietly = TRUE)) {
      install.packages(p, quiet = TRUE)
      library(p, character.only = TRUE)
    }
  }
}

cat("✅ Ambiente configurado!\n")

# ============================================================
# PARTE 2: CRIAR DADOS SIMULADOS DE AMAZON REVIEWS
# (caso não tenha o arquivo real)
# ============================================================

# Se você tiver o arquivo real do Kaggle, use:
# reviews <- read.csv("amazon-reviews.csv")

# Se NÃO tiver, criamos dados simulados REALISTAS:
set.seed(42)

reviews <- data.frame(
  review_id = 1:1000,
  product_id = sample(paste0("B00", sample(1000:9999, 100)), 1000, replace = TRUE),
  product_category = sample(c("Electronics", "Books", "Clothing", "Home & Kitchen", "Toys"), 1000, replace = TRUE),
  rating = sample(1:5, 1000, replace = TRUE, prob = c(0.05, 0.05, 0.10, 0.30, 0.50)),
  review_text = character(1000),
  reviewer_name = sample(paste0("user_", 1:200), 1000, replace = TRUE),
  review_date = sample(seq.Date(as.Date("2023-01-01"), as.Date("2024-12-31"), by = "day"), 1000, replace = TRUE),
  helpful_votes = sample(0:50, 1000, replace = TRUE),
  total_votes = sample(0:60, 1000, replace = TRUE)
)

# Gerar textos de review realistas
review_templates <- list(
  "1" = c("Terrible product", "Waste of money", "Very disappointed", "Poor quality", "Do not buy"),
  "2" = c("Not great", "Could be better", "Average at best", "Disappointed", "Meh"),
  "3" = c("It's okay", "Nothing special", "Decent product", "Works as expected", "Fine"),
  "4" = c("Good product", "Happy with purchase", "Works well", "Recommended", "Good value"),
  "5" = c("Excellent!", "Best purchase ever", "Love it!", "Amazing quality", "Highly recommended")
)

for (i in 1:nrow(reviews)) {
  rating_char <- as.character(reviews$rating[i])
  templates <- review_templates[[rating_char]]
  reviews$review_text[i] <- sample(templates, 1)
}

# Adicionar algumas palavras específicas por categoria
reviews$review_text <- case_when(
  reviews$product_category == "Electronics" ~ paste(reviews$review_text, "device electronic"),
  reviews$product_category == "Books" ~ paste(reviews$review_text, "book read interesting"),
  reviews$product_category == "Clothing" ~ paste(reviews$review_text, "shirt fit comfortable"),
  TRUE ~ reviews$review_text
)

cat("✅ Dados criados:", nrow(reviews), "reviews\n")
cat("   Período:", min(reviews$review_date), "a", max(reviews$review_date), "\n\n")

# ============================================================
# PARTE 3: ANÁLISE EXPLORATÓRIA (DESCRITIVA)
# ============================================================

cat("========== ANÁLISE EXPLORATÓRIA ==========\n\n")

# 3.1 Distribuição das avaliações
cat("📊 Distribuição das notas:\n")
rating_dist <- table(reviews$rating)
print(rating_dist)
cat("   Média geral:", mean(reviews$rating), "\n")
cat("   Mediana:", median(reviews$rating), "\n\n")

# 3.2 Análise por categoria
cat("📊 Desempenho por categoria:\n")
categoria_stats <- reviews %>%
  group_by(product_category) %>%
  summarise(
    total_reviews = n(),
    rating_medio = mean(rating),
    desvio_rating = sd(rating),
    perc_5_estrelas = mean(rating == 5) * 100,
    helpful_rate = mean(helpful_votes / (total_votes + 1) * 100, na.rm = TRUE)
  ) %>%
  arrange(desc(rating_medio))

print(categoria_stats)

# 3.3 Evolução temporal
cat("\n📈 Evolução mensal das notas:\n")
reviews$month <- format(reviews$review_date, "%Y-%m")
evolucao <- reviews %>%
  group_by(month) %>%
  summarise(
    rating_medio = mean(rating),
    total_reviews = n()
  )
print(head(evolucao, 6))

# ============================================================
# PARTE 4: NLP BÁSICO (ANÁLISE DE SENTIMENTO)
# ============================================================

cat("\n========== ANÁLISE DE SENTIMENTO ==========\n")

# 4.1 Tokenização e palavras mais frequentes
library(tidytext)

# Palavras mais comuns em reviews positivas (5 estrelas)
palavras_positivas <- reviews %>%
  filter(rating >= 4) %>%
  unnest_tokens(word, review_text) %>%
  anti_join(stop_words, by = "word") %>%
  count(word, sort = TRUE) %>%
  head(10)

cat("\n⭐ Palavras mais comuns em reviews POSITIVAS:\n")
print(palavras_positivas)

# Palavras mais comuns em reviews negativas (1-2 estrelas)
palavras_negativas <- reviews %>%
  filter(rating <= 2) %>%
  unnest_tokens(word, review_text) %>%
  anti_join(stop_words, by = "word") %>%
  count(word, sort = TRUE) %>%
  head(10)

cat("\n💀 Palavras mais comuns em reviews NEGATIVAS:\n")
print(palavras_negativas)

# 4.2 Nuvem de palavras
if (require(wordcloud, quietly = TRUE)) {
  todas_palavras <- reviews %>%
    unnest_tokens(word, review_text) %>%
    anti_join(stop_words, by = "word") %>%
    count(word, sort = TRUE)
  
  wordcloud(words = todas_palavras$word, 
            freq = todas_palavras$n,
            max.words = 50,
            random.order = FALSE,
            colors = brewer.pal(8, "Dark2"))
}

# ============================================================
# PARTE 5: MODELAGEM PREDITIVA (PREVER NOTA DO REVIEW)
# ============================================================

cat("\n========== MODELAGEM PREDITIVA ==========\n")

# 5.1 Preparar features
modelo_dados <- reviews %>%
  mutate(
    # Features numéricas
    review_length = nchar(review_text),
    has_exclamation = as.numeric(grepl("!", review_text)),
    has_question = as.numeric(grepl("\\?", review_text)),
    possui_palavra_alta = as.numeric(grepl("excellent|amazing|love|best", tolower(review_text))),
    possui_palavra_baixa = as.numeric(grepl("terrible|waste|poor|bad", tolower(review_text))),
    
    # Usar utilidade do review
    helpful_percent = helpful_votes / (total_votes + 1) * 100,
    
    # Categorical
    product_category = as.factor(product_category)
  ) %>%
  select(rating, review_length, has_exclamation, has_question, 
         possui_palavra_alta, possui_palavra_baixa, helpful_percent, product_category)

# 5.2 Divisão treino/teste
set.seed(123)
indices <- createDataPartition(modelo_dados$rating, p = 0.7, list = FALSE)
treino <- modelo_dados[indices, ]
teste <- modelo_dados[-indices, ]

# 5.3 Regressão Linear
modelo_lm <- lm(rating ~ . - product_category, data = treino)
pred_lm <- predict(modelo_lm, teste)
rmse_lm <- sqrt(mean((teste$rating - pred_lm)^2))
cat("\n📈 Regressão Linear - RMSE:", round(rmse_lm, 3))

# 5.4 Random Forest
modelo_rf <- randomForest(rating ~ ., data = treino, ntree = 100)
pred_rf <- predict(modelo_rf, teste)
rmse_rf <- sqrt(mean((teste$rating - pred_rf)^2))
cat("\n🌲 Random Forest - RMSE:", round(rmse_rf, 3))

cat("\n\n🏆 Melhor modelo:", ifelse(rmse_rf < rmse_lm, "Random Forest", "Regressão Linear"))
cat("\n   Redução de erro:", round((1 - rmse_rf/rmse_lm) * 100, 1), "%\n")

# 5.5 Importância das variáveis
if (exists("modelo_rf")) {
  importancia <- importance(modelo_rf)
  cat("\n📊 Importância das variáveis:\n")
  importancia_df <- data.frame(variavel = rownames(importancia), importancia = importancia[, 1])
  importancia_df <- importancia_df[order(-importancia_df$importancia), ]
  print(importancia_df)
}

# ============================================================
# PARTE 6: INSIGHTS DE NEGÓCIO (O QUE IMPORTA)
# ============================================================

cat("\n========== INSIGHTS E RECOMENDAÇÕES ==========\n\n")

# Insight 1: Qual categoria precisa de mais atenção?
pior_categoria <- categoria_stats$product_category[which.min(categoria_stats$rating_medio)]
cat("🔴 CATEGORIA CRÍTICA:", pior_categoria, 
    "- média de", round(min(categoria_stats$rating_medio), 2), "estrelas\n")
cat("   Recomendação: Investigar produtos desta categoria prioritariamente\n\n")

# Insight 2: Relação entre utilidade do review e nota
cor_helpful_rating <- cor(reviews$helpful_votes, reviews$rating)
cat("📊 Correlação utilidade vs nota:", round(cor_helpful_rating, 3), "\n")
if (cor_helpful_rating > 0) {
  cat("   Reviews com notas altas tendem a ser considerados MAIS úteis\n\n")
} else {
  cat("   Reviews com notas baixas recebem mais votos de utilidade\n\n")
}

# Insight 3: O que faz um review ser bem avaliado?
cat("🔑 FATORES QUE MAIS INFLUENCIAM NOTA:\n")
for (i in 1:min(3, nrow(importancia_df))) {
  cat("   ", i, "-", importancia_df$variavel[i], "\n")
}

# ============================================================
# PARTE 7: VISUALIZAÇÕES PROFISSIONAIS
# ============================================================

cat("\n========== GERANDO VISUALIZAÇÕES ==========\n")

# Gráfico 1: Distribuição das notas
p1 <- ggplot(reviews, aes(x = as.factor(rating), fill = as.factor(rating))) +
  geom_bar() +
  geom_text(stat = "count", aes(label = after_stat(count)), vjust = -0.5) +
  scale_fill_manual(values = c("red", "orange", "yellow", "lightgreen", "darkgreen")) +
  theme_minimal() +
  labs(title = "Distribuição das Avaliações Amazon",
       subtitle = paste("Média geral:", round(mean(reviews$rating), 2), "estrelas"),
       x = "Nota", y = "Quantidade de Reviews") +
  theme(legend.position = "none")
print(p1)

# Gráfico 2: Nota média por categoria
p2 <- ggplot(categoria_stats, aes(x = reorder(product_category, rating_medio), 
                                  y = rating_medio, fill = rating_medio)) +
  geom_col() +
  geom_text(aes(label = round(rating_medio, 2)), hjust = -0.2) +
  coord_flip() +
  scale_fill_gradient(low = "red", high = "darkgreen") +
  theme_minimal() +
  labs(title = "Nota Média por Categoria",
       x = "Categoria", y = "Nota Média") +
  theme(legend.position = "none")
print(p2)

# Gráfico 3: Evolução temporal
p3 <- ggplot(evolucao, aes(x = as.Date(paste0(month, "-01")), y = rating_medio)) +
  geom_line(color = "steelblue", size = 1.2) +
  geom_point(color = "steelblue", size = 2) +
  geom_smooth(method = "lm", se = FALSE, color = "red", linetype = "dashed") +
  theme_minimal() +
  labs(title = "Evolução da Satisfação ao Longo do Tempo",
       subtitle = "Linha vermelha mostra tendência",
       x = "Mês", y = "Nota Média")
print(p3)

# ============================================================
# PARTE 8: EXPORTAR RESULTADOS
# ============================================================

cat("\n========== EXPORTANDO RESULTADOS ==========\n")

# Salvar resumo executivo
sink("analise_amazon_resumo.txt")
cat("RELATÓRIO EXECUTIVO - ANÁLISE DE REVIEWS AMAZON\n")
cat("===============================================\n\n")
cat("Data da análise:", Sys.Date(), "\n")
cat("Total de reviews analisados:", nrow(reviews), "\n\n")
cat("PRINCIPAIS MÉTRICAS:\n")
cat("- Nota média:", round(mean(reviews$rating), 2), "/5\n")
cat("- Categoria com melhor nota:", categoria_stats$product_category[1], "\n")
cat("- Categoria com pior nota:", pior_categoria, "\n\n")
cat("MODELAGEM PREDITIVA:\n")
cat("- Melhor modelo:", ifelse(rmse_rf < rmse_lm, "Random Forest", "Regressão Linear"), "\n")
cat("- Erro médio de predição (RMSE):", round(min(rmse_lm, rmse_rf), 3), "\n")
sink()

cat("✅ Resumo executivo: analise_amazon_resumo.txt\n")
cat("✅ Gráficos gerados na tela\n")
cat("✅ Dados processados disponíveis em 'reviews'\n")

# ============================================================
# CONCLUSÃO
# ============================================================

cat("\n
╔══════════════════════════════════════════════════════════════════╗
║                    🎯 ANÁLISE CONCLUÍDA!                         ║
║                                                                  ║
║  O QUE VOCÊ ENTREGOU:                                           ║
║  ✅ Análise exploratória completa                               ║
║  ✅ NLP básico (palavras-chave + nuvem)                         ║
║  ✅ Modelagem preditiva (RMSE =", round(min(rmse_lm, rmse_rf), 3), ")                  ║
║  ✅ Insights de negócio acionáveis                              ║
║  ✅ Visualizações profissionais                                 ║
║  ✅ Resumo executivo exportado                                  ║
║                                                                  ║
║  PRÓXIMOS PASSOS (NÍVEL SÊNIOR):                                ║
║  • Rodar com dados reais do Kaggle                              ║
║  • Adicionar análise de sentimento avançada (BERT)              ║
║  • Criar dashboard interativo (Shiny)                           ║
║  • Automatizar relatório semanal                                ║
╚══════════════════════════════════════════════════════════════════╝
")
