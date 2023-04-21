use starknet::ContractAddress;

#[abi]
trait IERC20 {
    fn approve(spender: ContractAddress, amount: u256) -> bool;
    fn mint(amount: u256);
    fn transfer(recipient: ContractAddress, amount: u256) -> bool;
    fn transferFrom(sender: ContractAddress, recipient: ContractAddress, amount: u256) -> bool;
    fn balance_of(account: ContractAddress) -> u256;
    fn allowance(owner: ContractAddress, spender: ContractAddress) -> u256;
}

#[contract]
mod StakingToken {
    use starknet::get_caller_address;
    use starknet::get_contract_address;
    use starknet::contract_address_const;
    use starknet::ContractAddress;
    use starknet::ContractAddressZeroable;
    use super::IERC20Dispatcher;
    use super::IERC20DispatcherTrait;
    use traits::Into;

    //##############
    // Storage Vars #
    //##############
    struct Storage {
        _staking_token: ContractAddress,
        _token_rewards: ContractAddress,
        // User address, amount
        _stakers: LegacyMap<ContractAddress, u256>,
        _rewards: LegacyMap<ContractAddress, u256>,
    }

    //#########
    // Events #
    //########
    #[event]
    fn Deposit(sender: ContractAddress, value: u256) {}

    #[event]
    fn Withdraw(sender: ContractAddress, value: u256) {}

    #[event]
    fn Claim_Rewards(sender: ContractAddress, value: u256) {}

    //##############
    // Constructor #
    //##############
    #[constructor]
    fn constructor(staking_token: ContractAddress, token_rewards: ContractAddress) {
        _staking_token::write(staking_token);
        _token_rewards::write(token_rewards);
    }

    //################
    // View Functions #
    //################

    #[view]
    fn balanceStaked(account: ContractAddress) -> u256 {
        _stakers::read(account)
    }

    #[view]
    fn earnedRewards(account: ContractAddress) -> u256 {
        _rewards::read(account)
    }

    #[view]
    fn stakingToken() -> ContractAddress {
        _staking_token::read()
    }

    #[view]
    fn token_rewards() -> ContractAddress {
        _token_rewards::read()
    }

    //####################
    // External Functions #
    //####################

    #[external]
    fn stake(amount: u256) {
        let caller = get_caller_address();
        let this_contract = get_contract_address();
        let staking_token = IERC20Dispatcher { contract_address: _staking_token::read() };

        let approved: u256 = staking_token.allowance(caller, this_contract);
        assert(approved > 1.into(), 'Not approved');
        assert(amount != 0.into(), 'Must be greater than 0');

        staking_token.transferFrom(caller, this_contract, amount);
        _stakers::write(caller, amount);
        _rewards::write(caller, 50000.into());

        Deposit(caller, amount);
    // return ();
    }

    #[external]
    fn claimRewards() {
        let caller = get_caller_address();
        let this_contract = get_contract_address();
        let rewards = earnedRewards(caller);
        assert(rewards > 0.into(), 'Dont have rewards');
        let reward_token = IERC20Dispatcher { contract_address: _token_rewards::read() };

        _rewards::write(caller, 0.into()); // se actualiza el registro
        reward_token.mint(50000.into()); // lo mintea el contrato
        reward_token.transferFrom(this_contract, caller, 50000.into());

        Claim_Rewards(caller, rewards);
    }

    #[external]
    fn withdrawStake() {
        let caller = get_caller_address();
        let amount_staked = _stakers::read(caller);
        assert(amount_staked > 0.into(), 'Dont have amount staked');

        let staking_token = IERC20Dispatcher { contract_address: _staking_token::read() };

        _stakers::write(caller, 0.into());
        staking_token.transfer(caller, amount_staked);

        Withdraw(caller, amount_staked);
    }
}
