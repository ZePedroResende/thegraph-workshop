# thegraph-workshop

This is the repository for the [SMARTT talk of 23 of march 2022](https://subvisual.notion.site/Society-of-Mars-Advanced-Royal-Tech-Talks-28cf36c8beac41c9a9b01046f98b7c6c)

## Directories

### contracts

 >
 >***You don't actually need to deploy or compile these contracts to use the graph example.***
 >
 > You can use this factory contract deployed on **rinkeby** :
 >- Factory: `0x999Ed6BC3391F637F8E498fbB696BbC4BDE5De8d`

[foundry](https://github.com/gakonst/foundry) repository of contracts with a :

 -  Factory of `BeaconProxy` to an `ERC721` implementation

 -  `ERC721` implementation

 -  `ERC2981` for royalties




### theraph-example

[thegraph-example](https://thegraph.com/en/) a subgraph for this contracts with two mappings :
 -  mapping with a data source and a named address for the Factory
 -  mapping with a template for dinamicaly created erc721
