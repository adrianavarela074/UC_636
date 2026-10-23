#!/bin/bash

# Configurações oficiais do enunciado do projeto
DOMAIN="adrimari.pt"
SITE_FOLDER="/var/www/html"

echo ""
echo "=================================================="
echo " Criacao do Website Estatico (index.html)"
echo "=================================================="
echo ""

# 1. Garantir que a pasta padrao existe
sudo mkdir -p "${SITE_FOLDER}"

# 2. Criar a configuracao do Virtual Host no Apache
sudo tee /etc/httpd/conf.d/${DOMAIN}.conf > /dev/null <<EOF
<VirtualHost *:80>
    ServerName ${DOMAIN}
    ServerAlias www.${DOMAIN}
    DocumentRoot ${SITE_FOLDER}

    ErrorLog /var/log/httpd/${DOMAIN}_error.log
    CustomLog /var/log/httpd/${DOMAIN}_access.log combined

    <Directory ${SITE_FOLDER}>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF

# 3. Gerar o ficheiro index.html com o design visual completo convertido
sudo tee ${SITE_FOLDER}/index.html > /dev/null <<'EOF'
<!DOCTYPE html>
<html lang="pt-PT">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>UC 00636 · Administrar um servidor de base de dados</title>
<style>
  :root {
    --fundo: #e8eef4; --papel: #f7fafc; --tinta: #0f2a43; --tinta-suave: #3d5368;
    --azul: #1d5fd1; --ambar: #f2a900; --linha: #b9c7d4; --term-fundo: #10263b; --term-texto: #d6e4f0;
    --fonte: "Segoe UI", Arial, sans-serif; --mono: monospace;
  }
  * { box-sizing: border-box; }
  body { margin: 0; background: var(--fundo); color: var(--tinta); font-family: var(--fonte); padding: 2rem; }
  .contentor { max-width: 800px; margin: auto; background: var(--papel); padding: 2rem; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); }
  h1 { color: var(--azul); margin-top: 0; }
  .etiqueta { background: var(--ambar); padding: .2rem .5rem; border-radius: 4px; font-weight: bold; font-size: 0.9rem; }
  pre { background: var(--term-fundo); color: var(--term-texto); padding: 1rem; border-radius: 6px; overflow-x: auto; font-family: var(--mono); white-space: pre; }
</style>
</head>
<body>
<div class="contentor">
  <h1>Administrar um servidor de base de dados</h1>
  <p><strong>Curso:</strong> Gestão de Redes e Sistemas Computacionais (<span class="etiqueta">GRSC0226</span>)</p>
  <p><strong>Trabalho realizado por:</strong> Adriana Varela e Mariana Costa</p>
  
  <h3>Output de Validação (Tabela Estilo MySQL):</h3>
  <pre>
+---------------+----------+----------+

| nome          | turma    | modulo   |
+---------------+----------+----------+

| Adriana Varela| GRSC0226 | UC 00636 |
| Mariana Costa | GRSC0226 | UC 00636 |
+---------------+----------+----------+
2 linhas no conjunto (0,00 seg)</pre>
</div>
</body>
</html>
EOF

# 4. Permissoes e limpeza
sudo rm -f ${SITE_FOLDER}/index.php   # Remove o index.php antigo para nao haver conflitos
sudo chown -R apache:apache "${SITE_FOLDER}"
sudo chmod -R 755 "${SITE_FOLDER}"
sudo restorecon -R -v "${SITE_FOLDER}"

# 5. Reiniciar o Apache
sudo systemctl restart httpd

echo ""
echo "Site index.html criado e Apache reiniciado!"
echo "=================================================="
