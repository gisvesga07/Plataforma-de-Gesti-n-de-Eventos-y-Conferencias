Informe  | Base de datos relacionales

Estudiantes:   
 

Karol Yamile Palomino   
Giselle Alejandra Vesga   
Johan Stiveen Dueñas Lopez  
Jose David Tarazona Diaz  
Juan Sebastián Herrera Suarez

   

Docente: 

 Nury Farelo Velasquez

Universidad Industrial de Santander   
Ingeniería en Ciencias de Datos   
2026

1. **Conceptos importantes y relevantes en la temática:**  
     
- **Jerarquía de Eventos y Sesiones:** Un evento no es un ente aislado. Suele tener sub-eventos, sesiones, talleres o paneles que ocurren en horarios específicos y lugares definidos.  
- **Gestión de Inventario y Aforo:** El control de capacidad es crítico. Debes separar el aforo total del evento del aforo de espacios específicos (salas/salones).  
- **Modelos de Precios y Entradas (Ticketing):** La relación entre "Entrada" (TickGet) y "Servicio" es vital. Un tipo de entrada (ej. "VIP") debe desbloquear acceso a servicios específicos (ej. "Acceso al buffet", "Acceso a zona premium").  
- **Trazabilidad de la Transacción**: Cada registro o compra debe estar vinculado a un usuario, un método de pago y un estado de validación (para el control de ingreso).  
- **Se puede estructurar con entidades principales como:**  
1. Gestión de usuarios y roles:  Un usuarios con ID, nombre, correo, tipo de usuario o rol  y demás datos relacionados de este y también está el rol que cumple en el evento con permisos especiales.  
2. Definición de evento: se necesita saber los datos del evento, así mismo del espacio y las sesiones   
3. Entrada y servicios:  debe tener información o datos como tipo de entrada, el servicio  y la entrada a este servicio.  
4. Transacciones y asistencias el cual cuenta con datos como entradas vendidas y el registro de ingreso y todos los datos específicos necesarios para cada uno.

   	

- **Gamificación**: Uso de puntos, retos o tablas de clasificación para incentivar la interacción en la plataforma.  
- el uso de salas paralelas en sesiones pequeñas   
- **Informes y métricas**: Datos detallados sobre tiempos de conexión, sesiones más populares y nivel de participación. 

**2\. Tendencias actuales en dichos conceptos:**

- **Hibridación y multi-ubicación**: eventos con componentes presenciales y virtuales, sesiones paralelas transmitidas en vivo y espacios virtuales simultáneos  
- **Gestión de aforo en tiempo real**: sensores IoT, conteo por QR/NFC y dashboards que actualizan capacidad por sala y alertas automáticas para límites y redistribución de público.  
- **Ticketing dinámico y precios flexibles**: precios por demanda, early-bird, códigos promocionales personalizados, upsell automático de servicios (paquetes VIP, workshops), y segmentación por perfil del usuario.  
- **Transacciones seguras y flujo de verificación**: tokenización de tarjetas (PCI compliant), pago en un click, comprobantes electrónicos, estados de validación en tiempo real y conciliación automática con pasarelas.  
- **Experiencia de usuario y gestión de roles más integrada:** SSO/OAuth, paneles según rol (organizador, expositor, staff), permisos más finos y auditoría de acciones por rol.  
- **Gamificación avanzada ligada a monetización:** puntos, retos, recompensas canjeables por servicios o upgrades; leaderboard en tiempo real y métricas de engagement integradas al CRM.  
- **Integraciones y APIs abiertas:** ecosistema de integraciones (streaming, CRM, marketing automation, control de acceso) con webhooks y contratos API para sincronización de eventos, ventas y asistentes.  
- **Automatización operativa:** workflows para check-in/checkout, reembolsos, asignación automática de asientos, y orquestación de notificaciones (email/SMS/push) según estados de compra o cambios de agenda.  
- **Privacidad y cumplimiento reforzado:** anonimización, consentimiento granular para marketing, retención mínima de datos y cumplimiento regional (GDPR, LOPD/leyes locales).


**3\. HERRAMIENTAS EN EL MERCADO**

1. **Tripleseat:** Es una plataforma que usualmente es utilizada para la gestión de eventos y CRM  es frecuentemente usada por los restaurantes, hoteles y centros de reuniones para manejar eficientemente como es el desarrollo y ciclo de vida de un evento.  
   1. **CRM de contactos y leads (SmartLeads):** captura automática de clientes potenciales desde formularios web y los integra a una base de datos de contactos.  
   2. **Calendario centralizado de reservas:** muestra eventos filtrables por sede, sala o estado (tentativo, confirmado, cancelado), lo que implica una entidad Evento con estado y relación N:1 con Sala/Espacio.  
   3. **Documentos y contratos:** propuestas, contratos y BEOs (Banquet Event Orders) generados dinámicamente y almacenados en línea, vinculados al evento.  
   4. **Pagos**: procesamiento de depósitos y pagos, con recordatorios automáticos — sugiere entidad Pago/Factura ligada a Evento y Cliente.  
2. **Momentus Technologies:** Es una solución de la EBMS (Event Business Management System) lo que proporciona un mayor alcance para todo por eso usualmente es usado por los centros de convenciones de gran magnitud, estadios y arenas. Esto se logra ya que el proceso es más robusto y multi-módulo a diferencia del Tripleseat.  
   1. **CRM y reservas de espacios:** gestión de información de clientes y reservas de salas/recintos, con vista de calendario para identificar huecos y optimizar la ocupación.  
   2. **Registro de asistentes y gestión de exhibiciones:** propio de ferias/convenciones, con entidades adicionales como Asistente, Stand/Exhibición, Expositor.  
   3. **Módulo financiero:** facturación y pagos integrados a nivel empresarial (muchos clientes empiezan solo con el módulo de eventos y luego añaden el financiero, lo que muestra que el modelo de datos está diseñado en módulos desacoplables).  
   4. **Reportes y analítica en tiempo real:** sobre uso de espacios, ingresos y rendimiento.  
   5. **Sitios web y portal:** para inscripciones y pagos en línea de asistentes.