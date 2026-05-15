CREATE TABLE livros (
    id_livro NUMBER PRIMARY KEY,
    titulo VARCHAR2(100),
    autor VARCHAR2(100),
    genero VARCHAR2(50),
    preco NUMBER(10,2)
);

INSERT INTO livros VALUES (1, 'O Codificador Limpo', 'Robert Martin', 'Tecnologia', 85.00);
INSERT INTO livros VALUES (2, 'SQL Avançado', 'Grimaldo Oliveira', 'Tecnologia', 120.00);
INSERT INTO livros VALUES (3, 'Dom Casmurro', 'Machado de Assis', 'Literatura', 30.00);
INSERT INTO livros VALUES (4, 'Engenharia de Dados', 'Grimaldo Oliveira', 'Tecnologia', NULL); -- Preço Nulo para teste
INSERT INTO livros VALUES (5, 'A Arte da Guerra', 'Sun Tzu', 'Estratégia', 25.00);
INSERT INTO livros VALUES (6, 'Clean Code', 'Robert Martin', 'Tecnologia', 95.00);
INSERT INTO livros VALUES (7, 'O Hobbit', 'J.R.R. Tolkien', 'Fantasia', 45.00);

select count(*) as total_livros from livros;

select autor, avg(nvl(preco,0)) as preço_medio
from livros
group by autor;

select genero, count(*) as qtd_livros
from livros
group by genero;

select genero, max(preco) as preco_max, min(preco) as preco_min
from livros
where preco is not null
group by genero;

select autor, count(*) as qtd_livros
from livros
group by autor
having count(*) >1;

select autor, count(*) as qtd
from livros
group by qtd desc
fetch first 1 rows only;

SELECT autor, COUNT(*) AS qtd
FROM livros
GROUP BY autor
ORDER BY qtd DESC
FETCH FIRST 1 ROWS ONLY;

select autor, avg(nvl(preco, 0)) as media_preco
from livros
group by autor
having avg(nvl(preco, 0)) >10;

select genero,
    listagg(titulo, ', ') within group (order by preco) as livros_do_genero
from livros
group by genero;
-- Inserindo os livros de Augusto Cury (Ansiedade e Jesus)
INSERT INTO livros (id_livro, titulo, autor, genero, preco) VALUES (10, 'Ansiedade: Como enfrentar o mal do século', 'Augusto Cury', 'Psicologia', 35.90);
INSERT INTO livros (id_livro, titulo, autor, genero, preco) VALUES (11, 'Ansiedade 2: Autocontrole', 'Augusto Cury', 'Psicologia', 32.00);
INSERT INTO livros (id_livro, titulo, autor, genero, preco) VALUES (12, 'O Mestre dos Mestres (Jesus)', 'Augusto Cury', 'Teologia/Autoajuda', 40.00);
INSERT INTO livros (id_livro, titulo, autor, genero, preco) VALUES (13, 'O Mestre da Sensibilidade', 'Augusto Cury', 'Teologia/Autoajuda', 38.50);

-- Inserindo C.S. Lewis
INSERT INTO livros (id_livro, titulo, autor, genero, preco) VALUES (20, 'O Peso da Glória', 'C.S. Lewis', 'Literatura Cristã', 45.00);
INSERT INTO livros (id_livro, titulo, autor, genero, preco) VALUES (21, 'Cartas de um Diabo a seu Aprendiz', 'C.S. Lewis', 'Literatura Cristã', 42.90);
INSERT INTO livros (id_livro, titulo, autor, genero, preco) VALUES (22, 'Cristianismo Puro e Simples', 'C.S. Lewis', 'Literatura Cristã', 50.00);

-- Inserindo Teologia Clássica (Institutas e Solas)
INSERT INTO livros (id_livro, titulo, autor, genero, preco) VALUES (30, 'As Institutas - Vol 1', 'João Calvino', 'Teologia Clássica', 120.00);
INSERT INTO livros (id_livro, titulo, autor, genero, preco) VALUES (31, 'As Institutas - Vol 2', 'João Calvino', 'Teologia Clássica', 120.00);
INSERT INTO livros (id_livro, titulo, autor, genero, preco) VALUES (32, 'Sola Gratia', 'Diversos', 'Teologia Clássica', 25.00);
INSERT INTO livros (id_livro, titulo, autor, genero, preco) VALUES (33, 'Sola Scriptura', 'Diversos', 'Teologia Clássica', 25.00);

-- Inserindo Hernandes Dias Lopes
INSERT INTO livros (id_livro, titulo, autor, genero, preco) VALUES (40, 'As Teses de Satanás', 'Hernandes Dias Lopes', 'Comentário Bíblico', 30.00);
INSERT INTO livros (id_livro, titulo, autor, genero, preco) VALUES (41, 'Comentário Expositivo: Romanos', 'Hernandes Dias Lopes', 'Comentário Bíblico', 55.00);

-- Inserindo Pierre Barbet
INSERT INTO livros (id_livro, titulo, autor, genero, preco) VALUES (50, 'A Crucificação de Cristo: Descrita por um Cirurgião', 'Pierre Barbet', 'Científico/Religioso', 60.00);

