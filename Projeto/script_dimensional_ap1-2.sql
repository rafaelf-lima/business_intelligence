
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
                cnpj CHAR(14) NOT NULL,
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
                cpf CHAR(11) NOT NULL,
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
                etl_data_fim DATE NOT NULL,
                etl_versao INTEGER NOT NULL,
                etl_data_inicio DATE NOT NULL,
                cpf CHAR(11) NOT NULL,
                CONSTRAINT sk_paciente PRIMARY KEY (sk_paciente)
);


ALTER SEQUENCE public.dim_paciente_sk_paciente_seq OWNED BY public.dim_paciente.sk_paciente;

CREATE TABLE public.ft_atendimento (
                sk_paciente INTEGER NOT NULL,
                sk_consulta INTEGER NOT NULL,
                sk_profissional INTEGER NOT NULL,
                sk_consultorio INTEGER NOT NULL,
                sk_data INTEGER NOT NULL,
                faturamento NUMERIC(10,2) NOT NULL,
                horario TIME NOT NULL
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
