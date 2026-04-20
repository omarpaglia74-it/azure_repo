</> Markdown

# Azure Deploy a VM 

## Obiettivo
Deployare una VM mediante CLI.

## Prerequisiti
- Azure sub
- Azure CLI
- Resource Group

## Steps VM Linix
1. Creare un Resource Group
2. Verificare i size disponibili nella region scelta 
3. Deployare una VM Linux con PIP
4. Testare l'accesso e la funzionalità mediante SSH
5. Pulire tutto il lab

## Steps VM Microsoft
1. Creare RG
2. Verificare i size disponibili nella regione
3. Verificare la disponibilità dell'immagine
4. Deployare VM Window con PIP
5. Testare l'accesso e le funzionalità mediante Web Connect
6. Pulire il lab

## Commands

- Creo il gruppo RGLab
az group create RGLab --location WESTEUROPE

- Verifico la disponibilità della size inerente la VM
az vm list-skus -o table --location westeurope oppure az vm list-sizes -o table --location westeurope

- Procedo al Deploy
az vm create --name VM1 --resource-group RGLab --admin-user localadmin --size Standard_B1s --generate-ssh-keys --location westeurope --image Ubuntu2204
-Attenzione il deploy potrebbe fallise per il size che non è disponibile in regione, per l'image che è corretta ma la versione della cli potrebbe
-non ricoscere in quanto necessita dell'indirizzo completo Canonical:0001-com-ubuntu-server-jammy:22_04-lts:latest
-oppure perché il componente non è registrato nella regione

- Verifico la configurazione della VM e l'indirizzo ip
az vm show --name VM1 --resource-group RGLab
az vm list-ip-address --name VM1 --resource-group RGLab

- Verifico se la VM è running
az vm list -d -o table - attenzione da dove lanci il deploy perché le chiavi verrano aggiornate/salvate nello stesso ambiente

In screenshot è presente lo screen del test di connessione

- Pulisco tutto il lab andando ad eliminare il gruppo 
az group delete --name RGLab -y

- Creo il RG
az group create --name RGLab --location westeurope

- Verifico la disponibilità della size
az vm list-sizes --o table --location westeurope

- Verifico la disponibilità dell'imagine cominciando dal Publisher
az vm image list-publisher -l westeurope -o tatble (Per win microsoft è MicrosoftWindowsServer)

- Verifico la offer
az vm image list-offers -l westeurope -p MicrosoftWindowsServer -o table (Solitamente è WindowsServer)

- Verifico la SKU
az vm image list-skus -l westeurope -p MicorsoftWindowsServer -f WindowsServer -o table

Dalla lista possiamo sceglierne uno ad esempio 2019-Datacenter

Tenendo conte che la URN è composta da Publisher:Offer:Sku:Version posso completarla URN in questo modo

MicrosoftWindowsServer:WindowsServer:2019-Datacenter:latest

IMAGE=MicrosoftWindowsServer:WindowServer:2019-Datacenter:latest

- Effetto il deploy di Win 2019 Datacenter Server 
az vm create --name VM1 --resource-group RGLab --admin-user localuser --size Standard_B2s --location westeurope --image $IMAGE

- Mediante Azure Portal è possibile accedere alla VM mediante Bastion 

- Ultimo punto pulisco il lab cancellando il resource group
az group delete --name RGLab -y
