#!/bin/bash

LOG_CENTRAL="/var/log/security.log"
AUDIT_LOG="/var/log/audit/audit.log"

registry_log() {
	local MESSAGE="$1"
	echo "$(date '+%Y-%m-%d %H:%M:%S') - $MESSAGE" | sudo tee -a "LOG_CENTRAL" > /dev/null
}

if [ ! -f "$LOG_CENTRAL" ]; then
	sudo touch "$LOG_CENTRAL"
	sudo chmod 600 "$LOG_CENTRAL"
	registry_log " Ficheiro de log centralizado criado com sucesso"
fi

echo ""
echo " A verificar o estado do SELinux..."
echo ""

STATUS_SELINUX=$(getenforce)

if [ "$STATUS_SELINUX" = "Enforcing" ]; then
	echo "OK: O SELinux está ativo em modo enforcing"
	registry_log "SELinux validade: O estado atual é enforcing"
else
	echo "Aviso: O SELinux não está em modo enforcing (estado atual: $STATUS_SELINUX)"
	echo "A tentar reativar o modo enforcing..."

	sudo setenforce 1
	if [ "$(getenforce)" = "Enforcing" ]; then
		echo "SELinux alterado para enforcing com sucesso"
		registry_log "SELinux alterado dinamicamente para enforcing via setenforce"

	else
		echo "Não foi possível ativar o modo enforcing"
		registry_log "Falha ao tentar forçar o modo enforcing"
		exit 1
	fi
fi

echo ""
echo "A verificar dependências do utilitário sealert..."
echo ""

if ! command -v sealert &> /dev/null; then
	echo "sealert não encontrado"
	registry_log "Instalação automáica do pacote setroubleshoot-server iniciada"

	sudo dnf install -y setroubleshoot-server

	if ! command -v sealert &> /dev/null; then
		echo "Falha ao instalar o pacote"
		registry_log "Falha na instalação do utilitário sealert"
		exit 1
	fi
	echo "sealert instalado com sucesso!"
fi

echo ""
echo "A analisar os logs de auditoria e a gerar relatórios..."
echo ""

if [ ! -f "$AUDIT_LOG" ]; then
	echo "O ficheiro de logs $AUDIT_LOG não existe"
	registry_log "Ficheiro $AUDIT_LOG ausente no sistema"
	exit 1
fi

registry_log "Execução do comando sealert iniciada para análise do audit.log"

TMP_REPORT=$(mktemp)
sudo sealert -a "$AUDIT_LOG" >  "$TMP_REPORT" 2>&1

DETECTED_WARNINGS=$(grep -c "SELinux is preventing" "$TMP_REPORT")

echo ""
echo "Número de alertas de bloqueio analisados: $DETECTED_WARNINGS"
echo""

echo ""
echo "RELATÓRIO SEALERT" | sudo tee -a "$LOG_CENTRAL" > /dev/null
sudo cat "$TMP_REPORT" | sudo tee -a "$LOG_CENTRAL" > /dev/null

rm -f "$TMP_REPORT"
registry_log "Relatório do sealert anexado com sucesso ao log centralizado"

echo ""
echo "Todos os eventos foram gravados com sucesso em: $LOG_CENTRAL"
