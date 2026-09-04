# Plataforma de Gestion de Eventos y Conferencias
Bases de datos relacional que permite la gestion de eventos.

# Integrantes:
- Karol Yamile Palomino Prada      2243579
- Giselle Alejandra Vesga Romero   2243603
- Juan Sebastián Herrera Suárez    2243569
- Johan Stiveen Dueñas López  2243599
- Jose David Tarazona Díaz 2243566


# **Primera seccion: Conceptos importantes y relevantes en la temática:**
     
- **Jerarquía de Eventos y Sesiones:** Un evento no es un ente aislado. Suele tener sub-eventos, sesiones, talleres o paneles que ocurren en horarios específicos y lugares definidos.  
- **Gestión de Inventario y Aforo:** El control de capacidad es muy importante. Debes separar el aforo total del evento con el aforo de espacios específicos en salas y salones.  
- **Modelos de Precios y Entradas (Ticketing):** La relación entre "Entrada" y "Servicio" es vital. Un tipo de entrada por ejemplo "VIP" debe desbloquear acceso a servicios específicos como por ejemplo acceso al bufet.  
- **Trazabilidad de la Transacción:** Cada registro o compra debe estar vinculado a un usuario, un método de pago y un estado de validación asi se tiene un control.

Se puede estructurar con entidades principales como:

1. **Gestión de usuarios y roles:**  Un usuarios con ID, nombre, correo, tipo de usuario o rol  y demás datos relacionados de este y también está el rol que cumple en el evento con permisos especiales.  
2. **Definición de evento:** se necesita saber los datos del evento, así mismo del espacio y las sesiones   
3. **Entrada y servicios:**  debe tener información o datos como tipo de entrada, el servicio  y la entrada a este servicio.  
4. **Transacciones y asistencias:** cuenta con datos como entradas vendidas y el registro de ingreso y todos los datos específicos necesarios para cada uno.

   	
**(Datos Curiosos)**
- Gamificación: Uso de puntos, retos o tablas de clasificación para incentivar la interacción en la plataforma.  
- Uso de salas paralelas en sesiones pequeñas   
- Informes y métricas: Datos detallados sobre tiempos de conexión, sesiones más populares y nivel de participación.
- Sensores IoT son dispositivos físicos que detectan, miden y transmiten datos del mundo real hacia internet de forma automática y en tiempo real.
- Conteo por QR / NFC: método de registro y control de flujo basado en la acción del usuario, quien utiliza su teléfono móvil para interactuar con un código o un chip físico.
- Dashboard: interfaz gráfica que organiza, simplifica y muestra visualmente los datos recolectados por los sensores o los sistemas QR/NFC.

# **Segunda seccion: Tendencias actuales en dichos conceptos:**

- Hibridación y multi-ubicación: Integración de componentes presenciales y virtuales con transmisiones en vivo y espacios simultáneos.
- Control de aforo en tiempo real: Monitoreo exacto de la capacidad mediante IoT y códigos QR/NFC, apoyado en dashboards y alertas automáticas.
- Ticketing dinámico: Precios ajustables por demanda, promociones, ventas adicionales automáticas (upsell) y segmentación de usuarios.
- Transacciones seguras: Pagos rápidos y tokenizados, con validación instantánea y conciliación automática de los comprobantes.
- Gestión de roles y UX: Accesos unificados (SSO), paneles adaptados a cada perfil (staff, organizador), permisos detallados y auditoría de acciones.
- Gamificación y monetización: Sistema de puntos y recompensas canjeables diseñados para incentivar la interacción, con métricas vinculadas al CRM.
- Integraciones y APIs abiertas: Conexión ágil mediante webhooks con plataformas externas (CRM, streaming, accesos) para sincronizar datos al instante.
- Automatización operativa: Flujos de trabajo automáticos para check-in/out, asignación de asientos, reembolsos y notificaciones (email, SMS, push).
- Privacidad y cumplimiento normativo: Protección de la información, gestión de consentimientos de marketing y apego estricto a leyes de protección de datos (ej. GDPR).

# **Tercera seccion: Herramientas en el mercado**

**Tripleseat:**
Plataforma de gestión de eventos y CRM orientada a restaurantes, hoteles y centros de reuniones para controlar el ciclo de vida de un evento. Sus funciones principales incluyen:
CRM y Leads: Captura automática de clientes potenciales (SmartLeads) vinculados a una base de datos central.
Calendario centralizado: Visualización de reservas filtrada por sede, sala y estado (tentativo, confirmado, cancelado).
Documentos y contratos: Generación dinámica y almacenamiento en línea de propuestas, contratos y órdenes de eventos (BEOs).
Gestión de pagos: Procesamiento de depósitos y cobros con recordatorios automáticos.

**Momentus Technologies:**
Sistema EBMS multi-módulo y robusto, diseñado para recintos de gran magnitud como estadios y centros de convenciones. Sus características clave abarcan:
CRM y reserva de espacios: Gestión de clientes y calendarios enfocados en optimizar la ocupación de las salas.
Asistentes y exhibiciones: Herramientas para el registro de usuarios, expositores y stands en ferias o convenciones.
Módulo financiero empresarial: Facturación y pagos avanzados mediante un modelo de datos por módulos desacoplables.
Analítica y portales web: Reportes en tiempo real sobre ingresos y uso de espacios, complementado con sitios web para la inscripción y pago de asistentes.
