
@description('Zone')
param location string = 'westeurope'

resource virtualNetwork 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'VNet1'
  location: location
  tags: {
    VRete: 'VirtualNetwork1'
  }
  properties: {

    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'Subnet-1'
        properties: {
          addressPrefix: '10.0.0.0/24'
          networkSecurityGroup:{
            id: nsgSub1.id
          }
        }
      }
      {
        name: 'Subnet-2'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
    ]
  }
}

resource nsgSub1 'Microsoft.Network/networkSecurityGroups@2019-11-01' = {
  name: 'NSG1'
  location: location
  properties: {
    securityRules: [
      {
        name: 'NSG1Rule'
        properties: {
          description: 'RegolaVnet1'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 100
          direction: 'Inbound'
        }
      }
    ]
  }
}


