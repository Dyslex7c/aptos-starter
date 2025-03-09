module deployer_addr::SimpleCounter {
    use std::signer;
    use std::error;

    // Error constants
    const ECOUNTER_EXISTS: u64 = 1;
    const ECOUNTER_NOT_FOUND: u64 = 2;

    // Simple counter resource
    struct Counter has key {
        value: u64
    }

    // Initialize a new counter for the caller with value of 0
    public entry fun initialize_counter(account: &signer) {
        let account_addr = signer::address_of(account);
        
        // Check if counter already exists
        assert!(!exists<Counter>(account_addr), error::already_exists(ECOUNTER_EXISTS));
        
        // Create and move the counter resource to the signer's account
        move_to(account, Counter { value: 0 });
    }

    // Increment the counter value by 1
    public entry fun increment(account: &signer) acquires Counter {
        let account_addr = signer::address_of(account);
        
        // Ensure counter exists
        assert!(exists<Counter>(account_addr), error::not_found(ECOUNTER_NOT_FOUND));
        
        // Borrow and increment
        let counter = borrow_global_mut<Counter>(account_addr);
        counter.value = counter.value + 1;
    }

    // Set the counter to a specific value
    public entry fun set_value(account: &signer, new_value: u64) acquires Counter {
        let account_addr = signer::address_of(account);
        
        // Ensure counter exists
        assert!(exists<Counter>(account_addr), error::not_found(ECOUNTER_NOT_FOUND));
        
        // Borrow and set value
        let counter = borrow_global_mut<Counter>(account_addr);
        counter.value = new_value;
    }

    // Get the current counter value (view function)
    #[view]
    public fun get_value(account_addr: address): u64 acquires Counter {
        assert!(exists<Counter>(account_addr), error::not_found(ECOUNTER_NOT_FOUND));
        
        let counter = borrow_global<Counter>(account_addr);
        counter.value
    }
}