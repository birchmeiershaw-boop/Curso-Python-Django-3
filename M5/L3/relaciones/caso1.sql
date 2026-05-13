CREATE TABLE clientes_v1 (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE deudas_v1 (
    id SERIAL PRIMARY KEY,
    cliente_id INT,
    monto NUMERIC(10,2) NOT NULL
);

INSERT INTO clientes_v1 (nombre) VALUES
('Juan'),
('María'),
('Pedro'),
('Camila'),
('Diego');

INSERT INTO deudas_v1 (cliente_id, monto) VALUES
(1, 50000),
(2, 75000),
(3, 30000),
(99, 120000), -- ID huérfano, no existe cliente
(NULL, 45000); -- Sin cliente relacionado