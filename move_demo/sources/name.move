// move_demo::name::set_name()
// move_demo::name::name()
// move_demo::name::NameRecord
module move_demo::name {
    use std::signer::address_of;
    use std::string::{String, utf8};

    struct NameRecord has key {
        name: String,
    }

    public entry fun set_name(user: signer, name: String) acquires NameRecord {
        let user_addr = address_of(&user);
        if (!exists<NameRecord>(user_addr)) {
            // Create a new record
            move_to(&user, NameRecord { name });
        } else {
            // Update the existing record
            let name_record = borrow_global_mut<NameRecord>(user_addr);
            name_record.name = name;
        }
    }

    #[view]
    public fun name(of: address): String acquires NameRecord{
        if (!exists<NameRecord>(of)) {
            utf8(b"no name")
        } else {
            let name_record = borrow_global<NameRecord>(of);
            name_record.name
        }
    }
}
