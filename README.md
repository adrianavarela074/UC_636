# UC_636

# Automatização da Configuração e Alojamento de Website em Servidor Linux (CentOS 10)

Este repositório contém o conjunto de scripts de automatização desenvolvidos para a instalação, configuração, otimização e proteção robusta de um servidor Linux (CentOS 10). O objetivo principal é alojar um website corporativo acessível externamente através de um IP público fixo, reduzindo a intervenção manual e garantindo a total reprodutibilidade do ambiente.

---

##  Arquitetura do Sistema e Stack Tecnológica

O ambiente do servidor foi desenhado com base nos requisitos oficiais do projeto:
* **Sistema Operativo:** CentOS 10
* **Servidor Web:** Apache HTTPD (com suporte a Virtual Hosts)
* **Linguagem de Script:** PHP (Processado via PHP-FPM)
* **Base de Dados:** MariaDB Server
* **Segurança Ativa:** SELinux (Modo Enforcing), Firewalld, Fail2ban e Mod_security
* **Diretório do Website:** `/var/www/html`

---

##  Funcionalidades Principais dos Scripts

Os scripts estão divididos de forma modular para cobrir todo o ciclo de vida do servidor, desde o aprovisionamento até à manutenção diária:

### 1. Instalação e Serviços Base (Scripts 1 & 2)
* **Instalação Automatizada:** Instalação limpa da stack LAMP (Apache, PHP, MariaDB).
* **Implementação do Website:** Criação automática do diretório e ficheiro do website (`index.html`/`index.php`) e validação local.
* **Segurança de Base de Dados:** Execução automatizada e silenciosa do `mysql_secure_installation`, definindo a password de root, removendo utilizadores anónimos e desativando acessos remotos inseguros.

### 2. Infraestrutura de Rede e Firewall (Script 3)
* **Deteção de IP:** Identificação automática do IP público do servidor.
* **Políticas de Tráfego:** Configuração estrita do `firewalld`, fechando todas as portas e permitindo apenas tráfego legítimo: **SSH (22)**, **HTTP (80)** e **HTTPS (443)**.

### 3. Fortificação e Segurança Avançada (Scripts 4, 5 & 6)
* **Auditoria SELinux:** Garantia do modo *Enforcing* ativo e geração automática de relatórios de conformidade através do comando `sealert` com logs centralizados em `/var/log/seguranca.log`.
* **Proteção Contra Força Bruta:** Configuração do `Fail2ban` com regras severas para bloquear IPs (máximo de 3 tentativas falhadas) em acessos SSH e Apache, com alertas integrados.
* **Web Application Firewall (WAF):** Integração do `Mod_security` com as regras globais do OWASP CRS para blindagem contra ataques web como SQL Injection (SQLi) e Cross-Site Scripting (XSS).

### 4. Otimização e Performance (Tuning - Scripts 7, 8 & 9)
* **Tuning Apache:** Ativação dos módulos `mod_deflate` (compressão), `KeepAlive` e ajuste dinâmico de timeouts conforme os recursos de hardware.
* **Otimização MariaDB:** Edição dinâmica do `/etc/my.cnf` para alocar de forma inteligente a memória RAM (InnoDB Buffer Pool ajustado para 60% da RAM disponível).
* **Ajustes PHP:** Otimização do `/etc/php.ini` com limites de memória elevados (`memory_limit = 256M`), suporte a uploads maiores e fuso horário definido para `Europe/Lisbon`.

### 5. Manutenção e Backup (Scripts 10 & 11)
* **Políticas de Backup:** Script cronometrável para atualizações do sistema (`dnf update`) e geração de cópias de segurança diárias e compactadas da base de dados e do diretório `/var/www/html`.
* **Monitorização Remota:** Análise periódica de logs críticos de sistema e web com envio de alertas automáticos em caso de anomalias.

---

##  Como Executar o Projeto

Para garantir que o ambiente é configurado sem erros de permissões, os scripts devem ser executados sequencialmente com privilégios de administrador (`root` ou `sudo`):

```bash
# 1. Clonar ou transferir os scripts para o servidor CentOS 10
# 2. Dar permissões de execução aos ficheiros .sh
chmod +x *.sh

# 3. Executar os scripts na ordem planeada no Roadmap
sudo ./script1_instalacao.sh
sudo ./script2_mariadb_seguro.sh
sudo ./script3_firewall.sh
# ... seguir consecutivamente até ao script 11
```

---

## Autoras e Turma
* **Curso:** Gestão de Redes e Sistemas Computacionais
* **Turma:** GRSC0226
* **Módulo:** UC 00636 - Administrar um servidor de base de dados
* **Desenvolvido por:** Adriana Varela & Mariana Costa
* **Entrega do Relatório:** 1 de Novembro
* **Defesa do Projeto:** 26 e 28 de Outubro
