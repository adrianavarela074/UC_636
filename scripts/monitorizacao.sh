#!/bin/bash

echo "Monitorizacao de logs e sincronizacao NTP"
echo ""

echo "A configurar a sincronizacao horaria (NTP)..."
sudo dnf install chrony -y &> /dev/null

sudo systemctl enable --now chronyd

sudo chronyc makestep
echo "Horas do sistema sincronizadas com sucesso via NTP."
echo""
echo "Hora atual: $(date)"
echo ""

echo "A analisar logs do sistema e do Apache..."
REPORT_FILE="/var/log/seguranca_report.log"
DATA_ATUAL=$(date "+%b %d")

sudo tee $REPORT_FILE > /dev/null <<EOF
==========================================================
 RELATÓRIO DE SEGURANÇA E LOGS - $(date)
==========================================================

[1] FALHAS DE AUTENTICAÇÃO SSH REALIZADAS HOJE ($DATA_ATUAL):
----------------------------------------------------------
EOF

sudo grep "$DATA_ATUAL" /var/log/secure | grep -E "Failed|Invalid" | sudo tee -a $REPORT_FILE > /dev/null

sudo tee -a $REPORT_FILE > /dev/null <<EOF

[2] ERROS CRÍTICOS RECENTES NO APACHE (HTTP 4xx e 5xx):
----------------------------------------------------------
EOF

if [ -f "/var/log/httpd/error_log" ]; then
    sudo tail -n 50 /var/log/httpd/error_log | grep -E "error|warn" | sudo tee -a $REPORT_FILE > /dev/null
else
    echo "Aviso: Log do Apache nao encontrado ou vazio ainda." | sudo tee -a $REPORT_FILE > /dev/null
fi

echo "Relatorio gerado com sucesso em: $REPORT_FILE"
echo ""

echo ""
echo "A verificar a existencia de falhas criticas..."
echo ""

SSH_FAILURES=$(sudo grep "$DATA_ATUAL" /var/log/secure | grep -E "Failed|Invalid" | wc -l)

if [ "$SSH_FAILURES" -gt 0 ]; then
    echo " ALERTAS CRÍTICOS DETETADOS!"
    echo " -> Foram encontradas ${SSH_FAILURES} tentativas falhadas de login SSH hoje."
    echo " -> Verifique os detalhes em: cat $REPORT_FILE"
else
    echo " Sistema Seguro: Nenhuma anomalia grave detetada nos logs hoje."
fi
