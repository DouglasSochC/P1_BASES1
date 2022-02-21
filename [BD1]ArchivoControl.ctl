OPTIONS (SKIP=1)
    LOAD DATA
    CHARACTERSET UTF8
    INFILE 'BIG_SMOKE_DATA.csv'
    INTO TABLE temporal TRUNCATE
    FIELDS TERMINATED BY ';' OPTIONALLY ENCLOSED BY '"'
    TRAILING(
    nombre_empleado,
    apellido_empleado,
    direccion_empleado,
    telefono_empleado,
    genero_empleado,
    fecha_nacimiento_empleado,
    titulo_del_empleado,
    nombre_paciente,
    apellido_paciente,
    direccion_paciente,
    telefono_paciente,
    genero_paciente,
    fecha_nacimiento_paciente,
    altura,
    peso,
    fecha_evaluacion,
    sintoma_del_paciente,
    diagnostico_del_sintoma,
    rango_del_diagnostico,
    fecha_tratamiento,
    tratamiento_aplicado
    )