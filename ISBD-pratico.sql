create schema compufit;
use compufit;
--
-- Estrutura da Tabela pessoa
--
CREATE TABLE pessoa (
  cpf char(11) NOT NULL,
  nome varchar(80) NOT NULL,
  dataNasc date NOT NULL,
  sexo char(1) NOT NULL,
  estado char(2) NOT NULL,
  cep char(8) NOT NULL,
  cidade varchar(30) NOT NULL,
  bairro varchar(30) DEFAULT NULL,
  numero int unsigned NOT NULL,
  logradouro varchar(40) NOT NULL,
  tipoPessoa char(1) NOT NULL default 'c',
  PRIMARY KEY (cpf)
);
--
-- Estrutura da Tabela cliente
--
CREATE TABLE cliente (
  cpfCliente char(11) NOT NULL,
  peso float NOT NULL,
  altura float NOT NULL,
  PRIMARY KEY (cpfCliente),
  CONSTRAINT fk_Cliente_Pessoa1 FOREIGN KEY (cpfCliente) REFERENCES pessoa (cpf)
  ON DELETE CASCADE
  ON UPDATE CASCADE
);
--
-- Estrutura da Tabela funcionario
--
CREATE TABLE funcionario (
  cpfFunc char(11) NOT NULL,
  periodoDeTrabalho char(1) NOT NULL,
  salario float NOT NULL,
  dataAdmissao date NOT NULL,
  tipoFunc char(1) NOT NULL,
  PRIMARY KEY (cpfFunc),
  CONSTRAINT fk_Funcionario_Pessoa1 FOREIGN KEY (cpfFunc) REFERENCES pessoa (cpf)
  ON DELETE CASCADE
  ON UPDATE CASCADE
);
--
-- Estrutura da Tabela instrutor
--
CREATE TABLE instrutor (
  cpfInstrutor char(11) NOT NULL,
  cref char(9) NOT NULL,
  especializacao varchar(30) NOT NULL,
  PRIMARY KEY (cpfInstrutor),
  UNIQUE KEY cref_UNIQUE (cref),
  CONSTRAINT Func_Inst FOREIGN KEY (cpfInstrutor) REFERENCES funcionario (cpfFunc)
  ON DELETE CASCADE
  ON UPDATE CASCADE
);
--
-- Estrutura da Tabela recepcionista
--
CREATE TABLE recepcionista (
  cpfRecepcionista char(11) NOT NULL,
  tempoDigitacao float NOT NULL,
  PRIMARY KEY (cpfRecepcionista),
  CONSTRAINT recep_Func FOREIGN KEY (cpfRecepcionista) REFERENCES funcionario (cpfFunc) 
  ON DELETE CASCADE 
  ON UPDATE CASCADE
);
--
-- Estrutura da Tabela fonepessoa
--
CREATE TABLE fonepessoa (
  cpf char(11) NOT NULL,
  telefone varchar(11) NOT NULL,
  PRIMARY KEY (cpf,telefone),
  CONSTRAINT fk_FonePessoa_Pessoa FOREIGN KEY (cpf) REFERENCES pessoa (cpf)
  ON DELETE CASCADE
  ON UPDATE CASCADE
);
--
-- Estrutura da Tabela instrui
--
CREATE TABLE instrui (
  cpfInstrutor char(11) NOT NULL,
  cpfCliente char(11) NOT NULL,
  PRIMARY KEY (cpfInstrutor,cpfCliente),
  KEY instrui_cliente_idx (cpfCliente),
  CONSTRAINT instrui_cliente FOREIGN KEY (cpfCliente) REFERENCES cliente (cpfCliente)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  CONSTRAINT instrui_instrutor FOREIGN KEY (cpfInstrutor) REFERENCES instrutor (cpfInstrutor) 
  ON DELETE CASCADE
  ON UPDATE CASCADE
);
--
-- Estrutura da Tabela modalidade
--
CREATE TABLE modalidade (
  idModalidade int NOT NULL AUTO_INCREMENT,
  nome varchar(20) NOT NULL,
  descricao varchar(50) DEFAULT NULL,
  PRIMARY KEY (idModalidade),
  UNIQUE KEY nome_UNIQUE (nome)
);
--
-- Estrutura da Tabela ensina
--
CREATE TABLE ensina (
  cpfInstrutor char(11) NOT NULL,
  idModalidade int NOT NULL,
  PRIMARY KEY (cpfInstrutor,idModalidade),
  KEY ensina_modalidade_idx (idModalidade),
  CONSTRAINT ensina_Instrutor FOREIGN KEY (cpfInstrutor) REFERENCES instrutor (cpfInstrutor)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
  CONSTRAINT ensina_modalidade FOREIGN KEY (idModalidade) REFERENCES modalidade (idModalidade)
  ON DELETE CASCADE
  ON UPDATE CASCADE
);
--
-- Estrutura da Tabela equipamento
--
CREATE TABLE equipamento (
  serial varchar(20) NOT NULL,
  nome varchar(20) NOT NULL,
  status varchar(10) NOT NULL,
  dataDeAquisicao date NOT NULL,
  PRIMARY KEY (serial)
);
--
-- Estrutura da Tabela plano
--
CREATE TABLE plano (
  idPlano int NOT NULL AUTO_INCREMENT,
  nome varchar(20) NOT NULL,
  periodo varchar(20) NOT NULL,
  preco float NOT NULL,
  descricao varchar(50) DEFAULT NULL,
  PRIMARY KEY (idPlano),
  UNIQUE KEY nome_UNIQUE (nome)
);
--
-- Estrutura da Tabela tem
--
CREATE TABLE tem (
  idPlano int NOT NULL,
  idModalidade int NOT NULL,
  PRIMARY KEY (idPlano,idModalidade),
  KEY tem_modalidade_idx (idModalidade),
  CONSTRAINT tem_modalidade FOREIGN KEY (idModalidade) REFERENCES modalidade (idModalidade)
  ON DELETE CASCADE 
  ON UPDATE CASCADE,
  CONSTRAINT tem_plano FOREIGN KEY (idPlano) REFERENCES plano (idPlano)
  ON DELETE CASCADE 
  ON UPDATE CASCADE
);
--
-- Estrutura da Tabela utiliza
--
CREATE TABLE utiliza (
  idModalidade int NOT NULL,
  serialEquipamento varchar(20) NOT NULL,
  PRIMARY KEY (idModalidade,serialEquipamento),
  KEY utiliza_equipamento_idx (serialEquipamento),
  CONSTRAINT utiliza_equipamento FOREIGN KEY (serialEquipamento) REFERENCES equipamento (`serial`)
  ON DELETE CASCADE 
  ON UPDATE CASCADE,
  CONSTRAINT utiliza_modalidade FOREIGN KEY (idModalidade) REFERENCES modalidade (idModalidade)
  ON DELETE CASCADE 
  ON UPDATE CASCADE
);
--
-- Estrutura da Tabela vende
--
CREATE TABLE vende (
  cpfCliente char(11) NOT NULL,
  IdPlano int NOT NULL,
  cpfRecep char(11) NOT NULL,
  dataInicio date NOT NULL,
  PRIMARY KEY (cpfCliente,IdPlano),
  KEY vende_plano_idx (IdPlano),
  KEY vende_rec_idx (cpfRecep),
  CONSTRAINT vende_cli FOREIGN KEY (cpfCliente) REFERENCES cliente (cpfCliente)
  ON DELETE CASCADE 
  ON UPDATE CASCADE,
  CONSTRAINT vende_plano FOREIGN KEY (IdPlano) REFERENCES plano (idPlano)
  ON DELETE CASCADE 
  ON UPDATE CASCADE
);

