module pool::artist_marketplace {

    use std::signer;
    use std::vector;
    use std::string::String;
    use std::string;
    use aptos_framework::timestamp;
    use aptos_std::simple_map::{Self, SimpleMap};
    use pool::apt_transfer;

struct Ticket has key, store , drop, copy {
    eventId:vector<u8>,
    ticketId:u64,
    owner: address,
    artist: address,
    startTime: u64,
    endTime: u64,
    }

struct ArtistTicketCollection has key, store, drop,copy {
    eventName: String,
    price:u64,
    maxTickets: u64,
    ticketList: vector<Ticket>,
    availableForSale:bool,
    startTime: u64,
    endTime: u64,
    author:address,
    banner:String,
    }

struct Artist has key, store,drop,copy{
    artistName: String,
    artistCollection: vector<ArtistTicketCollection>,
    name2collection: SimpleMap<String, ArtistTicketCollection>,
    }


struct UserTicketCollection has key, store,drop {
    user_addr: address,
    governanceTicket:u64,
    ticketList: vector<Ticket>,
    }


struct Storage has store ,key ,drop {
    artists: SimpleMap<address, Artist>,
    users: SimpleMap<address, UserTicketCollection>,
    a2u:SimpleMap<address,  vector<Ticket>>,
    u2u:SimpleMap<address,  vector<Ticket>>,
    
    }

