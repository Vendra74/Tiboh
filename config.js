// Configuração do banco (Supabase) para a versão do app no GitHub Pages.
// Pegue os dois valores em Supabase > Project Settings > API.
// A chave "anon" é pública por natureza: quem protege os pedidos é o login
// e a lista de e-mails em public.membros (veja supabase/schema.sql).
window.TIBOH_CONFIG = {
  supabaseUrl: "",
  supabaseAnonKey: "",
};
