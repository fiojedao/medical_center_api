CREATE DATABASE medical_center;

USE medical_center;

-- Tabla para gestionar los tipos de usuario
CREATE TABLE user_types (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  type VARCHAR(100) NOT NULL,
  description VARCHAR(255) NOT NULL,
  created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para gestionar los usuarios
CREATE TABLE users_auth (
  user_id VARCHAR(20) NOT NULL,
  username VARCHAR(100) NOT NULL,
  password VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL,
  user_type_id INT NOT NULL,
  created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_type_id) REFERENCES user_types(id),
  PRIMARY KEY (user_id, username, email)
);

CREATE TABLE users (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id VARCHAR(20) NOT NULL,
  name VARCHAR(45) NOT NULL,
  lastname_one VARCHAR(45) NOT NULL,
  lastname_two VARCHAR(45) NOT NULL,
  genre VARCHAR(20) NOT NULL,
  address VARCHAR(255) NOT NULL,
  date_of_birth DATE NOT NULL,
  contact VARCHAR(20) NOT NULL,
  emergency_contact VARCHAR(20) NOT NULL,
  blood_type VARCHAR(15) NOT NULL,
  created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users_auth(user_id)
);

-- Tabla para gestionar la autenticación de los usuarios
CREATE TABLE user_sessions (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id VARCHAR(20) NOT NULL,
  user_name VARCHAR(100) NOT NULL,
  user_email VARCHAR(100) NOT NULL,
  session_token VARCHAR(100) NOT NULL,
  created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id, user_name, user_email) REFERENCES users_auth(user_id, username, email)
);

-- Tabla para gestionar las preferencias de los usuarios
CREATE TABLE user_preferences (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id VARCHAR(20) NOT NULL,
  preference_name VARCHAR(100) NOT NULL,
  preference_value VARCHAR(100),
  created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users_auth(user_id)
);

CREATE TABLE medical_specialities (
  code_id VARCHAR(20) NOT NULL,
  name VARCHAR(50) NOT NULL,
  description VARCHAR(250) NOT NULL,
  created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (code_id)
);

-- Tabla para gestionar los médicos
CREATE TABLE doctors (
  doctor_id VARCHAR(20) NOT NULL,
  name VARCHAR(100) NOT NULL,
  medical_specialities_code VARCHAR(20) NOT NULL,
  created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (doctor_id),
  FOREIGN KEY (medical_specialities_code) REFERENCES medical_specialities(code_id)
);


-- Tabla para gestionar las enfermedades
CREATE TABLE diseases (
  code_id VARCHAR(20) NOT NULL,
  name VARCHAR(100) NOT NULL,
  created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (code_id)
);

-- Tabla para gestionar las alergias
CREATE TABLE allergies (
  code_id VARCHAR(20) NOT NULL,
  name VARCHAR(100) NOT NULL,
  created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (code_id)
);