    const AUTHORIZATION_ERROR: u64 = 1;
    const ARTIST_ALREADY_EXISTS: u64 = 100;
    const ARTIST_DOES_NOT_EXIST: u64 = 101;
    const ARTIST_COLLECTION_DOES_NOT_EXIST: u64 = 102;
    const ARTIST_COLLECTION_ALREADY_EXISTS: u64 = 103;
    const ARTIST_COLLECTION_NOT_OPEN_FOR_SALE: u64 = 104;
    const ARTIST_COLLECTION_SOLD_OUT: u64 = 105;
    const EVENT_NOT_STARTED: u64 = 106;
    const EVENT_ENDED: u64 = 107;
    const TICKET_DOES_NOT_EXIST: u64 = 108;
    const USER_ALREADY_EXISTS: u64 = 109;
    const STORAGE_EXIST:u64=404;

const Creator_account: address = @0x28a94ba89b8637a6166d660ce089d37cf33e8ded7a9a5cdfd7b061453cd46797;



public fun init_storage(creator:&signer) {
    assert!(signer::address_of(creator) == Creator_account && (!exists<Storage>(Creator_account))==true,101);
            let storage = Storage {
                artists: simple_map::create<address, Artist>(),
                users: simple_map::create<address, UserTicketCollection>(),
                a2u: simple_map::create<address, vector<Ticket>> (),
                u2u: simple_map::create<address, vector<Ticket>> (),
            };
    move_to<Storage>(creator, storage);

    }



public fun generateTID(artist_name: String, eventName: String): vector<u8> {
    let artist_name_bytevector_addr:&vector<u8> = string::bytes(&artist_name);
    let event_name_bytevector_addr:&vector<u8> = string::bytes(&eventName);
    let artist_name_bytevector:vector<u8> = *artist_name_bytevector_addr;
    let event_name_bytevector:vector<u8> = *event_name_bytevector_addr;
    vector::append<u8>(&mut artist_name_bytevector, event_name_bytevector);
    return artist_name_bytevector
    }



public fun createArtist(artist: &signer, artistName: String) acquires Storage{
    let storage:&mut Storage = borrow_global_mut<Storage>(Creator_account);
    let artist_obj = Artist {
        artistName: artistName,
        artistCollection: vector::empty<ArtistTicketCollection>(),
        name2collection: simple_map::create<String, ArtistTicketCollection>(),
    };
    simple_map::add(&mut storage.artists, signer::address_of(artist), artist_obj);
    }



public fun createNewArtistCollection(a_Creator: &signer, eventName: String, price: u64, num_tickets: u64, startTime: u64, endTime: u64,banner:String) acquires Storage{
    let storage:&mut Storage =borrow_global_mut<Storage>(Creator_account);
    let artist:&mut Artist=simple_map::borrow_mut(&mut storage.artists, &signer::address_of(a_Creator));
    let ticket_list = vector::empty<Ticket>();
    let uid=generateTID(artist.artistName, eventName);
    let max_tickets=num_tickets;
    while(num_tickets > 0){
        let ticket:Ticket=Ticket{
            eventId:uid,
            ticketId:vector::length(&ticket_list),
            owner: signer::address_of(a_Creator),
            artist: signer::address_of(a_Creator),
            startTime: startTime,
            endTime: endTime,
            };
    vector::push_back<Ticket>(&mut ticket_list, ticket);
    num_tickets = num_tickets - 1;
    };       
    let artistCollection:ArtistTicketCollection = ArtistTicketCollection {
        eventName: eventName,
        price: price,
        maxTickets: max_tickets,
        ticketList:ticket_list,
        availableForSale: false,
        startTime: startTime,
        endTime: endTime,
        author:signer::address_of(a_Creator),
        banner:banner,
    };
    simple_map::add(&mut artist.name2collection, eventName, artistCollection);
    vector::push_back(&mut artist.artistCollection, artistCollection);
    }



public fun createCollection_user(user: &signer) acquires Storage{
    let storage:&mut Storage = borrow_global_mut<Storage>(Creator_account);
    let utc:UserTicketCollection = UserTicketCollection{
    user_addr: signer::address_of(user),
    ticketList: vector::empty<Ticket>(),
    governanceTicket:0,
    };
    simple_map::add(&mut storage.users,signer::address_of(user),utc);
    }

public fun TransferTicket(user: &signer, artist_addr: address, artistCollection: String ) acquires Storage {
    let storage:&mut Storage = borrow_global_mut<Storage>(Creator_account);
    let u2u = &mut storage.u2u;
    let artist:&mut Artist=simple_map::borrow_mut(&mut storage.artists, &artist_addr);
    let artistCollection = simple_map::borrow_mut(&mut artist.name2collection, &artistCollection);
    artistCollection.maxTickets=artistCollection.maxTickets-1;
    let artist_ticktes=&mut artistCollection.ticketList;
    let ticketId = vector::length(artist_ticktes) - 1;
    assert!(artistCollection.availableForSale==true,404);
    let artist_ticket = &mut artistCollection.ticketList;      
    let users_collection:&mut UserTicketCollection=simple_map::borrow_mut(&mut storage.users, &signer::address_of(user));
    let user_tickets:&mut vector<Ticket> = &mut users_collection.ticketList;
    users_collection.governanceTicket=users_collection.governanceTicket+25;
    let price: u64 = artistCollection.price;
    apt_transfer::ms_trans(user,artist_addr, price);
    let ticket= vector::borrow_mut(artist_ticket,ticketId);
    ticket.owner=signer::address_of(user);
    let ticket2tranfer = vector::borrow_mut<Ticket>(&mut artistCollection.ticketList, ticketId);
    vector::push_back(user_tickets,*ticket2tranfer);
    simple_map::upsert(&mut storage.a2u,signer::address_of(user),*user_tickets);
    simple_map::upsert(u2u,signer::address_of(user),*user_tickets);
    vector::remove(&mut artistCollection.ticketList, ticketId);  
    }
     

public fun setforsale(artist:&signer,artistCollection:String) acquires Storage{    
    let storage:&mut Storage = borrow_global_mut<Storage>(Creator_account);
    let artistt:&mut Artist=simple_map::borrow_mut(&mut storage.artists, &signer::address_of(artist));
    let artistCollection = simple_map::borrow_mut(&mut artistt.name2collection, &artistCollection);
    artistCollection.availableForSale=true;
    }


public entry fun u2u(kispe:&signer,kisse:address,price:u64,id:u64) acquires Storage{
    let storage:&mut Storage=borrow_global_mut<Storage>(Creator_account);
    let user_kispe = &mut storage.users;
    let user: &mut UserTicketCollection= simple_map::borrow_mut(user_kispe,&signer::address_of(kispe));
    let ticket_kispe_vector = &mut user.ticketList;
    let u2u = &mut storage.u2u;
    let kisse_Ticket_vector : &mut vector<Ticket> = simple_map::borrow_mut(u2u,&kisse);
    let ticket_to_transfer = vector::borrow_mut<Ticket>(kisse_Ticket_vector,id);
    let price2u = price*9/10;
    apt_transfer::ms_trans(kispe,kisse, price2u);
    ticket_to_transfer.owner=signer::address_of(kispe);
    vector::push_back(ticket_kispe_vector, *ticket_to_transfer);
    simple_map::remove(u2u,&kisse);
    remove_main_user(id,kisse);                                                                                                                                                                                                                                                                                                                                                                             
    }


public fun remove_main_user(id:u64,kisse:address) acquires Storage{
    let storage:&mut Storage=borrow_global_mut<Storage>(Creator_account);
    let user_kisse = &mut storage.users;
    let user: &mut UserTicketCollection= simple_map::borrow_mut(user_kisse,&kisse);
    let ticket_kisse_vector = &mut user.ticketList;
    vector::remove(ticket_kisse_vector,id);
    }



}