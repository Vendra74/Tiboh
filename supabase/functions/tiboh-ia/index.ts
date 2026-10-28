// Função do Supabase que leva a IA para o app no GitHub Pages.
// Só membros da Tiboh (tabela tiboh_membros) podem chamar; a chave da API da
// Anthropic fica no segredo ANTHROPIC_API_KEY do Supabase, nunca na página.
//
// Corpo: { prompt: string, tarefa: "pedido" | "fornada" }
// Resposta: { text, truncated } ou { code } em caso de erro.
import Anthropic from "npm:@anthropic-ai/sdk";
import { createClient } from "npm:@supabase/supabase-js@2";

const cors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};
const reply = (body: unknown, status = 200) =>
  new Response(JSON.stringify(body), { status, headers: { ...cors, "Content-Type": "application/json" } });

const anthropic = new Anthropic(); // lê ANTHROPIC_API_KEY

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: cors });
  if (req.method !== "POST") return reply({ code: "invalid_request" }, 405);

  // Checa a lista de membros com o login de quem chamou (o RLS decide).
  const sb = createClient(Deno.env.get("SUPABASE_URL")!, Deno.env.get("SUPABASE_ANON_KEY")!, {
    global: { headers: { Authorization: req.headers.get("Authorization") ?? "" } },
  });
  const { data: membro, error: membroErr } = await sb.rpc("tiboh_eh_membro");
  if (membroErr || membro !== true) return reply({ code: "not_granted" }, 403);

  let prompt: unknown, tarefa: unknown;
  try {
    ({ prompt, tarefa } = await req.json());
  } catch {
    return reply({ code: "invalid_request" }, 400);
  }
  if (typeof prompt !== "string" || !prompt.trim() || prompt.length > 60000) {
    return reply({ code: "invalid_request" }, 400);
  }

  try {
    const msg = await anthropic.beta.messages.create({
      model: "claude-opus-5-5",
      max_tokens: 16000,
      // Ler um pedido é simples; planejar a fornada pede um pouco mais de raciocínio.
      output_config: { effort: tarefa === "pedido" ? "low" : "medium" },
      betas: ["server-side-fallback-2026-07-01"],
      fallbacks: "default",
      messages: [{ role: "user", content: prompt }],
    });
    if (msg.stop_reason === "refusal") return reply({ code: "refused" }, 422);
    const text = msg.content.flatMap((b) => (b.type === "text" ? [b.text] : [])).join("");
    if (!text.trim()) return reply({ code: "empty_completion" }, 502);
    return reply({ text, truncated: msg.stop_reason === "max_tokens" });
  } catch (e) {
    if (e instanceof Anthropic.RateLimitError) return reply({ code: "rate_limited" }, 429);
    if (e instanceof Anthropic.AuthenticationError) {
      console.error("ANTHROPIC_API_KEY inválida ou ausente");
      return reply({ code: "not_granted" }, 503);
    }
    console.error(e);
    return reply({ code: "upstream_error" }, 502);
  }
});
