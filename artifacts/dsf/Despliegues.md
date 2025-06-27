# 🧾 Instructivo de Procedimientos Técnicos — Ualá

---

## 🔧 Gestión de Pods (Kubernetes)

```sh
kubectl get pod -n <namespace>
kubectl exec -it NOMBRE_DEL_POD_APP --namespace transact-dev -- sh
```

---

## 📁 Rutas de carpetas

**TAFJ:**  
```sh
cd /srv/Temenos/TAFJ/bin
```

**Class file:**  
```sh
cd /srv/Temenos/TAFJ/data/tafj/classes/com/temenos/t24
```

**Logs:**  
```sh
cd /shares/log
cd /shares/tafjud/como
```

**Jars:**  
```sh
cd /srv/Temenos/T24/Lib/L3lib
```

**Deployments folder:**  
```sh
cd /opt/jboss/wildfly/standalone/deployments/
```

---

## 🛠️ Herramientas de Base de Datos (DbTools)

**Login:**  
```sh
sh DBTools -u user2g -p Passw@rd1
```

**Crear usuario:**  
```sh
sh tUserMgnt --Add -u user2g -p Passw@rd1
```

---

## 🐞 Incidente EB.API no permite BASIC

### 🎟️ Ticket y descarga
[TSR-1032458](https://servicedesk.temenos.com/tickets/servicedesk/customer/portal/1/TSR-1032458)

---

## ⚙️ Procedimiento de corrección de campo EXTENSIBLE.CUSTOMISATION

1. Extraer el archivo `RESET_MARKER_ABC_Utility.zip`.
2. Copiar el `.class` en:  
   `%TAFJ_HOME%\data	afj\classes\com\Temenos\t24`
3. Ejecutar desde la consola de TAFJ:  
   ```sh
   sh tRun RESET.MARKER.NBI
   ```
4. Verificar que aparezca el mensaje: `Process Complete`.
5. Confirmar que el campo `EXTENSIBLE.CUSTOMISATION` del SPF esté en `NULL`.

---

## 🔍 Validación EB.API BASIC

1. Ejecutar `EB.API, EJEMPLO`
2. Ingresar una descripción cualquiera.
3. En **Protección**, ingresar: `none`.
4. En **Source Type**, ingresar: `Basic`.  
   No debería aparecer el error: `JCV Not allowed - JAVA Only`.

---

## 🧹 Eliminar registros en DBTools (si persiste el error)

> ⚠️ Verificar con Temenos las lineas antes de ejecutar.

1. Ingresar a DbTools.
2. Ejecutar:
   JED F.LOCKING JD.LOCKING.REC
   d 2
   d 2
   s
   x

---

## 💻 Accesos Web y APIs

### 🔗 Workbench UUX
[Acceso a Workbench](https://wbuux.dev.corebanking.uala.mx/wb-uux/)

---

### 👤 Creación de usuario en Workbench

**Endpoint:**  
`https://wbtools.dev.corebanking.uala.mx/wb-tools/api/v1.0.0/basicauth/identity`

**Configuración (POST):**
1. Authorization: `admin` / `admin`
2. Body → Raw (JSON):
```json
{
  "name": "WB User",
  "roles": [
    "developer",
    "release_manager",
    "WorkbenchAgent",
    "default-roles-dsfpackager"
  ],
  "email": "wbuser@temenos.com",
  "userName": "NOMBREUSER",
  "password": "PASSWORD"
}
```

---

### 📦 Despliegue de paquetes

**Endpoint:**  
`https://transact-qas.dev.corebanking.uala.mx/dsf-iris/api/v4.0.0/meta/dsfpackages/deploy?async=true`

**Configuración (POST):**
1. Authorization: `USER` / `PASSWORD`
2. Body: Binary (cargar paquete)
3. Send

---

### 📊 Verificar estado de paquete desplegado

**Endpoint:**  
Reemplazar el nombre del paquete según corresponda.  
`https://transact-qas.dev.corebanking.uala.mx/dsf-iris/api/v1.0.0/meta/dsfpackages/packageRecordHash?packages=Abc.Sector.Economico-1.0.0`

**Configuración (PUT):**
1. Authorization: `USER` / `PASSWORD` (Mismo Browser Transact Admin)
2. Body: None
3. Send
