DROP DATABASE IF EXISTS gestion_eventos;
CREATE DATABASE gestion_eventos;
USE gestion_eventos;

CREATE TABLE ESPACIO (
    codigo_espacio VARCHAR(20)  NOT NULL,
    nombre         VARCHAR(100) NOT NULL,
    ubicacion      VARCHAR(150) NOT NULL,
    aforo_max      INTEGER      NOT NULL,
    PRIMARY KEY (codigo_espacio),
    CONSTRAINT ck_espacio_aforo CHECK (aforo_max > 0)
);

CREATE TABLE EVENTO (
    codigo_evento  VARCHAR(20)  NOT NULL,
    nombre         VARCHAR(100) NOT NULL,
    tipo           VARCHAR(50)  NOT NULL,
    fecha          DATE         NOT NULL,
    hora_inicio    TIME         NOT NULL,
    hora_fin       TIME         NOT NULL,
    codigo_espacio VARCHAR(20)  NOT NULL,
    PRIMARY KEY (codigo_evento),
    FOREIGN KEY (codigo_espacio) REFERENCES ESPACIO(codigo_espacio)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT ck_evento_horas CHECK (hora_fin > hora_inicio)
);

CREATE TABLE USUARIO (
    id_usuario     VARCHAR(20)  NOT NULL,
    correo         VARCHAR(100) UNIQUE NOT NULL,
    nombre         VARCHAR(100) NOT NULL,
    telefono       VARCHAR(20),
    fecha_registro DATE         NOT NULL,
    PRIMARY KEY (id_usuario)
);


CREATE TABLE USUARIO_ESTANDAR (
    id_usuario VARCHAR(20) NOT NULL,
    edad       INTEGER     NOT NULL,
    PRIMARY KEY (id_usuario),
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT ck_estandar_edad CHECK (edad >= 0)
);

CREATE TABLE USUARIO_VIP (
    id_usuario VARCHAR(20)  NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    PRIMARY KEY (id_usuario),
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE SERVICIO (
    codigo_servicio INTEGER AUTO_INCREMENT,
    tipo            VARCHAR(50) NOT NULL,
    descripcion     VARCHAR(200),
    PRIMARY KEY (codigo_servicio)
);

CREATE TABLE ENTRADA (
    codigo_entrada VARCHAR(20)   NOT NULL,
    tipo           VARCHAR(50)   NOT NULL,
    precio         DECIMAL(10,2) NOT NULL,
    codigo_evento  VARCHAR(20)   NOT NULL,
    PRIMARY KEY (codigo_entrada),
    FOREIGN KEY (codigo_evento) REFERENCES EVENTO(codigo_evento)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT ck_entrada_precio CHECK (precio >= 0)
);


CREATE TABLE ENTRADA_SERVICIO (
    codigo_entrada  VARCHAR(20) NOT NULL,
    codigo_servicio INTEGER     NOT NULL,
    cantidad        INTEGER     NOT NULL,
    PRIMARY KEY (codigo_entrada, codigo_servicio),
    FOREIGN KEY (codigo_entrada) REFERENCES ENTRADA(codigo_entrada)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (codigo_servicio) REFERENCES SERVICIO(codigo_servicio)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT ck_es_cantidad CHECK (cantidad > 0)
);


CREATE TABLE COMPRA (
    codigo_entrada VARCHAR(20)   NOT NULL,
    id_usuario     VARCHAR(20)   NOT NULL,
    fecha_compra   DATETIME      NOT NULL,
    monto_pagado   DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (codigo_entrada, id_usuario),
    FOREIGN KEY (codigo_entrada) REFERENCES ENTRADA(codigo_entrada)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT ck_compra_monto CHECK (monto_pagado >= 0)
);


CREATE TABLE EVALUACION (
    id_evaluacion INTEGER AUTO_INCREMENT,
    id_usuario    VARCHAR(20) NOT NULL,
    codigo_evento VARCHAR(20) NOT NULL,
    calificacion  INTEGER     NOT NULL,
    comentario    TEXT,
    PRIMARY KEY (id_evaluacion),
    FOREIGN KEY (id_usuario) REFERENCES USUARIO(id_usuario)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (codigo_evento) REFERENCES EVENTO(codigo_evento)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT uq_evaluacion UNIQUE (id_usuario, codigo_evento),
    CONSTRAINT ck_eval_calificacion CHECK (calificacion BETWEEN 1 AND 5)
);