# Tiboh

Ferramentas de gestão da **Tiboh cookies** ([@tiboh.oh](https://www.instagram.com/tiboh.oh/), Belo Horizonte): pedidos, estoque e demanda.

## App de pedidos (`app/index.html`)

App web pensado para o celular. O mesmo código roda em dois lugares:

- **GitHub Pages:** https://vendra74.github.io/Tiboh/ (dados no Supabase, entrada com código por e-mail, IA pela função `tiboh-ia` do Supabase).
- **Artifact do Claude:** https://claude.ai/artifact/88ZAUmUAaJQziMByMg9AXM (dados no banco do Artifact, IA pelo plano Claude de quem usa).

- **Pedidos:** kanban com duas colunas, *Em aberto* e *Vendidos*. Cada card é um pedido com data, nome, telefone, canal, quantidade de cada sabor, caixas e valor.
- **Valor automático:** cookie avulso R$ 15 e caixa com 4 R$ 55. Dá para mudar o valor em cada pedido.
- **IA no pedido:** cole a mensagem do WhatsApp e a IA preenche o card.
- **Estoque:** cookies congelados por sabor (massa porcionada, assada só na hora da venda). Quando um pedido vai para *Vendidos*, os cookies saem do estoque, e voltam se o pedido voltar para *Em aberto*.
- **Demanda:** vendas por sabor (7 dias, 30 dias ou tudo), clientes que mais pedem e sugestão da IA de quantos porcionar e congelar de cada sabor.

Os pedidos nunca ficam neste repositório. Ficam no Supabase (Pages) ou no banco do Artifact (Claude).

### Dados

| Caminho | Conteúdo |
|---|---|
| `pedidos/<id>` | `data` (AAAA-MM-DD), `canal`, `nome`, `telefone`, `itens` {saborId: qtd}, `caixas`, `valor`, `obs`, `status` (`aberto` ou `vendido`), `vendidoEm`, `criadoEm` |
| `estoque/cookies` | `qtd` {saborId: n}, `atualizadoEm` |
| `config/menu` (opcional) | `sabores` [{id, nome}], `precoIndividual`, `precoCaixa4`. Se existir, substitui o cardápio padrão do código |

Sabores: `tradicional`, `cacau-black`, `red-velvet`, `smores-padaria`, `smores-delivery`, `kitkat`, `kinder`.

### Como atualizar

`app/index.html` é a fonte. Ela não tem `<html>`/`<head>`/`<body>`, porque o Artifact acrescenta esse esqueleto ao publicar. Depois de editar:

1. Rode `python3 scripts/build-pages.py`, que gera o `index.html` da raiz (a página do Pages), e faça commit dos dois arquivos.
2. Para atualizar o Artifact, peça ao Claude para republicar na mesma URL.

### Configurar o GitHub Pages + Supabase (uma vez)

1. Use um projeto do [Supabase](https://supabase.com) só da Tiboh. Desde 28/10/2026 ela tem conta e projeto próprios, separados do app Cuidar.
2. No **SQL Editor**, rode `supabase/schema.sql`. Depois rode o `insert into public.tiboh_membros ...` do final com os e-mails de quem vai usar o app. Só esses e-mails veem os pedidos.
3. Em **Authentication > URL Configuration**, adicione `https://vendra74.github.io/Tiboh/` em *Redirect URLs*. Coloque o mesmo endereço também como *Site URL*.
   Em **Authentication > Emails > Magic Link**, acrescente ao modelo uma linha com o código, por exemplo `<p>Seu código: <strong>{{ .Token }}</strong></p>`. O app pede esse código, e assim o atalho do iPhone pode abrir em tela cheia, que guarda o login separado do Safari.
4. Em **Project Settings > API**, copie a *Project URL* e a chave *anon public* para o `config.js`.
5. No GitHub, em **Settings > Pages**, escolha *Deploy from a branch*, branch `main`, pasta `/ (root)`.

6. **IA (opcional):** crie uma chave em [console.anthropic.com](https://console.anthropic.com) e guarde em **Edge Functions > Secrets** com o nome `ANTHROPIC_API_KEY`. Depois, em **Edge Functions > Deploy a new function > Via Editor**, crie a função `tiboh-ia` com o conteúdo de `supabase/functions/tiboh-ia/index.ts` e **desligue** *Verify JWT* (em projetos novos ele recusa o login; a própria função confere login e `tiboh_membros`). Sem a função, o app funciona normalmente e os botões de IA somem na primeira tentativa.

A função só atende quem está em `tiboh_membros`, e a chave da Anthropic fica no servidor, nunca no navegador. Cada uso custa centavos na conta da Anthropic.

A chave *anon* é pública por natureza. O que protege os pedidos é o login e a lista `tiboh_membros`, aplicados pelas regras de acesso (RLS) do banco.

## Identidade visual (`identidade-visual/`)

- **Cores:** azul Tiboh `#1E80C1`, creme `#FFF2D0`, amarelo da caixa `#FCD923`.
- **Logos:** o script "Tiboh" (solto e no oval), o selo "oh'" e as variações de cor.
- **Embalagem:** arte final, opção 1, gabarito de corte e vinco (69 × 3 × 129 cm) e o verso com "Como aquecer?" e "Como armazenar?".
- **Adesivos do expositor.**
- **Slogan:** *Worth every crumb.*

## Planilha de controle

A planilha Excel de vendas por semana e de ingredientes (`Tiboh - Controle.xlsx`) está no Mac do Andre e ainda não foi colocada neste repositório.
