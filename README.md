# Tiboh

Ferramentas de gestão da **Tiboh cookies** ([@tiboh.oh](https://www.instagram.com/tiboh.oh/), Belo Horizonte): pedidos, estoque e demanda.

## App de pedidos (`app/index.html`)

App web pensado para o celular, publicado como Artifact do Claude:
**https://claude.ai/artifact/88ZAUmUAaJQziMByMg9AXM**

- **Pedidos:** kanban com duas colunas, *Em aberto* e *Vendidos*. Cada card é um pedido com data, nome, telefone, canal, quantidade de cada sabor, caixas e valor.
- **Valor automático:** cookie avulso R$ 15 e caixa com 4 R$ 55. Dá para mudar o valor em cada pedido.
- **IA no pedido:** cole a mensagem do WhatsApp e a IA preenche o card.
- **Estoque:** cookies prontos por sabor. Quando um pedido vai para *Vendidos*, os cookies saem do estoque, e voltam se o pedido voltar para *Em aberto*.
- **Demanda:** vendas por sabor (7 dias, 30 dias ou tudo), clientes que mais pedem e sugestão da IA de quantos assar de cada sabor.

Os dados ficam no banco do próprio Artifact, não neste repositório.

### Dados

| Caminho | Conteúdo |
|---|---|
| `pedidos/<id>` | `data` (AAAA-MM-DD), `canal`, `nome`, `telefone`, `itens` {saborId: qtd}, `caixas`, `valor`, `obs`, `status` (`aberto` ou `vendido`), `vendidoEm`, `criadoEm` |
| `estoque/cookies` | `qtd` {saborId: n}, `atualizadoEm` |
| `config/menu` (opcional) | `sabores` [{id, nome}], `precoIndividual`, `precoCaixa4`. Se existir, substitui o cardápio padrão do código |

Sabores: `tradicional`, `cacau-black`, `red-velvet`, `smores-padaria`, `smores-delivery`, `kitkat`, `kinder`.

### Como atualizar

`app/index.html` é o conteúdo da página, sem `<html>`/`<head>`/`<body>`, porque o Artifact acrescenta esse esqueleto ao publicar. Depois de editar, peça ao Claude para republicar a página na mesma URL.

## Identidade visual (`identidade-visual/`)

- **Cores:** azul Tiboh `#1E80C1`, creme `#FFF2D0`, amarelo da caixa `#FCD923`.
- **Logos:** o script "Tiboh" (solto e no oval), o selo "oh'" e as variações de cor.
- **Embalagem:** arte final, opção 1, gabarito de corte e vinco (69 × 3 × 129 cm) e o verso com "Como aquecer?" e "Como armazenar?".
- **Adesivos do expositor.**
- **Slogan:** *Worth every crumb.*

## Planilha de controle

A planilha Excel de vendas por semana e de ingredientes (`Tiboh - Controle.xlsx`) está no Mac do Andre e ainda não foi colocada neste repositório.
