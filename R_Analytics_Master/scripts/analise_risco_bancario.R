# -------------------------------------------------------------------------
# PROJETO: Monitoramento de Risco de Crédito vs. Exposição Financeira
# OBJETIVO: Análise de Portfólio de Ativos Bancários
# DATA: 08/05/2026
# -------------------------------------------------------------------------

# 1. CARREGAR BIBLIOTECAS
if(!require(ggplot2)) install.packages("ggplot2")
if(!require(scales)) install.packages("scales")
library(ggplot2)
library(scales)

# 2. GERAR DADOS SINTÉTICOS DE ALTO VALOR
set.seed(2026)
df_bancario <- data.frame(
  Transaction_ID = paste0("TXN-", 1000:1499),
  Account_Type = sample(c("Corporate High-Yield", "Retail Premium", "Institutional"), 500, replace = TRUE),
  Asset_Class = sample(c("Fixed Income", "Equities", "Derivatives", "Cash Equivalent"), 500, replace = TRUE),
  Transaction_Value_USD = round(runif(500, min = 15000, max = 850000), 2),
  Credit_Risk_Score = round(rnorm(500, mean = 720, sd = 100), 0)
)

# 3. VISUALIZAÇÃO EXECUTIVA (GGPLOT2)
grafico_risco <- ggplot(df_bancario, aes(x = Credit_Risk_Score, y = Transaction_Value_USD, color = Asset_Class)) +
  geom_point(alpha = 0.6, size = 3) +
  theme_minimal() +
  labs(
    title = "Monitoramento de Risco de Crédito vs. Exposição Financeira",
    subtitle = "Análise de Portfólio de Ativos (Valores em USD)",
    x = "Score de Risco de Crédito",
    y = "Valor da Transação",
    color = "Classe de Ativo"
  ) +
  scale_y_continuous(labels = label_dollar())

# 4. EXIBIR GRÁFICO
print(grafico_risco)