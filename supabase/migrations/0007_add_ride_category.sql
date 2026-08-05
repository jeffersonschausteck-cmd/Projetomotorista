-- Fase 3: a categoria da corrida (ex: "UberX", "99 Comfort") é texto livre —
-- varia demais entre plataformas para virar enum, e é um dos campos que o
-- OCR consegue extrair da tela da oferta.
alter table rides add column category text;
