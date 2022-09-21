CREATE DATABASE ECommerce;
USE ECommerce;
-- DROP DATABASE Ecommerce;

CREATE TABLE Cliente_Fisico(
	IdCliente_Fisico INT AUTO_INCREMENT PRIMARY KEY,
    Fnome VARCHAR(10),
    Mnome VARCHAR(10),
    Lnome VARCHAR(15),
    CPF CHAR(11) NOT NULL,
    Endereço VARCHAR(255),
    CONSTRAINT unique_cpf_cliente_fisico UNIQUE(CPF),
    RG CHAR(9) NOT NULL,
    CONSTRAINT unique_rg_cliente_fisico UNIQUE(RG)
);

CREATE TABLE Cliente_Juridico(
	IdCliente_Juridico INT AUTO_INCREMENT PRIMARY KEY,
    ENome VARCHAR(45),
    CNPJ CHAR(15) NOT NULL,
    Endereço VARCHAR(45),
    Inscrição_estadual CHAR(9) NOT NULL,
    CONSTRAINT unique_inscrição_estadual_cliente_juridico UNIQUE(Inscrição_estadual),
    CONSTRAINT unique_cnpj_cliente UNIQUE(CNPJ)
);

CREATE TABLE Produto(
	IdProduto INT AUTO_INCREMENT PRIMARY KEY,
    PNome VARCHAR(45) NOT NULL,
    Categoria ENUM('eletrônico','vestimento', 'brinquedo', 'alimentos', 'Móveis') NOT NULL,
    Descrição VARCHAR(255),
    Valor FLOAT,
    Avaliação FLOAT DEFAULT 0,
    Size VARCHAR(10)
);

CREATE TABLE Pagamento(
	IdPagamento INT AUTO_INCREMENT PRIMARY KEY,
    IdPagamentoCliente_Fisico INT,
    IdPagamentoCliente_Juridico INT,
    Tipo_de_Pagamento ENUM('Boleto', 'Cartão', 'Cheque', 'Dois Cartões'),
    Limite_Disponivel FLOAT,
    CONSTRAINT fk_pagamento_cliente_fisico FOREIGN KEY(IdPagamentoCliente_Fisico) REFERENCES Cliente_Fisico(IdCliente_Fisico),
    CONSTRAINT fk_pagamento_cliente_juridico FOREIGN KEY(IdPagamentoCliente_Juridico) REFERENCES Cliente_Juridico(IdCliente_Juridico)
);

CREATE TABLE Pedido(
	IdPedido INT AUTO_INCREMENT PRIMARY KEY,
    IdPedidoCliente_Fisico INT,
    IdPedidoCliente_Juridico INT,
    IdPedidoFormas_de_Pagamento INT,
    Código_de_Rastreio CHAR(13),
    PedidoStatus ENUM('Cancelado', 'Confirmado', 'Em Processamento', 'Enviado') DEFAULT 'Em Processamento',
    PedidoDescrição VARCHAR(255),
    PedidoFrete FLOAT DEFAULT 0,
    PagamentoCash BOOLEAN DEFAULT FALSE,
    CONSTRAINT unique_codigo_de_rastreio_pedido UNIQUE(Código_de_Rastreio),
    CONSTRAINT fk_pedido_cliente_fisico FOREIGN KEY(IdPedidoCliente_Fisico) REFERENCES Cliente_Fisico(IdCliente_Fisico),
    CONSTRAINT fk_pedido_cliente_juridico FOREIGN KEY(IdPedidoCliente_Juridico) REFERENCES Cliente_Juridico(IdCliente_Juridico),
    CONSTRAINT fk_pedido_formas_de_pagamento FOREIGN KEY(IdPedidoFormas_de_Pagamento) REFERENCES Pagamento(IdPagamento)
);

CREATE TABLE Estoque(
	IdEstoque INT AUTO_INCREMENT PRIMARY KEY,
    Elocal VARCHAR(45),
    Quantidade INT DEFAULT 0
);

CREATE TABLE Fornecedor(
	IdFornecedor INT AUTO_INCREMENT PRIMARY KEY,
    Razão_Social VARCHAR(255) NOT NULL,
    CNPJ CHAR(15) NOT NULL,
    CONTATO CHAR(11) NOT NULL,
    CONSTRAINT unique_cnpj_fornecedor UNIQUE(CNPJ)
);

CREATE TABLE Vendedor(
	IdVendedor INT AUTO_INCREMENT PRIMARY KEY,
    Razão_Social VARCHAR(255) NOT NULL,
    Nome_Fantasia VARCHAR(255),
    CNPJ CHAR(15),
    CPF CHAR(9),
    VLocal VARCHAR(255),
    CONTATO CHAR(11) NOT NULL,
    CONSTRAINT unique_cnpj_vendedor UNIQUE(CNPJ),
    CONSTRAINT unique_cpf_vendedor UNIQUE(CPF)
);

