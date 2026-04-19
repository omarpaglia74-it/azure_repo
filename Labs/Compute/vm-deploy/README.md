</> Markdown

# Azure Deploy a VM 

## Obiettivo
Deployare una VM mediante CLI.

## Prerequisiti
- Azure sub
- Azure CLI
- Resource Group

## Steps
1. Creare un Resource Group
2. Verificare i size disponibili nella region scelta 
3. Deployare una VM Linux con PIP
4. Testare l'accesso e la funzionalità mediante SSH

## Commands

- Creo il gruppo RGLab
az group create RGLab --location WESTEUROPE

- Verifico la disponibilità della size inerente la VM
az vm list-skus -o table --location westeurope oppure az vm list-sizes -o table --location westeurope

-Procedo al Deploy
az vm create --name VM1 --resource-group RGLab --admin-user localadmin --size Standard_B1s --generate-ssh-keys --location westeurope --image Ubuntu2204
-Attenzione il deploy potrebbe fallise per il size che non è disponibile in regione, per l'image che è corretta ma la versione della cli potrebbe
-non ricoscere in quanto necessita dell'indirizzo completo Canonical:0001-com-ubuntu-server-jammy:22_04-lts:latest
-oppure perché il componente non è registrato nella regione

-Verifico la configurazione della VM e l'indirizzo ip
az vm show --name VM1 --resource-group RGLab
az vm list-ip-address --name VM1 --resource-group RGLab

-Verifico se la VM è running
az vm list -d -o table - attenzione da dove lanci il deploy perché le chiavi verrano aggiornate/salvate nello stesso ambiente

In screenshot è presente lo screen del test di connessione

- Pulisco tutto il lab andando ad eliminare il gruppo 
az group delete --name RGLab -y
