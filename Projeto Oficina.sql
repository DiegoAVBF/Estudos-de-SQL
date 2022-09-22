CREATE DATABASE Oficina;
USE Oficina;
-- DROP DATABASE Oficina;

CREATE TABLE Cliente(
	IdCliente INT AUTO_INCREMENT PRIMARY KEY,
    Fnome VARCHAR(10),
    Mnome VARCHAR(10),
    Lnome VARCHAR(15),
    CPF CHAR(11) NOT NULL,
    Contato VARCHAR(11) NOT NULL,
    Endereço VARCHAR(255),
    CONSTRAINT unique_cpf_cliente_fisico UNIQUE(CPF)
    );
    
    CREATE TABLE Mecânico(
	IdMecanico INT AUTO_INCREMENT PRIMARY KEY,
    Fnome VARCHAR(10),
    Mnome VARCHAR(10),
    Lnome VARCHAR(15),
    CPF CHAR(11) NOT NULL,
    Endereço VARCHAR(255),
    RG CHAR(9) NOT NULL,
    Especialidade VARCHAR(45),
    CONSTRAINT unique_cpf_cliente_fisico UNIQUE(CPF),
    CONSTRAINT unique_rg_cliente_fisico UNIQUE(RG)
);

CREATE TABLE Peça(
	IdPeça INT AUTO_INCREMENT PRIMARY KEY,
    PNome VARCHAR(45) NOT NULL,
    Descrição VARCHAR(255),
    Preço FLOAT NOT NULL,
    Quantidade INT DEFAULT 0
);

CREATE TABLE Pedido(
	IdPedido INT AUTO_INCREMENT PRIMARY KEY,
    IdPedidoCliente INT,
    IdPedidoPagamento INT,
    PedidoDescrição VARCHAR(255),
    PedidoData_de_Solicitação DATE NOT NULL,
    PedidoLiberado BOOLEAN DEFAULT FALSE,
    PedidoRevisão_ou_Concerto BOOLEAN NOT NULL,
    CONSTRAINT fk_pedido_cliente FOREIGN KEY(IdPedidoCliente) REFERENCES Cliente(IdCliente),
    CONSTRAINT fk_pedido_pagamento FOREIGN KEY(IdPedidoPagamento) REFERENCES Pagamento(IdPagamento)
);

CREATE TABLE Pagamento(
	IdPagamento INT AUTO_INCREMENT PRIMARY KEY,
    IdPagamentoCliente INT,
    Tipo_de_Pagamento ENUM('Boleto', 'Cartão', 'Cheque', 'Dois Cartões'),
    Limite_Disponivel FLOAT,
    CONSTRAINT fk_pagamento_cliente FOREIGN KEY(IdPagamentoCliente) REFERENCES Cliente(IdCliente)
);

CREATE TABLE Ordem_de_Serviço(
	IdOS INT PRIMARY KEY AUTO_INCREMENT,
    IdOSPedido INT,
    IdOSCliente INT,
    IdOSPagamento INT,
    Data_de_emissão DATE,
    Valor_do_serviço DATE,
    OSStatus ENUM('Cancelado', 'Confirmado', 'Em Processamento', 'Enviado') DEFAULT 'Em Processamento',
    Data_de_Conclusão DATE,
    PagamentoCash BOOL DEFAULT FALSE,
    CONSTRAINT fk_Ordem_Pedido FOREIGN KEY(IdOSPedido) REFERENCES Pedido(IdPedido),
    CONSTRAINT fk_Ordem_cliente FOREIGN KEY(IdOSCliente) REFERENCES Cliente(IdCliente),
    CONSTRAINT fk_Ordem_pagamento FOREIGN KEY(IdOSPagamento) REFERENCES Pagamento(IdPagamento)
);

CREATE TABLE PeçaOrdem(
	IdPPeça INT,
    IdPOS INT,
    IdPPedidos INT,
    Quantidade INT DEFAULT 1,
    PRIMARY KEY (IdPOS, IdPPedidos),
    CONSTRAINT fk_ordem_ppeça FOREIGN KEY(IdPPeça) REFERENCES Peça(IdPeça),
    CONSTRAINT fk_pordem FOREIGN KEY(IdPOS) REFERENCES Ordem_de_Serviço(IdOS),
    CONSTRAINT fk_ordem_ppedidos FOREIGN KEY(IdPPedidos) REFERENCES Pedido(IdPedido)
);

