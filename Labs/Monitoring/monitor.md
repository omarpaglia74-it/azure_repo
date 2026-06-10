### Monitor Deploy

## In Questo Lab verrà deployata un VM ed un Monitor per controllare le metriche della VM
## Attiveremo l'agent sulla VM

- Effettuo il Deploy della VM accertandomi dell'URN, in questo lab usero Win Datacenter 2019:
- az vm create -n <VM_name> -g <RG_name> --image MicrosoftWindowsServer:WindowsServer:2019-Datacenter:Latest --size  "size di esempio Standard_A2_v2" --admin-username "local_admin" --admin-password "admin_passw0rd" --location "zona location"

- Verifica della presenza dell'Agent sulla VM Microsoft
- az vm extension list -g "RG" --vm-name "VM" -o table
- Il risultato dovrebbe restituire una linea nulla in quanto l'agent non è stato deployato insieme alla VM
- Procediamo al deploy dell'Agent:
- az vm extension set --resource-group "RG" --vm-name "VM" --name AzureMonitorWindowsAgent --publisher Microsoft.Azure.Monitor --enable-auto-upgrade true
- l'opzione attivata --enable-auto-upgrade true consente alla piattaforma Azure di aggiornare in autonomia l'Agent se presente una nuova verisone

- Verifica della presenza dell'Agent sul VM Linux
- az vm extension list -g "RG" --vm-name "VM"  -o table
- Procediamo al deploy dell'Agent su VM Linux:
- az vm extension set --resource-group "RG" --vm-name "VM" --name AzureMonitorLinuxAgent --publisher Microsoft.Azure.Monitor --enable-auto-upgrade true

## Anche avendo deployato l'Agent, al momento le metriche che possiamo vedere sono solo le "metriche host" presenti in
## Monitor -> Metrics del portale di Azure, ovvero le metriche che sono al di fuori della VM.
## Per le Metriche Guest OS oltre al già installato Agent sono necessari un DCR (Data Collection Rule) e Log Analytics Workspace
## rispettivamente come regole per la raccolta dati e come destinazione 

# Creo Log Analytics Workspace
- az monitor log-analytics workspace create --name "WorkSpace Name" --resource-group "RG" --location "Location"
- Visualizzo la presenza del WorkSpace:
- az monitor log-analytics workspace list -o table

# Creo una DCR 
- Inserisco come destination il Workspace appena creato
- come raccolta dati l'agent sulla VM
- Utilizzo un template in bicep deployato mediante cli
- az deployment group create --resource-group "RG" --template-file "template.dcr per il lab ho preparato dcr.bicep" --parameters vmName="VM" dcrName=dcr-vi1-windows-pef-law // ATTENZIONE I PARAMETRI SONO PASSATI IN BASE ALLE VARIABILI SETTATE NEL TEMPLATE

- Controllimao se la DCR sia stata creata
- az monitor data-collection rule list --resource-group "RG" -o table

# A questo punto emerge un problema ovvero i dati non vengono passati al workspace
# I dati non arrivano anche se l'agent è installato, il workspace è presente così come la DCR e l'associazione al log analytics.
# In sostanza quello che manca è il system-assigned Managed Identity alla VM che possa essere usato dall'agent per poter avere accesso al log analytics

- Per evitare questo problema le strade sono due o si attiva nel deploy della VM stessa
- ... --assign-identity  // Questa è l'opzione da aggiungere nel momento del deploy
- La seconda strada è quello di attivare l'identità sulla VM già esistente
- az vm identity assign --resource-group "RG" --name "VM"
- In realtà può essere attivata anche dal portale di azure VM->Security->Identity quindi impostare lo status su on

## Controllo arrivo dei dati nel WorkSpace
- Da Log Analytics nella sezione query kusto:
- Perf
- where TimeGenerated > ago(1h)
- project TimeGenerated, Computer, ObjectName, CounterName, CounterValue
- take 20
- Se tutto funziona correttamente dovrebbero visualizzarsi dei record

## Invio delle metriche ache a Azure Monitor oltre che a Log Analytics
- ATTENZIONE FATTA QUESTA MODIFICA CHE AGGIUNGERE UNA DESTINAZIONE ALLA DCR
- LA STESSA NON POTRA' PIù ESSERE GESTITA DAL PORTALE STESSO
- Mediante portale su Log Analytics WorkSpace
- Azure Monitor
- -> Data Collection Rules -> seleziona la DCR -> Data Sources / Collect and deliver -> Performance Counters -> aggiungi/modifichi 
- Destination aggiungendo Azure Monitr Metrics
- Ovviamente questa configuraizone può essere messa in essere deployando da un template che preveda le due destination
- az deployment group create --resource-group "RG" --template-file DCR_WorkSpaceMonitor.bicep --parameters vmName=VM1 dcrName=dcr-vm1-windows-perf-law

- Dopo qualche minuto è possibile controllare l'arrivo dei dati andando sul workspace
- quindi su Log ed eseguendo le seguenti query di esempio:

- Perf | where Computer has "VM1" | sort by TimeGenerated desc

- Perf | where TimeGenerated > ago(2h) | take 20

- Heartbeat | where TimeGenerated > ago(4h) | summarize Count=count() by Computer, OSType, ResourceGroup, _ResourceId | order by Count desc

- Perf | where TimeGenerated > ago(2h) | take 20

- Le tabelle dovrebbero popolarsi di dati, si ricorda di attendere qualche minuto.