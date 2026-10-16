#/bin/bash

echo "A instalar o GIT..."
echo ""

sudo dnf install git -y

echo ""
echo "A verificar a versão do GIT"
echo ""

sudo git --version 

echo ""
echo "Configuração inicial do GIT..."
echo ""

echo "git config --global user.name "Adriana Mariana""
echo "git config --global user.email "adrimari@exemplo.com""

git config --global user.name "Adriana Mariana"
git config --global user.email "adrimari@exemplo.com"

echo ""
echo "Instalação concluída com sucesso!"
echo ""

