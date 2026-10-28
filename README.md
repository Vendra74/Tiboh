# Tiboh

Ferramentas de gestão da **Tiboh cookies** ([@tiboh.oh](https://www.instagram.com/tiboh.oh/), Belo Horizonte): pedidos, estoque e demanda.

## App de pedidos (`app/index.html`)

App web pensado para o celular. O mesmo código roda em dois lugares:

- **GitHub Pages:** https://vendra74.github.io/Tiboh/ (dados no Supabase, entrada com link por e-mail, sem IA).
- **Artifact do Claude:** https://claude.ai/artifact/88ZAUmUAaJQziMByMg9AXM (dados no banco do Artifact, com IA).

- **Pedidos:** kanban com duas colunas, *Em aberto* e *Vendidos*. Cada card é um pedido com data, nome, telefone, canal, quantidade de cada sabor, caixas e valor.
- **Valor automático:** cookie avulso R$ 15 e caixa com 4 R$ 55. Dá para mudar o valor em cada pedido.
- **IA no pedido:** cole a mensagem do WhatsApp e a IA preenche o card.
- **Estoque:** cookies prontos por sabor. Quando um pedido vai para *Vendidos*, os cookies saem do estoque, e voltam se o pedido voltar para *Em aberto*.
- **Demanda:** vendas por sabor (7 dias, 30 dias ou tudo), clientes que mais pedem e sugestão da IA de quantos assar de cada sabor.

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

1. Use um projeto do [Supabase](https://supabase.com), novo ou um que já exista. As tabelas da Tiboh têm o prefixo `tiboh_` e não mexem nas outras.
2. No **SQL Editor**, rode `supabase/schema.sql`. Depois rode o `insert into public.tiboh_membros ...` do final com os e-mails de quem vai usar o app. Só esses e-mails veem os pedidos.
3. Em **Authentication > URL Configuration**, adicione `https://vendra74.github.io/Tiboh/` em *Redirect URLs*. Se o projeto já tem outro app, **não mude** a *Site URL*, porque ela é do outro app. O link de login já pede para voltar para a Tiboh.
4. Em **Project Settings > API**, copie a *Project URL* e a chave *anon public* para o `config.js`.
5. No GitHub, em **Settings > Pages**, escolha *Deploy from a branch*, branch `main`, pasta `/ (root)`.

A chave *anon* é pública por natureza. O que protege os pedidos é o login e a lista `tiboh_membros`, aplicados pelas regras de acesso (RLS) do banco.

## Identidade visual (`identidade-visual/`)

- **Cores:** azul Tiboh `#1E80C1`, creme `#FFF2D0`, amarelo da caixa `#FCD923`.
- **Logos:** o script "Tiboh" (solto e no oval), o selo "oh'" e as variações de cor.
- **Embalagem:** arte final, opção 1, gabarito de corte e vinco (69 × 3 × 129 cm) e o verso com "Como aquecer?" e "Como armazenar?".
- **Adesivos do expositor.**
- **Slogan:** *Worth every crumb.*

## Planilha de controle

A planilha Excel de vendas por semana e de ingredientes (`Tiboh - Controle.xlsx`) está no Mac do Andre e ainda não foi colocada neste repositório.
