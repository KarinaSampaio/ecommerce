-- aula manipulacao de tabelas 

use ecommerce;

SELECT * 
FROM ITENS_PEDIDO 
WHERE PRODUCT_ID IN(SELECT ID 
					FROM PRODUTOS 
                    WHERE PRICE < 2000
                    );

SELECT ID_PEDIDO, 
NOME_CLIENTE, 
PRECO, 
CASE WHEN PRECO >= 5000  THEN 'VENDA BOA!'
     WHEN PRECO BETWEEN 3000 AND 5000 THEN 'VENDA NORMAL'
ELSE 'VENDA ZOADA'
END AS classificacao_venda
FROM gold_pedidos;

SELECT *,
CASE WHEN QUANTIDADE_PEDIDOS > 3 THEN 'BOA'
	 WHEN QUANTIDADE_PEDIDOS BETWEEN 2 AND 3 THEN 'NORMAL' 
ELSE 'BAIXO' 
END AS CLASSIFICACAO_CLIENTE
FROM(
	SELECT NOME_CLIENTE, 
	COUNT(DISTINCT ID_PEDIDO) AS QUANTIDADE_PEDIDOS
	FROM gold_pedidos
	GROUP BY 1
	ORDER BY 2 DESC
) AS T;

WITH TotalVendasPorCliente AS (
    SELECT p.client_id, SUM(pr.price) AS TotalVendas,
    MAX(p.created_at) AS DataUltimoPedido
    FROM pedidos p
    JOIN itens_pedido ip ON p.id = ip.transaction_id
    JOIN produtos pr ON ip.product_id = pr.id
    GROUP BY p.client_id
)
SELECT concat(c.first_name,' ',c.last_name) as nome, 
round(tv.TotalVendas,2) as total, 
tv.DataUltimoPedido
FROM clientes c
JOIN TotalVendasPorCliente tv ON c.id = tv.client_id;

-- Exercicio de manipulacao de tabela aula 09 

CREATE TABLE Livros (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Titulo VARCHAR(255),
    Autor VARCHAR(255),
    AnoPublicacao INT,
    Genero VARCHAR(100)
);

INSERT INTO Livros (Titulo, Autor, AnoPublicacao, Genero) VALUES
('Dom Casmurro', 'Machado de Assis', 1899, 'Romance'),
('A Moreninha', 'Joaquim Manuel de Macedo', 1844, 'Romance'),
('Memórias Póstumas de Brás Cubas', 'Machado de Assis', 1881, 'Romance'),
('O Guarani', 'José de Alencar', 1857, 'Romance'),
('Capitães da Areia', 'Jorge Amado', 1937, 'Romance'),
('A Hora da Estrela', 'Clarice Lispector', 1977, 'Romance'),
('Vidas Secas', 'Graciliano Ramos', 1938, 'Romance'),
('O Alienista', 'Machado de Assis', 1882, 'Ficção Científica'),
('Cidades de Papel', 'John Green', 2008, 'Romance'),
('O Pequeno Príncipe', 'Antoine de Saint-Exupéry', 1943, 'Fábula');

ALTER TABLE Livros ADD Editora VARCHAR(255);
ALTER TABLE Livros DROP COLUMN Genero;
ALTER TABLE Livros CHANGE AnoPublicacao Ano INT;

-- Aplicando conceitos de subquery

SELECT Titulo 
FROM Livros
WHERE Autor = 'Machado de Assis' AND Ano < 1900;

SELECT Titulo, Autor 
FROM Livros
WHERE Ano = (SELECT Ano FROM Livros WHERE Titulo = 'Dom Casmurro') AND Titulo = 'Dom Casmurro';



