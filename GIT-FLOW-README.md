# Flujo de Git - TestApp4

## 📋 Descripción
Este documento describe el flujo de desarrollo Git utilizado en el proyecto TestApp4. Se basa en el modelo Git Flow, donde cada funcionalidad (feature) se desarrolla en una rama separada, se integra a la rama `develop` y finalmente a `main` para releases.

## 🏗️ Estructura de Ramas
- **`main`**: Rama de producción. Contiene código estable y listo para release.
- **`develop`**: Rama de integración. Contiene el código más reciente en desarrollo.
- **`feature/*`**: Ramas para desarrollo de nuevas funcionalidades (ej: `feature/networking`, `feature/mapas`).

## 🚀 Flujo de Desarrollo

### 1. **Inicio de una Nueva Feature**
   - Crear una rama `feature` desde `develop`:
     ```bash
     git checkout develop
     git pull origin develop  # Asegurarse de tener la última versión
     git checkout -b feature/nombre-del-modulo
     ```
   - Ejemplo: `git checkout -b feature/mapas`

### 2. **Desarrollo en la Rama Feature**
   - Realizar commits frecuentes durante el desarrollo:
     ```bash
     git add .
     git commit -m "Descripción del cambio realizado"
     ```
   - Mantener la rama actualizada con `develop` si es necesario:
     ```bash
     git checkout develop
     git pull origin develop
     git checkout feature/nombre-del-modulo
     git merge develop  # Resolver conflictos si existen
     ```

### 3. **Finalización de la Feature**
   - Una vez completada la funcionalidad, hacer un commit final:
     ```bash
     git add .
     git commit -m "Complete feature: descripción completa de la funcionalidad implementada"
     ```

### 4. **Push de la Rama Feature a Remoto**
   - Subir la rama al repositorio remoto:
     ```bash
     git push -u origin feature/nombre-del-modulo
     ```
   - Esto asegura que la rama esté disponible en remoto para revisión o backup.

### 5. **Integración a Develop**
   - Cambiar a `develop` y fusionar la feature:
     ```bash
     git checkout develop
     git pull origin develop  # Actualizar develop
     git merge feature/nombre-del-modulo
     ```
   - Resolver cualquier conflicto y hacer commit si es necesario.
   - Push de los cambios a remoto:
     ```bash
     git push origin develop
     ```

### 6. **Integración a Main (Release)**
   - Cuando `develop` esté listo para release, fusionar a `main`:
     ```bash
     git checkout main
     git pull origin main  # Actualizar main
     git merge develop
     ```
   - Push a remoto:
     ```bash
     git push origin main
     ```

### 7. **Creación de Tag**
   - Crear un tag para marcar el release:
     ```bash
     git tag -a v1.0.0 -m "Release v1.0.0: Descripción del release"
     ```
   - Push del tag a remoto:
     ```bash
     git push origin v1.0.0
     ```

### 8. **Aumento del Número de Versión**
   - Actualizar el número de versión en el proyecto (en `Info.plist` o `project.pbxproj`):
     - Abrir `TestApp4.xcodeproj` en Xcode.
     - Ir a Project Settings > General > Version y Build.
     - Incrementar el número de versión (ej: de 1.0.0 a 1.1.0).
   - Hacer commit de los cambios de versión:
     ```bash
     git add .
     git commit -m "Bump version to 1.1.0"
     git push origin main
     ```

## 📝 Notas Importantes
- **Commits Descriptivos**: Usar mensajes claros y en inglés para commits (ej: "Add Pokemon list view with VIPER pattern").
- **Pull Requests**: Para proyectos colaborativos, crear PR desde `feature/*` a `develop`.
- **Versionado Semántico**: Usar formato `vMAJOR.MINOR.PATCH` para tags (ej: v1.0.0).
- **Resolución de Conflictos**: Siempre resolver conflictos localmente antes de push.
- **Backup**: Push frecuente a remoto para evitar pérdida de trabajo.

## 🔄 Ejemplo Completo para una Feature
```bash
# 1. Crear rama
git checkout develop
git pull origin develop
git checkout -b feature/mapas

# 2. Desarrollar y commits
git add .
git commit -m "Implement MapKit integration"
# ... más commits ...

# 3. Commit final
git add .
git commit -m "Complete Mapas module with VIPER and MapKit"

# 4. Push feature
git push -u origin feature/mapas

# 5. Merge a develop
git checkout develop
git pull origin develop
git merge feature/mapas
git push origin develop

# 6. Merge a main (cuando sea release)
git checkout main
git pull origin main
git merge develop
git push origin main

# 7. Crear tag
git tag -a v1.1.0 -m "Release v1.1.0: Add Mapas module"
git push origin v1.1.0

# 8. Aumentar versión en Xcode y commit
git add .
git commit -m "Bump version to 1.2.0"
git push origin main
```

## 📊 Estado Actual del Proyecto
- **Features Completadas**: UI Components, Album, Persistence, Networking, MainView
- **En Desarrollo**: Mapas
- **Pendiente**: WebView
- **Último Tag**: v1.0.0 (estimado, verificar en repo)

Para más detalles sobre el progreso, consulta `README.md`.</content>
<parameter name="filePath">/Users/joeldelgado/Documents/TutorialUIKit/TestApp4/GIT-FLOW-README.md