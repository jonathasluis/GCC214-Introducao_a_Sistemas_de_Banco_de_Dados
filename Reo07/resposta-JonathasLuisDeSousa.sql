#1
INSERT INTO biblioteca.editora (cnpjEditora,nomeEditora,cidade,email,site) VALUES ('12345678912345','editora livre','lavras','livre@gmail.com','www.ediLivre.com');
INSERT INTO biblioteca.livro (isbnLivro,titulo,edicao,anoPublicacao,IdEditora) VALUES ('1234567891234','a volta dos que não foram',2,2015,1);
INSERT INTO biblioteca.usuario (nomeUsuario,endereco,telefone) VALUES ('joao da silva','centro - lavras','35974563215');
INSERT INTO biblioteca.exemplar (localizacao,tipoEmprestimo,idLivro) VALUES ('setor 5','n',1);
INSERT INTO biblioteca.autor (idLivro,nomeAutor) VALUES (1,'Eddie Brock');
INSERT INTO biblioteca.emprestimo (idExemplar,idUsuario,dataEmprestimo,dataLimiteDevolucao,dataRealDevolucao) VALUES (1,1,'2021-10-18','2021-10-25','2021-10-22');

#2
SELECT nomeEditora, email FROM editora WHERE cnpjEditora = "12345678901234";

#3
SELECT titulo, isbnLivro FROM livro WHERE anoPublicacao BETWEEN 2017 AND 2020
UNION
SELECT titulo, isbnLivro FROM livro WHERE edicao = 3;

#4
SELECT titulo, isbnLivro
FROM livro NATURAL JOIN editora
WHERE nomeEditora = 'Springer';

#5
SELECT l.titulo
FROM autor NATURAL JOIN livro as l
WHERE nomeAutor LIKE 'Maria %Ferreira%';

#6
SELECT l.titulo, nomeAutor
FROM autor NATURAL JOIN livro AS l
NATURAL JOIN editora AS e
WHERE e.cidade = 'lavras'
ORDER BY titulo,nomeAutor;

#7
SELECT l.titulo,e.dataEmprestimo
FROM emprestimo as e natural join usuario
natural join exemplar
natural join livro as l
WHERE nomeUsuario = 'Maria Maria Anônima';

#8
SELECT u.nomeUsuario,u.telefone
FROM emprestimo natural join usuario as u
WHERE dataLimiteDevolucao < now() 
AND dataRealDevolucao is null;

#9
SELECT u.nomeUsuario,u.endereco
FROM emprestimo natural join usuario as u
natural join exemplar natural join livro
natural join editora as e
WHERE e.nomeEditora = 'Pearson';

#10
SELECT nomeUsuario FROM usuario
WHERE idUsuario not in
	(select idUsuario from emprestimo);

#11
SELECT titulo,isbnLivro
from livro natural join editora
where nomeEditora = 'Campus'
union
SELECT titulo,isbnLivro
from emprestimo natural join exemplar
natural join livro
natural join usuario
where nomeUsuario = 'Pedro Paulo Campus';

#12
SELECT titulo,localizacao
FROM exemplar right join livro
ON exemplar.idLivro = livro.idLivro;

#13
SELECT isbnLivro,titulo, count(*) as 'quantidade_exemplar'
FROM exemplar natural join livro
GROUP BY isbnLivro, titulo;

#14
SELECT isbnLivro,titulo, count(*) as 'quantidade_exemplar'
FROM exemplar natural join livro
GROUP BY isbnLivro,titulo
having count(*) > 5;

#15
SELECT count(*) as quantidade
FROM emprestimo natural join usuario
natural join exemplar natural join livro
where nomeUsuario = 'Joana Ana Santana' AND titulo= 'Introdução ao Oracle';

#16
select titulo, isbnLivro
FROM emprestimo
natural join exemplar
natural join livro
group by isbnLivro, titulo
order by count(*) DESC
limit  1;

#17
select idUsuario, nomeUsuario, count(*) as quantidade
from emprestimo
natural join usuario
group by idUsuario, nomeUsuario
having count(*) > 5;

#18
create view questa18 as
	select idLivro, titulo, count(idlivro) as qtd, idEditora
	from exemplar natural join livro
	group by idLivro, titulo;

select nomeEditora from questa18
natural join editora
group by idEditora, nomeEditora
having sum(qtd) > 5;

#19
UPDATE usuario SET telefone = '35912344568' where nomeUsuario = 'Felizardo Feliz Felizberto';

#20
delete from autor where nomeAutor = '‘BookMundo B. Livraldo'
and idLivro in(select idLivro from livro where isbnLivro = '1234567890123');