CREATE TABLE ProdutoVendedor(
	IdVVendedor INT,
    IdVProduto INT,
    Quantidade INT DEFAULT 1,
    PRIMARY KEY (IdVVendedor, IdVProduto),
    CONSTRAINT fk_produto_vendedor FOREIGN KEY(IdVVendedor) REFERENCES Vendedor(IdVendedor),
    CONSTRAINT fk_produto_vproduto FOREIGN KEY(IdVProduto) REFERENCES Produto(IdProduto)
);

CREATE TABLE ProdutoPedido(
	IdPPedido INT,
    IdPProduto INT,
    Quantidade INT DEFAULT 1,
    PPStatus ENUM('Disponível', 'Sem estoque') DEFAULT 'Disponível',
    PRIMARY KEY (IdPPedido, IdPProduto),
    CONSTRAINT fk_produto_pedido FOREIGN KEY(IdPPedido) REFERENCES Pedido(IdPedido),
    CONSTRAINT fk_produto_pproduto FOREIGN KEY(IdPProduto) REFERENCES Produto(IdProduto)
);

CREATE TABLE ProdutoEstoque(
	IdEEstoque INT,
    IdEProduto INT,
    PLocal VARCHAR(255) NOT NULL,
    Quantidade INT DEFAULT 1,
    PRIMARY KEY (IdEEstoque, IdEProduto),
    CONSTRAINT fk_produto_estoque FOREIGN KEY(IdEEstoque) REFERENCES Estoque(IdEstoque),
    CONSTRAINT fk_produto_eproduto FOREIGN KEY(IdEProduto) REFERENCES Produto(IdProduto)
);

CREATE TABLE ProdutoFornecedor(
	IdFFornecedor INT,
    IdFProduto INT,
    Quantidade INT NOT NULL,
    PRIMARY KEY (IdFFornecedor, IdFProduto),
    CONSTRAINT fk_produto_fornecedor FOREIGN KEY(IdFFornecedor) REFERENCES Fornecedor(IdFornecedor),
    CONSTRAINT fk_produto_fproduto FOREIGN KEY(IdFProduto) REFERENCES Produto(IdProduto)
);

SHOW TABLES;

INSERT INTO Cliente_Fisico (Fnome, Mnome, Lnome, CPF, Endereço, RG)
	VALUES ('Maria','M','Silva',12345678901,'Rua Silva de Prato 29, Carangola - Cidade das Flores',208894550),
		   ('Matheus','O','Pimentel',09876543219,'Rua Alemeda 289, Centro - Cidade das Flores', 345567329),
           ('Ricardo','F','Silva',35257842480,'Avenida Alemeda Vinha 1009, Centro - Cidade das Flores', 998455629),
           ('Josiane','V','Barbosa',33075605647,'Rua Pedro Alvares Cabral 940, Centro - Nilópolis', 209008755),
           ('Zuila','A','Silva',77895314598,'Rua Pedro Alvares Cabral 938, Centro - Nilópolis', 657990046),
           ('Isabele','M','Cruz',55438206517,'Rua Alemida das Flores 28, Centro - Cidade das Flores',341009678);
           
INSERT INTO Produto (PNome, Categoria, Avaliação, Size) 
	VALUES ('Fone de ouvido', 'eletrônico', '4', NULL),
		   ('Barbie Elsa','brinquedo','3',NULL),
           ('Body Carters', 'vestimento','5',NULL),
           ('Microfone Vedo - Youtuber', 'eletrônico','4',NULL),
           ('Sofá retrátil', 'Móveis', '3','3x57x80'),
           ('Farinha de arroz','alimentos','2',NULL),
           ('Fire Stick Amazon','eletrônico','3',NULL);
 
-- Tipo_de_Pagamento ENUM('Boleto', 'Cartão', 'Cheque', 'Dois Cartões'),
INSERT INTO Pagamento (IdPagamentoCliente_Fisico, Tipo_de_Pagamento, Limite_Disponivel)
			VALUES ('1', 'Cartão', '1000.0'),
				   ('2', 'Cheque', NULL),
                   ('3', 'Boleto', NULL),
                   ('4', 'Cartão', '10000.0'),
                   ('5', 'Cartão', '5000.0'),
                   ('6', 'Cartão', '7500.0');
                   
-- PedidoStatus ENUM('Cancelado', 'Confirmado', 'Em Processamento', 'Enviado') DEFAULT 'Em Processamento'
DELETE FROM pedido WHERE IdPedidoCliente_Fisico IN (1,2,3,4);
INSERT INTO Pedido (IdPedidoCliente_Fisico, PedidoStatus, PedidoDescrição, PedidoFrete, PagamentoCash)
	VALUES ('1', DEFAULT, 'Compra via Aplicativo', NULL, 1),
           ('2', DEFAULT, 'Compra via Aplicativo', 50, 0),
           ('3', 'Confirmado', NULL, NULL, 1),
           ('4', DEFAULT,'Compra via Aplicativo', 150, 0);
