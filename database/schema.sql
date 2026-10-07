-- ============================================================
-- AGÊNCIA DASHBOARD — Database Schema (PostgreSQL / Supabase)
-- HenStag Portugal (HSP) + Outlet das Viagens (ODV)
-- ============================================================
-- Versão: 2.0
-- Uma só base de dados, campo "marca" separa as duas marcas.
-- HSP usa tabelas por categoria (atividades, packs, alojamento, transfers, merch).
-- ODV usa tabelas genéricas (tipo + serviço).
-- ============================================================

-- ────────────────────────────────────────────────────────────
-- 0. LOOKUPS
-- ────────────────────────────────────────────────────────────

CREATE TABLE cidades (
  id   SERIAL PRIMARY KEY,
  nome TEXT NOT NULL UNIQUE
);

CREATE TABLE paises (
  id   SERIAL PRIMARY KEY,
  nome TEXT NOT NULL UNIQUE
);

-- ────────────────────────────────────────────────────────────
-- 1. PARCEIROS (Partners / Suppliers) — partilhado HSP + ODV
-- ────────────────────────────────────────────────────────────

CREATE TABLE parceiros (
  id                     SERIAL PRIMARY KEY,
  id_legado              INTEGER,              -- ID original do Sheet HSP (para migração)
  marca                  TEXT[] DEFAULT '{hsp}', -- '{hsp}', '{odv}', '{hsp,odv}'
  nome_empresa           TEXT NOT NULL,
  cidades                TEXT,
  categoria              TEXT,
  nome_responsavel       TEXT,
  email                  TEXT,
  email_2                TEXT,
  telemovel              TEXT,
  telemovel_2            TEXT,
  modalidade_reservas    TEXT,
  codigo_site            TEXT,
  modalidade_pagamento   TEXT,
  politica_cancelamento  TEXT,
  nome_fiscal            TEXT,
  iban                   TEXT,
  notas                  TEXT,
  ativo                  BOOLEAN DEFAULT TRUE,
  created_at             TIMESTAMPTZ DEFAULT NOW(),
  updated_at             TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_parceiros_cidade ON parceiros USING GIN (to_tsvector('simple', coalesce(cidades,'')));
CREATE INDEX idx_parceiros_categoria ON parceiros (categoria);
CREATE INDEX idx_parceiros_marca ON parceiros USING GIN (marca);

-- ────────────────────────────────────────────────────────────
-- 2. PRODUTOS — ATIVIDADES (HSP)
-- ────────────────────────────────────────────────────────────

CREATE TABLE produtos_atividades (
  id                    SERIAL PRIMARY KEY,
  produto_id_externo    TEXT,
  variante_id_externo   TEXT,
  cidade                TEXT NOT NULL,
  sku                   TEXT NOT NULL UNIQUE,
  nome                  TEXT NOT NULL,
  variante              TEXT,
  idiomas               TEXT,
  is_addon              BOOLEAN DEFAULT FALSE,
  categoria             TEXT,
  pvp_parceiro          NUMERIC(10,2),
  margem_fornecedor     NUMERIC(5,4),
  preco_compra          NUMERIC(10,2),
  iva_sobre_lucro       NUMERIC(10,2),
  pvp                   NUMERIC(10,2),
  margem_bruto_pct      NUMERIC(5,4),
  margem_bruto_eur      NUMERIC(10,2),
  horarios              TEXT,
  dias_semana           TEXT,
  min_qty               INTEGER DEFAULT 1,
  max_qty               INTEGER DEFAULT 99,
  localizacao           TEXT,
  distancia_cidade      TEXT,
  duracao               TEXT,
  dados_necessarios     TEXT,
  parceiro_id           INTEGER REFERENCES parceiros(id),
  notas                 TEXT,
  no_site               BOOLEAN DEFAULT FALSE,
  no_catalogo           BOOLEAN DEFAULT FALSE,
  comprar_na_hora       BOOLEAN DEFAULT FALSE,
  consentimento_imagens BOOLEAN DEFAULT FALSE,
  ativo                 BOOLEAN DEFAULT TRUE,
  created_at            TIMESTAMPTZ DEFAULT NOW(),
  updated_at            TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_prod_ativ_cidade ON produtos_atividades (cidade);
CREATE INDEX idx_prod_ativ_parceiro ON produtos_atividades (parceiro_id);
CREATE INDEX idx_prod_ativ_categoria ON produtos_atividades (categoria);

-- ────────────────────────────────────────────────────────────
-- 3. PRODUTOS — PACKS (HSP)
-- ────────────────────────────────────────────────────────────

CREATE TABLE produtos_packs (
  id                    SERIAL PRIMARY KEY,
  produto_id_externo    TEXT,
  variante_id_externo   TEXT,
  cidade                TEXT NOT NULL,
  sku                   TEXT NOT NULL UNIQUE,
  sku_produto_1         TEXT,
  sku_produto_2         TEXT,
  sku_produto_3         TEXT,
  nome                  TEXT NOT NULL,
  produto_1_nome        TEXT,
  produto_2_nome        TEXT,
  produto_3_nome        TEXT,
  soma_compra           NUMERIC(10,2),
  soma_pvp_individual   NUMERIC(10,2),
  pvp_pack              NUMERIC(10,2),
  margem_liquida_pct    NUMERIC(5,4),
  margem_liquida_eur    NUMERIC(10,2),
  horarios              TEXT,
  dias_semana           TEXT,
  min_participantes     INTEGER DEFAULT 1,
  max_participantes     INTEGER DEFAULT 99,
  step                  INTEGER DEFAULT 1,
  duracao               TEXT,
  fornecedor_1_id       INTEGER REFERENCES parceiros(id),
  fornecedor_2_id       INTEGER REFERENCES parceiros(id),
  fornecedor_3_id       INTEGER REFERENCES parceiros(id),
  pp_uni                TEXT,
  notas                 TEXT,
  comprar_na_hora       BOOLEAN DEFAULT FALSE,
  ativo                 BOOLEAN DEFAULT TRUE,
  created_at            TIMESTAMPTZ DEFAULT NOW(),
  updated_at            TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_prod_packs_cidade ON produtos_packs (cidade);

-- ────────────────────────────────────────────────────────────
-- 4. PRODUTOS — ALOJAMENTO (HSP)
-- ────────────────────────────────────────────────────────────

CREATE TABLE produtos_alojamento (
  id                    SERIAL PRIMARY KEY,
  produto_id_externo    TEXT,
  variante_id_externo   TEXT,
  cidade                TEXT NOT NULL,
  sku                   TEXT NOT NULL UNIQUE,
  nome                  TEXT NOT NULL,
  variante              TEXT,
  is_addon              BOOLEAN DEFAULT FALSE,
  checkin_modo          TEXT,
  categoria             TEXT,
  pequeno_almoco        TEXT,
  caucao                TEXT,
  preco_minimo          NUMERIC(10,2),
  preco_maximo          NUMERIC(10,2),
  taxa_turistica        TEXT,
  margem_fornecedor     NUMERIC(5,4),
  preco_compra_min      NUMERIC(10,2),
  preco_compra_max      NUMERIC(10,2),
  preco_venda           NUMERIC(10,2),
  margem_pct            NUMERIC(5,4),
  margem_eur            NUMERIC(10,2),
  hora_checkin          TEXT,
  hora_checkout         TEXT,
  min_qty               INTEGER DEFAULT 1,
  max_qty               INTEGER DEFAULT 99,
  localizacao           TEXT,
  distancia_cidade      TEXT,
  comprar_na_hora       BOOLEAN DEFAULT FALSE,
  parceiro_id           INTEGER REFERENCES parceiros(id),
  notas                 TEXT,
  ativo                 BOOLEAN DEFAULT TRUE,
  created_at            TIMESTAMPTZ DEFAULT NOW(),
  updated_at            TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_prod_aloj_cidade ON produtos_alojamento (cidade);
CREATE INDEX idx_prod_aloj_parceiro ON produtos_alojamento (parceiro_id);

-- ────────────────────────────────────────────────────────────
-- 5. PRODUTOS — TRANSFERS (HSP)
-- ────────────────────────────────────────────────────────────

CREATE TABLE produtos_transfers (
  id                    SERIAL PRIMARY KEY,
  produto_id_externo    TEXT,
  variante_id_externo   TEXT,
  cidade                TEXT NOT NULL,
  sku                   TEXT NOT NULL UNIQUE,
  nome                  TEXT NOT NULL,
  variante              TEXT,
  is_addon              BOOLEAN DEFAULT FALSE,
  categoria             TEXT,
  pvp_parceiro          NUMERIC(10,2),
  margem_fornecedor     NUMERIC(5,4),
  preco_compra          NUMERIC(10,2),
  iva_sobre_lucro       NUMERIC(10,2),
  pvp                   NUMERIC(10,2),
  margem_bruta_pct      NUMERIC(5,4),
  margem_bruta_eur      NUMERIC(10,2),
  min_participantes     INTEGER DEFAULT 1,
  max_participantes     INTEGER DEFAULT 99,
  comprar_na_hora       BOOLEAN DEFAULT FALSE,
  parceiro_id           INTEGER REFERENCES parceiros(id),
  notas                 TEXT,
  ativo                 BOOLEAN DEFAULT TRUE,
  created_at            TIMESTAMPTZ DEFAULT NOW(),
  updated_at            TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_prod_trans_cidade ON produtos_transfers (cidade);

-- ────────────────────────────────────────────────────────────
-- 6. PRODUTOS — MERCH (HSP)
-- ────────────────────────────────────────────────────────────

CREATE TABLE produtos_merch (
  id                    SERIAL PRIMARY KEY,
  produto_id_externo    TEXT,
  variante_id_externo   TEXT,
  sku                   TEXT NOT NULL UNIQUE,
  nome                  TEXT NOT NULL,
  variante              TEXT,
  pvp_parceiro          NUMERIC(10,2),
  preco_s_iva_parceiro  NUMERIC(10,2),
  margem_fornecedor     NUMERIC(5,4),
  preco_compra_s_iva    NUMERIC(10,2),
  preco_venda_s_iva     NUMERIC(10,2),
  pvp                   NUMERIC(10,2),
  margem_liquida_pct    NUMERIC(5,4),
  margem_liquida_eur    NUMERIC(10,2),
  min_qty               INTEGER DEFAULT 1,
  max_qty               INTEGER DEFAULT 99,
  info_legal            TEXT,
  parceiro_id           INTEGER REFERENCES parceiros(id),
  notas                 TEXT,
  no_site               BOOLEAN DEFAULT FALSE,
  no_catalogo           BOOLEAN DEFAULT FALSE,
  comprar_na_hora       BOOLEAN DEFAULT FALSE,
  consentimento_imagens BOOLEAN DEFAULT FALSE,
  ativo                 BOOLEAN DEFAULT TRUE,
  created_at            TIMESTAMPTZ DEFAULT NOW(),
  updated_at            TIMESTAMPTZ DEFAULT NOW()
);

-- ────────────────────────────────────────────────────────────
-- 7. PRODUTOS — GENÉRICO (ODV)
-- ────────────────────────────────────────────────────────────
-- ODV tem produtos simples: código + nome (pacotes de viagem)

CREATE TABLE produtos_odv (
  id                    SERIAL PRIMARY KEY,
  codigo                TEXT NOT NULL UNIQUE,    -- OTPK-1001, OTPK-1022
  nome                  TEXT NOT NULL,           -- "Pacote Oviedo - Alojamento + Ferry + Charter"
  cidade                TEXT,
  notas                 TEXT,
  ativo                 BOOLEAN DEFAULT TRUE,
  created_at            TIMESTAMPTZ DEFAULT NOW(),
  updated_at            TIMESTAMPTZ DEFAULT NOW()
);

-- ────────────────────────────────────────────────────────────
-- 8. GRUPOS (Reservas / Booking principal) — partilhado HSP + ODV
-- ────────────────────────────────────────────────────────────
-- Fluxo: Criar grupo → adicionar vendas → adicionar compras

CREATE TABLE grupos (
  id                    SERIAL PRIMARY KEY,
  marca                 TEXT NOT NULL DEFAULT 'hsp' CHECK (marca IN ('hsp', 'odv')),

  -- Identificação (substitui grupo_id + venda_id_site)
  referencia            TEXT NOT NULL,           -- #R1001, #OT1038, #W1006, etc.
  origem_venda          TEXT,                    -- 'Lead', 'Marketplace', 'Site', 'Direto', etc.

  -- Info do grupo
  tipo_grupo            TEXT CHECK (tipo_grupo IN ('feminino', 'masculino', 'misto', 'empresa', 'familia', 'outro')),
  data_reserva          DATE,
  pais_origem           TEXT,
  nr_participantes      INTEGER,
  data_inicio           DATE,                    -- HSP: data início | ODV: data IDA
  data_fim              DATE,                    -- HSP: data fim   | ODV: data VOLTA
  nome_cliente          TEXT NOT NULL,
  telemovel             TEXT,
  email                 TEXT,
  cidade                TEXT,
  confirmacao_parceiros TEXT,
  fatura                TEXT,
  fatura_nr             TEXT,
  info                  TEXT,
  estado_pagamento      TEXT DEFAULT 'Pendente' CHECK (estado_pagamento IN ('Pago', 'Parcial', 'Pendente', 'Aguarda Pagamento', 'Cancelado')),

  -- ODV-específico
  outlet_revendedor     TEXT,                    -- 'Outlet', 'Juliana', etc. (quem vendeu)
  fonte_lead            TEXT,                    -- 'Instagram', 'Whatsapp', 'Site', 'Pesssoal/Regional', etc.
  aeroporto_saida       TEXT,                    -- Aeroporto de partida (ex: 'OPO', 'LIS', 'FAO')
  check_in_voo          TEXT,                    -- 'N/A', 'Responsabilidade do Outlet', 'Feito'
  incluido              TEXT,                    -- O que está incluído no pacote
  desconto              NUMERIC(10,2),
  regime_venda          TEXT,                    -- PA, TI, MP, SA, NA (ODV) | Especial, Normal (HSP)
  pasta_faturas         TEXT,
  resumo_compras        TEXT,

  -- Financeiro — Totais
  total                 NUMERIC(10,2) DEFAULT 0,
  pago                  NUMERIC(10,2) DEFAULT 0,
  pago_pct              NUMERIC(5,2) DEFAULT 0,
  em_falta              NUMERIC(10,2) DEFAULT 0,
  proximo_pagamento     DATE,

  -- Regime Especial (serviços — HSP e ODV)
  total_sem_merch       NUMERIC(10,2) DEFAULT 0,
  custo_sem_merch       NUMERIC(10,2) DEFAULT 0,
  lucro_bruto_re        NUMERIC(10,2) DEFAULT 0,
  lucro_bruto_re_pct    NUMERIC(5,4) DEFAULT 0,
  iva_sobre_lucro_re    NUMERIC(10,2) DEFAULT 0,
  lucro_liquido_re      NUMERIC(10,2) DEFAULT 0,
  lucro_liquido_re_pct  NUMERIC(5,4) DEFAULT 0,

  -- Regime 23% (merch — só HSP por agora)
  merch_venda           NUMERIC(10,2) DEFAULT 0,
  custo_merch_c_iva     NUMERIC(10,2) DEFAULT 0,
  lucro_bruto_merch_pct NUMERIC(5,4) DEFAULT 0,
  custo_merch_s_iva     NUMERIC(10,2) DEFAULT 0,
  iva_merch_retido_venda  NUMERIC(10,2) DEFAULT 0,
  iva_merch_retido_compra NUMERIC(10,2) DEFAULT 0,
  iva_pagar_margem_23   NUMERIC(10,2) DEFAULT 0,
  lucro_liquido_merch   NUMERIC(10,2) DEFAULT 0,
  lucro_liquido_merch_pct NUMERIC(5,4) DEFAULT 0,

  -- Totais combinados
  lucro_liquido_total   NUMERIC(10,2) DEFAULT 0,
  lucro_liquido_total_pct NUMERIC(5,4) DEFAULT 0,

  -- Metadata
  trimestre             TEXT,
  mes_reserva           TEXT,
  mes_viagem_inicio     TEXT,
  mes_viagem_fim        TEXT,
  nr_faturas_em_falta   TEXT,
  faturas_em_falta      TEXT,
  notas                 TEXT,

  atualizado_em         TIMESTAMPTZ,
  atualizado_por        TEXT,
  created_at            TIMESTAMPTZ DEFAULT NOW(),
  updated_at            TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_grupos_marca ON grupos (marca);
CREATE INDEX idx_grupos_cidade ON grupos (cidade);
CREATE INDEX idx_grupos_estado ON grupos (estado_pagamento);
CREATE INDEX idx_grupos_data_reserva ON grupos (data_reserva DESC);
CREATE INDEX idx_grupos_data_inicio ON grupos (data_inicio);
CREATE INDEX idx_grupos_tipo_grupo ON grupos (tipo_grupo);
CREATE UNIQUE INDEX idx_grupos_referencia ON grupos (marca, referencia);

-- ────────────────────────────────────────────────────────────
-- 9. VENDAS HSP — Linhas de venda por categoria
-- ────────────────────────────────────────────────────────────

-- 9a. Vendas — Atividades (HSP)
CREATE TABLE vendas_atividades (
  id                    SERIAL PRIMARY KEY,
  grupo_id              INTEGER NOT NULL REFERENCES grupos(id) ON DELETE CASCADE,
  cidade                TEXT,
  parceiro_id           INTEGER REFERENCES parceiros(id),
  parceiro_nome         TEXT,
  produto_nome          TEXT,
  sku                   TEXT,
  pvp                   NUMERIC(10,2),
  quantidade            INTEGER DEFAULT 1,
  data_atividade        DATE,
  hora_atividade        TIME,
  confirmacao_parceiro  TEXT,
  total                 NUMERIC(10,2) DEFAULT 0,
  responsavel           TEXT,
  atualizado_em         TIMESTAMPTZ,
  atualizado_por        TEXT,
  created_at            TIMESTAMPTZ DEFAULT NOW(),
  updated_at            TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_venda_ativ_grupo ON vendas_atividades (grupo_id);

-- 9b. Vendas — Packs (HSP)
CREATE TABLE vendas_packs (
  id                    SERIAL PRIMARY KEY,
  grupo_id              INTEGER NOT NULL REFERENCES grupos(id) ON DELETE CASCADE,
  cidade                TEXT,
  produto_nome          TEXT,
  sku                   TEXT,
  pvp                   NUMERIC(10,2),
  quantidade            INTEGER DEFAULT 1,
  data_at1              DATE,
  hora_at1              TIME,
  data_at2              DATE,
  hora_at2              TIME,
  data_at3              DATE,
  hora_at3              TIME,
  confirmacao_parceiros TEXT,
  total                 NUMERIC(10,2) DEFAULT 0,
  responsavel           TEXT,
  parceiro_1_id         INTEGER REFERENCES parceiros(id),
  parceiro_2_id         INTEGER REFERENCES parceiros(id),
  parceiro_3_id         INTEGER REFERENCES parceiros(id),
  sku_at_1              TEXT,
  sku_at_2              TEXT,
  sku_at_3              TEXT,
  atualizado_em         TIMESTAMPTZ,
  atualizado_por        TEXT,
  created_at            TIMESTAMPTZ DEFAULT NOW(),
  updated_at            TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_venda_packs_grupo ON vendas_packs (grupo_id);

-- 9c. Vendas — Alojamento (HSP)
CREATE TABLE vendas_alojamento (
  id                    SERIAL PRIMARY KEY,
  grupo_id              INTEGER NOT NULL REFERENCES grupos(id) ON DELETE CASCADE,
  cidade                TEXT,
  parceiro_id           INTEGER REFERENCES parceiros(id),
  parceiro_nome         TEXT,
  produto_nome          TEXT,
  sku                   TEXT,
  pvp                   NUMERIC(10,2),
  quantidade            INTEGER DEFAULT 1,
  nr_pessoas            INTEGER,
  categoria             TEXT,
  pequeno_almoco        TEXT,
  taxa_turistica        NUMERIC(10,2),
  caucao                NUMERIC(10,2),
  data_checkin          DATE,
  data_checkout         DATE,
  confirmacao_parceiro  TEXT,
  total                 NUMERIC(10,2) DEFAULT 0,
  responsavel           TEXT,
  atualizado_em         TIMESTAMPTZ,
  atualizado_por        TEXT,
  created_at            TIMESTAMPTZ DEFAULT NOW(),
  updated_at            TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_venda_aloj_grupo ON vendas_alojamento (grupo_id);

-- 9d. Vendas — Transfers (HSP)
CREATE TABLE vendas_transfers (
  id                    SERIAL PRIMARY KEY,
  grupo_id              INTEGER NOT NULL REFERENCES grupos(id) ON DELETE CASCADE,
  cidade                TEXT,
  parceiro_id           INTEGER REFERENCES parceiros(id),
  parceiro_nome         TEXT,
  produto_nome          TEXT,
  sku                   TEXT,
  pvp                   NUMERIC(10,2),
  quantidade            INTEGER DEFAULT 1,
  nr_pessoas            INTEGER,
  data_inicio           DATE,
  hora_inicio           TIME,
  data_fim              DATE,
  hora_fim              TIME,
  percurso              TEXT,
  confirmacao_parceiro  TEXT,
  total                 NUMERIC(10,2) DEFAULT 0,
  responsavel           TEXT,
  atualizado_em         TIMESTAMPTZ,
  atualizado_por        TEXT,
  created_at            TIMESTAMPTZ DEFAULT NOW(),
  updated_at            TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_venda_trans_grupo ON vendas_transfers (grupo_id);

-- 9e. Vendas — Merch (HSP)
CREATE TABLE vendas_merch (
  id                    SERIAL PRIMARY KEY,
  grupo_id              INTEGER NOT NULL REFERENCES grupos(id) ON DELETE CASCADE,
  parceiro_id           INTEGER REFERENCES parceiros(id),
  parceiro_nome         TEXT,
  produto_nome          TEXT,
  sku                   TEXT,
  pvp                   NUMERIC(10,2),
  quantidade            INTEGER DEFAULT 1,
  data_entrega          DATE,
  local_entrega         TEXT,
  estado_envio_cliente  TEXT,
  estado_envio_parceiro TEXT,
  enviar_ate            DATE,
  total                 NUMERIC(10,2) DEFAULT 0,
  atualizado_em         TIMESTAMPTZ,
  atualizado_por        TEXT,
  created_at            TIMESTAMPTZ DEFAULT NOW(),
  updated_at            TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_venda_merch_grupo ON vendas_merch (grupo_id);

-- ────────────────────────────────────────────────────────────
-- 10. VENDAS ODV — Linhas de venda genéricas
-- ────────────────────────────────────────────────────────────
-- ODV não separa por categoria — usa um campo "tipo" (Alojamento, Charter, Voo, etc.)

CREATE TABLE vendas_odv (
  id                    SERIAL PRIMARY KEY,
  grupo_id              INTEGER NOT NULL REFERENCES grupos(id) ON DELETE CASCADE,
  cidade                TEXT,
  servico               TEXT,                    -- "Porto - Alojamento", "Sal - Charter"
  codigo_produto        TEXT,                    -- OTPK-1009
  detalhe               TEXT,
  quantidade            INTEGER DEFAULT 1,
  preco                 NUMERIC(10,2),
  desconto              NUMERIC(10,2),
  regime                TEXT,                    -- PA, TI, MP, SA, NA
  confirmacao           TEXT,
  total                 NUMERIC(10,2) DEFAULT 0,
  atualizado_em         TIMESTAMPTZ,
  atualizado_por        TEXT,
  created_at            TIMESTAMPTZ DEFAULT NOW(),
  updated_at            TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_venda_odv_grupo ON vendas_odv (grupo_id);

-- ────────────────────────────────────────────────────────────
-- 11. COMPRAS HSP — Linhas de compra por categoria
-- ────────────────────────────────────────────────────────────

-- 11a. Compras — Atividades (HSP)
CREATE TABLE compras_atividades (
  id                    SERIAL PRIMARY KEY,
  grupo_id              INTEGER NOT NULL REFERENCES grupos(id) ON DELETE CASCADE,
  cidade                TEXT,
  parceiro_id           INTEGER REFERENCES parceiros(id),
  parceiro_nome         TEXT,
  produto_nome          TEXT,
  sku                   TEXT,
  preco_compra          NUMERIC(10,2),
  quantidade            INTEGER DEFAULT 1,
  data_atividade        DATE,
  hora_atividade        TIME,
  estado_reserva        TEXT DEFAULT 'Pendente' CHECK (estado_reserva IN ('Confirmado', 'Pendente', 'Cancelado')),
  total                 NUMERIC(10,2) DEFAULT 0,
  pago                  NUMERIC(10,2) DEFAULT 0,
  em_falta              NUMERIC(10,2) DEFAULT 0,
  pagar_ate             DATE,
  data_pagamento        DATE,
  tem_fatura            BOOLEAN DEFAULT FALSE,
  metodo_pagamento      TEXT,
  responsavel           TEXT,
  atualizado_em         TIMESTAMPTZ,
  atualizado_por        TEXT,
  created_at            TIMESTAMPTZ DEFAULT NOW(),
  updated_at            TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_compra_ativ_grupo ON compras_atividades (grupo_id);
CREATE INDEX idx_compra_ativ_parceiro ON compras_atividades (parceiro_id);
CREATE INDEX idx_compra_ativ_data ON compras_atividades (data_atividade);

-- 11b. Compras — Alojamento (HSP)
CREATE TABLE compras_alojamento (
  id                    SERIAL PRIMARY KEY,
  grupo_id              INTEGER NOT NULL REFERENCES grupos(id) ON DELETE CASCADE,
  cidade                TEXT,
  parceiro_id           INTEGER REFERENCES parceiros(id),
  parceiro_nome         TEXT,
  produto_nome          TEXT,
  sku                   TEXT,
  preco_compra          NUMERIC(10,2),
  quantidade            INTEGER DEFAULT 1,
  nr_pessoas            INTEGER,
  categoria             TEXT,
  pequeno_almoco        TEXT,
  taxa_turistica        NUMERIC(10,2) DEFAULT 0,
  caucao                NUMERIC(10,2) DEFAULT 0,
  data_checkin          DATE,
  data_checkout         DATE,
  estado_reserva        TEXT DEFAULT 'Pendente' CHECK (estado_reserva IN ('Confirmado', 'Pendente', 'Cancelado')),
  total                 NUMERIC(10,2) DEFAULT 0,
  pago                  NUMERIC(10,2) DEFAULT 0,
  em_falta              NUMERIC(10,2) DEFAULT 0,
  pagar_ate             DATE,
  data_pagamento        DATE,
  tem_fatura            BOOLEAN DEFAULT FALSE,
  metodo_pagamento      TEXT,
  responsavel           TEXT,
  atualizado_em         TIMESTAMPTZ,
  atualizado_por        TEXT,
  created_at            TIMESTAMPTZ DEFAULT NOW(),
  updated_at            TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_compra_aloj_grupo ON compras_alojamento (grupo_id);

-- 11c. Compras — Transfers (HSP)
CREATE TABLE compras_transfers (
  id                    SERIAL PRIMARY KEY,
  grupo_id              INTEGER NOT NULL REFERENCES grupos(id) ON DELETE CASCADE,
  cidade                TEXT,
  parceiro_id           INTEGER REFERENCES parceiros(id),
  parceiro_nome         TEXT,
  produto_nome          TEXT,
  sku                   TEXT,
  preco_compra          NUMERIC(10,2),
  quantidade            INTEGER DEFAULT 1,
  nr_pessoas            INTEGER,
  data_inicio           DATE,
  hora_inicio           TIME,
  data_fim              DATE,
  hora_fim              TIME,
  percurso              TEXT,
  estado_reserva        TEXT DEFAULT 'Pendente' CHECK (estado_reserva IN ('Confirmado', 'Pendente', 'Cancelado')),
  total                 NUMERIC(10,2) DEFAULT 0,
  pago                  NUMERIC(10,2) DEFAULT 0,
  em_falta              NUMERIC(10,2) DEFAULT 0,
  pagar_ate             DATE,
  data_pagamento        DATE,
  tem_fatura            BOOLEAN DEFAULT FALSE,
  metodo_pagamento      TEXT,
  responsavel           TEXT,
  atualizado_em         TIMESTAMPTZ,
  atualizado_por        TEXT,
  created_at            TIMESTAMPTZ DEFAULT NOW(),
  updated_at            TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_compra_trans_grupo ON compras_transfers (grupo_id);

-- 11d. Compras — Merch (HSP)
CREATE TABLE compras_merch (
  id                    SERIAL PRIMARY KEY,
  grupo_id              INTEGER NOT NULL REFERENCES grupos(id) ON DELETE CASCADE,
  parceiro_id           INTEGER REFERENCES parceiros(id),
  parceiro_nome         TEXT,
  produto_nome          TEXT,
  sku                   TEXT,
  preco_unitario        NUMERIC(10,2),
  quantidade            INTEGER DEFAULT 1,
  chega_ate             DATE,
  estado_encomenda      TEXT,
  taxa_iva              NUMERIC(5,4) DEFAULT 0.23,
  total_c_iva           NUMERIC(10,2) DEFAULT 0,
  pago                  NUMERIC(10,2) DEFAULT 0,
  em_falta              NUMERIC(10,2) DEFAULT 0,
  pagar_ate             DATE,
  data_pagamento        DATE,
  tem_fatura            BOOLEAN DEFAULT FALSE,
  metodo_pagamento      TEXT,
  responsavel           TEXT,
  atualizado_em         TIMESTAMPTZ,
  atualizado_por        TEXT,
  created_at            TIMESTAMPTZ DEFAULT NOW(),
  updated_at            TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_compra_merch_grupo ON compras_merch (grupo_id);

-- ────────────────────────────────────────────────────────────
-- 12. COMPRAS ODV — Linhas de compra genéricas
-- ────────────────────────────────────────────────────────────

CREATE TABLE compras_odv (
  id                    SERIAL PRIMARY KEY,
  grupo_id              INTEGER NOT NULL REFERENCES grupos(id) ON DELETE CASCADE,
  cidade                TEXT,
  parceiro_id           INTEGER REFERENCES parceiros(id),
  parceiro_nome         TEXT,
  tipo                  TEXT,                    -- Alojamento, Charter, Seguro, Voo, Ferry, Transferes, Carro, Outros
  servico               TEXT,                    -- nome do serviço específico
  quantidade            INTEGER DEFAULT 1,
  preco                 NUMERIC(10,2),
  nr_pessoas            INTEGER,
  regime                TEXT,                    -- PA, TI, MP, SA, NA
  total                 NUMERIC(10,2) DEFAULT 0,
  pago                  NUMERIC(10,2) DEFAULT 0,
  em_falta              NUMERIC(10,2) DEFAULT 0,
  pagar_ate             DATE,
  data_pagamento        DATE,
  confirmacao_parceiro  TEXT,
  tem_fatura            TEXT,                    -- 'Sim', 'Nao', 'Em Espera'
  metodo_pagamento      TEXT,
  responsavel           TEXT,
  atualizado_em         TIMESTAMPTZ,
  atualizado_por        TEXT,
  created_at            TIMESTAMPTZ DEFAULT NOW(),
  updated_at            TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_compra_odv_grupo ON compras_odv (grupo_id);
CREATE INDEX idx_compra_odv_parceiro ON compras_odv (parceiro_id);

-- ────────────────────────────────────────────────────────────
-- 13. PAGAMENTOS DE CLIENTES — partilhado HSP + ODV
-- ────────────────────────────────────────────────────────────

CREATE TABLE pagamentos_cliente (
  id                    SERIAL PRIMARY KEY,
  grupo_id              INTEGER NOT NULL REFERENCES grupos(id) ON DELETE CASCADE,
  valor                 NUMERIC(10,2) NOT NULL,
  forma_pagamento       TEXT,
  codigo_venda_site     TEXT,
  data_pagamento        DATE,
  tem_fatura            BOOLEAN DEFAULT FALSE,
  regime                TEXT,
  fatura_nr             TEXT,
  atualizado_em         TIMESTAMPTZ,
  atualizado_por        TEXT,
  created_at            TIMESTAMPTZ DEFAULT NOW(),
  updated_at            TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_pag_cliente_grupo ON pagamentos_cliente (grupo_id);
CREATE INDEX idx_pag_cliente_data ON pagamentos_cliente (data_pagamento DESC);

-- ────────────────────────────────────────────────────────────
-- 14. REEMBOLSOS A CLIENTES — partilhado HSP + ODV
-- ────────────────────────────────────────────────────────────

CREATE TABLE reembolsos (
  id                    SERIAL PRIMARY KEY,
  grupo_id              INTEGER NOT NULL REFERENCES grupos(id) ON DELETE CASCADE,
  valor                 NUMERIC(10,2) NOT NULL,
  forma_reembolso       TEXT,
  codigo_reembolso_site TEXT,
  data_reembolso        DATE,
  regime                TEXT,
  faturado              BOOLEAN DEFAULT FALSE,
  fatura_nr             TEXT,
  atualizado_em         TIMESTAMPTZ,
  atualizado_por        TEXT,
  created_at            TIMESTAMPTZ DEFAULT NOW(),
  updated_at            TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_reembolsos_grupo ON reembolsos (grupo_id);

-- ────────────────────────────────────────────────────────────
-- 15. PAGAMENTOS A FORNECEDORES — partilhado HSP + ODV
-- ────────────────────────────────────────────────────────────
-- ODV já trackeia isto separadamente dos dados de compra

CREATE TABLE pagamentos_fornecedor (
  id                    SERIAL PRIMARY KEY,
  parceiro_id           INTEGER REFERENCES parceiros(id),
  parceiro_nome         TEXT,
  grupo_id              INTEGER REFERENCES grupos(id),
  valor                 NUMERIC(10,2) NOT NULL,
  forma_pagamento       TEXT,
  data_pagamento        DATE,
  notas                 TEXT,
  created_at            TIMESTAMPTZ DEFAULT NOW(),
  updated_at            TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_pag_forn_parceiro ON pagamentos_fornecedor (parceiro_id);
CREATE INDEX idx_pag_forn_grupo ON pagamentos_fornecedor (grupo_id);

-- ────────────────────────────────────────────────────────────
-- 16. REEMBOLSOS DE FORNECEDORES — partilhado HSP + ODV
-- ────────────────────────────────────────────────────────────

CREATE TABLE reembolsos_fornecedor (
  id                    SERIAL PRIMARY KEY,
  parceiro_id           INTEGER REFERENCES parceiros(id),
  parceiro_nome         TEXT,
  grupo_id              INTEGER REFERENCES grupos(id),
  valor                 NUMERIC(10,2) NOT NULL,
  forma_pagamento       TEXT,
  data_reembolso        DATE,
  notas                 TEXT,
  created_at            TIMESTAMPTZ DEFAULT NOW(),
  updated_at            TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_reemb_forn_parceiro ON reembolsos_fornecedor (parceiro_id);

-- ────────────────────────────────────────────────────────────
-- 17. DESPESAS DA EMPRESA
-- ────────────────────────────────────────────────────────────

CREATE TABLE despesas (
  id                    SERIAL PRIMARY KEY,
  marca                 TEXT CHECK (marca IN ('hsp', 'odv', 'geral')),
  tipo                  TEXT NOT NULL CHECK (tipo IN ('variavel', 'fixa')),
  categoria             TEXT,
  descricao             TEXT NOT NULL,
  valor                 NUMERIC(10,2) NOT NULL,
  data_despesa          DATE,
  data_pagamento        DATE,
  recorrente            BOOLEAN DEFAULT FALSE,
  periodicidade         TEXT,
  notas                 TEXT,
  created_at            TIMESTAMPTZ DEFAULT NOW(),
  updated_at            TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_despesas_data ON despesas (data_despesa DESC);
CREATE INDEX idx_despesas_marca ON despesas (marca);

-- ────────────────────────────────────────────────────────────
-- 18. LEADS (Pipeline de vendas)
-- ────────────────────────────────────────────────────────────

CREATE TABLE leads (
  id                    SERIAL PRIMARY KEY,
  marca                 TEXT NOT NULL CHECK (marca IN ('hsp', 'odv')),
  nome                  TEXT NOT NULL,
  email                 TEXT,
  telemovel             TEXT,
  pais                  TEXT,
  cidade_destino        TEXT,
  nr_pessoas            INTEGER,
  data_viagem           DATE,
  origem                TEXT,
  estado                TEXT DEFAULT 'Novo' CHECK (estado IN ('Novo', 'Contactado', 'Orçamento Enviado', 'Negociação', 'Convertido', 'Perdido')),
  valor_estimado        NUMERIC(10,2),
  notas                 TEXT,
  responsavel           TEXT,
  grupo_id              INTEGER REFERENCES grupos(id),
  created_at            TIMESTAMPTZ DEFAULT NOW(),
  updated_at            TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX idx_leads_marca ON leads (marca);
CREATE INDEX idx_leads_estado ON leads (estado);

-- ────────────────────────────────────────────────────────────
-- 19. USERS (autenticação e audit trail)
-- ────────────────────────────────────────────────────────────

CREATE TABLE users (
  id                    SERIAL PRIMARY KEY,
  email                 TEXT NOT NULL UNIQUE,
  nome                  TEXT,
  role                  TEXT DEFAULT 'user' CHECK (role IN ('admin', 'user', 'viewer')),
  ativo                 BOOLEAN DEFAULT TRUE,
  created_at            TIMESTAMPTZ DEFAULT NOW()
);

-- ────────────────────────────────────────────────────────────
-- 20. VIEWS — Dados calculados
-- ────────────────────────────────────────────────────────────

-- Vista: Dívidas a parceiros — HSP (categorias separadas)
CREATE OR REPLACE VIEW v_divida_parceiros_hsp AS
SELECT
  p.id AS parceiro_id, p.nome_empresa AS parceiro,
  g.referencia, g.marca, 'atividade' AS tipo_compra,
  c.total AS valor_total, c.pago, c.em_falta, c.pagar_ate
FROM compras_atividades c
JOIN grupos g ON g.id = c.grupo_id
JOIN parceiros p ON p.id = c.parceiro_id
WHERE c.em_falta != 0

UNION ALL

SELECT p.id, p.nome_empresa, g.referencia, g.marca, 'alojamento',
  c.total, c.pago, c.em_falta, c.pagar_ate
FROM compras_alojamento c
JOIN grupos g ON g.id = c.grupo_id
JOIN parceiros p ON p.id = c.parceiro_id
WHERE c.em_falta != 0

UNION ALL

SELECT p.id, p.nome_empresa, g.referencia, g.marca, 'transfer',
  c.total, c.pago, c.em_falta, c.pagar_ate
FROM compras_transfers c
JOIN grupos g ON g.id = c.grupo_id
JOIN parceiros p ON p.id = c.parceiro_id
WHERE c.em_falta != 0

UNION ALL

SELECT p.id, p.nome_empresa, g.referencia, g.marca, 'merch',
  c.total_c_iva, c.pago, c.em_falta, c.pagar_ate
FROM compras_merch c
JOIN grupos g ON g.id = c.grupo_id
JOIN parceiros p ON p.id = c.parceiro_id
WHERE c.em_falta != 0;

-- Vista: Dívidas a parceiros — ODV (tabela genérica)
CREATE OR REPLACE VIEW v_divida_parceiros_odv AS
SELECT
  c.parceiro_id, c.parceiro_nome AS parceiro,
  g.referencia, g.marca, c.tipo AS tipo_compra,
  c.total AS valor_total, c.pago, c.em_falta, c.pagar_ate
FROM compras_odv c
JOIN grupos g ON g.id = c.grupo_id
WHERE c.em_falta != 0;

-- Vista: Todas as dívidas a parceiros (HSP + ODV)
CREATE OR REPLACE VIEW v_divida_parceiros AS
SELECT * FROM v_divida_parceiros_hsp
UNION ALL
SELECT * FROM v_divida_parceiros_odv
ORDER BY pagar_ate ASC NULLS LAST;

-- Vista: Próximos pagamentos a receber (clientes)
CREATE OR REPLACE VIEW v_proximos_pagamentos AS
SELECT
  g.id, g.referencia, g.marca, g.nome_cliente,
  g.total, g.pago, g.em_falta, g.proximo_pagamento
FROM grupos g
WHERE g.em_falta > 0
  AND g.estado_pagamento != 'Cancelado'
ORDER BY g.proximo_pagamento ASC NULLS LAST;

-- Vista: Próximos eventos HSP
CREATE OR REPLACE VIEW v_proximos_eventos AS
SELECT
  g.referencia, g.nome_cliente, g.cidade, g.marca,
  'atividade' AS tipo, va.produto_nome,
  va.data_atividade AS data_evento, va.hora_atividade AS hora_evento,
  va.parceiro_nome, va.confirmacao_parceiro
FROM vendas_atividades va
JOIN grupos g ON g.id = va.grupo_id
WHERE va.data_atividade >= CURRENT_DATE

UNION ALL

SELECT g.referencia, g.nome_cliente, g.cidade, g.marca,
  'alojamento', va.produto_nome, va.data_checkin, NULL,
  va.parceiro_nome, va.confirmacao_parceiro
FROM vendas_alojamento va
JOIN grupos g ON g.id = va.grupo_id
WHERE va.data_checkin >= CURRENT_DATE

UNION ALL

SELECT g.referencia, g.nome_cliente, g.cidade, g.marca,
  'transfer', vt.produto_nome, vt.data_inicio, vt.hora_inicio,
  vt.parceiro_nome, vt.confirmacao_parceiro
FROM vendas_transfers vt
JOIN grupos g ON g.id = vt.grupo_id
WHERE vt.data_inicio >= CURRENT_DATE

ORDER BY data_evento ASC, hora_evento ASC NULLS LAST;

-- Vista: Próximas viagens ODV
CREATE OR REPLACE VIEW v_proximas_viagens_odv AS
SELECT
  g.referencia, g.nome_cliente, g.cidade, g.marca,
  g.data_inicio, g.data_fim,
  g.check_in_voo, g.estado_pagamento, g.info
FROM grupos g
WHERE g.marca = 'odv'
  AND g.data_inicio >= CURRENT_DATE
ORDER BY g.data_inicio ASC;

-- Vista: Resumo financeiro por mês
CREATE OR REPLACE VIEW v_resumo_mensal AS
SELECT
  marca,
  DATE_TRUNC('month', data_reserva) AS mes,
  COUNT(*) AS nr_grupos,
  SUM(total) AS faturado,
  SUM(lucro_bruto_re) AS lucro_bruto,
  SUM(lucro_liquido_total) AS lucro_liquido,
  SUM(em_falta) AS por_receber,
  ROUND(AVG(lucro_liquido_total_pct) * 100, 1) AS margem_media_pct
FROM grupos
WHERE data_reserva IS NOT NULL
  AND estado_pagamento != 'Cancelado'
GROUP BY marca, DATE_TRUNC('month', data_reserva)
ORDER BY mes DESC;

-- Vista: Faturas em falta nas compras
CREATE OR REPLACE VIEW v_faturas_em_falta AS
SELECT g.referencia, g.marca, ca.cidade, ca.parceiro_nome,
  ca.produto_nome, ca.sku, 'atividade' AS tipo
FROM compras_atividades ca
JOIN grupos g ON g.id = ca.grupo_id
WHERE ca.tem_fatura = FALSE AND ca.total > 0

UNION ALL

SELECT g.referencia, g.marca, ca.cidade, ca.parceiro_nome,
  ca.produto_nome, ca.sku, 'alojamento'
FROM compras_alojamento ca
JOIN grupos g ON g.id = ca.grupo_id
WHERE ca.tem_fatura = FALSE AND ca.total > 0

UNION ALL

SELECT g.referencia, g.marca, NULL, cm.parceiro_nome,
  cm.produto_nome, cm.sku, 'merch'
FROM compras_merch cm
JOIN grupos g ON g.id = cm.grupo_id
WHERE cm.tem_fatura = FALSE AND cm.total_c_iva > 0;

-- ────────────────────────────────────────────────────────────
-- 21. FUNÇÕES — Auto-update de timestamps
-- ────────────────────────────────────────────────────────────

CREATE OR REPLACE FUNCTION set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DO $$
DECLARE
  t TEXT;
BEGIN
  FOR t IN
    SELECT table_name FROM information_schema.columns
    WHERE column_name = 'updated_at'
      AND table_schema = 'public'
    GROUP BY table_name
  LOOP
    EXECUTE format(
      'CREATE TRIGGER trg_%s_updated_at BEFORE UPDATE ON %I FOR EACH ROW EXECUTE FUNCTION set_updated_at()',
      t, t
    );
  END LOOP;
END;
$$;
