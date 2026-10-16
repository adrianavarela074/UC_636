#!/bin/bash

echo "A iniciar a configuração da rede e firewall..."
echo""

INTERFACE="ens160"
STATIC_IP="172.16.0.193/24"
GATEWAY="172.16.0.1"
DNS_SERVER="8.8.8.8"

sudo dnf install -y curl

PUBLIC_IP=$(curl -s ifconfig.me)
echo""
echo "O seu IP público é $PUBLIC_IP"
echo ""

echo ""
echo "Configuração do IP fixo na interface [$INTERFACE]..."
echo ""

PROFILE=$(nmcli -g GENERAL.CONNECTION device show "$INTERFACE" | head -n1)

if [ -z "$PROFILE" ]; then
	echo "Não foi encontrada nenhuma ligação ativa na interface $INTERFACE"
	exit 1
fi

sudo nmcli connection modify "$PROFILE" \
	ipv4.addresses "$STATIC_IP" \
	ipv4.gateway "$GATEWAY" \
	ipv4.dns "$DNS_SERVER" \
	ipv4.method manual

echo "A reiniciar a interface para aplicar as alterações efetuadas..."
echo ""

sudo nmcli connection down "$PROFILE" && sudo nmcli connection up "$PROFILE"

echo "Teste de conectividade..."
echo ""

if ping -c 2 -W 2 "$GATEWAY" > /dev/null; then
	echo "OK";
else
	echo "Falha";
fi

if ping -c 2 -W 2 8.8.8.8 > /dev/null; then
	echo "OK";
else
	echo "Falha";
fi

echo ""
echo "Configuração das portas 22, 80 e 443..."
echo ""
sudo systemctl enable --now firewalld

sudo firewall-cmd --permanent --zone=public --add-port=22/tcp
sudo firewall-cmd --permanent --zone=public --add-port=80/tcp
sudo firewall-cmd --permanent --zone=public --add-port=443/tcp

echo ""
echo "A dar reload para aplicar as novas regras..."
echo ""

sudo firewall-cmd --reload

echo "Portas atualmente abertas na zona pública:"
sudo firewall-cmd --zone=public --list-ports

echo ""
echo "A criar redirecionamento via script auxiliar..."
if [ -f "./red_router.sh" ]; then
	chmod +x ./red_router.sh
	./red_router.sh "$STATIC_IP"
else
	echo "Script auxiliar não encontrado. A saltar..."
fi

echo ""
echo "Teste final de serviço externo HTTP via CURL..."
echo ""

if curl -sI --connect-timeout 3 http://google.com | grep -q "HTTP/"; then
	echo "OK";
else
	echo "Falha";
fi

echo ""
echo "Configuração concluída com sucesso!"
