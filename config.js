// Configuração do banco (Supabase) para a versão do app no GitHub Pages.
// Pegue os dois valores em Supabase > Project Settings > API.
// A chave "anon" é pública por natureza: quem protege os pedidos é o login
// e a lista de e-mails em public.tiboh_membros (veja supabase/schema.sql).
window.TIBOH_CONFIG = {
  supabaseUrl: "https://shhpezrkvezalgsfdxgk.supabase.co",
  supabaseAnonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InNoaHBlenJrdmV6YWxnc2ZkeGdrIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTMyMTU1MzAsImV4cCI6MjEwODc5MTUzMH0.dlfVfn4TVkoGsSROGhaE161srNV6eHsTu49Os0dG7Lc",
};
