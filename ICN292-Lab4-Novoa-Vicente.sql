DROP DATABASE IF EXISTS austral;
CREATE DATABASE austral;
USE austral;

-- Tablas del sistema
CREATE TABLE autores (
    id_autor INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(80) NOT NULL,
    pais VARCHAR(60),
    genero ENUM('Cómic', 'Ensayo', 'Infantil', 'Novela', 'Poesía') NOT NULL
);

CREATE TABLE colecciones (
    id_coleccion INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(120) NOT NULL,
    fecha_publicacion DATE NOT NULL
);

CREATE TABLE libros (
    id_libro INT AUTO_INCREMENT PRIMARY KEY,
    id_autor INT NOT NULL,
    id_coleccion INT,
    titulo VARCHAR(120) NOT NULL,
    paginas INT NOT NULL,
    ejemplares_vendidos INT NOT NULL,
    anio INT NOT NULL,
    FOREIGN KEY (id_autor) REFERENCES autores(id_autor),
    FOREIGN KEY (id_coleccion) REFERENCES colecciones(id_coleccion)
);

CREATE TABLE pagos (
    id_pago INT AUTO_INCREMENT PRIMARY KEY,
    id_autor INT NOT NULL,
    fecha_pago DATE NOT NULL,
    monto DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_autor) REFERENCES autores(id_autor)
);

-- Inserción de autores
INSERT INTO autores (nombre, pais, genero) VALUES
('Elena Pizarro', 'Chile', 'Novela'),
('Harold Finch', 'Inglaterra', 'Ensayo'),
('Rodrigo Bahamonde', 'Chile', 'Poesía'),
('Valentina Correa', 'Argentina', 'Infantil'),
('Nora Keller', 'Estados Unidos', 'Novela'),
('Kenji Arakawa', NULL, 'Cómic');

-- Inserción de colecciones
INSERT INTO colecciones (titulo, fecha_publicacion) VALUES
('Colección Clásicos Contemporáneos', '2023-03-15'),
('Colección Juvenil Austral', '2024-01-10');

-- Inserción de libros
INSERT INTO libros (id_autor, id_coleccion, titulo, paginas, ejemplares_vendidos, anio) VALUES
((SELECT id_autor FROM autores WHERE nombre = 'Elena Pizarro'), 1, 'Cielo de Enero', 210, 1500, 2024),
((SELECT id_autor FROM autores WHERE nombre = 'Elena Pizarro'), 1, 'Marea Baja', 185, 800, 2023),
((SELECT id_autor FROM autores WHERE nombre = 'Elena Pizarro'), 2, 'El Norte', 200, 2200, 2024),
((SELECT id_autor FROM autores WHERE nombre = 'Harold Finch'), 1, 'Estrellas que Caen', 240, 3000, 2022),
((SELECT id_autor FROM autores WHERE nombre = 'Harold Finch'), 2, 'Máquinas', 215, 450, 2024),
((SELECT id_autor FROM autores WHERE nombre = 'Rodrigo Bahamonde'), 1, 'Luz Artificial', 300, 1200, 2024),
((SELECT id_autor FROM autores WHERE nombre = 'Rodrigo Bahamonde'), 2, 'Ruido Blanco', 280, 600, 2023),
((SELECT id_autor FROM autores WHERE nombre = 'Valentina Correa'), 2, 'El Barrio de Lila', 190, 5000, 2024),
((SELECT id_autor FROM autores WHERE nombre = 'Valentina Correa'), 2, 'Antes del Amanecer', 205, 2700, 2024),
((SELECT id_autor FROM autores WHERE nombre = 'Valentina Correa'), 1, 'La Calle 8', 175, 900, 2023),
((SELECT id_autor FROM autores WHERE nombre = 'Nora Keller'), 1, 'Flor de Hierro', 195, 4100, 2024),
((SELECT id_autor FROM autores WHERE nombre = 'Nora Keller'), 2, 'Hora Dorada', 220, 1800, 2022);

-- Inserción de pagos
INSERT INTO pagos (id_autor, fecha_pago, monto) VALUES
((SELECT id_autor FROM autores WHERE nombre = 'Elena Pizarro'), '2024-05-10', 150050.00),
((SELECT id_autor FROM autores WHERE nombre = 'Elena Pizarro'), '2024-08-20', 85000.00),
((SELECT id_autor FROM autores WHERE nombre = 'Harold Finch'), '2024-06-12', 200000.00);


-- Consultas

-- 1
SELECT nombre, genero 
FROM autores 
WHERE pais <> 'Chile' OR pais IS NULL 
ORDER BY nombre;

-- 2
SELECT titulo, paginas 
FROM libros 
WHERE paginas BETWEEN 190 AND 220 
ORDER BY paginas;

-- 3
SELECT 
    COUNT(*) AS total_libros,
    SUM(ejemplares_vendidos) AS suma_ventas,
    AVG(paginas) AS promedio_paginas,
    MIN(anio) AS anio_minimo,
    MAX(ejemplares_vendidos) AS max_ventas
FROM libros;

-- 4
SELECT DISTINCT genero 
FROM autores 
ORDER BY genero;

-- 5
SELECT a.nombre, COUNT(l.id_libro) AS total
FROM autores a
JOIN libros l ON a.id_autor = l.id_autor
WHERE l.anio = 2024
GROUP BY a.id_autor
HAVING total > 1
ORDER BY a.nombre;

-- 6
SELECT titulo, ejemplares_vendidos 
FROM libros 
WHERE anio = 2024 AND ejemplares_vendidos > 2000 
ORDER BY ejemplares_vendidos DESC 
LIMIT 3;

-- 7
INSERT INTO libros (id_autor, titulo, paginas, ejemplares_vendidos, anio) 
VALUES ((SELECT id_autor FROM autores WHERE nombre = 'Rodrigo Bahamonde'), 'Papel Mojado', 260, 50, 2024);

SELECT * FROM libros WHERE titulo = 'Papel Mojado';

SET SQL_SAFE_UPDATES = 0;
DELETE FROM libros WHERE titulo = 'Papel Mojado';
SET SQL_SAFE_UPDATES = 1;

SELECT * FROM libros WHERE titulo = 'Papel Mojado';

-- 8
SELECT titulo, ejemplares_vendidos 
FROM libros 
WHERE titulo = 'Cielo de Enero';

SET SQL_SAFE_UPDATES = 0;
UPDATE libros 
SET ejemplares_vendidos = ejemplares_vendidos + 100 
WHERE titulo = 'Cielo de Enero';
SET SQL_SAFE_UPDATES = 1;

SELECT titulo, ejemplares_vendidos 
FROM libros 
WHERE titulo = 'Cielo de Enero';

-- 9
SELECT l.titulo AS libro, c.titulo AS coleccion, c.fecha_publicacion
FROM libros l
JOIN colecciones c ON l.id_coleccion = c.id_coleccion;

-- 10
SELECT a.nombre, p.fecha_pago, p.monto
FROM pagos p
JOIN autores a ON p.id_autor = a.id_autor;

SELECT a.nombre, SUM(p.monto) AS total_pagado
FROM pagos p
JOIN autores a ON p.id_autor = a.id_autor
GROUP BY a.id_autor;