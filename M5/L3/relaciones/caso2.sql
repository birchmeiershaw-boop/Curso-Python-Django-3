CREATE TABLE clientes_v2 (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE deudas_v2 (
    id SERIAL PRIMARY KEY,
    cliente_id INT NOT NULL,
    monto NUMERIC(10,2) NOT NULL,

    CONSTRAINT fk_cliente_deuda_v2
    FOREIGN KEY (cliente_id)
    REFERENCES clientes_v2(id)
);

INSERT INTO clientes_v2 (nombre) VALUES
('Juan'),
('María'),
('Pedro'),
('Camila'),
('Diego');

INSERT INTO deudas_v2 (cliente_id, monto) VALUES
(1, 50000),
(2, 75000),
(3, 30000),
(4, 120000),
(5, 45000);