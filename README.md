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

<img width="500" alt="Arquitectura de CryptoApp" src="https://github.com/RafaSG13/CryptoApp/assets/58252921/1c752cf1-f449-4b9c-bc31-5fe69004e3cc">

## Resultados

|                 List                 |                 Edit Portfolio                  |                 Coin Detail                 |
|:------------------------------------:|:-----------------------------------------------:|:-------------------------------------------:|
| <img width="250" src="https://github.com/RafaSG13/CryptoApp/assets/58252921/b51458b7-9fab-4b20-ae80-cd348ce649ba"> | <img width="250" src="https://github.com/RafaSG13/CryptoApp/assets/58252921/e31aba55-76b8-4900-bd6a-2b5c1b107911"> | <img width="250" src="https://github.com/RafaSG13/CryptoApp/assets/58252921/a019a20a-b442-4d08-9bd6-0e7115e2295b"> |

## Contacto

Para cualquier pregunta o sugerencia, por favor contacta a rafasrrg13@gmail.com.

---

¡Gracias por visitar CryptoApp y feliz aprendizaje con SwiftUI!
