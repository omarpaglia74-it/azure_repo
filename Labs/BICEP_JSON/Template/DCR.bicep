param location string = resourceGroup().location
param dcrName string = 'dcr-vm1-windows-perf-law'
param vmName string = 'VM1'

var logAnalyticsWorkspaceName = 'cassinoworkspace2026'

resource vm 'Microsoft.Compute/virtualMachines@2024-07-01' existing = {
  name: vmName
}

resource law 'Microsoft.OperationalInsights/workspaces@2023-09-01' existing = {
  name: logAnalyticsWorkspaceName
}

resource dcr 'Microsoft.Insights/dataCollectionRules@2024-03-11' = {
  name: dcrName
  location: location
  kind: 'Windows'
  properties: {
    dataSources: {
      performanceCounters: [
        {
          name: 'windowsPerfCounters'
          streams: [
            'Microsoft-Perf'
          ]
          samplingFrequencyInSeconds: 60
          counterSpecifiers: [
            '\\Processor(_Total)\\% Processor Time'
            '\\Memory\\Available MBytes'
            '\\LogicalDisk(_Total)\\% Free Space'
            '\\LogicalDisk(_Total)\\Disk Reads/sec'
            '\\LogicalDisk(_Total)\\Disk Writes/sec'
            '\\Network Interface(*)\\Bytes Total/sec'
          ]
        }
      ]
    }

    destinations: {
      logAnalytics: [
        {
          name: 'logAnalytics-default'
          workspaceResourceId: law.id
        }
      ]
    }

    dataFlows: [
      {
        streams: [
          'Microsoft-Perf'
        ]
        destinations: [
          'logAnalytics-default'
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
