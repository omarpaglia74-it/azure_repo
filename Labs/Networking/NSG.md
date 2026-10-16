##Creazione/Gestione NSG

##Requisiti
- Accesso Tenent
- Resource Group

##Creazione NSG
- az network nsg create -g "Nome Gruppo" -n "Nome NSG"

##Creazione Rule
- az network nsg rule create -g "Nome gruppo" --nsg-name "Nome NSG" -n "Nome Regola" --priority 120 --source-address-prefix 20.130.28.0/24 --source-port-ranges 80 --destination-address-prefix '*' --destination-port-ranges 80 8080 --access Deny --protocol Tcp --description "Negato da un indirizzo specifico il passaggio sulle porte 80 e 8080"

##Modifica Rule - Modifica la proprietà indicata
- az network nsg rule update -g "Nome Gruppo" --nsg-name "Nome NSG" --name "Nome Regola" --source-address-prefixes 208.130.28.0/24

##Cancellare Rule
- az network nsg rule delete -g "Nome Gruppo" --nsg-name "Nome NSG" -n "Nome Regola"
##Assegnazione NSG a Sottorete


##Modifica Regole Assegnate

##Deassegnare NSG

##Creazione ASG

##Assegnazione ASG

#Deassegnare ASG


