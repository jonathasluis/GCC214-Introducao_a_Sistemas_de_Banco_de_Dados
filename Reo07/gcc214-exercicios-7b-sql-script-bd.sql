-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema Biblioteca
-- -----------------------------------------------------
CREATE SCHEMA Biblioteca;

USE Biblioteca;

-- -----------------------------------------------------
-- Table `Editora`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Editora` (
  `idEditora` INT NOT NULL AUTO_INCREMENT,
  `cnpjEditora` CHAR(14) NOT NULL,
  `nomeEditora` VARCHAR(50) NOT NULL,
  `cidade` VARCHAR(30) NOT NULL,
  `email` VARCHAR(40) NOT NULL,
  `site` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`idEditora`),
  UNIQUE INDEX `cnpjEditora_UNIQUE` (`cnpjEditora` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Livro`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Livro` (
  `idLivro` INT NOT NULL AUTO_INCREMENT,
  `isbnLivro` CHAR(13) NOT NULL,
  `titulo` VARCHAR(100) NOT NULL,
  `edicao` DECIMAL(2) NOT NULL,
  `anoPublicacao` DECIMAL(4) NOT NULL,
  `idEditora` INT NOT NULL,
  PRIMARY KEY (`idLivro`),
  UNIQUE INDEX `isbnLivro_UNIQUE` (`isbnLivro` ASC),
  INDEX `fk_Livro_Editora1_idx` (`idEditora` ASC),
  CONSTRAINT `fk_Livro_Editora1`
    FOREIGN KEY (`idEditora`)
    REFERENCES `Editora` (`idEditora`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Exemplar`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Exemplar` (
  `idExemplar` INT NOT NULL AUTO_INCREMENT,
  `localizacao` VARCHAR(20) NOT NULL,
  `tipoEmprestimo` CHAR(1) NOT NULL,
  `idLivro` INT NOT NULL,
  PRIMARY KEY (`idExemplar`),
  INDEX `fk_Exemplar_Livro1_idx` (`idLivro` ASC),
  CONSTRAINT `fk_Exemplar_Livro1`
    FOREIGN KEY (`idLivro`)
    REFERENCES `Livro` (`idLivro`)
    ON DELETE RESTRICT
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Usuario` (
  `idUsuario` INT NOT NULL AUTO_INCREMENT,
  `nomeUsuario` VARCHAR(50) NOT NULL,
  `endereco` VARCHAR(100) NOT NULL,
  `telefone` CHAR(11) NOT NULL,
  PRIMARY KEY (`idUsuario`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Emprestimo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Emprestimo` (
  `idEmprestimo` INT NOT NULL AUTO_INCREMENT,
  `idExemplar` INT NOT NULL,
  `idUsuario` INT NOT NULL,
  `dataEmprestimo` DATE NOT NULL,
  `dataLimiteDevolucao` DATE NOT NULL,
  `dataRealDevolucao` DATE NULL,
  PRIMARY KEY (`idEmprestimo`),
  INDEX `fk_Emprestimo_Exemplar1_idx` (`idExemplar` ASC),
  INDEX `fk_Emprestimo_Usuario1_idx` (`idUsuario` ASC),
  CONSTRAINT `fk_Emprestimo_Exemplar1`
    FOREIGN KEY (`idExemplar`)
    REFERENCES `Exemplar` (`idExemplar`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Emprestimo_Usuario1`
    FOREIGN KEY (`idUsuario`)
    REFERENCES `Usuario` (`idUsuario`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Autor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Autor` (
  `idLivro` INT NOT NULL,
  `nomeAutor` VARCHAR(30) NOT NULL,
  PRIMARY KEY (`idLivro`, `nomeAutor`),
  INDEX `fk_Autor_Livro_idx` (`idLivro` ASC),
  CONSTRAINT `fk_Autor_Livro`
    FOREIGN KEY (`idLivro`)
    REFERENCES `Livro` (`idLivro`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
