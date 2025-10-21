USE e_commerce;

CREATE TABLE IF NOT EXISTS Auditoria_Clientes (
    id_auditoria INT AUTO_INCREMENT PRIMARY KEY,   
    id_cliente INT NOT NULL,                       
    campo_modificado VARCHAR(50) NOT NULL,         
    valor_antiguo VARCHAR(255),                    
    valor_nuevo VARCHAR(255),                      
    fecha_modificacion DATETIME DEFAULT NOW()      
);

-- ==============================================================================
-- trg_audit_cliente_after_update.
-- ==============================================================================

DROP TRIGGER IF EXISTS trg_audit_cliente_after_update;

CREATE TRIGGER trg_audit_cliente_after_update
AFTER UPDATE ON clientes
FOR EACH ROW
BEGIN
    -- Verificar si el campo 'email' cambió
    IF OLD.email <> NEW.email THEN
        INSERT INTO Auditoria_Clientes (id_cliente, campo_modificado, valor_antiguo, valor_nuevo, fecha_modificacion)
        VALUES (NEW.id_cliente, 'email', OLD.email, NEW.email, NOW());
    END IF;

    -- Verificar si el campo 'direccion_envio' cambió
    IF OLD.direccion_envio <> NEW.direccion_envio THEN
        INSERT INTO Auditoria_Clientes (id_cliente, campo_modificado, valor_antiguo, valor_nuevo, fecha_modificacion)
        VALUES (NEW.id_cliente, 'direccion_envio', OLD.direccion_envio, NEW.direccion_envio, NOW());
    END IF;
END;

UPDATE clientes SET direccion_envio ='Torcoroma 3 mz b3 casa 18' WHERE id_cliente =1;
SELECT * FROM Auditoria_Clientes;
