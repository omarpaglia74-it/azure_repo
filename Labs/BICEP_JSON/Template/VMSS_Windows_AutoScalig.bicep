
@description('Name of the Virtual Machine Scale Set')
param scaleSetName string = 'ScaleSet1'

@description('Location for the Virtual Machine Scale Set')
param location string = 'westeurope'

@description('Admin username for the Virtual Machine Scale Set')
param adminUsername string = 'azureuser'

@secure()
@description('Admin password for the Virtual Machine Scale Set')
param adminPassword string



resource virtualMachineScaleSet 'Microsoft.Compute/virtualMachineScaleSets@2021-07-01' = {
  name: scaleSetName
  location: location
  sku: {
    name: 'Standard_A2_v2'
    capacity: 2
  }
  properties: {
    upgradePolicy: {
      mode: 'Automatic'
    }
    virtualMachineProfile: {
      storageProfile: {
        imageReference: {
          publisher: 'MicrosoftWindowsServer'
          offer: 'WindowsServer'
          sku: '2019-Datacenter'
          version: 'latest'
        }
        osDisk: {
          createOption: 'FromImage'
        }
      }
      osProfile: {
        computerNamePrefix: 'vmss'
        adminUsername: adminUsername
        adminPassword: adminPassword
      }
      networkProfile: {
        networkInterfaceConfigurations: [
          {
            name: 'nicConfig1'
            properties: {
              primary: true
              ipConfigurations: [
                {
                  name: 'ipConfig1'
                  properties: {
                    subnet: {
                      id: Subnet1.id
                    }
                  }
                }
              ]
            }
          }
        ]
      }
    }
  }
}

resource VNET1 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'VNET1'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
  }
}

resource Subnet1 'Microsoft.Network/virtualNetworks/subnets@2019-11-01' = {
  name: 'Subnet1'
  parent: VNET1
  properties: {
    addressPrefix: '10.0.0.0/24'
    networkSecurityGroup:{
      id: NSG1.id
    }
  }
}

resource NSG1 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: 'NSG1'
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowRDP'
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1000
          direction: 'Inbound'
        }
      }
    ]
  }
}


resource scale1 'Microsoft.Insights/autoscalesettings@2022-10-01' = {
  name: 'autoscaleSettings1'
  location: location
  properties: {
    enabled: true
    targetResourceUri: virtualMachineScaleSet.id
    profiles: [
      {
        name: 'AutoScaleProfile1'
        capacity: {
          minimum: '2'
          maximum: '5'
          default: '2'
        }
        rules: [
          {
            metricTrigger: {
              metricName: 'Percentage CPU'
              metricResourceUri: virtualMachineScaleSet.id
              metricNamespace: 'Microsoft.Compute/virtualMachineScaleSets'
              timeGrain: 'PT1M'
              statistic: 'Average'
              timeWindow: 'PT5M'
              timeAggregation: 'Average'
              operator: 'GreaterThan'
              threshold: 75
            }
            scaleAction: {
              direction: 'Increase'
              type: 'ChangeCount'
              value: '1'
              cooldown: 'PT5M'
            }
          }
          {
            metricTrigger: {
              metricName: 'Percentage CPU'
              metricResourceUri: virtualMachineScaleSet.id
              metricNamespace: 'Microsoft.Compute/virtualMachineScaleSets'
              timeGrain: 'PT1M'
              statistic: 'Average'
              timeWindow: 'PT5M'
              timeAggregation: 'Average'
              operator: 'LessThan'
              threshold: 25
            }
            scaleAction: {
              direction: 'Decrease'
              type: 'ChangeCount'
              value: '1'
              cooldown: 'PT5M'
            }
          }
        ]
      }
    ]
  }
}