-- Tabla para gestionar los registros médicos
CREATE TABLE medical_records (
  medical_records_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id VARCHAR(20),
  doctor_id VARCHAR(20),
  created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT user_id FOREIGN KEY (user_id) REFERENCES users(user_id),
  CONSTRAINT doctor_id FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

CREATE TABLE medical_record_diseases (
  user_id VARCHAR(20) NOT NULL,
  medical_record_id INT NOT NULL,
  diseases_code_id VARCHAR(20) NOT NULL,
  created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT medical_record_id_diseases FOREIGN KEY (medical_record_id) REFERENCES medical_records(medical_records_id),
  CONSTRAINT diseases_code_id FOREIGN KEY (diseases_code_id) REFERENCES diseases(code_id)
);

CREATE TABLE medical_record_allergies (
  user_id VARCHAR(20) NOT NULL,
  medical_record_id INT NOT NULL,
  allergies_code_id VARCHAR(20) NOT NULL,
  created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT medical_record_id_allergies FOREIGN KEY (medical_record_id) REFERENCES medical_records(medical_records_id),
  CONSTRAINT allergies_code_id FOREIGN KEY (allergies_code_id) REFERENCES allergies(code_id)
);

-- Gestiona los registro de medicamentos que utilizara stock
CREATE TABLE medications (
  code VARCHAR(100) PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  description VARCHAR(255) NOT NULL,
  dose VARCHAR(255) NOT NULL,
  type VARCHAR(255) NOT NULL,
  created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_date DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Contiene la información de los medicamentos en existencia
CREATE TABLE stock (
  id INT AUTO_INCREMENT PRIMARY KEY,
  medications_code VARCHAR(100) NOT NULL,
  lot VARCHAR(50) NOT NULL,
  expiration_date DATE NOT NULL,
  description VARCHAR(255) NOT NULL,
  entry_date VARCHAR(255) NOT NULL,
  amount INT NOT NULL,
  created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (medications_code) REFERENCES medications(code)
);

-- Tabla para gestionar los medicamentos
CREATE TABLE medications_user (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  medical_records_id INT NOT NULL,
  created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  medications_code INT NOT NULL,
  stock_id INT NOT NULL,
  FOREIGN KEY (medical_records_id) REFERENCES medical_records(medical_records_id),
  FOREIGN KEY (stock_id) REFERENCES stock(id)
);

-- Tabla para gestionar las cirugias

CREATE TABLE surgeries (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  date DATETIME NOT NULL,
  medical_records_id INT NOT NULL,
  doctor_id VARCHAR(20) NOT NULL,
  status CHAR NOT NULL,
  created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (medical_records_id) REFERENCES medical_records(medical_records_id),
  FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

-- Tabla para gestionar las citas
CREATE TABLE appointments (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  date DATETIME NOT NULL,
  description VARCHAR(100),
  medical_records_id INT NOT NULL,
  consulting_room VARCHAR(50),
  status CHAR NOT NULL,
  created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (medical_records_id) REFERENCES medical_records(medical_records_id)
);

-- Tabla intermedia para relacionar médicos con citas
CREATE TABLE appointment_doctors (
  appointment_id INT NOT NULL,
  doctor_id VARCHAR(20) NOT NULL,
  created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (appointment_id, doctor_id),
  FOREIGN KEY (appointment_id) REFERENCES appointments(id),
  FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

-- Tabla consulta medica
CREATE TABLE general_consult (
  id_consult INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  doctor_id VARCHAR(20) NOT NULL,
  description VARCHAR(255) NOT NULL,
  price DECIMAL NOT NULL,
  created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_date DATETIME DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);

CREATE TABLE appointments_times (
  id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  appointments_id INT NOT NULL,
  init_datetime DATETIME NOT NULL,
  end_datetime DATETIME NOT NULL,
  created_date DATETIME NULL DEFAULT CURRENT_TIMESTAMP(),
  updated_date DATETIME NULL DEFAULT CURRENT_TIMESTAMP(),
  FOREIGN KEY (appointments_id) REFERENCES appointments(id)
);

/*
-- Indices para mejorar la eficiencia en las búsquedas
CREATE INDEX idx_users_auth_username ON users_auth (username);
CREATE INDEX idx_user_sessions_user_id ON user_sessions (user_id);
CREATE INDEX idx_user_preferences_user_id ON user_preferences (user_id);
CREATE INDEX idx_medical_records_user_id ON medical_records (user_id);
CREATE INDEX idx_allergies_medical_records_id ON allergies (medical_records_id);
CREATE INDEX idx_diseases_medical_records_id ON diseases (medical_records_id);
CREATE INDEX idx_medications_user_medical_records_id ON medications_user (medical_records_id);
CREATE INDEX idx_surgeries_medical_records_id ON surgeries (medical_records_id);
CREATE INDEX idx_appointments_medical_records_id ON appointments (medical_records_id);*/


-- INSERT

INSERT INTO allergies (code_id, name, created_date, updated_date)
VALUES
('A001', 'Pollen', '2022-01-01 00:00:00', '2022-01-01 00:00:00'),
('A002', 'Dust mites', '2022-01-02 00:00:00', '2022-01-02 00:00:00'),
('A003', 'Pet dander', '2022-01-03 00:00:00', '2022-01-03 00:00:00'),
('A004', 'Mold', '2022-01-04 00:00:00', '2022-01-04 00:00:00'),
('A005', 'Food', '2022-01-05 00:00:00', '2022-01-05 00:00:00'),
('A006', 'Insect bites', '2022-01-06 00:00:00', '2022-01-06 00:00:00'),
('A007', 'Latex', '2022-01-07 00:00:00', '2022-01-07 00:00:00'),
('A008', 'Medication', '2022-01-08 00:00:00', '2022-01-08 00:00:00'),
('A009', 'Chemicals', '2022-01-09 00:00:00', '2022-01-09 00:00:00'),
('A010', 'Smoke', '2022-01-10 00:00:00', '2022-01-10 00:00:00'),
('A011', 'Cold air', '2022-01-11 00:00:00', '2022-01-11 00:00:00'),
('A012', 'Exercise', '2022-01-12 00:00:00', '2022-01-12 00:00:00'),
('A013', 'Stress', '2022-01-13 00:00:00', '2022-01-13 00:00:00'),
('A014', 'Alcohol', '2022-01-14 00:00:00', '2022-01-14 00:00:00'),
('A015', 'Caffeine', '2022-01-15 00:00:00', '2022-01-15 00:00:00'),
('A016', 'Chocolate', '2022-01-16 00:00:00', '2022-01-16 00:00:00'),
('A017', 'Eggs', '2022-01-17 00:00:00', '2022-01-17 00:00:00'),
('A018', 'Fish', '2022-01-18 00:00:00', '2022-01-18 00:00:00'),
('A019', 'Milk', '2022-01-19 00:00:00', '2022-01-19 00:00:00'),
('A020', 'Nuts', '2022-01-20 00:00:00', '2022-01-20 00:00:00');

INSERT INTO diseases (code_id, name, created_date, updated_date)
VALUES
('D001', 'Cancer', '2022-01-01 00:00:00', '2022-01-01 00:00:00'),
('D002', 'Diabetes', '2022-01-02 00:00:00', '2022-01-02 00:00:00'),
('D003', 'Heart disease', '2022-01-03 00:00:00', '2022-01-03 00:00:00'),
('D004', 'Stroke', '2022-01-04 00:00:00', '2022-01-04 00:00:00'),
('D005', 'Alzheimers', '2022-01-05 00:00:00', '2022-01-05 00:00:00'),
('D006', 'Parkinsons', '2022-01-06 00:00:00', '2022-01-06 00:00:00'),
('D007', 'Arthritis', '2022-01-07 00:00:00', '2022-01-07 00:00:00'),
('D008', 'Depression', '2022-01-08 00:00:00', '2022-01-08 00:00:00'),
('D009', 'Anxiety', '2022-01-09 00:00:00', '2022-01-09 00:00:00'),
('D010', 'Obesity', '2022-01-10 00:00:00', '2022-01-10 00:00:00'),
('D011', 'Asthma', '2022-01-11 00:00:00', '2022-01-11 00:00:00'),
('D012', 'COPD', '2022-01-12 00:00:00', '2022-01-12 00:00:00'),
('D013', 'HIV/AIDS', '2022-01-13 00:00:00', '2022-01-13 00:00:00'),
('D014', 'Hepatitis', '2022-01-14 00:00:00', '2022-01-14 00:00:00'),
('D015', 'Malaria', '2022-01-15 00:00:00', '2022-01-15 00:00:00'),
('D016', 'Tuberculosis', '2022-01-16 00:00:00', '2022-01-16 00:00:00'),
('D017', 'Measles', '2022-01-17 00:00:00', '2022-01-17 00:00:00'),
('D018', 'Flu', '2022-01-18 00:00:00', '2022-01-18 00:00:00'),
('D019', 'COVID-19', '2022-01-19 00:00:00', '2022-01-19 00:00:00'),
('D020', 'High blood pressure', '2022-01-20 00:00:00','2022-01-19 00:00:00');

INSERT INTO medical_specialities (code_id, name, description, created_date, updated_date)
VALUES
('MSP001', 'Cardiology', 'Specializes in treating heart diseases and conditions.', '2022-01-01 00:00:00', '2022-01-01 00:00:00'),
('MSP002', 'Dermatology', 'Specializes in treating skin conditions and diseases.', '2022-01-02 00:00:00', '2022-01-02 00:00:00'),
('MSP003', 'Endocrinology', 'Specializes in treating hormonal disorders.', '2022-01-03 00:00:00', '2022-01-03 00:00:00'),
('MSP004', 'Gastroenterology', 'Specializes in treating digestive system disorders.', '2022-01-04 00:00:00', '2022-01-04 00:00:00'),
('MSP005', 'Hematology', 'Specializes in treating blood disorders.', '2022-01-05 00:00:00', '2022-01-05 00:00:00'),
('MSP006', 'Infectious Disease', 'Specializes in treating infectious diseases.', '2022-01-06 00:00:00', '2022-01-06 00:00:00'),
('MSP007', 'Internal Medicine', 'Specializes in treating internal diseases.', '2022-01-07 00:00:00', '2022-01-07 00:00:00'),
('MSP008', 'Neurology', 'Specializes in treating nervous system disorders.', '2022-01-08 00:00:00', '2022-01-08 00:00:00'),
('MSP009', 'Oncology', 'Specializes in treating cancer.', '2022-01-09 00:00:00', '2022-01-09 00:00:00'),
('MSP010', 'Ophthalmology', 'Specializes in treating eye diseases and conditions.', '2022-01-10 00:00:00', '2022-01-10 00:00:00'),
('MSP011', 'Orthopedics', 'Specializes in treating bone and joint diseases and injuries.', '2022-01-11 00:00:00', '2022-01-11 00:00:00'),
('MSP012', 'Otolaryngology', 'Specializes in treating ear, nose, and throat diseases and conditions.', '2022-01-12 00:00:00', '2022-01-12 00:00:00'),
('MSP013', 'Pediatrics', 'Specializes in treating children\'s health and diseases.', '2022-01-13 00:00:00', '2022-01-13 00:00:00'),
('MSP014', 'Psychiatry', 'Specializes in treating mental disorders.', '2022-01-14 00:00:00', '2022-01-14 00:00:00'),
('MSP015', 'Pulmonology', 'Specializes in treating lung diseases and conditions.', '2022-01-15 00:00:00', '2022-01-15 00:00:00'),
('MSP016', 'Radiology', 'Specializes in diagnosing and treating diseases and injuries using medical imaging procedures.', '2022-01-16 00:00:00', '2022-01-16 00:00:00'),
('MSP017', 'Rheumatology', 'Specializes in treating autoimmune and inflammatory disorders affecting the joints, muscles, and bones.', '2022-01-17 00:00:00', '2022-01-17 00:00:00'),
('MSP018', 'Sleep Medicine', 'Specializes in diagnosing and treating sleep disorders.', '2022-01-18 00:00:00', '2022-01-18 00:00:00'),
('MSP019', 'Sports Medicine', 'Specializes in treating and preventing sports-related injuries and conditions.', '2022-01-19 00:00:00', '2022-01-19 00:00:00'),
('MSP020', 'Surgery', 'Specializes in performing surgical procedures to treat diseases and injuries.', '2022-01-20 00:00:00', '2022-01-20 00:00:00'),
('MSP021', 'Urology', 'Specializes in treating urinary tract and male reproductive system disorders.', '2022-01-21 00:00:00', '2022-01-21 00:00:00'),
('MSP022', 'Allergy and Immunology', 'Specializes in diagnosing and treating allergies and immune system disorders.', '2022-01-22 00:00:00', '2022-01-22 00:00:00'),
('MSP023', 'Anesthesiology', 'Specializes in administering anesthesia during surgery and other medical procedures.', '2022-01-23 00:00:00', '2022-01-23 00:00:00'),
('MSP024', 'Cardiothoracic Surgery', 'Specializes in performing surgical procedures on the heart, lungs, and other thoracic organs.', '2022-01-24 00:00:00', '2022-01-24 00:00:00'),
('MSP025', 'Critical Care Medicine', 'Specializes in caring for critically ill patients in intensive care units.', '2022-01-25 00:00:00', '2022-01-25 00:00:00'),
('MSP026', 'Diagnostic Radiology', 'Specializes in using medical imaging to diagnose diseases and conditions.', '2022-01-26 00:00:00', '2022-01-26 00:00:00'),
('MSP027', 'Emergency Medicine', 'Specializes in providing immediate medical care to patients with acute illnesses and injuries.', '2022-01-27 00:00:00', '2022-01-27 00:00:00'),
('MSP028', 'Family Medicine', 'Specializes in providing primary care services to patients of all ages.', '2022-01-28 00:00:00', '2022-01-28 00:00:00'),
('MSP029', 'Gynecology', 'Specializes in treating female reproductive system disorders and providing women\'s health care services.', '2022-01-29 00:00:00', '2022-01-29 00:00:00');


INSERT INTO medications (code, name, description, dose, type, created_date, updated_date) VALUES
('MED001', 'Amoxicillin', 'An antibiotic used to treat bacterial infections.', '500 mg every 8 hours', 'Tablet', '2022-01-01 00:00:00', '2022-01-01 00:00:00'),
('MED002', 'Ibuprofen', 'A nonsteroidal anti-inflammatory drug (NSAID) used to relieve pain, inflammation, and fever.', '400 mg every 6 hours', 'Capsule', '2022-01-02 00:00:00', '2022-01-02 00:00:00'),
('MED003', 'Lisinopril', 'An angiotensin-converting enzyme (ACE) inhibitor used to treat hypertension and heart failure.', '10 mg once daily', 'Tablet', '2022-01-03 00:00:00', '2022-01-03 00:00:00'),
('MED004', 'Metformin', 'An oral diabetes medication used to lower blood sugar levels.', '1000 mg twice daily', 'Tablet', '2022-01-04 00:00:00', '2022-01-04 00:00:00'),
('MED005', 'Simvastatin', 'A lipid-lowering medication used to lower cholesterol levels.', '20 mg once daily', 'Tablet', '2022-01-05 00:00:00', '2022-01-05 00:00:00'),
('MED006', 'Omeprazole', 'A proton-pump inhibitor used to reduce stomach acid production and treat acid reflux and ulcers.', '20 mg once daily', 'Capsule', '2022-01-06 00:00:00', '2022-01-06 00:00:00'),
('MED007', 'Citalopram', 'An antidepressant medication used to treat depression and anxiety disorders.', '20 mg once daily', 'Tablet', '2022-01-07 00:00:00', '2022-01-07 00:00:00'),
('MED008', 'Atorvastatin', 'A lipid-lowering medication used to lower cholesterol levels.', '40 mg once daily', 'Tablet', '2022-01-08 00:00:00', '2022-01-08 00:00:00'),
('MED009', 'Albuterol', 'A bronchodilator used to treat asthma and other respiratory conditions.', '2 puffs every 4-6 hours', 'Inhaler', '2022-01-09 00:00:00', '2022-01-09 00:00:00'),
('MED010', 'Prednisone', 'A corticosteroid medication used to treat inflammation and autoimmune conditions.', '10 mg once daily', 'Tablet', '2022-01-10 00:00:00', '2022-01-10 00:00:00'),
('MED011', 'Tramadol', 'A pain medication used to treat moderate to severe pain.', '50-100 mg every 4-6 hours', 'Tablet', '2022-01-11 00:00:00', '2022-01-11 00:00:00'),
('MED012', 'Warfarin', 'An anticoagulant medication used to prevent blood clots.', '5 mg once daily', 'Tablet', '2022-01-12 00:00:00', '2022-01-12 00:00:00'),
('MED013', 'Gabapentin', 'An anticonvulsant medication used to treat seizures and nerve pain.', '300 mg three times daily', 'Capsule', '2022-01-13 00:00:00', '2022-01-13 00:00:00'),
('MED014', 'Hydrocodone', 'A narcotic pain medication used to treat moderate to severe pain.', '5-10 mg every 4-6 hours', 'Tablet', '2022-01-14 00:00:00', '2022-01-14 00:00:00'),
('MED015', 'Amlodipine', 'A calcium channel blocker used to treat hypertension and angina.', '5 mg once daily', 'Tablet', '2022-01-15 00:00:00', '2022-01-15 00:00:00'),
('MED016', 'Lorazepam', 'An anti-anxiety medication used to treat anxiety disorders and insomnia.', '1-2 mg once daily', 'Tablet', '2022-01-16 00:00:00', '2022-01-16 00:00:00'),
('MED017', 'Cephalexin', 'An antibiotic medication used to treat bacterial infections.', '500 mg every 6-8 hours', 'Capsule', '2022-01-17 00:00:00', '2022-01-17 00:00:00'),
('MED018', 'Furosemide', 'A loop diuretic medication used to treat fluid retention and edema.', '20-40 mg once daily', 'Tablet', '2022-01-18 00:00:00', '2022-01-18 00:00:00'),
('MED019', 'Trazodone', 'An antidepressant medication used to treat depression and insomnia.', '50-100 mg once daily at bedtime', 'Tablet', '2022-01-19 00:00:00', '2022-01-19 00:00:00'),
('MED020', 'Methotrexate', 'An antimetabolite medication used to treat cancer, autoimmune diseases, and ectopic pregnancy.', '10-25 mg once weekly', 'Tablet', '2022-01-20 00:00:00', '2022-01-20 00:00:00'),
('MED021', 'Alprazolam', 'An anti-anxiety medication used to treat anxiety disorders and panic attacks.', '0.25-0.5 mg three times daily', 'Tablet', '2022-01-21 00:00:00', '2022-01-21 00:00:00'),
('MED022', 'Levothyroxine', 'A thyroid hormone medication used to treat hypothyroidism.', '50-100 mcg once daily', 'Tablet', '2022-01-22 00:00:00', '2022-01-21 00:00:00');

INSERT INTO user_types (id, name, type, description, created_date, updated_date)
VALUES 
  (1, 'Doctor', 'Staff', 'Profesional médico capacitado para brindar atención y tratamiento a pacientes', NOW(), NOW()),
  (2, 'Enfermera', 'Staff', 'Profesional capacitado para brindar atención y cuidados a pacientes', NOW(), NOW()),
  (3, 'Paciente', 'Patient', 'Individuo que busca atención médica y tratamiento en el centro médico', NOW(), NOW()),
  (4, 'Administrador', 'Staff', 'Persona encargada de la gestión y administración del centro médico', NOW(), NOW()),
  (5, 'Recepcionista', 'Staff', 'Persona encargada de recibir y atender a pacientes en la recepción del centro médico', NOW(), NOW());

INSERT INTO users_auth (user_id, username, password, email, user_type_id, created_date, updated_date)
VALUES 
  ('u00001', 'j.perez', 'password1', 'j.perez@example.com', 1, NOW(), NOW()),
  ('u00002', 'm.gonzalez', 'password2', 'm.gonzalez@example.com', 3, NOW(), NOW()),
  ('u00003', 'p.ramirez', 'password3', 'p.ramirez@example.com', 2, NOW(), NOW()),
  ('u00004', 'a.admin', 'password4', 'a.admin@example.com', 4, NOW(), NOW()),
  ('u00005', 'r.recepcion', 'password5', 'r.recepcion@example.com', 5, NOW(), NOW()),
  ('u00006', 'l.diaz', 'password5', 'l.diaz@example.com', 3, NOW(), NOW()),
  ('u00007', 'a.castro', 'password5', 'a.castro@example.com', 3, NOW(), NOW()),
  ('u00008', 'c.alvarez', 'password5', 'c.alvarez@example.com', 3, NOW(), NOW()),
  ('u00009', 'r.hernandez', 'password5', 'r.hernandezn@example.com', 3, NOW(), NOW()),
  ('u00010', 'i.torres', 'password5', 'i.torres@example.com', 3, NOW(), NOW());
  
INSERT INTO users 
	(user_id, name, lastname_one, lastname_two, genre, address, date_of_birth, contact, emergency_contact, blood_type, created_date, updated_date)
VALUES
  ('u00001', 'Juan', 'Pérez', 'García', 'Masculino', 'Calle 123, Ciudad', '1980-01-01', '555-1234', '555-5678', 'O+', '2021-03-08 09:00:00', '2021-03-08 09:00:00'),
  ('u00002', 'María', 'González', 'Hernández', 'Femenino', 'Avenida 456, Pueblo', '1985-02-15', '555-2345', '555-6789', 'A-', '2021-03-08 10:00:00', '2021-03-08 10:00:00'),
  ('u00003', 'Pedro', 'Ramírez', 'Sánchez', 'Masculino', 'Calle 789, Villa', '1990-03-31', '555-3456', '555-7890', 'B+', '2021-03-08 11:00:00', '2021-03-08 11:00:00'),
  ('u00004', 'Ana', 'Martínez', 'Jiménez', 'Femenino', 'Avenida 012, Colonia', '1987-04-25', '555-4567', '555-8901', 'AB+', '2021-03-08 12:00:00', '2021-03-08 12:00:00'),
  ('u00005', 'Jorge', 'Gómez', 'Gutiérrez', 'Masculino', 'Calle 345, Aldea', '1983-05-11', '555-5678', '555-9012', 'O-', '2021-03-08 13:00:00', '2021-03-08 13:00:00'),
  ('u00006', 'Luisa', 'Díaz', 'López', 'Femenino', 'Avenida 678, Ciudad', '1995-06-27', '555-6789', '555-0123', 'B-', '2021-03-08 14:00:00', '2021-03-08 14:00:00'),
  ('u00007', 'Alberto', 'Castro', 'Fernández', 'Masculino', 'Calle 901, Pueblo', '1981-07-13', '555-7890', '555-1234', 'O+', '2021-03-08 15:00:00', '2021-03-08 15:00:00'),
  ('u00008', 'Carmen', 'Álvarez', 'Cruz', 'Femenino', 'Avenida 234, Villa', '1992-08-29', '555-8901', '555-2345', 'AB-', '2021-03-08 16:00:00', '2021-03-08 16:00:00'),
  ('u00009', 'Raúl', 'Hernández', 'Ortiz', 'Masculino', 'Calle 567, Colonia', '1997-09-14', '555-9012', '555-3456', 'O-', '2021-03-08 17:00:00', '2021-03-08 17:00:00'),
  ('u00010', 'Isabel', 'Torres', 'Ruiz', 'Femenino', 'Avenida 890, Aldea', '1989-10-30', '555-0123', '555-4567', 'A+', '2021-03-08 18:00:00', '2021-03-08 18:00:00');

