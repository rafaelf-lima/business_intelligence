create table pessoa_tratado (
	idpessoa INT,
	nomecompleto VARCHAR(255),
	genero VARCHAR(9),
	cidade VARCHAR(19),
	região VARCHAR(8),
	estado VARCHAR(14),
	altura NUMERIC(5,2),
	peso NUMERIC(5,2),
	classificacao_altura VARCHAR(5),
	tamanhocamisa VARCHAR(2),
	rem_em_dolar NUMERIC(5,2),
	rem_em_real NUMERIC(5,2)
);


select * from pessoa_tratado;