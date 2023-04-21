# Cairo 1 Smart Contracts Basics

Starknet es una blockchain de propósito general y una solución de capa 2 que ayuda a la escalabilidad, descentralización y seguridad de Ethereum a través del uso de pruebas de conocimiento cero STARKS.

Los ZK Rollups introducen el paradigma de computación probable, en este paradigma permitimos que los programas comprueben que se han ejecutado sin tener que volver a ejecutarlos.

Para hacer este proceso de forma efectiva se creó Cairo.

## Cairo

Es un lenguaje de programación fuertemente tipado y es nativo para programas de Computación Probable, además de tener una sintaxis muy similar a Rust.

## Correr Programas de Cairo en Docker

* Tener instalado Docker desktop.
* Tener corriendo el daemon de Docker.

**[Seguir las instrucciones en este tutorial](https://youtu.be/cASKzjYQ4iQ)**

## Instalar el ambiente de Cairo en forma local

**[Seguir las instrucciones de Starknet Book](https://book.starknet.io/chapter_1/environment_setup.html)**

### Resumen

En estos ejemplos vimos:

* Declaración de un smart contract con el macro `#[contract]`
* Declaración de eventos con el macro `#[event]`
* Uso de funciones externas con el macro `#[external]`
* Uso de tipo de dato Contract Address de la libreria `starknet::ContractAddress`
* Obtención de la cuenta/wallet que manda a llamar nuestras funciones usando la libreria `starknet::get_caller_address`
* Uso de variables de estado:

```rust
  struct Storage {
    _staking_token: ContractAddress,
    _token_rewards: ContractAddress,
    // User address, amount
    _stakers: LegacyMap<ContractAddress, u256>,
    _rewards: LegacyMap<ContractAddress, u256>,
  }
```

* Uso del Standard ERC20
* Interacción con smart contracts externos usando el macro `#[abi]` y los dispatchers correspondientes `IERC20Dispatcher` `IERC20DispatcherTrait`
[Ver más...](https://cairopractice.com/posts/calling-contracts-using-dispatch/)
* [Casteo de tipos](https://cairo-book.github.io/ch02-02-data-types.html#type-casting) con `into()`

## Compilando y Desplegando Smart Contracts

```sh
  starknet-compile -- src/Staking.cairo src/Staking.json
```

```sh
  starknet declare --contract src/Staking.json --account artur
```

```sh
  starknet deploy --class_hash 0x129594bdb807e580728f6abdb3d9f596e3b72088e64d2d3597a589be802f67c --account artur --inputs 49d36570d4e46f48e99674bd3fcc84644ddd6b96f7c741b1562b82f9e004dc7     0x0545b0ea692fa53c588927f1f8999067adf522f41df37d41ad101399024a5790
```
