##Creazione VNet Mediante Bash
##Questo Laboratorio illustra diverse operazioni su VNET e SUBNET

##Requisiti sono un Resource Group, la CLI e chiaramente un accesso ad un TENANT

##Creazione VNet e Sub 
- az network vnet create -g <Nome Gruppo> -n <Nome VNET> --address-prefix 10.0.0.0/16 --subnet-name <Nome sottorete> subnet-prefix 10.0.0.0/24

##Creazione subnet in VNet esistente 
-az network vnet subnet create -n <Nome subnet> -g <Nome gruppo> --address-prefix 10.1.0.0/24

##Creazione  NSG
-az network nsg create -g <nome gruppo> -n <nome NSG>

##Attribuizione un NSG ad una specifica SUB
-az network vnet subnet update -g <Nome Gruppo> -n <Nome Subnet> --vnet-name <Nome Vnet> --network-security-group <No me NSG>

##Cancellare una sub
-az network subgnet delete --name <Nome Sub> --resourge-group <Nome gruppo> --vnet-name <nome vnet>

##Cancellare una VNet
-az network vnet delete -g <Nome Gruppo> -n <Nome Vnet>
-
-
-
