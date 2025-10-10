# Contexto y Reglas del Proyecto iOS para GitHub Copilot

**Rol:** Eres un asistente de codificación experto en **Swift**, **UIKit**, y el desarrollo de aplicaciones para **iOS**.

**Objetivo:** Ayudarme a construir la aplicación **TestApp**, siguiendo la arquitectura **VIPER**, los principios **SOLID** y los estándares de código limpio detallados.

---

## Directrices de Desarrollo y Estándares de Código

Debes adherirte rigurosamente a las siguientes directrices en todo el código generado:

1.  **Arquitectura:** Utiliza la arquitectura **VIPER** (View, Interactor, Presenter, Entity, Router) para la estructura de cada *feature*.
2.  **Tecnología:**
    * El proyecto es **UIKit** con un target mínimo de **iOS 12**.
    * **Elimina** todo rastro de funciones que estén disponibles únicamente para **SwiftUI**.
    * Utiliza el **Storyboard** de Xcode para el entorno de desarrollo.
3.  **Principios de Diseño y Código Limpio:** Aplica los principios **SOLID** y las siguientes normas:
    * **Nombres Significativos**.
    * **Funciones Pequeñas y Específicas**.
    * **Comentarios Útiles** (no redundantes).
    * **DRY** (Don't Repeat Yourself).
    * **KISS** (Keep It Simple, Stupid).
    * Aplica la **Ley de Deméter** (Principio de Conocimiento Mínimo) y **Composición sobre Herencia**.
4.  **Comentarios:** Comenta los bloques de código importantes en **inglés y español**.
5.  **GitFlow:** El flujo de trabajo sigue un **GitFlow** organizado.
    * Cada *feature* se implementará en una **rama aparte**.
    * Al terminar, la *feature* se integra a la rama **`Develop`** y de ahí a la rama **`Main`**.
    * Se deben usar **etiquetas de Git (tags)** para denotar las versiones en la rama **`main`** (ej: `v0.1`).

---

## Features a Desarrollar

### Feature 1: Vista Principal (Tap Bar)

* Implementar un **Tap Bar Controller** con dos secciones: **Features** y **Perfil**.
* **Sección Features:** Título largo y una **tabla**.
    * La tabla contendrá celdas de diferentes tamaños, dirigiendo a las vistas de los features subsecuentes a través de un **navigation controller**.
    * Las celdas serán una **card** con bordes redondeados, sombra, un *image view*, un *label* para el título y otro para la descripción.
* **Sección Perfil:** Mostrar *image view* por defecto, **nombre, edad y correo electrónico**.
    * Botón "**editar**" que muestra un **formulario modal**.
    * El formulario permite seleccionar una imagen desde la **galería** y editar nombre, edad, y correo (campos pre-llenados).
    * Botón "**guardar**" que hace *dismiss*, notifica a la vista anterior de los cambios mediante un **delegado**, y actualiza los datos.

### Feature 2: UIComponents

* Crear un **view controller** que lista los siguientes componentes dentro de un **UIScrollView**:
    1.  **Label**.
    2.  **TextView:** No editable. Debe incluir un **attributed text** con al menos dos propiedades y un **hipervínculo** "Click aquí" que abra la página inicial de Google en el navegador.
    3.  **TextField**.
    4.  **Button:** Al hacer *tap*, muestra una **alerta nativa** con el texto ingresado en el *textfield*.
    5.  **Switch:** Modifica si el *TextField* anterior puede ser **editado o no**.
    6.  **Segmented Control** ("Nombre" y "Edad"): Valor por defecto "Nombre". Al cambiar la opción, el *TextField* borra el texto y cambia el tipo de teclado (alfanumérico para "Nombre", numérico para "Edad").
    7.  **ImageView** con una imagen por default.

### Feature 3: Album

* La mitad superior de la vista contendrá un **image view**.
* La mitad inferior contendrá un **collection view** con **scroll horizontal**.
* Mostrar un máximo de **8 imágenes** en el *collection view*.
* Al seleccionar una imagen, se debe mostrar en grande en el *image view* superior.

### Feature 4: Persistence (KeyChain y UserDefaults)

* **KeyChain:** Formulario para almacenar y leer **usuario** y **contraseña** en el **key chain**.
    * El *textfield* de contraseña debe tener **texto seguro** habilitado y un botón para **mostrar y ocultar** la contraseña.
    * Botón "**leer**": Busca y pinta los valores guardados. Si no los encuentra, muestra una alerta.
    * Botón "**guardar**": Almacena los textos en el *key chain*.
* **User Defaults:** Tres **switch** cuyo valor debe **recordarse** cada que se cierra y se vuelve a abrir la app.

### Feature 5: Networking (Lottie y API)

* **Dependencia:** Agregar el *framework* **Lottie** (recomendado Swift Package Manager).
* **Animación de Carga:** Crear una clase/función para **bloquear la vista** de cualquier `UIViewController` y mostrar la animación de Lottie mientras se ejecutan tareas en segundo plano (ej: llamada a API).
* **Lógica de la Vista:** Controller con una **tabla**.
    * Al entrar, la tabla estará vacía, se mostrará la animación de Lottie y se realizará una llamada a una **API pública gratuita** (ej: `https://pokeapi.co/`).
    * Al concluir la llamada, se quitará la animación y se mostrarán los datos recibidos en la tabla.
    * Crear una clase para peticiones HTTP y modelos para mapear los JSON a objetos.
    * La tabla debe poder **borrar celdas** mediante un *swipe action*.
    * **Confirmación:** La eliminación de la celda se confirmará con un **`UIAlertController`** con estilo **`.actionSheet`**.

### Feature 6: MapKit

* Vista con un **mapa**, dos **textfields** (para latitud y longitud) y un **botón** ("mostrar").
* Al presionar el botón:
    * **Validar** que los campos tengan texto válido y notificar el error si no lo tienen.
    * Si es válido, poner un **pin** en el mapa y hacer **zoom** a la zona.

### Feature 7: Web View

* Implementar una vista que cargue una página de internet mediante un **web view**.

---

## Features Opcionales (Prioridad Baja)

Considera implementar las siguientes *features* para aumentar la calidad del proyecto:

* Implementar **Localized Strings** (español como lenguaje predefinido).
* Implementar **sonidos** (ej: un sonido de *click* al seleccionar *features*).
* Agregar la dependencia **IQKeyboard** para que los *textfields* no se tapen al mostrar el teclado.
* Implementar autenticación **Touch ID o Face ID** para realizar cambios en perfil y leer contraseña del Key Chain.
* Agregar una **fuente custom**.
* Integrar alguna dependencia de **Firebase** como Remote Config.
