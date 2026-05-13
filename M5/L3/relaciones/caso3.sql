CREATE TABLE clientes_v3 (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE deudas_v3 (
    id SERIAL PRIMARY KEY,
    cliente_id INT NOT NULL,
    monto NUMERIC(10,2) NOT NULL,

    CONSTRAINT fk_cliente_deuda_v3
    FOREIGN KEY (cliente_id)
    REFERENCES clientes_v3(id)
    ON DELETE CASCADE
);

INSERT INTO clientes_v3 (nombre) VALUES
('Juan'),
('María'),
('Pedro'),
('Camila'),
('Diego');

INSERT INTO deudas_v3 (cliente_id, monto) VALUES
(1, 50000),
(2, 75000),
(3, 30000),
(4, 120000),
(5, 45000);