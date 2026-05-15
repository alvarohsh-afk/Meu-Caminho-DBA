-- Inserindo os dados
INSERT INTO departamentos (nome_depto, localizacao) VALUES ('TI', 'São Paulo');
INSERT INTO departamentos (nome_depto, localizacao) VALUES ('RH', 'Rio de Janeiro');

INSERT INTO funcionarios (nome, cargo, salario, id_depto) VALUES ('Álvaro', 'DBA Junior', 5000, 1);
INSERT INTO funcionarios (nome, cargo, salario, id_depto) VALUES ('Maria', 'Analista de RH', 4500, 2);
COMMIT;

-- O teste final: O JOIN
SELECT f.nome, f.cargo, d.nome_depto, d.localizacao
FROM funcionarios f
JOIN departamentos d ON f.id_depto = d.id_depto;

select d.nome_depto,
       sum(f.salario) as custo_total_salario,
       count(f.id_func) as total_funcionarios
from funcionarios f
join departamentos d on f.id_depto = d.id_depto
group by d.nome_depto;

select nome, cargo, salario
from funcionarios
where id_depto = 1 and salario > 4000;
