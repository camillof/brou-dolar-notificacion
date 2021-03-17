
# Verificador dolar e-brou con notificaciones 🇺🇾

Proyecto personal, un poco *bastante* verde aún, que comenzó en un principio con el fin de ser una API para un dashboard, que iba a estar ejecutando trabajos asíncronos. Luego derivó en algo para que me llegaran notificaciones al cel cuando la cotización del dólar cambiaba. Para esto consulto la web de e-brou (de una forma muy elemental) cada cierto intervalo de tiempo, usando IFTTT para las notificaciones.

![Ejemplo notificación](notification_example.png?raw=true "Ejemplo")

## Instalación

```sh
bundle install
rails db:setup
```

## Usos

- ### Local background

  Se puede usar de forma local ejecutándose en el fondo, gracias a la gema [rufus-scheduler](https://github.com/jmettraux/rufus-scheduler). Los trabajos agendados (`Handlers`) son ejecutados segun su configuración.

  Con los valores por defecto, se ejecutará el `ExchangeRateHandler` cada 30 minutos.

  ```sh
  IFTTT_ENDPOINT=your_endpoint IFTTT_KEY=your_key rails s
  ```

  Y el log se vería algo así:
  ```
    I, [2021-03-01T00:00:00.555202 #68666]  INFO -- : Initializing scheduler
    I, [2021-01-01T00:00:00.687702 #68666]  INFO -- : ExchangeRateHandler scheduled to run every 30m
    I, [2021-03-01T00:30:00.344803 #69278]  INFO -- : Checking dolar value
    I, [2021-03-01T00:30:01.513317 #69278]  INFO -- : Current value 45.2
    I, [2021-03-01T00:30:02.522944 #69278]  INFO -- : Dolar changed, sending event
  ```

  Se puede también levantar el server sin ejecutar el scheduler pasándole la variable de ambiente `RUN_SCHEDULER=false`

- ### Task

  También podemos ejecutar el `ExchangeRateHandler` de manera manual por única vez:
  ```sh
  IFTTT_ENDPOINT=your_endpoint IFTTT_KEY=your_key rake handler:check_exchange_rate
  ```
- ### Heroku

  Asi es como lo tengo en uso actualmente, con un free dyno y usando [Heroku Scheduler](https://devcenter.heroku.com/articles/scheduler) que te permite agendar comandos cada cierto tiempo. En este caso simplemente ejecuta el handler descripto en [Task](###task)

## API

Tiene también una API básica, donde se puede consultar el histórico de cotizaciones y la configuración de los handlers actuales:
- api/v1/historic_exchange_rates
- api/v1/handlers

Ejemplo:
- https://brou-dolar-notificacion.herokuapp.com/api/v1/historic_exchange_rates
- https://brou-dolar-notificacion.com/api/v1/handlers

## Otros

**Cómo detener las notificaciones**

Los `Handler` tienen un campo `notifications_enabled` que se puede deshabilitar si no quiero usar la funcionalidad de notificaciones
