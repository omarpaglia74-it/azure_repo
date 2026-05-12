###DEPLOY TEMPLATE BICEP E JSON

##Deploy VNET, 2 Sub2 e NSG
-
-

##Deploy VM Ubuntu Canonical, VNET, Una Sub, NSG, Una NIC, Public e Private IP ed una VM
#In questo Deploy vengono create una VNET che conterrà una Subnet a cui sarà creato ed agganciato un NSG, un IP Pubblico ed uno Privato  agganciati all'unica Subnet. 
-Per eseguire il deploy in questa configuraizone è necessario passare per la CLI 
-Si crea prima il gruppo:
-az group create --name Nome_Gruppo
-Quindi si lancia il deploy passando necessariamente come parametro la password del SO
-az deployment group create --resource-group Nome_gruppo --template-file VirtualMachineUbuntu.bicep --parameters adminPassword='xxxxxxxxxxxx'


#I file sono i seguenti
-[Template Biep](./Template/VirtualMachineUbuntu.bicep)
-[Template JSON](./Template/VirtualMachineUbuntu.json)

#Il Grafico
?[Schema del Deploy](./Image/VM_Ubuntu_VNET_Sub_NIC_NSG_PublicIP_PrivateIP.png)
