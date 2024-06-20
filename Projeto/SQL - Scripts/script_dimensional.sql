
CREATE TABLE public.dim_data (
                sk_data INTEGER NOT NULL,
                nk_data DATE NOT NULL,
                desc_data_completa VARCHAR(60) NOT NULL,
                nr_ano INTEGER NOT NULL,
                nm_trimestre VARCHAR(20) NOT NULL,
                nr_ano_trimestre VARCHAR(20) NOT NULL,
                nr_mes INTEGER NOT NULL,
                nm_mes VARCHAR(20) NOT NULL,
                ano_mes VARCHAR(20) NOT NULL,
                nr_semana INTEGER NOT NULL,
                ano_semana VARCHAR(20) NOT NULL,
                nr_dia INTEGER NOT NULL,
                nr_dia_ano INTEGER NOT NULL,
                nm_dia_semana VARCHAR(20) NOT NULL,
                flag_final_semana CHAR(3) NOT NULL,
                flag_feriado CHAR(3) NOT NULL,
                nm_feriado VARCHAR(60) NOT NULL,
                etl_dt_inicio TIMESTAMP NOT NULL,
                etl_dt_fim TIMESTAMP NOT NULL,
                versao INTEGER NOT NULL,
                CONSTRAINT sk_data_pk PRIMARY KEY (sk_data)
);


CREATE SEQUENCE public.dim_consultorio_sk_consultorio_seq;

CREATE TABLE public.dim_consultorio (
                sk_consultorio INTEGER NOT NULL DEFAULT nextval('public.dim_consultorio_sk_consultorio_seq'),
                nk_consultorio INTEGER NOT NULL,
                nm_consultorio VARCHAR(50) NOT NULL,
                cnpj CHAR(18) NOT NULL,
                cidade VARCHAR NOT NULL,
                etl_data_inicio DATE NOT NULL,
                etl_data_fim DATE NOT NULL,
                etl_versao INTEGER NOT NULL,
                CONSTRAINT sk_consultorio PRIMARY KEY (sk_consultorio)
);


ALTER SEQUENCE public.dim_consultorio_sk_consultorio_seq OWNED BY public.dim_consultorio.sk_consultorio;

CREATE SEQUENCE public.dim_consulta_sk_consulta_seq;

CREATE TABLE public.dim_consulta (
                sk_consulta INTEGER NOT NULL DEFAULT nextval('public.dim_consulta_sk_consulta_seq'),
                nk_consulta INTEGER NOT NULL,
                nm_consulta VARCHAR(50) NOT NULL,
                valor NUMERIC(10,2) NOT NULL,
                etl_data_inicio DATE NOT NULL,
                etl_data_fim DATE NOT NULL,
                etl_versao INTEGER NOT NULL,
                CONSTRAINT sk_consulta PRIMARY KEY (sk_consulta)
);


ALTER SEQUENCE public.dim_consulta_sk_consulta_seq OWNED BY public.dim_consulta.sk_consulta;

CREATE SEQUENCE public.dim_profissional_sk_profissional_seq;

CREATE TABLE public.dim_profissional (
                sk_profissional INTEGER NOT NULL DEFAULT nextval('public.dim_profissional_sk_profissional_seq'),
                nk_profissional INTEGER NOT NULL,
                nm_profissional VARCHAR(50) NOT NULL,
                cpf CHAR(14) NOT NULL,
                etl_data_inicio DATE NOT NULL,
                etl_data_fim DATE NOT NULL,
                etl_versao INTEGER NOT NULL,
                CONSTRAINT sk_profissional PRIMARY KEY (sk_profissional)
);


ALTER SEQUENCE public.dim_profissional_sk_profissional_seq OWNED BY public.dim_profissional.sk_profissional;

CREATE SEQUENCE public.dim_paciente_sk_paciente_seq;

CREATE TABLE public.dim_paciente (
                sk_paciente INTEGER NOT NULL DEFAULT nextval('public.dim_paciente_sk_paciente_seq'),
                nk_paciente INTEGER NOT NULL,
                nm_paciente VARCHAR(50) NOT NULL,
                data_nascimento DATE NOT NULL,
                cpf CHAR(14) NOT NULL,
                etl_data_fim DATE NOT NULL,
                etl_versao INTEGER NOT NULL,
                etl_data_inicio DATE NOT NULL,
                CONSTRAINT sk_paciente PRIMARY KEY (sk_paciente)
);


ALTER SEQUENCE public.dim_paciente_sk_paciente_seq OWNED BY public.dim_paciente.sk_paciente;

CREATE TABLE public.ft_atendimento (
                sk_paciente INTEGER NOT NULL,
                sk_consulta INTEGER NOT NULL,
                sk_profissional INTEGER NOT NULL,
                sk_consultorio INTEGER NOT NULL,
                sk_data INTEGER NOT NULL
);