--
-- Estrutura da Tabela extra
--
CREATE TABLE extra (
	idExtra int not null auto_increment,
    descricao varchar(50) not null,
    primary key (idExtra)
);

--
-- Alteração do tipo da coluna telefone da tabela 'fonepessoa'
--
alter table fonepessoa CHANGE COLUMN telefone telefone CHAR(11) NOT NULL;

--
-- Alteração da tabela 'vende', criação CONSTRAINT com a tabela 'Recepsionista'
--
alter table vende add CONSTRAINT vende_rec
FOREIGN KEY (cpfRecep)
REFERENCES recepcionista (cpfRecepcionista)
ON DELETE CASCADE 
ON UPDATE CASCADE;

--
-- Alteração da tabela 'vende', adição da coluna 'dataFim' 
--
alter table vende add column dataFim date NOT NULL;

--
-- Exclusão da tabela extra
--
DROP table if exists extra;

--
-- Inserção de dados nas tabelas
--
insert into pessoa values ('15698712365','joao','1995-05-09','m','mg','37200000','ribeirao vermelho','centro',99,'r. ellias freire','c');
insert into pessoa values ('12378965482','enzo','1998-01-03','m','mg','37200000','lavras','stone',147,'r. topazio','c');
insert into pessoa values ('16741223982','maria','1996-10-15','f','mg','37200000','lavras','centro',188,'r. platina','f');
insert into pessoa values ('16438974625','ana','1999-07-15','f','mg','37200000','lavras','centro',63,'r. dona inacia','f');
insert into cliente values ('15698712365',85.3,1.83);
insert into cliente values ('12378965482',70,1.77);
insert into funcionario values ('16741223982','m',2350,'2019-06-07','r');
insert into funcionario values ('16438974625','n',2200,'2020-12-08','i');
insert into instrutor values ('16438974625','123456789','aerobica');
insert into recepcionista values ('16741223982',15.6);
insert into fonepessoa values ('16741223982','35988254981');
insert into fonepessoa values ('16741223982','35999453614');
insert into instrui values ('16438974625','15698712365');
insert into equipamento values ('7694268468','esteira','novo','2020-04-06');
insert into equipamento values ('7694268466','bike ergometrica2','novo','2020-04-06');
insert into modalidade values (1,'aerobica','atividades aerobicas');
insert into modalidade values (2,'box','luta box');
insert into ensina values ('16438974625',1);
insert into plano values (1,'basico','mensal',100,'plano basico mensal');
insert into plano values (2,'fidelidade','anual',1000,'plano anual');
insert into tem values (1,1);
insert into utiliza values (1,'7694268468');
insert into utiliza values (1,'7694268466');
insert into utiliza values (2,'7694268466');
insert into vende values ('15698712365',1,'16741223982','2021-11-08','2021-12-08');
insert into vende values ('12378965482',1,'16741223982','2021-11-10','2021-12-10');

