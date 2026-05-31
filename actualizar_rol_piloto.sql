USE transmetro_db;

-- Agregar el rol Piloto si ya tienes la base importada.
-- Si el trigger de roles bloquea el INSERT, elimina temporalmente el trigger y vuelve a crearlo.
DROP TRIGGER IF EXISTS trg_roles_no_insert;

INSERT INTO roles (nombre_rol, descripcion)
SELECT 'Piloto', 'Puede ingresar alertas y consultarlas; no puede editarlas'
WHERE NOT EXISTS (SELECT 1 FROM roles WHERE nombre_rol='Piloto');

INSERT INTO usuarios (nombre, correo, contrasena, id_rol, estado)
SELECT 'Piloto Transmetro', 'piloto@transmetro.com', '$2y$12$xPHdHYcn2I01255mtdjVNetwayJ9PDrtBJ8npxzGmQjWfkFm.e5A6', r.id_rol, 'Activo'
FROM roles r
WHERE r.nombre_rol='Piloto'
AND NOT EXISTS (SELECT 1 FROM usuarios WHERE correo='piloto@transmetro.com');

DELIMITER $$
CREATE TRIGGER trg_roles_no_insert
BEFORE INSERT ON roles
FOR EACH ROW
BEGIN
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No se permite crear roles nuevos. Los roles ya estan definidos.';
END$$
DELIMITER ;
