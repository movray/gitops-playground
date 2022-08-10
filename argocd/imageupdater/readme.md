# ArgoCD ImageUpdater

---
### FYI: ImageUpdater eventuell ab 2.5 in ArgoCD 
https://argo-cd.readthedocs.io/en/stable/roadmap/#merge-argo-cd-image-updater-into-argo-cd

---
**Einschränkungen:** Es können nur Images geupdated werden die über Helm oder Kustomize bereitgestellt sind

---


### Es gibt 2 Möglichkeiten ArgoCD zu installieren:

1. In das gleiche Cluster:

``kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj-labs/argocd-image-updater/stable/manifests/install.yaml``

2. Den ImageUpdater seperat zu installieren und zum ArgoCD Server zu connecten
-> aufwändiger, siehe Anleitung: 

https://argocd-image-updater.readthedocs.io/en/stable/install/installation/#method-2-connect-using-argo-cd-api-server

---

### Funktionsweise:

Der ImageUpdater überprüft anhand von Annotations an ArgoCD Application Ressourcen ob ein Image geupdated werden soll.
Mit entsprechender Notation kann man verschiedene Kriterien einstellen. Die wichtigste Annotation ist:

    argocd-image-updater.argoproj.io/image-list: sample=nginx:~1.20.0

Man kann Aliase vergeben, um z.B. in Helm-Charts anders benannte Values zu überschreiben:
```
argocd-image-updater.argoproj.io/image-list: <alias>=some/image:<tag_name>
argocd-image-updater.argoproj.io/sample.helm.image-name: image.repository
argocd-image-updater.argoproj.io/sample.helm.image-tag: image.tag
```


Mit Hilfe von constraints können die Versionen eingestellt werden, siehe Doku:
https://github.com/Masterminds/semver#checking-version-constraints

```
nginx:~1.20.0 
```
bedeutet z.B. maximale Miniorversion = 20

Es gibt aktuell zwei Möglichkeiten zum Updaten der Images:
* argocd write-back (Nicht persistiert, default)
* git write-back (brauch evtl. Konfiguration / Rechte auf die Repos)


    argocd-image-updater.argoproj.io/write-back-method: git

ArgoCD erzeugt dann eine Datei, die eine höhere Priorisierung erhält und pusht diese ins Repo:
```
helm:
  parameters:
  - name: image.repository
    value: nginx
    forcestring: true
  - name: image.tag
    value: 1.20.2
    forcestring: true
```

---
**Sample-App:** 
Die Sample-App wird laut Values eigentlich mit nginx:1.19.0 ausgerollt, durch die Annotations wird der ImageUpdater das Image aber auf 1.20.2 updaten
---


Komplette Doku: https://argocd-image-updater.readthedocs.io/en/stable/