--
-- Atualização de dados nas tabelas
--
update plano set preco = 110 where idPlano = 1;
update equipamento set nome = 'bike ergometrica' where `serial` = '7694268468';
update pessoa set nome = 'joao sousa' where cpf = '15698712365';
update funcionario set salario = 2300 where cpfFunc = '16438974625';
update vende set dataFim = '2021-12-08' where cpfCliente = '15698712365' and idPlano = 1;

--
-- Exclusão de dados nas tabelas
--
delete from pessoa where cpf = '12378965482';
delete from modalidade where idModalidade = 2;
delete from plano where idPlano = 2;
delete from equipamento where `serial` = '7694268466';
delete from fonepessoa where cpf = '16741223982'and telefone = '35999453614';

--
-- Recupera o cpf e o nome do cliente e do(a) recepcionista e os dados do plano em uma venda
--
select cpfCliente, p1.nome as 'nome_cliente', cpfRecep, p2.nome as 'nome_recepcionista',
	dataInicio, DataFim, plano.nome as 'nome_plano', periodo, preco from vende
natural join plano
natural join cliente
join pessoa as p1 on cpfCliente = p1.cpf
join recepcionista on cpfRecep = cpfRecepcionista
join pessoa as p2 on cpfRecepcionista = p2.cpf
order by dataInicio;

--
-- Retorna o id e o nome da modalidade que utiliza mais de 1 equipamento
--
select idModalidade, m.nome, count(serialEquipamento) as 'quantidade_equipamentos'
from utiliza
natural join modalidade as m
group by idModalidade, m.nome
having quantidade_equipamentos > 1;

--
-- Retorna todos os funcionarios e seus dados
--
select cpfFunc, nome, dataNasc, sexo, dataAdmissao, periodoDeTrabalho, salario,
	tipoFunc, cref, especializacao, tempoDigitacao,
	estado, cep, cidade, bairro, numero, logradouro
from funcionario
join pessoa on cpfFunc = cpf
left outer join instrutor on cpfFunc = cpfInstrutor
left outer join recepcionista on cpfFunc = cpfRecepcionista;

--
-- Retorna os funcionarios contratados entre 2020 e 2021
--
select cpfFunc, dataAdmissao, tipoFunc
from funcionario
where dataAdmissao between '2020-01-01' and '2021-12-31';

--
-- Retorna o cpf e o nome do instrutor que instrui algun cliente chamado joao
--
select cpfInstrutor, nome from instrutor
join pessoa on cpfInstrutor = cpf
where cpfInstrutor in
	(select DISTINCT instrui.cpfInstrutor from instrui
    join pessoa on cpfCliente = cpf
    where nome like 'joao%');

--
-- Retorna a relação entre instrutor e a modalidade que ele ensina
--
select cpfInstrutor, p.nome as 'nome_instrutor(a)', i.especializacao,
	m.nome as 'modalidade', m.descricao from ensina
natural join instrutor as i join pessoa as p 
on cpfInstrutor = cpf
join modalidade as m on ensina.idModalidade = m.idModalidade;