SELECT * FROM Pedido;
SELECT * FROM Produto;
-- PPStatus ENUM('Disponível', 'Sem estoque') DEFAULT 'Disponível'
DESC ProdutoPedido;
INSERT INTO ProdutoPedido (IdPProduto, IdPPedido, Quantidade, PPStatus)
	VALUES (29,9,2,NULL),
		   (30,9,1,NULL),
           (31,10,1,NULL);
DELETE FROM Estoque WHERE IdEstoque IN (1,2,3);
SELECT * FROM Estoque;
INSERT INTO Estoque (Elocal, Quantidade)
	VALUES ('Rio de Janeiro', 1000),
		   ('Rio de Janeiro', 500),
           ('São Paulo', 10),
           ('São Paulo', 100),
           ('São Paulo', 10),
           ('Brasília', 60);

SELECT * FROM Produto; 
INSERT INTO ProdutoEstoque (IdEEstoque,IdEProduto,PLocal)
	VALUES (5,29,'RJ'),
		   (9,30,'GO');

INSERT INTO Fornecedor (Razão_Social, CNPJ, CONTATO)
	VALUES ('Almeida e Filhos', 429473620184927, '21985474223'),
		   ('Eletrônicos Silva', 298735590216452, '21480234615'),
           ('Eletrônicos Valma', 752105376529876, '21931764298');
           
SELECT * FROM Fornecedor;
INSERT INTO ProdutoFornecedor (IdFFornecedor, IdFProduto, Quantidade)
	VALUES (1,29,500),
		   (1,30,400),
           (2,32,633),
           (3,31,5),
           (2,33,10);
           
INSERT INTO Vendedor (Razão_Social, Nome_Fantasia, CNPJ, CPF, VLocal, CONTATO)
	VALUES ('Tech eletronics', NULL, 389145075387312, NULL, 'Rio de Janeiro', 21480432187),
		   ('Botique Durgas', NULL, NULL, 780148327, 'Rio de Janeiro', 21840627905),
           ('Kids World', NULL, 845097214689052, NULL, 'São Paulo', 11941096803);
           
SELECT * FROM Pedido;

INSERT INTO ProdutoVendedor (IdVVendedor, IdVProduto, Quantidade)
	VALUES (1,34,80),
		   (2,35,10);
           
SELECT COUNT(*) FROM Cliente_Fisico;
SELECT * FROM Cliente_Fisico c, Pedido p WHERE c.IdCliente_Fisico = IdPedidoCliente_Fisico;

SELECT Fnome,Mnome,Lnome,IdPedido,PedidoStatus FROM Cliente_Fisico c, Pedido p WHERE c.IdCliente_Fisico = IdPedidoCliente_Fisico;
SELECT concat(Fnome, ' ',Mnome,' ',Lnome) as Cliente,IdPedido as Pedido,PedidoStatus as Status FROM Cliente_Fisico c, Pedido p WHERE c.IdCliente_Fisico = IdPedidoCliente_Fisico;

INSERT INTO Pedido (IdPedidoCliente_Fisico, PedidoStatus, PedidoDescrição, PedidoFrete, PagamentoCash)
	VALUES (2, DEFAULT, 'Compra via Aplicativo', NULL, 1);
    
SELECT * FROM Cliente_Fisico c, Pedido p WHERE c.IdCliente_Fisico = IdPedidoCliente_Fisico GROUP BY IdPedido;

SELECT * FROM Cliente_Fisico LEFT OUTER JOIN Pedido ON IdCliente_Fisico = IdPedidoCliente_Fisico;

SELECT IdCliente_Fisico,Fnome, count(*) as Número_de_Pedidos FROM Cliente_Fisico INNER JOIN Pedido ON IdCliente_Fisico = IdPedidoCliente_Fisico
			INNER JOIN ProdutoPedido ON IdPPedido = IdPedido GROUP BY IdCliente_Fisico;
            
SELECT IdCliente_Fisico,Fnome, count(*) as Número_de_Pedidos FROM Cliente_Fisico INNER JOIN Pedido ON IdCliente_Fisico = IdPedidoCliente_Fisico
			INNER JOIN ProdutoPedido ON IdPPedido = IdPedido GROUP BY IdCliente_Fisico HAVING Número_de_Pedidos > 1;
            
SELECT * FROM Cliente_Fisico as Cliente INNER JOIN Pagamento ON IdCliente_Fisico = IdPagamentoCliente_Fisico;

SELECT concat(Fnome,' ',Mnome,' ',Lnome) as Cliente, CPF, Endereço, Tipo_de_Pagamento FROM Cliente_Fisico as Cliente INNER JOIN Pagamento ON IdCliente_Fisico = IdPagamentoCliente_Fisico ORDER BY Cliente;