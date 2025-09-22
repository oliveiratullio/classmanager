INSERT INTO department (name) VALUES
('Matemática'), ('Computação'), ('Letras');

INSERT INTO title (name) VALUES
('Assistente'), ('Adjunto'), ('Associado'), ('Titular');

INSERT INTO professor (name, department_id, title_id) VALUES
('Professor Girafales', 1, 4),
('Raimundo Nonato', 2, 2),
('Maria Antonieta', 1, 1),
('José Roberto', 2, 3);

INSERT INTO building (name) VALUES ('Prédio A'), ('Prédio B');

INSERT INTO room (building_id, name) VALUES
(1, 'A-101'),
(1, 'A-102'),
(2, 'B-201');

INSERT INTO subject (code, name, professor_id, department_id) VALUES
('MAT101', 'Cálculo I', 1, 1),
('MAT202', 'Álgebra Linear', 3, 1),
('INF101', 'Algoritmos', 2, 2),
('INF202', 'Estruturas de Dados', 4, 2);

INSERT INTO class (subject_id, year, semester, code) VALUES
(1, 2025, 1, 'MAT101-T01'),
(2, 2025, 1, 'MAT202-T01'),
(3, 2025, 1, 'INF101-T01'),
(4, 2025, 1, 'INF202-T01');

-- day_of_week: 1=Seg, 2=Ter, 3=Qua, 4=Qui, 5=Sex
-- MAT101 (Girafales) - Seg/Qua 09:30-11:00 em A-101
INSERT INTO class_schedule (class_id, room_id, day_of_week, start_time, end_time) VALUES
(1, 1, 1, '09:30', '11:00'),
(1, 1, 3, '09:30', '11:00');

-- MAT202 (Maria) - Ter 08:00-10:00 em A-102
INSERT INTO class_schedule VALUES
(DEFAULT, 2, 2, 2, '08:00', '10:00');

-- INF101 (Raimundo) - Seg 08:00-09:30 em A-101
INSERT INTO class_schedule VALUES
(DEFAULT, 3, 1, 1, '08:00', '09:30');

-- INF202 (José) - Sex 14:00-17:00 em B-201
INSERT INTO class_schedule VALUES
(DEFAULT, 4, 3, 5, '14:00', '17:00');
