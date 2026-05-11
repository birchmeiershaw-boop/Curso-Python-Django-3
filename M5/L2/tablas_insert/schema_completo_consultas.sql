-- ============================================================
-- Archivo completo de tablas y datos de prueba
-- Compatible con PostgreSQL
-- Basado en consultas SELECT, WHERE, JOIN, subconsultas y GROUP BY
-- ============================================================

-- ============================================================
-- LIMPIEZA INICIAL
-- ============================================================
DROP TABLE IF EXISTS payments CASCADE;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS clients CASCADE;

-- ============================================================
-- TABLA: clients
-- ============================================================
CREATE TABLE clients (
    client_id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(150),
    phone VARCHAR(50),
    country VARCHAR(80) NOT NULL DEFAULT 'Chile',
    city VARCHAR(100),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- TABLA: products
-- ============================================================
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    sku VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    category VARCHAR(80) NOT NULL,
    price NUMERIC(12,2) NOT NULL CHECK (price >= 0),
    stock INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- ============================================================
-- TABLA: orders
-- ============================================================
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    client_id INTEGER NOT NULL,
    order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    notes TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_orders_clients
        FOREIGN KEY (client_id)
        REFERENCES clients (client_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,

    CONSTRAINT chk_orders_status
        CHECK (status IN ('PENDING', 'PAID', 'CANCELLED', 'REFUNDED'))
);

-- ============================================================
-- TABLA: order_items
-- ============================================================
CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price NUMERIC(12,2) NOT NULL CHECK (unit_price >= 0),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_order_items_orders
        FOREIGN KEY (order_id)
        REFERENCES orders (order_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT fk_order_items_products
        FOREIGN KEY (product_id)
        REFERENCES products (product_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- ============================================================
-- TABLA: payments
-- ============================================================
CREATE TABLE payments (
    payment_id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL,
    amount NUMERIC(12,2) NOT NULL CHECK (amount >= 0),
    method VARCHAR(40) NOT NULL,
    status VARCHAR(30) NOT NULL DEFAULT 'PENDING',
    paid_at TIMESTAMP,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_payments_orders
        FOREIGN KEY (order_id)
        REFERENCES orders (order_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,

    CONSTRAINT chk_payments_method
        CHECK (method IN ('CASH', 'CARD', 'TRANSFER', 'WEBPAY', 'PAYPAL')),

    CONSTRAINT chk_payments_status
        CHECK (status IN ('PENDING', 'PAID', 'FAILED', 'REFUNDED'))
);

-- ============================================================
-- ÍNDICES RECOMENDADOS
-- ============================================================
CREATE INDEX idx_clients_country ON clients(country);
CREATE INDEX idx_clients_name ON clients(name);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_products_is_active ON products(is_active);
CREATE INDEX idx_orders_client_id ON orders(client_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_order_date ON orders(order_date);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);
CREATE INDEX idx_payments_order_id ON payments(order_id);
CREATE INDEX idx_payments_paid_at ON payments(paid_at);
CREATE INDEX idx_payments_status ON payments(status);

-- ============================================================
-- DATOS DE PRUEBA: clients
-- ============================================================
INSERT INTO clients (name, email, phone, country, city, is_active, created_at) VALUES
('Nxtara SpA', 'contacto@nxtara.com', '+56 9 1111 1111', 'Chile', 'Santiago', TRUE, '2025-01-10 09:00:00'),
('Comercial Andes Ltda', 'ventas@andes.cl', '+56 9 2222 2222', 'Chile', 'Valparaíso', TRUE, '2025-01-15 10:30:00'),
('TechNova Solutions', 'hello@technova.com', '+54 11 3333 3333', 'Argentina', 'Buenos Aires', TRUE, '2025-02-01 11:00:00'),
('Innova Perú SAC', 'info@innovaperu.pe', '+51 1 4444 4444', 'Perú', 'Lima', TRUE, '2025-02-12 12:00:00'),
('Global Soft SPA', NULL, '+56 9 5555 5555', 'Chile', 'Concepción', TRUE, '2025-03-01 08:45:00'),
('Retail Pro Chile', 'contacto@retailpro.cl', '+56 9 6666 6666', 'Chile', 'Santiago', TRUE, '2025-03-05 14:20:00'),
('Servicios Patagonia', 'admin@patagonia.cl', '+56 9 7777 7777', 'Chile', 'Puerto Montt', FALSE, '2025-03-12 16:00:00'),
('DataFlow Corp', 'contact@dataflow.com', '+1 555 8888', 'Estados Unidos', 'Miami', TRUE, '2025-04-01 09:15:00'),
('Logística Sur', NULL, '+56 9 9999 9999', 'Chile', 'Temuco', TRUE, '2025-04-10 18:30:00'),
('Finanzas Digitales', 'operaciones@findigital.cl', '+56 9 1010 1010', 'Chile', 'Santiago', TRUE, '2025-04-20 13:10:00'),
('SPA Inteligente', 'contacto@spainteligente.cl', '+56 9 1212 1212', 'Chile', 'Santiago', TRUE, '2025-05-01 10:00:00'),
('Cloud Norte', 'soporte@cloudnorte.cl', '+56 9 1313 1313', 'Chile', 'Antofagasta', TRUE, '2025-05-03 10:00:00');

-- ============================================================
-- DATOS DE PRUEBA: products
-- ============================================================
INSERT INTO products (sku, name, description, category, price, stock, is_active, created_at) VALUES
('SW-001', 'Licencia ERP Básica', 'Licencia mensual para gestión empresarial básica', 'SOFTWARE', 29990, 100, TRUE, '2025-01-01 09:00:00'),
('SW-002', 'Licencia ERP Pro', 'Licencia mensual para gestión empresarial avanzada', 'SOFTWARE', 79990, 80, TRUE, '2025-01-02 09:00:00'),
('SW-003', 'Módulo Gestión Documental', 'Módulo de documentos con búsqueda avanzada', 'SOFTWARE', 49990, 120, TRUE, '2025-01-03 09:00:00'),
('SW-004', 'Módulo IA Documental', 'Procesamiento inteligente con IA', 'SOFTWARE', 129990, 60, TRUE, '2025-01-04 09:00:00'),
('SRV-001', 'Consultoría Técnica', 'Horas de consultoría para implementación', 'SERVICES', 45000, 200, TRUE, '2025-01-05 09:00:00'),
('SRV-002', 'Soporte Premium', 'Plan mensual de soporte prioritario', 'SERVICES', 59990, 150, TRUE, '2025-01-06 09:00:00'),
('HW-001', 'Servidor Mini', 'Equipo físico para despliegues locales', 'HARDWARE', 850000, 10, TRUE, '2025-01-07 09:00:00'),
('HW-002', 'Router Empresarial', 'Router para redes empresariales', 'HARDWARE', 120000, 25, TRUE, '2025-01-08 09:00:00'),
('BK-001', 'Curso SQL Inicial', 'Curso introductorio de SQL', 'EDUCATION', 19990, 500, TRUE, '2025-01-09 09:00:00'),
('BK-002', 'Curso PostgreSQL Avanzado', 'Curso avanzado de PostgreSQL', 'EDUCATION', 39990, 300, TRUE, '2025-01-10 09:00:00'),
('SW-005', 'Licencia API Gateway', 'Gestión de APIs y seguridad', 'SOFTWARE', 99990, 70, TRUE, '2025-01-11 09:00:00'),
('SRV-003', 'Auditoría de Seguridad', 'Evaluación técnica de seguridad web', 'SERVICES', 350000, 40, TRUE, '2025-01-12 09:00:00'),
('SW-006', 'Licencia Obsoleta', 'Producto descontinuado', 'SOFTWARE', 15000, 0, FALSE, '2025-01-13 09:00:00');

-- ============================================================
-- DATOS DE PRUEBA: orders
-- ============================================================
INSERT INTO orders (client_id, order_date, status, notes) VALUES
(1, '2025-01-15 10:00:00', 'PAID', 'Primera compra'),
(1, '2025-02-20 11:00:00', 'PAID', 'Renovación mensual'),
(1, '2025-03-22 12:00:00', 'PAID', 'Compra adicional'),
(1, '2025-04-10 13:00:00', 'PENDING', 'Pendiente de pago'),
(1, '2025-05-02 14:00:00', 'PAID', 'Pedido grande'),
(1, '2025-05-15 15:00:00', 'PAID', 'Soporte adicional'),
(2, '2025-02-01 09:30:00', 'PAID', 'Compra software'),
(2, '2025-03-03 10:30:00', 'CANCELLED', 'Cancelado por cliente'),
(3, '2025-03-10 11:30:00', 'PAID', 'Pedido internacional'),
(4, '2025-04-05 12:30:00', 'PENDING', 'Esperando transferencia'),
(5, '2025-04-15 13:30:00', 'PAID', 'Cliente sin email'),
(6, '2025-05-01 14:30:00', 'PAID', 'Retail'),
(6, '2025-05-08 15:30:00', 'REFUNDED', 'Reembolso'),
(8, '2025-06-01 16:30:00', 'PAID', 'Cliente extranjero'),
(10, CURRENT_DATE - INTERVAL '5 days', 'PAID', 'Compra reciente'),
(11, CURRENT_DATE - INTERVAL '10 days', 'PAID', 'Compra últimos 30 días'),
(12, CURRENT_DATE - INTERVAL '35 days', 'PAID', 'Compra fuera de últimos 30 días'),
(3, CURRENT_DATE - INTERVAL '2 days', 'PENDING', 'Pedido reciente pendiente'),
(4, CURRENT_DATE - INTERVAL '1 day', 'CANCELLED', 'Cancelación reciente'),
(9, CURRENT_DATE, 'PENDING', 'Pedido sin ítems para probar NOT EXISTS');

-- ============================================================
-- DATOS DE PRUEBA: order_items
-- ============================================================
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 2, 29990),
(1, 3, 1, 49990),
(2, 2, 1, 79990),
(2, 6, 1, 59990),
(3, 4, 1, 129990),
(3, 5, 5, 45000),
(4, 1, 1, 29990),
(5, 7, 2, 850000),
(5, 12, 1, 350000),
(6, 6, 3, 59990),
(7, 3, 2, 49990),
(7, 10, 1, 39990),
(8, 2, 1, 79990),
(9, 11, 2, 99990),
(9, 4, 1, 129990),
(10, 5, 2, 45000),
(11, 8, 1, 120000),
(11, 1, 1, 29990),
(12, 2, 4, 79990),
(12, 3, 3, 49990),
(13, 9, 1, 19990),
(14, 4, 2, 129990),
(15, 12, 1, 350000),
(16, 11, 1, 99990),
(17, 6, 1, 59990),
(18, 1, 1, 29990),
(19, 2, 1, 79990);

-- ============================================================
-- DATOS DE PRUEBA: payments
-- ============================================================
INSERT INTO payments (order_id, amount, method, status, paid_at) VALUES
(1, 109970, 'WEBPAY', 'PAID', '2025-01-15 10:15:00'),
(2, 139980, 'TRANSFER', 'PAID', '2025-02-20 11:15:00'),
(3, 354990, 'CARD', 'PAID', '2025-03-22 12:15:00'),
(4, 29990, 'TRANSFER', 'PENDING', NULL),
(5, 2050000, 'WEBPAY', 'PAID', '2025-05-02 14:15:00'),
(6, 179970, 'CARD', 'PAID', '2025-05-15 15:15:00'),
(7, 139970, 'WEBPAY', 'PAID', '2025-02-01 09:45:00'),
(8, 79990, 'CARD', 'FAILED', NULL),
(9, 329970, 'PAYPAL', 'PAID', '2025-03-10 11:45:00'),
(10, 90000, 'TRANSFER', 'PENDING', NULL),
(11, 149990, 'WEBPAY', 'PAID', '2025-04-15 13:45:00'),
(12, 469930, 'CARD', 'PAID', '2025-05-01 14:45:00'),
(13, 19990, 'WEBPAY', 'REFUNDED', '2025-05-08 15:45:00'),
(14, 259980, 'PAYPAL', 'PAID', '2025-06-01 16:45:00'),
(15, 350000, 'TRANSFER', 'PAID', now() - INTERVAL '4 days'),
(16, 99990, 'WEBPAY', 'PAID', now() - INTERVAL '9 days'),
(17, 59990, 'CARD', 'PAID', now() - INTERVAL '34 days'),
(18, 29990, 'TRANSFER', 'PENDING', NULL),
(19, 79990, 'CARD', 'FAILED', NULL);

-- ============================================================
-- CONSULTAS DE VERIFICACIÓN OPCIONALES
-- ============================================================
-- SELECT * FROM clients;
-- SELECT * FROM products WHERE is_active = TRUE;
-- SELECT * FROM orders WHERE status = 'PAID' AND order_date >= CURRENT_DATE - INTERVAL '30 days';
-- SELECT o.order_id, c.name AS client, SUM(oi.quantity * oi.unit_price) AS total
-- FROM orders o
-- JOIN clients c ON c.client_id = o.client_id
-- JOIN order_items oi ON oi.order_id = o.order_id
-- GROUP BY o.order_id, c.name
-- ORDER BY total DESC;
