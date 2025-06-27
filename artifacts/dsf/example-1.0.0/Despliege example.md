# 🧾 Instructivo de Procedimientos Técnicos despliegue paquete example — Ualá

---

## 🔧 Gestión de Pods (Kubernetes)

```sh
kubectl get pod -n <namespace>
kubectl exec -it NOMBRE_DEL_POD_APP --namespace transact-dev -- sh
```

---

## 📁 Rutas de carpetas


**Jars:**  
```sh
cd /srv/Temenos/T24/Lib/L3lib
```


---

## 💻 Accesos Web y APIs

### 🔗 Workbench UUX
[Acceso a Workbench](https://wbuux.dev.corebanking.uala.mx/wb-uux/)


---

### 📦 Despliegue de paquetes

**Endpoint:**  
Reemplazar qas por el ambiente a desplegar.  

`https://transact-qas.dev.corebanking.uala.mx/dsf-iris/api/v4.0.0/meta/dsfpackages/deploy?async=true`

**Configuración (POST):**
1. Authorization: `USER` / `PASSWORD` (Mismo user admin que Browser Transact )
2. Body: Binary (cargar paquete)
3. Send

---

### 📊 Verificar estado de paquete desplegado

**Endpoint:**  
Reemplazar qas por el ambiente a desplegar.  
Reemplazar el nombre del paquete según corresponda.  
`https://transact-qas.dev.corebanking.uala.mx/dsf-iris/api/v1.0.0/meta/dsfpackages/packageRecordHash?packages=Abc.Sector.Economico-1.0.0`

**Configuración (PUT):**
1. Authorization: `USER` / `PASSWORD` 
2. Body: None
3. Send
