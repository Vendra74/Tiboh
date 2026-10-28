#!/usr/bin/env python3
"""Gera index.html (GitHub Pages) a partir de app/index.html (fonte do Artifact).

app/index.html não tem <html>/<head>/<body> porque o Artifact acrescenta esse
esqueleto ao publicar. Aqui fazemos o mesmo e carregamos config.js antes do app.
Uso: python3 scripts/build-pages.py
"""
from pathlib import Path

root = Path(__file__).resolve().parent.parent
page = (root / "app" / "index.html").read_text(encoding="utf-8")

head = """<!doctype html>
<!-- Gerado por scripts/build-pages.py a partir de app/index.html. Não edite aqui. -->
<html lang="pt-BR">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="theme-color" content="#1e80c1">
<link rel="apple-touch-icon" href="icons/icon-180.png">
<link rel="icon" type="image/png" sizes="32x32" href="icons/icon-32.png">
<link rel="manifest" href="manifest.webmanifest">
<meta name="apple-mobile-web-app-title" content="Tiboh">
<style>:root{color-scheme:light;padding-top:env(safe-area-inset-top,0px);padding-bottom:env(safe-area-inset-bottom,0px)}body{margin:0;font:14px/1.4 system-ui,sans-serif}img{max-width:100%}[hidden]{display:none!important}</style>
<script src="config.js"></script>
</head>
<body>
"""
out = head + page + "\n</body>\n</html>\n"
(root / "index.html").write_text(out, encoding="utf-8")
print("index.html gerado")
