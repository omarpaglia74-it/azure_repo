##Creazione/Gestione NSG

##Requisiti
- Accesso Tenent
- Resource Group

##Creazione NSG
- az network nsg create -g "Nome Gruppo" -n "Nome NSG"

##Creazione Regola
- az network nsg rule create -g "Nome gruppo" --nsg-name "Nome NSG" -n "Nome Regola" --priority 120 --source-address-prefix 20.130.28.0/24 --source-port-ranges 80 --destination-address-prefix '*' --destination-port-ranges 80 8080 --access Deny --protocol Tcp --description "Negato da un indirizzo specifico il passaggio sulle porte 80 e 8080"

##Modifica Regola - Modifica la proprietà indicata
- az network nsg rule update -g "Nome Gruppo" --nsg-name "Nome NSG" --name "Nome Regola" --source-address-prefixes 208.130.28.0/24

##Cancellare Regola
- az network nsg rule delete -g "Nome Gruppo" --nsg-name "Nome NSG" -n "Nome Regola"

##Assegnazione NSG a Sottorete
- az network vnet sub update -g "Nome Gruppo" --vnet-name "Nome Vnet" -n "Nome Sub" --network-security-group "Nome NSG"

##Rimuovere NSG da sottorete
- az network vnet sub update -g "Nome Gruppo" --vnet-name "Nome Vnet" -n "Nome Sub" --remove netsecuritygroup



##Creazione ASG
- az network asg create -g "Nome Gruppo" -n "Nome ASG" --location "location scelta"

##Creazione Regola NSG con ASG
- az network nsg rule create -g "Nome Gruppo" --nsg-name "Nome NSG" --name "Nome Regola es Allow-WenToApp" -- priority 200 --direction Inbound --access Allow --protocol Tcp --source-args "ASG-WEB" --desitnation-args "ASG-APP" --destination-port-ranges 8080

#Assegnare IP ad ASG
- az network nic ip-config update -g "Nome gruppo" --nic-name "Nome NIC" --name "Nome associazione es ipconfig1" --application-security-group "Nome ASG es ASG-WEB"

#Rimuovere IP da ASG
- az network nic ip-config update - g "Nome gruppo" --nice-name "Nome NIC" -n "nNome associazione" --remove

##Rimuovere un ASG
- az network asg delete -g "Nome RG" --name "Nome ASG"
