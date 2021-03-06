   Entities can be loaded from the store using a string ID; this ID
   needs to be unique across all entities of the same type
``` javascript
let entity = ExampleEntity.load(event.transaction.from.toHex())
```

Entities only exist after they have been saved to the store;
`null` checks allow to create entities on demand
``` javascript
if (!entity) {
    entity = new ExampleEntity(event.transaction.from.toHex())

    Entity fields can be set using simple assignments
    entity.count = BigInt.fromI32(0)
}
```

BigInt and BigDecimal math are supported
``` javascript
entity.count = entity.count + BigInt.fromI32(1)
```

Entity fields can be set based on event parameters
``` javascript
entity.param0 = event.params.param0
entity.param1 = event.params.param1
```
  
Entities can be written to the store with `.save()`
``` javascript
entity.save()
```

   If a handler doesn't require existing field values, it is faster  _not_ to load the entity from the store. 
   
   Instead, create it fresh with `new Entity(...)`, set the fields that should be updated and save the entity back to the store. _Fields that were not set or unset remain unchanged, allowing for partial updates to be applied_.

   It is also possible to access smart contracts from mappings. For
   example, the contract that has emitted the event can be connected to with:
   
``` javascript
let contract = Contract.bind(event.address)
```
   
   The following functions can then be called on this contract to access state variables and other data:
  
   - contract.DEFAULT_ADMIN_ROLE(...)
   - contract.DEPLOYER_ROLE(...)
   - contract.MODERATOR_ROLE(...)
   - contract.deploy721Contract(...)
   - contract.getRoleAdmin(...)
   - contract.getRoleMember(...)
   - contract.getRoleMemberCount(...)
   - contract.hasRole(...)
   - contract.implementationAddress(...)
   - contract.publicDeployerEnabled(...)
   - contract.supportsInterface(...)
   - contract.upgradeableBeacon(...)
