# Guion — Claude Code: Como Trabajo Hoy

**Duracion:** ~40-45 min (30 min slides + 10-12 min demo)
**Formato:** informal, amigos devs
**Controles:** ← → navegar, L laser, N speaker notes

---

## Intro (slides 1-3, ~4 min)

### Slide 1 — Titulo (30 seg)
- "Les voy a mostrar como trabajo hoy. Ya no escribo codigo — defino que quiero y un agente lo ejecuta."

### Slide 2 — Antes vs ahora (2 min)
- Antes: Notion → investigar → codear → test → commit → PR → Notion. Todo manual.
- Ahora: defino que quiero, apruebo checkpoints, el agente hace el resto.
- No fue magico — fui armando las piezas de a una.

### Slide 3 — Claude Code en 30 seg (1.5 min)
- CLI agent en tu terminal. No chatbot, no autocomplete.
- Acceso real: filesystem, bash, git, gh, cualquier cosa.
- Lo clave: spawna sub-agentes y se conecta con Notion via MCP.

---

## Mi setup (slides 4-12, ~14 min)

### Slide 4 — Las piezas (1 min)
- Overview de las 6 piezas: CLAUDE.md, 44 skills, 7 agents, MCP, hooks, 9 repos
- Cada una se agrego de a poco. Empece solo con CLAUDE.md.

### Slide 5 — CLAUDE.md (2 min)
- La base de todo. Se lee al inicio de cada sesion.
- Mostrar snippet: repos, convenciones, comandos, tabla de agents.
- "Sin esto, el agente es generico. Con esto, ya sabe todo de tu proyecto."

### Slide 6 — /init (1.5 min) ⭐ NEW
- Transicion natural: "Ya vieron que es CLAUDE.md. Pero no lo escriban a mano."
- Mostrar que /init escanea stack, configs, git history automaticamente.
- Comparar: 30 min a mano vs 2 min con /init.
- "Hice un skill que lee tu repo y genera el CLAUDE.md. Lo van a ver en la parte practica."

### Slide 7 — Skills (2 min)
- Prompts especializados que cargan on-demand.
- /ship: 8 pasos de pre-flight a Notion update.
- /dev-starter: Notion → analisis → plan → branch.
- /shaping, /breadboarding para disenar.
- 44 archivos en 18 grupos para cada stack.

### Slide 8 — Agents (2 min)
- 7 agentes, cada uno con su rol y restricciones.
- Orchestrator coordina, no codea. Analyst solo lee. Shipper usa Haiku.
- Cada agente tiene solo las tools que necesita.

### Slide 9 — Pipeline completo (2 min)
- Shaping → Breadboard → Dev-Starter → Orchestrator → Analyst → Dev Agents → Reviewer → Shipper
- Yo: shaping + approvals. Agente: todo lo demas. Pipeline: valida.

### Slide 10 — Notion MCP (1.5 min)
- /dev-starter busca tarea, lee criterios, crea branch, actualiza Notion.
- /ship crea PR y actualiza Notion a "Lista para validar".
- Todo sin salir de la terminal.

### Slide 11 — Hooks (1.5 min)
- Shell commands automaticos en cada accion del agente.
- Guardrails reales — el agente no puede saltarselos.
- Ideas: lint, bloquear secrets, validar schemas.

---

## Lecciones (slides 13-17, ~8 min)

### Slide 13 — Nunca codear sin plan (2 min)
- Sin plan: empieza, descubre problemas, reescribe. Caro.
- Con plan: investiga, planea, checkpoint, ejecuta limpio.
- El orchestrator fuerza checkpoint obligatorio.

### Slide 14 — Se opinionated (1.5 min)
- Vago in = vago out.
- Investigar → aprender → opinar → cristalizar en Skill.
- Ejemplo: no "escribe un controlador" sino specs detalladas.

### Slide 15 — Hablar en arquitectura (1.5 min)
- Decir QUE, no COMO. El agente rellena la implementacion.
- "Consumer que procese X y emita Y" > "clase que herede de Z con metodo W".

### Slide 16 — CI/CD como safety net (1.5 min)
- "Como confias?" — con un pipeline solido.
- Pre-commit + pre-flight + CI. Si pasa, es correcto.

### Slide 17 — Slash commands y shortcuts (2 min)
- /compact es clave cuando el contexto se llena y se pone lento.
- /insights y /usage para metricas y consumo.
- Esc Esc = rewind (deshacer turno). Shift+Tab cicla permission modes.
- Permission modes: Normal (pide permiso), Auto-accept (aprueba safe), YOLO (danger zone — aprueba todo, usar con cuidado).
- Yo uso auto-accept casi siempre. YOLO cuando estoy apurado.

---

## Demo (slides 20-22, ~10-12 min)

### Slide 21 — Guia de demo
1. **Workspace** (2 min): `ls`, `tree .claude/ -L 2`
2. **CLAUDE.md** (2 min): abrir y scrollear secciones
3. **Skills** (2 min): `cat .claude/skills/ship/SKILL.md`
4. **Agents** (2 min): `cat .claude/agents/orchestrator.md`
5. **Flujo rapido** (2-4 min): /ship o prompt simple

---

## Ideas + cierre (slides 23-29, ~7 min)

### Slide 23 — Flujos para automatizar (1.5 min)
- Code review automatizado, onboarding, migrations, incident response.

### Slide 24 — Skills para cualquiera (1.5 min)
- /deploy, /hotfix, /migration, /scaffold, /pr-review.

### Slide 25 — Como empezar (1 min)
- Paso 1: CLAUDE.md (30 min)
- Paso 2: un Skill (1 hora)
- Paso 3: un Hook (15 min)
- Iterar. No armar todo junto.

### Slide 26 — Les prepare algo (1.5 min) ⭐ NEW
- "Para que no partan de cero, les prepare un repo."
- Mostrar URL: github.com/rzyuras/rados-claude-workshop
- Config-only: agents, META skills, hooks. Se clona y se linkea.
- Highlight META skills: /init, /generate-skill, /generate-agent.

### Slide 27 — Que trae (1.5 min) ⭐ NEW
- Tree del repo: agents/, skills/, hooks/
- 4 agents (planner, developer, reviewer, shipper)
- 5 skills (3 META + 2 utilities)
- 2 hooks (lint-on-save, block-secrets)
- "Todo funciona out of the box con symlink."

### Slide 28 — 3 comandos (1 min) ⭐ NEW
- Clone → symlink → /init. Eso es todo.
- "En 2 minutos tienen agents, skills y hooks funcionando."
- Si hay tiempo, hacer demo en vivo del setup.

### Slide 29 — Preguntas
- "Quieren que les ayude a correr /init en su proyecto?"

---

## Pre-demo checklist
- [ ] Terminal con fuente grande
- [ ] Repos actualizados
- [ ] Un repo con cambios uncommitted (para /ship)
- [ ] Claude Code autenticado
- [ ] Browser con index.html fullscreen
- [ ] rados-claude-workshop clonado (para demo de /init)

## Si voy corto de tiempo
- Acortar demo: workspace + 1 skill + 1 agent
- Saltar CLI flags
- Comprimir ideas en 1 slide
- Workshop slides (26-28): mostrar solo slide 28 (3 comandos) y dar URL
