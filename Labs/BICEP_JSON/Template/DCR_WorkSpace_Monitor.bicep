@description('Questo file Bicep crea una Data Collection Rule (DCR) per monitorare le performance di una macchina virtuale Windows ')
@description('e inviare i dati a un Log Analytics Workspace. La DCR raccoglie contatori di performance come l\'utilizzo della CPU, la memoria disponibile e lo spazio libero su disco,') 
@description('e li invia sia al Log Analytics Workspace che ad Azure Monitor Metrics.')

@description('Il file include anche associazione della DCR alla macchina virtuale, consentendo la raccolta dei dati di performance in tempo reale.')
param location string = resourceGroup().location
param dcrName string = 'dcr-vm1-windows-perf-law'
param vmName string = 'VM1'

var logAnalyticsWorkspaceName string = 'cassinoworkspace2026'

resource vm 'Microsoft.Compute/virtualMachines@2024-07-01' existing = {
  name: vmName
}

resource law 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource dcr 'Microsoft.Insights/dataCollectionRules@2023-03-11' = {
  name: dcrName
  location: location
  kind: 'Windows'
  properties: {
    dataSources: {
      performanceCounters: [
        {
          name: 'perfCountersDataSource'
          streams: [
            'Microsoft-Perf'
            'Microsoft-InsightsMetrics'
          ]
          samplingFrequencyInSeconds: 60
          counterSpecifiers: [
            '\\Processor(_Total)\\% Processor Time'
            '\\Memory\\Available MBytes'
            '\\LogicalDisk(_Total)\\% Free Space'
          ]
        }
      ]
    }

    destinations: {
      logAnalytics: [
        {
          name: 'laWorkspace'
          workspaceResourceId: law.id
        }
      ]

      azureMonitorMetrics: {
        name: 'azureMonitorMetrics-default'
      }
    }

    dataFlows: [
      {
        streams: [
          'Microsoft-Perf'
        ]
        destinations: [
          'laWorkspace'
        ]
      }
      {
        streams: [
          'Microsoft-InsightsMetrics'
        ]
        destinations: [
          'azureMonitorMetrics-default'
        ]
      }
    ]
  }
}

resource dcrAssociation 'Microsoft.Insights/dataCollectionRuleAssociations@2024-03-11' = {
  name: 'dcr-vm1-windows-perf-law-association'
  scope: vm
  properties: {
    dataCollectionRuleId: dcr.id
  }
}
