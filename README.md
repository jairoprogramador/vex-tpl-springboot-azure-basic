# Tu Infraestructura como Plantilla, Potenciada por fastDeploy

**Convierte tus despliegues en un proceso predecible, repetible y agnóstico a la tecnología. `mydeploy` no es solo un repositorio; es el blueprint para la excelencia en DevOps, diseñado para ser un motor de referencia para `fastDeploy`.**

---

## ¿Qué es `mydeploy`?

`mydeploy` es una plantilla de despliegue que estandariza y automatiza el proceso de llevar un microservicio Java a un cluster de Azure Kubernetes Service (AKS). Pero su verdadero poder reside en su diseño: una arquitectura de "infraestructura como plantilla" que te permite abstraer la complejidad y centrarte en lo que realmente importa: el código.

Este repositorio es la implementación de referencia para [fastDeploy](https://github.com/jairoprogramador/fastdeploy), una herramienta CLI que consume plantillas como esta para orquestar despliegues complejos con comandos simples e intuitivos.

## La Filosofía: Infraestructura como Plantilla

Olvídate de los scripts frágiles y los `READMEs` de 100 pasos. La filosofía detrás de `mydeploy` es simple pero poderosa:

> **Define tu proceso de despliegue una vez. Ejecútalo miles de veces, en cualquier entorno, sin fricción.**

Centralizamos toda la lógica de despliegue —desde la verificación de herramientas hasta el aprovisionamiento de infraestructura y el despliegue final— en una estructura de pasos (`steps`) y entornos (`environments`) clara y reutilizable.

## ✨ Características que te Empoderan

*   **🚀 Despliegues Agnósticos a la Tecnología:** Aunque este ejemplo se centra en Java y AKS, la estructura de `steps` y `commands.yaml` es universal. ¿Necesitas desplegar Node.js en AWS? ¿O un servicio de Python en Google Cloud? Simplemente adapta los comandos. El framework ya está aquí.
*   **⚙️ Orquestación por Pasos (Steps):** El directorio `steps` divide el despliegue en fases lógicas y numeradas (`01-test`, `02-supply`, etc.). Cada paso es un subdirectorio autocontenido, lo que facilita la comprensión, el mantenimiento y la depuración del flujo.
*   **📄 Comandos Declarativos (`commands.yaml`):** Dentro de cada paso, el archivo `commands.yaml` define las acciones a ejecutar. Cada comando es un objeto con:
    *   `name`: Un verbo en infinitivo que describe la acción.
    *   `description`: Una explicación clara de lo que hace el comando.
    *   `cmd`: El comando de shell a ejecutar.
    *   `workdir`: (Opcional) El directorio de trabajo para la ejecución.
*   **✅ Validación y Captura de Salidas (`outputs`):** La sección `outputs` es donde la magia ocurre.
    *   **Validación de Éxito (`probe`):** Define una expresión regular para validar que la salida de un comando es la esperada. Si no coincide, el despliegue falla. ¡Adiós a los falsos positivos!
    *   **Creación Dinámica de Variables:** ¿Necesitas el ID de un recurso creado por Terraform o el nombre de un servidor? Captura valores de la salida de un comando usando grupos en tu expresión regular `probe` y asígnalos a una nueva variable. Estas variables estarán disponibles en los pasos posteriores.
*   **🌐 Gestión de Entornos (`environments.yaml`):** Define tus entornos (`sandbox`, `staging`, `production`) en un único archivo. `fastDeploy` utilizará esta configuración para dirigir los despliegues y aplicar las variables correctas.
*   **🔒 Variables por Entorno (`variables/`):** Gestiona tus configuraciones específicas de cada entorno de forma segura y organizada. El directorio `variables` contiene subdirectorios por cada entorno, permitiéndote mantener, por ejemplo, `deploy.yaml` con valores diferentes para `prod` y `sand`.
*   **📝 Plantillas Dinámicas (`templates`):** La clave para la reutilización. Define archivos (`Dockerfile`, `deployment.yaml`, etc.) con placeholders para tus variables. La directiva `templates` en un comando le indica a `fastDeploy` que reemplace las variables en esos archivos justo antes de ejecutar el comando, adaptándolos al entorno y al contexto del despliegle.

## ¿Cómo Funciona con `fastDeploy`?

`fastDeploy` es el motor que da vida a esta plantilla. Cuando un desarrollador ejecuta `fd deploy sand`:

1.  **Clona `mydeploy`:** `fastDeploy` clona este repositorio en segundo plano.
2.  **Lee la Configuración:** Analiza `environments.yaml`, los `steps` y los `variables` correspondientes al entorno `sand`.
3.  **Ejecuta los Pasos en Orden:**
    *   Comienza con `01-test`, ejecutando los comandos de `commands.yaml`.
    *   Valida las salidas con `probe`.
    *   Captura nuevas variables desde los `outputs`.
    *   Procesa las plantillas (`templates`) si se especifican.
    *   Continúa con `02-supply`, `03-package`, y así sucesivamente, pasando las variables generadas entre pasos.
4.  **Reporta el Resultado:** Informa al usuario si el despliegue fue un éxito o si falló en algún punto, proporcionando contexto claro.

## Requisitos de Plataforma (ACR Cache / Docker Hub)

El paso `03-package` construye la imagen con `az acr build`, que descarga las imágenes
base (`maven`, `eclipse-temurin`) desde Docker Hub. Para evitar el rate limit anónimo
(`toomanyrequests`), esta plantilla usa **ACR Cache (pull-through) autenticado**:

*   `02-supply` (`terraform/shared/acr_cache.tf`) provisiona un Key Vault, un
    `credential_set` y una `cache_rule` (`docker.io/library/*` → `library/*`) sobre un ACR
    **SKU Standard** (Cache no funciona en Basic).
*   El `Dockerfile` referencia `${var.azure_container_registry_login_server}/library/...`
    en lugar de Docker Hub directo (el `FROM` se interpola vía `templates`).

Esto requiere dos secretos **provistos por la plataforma Vex**, no por el usuario:

| Variable Terraform | Origen |
|---|---|
| `dockerhub_username` | Inyectada como `TF_VAR_dockerhub_username` por el backend del portal |
| `dockerhub_token`    | Inyectada como `TF_VAR_dockerhub_token` (token read-only de una cuenta Docker Hub de Vex) |

**Convenio de opt-in:** la plataforma inyecta estas `TF_VAR_*` en todos los despliegues;
un pipeline las usa solo si **declara** las variables `dockerhub_username`/`dockerhub_token`
en su `variables.tf` (Terraform ignora las `TF_VAR_*` no declaradas). Pipelines que no
empaquetan vía ACR simplemente no las declaran.

## Empieza a Construir tu Propia Plantilla

Usa `mydeploy` como punto de partida. Fórkalo, adáptalo a tus tecnologías y empieza a construir una cultura de despliegues estandarizados en tu organización.

**Con `mydeploy` y `fastDeploy`, la infraestructura deja de ser un cuello de botella y se convierte en una ventaja competitiva.**
