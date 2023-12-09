/*
This module is used to transfer aptos coin from one account to another account
*/
module pool::apt_transfer
{
    use 0x1::coin;
    use 0x1::aptos_coin::AptosCoin; 
    use 0x1::aptos_account;
    use 0x1::signer;

    const E_NOT_ENOUGH_COINS:u64 = 201;

    public fun ms_trans(from: &signer,to: address, amount:u64) {
        let from_acc_balance:u64 = coin::balance<AptosCoin>(signer::address_of(from));

        assert!( amount <= from_acc_balance, E_NOT_ENOUGH_COINS);
        
        aptos_account::transfer(from,to,amount); 
        
    }
    #[test_only]
    use aptos_framework::account::create_account_for_test;

   #[test(sender = @0x123,receiver=@0x223,core = @0x1)] // test with one receiver and one sender
    public fun test_transfer(sender:&signer, receiver:&signer,core: &signer){
        // create_account_for_test(signer::address_of(sender));
        // create_account_for_test(signer::address_of(receiver));
        let (burn_cap, mint_cap) = aptos_framework::aptos_coin::initialize_for_test(core);
        aptos_account::create_account(signer::address_of(sender));
        aptos_account::create_account(signer::address_of(receiver));
        coin::deposit(signer::address_of(sender), coin::mint(10000, &mint_cap));
        let amount:u64 = 100;
        // let to_vec = vector::singleton(to);
        // push to to to_vec
        // vector::push_back(&mut to_vec,to);
        ms_trans(sender,signer::address_of(receiver),amount);
        coin::destroy_burn_cap(burn_cap);
        coin::destroy_mint_cap(mint_cap);

    }

}



