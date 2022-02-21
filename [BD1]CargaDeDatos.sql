/**************************************************************************/
INSERT INTO titulo (
    nombre
) SELECT DISTINCT 
    titulo_del_empleado
FROM temporal WHERE titulo_del_empleado IS NOT NULL;
/**************************************************************************/
INSERT INTO empleado (
    nombre,
    apellido,
    direccion,
    telefono,
    fecha_nacimiento,
    genero,
    id_titulo
) SELECT DISTINCT
    nombre_empleado,
    apellido_empleado,
    direccion_empleado,
    CAST(REPLACE(telefono_empleado,'-') AS INT),
    TO_DATE(fecha_nacimiento_empleado, 'YYYY-MM-DD'),
    genero_empleado,    
    (SELECT id_titulo FROM titulo WHERE titulo.nombre = temporal.titulo_del_empleado)
FROM temporal WHERE nombre_empleado IS NOT NULL;
/**************************************************************************/
INSERT INTO paciente (
    nombre,
    apellido,
    direccion,
    telefono,
    fecha_nacimiento,
    genero,
    altura_mt,
    peso
) SELECT DISTINCT
    nombre_paciente,
    apellido_paciente,
    direccion_paciente,
    CAST(REPLACE(telefono_paciente,'-') AS INT),
    TO_DATE(fecha_nacimiento_paciente, 'YYYY-MM-DD'),
    genero_paciente,    
    altura,
    peso
FROM temporal WHERE nombre_paciente IS NOT NULL;
/**************************************************************************/
INSERT INTO sintoma (
    nombre
)SELECT DISTINCT
    sintoma_del_paciente
FROM temporal WHERE sintoma_del_paciente IS NOT NULL;
/**************************************************************************/
INSERT INTO diagnostico (
    nombre
) SELECT DISTINCT
    diagnostico_del_sintoma
FROM temporal WHERE diagnostico_del_sintoma IS NOT NULL;
/**************************************************************************/
INSERT INTO tratamiento (
    nombre
) SELECT DISTINCT
    tratamiento_aplicado
FROM temporal WHERE tratamiento_aplicado IS NOT NULL;
/**************************************************************************/
INSERT INTO evaluacion (
    fecha_evaluacion,
    id_sintoma,
    id_empleado,
    id_paciente
) SELECT DISTINCT
    TO_DATE(temporal.fecha_evaluacion, 'YYYY-MM-DD'),
    (SELECT id_sintoma FROM sintoma WHERE sintoma.nombre = temporal.sintoma_del_paciente),
    (
        SELECT id_empleado FROM empleado 
        WHERE empleado.nombre = temporal.nombre_empleado 
        AND empleado.apellido = temporal.apellido_empleado 
        AND empleado.direccion = temporal.direccion_empleado
        AND empleado.telefono = CAST(REPLACE(temporal.telefono_empleado,'-') AS INT)
        AND empleado.fecha_nacimiento = TO_DATE(temporal.fecha_nacimiento_empleado, 'YYYY-MM-DD')
        AND empleado.genero = temporal.genero_empleado
        AND empleado.id_titulo = (SELECT id_titulo FROM titulo WHERE titulo.nombre = temporal.titulo_del_empleado)
    ),
    (
        SELECT id_paciente FROM paciente
        WHERE paciente.nombre = temporal.nombre_paciente
        AND paciente.apellido = temporal.apellido_paciente
        AND paciente.direccion = temporal.direccion_paciente
        AND paciente.telefono = CAST(REPLACE(temporal.telefono_paciente,'-') AS INT)
        AND paciente.fecha_nacimiento = TO_DATE(temporal.fecha_nacimiento_paciente, 'YYYY-MM-DD')
        AND paciente.genero = temporal.genero_paciente
        AND paciente.altura_mt = temporal.altura
        AND paciente.peso = temporal.peso
    )
FROM temporal WHERE nombre_paciente IS NOT NULL;
/**************************************************************************/
INSERT INTO detalle_evaluacion (
    id_evaluacion,
    id_diagnostico,
    id_tratamiento,
    rango_diagnostico,
    fecha_tratamiento
) SELECT
    (
        SELECT id_evaluacion FROM evaluacion 
                WHERE (evaluacion.fecha_evaluacion = TO_DATE(temporal.fecha_evaluacion, 'YYYY-MM-DD') OR evaluacion.fecha_evaluacion IS NULL)
                AND (evaluacion.id_sintoma = (SELECT id_sintoma FROM sintoma WHERE sintoma.nombre = temporal.sintoma_del_paciente)
                OR evaluacion.id_sintoma IS NULL)
                AND (evaluacion.id_empleado = (
                    SELECT id_empleado FROM empleado 
                    WHERE empleado.nombre = temporal.nombre_empleado 
                    AND empleado.apellido = temporal.apellido_empleado 
                    AND empleado.direccion = temporal.direccion_empleado
                    AND empleado.telefono = CAST(REPLACE(temporal.telefono_empleado,'-') AS INT)
                    AND empleado.fecha_nacimiento = TO_DATE(temporal.fecha_nacimiento_empleado, 'YYYY-MM-DD')
                    AND empleado.genero = temporal.genero_empleado
                    AND empleado.id_titulo = (SELECT id_titulo FROM titulo WHERE titulo.nombre = temporal.titulo_del_empleado)
                ) OR evaluacion.id_empleado IS NULL)
                AND evaluacion.id_paciente = (
                    SELECT id_paciente FROM paciente
                    WHERE paciente.nombre = temporal.nombre_paciente
                    AND paciente.apellido = temporal.apellido_paciente
                    AND paciente.direccion = temporal.direccion_paciente
                    AND paciente.telefono = CAST(REPLACE(temporal.telefono_paciente,'-') AS INT)
                    AND paciente.fecha_nacimiento = TO_DATE(temporal.fecha_nacimiento_paciente, 'YYYY-MM-DD')
                    AND paciente.genero = temporal.genero_paciente
                    AND paciente.altura_mt = temporal.altura
                    AND paciente.peso = temporal.peso
                )
    ),
    (SELECT id_diagnostico FROM diagnostico WHERE diagnostico.nombre = temporal.diagnostico_del_sintoma),
    (SELECT id_tratamiento FROM tratamiento WHERE tratamiento.nombre = temporal.tratamiento_aplicado),
    CAST(temporal.rango_del_diagnostico AS SMALLINT),
    TO_DATE(temporal.fecha_tratamiento, 'YYYY-MM-DD')
FROM temporal WHERE nombre_paciente IS NOT NULL;
/**************************************************************************/
COMMIT;