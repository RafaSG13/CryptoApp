# CryptoApp

CryptoApp es un proyecto con el cual exploro diferentes elementos de SwiftUI.
Este proyecto comenzó como parte de un curso online, sin embargo, he hecho modificaciones buscando siempre explorar nuevos componentes, conceptos e ideas.
A continuación, dejo las fuentes del curso y la web del autor del curso del que partio esta pequeña aplicacion.

## Fuentes del Curso

- [Curso en YouTube](https://www.youtube.com/watch?v=TTYKL6CfbSs&list=PLwvDm4Vfkdphbc3bgy_LpLRQ9DDfFGcFu)
- [Web del autor](https://www.swiftful-thinking.com)

## Descripción del Proyecto

CryptoApp es una aplicación que proporciona información sobre criptomonedas utilizando SwiftUI para la interfaz de usuario. Este proyecto es una excelente oportunidad para aprender y aplicar diferentes conceptos de SwiftUI, como vistas, transiciones, navegación y más.

## Características

- Visualización de estadísticas de criptomonedas.
- Búsqueda de criptomonedas.
- Lista de criptomonedas.
- Lista de portafolio de criptomonedas.
- Transiciones animadas entre vistas.

## Instalación

1. Clona el repositorio:
    ```bash
    https://github.com/RafaSG13/CryptoApp.git
    ```

2. Abre el proyecto en Xcode:
    ```bash
    cd CryptoApp
    open CryptoApp.xcodeproj
    ```

3. Ejecuta la aplicación en un simulador o dispositivo.


## Estructura del Proyecto
El proyecto sigue una arquitectura basada en MVVM, con un ViewModel por View. En este caso, como los respectivos viewModel requerían de los mismos datos, he implementado un repository, encargado de gestionar las diferentes fuentes de datos del proyecto, desde la informacion superficial de las monedas, hasta las imagenes de las mismas y la informacion del mecado.
<img width="736" alt="Arquitectura de CryptoApp" src="https://github.com/RafaSG13/CryptoApp/assets/58252921/1c752cf1-f449-4b9c-bc31-5fe69004e3cc">

![simulator_screenshot_4E702007-CE1B-4B72-AE08-9574A78BB46C](https://github.com/RafaSG13/CryptoApp/assets/58252921/fa4c278c-7b92-4509-ad09-296ed01d8a30)
![simulator_screenshot_E1632094-CB7C-4E80-AD99-FCDCD61FCCC1](https://github.com/RafaSG13/CryptoApp/assets/58252921/8a9f4ebf-c321-4cc1-9851-6e96e5ca009b)
![simulator_screenshot_65F7963D-F94E-4951-9EC0-A4DC7ABDDB5B](https://github.com/RafaSG13/CryptoApp/assets/58252921/79d2f5d7-837d-4296-9f66-ad97712671e3)


## Contacto

Para cualquier pregunta o sugerencia, por favor contacta a [rafasrrg13@gmail.com].

---

¡Gracias por visitar CryptoApp y feliz aprendizaje con SwiftUI!
