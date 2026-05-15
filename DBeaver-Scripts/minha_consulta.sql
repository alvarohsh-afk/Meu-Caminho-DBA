
-- Minha primeira query SQL no R
-- Analisando dados de vendas

SELECT 
  categoria,
  COUNT(*) as total_transacoes,
  SUM(valor) as receita_total,
  AVG(valor) as ticket_medio
FROM vendas
GROUP BY categoria
ORDER BY receita_total DESC