-- Inserindo a coleção de J.R.R. Tolkien
INSERT INTO livros (id_livro, titulo, autor, genero, preco) VALUES (60, 'O Hobbit', 'J.R.R. Tolkien', 'Fantasia Épica', 49.90);
INSERT INTO livros (id_livro, titulo, autor, genero, preco) VALUES (61, 'O Senhor dos Anéis: A Sociedade do Anel', 'J.R.R. Tolkien', 'Fantasia Épica', 59.90);
INSERT INTO livros (id_livro, titulo, autor, genero, preco) VALUES (62, 'O Senhor dos Anéis: As Duas Torres', 'J.R.R. Tolkien', 'Fantasia Épica', 59.90);
INSERT INTO livros (id_livro, titulo, autor, genero, preco) VALUES (63, 'O Senhor dos Anéis: O Retorno do Rei', 'J.R.R. Tolkien', 'Fantasia Épica', 59.90);
INSERT INTO livros (id_livro, titulo, autor, genero, preco) VALUES (64, 'O Silmarillion', 'J.R.R. Tolkien', 'Fantasia Épica', 45.00);

-- Inserindo Allan Brito e Itamar Sabará
INSERT INTO livros (id_livro, titulo, autor, genero, preco) VALUES (70, 'Antropologia Bíblica (ou título similar)', 'Allan Brito', 'Teologia Pastoral', 48.00);
INSERT INTO livros (id_livro, titulo, autor, genero, preco) VALUES (71, 'A Cultura do Jejum', 'Itamar Sabará', 'Espiritualidade', 35.00);
INSERT INTO livros (id_livro, titulo, autor, genero, preco) VALUES (72, 'Psicologia da Alma (ou título similar)', 'Itamar Sabará', 'Psicologia Cristã', 42.00);

select * from  livros where titulo like '%Anéis%';

select autor, sum(preco) as investimento_total
from livros
group by autor
order by investimento_total desc;
UPDATE livros 
SET autor = 'Allan Brisote' 
WHERE autor = 'Allan Brito';

-- Inserindo os volumes da Coleção Comentário Expositivo (Hernandes Dias Lopes)
INSERT INTO livros (id_livro, titulo, autor, genero, preco) VALUES (100, 'Comentário de Mateus', 'Hernandes Dias Lopes', 'Comentário Bíblico', 45.00);
INSERT INTO livros (id_livro, titulo, autor, genero, preco) VALUES (101, 'Comentário de Marcos', 'Hernandes Dias Lopes', 'Comentário Bíblico', 45.00);
INSERT INTO livros (id_livro, titulo, autor, genero, preco) VALUES (102, 'Comentário de Lucas', 'Hernandes Dias Lopes', 'Comentário Bíblico', 45.00);
INSERT INTO livros (id_livro, titulo, autor, genero, preco) VALUES (103, 'Comentário de João', 'Hernandes Dias Lopes', 'Comentário Bíblico', 45.00);
INSERT INTO livros (id_livro, titulo, autor, genero, preco) VALUES (104, 'Comentário de Romanos', 'Hernandes Dias Lopes', 'Comentário Bíblico', 45.00);
INSERT INTO livros (id_livro, titulo, autor, genero, preco) VALUES (105, 'Comentário de Gálatas', 'Hernandes Dias Lopes', 'Comentário Bíblico', 45.00);
INSERT INTO livros (id_livro, titulo, autor, genero, preco) VALUES (106, 'Comentário de Efésios', 'Hernandes Dias Lopes', 'Comentário Bíblico', 45.00);
INSERT INTO livros (id_livro, titulo, autor, genero, preco) VALUES (107, 'Comentário de Filipenses', 'Hernandes Dias Lopes', 'Comentário Bíblico', 45.00);
INSERT INTO livros (id_livro, titulo, autor, genero, preco) VALUES (108, 'Comentário de Colossenses', 'Hernandes Dias Lopes', 'Comentário Bíblico', 45.00);
INSERT INTO livros (id_livro, titulo, autor, genero, preco) VALUES (109, 'Comentário de Hebreus', 'Hernandes Dias Lopes', 'Comentário Bíblico', 45.00);
INSERT INTO livros (id_livro, titulo, autor, genero, preco) VALUES (110, 'Comentário de Apocalipse', 'Hernandes Dias Lopes', 'Comentário Bíblico', 45.00);

-- Inserindo os livros do Kit (Pregação Expositiva e outros)
INSERT INTO livros (id_livro, titulo, autor, genero, preco) VALUES (111, 'Pregação Expositiva', 'Hernandes Dias Lopes', 'Teologia Pastoral', 38.00);
INSERT INTO livros (id_livro, titulo, autor, genero, preco) VALUES (112, 'João: O Evangelho da Glória', 'Hernandes Dias Lopes', 'Teologia', 42.00);

select autor, sum(preco) as investimento_total
from livros
group by autor
order by investimento_total desc;
-- Sempre use o COMMIT no Oracle para salvar a alteração permanentemente
COMMIT;
commit;

select autor, sum(preco) as investimento_total
from livros
group by autor
order by investimento_total desc; -- Note o ponto e vírgula aqui!
-- Ajuste do preço médio da coleção do Hernandes (1500 / 50 livros = 30 cada)
UPDATE livros SET preco = 30 WHERE autor = 'Hernandes Dias Lopes';

-- Ajuste do nome do Allan Brisote
UPDATE livros SET autor = 'Allan Brisote' WHERE autor = 'Allan Brito';

COMMIT; -- Importante para o Oracle salvar as mudanças

-- 1) Exibe informações da versão do Oracle
SELECT banner
FROM v$version
WHERE banner LIKE 'Oracle%';

-- 2) Exibe o usuário conectado
SELECT SYS_CONTEXT('USERENV','SESSION_USER') AS usuario_conectado,
       SYS_CONTEXT('USERENV','DB_NAME') AS banco,
       SYS_CONTEXT('USERENV','TERMINAL') AS terminal
FROM dual;

-- 3) Teste simples de PL/SQL para confirmar execução
BEGIN
  DBMS_OUTPUT.PUT_LINE('Teste Oracle SQL Developer: Conexão OK!');
END;
/