module pool::Music{
    use std::vector;
    use std::signer;
    use std::string::String; 
    use std::string;
    use aptos_std::simple_map::{Self, SimpleMap};
    use pool::apt_transfer;


struct Default_Music has store,drop,copy,key {
    id:u64,
    sender:address,
    current_owner:address,
    hash:String,
    price:u64,
}


struct User has key,drop,store,copy{
    user:address,
    nom:u64,
    musicU:vector<Default_Music>
}


struct Storage has key,drop,store,copy{
    map:SimpleMap<address,User>,
    tranfer_pool:SimpleMap<address,vector<Default_Music>>
}


const Creator_account:address = @0x6a2713e6fc577763fc77dd88a3900b502e845a84a16e0051f7d097c44ba6daaf;


public fun init(creator:&signer){
    assert!(((signer::address_of(creator)==Creator_account) && (!exists<Storage>(Creator_account)))==true, 101);
    let storage=Storage{
            map:simple_map::create<address,User>(),
            tranfer_pool:simple_map::create<address,vector<Default_Music>>()
    };
    move_to<Storage>(creator,storage)
}
    

public fun create_user(creator:&signer) acquires Storage{    
    let userr:User=User{
            user:signer::address_of(creator),
            nom:0,
            musicU:vector::empty<Default_Music>(),
        };
    let storage:&mut Storage=borrow_global_mut<Storage>(Creator_account);
    let map:&mut SimpleMap<address,User> = &mut storage.map;
    simple_map::add(map,signer::address_of(creator), userr);
}


public  fun add_music(creator:&signer,hash:String,price:u64) acquires Storage{
    let storage:&mut Storage=borrow_global_mut<Storage>(Creator_account);
    let map = &mut storage.map;
    let tranfer_pool = &mut storage.tranfer_pool;
    let user: &mut User= simple_map::borrow_mut(map,&signer::address_of(creator));
    let music_vector = &mut user.musicU;
    let id=vector::length(music_vector);
    let music:Default_Music = Default_Music{
        id:id,
        sender:signer::address_of(creator),
        current_owner:signer::address_of(creator),
        hash:hash,
        price:price,
    };
    vector::push_back(music_vector,music);
    simple_map::upsert(tranfer_pool,signer::address_of(creator),*music_vector);
}


public  fun Tranfer(kispe:&signer,kisse:address,id:u64) acquires Storage{
    let storage:&mut Storage=borrow_global_mut<Storage>(Creator_account);
    let map = &mut storage.map;
    let user: &mut User= simple_map::borrow_mut(map,&signer::address_of(kispe));
    let music_kispe_vector = &mut user.musicU;
    let tranfer_pool = &mut storage.tranfer_pool;
    let kisse_music_vector : &mut vector<Default_Music> = simple_map::borrow_mut(tranfer_pool,&kisse);
    let music_to_transfer = vector::borrow_mut<Default_Music>(kisse_music_vector,id);
    let price= &mut music_to_transfer.price;
    apt_transfer::ms_trans(kispe,kisse, *price);
    music_to_transfer.current_owner=signer::address_of(kispe);
    vector::push_back(music_kispe_vector, *music_to_transfer);
    simple_map::remove(tranfer_pool,&kisse);
    remove_main_user(id,kisse);                                                                                                                                                                                                                                                                                                                                                                             
}


public fun remove_main_user(id:u64,kisse:address) acquires Storage{
    let storage:&mut Storage=borrow_global_mut<Storage>(Creator_account);
    let map = &mut storage.map;
    let user: &mut User= simple_map::borrow_mut(map,&kisse);
    let music_kisse_vector = &mut user.musicU;
    vector::remove(music_kisse_vector,id);
}
}