#21
DELIMITER //
create procedure ConcedeEmprestimo(in idE int, in idUser int, in diasDev int)
begin
	insert into emprestimo (idExemplar,idUsuario,dataEmprestimo,DataLimiteDevolucao)
    values (idE,idUser,CURDATE(),CURDATE() + INTERVAL diasDev DAY);
end //
DELIMITER ;

call ConcedeEmprestimo(1,1,7)

#22
DELIMITER //
create procedure DevolveEmprestimo(in idEm int, out atraso int, out cod int)
begin
	if idEm not in (select idEmprestimo from emprestimo) then
		set cod = 1;
	else
        if (select dataRealDevolucao from emprestimo where idEMprestimo = idEm) is null then
			set cod = 0;
            UPDATE emprestimo SET dataRealDevolucao = CURDATE() where idEmprestimo = idEM;
            if CURDATE() > (select DataLimiteDevolucao from emprestimo where idEMprestimo = idEm) then
				set atraso = DATEDIFF(CURDATE(),(select DataLimiteDevolucao from emprestimo where idEMprestimo = idEm));
			else
				set atraso = 0;
			end if;
		else
			set cod = 2;
        end if;
    end if;
end //
DELIMITER ;

call DevolveEmprestimo(15,@atraso,@cod);
select @atraso,@cod;

#23
DELIMITER //
CREATE TRIGGER before_add_emprestimo
BEFORE INSERT ON emprestimo
FOR EACH ROW
BEGIN
	IF NEW.dataLimiteDevolucao < NEW.dataEmprestimo OR NEW.dataRealDevolucao is not null THEN
		SIGNAL SQLSTATE '45000' SET message_text = 'A data limite de devolução não pode ser menor que a data do emprestimo
			e a data real de devolução deve ser NULL!';  
	end if;
END //
DELIMITER ;

#inconsistente
insert into emprestimo (idexemplar,idusuario,dataemprestimo,datalimitedevolucao) values (5,1,'2020-05-01','2020-04-01');
insert into emprestimo (idexemplar,idusuario,dataemprestimo,datalimitedevolucao,dataRealDevolucao) values (5,1,'2020-05-01','2020-06-01','2020-06-02');

#consistente
insert into emprestimo (idexemplar,idusuario,dataemprestimo,datalimitedevolucao) values (4,1,'2020-05-01','2020-06-01'); 

DELIMITER //
CREATE TRIGGER before_upd_emprestimo
BEFORE update ON emprestimo
FOR EACH ROW
BEGIN
	IF NEW.dataLimiteDevolucao < NEW.dataEmprestimo OR (NEW.dataRealDevolucao is not null  AND NEW.dataRealDevolucao < NEW.dataEmprestimo) THEN
		SIGNAL SQLSTATE '45000' SET message_text = 'A data limite e real de devolução não pode ser menor que a data do emprestimo';
	end if;
END //
DELIMITER ;

#inconsistente
update emprestimo set dataemprestimo = '2021-12-30', datalimitedevolucao = '2021-10-28' where idemprestimo = 1;
#consistente
update emprestimo set dataemprestimo = '2021-09-30', datalimitedevolucao = '2021-10-28' where idemprestimo = 1;

#24
DELIMITER //
create TRIGGER before_del_user
BEFORE delete ON usuario
FOR EACH ROW
BEGIN
	IF old.idUsuario in(select idUsuario from emprestimo where dataRealDevolucao is null) then
		SIGNAL SQLSTATE '45000' SET message_text = 'Não é possivel excluir um usuario com empreestimos pendentes!';
	end if;
END //
DELIMITER ;

delete from usuario where idusuario = 2;

#25
CREATE USER 'jonathas'@'localhost' IDENTIFIED BY '1234';
GRANT SELECT ON biblioteca.* TO 'jonathas'@'localhost';
GRANT EXECUTE ON PROCEDURE biblioteca.ConcedeEmprestimo TO 'jonathas'@'localhost';
GRANT UPDATE (idExemplar,localizacao,idLivro) ON biblioteca.exemplar TO 'jonathas'@'localhost';

REVOKE SELECT ON biblioteca.* FROM 'jonathas'@'localhost';
REVOKE EXECUTE ON PROCEDURE biblioteca.ConcedeEmprestimo FROM 'jonathas'@'localhost';
REVOKE UPDATE (idExemplar,localizacao,idLivro) ON biblioteca.exemplar FROM 'jonathas'@'localhost';

#teste no novo usuario
select * from biblioteca.autor;
select * from biblioteca.editora;
select * from biblioteca.emprestimo;
select * from biblioteca.exemplar;
select * from biblioteca.livro;
select * from biblioteca.usuario;

call biblioteca.ConcedeEmprestimo(2,2,2);

UPDATE `biblioteca`.`exemplar` SET `localizacao` = 'corredor 1', `idLivro` = '2' WHERE (`idExemplar` = '2');

