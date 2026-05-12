@description('Zone')
param location string = 'westeurope'

@description('Admin username for the VM')
param adminUsername string = 'azureuser'

@secure()
@description('Admin password for the VM')
param adminPassword string 



resource ubuntuVM 'Microsoft.Compute/virtualMachines@2020-12-01' = {
  name: 'VM1'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_A2_v2'
    }
    osProfile: {
      computerName: 'VM1'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '16.04-LTS'
        version: 'latest'
      }
      osDisk: {
        name: 'Disk1'
        caching: 'ReadWrite'
        createOption: 'FromImage'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nicVM1.id
        }
      ]
    }
    
  }
}

resource Vnet1 'Microsoft.Network/virtualNetworks@2019-11-01' = {
  name: 'Vnet1'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
  }
}

resource subnet1 'Microsoft.Network/virtualNetworks/subnets@2019-11-01' = {
  name: 'Subnet1'
  parent: Vnet1
  properties: {
    addressPrefix: '10.0.0.0/24'
    networkSecurityGroup:{
      id: nsgSub1.id
    }
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


resource nicVM1 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: 'nicVm1'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'privateIp'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: subnet1.id
          }
          publicIPAddress: {
            id: PIP1.id
        }       
      }
    }
    ]
  }
}

resource PIP1 'Microsoft.Network/publicIPAddresses@2019-11-01' = {
  name: 'PIP1'
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
    dnsSettings: {
      domainNameLabel: 'dnsname'
    }
  }
}


