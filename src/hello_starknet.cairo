#[contract]
mod HelloStarknet {
    use starknet::get_caller_address;
    use starknet::ContractAddress;


    #[event]
    fn Hello(from: ContractAddress, value: felt252) {}

    #[event]
    fn Hola(from: ContractAddress, value: felt252) {}

    #[external]
    fn Say_Hello(message: felt252) { //  1615359997630894555177670709851143935038416505
        let caller = get_caller_address();
        Hello(caller, message);
    }

    #[external]
    fn Say_Hello_In_Argetino(message: felt252) {
        let caller = get_caller_address();
        Hola(caller, message);
    }
}
