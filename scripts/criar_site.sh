#!/bin/bash

INDEX_FILE="/var/www/adrimari.pt/public_html/index.php"

echo "A gerar o ficheiro do site..."
echo ""
echo ""

sudo tee "$INDEX_FILE" > /dev/null <<EOF

<!DOCTYPE html>
<html lang="pt-PT">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>UC 00636 · Administrar um servidor de base de dados</title>
<meta name="description" content="Trabalho de Adriana Varela e Mariana Costa, turma GRSC0226, módulo UC 00636 - Administrar um servidor de base de dados.">
<style>
  :root {
    --fundo: #e8eef4;
    --papel: #f7fafc;
    --tinta: #0f2a43;
    --tinta-suave: #3d5368;
    --azul: #1d5fd1;
    --ambar: #f2a900;
    --linha: #b9c7d4;
    --term-fundo: #10263b;
    --term-texto: #d6e4f0;
    --term-cinza: #7f98ae;
    --term-ciano: #5fd0e8;
    --term-ambar: #ffc94d;
    --fonte: "Segoe UI", "Helvetica Neue", Arial, "Liberation Sans", sans-serif;
    --mono: "DejaVu Sans Mono", Consolas, "Liberation Mono", Menlo, monospace;
  }
  * { box-sizing: border-box; }
  html { scroll-behavior: smooth; }
  body {
    margin: 0;
    background: var(--fundo);
    color: var(--tinta);
    font-family: var(--fonte);
    font-size: 1.0625rem;
    line-height: 1.65;
  }
  a { color: var(--azul); }
  a:focus-visible, button:focus-visible { outline: 3px solid var(--ambar); outline-offset: 3px; }

  .contentor { width: min(1080px, 100% - 2.5rem); margin-inline: auto; }

  /* Cabeçalho */
  header.topo { padding: 1.25rem 0; border-bottom: 1px solid var(--linha); }
  .topo .contentor { display: flex; flex-wrap: wrap; gap: .75rem 2rem; align-items: center; justify-content: space-between; }
  .marca { font-family: var(--mono); font-weight: 700; font-size: 1rem; color: var(--tinta); text-decoration: none; }
  .marca span { color: var(--azul); }
  nav ul { list-style: none; margin: 0; padding: 0; display: flex; gap: 1.5rem; }
  nav a { color: var(--tinta-suave); text-decoration: none; font-weight: 600; font-size: .95rem; }
  nav a:hover { color: var(--azul); text-decoration: underline; text-underline-offset: 4px; }

  /* Hero */
  .hero { padding: clamp(2.5rem, 7vw, 5rem) 0 clamp(2.5rem, 6vw, 4rem); }
  .hero .contentor { display: grid; grid-template-columns: 1fr; gap: 2.5rem; }
  @media (min-width: 900px) { .hero .contentor { grid-template-columns: 1fr 1.15fr; align-items: center; gap: 3.5rem; } }
  .hero h1 {
    margin: 0 0 1rem;
    font-size: clamp(2.1rem, 5vw, 3.4rem);
    line-height: 1.08;
    letter-spacing: -0.02em;
    font-weight: 800;
  }
  .hero p.sub { margin: 0 0 1.5rem; color: var(--tinta-suave); max-width: 34rem; }
  .etiquetas { display: flex; flex-wrap: wrap; gap: .5rem; }
  .etiqueta {
    font-family: var(--mono); font-size: .85rem; font-weight: 600;
    padding: .3rem .7rem; border: 1.5px solid var(--tinta); border-radius: 4px; background: var(--papel);
  }
  .etiqueta.destaque { background: var(--ambar); border-color: var(--ambar); }

  /* Terminal */
  .terminal {
    background: var(--term-fundo); color: var(--term-texto);
    border-radius: 10px; overflow: hidden;
    box-shadow: 10px 10px 0 var(--tinta);
    font-family: var(--mono); font-size: .88rem; line-height: 1.6;
  }
  .terminal-barra {
    display: flex; align-items: center; gap: .5rem; padding: .6rem .9rem;
    background: #0a1a2a; color: var(--term-cinza); font-size: .78rem;
  }
  .terminal-barra i { width: 11px; height: 11px; border-radius: 50%; background: var(--term-cinza); opacity: .5; display: inline-block; }
  .terminal-barra span { margin-left: .5rem; }
  .terminal-corpo { padding: 1.1rem 1.1rem 1.3rem; overflow-x: auto; }
  .terminal-corpo pre { margin: 0; font: inherit; white-space: pre; }
  .ps { color: var(--term-ciano); }
  .kw { color: var(--term-ambar); }
  .mudo { color: var(--term-cinza); }
  .cursor { display: inline-block; width: .55em; height: 1.1em; background: var(--term-texto); vertical-align: text-bottom; animation: piscar 1.1s steps(1) infinite; }
  @keyframes piscar { 50% { opacity: 0; } }
  .js .resultado { visibility: hidden; }
  .js .resultado.visivel { visibility: visible; }
  @media (prefers-reduced-motion: reduce) { .cursor { animation: none; } }

  /* Secções */
  section.bloco { padding: clamp(2.5rem, 6vw, 4rem) 0; border-top: 1px solid var(--linha); }
  .bloco h2 { margin: 0 0 1.5rem; font-size: clamp(1.5rem, 3vw, 2rem); letter-spacing: -0.01em; line-height: 1.2; }
  .bloco p { max-width: 42rem; margin: 0 0 1rem; }

  /* Autoras */
  .autoras { display: grid; gap: 1.25rem; grid-template-columns: 1fr; }
  @media (min-width: 640px) { .autoras { grid-template-columns: 1fr 1fr; } }
  .autora { background: var(--papel); border: 1.5px solid var(--tinta); border-radius: 8px; padding: 1.25rem 1.4rem; display: flex; gap: 1rem; align-items: center; }
  .iniciais {
    flex: none; width: 3.25rem; height: 3.25rem; border-radius: 6px;
    background: var(--tinta); color: var(--papel);
    display: grid; place-items: center; font-family: var(--mono); font-weight: 700; font-size: 1.1rem;
  }
  .autora h3 { margin: 0; font-size: 1.15rem; line-height: 1.3; }
  .autora p { margin: .1rem 0 0; font-size: .92rem; color: var(--tinta-suave); }

  /* Curso */
  .duas-colunas { display: grid; gap: 2rem; grid-template-columns: 1fr; }
  @media (min-width: 900px) { .duas-colunas { grid-template-columns: 1fr 1fr; gap: 3.5rem; } }
  .areas { list-style: none; margin: 0; padding: 0; border-top: 1px solid var(--linha); }
  .areas li { padding: .9rem 0; border-bottom: 1px solid var(--linha); }
  .areas strong { display: block; }
  .areas span { color: var(--tinta-suave); font-size: .97rem; }

  /* Módulo */
  .modulo { background: var(--tinta); color: var(--papel); }
  .modulo .contentor { padding-block: clamp(2.5rem, 6vw, 4rem); }
  .modulo h2 { color: var(--papel); }
  .modulo .codigo { font-family: var(--mono); color: var(--ambar); font-weight: 700; margin: 0 0 .5rem; }
  .modulo ul { margin: 0; padding-left: 1.2rem; max-width: 42rem; }
  .modulo li { margin-bottom: .45rem; }
  .modulo li::marker { color: var(--ambar); }

  footer { padding: 1.75rem 0 2.5rem; color: var(--tinta-suave); font-size: .92rem; }
  footer .contentor { display: flex; flex-wrap: wrap; justify-content: space-between; gap: .5rem 2rem; }
