vendas %>%
  group_by(categoria) %>%
  summarise(total = sum(valor)) %>%
  mutate(participacao = round(total / sum(total) * 100, 1)) %>%
  arrange(desc(total))