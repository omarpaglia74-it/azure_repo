### URN - HOW TO
- Publisher:Offer:Sku:Version
- Indica esattamente il sistema operativo da deployare nella regione

## Obiettivo
- Come scoprire una URN completa di una VM da deployare
- Si rende necessaria questa opzione quando da CLI vogliamo 
- deployare una VM indicando esattamente la URN

## Prerequisiti
- Azure Sub
- Azure Cli


## Steps URN
1. Creare la variabile d'ambiente per la location
2. Creare la variabile d'ambiente per il Publisher
3. Creare la variabile d'ambiente per Offer
4. Creare la variabile d'ambiente per Sku
5. Creare la variabile d'ambiente per l'immagine da deplyare

## Commands
- Creiamo $LOC per la location
- LOC = westeurope
- Verifichiamo i publisher nella LOC
- az vm image list-publisher -l $LOC -o table
- possiamo inserire | grep -i Windows oppure canonical o Debian
- az vm image list-publisher -l $LOC -o table | egrep -i "(windows|canonical|debian) 
- Impostiamo PUB1=MicrosoftWindowsServer && PUB2=Debian && PUB3=Canonical
- Andiamo a verificare Offer che ci interessa
- az vm image list-offers -l $LOC -p $PUB1 -o table (stessa cosa può essere fatta per PUB2,3)
- Per VM Windows abbia WindowsServer oppure WindowsServer2022 quindi impostiamo la variabile ambientale
- OFFER1=WindowsServer
- Ora con Publisher e Offer già acquisiti procediamo con la Sku
- az vm image list-skus -l $LOC -p $PUB1 -f $OFFER1 -o table
- otterremo una lista di sku da cui prendiamo quella che ci interessa
- SKU1=2019-datacenter imposto questa 
- Per la versione preferisco l'ultima latest ed impostiamo IMAGE
- IMAGE=$PUB1:$OFFER1:$SKU1:latest quindi possiamo procedere al deploy
- lo stesso procedimento posso usarlo per publisher come canonical o debian ecc



