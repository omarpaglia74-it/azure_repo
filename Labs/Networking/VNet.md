##Creazione VNet Mediante Bash

-E' necessario creare oppure avere un RG
-Creazione VNet e Sub mediante cli
 az network vnet create -g <Nome Gruppo> -n <Nome VNET> --address-prefix 10.0.0.0/16 --subnet-name <Nome sottorete> - subnet-prefix 10.0.0.0/24
-Ora si crea una seconda subnet
 az network vnet subnet creat -n <Nome subnet> -g <Nome gruppo> --address-prefix 10.1.0.0/24
-Creare un NSG
 az network nsg create -g <nome gruppo> -n <nome NSG>
-Attribuire un NSG ad una specifica SUB
 az network vnet subnet update -g <Nome Gruppo> -n <Nome Subnet> --vnet-name <Nome Vnet> --network-security-group <No me NSG>

-Cancellare una sub
 az network subgnet delete --name <Nome Sub> --resourge-group <Nome gruppo> --vnet-name <nome vnet>

-Cancellare una VNet
 az network vnet delete -g <Nome Gruppo> -n <Nome Vnet>
-
-
-