--
-- Retorna as pessoas que moram no centro de lavras e as pessoas que moram no centro de ribeirao vermelho
--
select * from pessoa
where cidade = 'lavras' and bairro = 'centro'
union
select * from pessoa
where cidade = 'ribeirao vermelho' and bairro = 'centro';

--
-- view que recupera o cpf, o nome do cliente e do(a) recepcionista e os dados do plano em uma venda
--
create view vende_estendido as
select cpfCliente, p1.nome as 'nome_cliente', cpfRecep, p2.nome as 'nome_recepcionista',
	dataInicio, DataFim, plano.nome as 'nome_plano', periodo, preco from vende
natural join plano
natural join cliente
join pessoa as p1 on cpfCliente = p1.cpf
join recepcionista on cpfRecep = cpfRecepcionista
join pessoa as p2 on cpfRecepcionista = p2.cpf
order by dataInicio;

select * from vende_estendido;

--
-- view que retorna todos os funcionarios e seus dados
--
create view funcionario_estendido as
select cpfFunc, nome, dataNasc, sexo, dataAdmissao, periodoDeTrabalho, salario,
	tipoFunc, cref, especializacao, tempoDigitacao,
	estado, cep, cidade, bairro, numero, logradouro
from funcionario
join pessoa on cpfFunc = cpf
left outer join instrutor on cpfFunc = cpfInstrutor
left outer join recepcionista on cpfFunc = cpfRecepcionista;

select * from funcionario_estendido;

--
-- view que retorna a relação entre instrutor e a modalidade que ele ensina
--
create view ensina_estendido as
select cpfInstrutor, p.nome as 'nome_instrutor(a)', i.especializacao,
	m.nome as 'modalidade', m.descricao from ensina
natural join instrutor as i join pessoa as p 
on cpfInstrutor = cpf
join modalidade as m on ensina.idModalidade = m.idModalidade;

select * from ensina_estendido;

--
-- Criação do usuario instrutor e suas permissões de acesso
--
create USER 'instrutor'@'localhost' IDENTIFIED BY '1234';
grant select, update(peso,altura) on compufit.cliente to 'instrutor'@'localhost';
grant all on compufit.ensina to 'instrutor'@'localhost';
grant select on compufit.equipamento to 'instrutor'@'localhost';
grant all on compufit.intrui to 'instrutor'@'localhost';
grant select on compufit.instrutor to 'instrutor'@'localhost';
grant all on compufit.modalidade to 'instrutor'@'localhost';
grant all on compufit.utiliza to 'instrutor'@'localhost';

revoke insert,update,delete  on compufit.ensina from 'instrutor'@'localhost';

--
-- Criação do usuario recepcionista e suas permissões de acesso
--
create USER 'recep'@'localhost' IDENTIFIED BY '1234';
grant all on compufit.cliente to 'recep'@'localhost';

grant all on compufit.ensina to 'recep'@'localhost';
grant select on compufit.equipamento to 'recep'@'localhost';
grant all on compufit.fonepessoa to 'recep'@'localhost';
grant all on compufit.intrui to 'recep'@'localhost';
grant select on compufit.recepcionista to 'recep'@'localhost';
grant select on compufit.instrutor to 'recep'@'localhost';
grant all on compufit.pessoa to 'recep'@'localhost';
grant all on compufit.plano to 'recep'@'localhost';
grant all on compufit.modalidade to 'recep'@'localhost';
grant all on compufit.utiliza to 'recep'@'localhost';
grant all on compufit.vende to 'recep'@'localhost';
grant all on compufit.tem to 'recep'@'localhost';

revoke insert,update,delete  on compufit.plano from 'recep'@'localhost';
revoke update,delete on compufit.vende from 'recep'@'localhost';

--
-- Trigger inserção 'vende', a data Inicial não pode ser maior que a data final
--
DELIMITER //
create trigger before_insert_vende
before insert on vende
for each row
begin
	if new.dataInicio > new.dataFim then
		SIGNAL SQLSTATE '45000' SET message_text = 'A data Inicial não pode ser maior que a data final';  
    end if;
end //
DELIMITER ;

insert into vende values ('13264976831',1,'16741223982','2021-11-10','2020-12-10');

--
-- Trigger exclusão 'cliente', não pode excluir um cliente com um plano ativo
--
DELIMITER //
create trigger before_delete_cliente
before delete on cliente
for each row
begin
	if old.cpfCliente in(select cpfCliente from vende where dataFim > curdate()) then
		SIGNAL SQLSTATE '45000' SET message_text = 'O plano do cliente não venceu!';  
    end if;
end //
DELIMITER ;

delete from cliente where cpfCliente = '12378965482';

--
-- Trigger alteração ...
--
