-- Fix HSP dívidas data gaps
-- 1. HenStagPortugal (Stock) is not a current debt — mark as paid
UPDATE compras_merch
SET pago = 29.2, em_falta = 0
WHERE id = 10 AND parceiro_nome = 'HenStagPortugal (Stock)';

-- 2. Living Tuk Tuk #1034 — missing compras entry (exists in Google Sheets Divida_Parceiros)
INSERT INTO compras_atividades (grupo_id, parceiro_id, parceiro_nome, total, pago, em_falta, produto_nome, quantidade, preco_compra)
VALUES (1, 113, 'Living Tuk Tuk', 326.40, 0, 326.40, 'Tuk Tuk Tour', 1, 326.40);
