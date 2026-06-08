###Monitor Deploy

##In Questo Lab verrà deployata un VM ed un Monitor per controllare le metriche della VM
##Attiveremo l'agent sulla VM

- Effettuo il Deploy della VM accertandomi dell'URN, in questo lab usero Win Datacenter 2019:
- az vm create -n <VM name> -g <RG> --image MicrosoftWindowsServer:WindowsServer:2019-Datacenter:Latest --size  <il size ad esempio Standard_A2_v2> --admin-username <local_admin> --admin-password <password> --location <location>

- Verifica della presenza dell'Agent sulla VM Microsoft
- az vm extension list -g <RG> --vm-name <VM> -o table
- Il risultato dovrebbe restituire una linea nulla in quanto l'agent non è stato deployato insieme alla VM
- Procediamo al deploy dell'Agent:
- az vm extension set --resource-group <RG> --vm-name <VM> --name AzureMonitorWindowsAgent --publisher Microsoft.Azure.Monitor --enable-auto-upgrade true
- l'opzione attivata --enable-auto-upgrade true consente alla piattaforma Azure di aggiornare in autonomia l'Agent se presente una nuova verisone

- Verifica della presenza dell'Agent sul VM Linux
- az vm extension list -g <RG> --vm-name <VM>  -o table
- Procediamo al deploy dell'Agent su VM Linux:
- az vm extension set --resource-group <RG> --vm-name <VM> --name AzureMonitorLinuxAgent --publisher Microsoft.Azure.Monitor --enable-auto-upgrade true


