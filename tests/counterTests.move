#[test_only]
module deployer_addr::SimpleCounterTests {
    use aptos_framework::account;
    use deployer_addr::SimpleCounter;

    // Test account addresses
    const ALICE: address = @0xA11CE;
    const BOB: address = @0xB0B;

    // Helper function to set up a test account
    fun create_test_account(addr: address): signer {
        account::create_account_for_test(addr)
    }

    // Test initialization
    #[test]
    fun test_initialize_counter() {
        // Set up test environment
        let alice = create_test_account(ALICE);
        
        // Initialize counter
        SimpleCounter::initialize_counter(&alice);
        
        // Check initial value
        let value = SimpleCounter::get_value(ALICE);
        assert!(value == 0, 0);
    }

    // Test increment
    #[test]
    fun test_increment() {
        // Set up test environment
        let alice = create_test_account(ALICE);
        
        // Initialize counter
        SimpleCounter::initialize_counter(&alice);
        
        // Increment counter
        SimpleCounter::increment(&alice);
        
        // Check value after increment
        let value = SimpleCounter::get_value(ALICE);
        assert!(value == 1, 0);
        
        // Increment again
        SimpleCounter::increment(&alice);
        
        // Check value after second increment
        value = SimpleCounter::get_value(ALICE);
        assert!(value == 2, 0);
    }

    // Test set_value
    #[test]
    fun test_set_value() {
        // Set up test environment
        let alice = create_test_account(ALICE);
        
        // Initialize counter
        SimpleCounter::initialize_counter(&alice);
        
        // Set value
        SimpleCounter::set_value(&alice, 42);
        
        // Check value after set
        let value = SimpleCounter::get_value(ALICE);
        assert!(value == 42, 0);
    }

    // Test multiple users
    #[test]
    fun test_multiple_users() {
        // Set up test environment
        let alice = create_test_account(ALICE);
        let bob = create_test_account(BOB);
        
        // Initialize counters for both users
        SimpleCounter::initialize_counter(&alice);
        SimpleCounter::initialize_counter(&bob);
        
        // Increment Alice's counter
        SimpleCounter::increment(&alice);
        SimpleCounter::increment(&alice);
        
        // Increment Bob's counter once
        SimpleCounter::increment(&bob);
        
        // Set Bob's counter to a specific value
        SimpleCounter::set_value(&bob, 100);
        
        // Check values
        let alice_value = SimpleCounter::get_value(ALICE);
        let bob_value = SimpleCounter::get_value(BOB);
        
        assert!(alice_value == 2, 0);
        assert!(bob_value == 100, 0);
    }

    // Test error cases
    #[test]
    #[expected_failure(abort_code = 0x80001, location = SimpleCounter)]
    fun test_initialize_twice() {
        // Set up test environment
        let alice = create_test_account(ALICE);
        
        // Initialize counter
        SimpleCounter::initialize_counter(&alice);
        
        // Try to initialize again (should fail)
        SimpleCounter::initialize_counter(&alice);
    }

    #[test]
    #[expected_failure(abort_code = 0x60002, location = SimpleCounter)]
    fun test_increment_uninitialized() {
        // Set up test environment
        let alice = create_test_account(ALICE);
        
        // Try to increment without initializing (should fail)
        SimpleCounter::increment(&alice);
    }

    #[test]
    #[expected_failure(abort_code = 0x60002, location = SimpleCounter)]
    fun test_set_value_uninitialized() {
        // Set up test environment
        let alice = create_test_account(ALICE);
        
        // Try to set value without initializing (should fail)
        SimpleCounter::set_value(&alice, 5);
    }

    #[test]
    #[expected_failure(abort_code = 0x60002, location = SimpleCounter)]
    fun test_get_value_uninitialized() {
        // Try to get value without initializing (should fail)
        let _ = SimpleCounter::get_value(ALICE);
    }
}