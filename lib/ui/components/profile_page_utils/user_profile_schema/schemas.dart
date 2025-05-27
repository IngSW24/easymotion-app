/*
===============================================================================
  SCHEMA ESTERNO
===============================================================================
*/

import '../field_descriptor.dart';

const personalSchema = <FieldDefinition>[
  FieldDefinition(key: 'firstName',   label: 'Nome',           type: FieldDataType.string),
  FieldDefinition(key: 'middleName',  label: 'Secondo nome',   type: FieldDataType.string),
  FieldDefinition(key: 'lastName',    label: 'Cognome',        type: FieldDataType.string),
  FieldDefinition(key: 'birthDate',   label: 'Data nascita',   type: FieldDataType.date),
  FieldDefinition(key: 'email',       label: 'Email',          type: FieldDataType.string),
  FieldDefinition(key: 'phoneNumber', label: 'Cellulare',      type: FieldDataType.string),
];

const healthSchema = <FieldDefinition>[
FieldDefinition(key: 'sex',                 label: 'Sesso',                                                 type: FieldDataType.string),
FieldDefinition(key: 'height',              label: 'Altezza',                                               type: FieldDataType.number, unit: 'cm', decimals: 0),
FieldDefinition(key: 'weight',              label: 'Peso',                                                  type: FieldDataType.number, unit: 'kg', decimals: 0),
FieldDefinition(key: 'profession',          label: 'Professione',                                           type: FieldDataType.string),
FieldDefinition(key: 'sport',               label: 'Sport',                                                 type: FieldDataType.string),
FieldDefinition(key: 'sportFrequency',      label: 'Frequenza Sport',                                       type: FieldDataType.number),
FieldDefinition(key: 'activityLevel',       label: 'Livello attività',                                      type: FieldDataType.string),
//FieldDefinition(key: 'smoker',              label: 'Fumatore',                                              type: FieldDataType.boolean),
FieldDefinition(key: 'alcoholUnits',        label: 'Alcol (u/sett.)',                                       type: FieldDataType.number, decimals: 0),
FieldDefinition(key: 'mobilityLevel',       label: 'Livello mobilità',                                      type: FieldDataType.string),
FieldDefinition(key: 'restingHeartRate',    label: 'Frequenza cardiaca a riposo',                           type: FieldDataType.number, unit: 'bpm', decimals: 0),
FieldDefinition(key: 'bloodPressure',       label: 'Pressione sanguignia',                                  type: FieldDataType.string),
FieldDefinition(key: 'medications',         label: 'Farmaci assunti',                                       type: FieldDataType.string),
FieldDefinition(key: 'allergies',           label: 'Allergie',                                              type: FieldDataType.string),
FieldDefinition(key: 'otherPathologies',    label: 'Patologie',                                             type: FieldDataType.string),
//FieldDefinition(key: 'painZone',            label: 'Zona dolore',                                           type: FieldDataType.string),
//FieldDefinition(key: 'painIntensity',       label: 'Intensità dolore (0-4)',                                type: FieldDataType.number, decimals: 0),
//FieldDefinition(key: 'painFrequency',       label: 'Frequenza dolore',                                      type: FieldDataType.string),
//FieldDefinition(key: 'painCharacteristics', label: 'Caratteristiche dolore',                                type: FieldDataType.string),
//FieldDefinition(key: 'painModifiers',       label: 'Aspetti che modificano la percezione del dolore',       type: FieldDataType.string),
FieldDefinition(key: 'sleepHours',          label: 'Sonno',                                                 type: FieldDataType.number, unit: 'h', decimals: 1),
FieldDefinition(key: 'perceivedStress',     label: 'Stress (0-10)',                                         type: FieldDataType.number, decimals: 0),
//FieldDefinition(key: 'lastMedicalCheckup',  label: 'Ultimo check-up',                                       type: FieldDataType.date),
FieldDefinition(key: 'personalGoals',       label: 'Obiettivi',                                             type: FieldDataType.string),
FieldDefinition(key: 'notes',               label: 'Note',                                                  type: FieldDataType.string),
];
