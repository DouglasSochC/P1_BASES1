/******************************************************************************************
*******************************************************************************************
1. Mostrar el nombre, apellido y teléfono de todos los empleados y la cantidad
de pacientes atendidos por cada empleado ordenados de mayor a menor.
*******************************************************************************************
*******************************************************************************************/
SELECT empleado.nombre, empleado.apellido, empleado.telefono, COUNT(DISTINCT evaluacion.fecha_evaluacion) AS cantidad_pacientes_atendidos
FROM evaluacion
INNER JOIN empleado ON empleado.id_empleado = evaluacion.id_empleado
GROUP BY empleado.nombre, empleado.apellido, empleado.telefono
ORDER BY cantidad_pacientes_atendidos DESC;
/******************************************************************************************
*******************************************************************************************
2. Mostrar el nombre, apellido, dirección y título de todos los empleados de sexo
masculino que atendieron a más de 3 pacientes en el año 2016.
*******************************************************************************************
*******************************************************************************************/
SELECT empleado.nombre, empleado.apellido, empleado.direccion, titulo.nombre, COUNT(DISTINCT evaluacion.fecha_evaluacion) AS titulo
FROM evaluacion
INNER JOIN empleado ON empleado.id_empleado = evaluacion.id_empleado
INNER JOIN titulo ON titulo.id_titulo = empleado.id_titulo
WHERE empleado.genero = 'M' AND evaluacion.fecha_evaluacion >= '01/01/2016' AND evaluacion.fecha_evaluacion <= '31/12/2016'
GROUP BY empleado.nombre, empleado.apellido, empleado.direccion, titulo.nombre
HAVING COUNT(DISTINCT evaluacion.fecha_evaluacion) > 3;
/******************************************************************************************
*******************************************************************************************
3. Mostrar el nombre y apellido de todos los pacientes que se están aplicando el
tratamiento “Tabaco en polvo” y que tuvieron el síntoma “Dolor de cabeza”.
*******************************************************************************************
*******************************************************************************************/
SELECT paciente.nombre, paciente.apellido FROM detalle_evaluacion
INNER JOIN tratamiento ON tratamiento.id_tratamiento = detalle_evaluacion.id_tratamiento
INNER JOIN evaluacion ON evaluacion.id_evaluacion = detalle_evaluacion.id_evaluacion
INNER JOIN paciente ON paciente.id_paciente = evaluacion.id_paciente
INNER JOIN sintoma ON sintoma.id_sintoma = evaluacion.id_sintoma
WHERE sintoma.nombre = 'Dolor de cabeza' AND tratamiento.nombre = 'Tabaco en polvo'
GROUP BY paciente.nombre, paciente.apellido
ORDER BY paciente.nombre, paciente.apellido;
/******************************************************************************************
*******************************************************************************************
4. Top 5 de pacientes que más tratamientos se han aplicado del tratamiento “Antidepresivos”. 
Mostrar nombre, apellido y la cantidad de tratamientos.
*******************************************************************************************
*******************************************************************************************/
SELECT paciente.nombre, paciente.apellido, COUNT(DISTINCT detalle_evaluacion.fecha_tratamiento) AS cantidad_tratamientos 
FROM detalle_evaluacion
INNER JOIN tratamiento ON tratamiento.id_tratamiento = detalle_evaluacion.id_tratamiento
INNER JOIN evaluacion ON evaluacion.id_evaluacion = detalle_evaluacion.id_evaluacion
INNER JOIN paciente ON paciente.id_paciente = evaluacion.id_paciente
INNER JOIN sintoma ON sintoma.id_sintoma = evaluacion.id_sintoma
WHERE tratamiento.nombre = 'Antidepresivos'
GROUP BY paciente.nombre, paciente.apellido
ORDER BY cantidad_tratamientos DESC
FETCH FIRST 5 ROWS ONLY;
/******************************************************************************************
*******************************************************************************************
5. Mostrar el nombre, apellido y dirección de todos los pacientes que se hayan
aplicado más de 3 tratamientos y no hayan sido atendidos por un empleado. 
Debe mostrar la cantidad de tratamientos que se aplicó el paciente. 
Ordenar los resultados de mayor a menor utilizando la cantidad de tratamientos.
*******************************************************************************************
*******************************************************************************************/
SELECT paciente.nombre, paciente.apellido, paciente.direccion, COUNT(detalle_evaluacion.id_detalle_evaluacion) AS cantidad_tratamiento 
FROM detalle_evaluacion
INNER JOIN evaluacion ON evaluacion.id_evaluacion = detalle_evaluacion.id_evaluacion
INNER JOIN paciente ON paciente.id_paciente = evaluacion.id_paciente
WHERE evaluacion.id_empleado IS NULL
GROUP BY paciente.nombre, paciente.apellido, paciente.direccion
HAVING COUNT(detalle_evaluacion.id_detalle_evaluacion) > 3;
/******************************************************************************************
*******************************************************************************************
6. Mostrar el nombre del diagnóstico y la cantidad de síntomas a los que ha sido
asignado donde el rango ha sido de 9. Ordene sus resultados de mayor a
menor en base a la cantidad de síntomas.
*******************************************************************************************
*******************************************************************************************/
SELECT COUNT(DISTINCT evaluacion.id_sintoma) AS cantidad_sintomas, diagnostico.nombre AS diagnositico_asignado
FROM detalle_evaluacion
INNER JOIN evaluacion ON evaluacion.id_evaluacion = detalle_evaluacion.id_evaluacion
INNER JOIN diagnostico ON diagnostico.id_diagnostico = detalle_evaluacion.id_diagnostico
WHERE detalle_evaluacion.rango_diagnostico = 9
GROUP BY diagnostico.nombre
ORDER BY cantidad_sintomas DESC;
/******************************************************************************************
*******************************************************************************************
7. Mostrar el nombre, apellido y dirección de todos los pacientes que
presentaron un síntoma que al que le fue asignado un diagnóstico con un
rango mayor a 5. Debe mostrar los resultados en orden alfabético tomando
en cuenta el nombre y apellido del paciente.
*******************************************************************************************
*******************************************************************************************/
SELECT paciente.nombre, paciente.apellido, paciente.direccion FROM detalle_evaluacion
INNER JOIN evaluacion ON evaluacion.id_evaluacion = detalle_evaluacion.id_evaluacion
INNER JOIN paciente ON paciente.id_paciente = evaluacion.id_paciente
WHERE detalle_evaluacion.rango_diagnostico > 5
GROUP BY paciente.nombre, paciente.apellido, paciente.direccion
ORDER BY paciente.nombre, paciente.apellido ASC;
/******************************************************************************************
*******************************************************************************************
8. Mostrar el nombre, apellido y fecha de nacimiento de todos los empleados de
sexo femenino cuya dirección es “1475 Dryden Crossing” y hayan atendido
por lo menos a 2 pacientes. Mostrar la cantidad de pacientes atendidos por
el empleado y ordénelos de mayor a menor.
*******************************************************************************************
*******************************************************************************************/
SELECT empleado.nombre, empleado.apellido, empleado.fecha_nacimiento, COUNT(DISTINCT evaluacion.id_paciente) AS pacientes_atendidos 
FROM evaluacion
INNER JOIN empleado ON empleado.id_empleado = evaluacion.id_empleado
WHERE evaluacion.id_paciente IS NOT NULL AND empleado.genero = 'F' AND empleado.direccion = '1475 Dryden Crossing'
GROUP BY empleado.nombre, empleado.apellido, empleado.fecha_nacimiento
HAVING COUNT(evaluacion.id_evaluacion) >= 2
ORDER BY COUNT(evaluacion.id_evaluacion) ASC;
/******************************************************************************************
*******************************************************************************************
9. Mostrar el porcentaje de pacientes que ha atendido cada empleado a partir
del año 2017 y mostrarlos de mayor a menor en base al porcentaje calculado.
REVISAR - UTILIZAR AVG
REVISAR - UTILIZAR AVG
REVISAR - UTILIZAR AVG
REVISAR - UTILIZAR AVG
*******************************************************************************************
*******************************************************************************************/
SELECT empleado.nombre, empleado.apellido, (COUNT(DISTINCT id_paciente)*100)/(SELECT SUM(COUNT(DISTINCT id_paciente)) FROM evaluacion
INNER JOIN empleado ON empleado.id_empleado = evaluacion.id_empleado
WHERE evaluacion.fecha_evaluacion >= '01/01/2017' AND evaluacion.fecha_evaluacion <= '31/12/2017'
GROUP BY empleado.nombre, empleado.apellido) AS pacientes_atendidos FROM evaluacion
INNER JOIN empleado ON empleado.id_empleado = evaluacion.id_empleado
WHERE evaluacion.fecha_evaluacion >= '01/01/2017' AND evaluacion.fecha_evaluacion <= '31/12/2017'
GROUP BY empleado.nombre, empleado.apellido
ORDER BY pacientes_atendidos DESC;
/******************************************************************************************
*******************************************************************************************
10. Mostrar el porcentaje del título de empleado más común de la siguiente
manera: nombre del título, porcentaje de empleados que tienen ese
título. Debe ordenar los resultados en base al porcentaje de mayor a menor.
UTILIZAR AVG
UTILIZAR AVG
UTILIZAR AVG
UTILIZAR AVG
*******************************************************************************************
*******************************************************************************************/
SELECT titulo.nombre, (COUNT(empleado.id_empleado)*100/(SELECT SUM(COUNT(empleado.id_empleado)) FROM empleado
INNER JOIN titulo ON titulo.id_titulo = empleado.id_titulo
GROUP BY titulo.nombre)) AS porcentaje_empleados FROM empleado
INNER JOIN titulo ON titulo.id_titulo = empleado.id_titulo
GROUP BY titulo.nombre
ORDER BY porcentaje_empleados DESC;
/******************************************************************************************
*******************************************************************************************
11. Mostrar el año y mes (de la fecha de evaluación) junto con el nombre y
apellido de los pacientes que más tratamientos se han aplicado y los que menos. 
(Todo en una sola consulta). Nota: debe tomar como cantidad
mínima 1 tratamiento.
REVISAR
REVISAR
REVISAR
REVISAR
*******************************************************************************************
*******************************************************************************************/
SELECT EXTRACT(YEAR FROM fecha_evaluacion) AS anio, EXTRACT(MONTH FROM fecha_evaluacion) AS mes, paciente.nombre, paciente.apellido 
FROM detalle_evaluacion
INNER JOIN evaluacion ON evaluacion.id_evaluacion = detalle_evaluacion.id_evaluacion
INNER JOIN paciente ON paciente.id_paciente = evaluacion.id_paciente;
