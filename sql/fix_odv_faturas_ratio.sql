-- Fix ODV contabilidade: populate nr_faturas_em_falta from Google Sheets data
-- compras_odv.tem_fatura is NULL for all rows (not migrated), so the dashboard
-- cannot compute fatura ratios. These values come from the Google Sheets Vendas
-- column AP (FaturasRatio) which is formula-computed from the Compras sheet.
-- Only incomplete ratios are listed (where received < total).

UPDATE grupos SET nr_faturas_em_falta = '1/2' WHERE referencia = '#R1008' AND marca = 'odv';
UPDATE grupos SET nr_faturas_em_falta = '0/1' WHERE referencia = '#R1032' AND marca = 'odv';
UPDATE grupos SET nr_faturas_em_falta = '3/4' WHERE referencia = '#R1047' AND marca = 'odv';
UPDATE grupos SET nr_faturas_em_falta = '1/2' WHERE referencia = '#R1058-OT' AND marca = 'odv';
UPDATE grupos SET nr_faturas_em_falta = '2/5' WHERE referencia = '#R1051-OT' AND marca = 'odv';
UPDATE grupos SET nr_faturas_em_falta = '1/2' WHERE referencia = '#P1002-OT' AND marca = 'odv';
UPDATE grupos SET nr_faturas_em_falta = '2/3' WHERE referencia = '#R1010-OT' AND marca = 'odv';
UPDATE grupos SET nr_faturas_em_falta = '1/3' WHERE referencia = '#OT1009' AND marca = 'odv';
UPDATE grupos SET nr_faturas_em_falta = '0/2' WHERE referencia = '#W1024-OT' AND marca = 'odv';
UPDATE grupos SET nr_faturas_em_falta = '0/1' WHERE referencia = '#OT1025' AND marca = 'odv';
UPDATE grupos SET nr_faturas_em_falta = '0/1' WHERE referencia = '#OT1030' AND marca = 'odv';
UPDATE grupos SET nr_faturas_em_falta = '0/1' WHERE referencia = '#OT1031' AND marca = 'odv';
UPDATE grupos SET nr_faturas_em_falta = '1/4' WHERE referencia = '#R1040-OT' AND marca = 'odv';
UPDATE grupos SET nr_faturas_em_falta = '0/1' WHERE referencia = '#OT1088' AND marca = 'odv';
UPDATE grupos SET nr_faturas_em_falta = '1/5' WHERE referencia = '#OT1016-R' AND marca = 'odv';
UPDATE grupos SET nr_faturas_em_falta = '2/3' WHERE referencia = '#OT1103' AND marca = 'odv';
UPDATE grupos SET nr_faturas_em_falta = '3/4' WHERE referencia = '#OT1100' AND marca = 'odv';
UPDATE grupos SET nr_faturas_em_falta = '2/4' WHERE referencia = '#OT1017' AND marca = 'odv';
UPDATE grupos SET nr_faturas_em_falta = '3/4' WHERE referencia = '#OT1106' AND marca = 'odv';
UPDATE grupos SET nr_faturas_em_falta = '1/5' WHERE referencia = '#OT1096' AND marca = 'odv';
UPDATE grupos SET nr_faturas_em_falta = '0/1' WHERE referencia = '#OT1153' AND marca = 'odv';
UPDATE grupos SET nr_faturas_em_falta = '3/4' WHERE referencia = '#OT1154' AND marca = 'odv';
UPDATE grupos SET nr_faturas_em_falta = '0/2' WHERE referencia = '#OT1150' AND marca = 'odv';
UPDATE grupos SET nr_faturas_em_falta = '0/1' WHERE referencia = '#OT1019' AND marca = 'odv';
UPDATE grupos SET nr_faturas_em_falta = '1/5' WHERE referencia = '#OT1163' AND marca = 'odv';
UPDATE grupos SET nr_faturas_em_falta = '1/4' WHERE referencia = '#OT1174' AND marca = 'odv';
UPDATE grupos SET nr_faturas_em_falta = '1/2' WHERE referencia = '#OT1213' AND marca = 'odv';
UPDATE grupos SET nr_faturas_em_falta = '0/5' WHERE referencia = '#OT1215' AND marca = 'odv';
UPDATE grupos SET nr_faturas_em_falta = '1/3' WHERE referencia = '#OT1218' AND marca = 'odv';
UPDATE grupos SET nr_faturas_em_falta = '1/5' WHERE referencia = '#OT1162' AND marca = 'odv';
UPDATE grupos SET nr_faturas_em_falta = '2/3' WHERE referencia = '#OT1236' AND marca = 'odv';
UPDATE grupos SET nr_faturas_em_falta = '2/4' WHERE referencia = '#OT1217' AND marca = 'odv';
UPDATE grupos SET nr_faturas_em_falta = '0/1' WHERE referencia = '#OT1252' AND marca = 'odv';
UPDATE grupos SET nr_faturas_em_falta = '1/5' WHERE referencia = '#OT1247' AND marca = 'odv';
UPDATE grupos SET nr_faturas_em_falta = '1/3' WHERE referencia = '#OT1253' AND marca = 'odv';