CREATE TABLE MecanicoPedido(
	IdMMecanico INT,
    IdMPedido INT,
    Mão_de_obra FLOAT NOT NULL DEFAULT 200.0,
    CONSTRAINT fk_mmecanico FOREIGN KEY(IdMMecanico) REFERENCES Mecânico(IdMecanico),
    CONSTRAINT fk_mecanico_mpedido FOREIGN KEY(IdMPedido) REFERENCES Pedido(IdPedido)
);

INSERT INTO Cliente (Fnome, Mnome, Lnome, CPF, Endereço, Contato)
	VALUES ('Maria','M','Silva',12345678901,'Rua Silva de Prato 29, Carangola - Cidade das Flores',21208894550),
		   ('Matheus','O','Pimentel',09876543219,'Rua Alemeda 289, Centro - Cidade das Flores', 22345567329),
           ('Ricardo','F','Silva',35257842480,'Avenida Alemeda Vinha 1009, Centro - Cidade das Flores', 12998455629),
           ('Josiane','V','Barbosa',33075605647,'Rua Pedro Alvares Cabral 940, Centro - Nilópolis', 21209008755),
           ('Zuila','A','Silva',77895314598,'Rua Pedro Alvares Cabral 938, Centro - Nilópolis', 21657990046),
           ('Isabele','M','Cruz',55438206517,'Rua Alemida das Flores 28, Centro - Cidade das Flores',21341009678);
           
INSERT INTO Peça (PNome, Preço, Quantidade) 
	VALUES ('Rosca', 5.0, 4),
		   ('Chave de Fenda',7.0,8),
           ('Rodas de Carro', 100.0,20),
           ('Portas de Carro', 200.0,10),
           ('Rodas de Moto', 75.0, 20),
           ('Motor de Carro',500.0,5),
           ('Motor de Moto',390.0,5);
           
INSERT INTO Mecânico (Fnome, Mnome, Lnome, CPF, Endereço, RG, Especialidade)
	VALUES ('Cleiton','M','Silva',12345673901,'Rua Silva de Prato 29, Carangola - Cidade das Flores',208794550, 'Troca de Rodas'),
		   ('Matheus','O','Augusto',09876547219,'Rua Alemeda 289, Centro - Cidade das Flores', 345517329, 'Soldagem'),
           ('Ricardo','Da','Cruz',35217842480,'Avenida Alemeda Vinha 1009, Centro - Cidade das Flores', 995455629, 'Revisão'),
           ('Diego','A','Vieira',33075805647,'Rua Pedro Alvares Cabral 940, Centro - Nilópolis', 209058755, 'Troca de Motores'),
           ('Vinicios','A','Silva',77895514598,'Rua Pedro Alvares Cabral 938, Centro - Nilópolis', 657790046, 'Manutenção nas portas'),
           ('Kleber','M','Cruz',55438296517,'Rua Alemida das Flores 28, Centro - Cidade das Flores',341609678, 'Pintura');
           
INSERT INTO Pagamento (IdPagamentoCliente, Tipo_de_Pagamento, Limite_Disponivel)
			VALUES ('1', 'Cartão', '1000.0'),
				   ('2', 'Cheque', NULL),
                   ('3', 'Boleto', NULL),
                   ('4', 'Cartão', '10000.0'),
                   ('5', 'Cartão', '5000.0'),
                   ('6', 'Cartão', '7500.0');
 
INSERT INTO Pedido (IdPedidoCliente, IdPedidoPagamento, PedidoDescrição, PedidoData_de_Solicitação, PedidoLiberado, PedidoRevisão_ou_Concerto)
	VALUES ('1', '1','Vistoria do Carro', '2022-07-15', 1, 0),
           ('2', '2','Concerto da Porta', '2022-05-20', 1, 1),
           ('3', '3','Vistoria do Carro', '2022-09-22', 0, 0),
           ('4', '4','Troca do Motor', '2022-09-21', 0, 1);
           
SELECT * FROM Pedido;