ALTER TABLE public.ft_atendimento ADD CONSTRAINT dim_data_ft_atendimento_fk
FOREIGN KEY (sk_data)
REFERENCES public.dim_data (sk_data)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ft_atendimento ADD CONSTRAINT dim_consultorio_ft_atendimento_fk
FOREIGN KEY (sk_consultorio)
REFERENCES public.dim_consultorio (sk_consultorio)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ft_atendimento ADD CONSTRAINT dim_consulta_ft_atendimento_fk
FOREIGN KEY (sk_consulta)
REFERENCES public.dim_consulta (sk_consulta)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ft_atendimento ADD CONSTRAINT dim_profissional_ft_atendimento_fk
FOREIGN KEY (sk_profissional)
REFERENCES public.dim_profissional (sk_profissional)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE public.ft_atendimento ADD CONSTRAINT dim_paciente_ft_atendimento_fk
FOREIGN KEY (sk_paciente)
REFERENCES public.dim_paciente (sk_paciente)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;


---Etapa de DNQs do dw_clinica
--- Essa etapa é para garantir que o fluxo do pentaho funcione de primeira,
--- as questões de valores nulos das chaves, isso acabou dando algumas dores de cabeças.


---dim_consultorio
INSERT INTO dim_consultorio (sk_consultorio, nk_consultorio, nm_consultorio, cnpj, cidade,
etl_data_inicio, etl_data_fim, etl_versao) VALUES
(0, 0, 'N/A', '00000000000000', 'N/A', '1900-01-01', '2199-12-31', 0);


---dim_paciente
INSERT INTO dim_paciente (sk_paciente, nk_paciente, nm_paciente, data_nascimento, cpf,
etl_data_fim, etl_versao, etl_data_inicio) VALUES
(0, 0, 'N/A', '1900-01-01', '00000000000000', '2199-12-31', 0, '1900-01-01');

---dim_profissional
INSERT INTO dim_profissional (sk_profissional, nk_profissional, nm_profissional, cpf, etl_data_inicio, etl_data_fim, etl_versao) VALUES
(0, 0, 'N/A', '00000000000000', '1900-01-01', '2199-12-31', 0);


---dim_consulta
INSERT INTO dim_consulta (sk_consulta, nk_consulta, nm_consulta, valor, etl_data_inicio, etl_data_fim, etl_versao) VALUES
(0, 0, 'N/A', 0.0, '1900-01-01', '2199-12-31', 0);



--- Inserindo os valores de dim_data

insert into dim_data
select to_number(to_char(datum,'yyyymmdd'), '99999999') as sk_tempo,
datum as nk_data,
to_char(datum,'dd/mm/yyyy') as data_completa_formatada,
extract (year from datum) as nr_ano,
'T' || to_char(datum, 'q') as nm_trimestre,
to_char(datum, '"T"q/yyyy') as nr_ano_trimenstre,
extract(month from datum) as nr_mes,
to_char(datum, 'tmMonth') as nm_mes,
to_char(datum, 'yyyy/mm') as nr_ano_nr_mes,
extract(week from datum) as nr_semana,
to_char(datum, 'iyyy/iw') as nr_ano_nr_semana,
extract(day from datum) as nr_dia,
extract(doy from datum) as nr_dia_ano,
to_char(datum, 'tmDay') as nm_dia_semana,
case when extract(isodow from datum) in (6, 7) then 'Sim' else 'Não'
end as flag_final_semana,
case when to_char(datum, 'mmdd') in ('0101','0421','0501','0907','1012','1102','1115','1120','1225') then 'Sim' else 'Não'
end as flag_feriado,
case 
---incluir aqui os feriados
when to_char(datum, 'mmdd') = '0101' then 'Ano Novo' 
when to_char(datum, 'mmdd') = '0421' then 'Tiradentes'
when to_char(datum, 'mmdd') = '0501' then 'Dia do Trabalhador'
when to_char(datum, 'mmdd') = '0907' then 'Dia da Pátria' 
when to_char(datum, 'mmdd') = '1012' then 'Nossa Senhora Aparecida' 
when to_char(datum, 'mmdd') = '1102' then 'Finados' 
when to_char(datum, 'mmdd') = '1115' then 'Proclamação da República'
when to_char(datum, 'mmdd') = '1120' then 'Dia da Consciência Negra'
when to_char(datum, 'mmdd') = '1225' then 'Natal' 
else 'Não é Feriado'
end as nm_feriado,
current_timestamp as data_carga,
'2199-12-31',
'1'
from (
---incluir aqui a data de início do script, criaremos 15 anos de datas
select '2020-01-01'::date + sequence.day as datum
from generate_series(0,5479) as sequence(day)
group by sequence.day
) dq
order by 1;

