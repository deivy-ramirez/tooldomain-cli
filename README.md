🛠️ tooldomain

tooldomain es una herramienta CLI en Bash para diagnóstico rápido de dominios, diseñada para soporte técnico de hosting y correo.
Permite validar DNS, correo y stack de hosting en tiempo real, sin depender de páginas web externas.

🚀 ¿Qué hace?

tooldomain consulta información en vivo usando DNS públicos y locales para detectar:

- Registros A / CNAME (con seguimiento automático)
- PTR (reverse DNS)
- NS
- MX
- TXT (SPF, DMARC, DKIM)
- Ping básico
- Proveedor de correo
- Panel de hosting (cPanel / Plesk) usando reglas internas
- Configuraciones mixtas (ej. MX Google + SPF hosting)

Todo se muestra en un formato tabular claro, optimizado para terminal.

📦 Requisitos

Funciona en macOS y Linux.

Obligatorios:

- bash
- dig o nslookup
- ping

En macOS, dig suele venir instalado por defecto.

Opcionales (mejoran precisión)

- curl
- jq

Si no están instalados, el script sigue funcionando (solo se desactiva el fallback DoH).

📥 Instalación

1. Descargar el script
   curl -fsSL https://raw.githubusercontent.com/deivy-ramirez/tooldomain-cli/main/install.sh | bash
2. Dar permisos
   chmod +x tooldomain
3. (Opcional) Moverlo al PATH
   mv tooldomain ~/.local/bin/

▶️ Uso

tooldomain dominio.com

También acepta:
tooldomain https://dominio.com/ruta

📧 Detección de proveedor de correo

El script identifica automáticamente:

✔️ Microsoft 365
mail.protection.outlook.com

SPF con spf.protection.outlook.com

✔️ Google Workspace
aspmx.l.google.com
_spf.google.com

⚠️ Google SMTP Relay

smtp.google.com
No es Google Workspace completo

✔️ Hosting / cPanel

mail.dominio.com
SPF de hosting

🛡️ Validaciones de correo

- SPF
-OK → -all
-WARN → ~all, +all o ausente

DMARC
Política	Estado
No existe	WARN
p=none	WARN
p=quarantine + sp=none	WARN
p=quarantine + sp=quarantine	OK
p=reject (+ sp=reject)	OK
DKIM

OK si existe p=
WARN si no se detecta

🚨 Alertas automáticas

El script muestra alertas cuando detecta:

- Configuración mixta
 (ej. MX Microsoft 365 + SPF Hosting)
- Falta de DMARC
- Falta de SPF
- Posible problema de propagación (TTL)
- Posible split DNS o caché de red

⏱️ ¿Por qué puede tardar unos segundos?

Porque tooldomain:

- Consulta DNS en tiempo real
- Usa múltiples resolvers (fallback)
- Verifica PTR y ping
- No usa caché interna (por diseño)

Tiempo normal:

- 1–3 s dominio sano
- 3–7 s dominio con problemas

🎯 Uso recomendado

- Diagnóstico rápido de dominios
- Validación de registros de dominios
- Confirmar proveedor real de correo
- Detectar configuraciones incorrectas
- Evitar depender de herramientas web externas

🔮 Mejoras futuras (opcionales)

--fast (modo rápido)
--short (solo resumen)
--json (salida estructurada)
Caché local temporal
Detección automática de split DNS