-- OSStatus ENUM('Cancelado', 'Confirmado', 'Em Processamento', 'Enviado') DEFAULT 'Em Processamento',
INSERT INTO Ordem_de_Serviço (IdOSPedido, IdOSCliente, IdOSPagamento, Data_de_emissão, Valor_do_serviço , OSStatus, Data_de_Conclusão, PagamentoCash)
	VALUES (1,1,1, '2022-07-15', 100.0, 'Confirmado', '2022-07-15', 0),
		   (2,2,2, '2022-05-20', 300.0, 'Confirmado', '2022-05-21', 1),
           (3,3,3, '2022-09-22', 100.0, DEFAULT, '2022-09-23', 1),
           (4,4,4, '2022-09-21', 700.0, DEFAULT, '2022-09-26', 0);
           
INSERT INTO MecanicoPedido (IdMMecanico, IdMPedido, Mão_de_obra)
	VALUES (3,1,100.0),
		   (5,2,100.0),
           (3,3,100.0),
           (4,4,DEFAULT);
           
INSERT INTO PeçaOrdem (IdPPeça, IdPOS, IdPPedidos, Quantidade)
	VALUES (NULL, 1, 1, NULL),
		   (4, 2, 2, DEFAULT),
           (NULL, 3, 3, NULL),
           (6, 4, 4, DEFAULT);
           
SELECT * FROM Pedido;
SELECT * FROM Peça;

SELECT COUNT(*) FROM Cliente;
SELECT * FROM Cliente c, Pedido p WHERE c.IdCliente = IdPedidoCliente;
SELECT Fnome,Mnome,Lnome,IdPedido,PedidoLiberado FROM Cliente c, Pedido p WHERE c.IdCliente = IdPedidoCliente;
SELECT concat(Fnome, ' ',Mnome,' ',Lnome) as Cliente,IdPedido as Pedido,PedidoLiberado as Liberado FROM Cliente c, Pedido p WHERE c.IdCliente = IdPedidoCliente;

SELECT * FROM Cliente c, Pedido p WHERE c.IdCliente = IdPedidoCliente GROUP BY IdPedido;
SELECT * FROM Cliente c, Pedido p WHERE c.IdCliente = IdPedidoCliente GROUP BY IdPedido HAVING PedidoLiberado = 1;
SELECT * FROM Cliente c, Pedido p WHERE c.IdCliente = IdPedidoCliente GROUP BY IdPedido HAVING PedidoLiberado = 0;

SELECT * FROM Cliente LEFT OUTER JOIN Pedido ON IdCliente = IdPedidoCliente;

SELECT IdCliente,Fnome, count(*) as Número_de_Pedidos FROM Cliente INNER JOIN Pedido ON IdCliente = IdPedidoCliente
			INNER JOIN PeçaOrdem ON IdPPedidos = IdPedido GROUP BY IdCliente;
            
SELECT IdCliente,Fnome, count(*) as Número_de_Pedidos FROM Cliente INNER JOIN Pedido ON IdCliente = IdPedidoCliente
			INNER JOIN PeçaOrdem ON IdPPedidos = IdPedido GROUP BY IdCliente HAVING Número_de_Pedidos = 1;
            
SELECT IdMecanico,Fnome, count(*) as Número_de_Pedidos FROM Mecânico INNER JOIN MecanicoPedido ON IdMMecanico = IdMecanico
			INNER JOIN Pedido ON IdPedido = IdMPedido GROUP BY IdMecanico;
            
SELECT IdMecanico,Fnome, count(*) as Número_de_Pedidos FROM Mecânico INNER JOIN MecanicoPedido ON IdMMecanico = IdMecanico
			INNER JOIN Pedido ON IdPedido = IdMPedido GROUP BY IdMecanico HAVING Número_de_Pedidos > 1;
            
SELECT * FROM Cliente as Cliente INNER JOIN Pagamento ON IdCliente = IdPagamentoCliente;
SELECT * FROM Cliente as Cliente INNER JOIN Pagamento ON IdCliente = IdPagamentoCliente ORDER BY Fnome;

SELECT concat(Fnome,' ',Mnome,' ',Lnome) as Cliente, CPF, Endereço, Tipo_de_Pagamento FROM Cliente as Cliente INNER JOIN Pagamento ON IdCliente = IdPagamentoCliente ORDER BY Cliente;
            





