# MonsterGeek

Un nuevo proyecto Flutter diseñado para gestionar el inventario y las ventas en línea de Monster Geek Coatzacoalcos. Este proyecto utiliza **FlutterFire** para integrar servicios de Firebase como autenticación, gestión de bases de datos y más.

## Características
- Gestión de Inventario:
  - Agregar, eliminar, editar y buscar productos.
  - Categorizar productos (por ejemplo: Autos a Escala, Figuras, Cómics, etc.).
- Tienda en Línea:
  - Registro y autenticación de usuarios.
  - Navegar y filtrar productos.
  - Funcionalidad de carrito de compras.
  - Métodos de pago (transferencia y tarjeta).
- Información de Servicios:
  - Detalles sobre servicios adicionales como Cafetería, Impresión 3D, Sublimación y Ensamble de PCs.
- Acceso Remoto:
  - Aplicación basada en la web accesible desde múltiples dispositivos.

## Primeros Pasos

Este proyecto es un punto de partida para una aplicación Flutter. A continuación, algunos recursos para comenzar:

- [Lab: Escribe tu primera aplicación Flutter](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Ejemplos útiles de Flutter](https://docs.flutter.dev/cookbook)

Para más ayuda con el desarrollo en Flutter, consulta la
[documentación en línea](https://docs.flutter.dev/), que incluye tutoriales, ejemplos y referencias de la API.

## Prerrequisitos

Antes de ejecutar el proyecto, asegúrate de lo siguiente:

1. **Flutter Instalado:**
   - Instala el SDK de Flutter desde [el sitio oficial de Flutter](https://flutter.dev/docs/get-started/install).

2. **Configuración de Firebase:**
   - Vincula el proyecto a una cuenta de Firebase.
   - Configura `google-services.json` (Android) y `GoogleService-Info.plist` (iOS).

3. **Dependencias:**
   - Ejecuta `flutter pub get` para instalar todos los paquetes requeridos.

## Instalación

1. Clona el repositorio:
   ```bash
   git clone <url-del-repositorio>
   cd monstergeek
   ```

2. Instala las dependencias:
   ```bash
   flutter pub get
   ```

3. Ejecuta la aplicación:
   ```bash
   flutter run
   ```

## Servicios de Firebase Utilizados
- **Autenticación:** Para el inicio de sesión y registro de usuarios.
- **Cloud Firestore:** Para gestionar el inventario y los datos de usuarios.
- **Firebase Storage:** Para manejar archivos multimedia, como imágenes de productos.

## Contribución

1. Haz un fork del repositorio.
2. Crea una nueva rama para tu funcionalidad:
   ```bash
   git checkout -b nombre-de-la-funcionalidad
   ```
3. Confirma tus cambios:
   ```bash
   git commit -m "Descripción de la funcionalidad"
   ```
4. Sube los cambios a la rama:
   ```bash
   git push origin nombre-de-la-funcionalidad
   ```
5. Envía un pull request.

## Licencia

Este proyecto está licenciado bajo la Licencia de la universidad veracruzana.
