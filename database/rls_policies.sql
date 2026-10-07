-- ============================================================
-- RLS POLICIES — Allow anon key full access to all tables
-- Run this in Supabase SQL Editor after creating the schema
-- ============================================================

-- Disable RLS on all tables (simplest approach for private dashboard)
ALTER TABLE cidades ENABLE ROW LEVEL SECURITY;
ALTER TABLE paises ENABLE ROW LEVEL SECURITY;
ALTER TABLE parceiros ENABLE ROW LEVEL SECURITY;
ALTER TABLE produtos_atividades ENABLE ROW LEVEL SECURITY;
ALTER TABLE produtos_packs ENABLE ROW LEVEL SECURITY;
ALTER TABLE produtos_alojamento ENABLE ROW LEVEL SECURITY;
ALTER TABLE produtos_transfers ENABLE ROW LEVEL SECURITY;
ALTER TABLE produtos_merch ENABLE ROW LEVEL SECURITY;
ALTER TABLE produtos_odv ENABLE ROW LEVEL SECURITY;
ALTER TABLE grupos ENABLE ROW LEVEL SECURITY;
ALTER TABLE vendas_atividades ENABLE ROW LEVEL SECURITY;
ALTER TABLE vendas_packs ENABLE ROW LEVEL SECURITY;
ALTER TABLE vendas_alojamento ENABLE ROW LEVEL SECURITY;
ALTER TABLE vendas_transfers ENABLE ROW LEVEL SECURITY;
ALTER TABLE vendas_merch ENABLE ROW LEVEL SECURITY;
ALTER TABLE vendas_odv ENABLE ROW LEVEL SECURITY;
ALTER TABLE compras_atividades ENABLE ROW LEVEL SECURITY;
ALTER TABLE compras_alojamento ENABLE ROW LEVEL SECURITY;
ALTER TABLE compras_transfers ENABLE ROW LEVEL SECURITY;
ALTER TABLE compras_merch ENABLE ROW LEVEL SECURITY;
ALTER TABLE compras_odv ENABLE ROW LEVEL SECURITY;
ALTER TABLE pagamentos_cliente ENABLE ROW LEVEL SECURITY;
ALTER TABLE reembolsos ENABLE ROW LEVEL SECURITY;
ALTER TABLE pagamentos_fornecedor ENABLE ROW LEVEL SECURITY;
ALTER TABLE reembolsos_fornecedor ENABLE ROW LEVEL SECURITY;
ALTER TABLE despesas ENABLE ROW LEVEL SECURITY;
ALTER TABLE despesas_fixas ENABLE ROW LEVEL SECURITY;
ALTER TABLE historico_cotacoes ENABLE ROW LEVEL SECURITY;
ALTER TABLE historico_cotacoes_hsp ENABLE ROW LEVEL SECURITY;
ALTER TABLE historico_propostas ENABLE ROW LEVEL SECURITY;
ALTER TABLE historico_orcamentos ENABLE ROW LEVEL SECURITY;
ALTER TABLE banco_imagens ENABLE ROW LEVEL SECURITY;
ALTER TABLE leads ENABLE ROW LEVEL SECURITY;
ALTER TABLE users ENABLE ROW LEVEL SECURITY;

-- Create permissive policies for anon role (SELECT, INSERT, UPDATE, DELETE)
DO $$
DECLARE
  t TEXT;
BEGIN
  FOR t IN
    SELECT unnest(ARRAY[
      'cidades','paises','parceiros',
      'produtos_atividades','produtos_packs','produtos_alojamento','produtos_transfers','produtos_merch','produtos_odv',
      'grupos',
      'vendas_atividades','vendas_packs','vendas_alojamento','vendas_transfers','vendas_merch','vendas_odv',
      'compras_atividades','compras_alojamento','compras_transfers','compras_merch','compras_odv',
      'pagamentos_cliente','reembolsos','pagamentos_fornecedor','reembolsos_fornecedor',
      'despesas','despesas_fixas',
      'historico_cotacoes','historico_cotacoes_hsp','historico_propostas','historico_orcamentos',
      'banco_imagens','leads','users'
    ])
  LOOP
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'allow_anon_select_' || t, t);
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'allow_anon_insert_' || t, t);
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'allow_anon_update_' || t, t);
    EXECUTE format('DROP POLICY IF EXISTS %I ON %I', 'allow_anon_delete_' || t, t);

    EXECUTE format('CREATE POLICY %I ON %I FOR SELECT TO anon USING (true)', 'allow_anon_select_' || t, t);
    EXECUTE format('CREATE POLICY %I ON %I FOR INSERT TO anon WITH CHECK (true)', 'allow_anon_insert_' || t, t);
    EXECUTE format('CREATE POLICY %I ON %I FOR UPDATE TO anon USING (true) WITH CHECK (true)', 'allow_anon_update_' || t, t);
    EXECUTE format('CREATE POLICY %I ON %I FOR DELETE TO anon USING (true)', 'allow_anon_delete_' || t, t);
  END LOOP;
END
$$;
