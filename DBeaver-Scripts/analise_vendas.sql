
-- Minha query de análise de vendas
-- Autor: Seu Nome
-- Data: Analise completa

WITH resumo_categoria AS (
  SELECT 
    categoria,
    COUNT(*) as vendas,
    SUM(valor) as receita,
    AVG(valor) as ticket_medio
  FROM vendas
  GROUP BY categoria
)
SELECT 
  *,
  ROUND(receita / SUM(receita) OVER() * 100, 2) as participacao_percentual
FROM resumo_categoria
ORDER BY receita DESC