</style>
</head>
<body>

<header class="topo">
  <div class="contentor">
    <a class="marca" href="#inicio">grsc0226<span>@</span>servidor-bd</a>
    <nav aria-label="Principal">
      <ul>
        <li><a href="#equipa">Equipa</a></li>
        <li><a href="#curso">O curso</a></li>
        <li><a href="#modulo">O módulo</a></li>
      </ul>
    </nav>
  </div>
</header>

<main id="inicio">
  <section class="hero">
    <div class="contentor">
      <div>
        <h1>Administrar um servidor de base de dados</h1>
        <p class="sub">Trabalho realizado por Adriana Varela e Mariana Costa no âmbito do curso de Gestão de Redes e Sistemas Computacionais.</p>
        <div class="etiquetas">
          <span class="etiqueta destaque">GRSC0226</span>
          <span class="etiqueta">UC 00636</span>
          <span class="etiqueta">CentOS · Apache</span>
        </div>
      </div>

      <div class="terminal" role="img" aria-label="Consulta SQL que devolve os nomes das autoras, a turma e o módulo">
        <div class="terminal-barra"><i></i><i></i><i></i><span>mysql — servidor-bd</span></div>
        <div class="terminal-corpo">
<pre><span class="ps">mysql&gt;</span> <span id="comando"><span class="kw">SELECT</span> nome, turma, modulo <span class="kw">FROM</span> equipa;</span><span class="cursor" aria-hidden="true"></span>
<span class="resultado" id="resultado">+----------------+----------+--------------+
| nome           | turma    | modulo       |
+----------------+----------+--------------+
| Adriana Varela | GRSC0226 | UC 00636     |
| Mariana Costa  | GRSC0226 | UC 00636     |
+----------------+----------+--------------+
<span class="mudo">2 linhas no conjunto (0,00 seg)</span></span></pre>
        </div>
      </div>
    </div>
  </section>

  <section class="bloco" id="equipa">
    <div class="contentor">
      <h2>Quem fez este trabalho</h2>
      <div class="autoras">
        <article class="autora">
          <div class="iniciais" aria-hidden="true">AV</div>
          <div>
            <h3>Adriana Varela</h3>
            <p>Turma GRSC0226</p>
          </div>
        </article>
        <article class="autora">
          <div class="iniciais" aria-hidden="true">MC</div>
          <div>
            <h3>Mariana Costa</h3>
            <p>Turma GRSC0226</p>
          </div>
        </article>
      </div>
    </div>
  </section>

  <section class="bloco" id="curso">
    <div class="contentor duas-colunas">
      <div>
        <h2>O curso de Gestão de Redes e Sistemas Computacionais</h2>
        <p>Este curso prepara profissionais para instalar, configurar e manter as redes e os sistemas informáticos de uma organização, garantindo que funcionam de forma segura e sem interrupções.</p>
        <p>Ao longo da formação, trabalha-se com equipamentos de rede, sistemas operativos de servidor e ferramentas de virtualização, sempre com forte componente prática.</p>
      </div>
      <ul class="areas">
        <li><strong>Redes de computadores</strong><span>Montagem, endereçamento, configuração e monitorização de redes locais.</span></li>
        <li><strong>Sistemas operativos</strong><span>Administração de servidores Linux e Windows, utilizadores e serviços.</span></li>
        <li><strong>Segurança informática</strong><span>Proteção de dados, controlo de acessos e cópias de segurança.</span></li>
        <li><strong>Virtualização</strong><span>Criação e gestão de máquinas virtuais para testar e alojar serviços.</span></li>
        <li><strong>Bases de dados</strong><span>Instalação, administração e manutenção de servidores de dados.</span></li>
      </ul>
    </div>
  </section>

  <section class="modulo" id="modulo">
    <div class="contentor">
      <p class="codigo">UC 00636</p>
      <h2>Administrar um servidor de base de dados</h2>
      <p style="max-width:42rem">Neste módulo aprende-se a pôr um servidor de base de dados a funcionar e a mantê-lo em boas condições. As principais tarefas de um administrador são:</p>
      <ul>
        <li>instalar e configurar o servidor de base de dados;</li>
        <li>criar bases de dados e gerir utilizadores e permissões;</li>
        <li>fazer cópias de segurança e restaurar dados;</li>
        <li>monitorizar o desempenho e resolver problemas;</li>
        <li>proteger o acesso à informação guardada.</li>
      </ul>
    </div>
  </section>
</main>

<footer>
  <div class="contentor">
    <span>Adriana Varela e Mariana Costa · GRSC0226</span>
    <span>UC 00636 - Administrar um servidor de base de dados</span>
  </div>
</footer>

<script>
  (function () {
    var reduzir = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
    var resultado = document.getElementById("resultado");
    if (reduzir || !resultado) return;
    document.documentElement.classList.add("js");
    var alvo = document.getElementById("comando");
    var html = alvo.innerHTML;
    var texto = alvo.textContent;
    alvo.textContent = "";
    var i = 0;
    function escrever() {
      if (i <= texto.length) {
        alvo.textContent = texto.slice(0, i++);
        setTimeout(escrever, 45);
      } else {
        alvo.innerHTML = html;
        resultado.classList.add("visivel");
      }
    }
    setTimeout(escrever, 500);
  })();
</script>
</body>
</html>


EOF

sudo chown apache:apache "$INDEX_FILE"
sudo chmod 644 "$INDEX_FILE"

echo ""
echo ""
echo "Site atualizado com sucesso!"
echo ""
