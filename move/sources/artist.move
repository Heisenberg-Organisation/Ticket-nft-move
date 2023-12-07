module pool::artist_marketplace {

    use std::signer;
    use std::vector;
    use std::string::String;
    use std::string;
    use aptos_framework::timestamp;
    use aptos_std::simple_map::{Self, SimpleMap};
    use pool::apt_transfer;

struct Ticket has key, store , drop, copy {
    eventId:String,
    ticketId:u64,
    owner: address,
    artist: address,
    startTime: u64,
    endTime: u64,
    streamLink: String
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
    artistCollection: vector<String>,
    musicKey: address,
    // name2collection: SimpleMap<String, ArtistTicketCollection>,
    }


struct UserTicketCollection has key, store,drop, copy{
    user_addr: address,
    governanceTicket:u64,
    ticketList: vector<Ticket>,
    songList: vector<Music>,
    }

struct Music has store, drop, key, copy {
    id: u64, 
    title: String,
    dataUploaded: u64,
    thumbnail: String,
    album: String,
    duration: u64,
    artist: address,
    hash: String,
    price: u64,
}


struct Storage has store ,key ,drop {
    artists: SimpleMap<address, Artist>,
    users: SimpleMap<address, UserTicketCollection>,
    // a2u: SimpleMap<address,  vector<Ticket>>,
    // u2u: SimpleMap<address,  vector<Ticket>>,
    eventCollection: SimpleMap<String, ArtistTicketCollection>,
    ticketCollection: SimpleMap<u64, Ticket>,
    a2m: SimpleMap<address, vector<Music>>,
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

const Creator_account: address = @0x6a2713e6fc577763fc77dd88a3900b502e845a84a16e0051f7d097c44ba6daaf;


public entry fun init_storage(creator:&signer) {
    assert!(signer::address_of(creator) == Creator_account && (!exists<Storage>(Creator_account))==true,101);
            let storage = Storage {
                artists: simple_map::create<address, Artist>(),
                users: simple_map::create<address, UserTicketCollection>(),
                // a2u: simple_map::create<address, vector<Ticket>> (),
                // u2u: simple_map::create<address, vector<Ticket>> (),
                eventCollection: simple_map::create<String, ArtistTicketCollection>(),
                ticketCollection: simple_map::create<u64, Ticket>(),
                a2m: simple_map::create<address, vector<Music>>(),
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



public entry fun createArtist(artist: &signer, artistName: String) acquires Storage{
    let storage:&mut Storage = borrow_global_mut<Storage>(Creator_account);
    let artist_obj = Artist {
        artistName: artistName,
        artistCollection: vector::empty<String>(),
        musicKey: signer::address_of(artist),
        // name2collection: simple_map::create<String, ArtistTicketCollection>(),
    };
    simple_map::add(&mut storage.artists, signer::address_of(artist), artist_obj);
    }



public entry fun createNewArtistCollection(a_Creator: &signer, eventName: String, price: u64, num_tickets: u64, startTime: u64, endTime: u64,banner:String, link: String) acquires Storage{
    // let storage:&mut Storage =borrow_global_mut<Storage>(Creator_account);
    // let artist:&mut Artist=simple_map::borrow_mut(&mut storage.artists, &signer::address_of(a_Creator));
    // let ticket_list = vector::empty<Ticket>();
    // let uid=generateTID(artist.artistName, eventName);
    // let max_tickets=num_tickets;
    // while(num_tickets > 0){
    //     let ticket:Ticket=Ticket{
    //         eventId:uid,
    //         ticketId:vector::length(&ticket_list),
    //         owner: signer::address_of(a_Creator),
    //         artist: signer::address_of(a_Creator),
    //         startTime: startTime,
    //         endTime: endTime,
    //         streamLink: String::from(""),
    //         };
    //     vector::push_back<Ticket>(&mut ticket_list, ticket);
    //     num_tickets = num_tickets - 1;
    // };       
    // let artistCollection:ArtistTicketCollection = ArtistTicketCollection {
    //     eventName: eventName,
    //     price: price,
    //     maxTickets: max_tickets,
    //     ticketList:ticket_list,
    //     availableForSale: false,
    //     startTime: startTime,
    //     endTime: endTime,
    //     author:signer::address_of(a_Creator),
    //     banner:banner,
    // };
    // simple_map::add(&mut artist.name2collection, eventName, artistCollection);
    // vector::push_back(&mut artist.artistCollection, artistCollection);

    let storage:&mut Storage =borrow_global_mut<Storage>(Creator_account);
    let artist:&mut Artist=simple_map::borrow_mut(&mut storage.artists, &signer::address_of(a_Creator));
    let ticket_list = vector::empty<Ticket>();
    // let uid=generateTID(artist.artistName, eventName);
    let uid = eventName;
    let eventID = eventName;
    let max_tickets=num_tickets;

    while (num_tickets > 0){
        let ticket:Ticket=Ticket{
            eventId: uid,
            ticketId:vector::length(&ticket_list),
            owner: signer::address_of(a_Creator),
            artist: signer::address_of(a_Creator),
            startTime: startTime,
            endTime: endTime,
            streamLink: link
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
        banner: banner,
    };
    simple_map::add(&mut storage.eventCollection, uid, artistCollection);
    vector::push_back(&mut artist.artistCollection, eventName);
    }

public entry fun createCollection_user(user: &signer) acquires Storage{
    let storage:&mut Storage = borrow_global_mut<Storage>(Creator_account);
    let utc:UserTicketCollection = UserTicketCollection{
        user_addr: signer::address_of(user),
        governanceTicket:0,
        ticketList: vector::empty<Ticket>(),
        songList: vector::empty<Music>(),
    };
    simple_map::add(&mut storage.users, signer::address_of(user), utc);
    }

public entry fun TransferTicket(user: &signer, artist_addr: address, eventName: String ) acquires Storage {
    // let storage:&mut Storage = borrow_global_mut<Storage>(Creator_account);
    // let u2u = &mut storage.u2u;
    // let artist:&mut Artist=simple_map::borrow_mut(&mut storage.artists, &artist_addr);
    // let artistCollection = simple_map::borrow_mut(&mut artist.name2collection, &artistCollection);
    // assert!(artistCollection.maxTickets>0,105);
    // artistCollection.maxTickets=artistCollection.maxTickets-1;
    // let artist_ticktes=&mut artistCollection.ticketList;
    // assert!(vector::length(artist_ticktes)>0,105);
    // let ticketId = vector::length(artist_ticktes) - 1;
    // let artist_ticket = &mut artistCollection.ticketList;      
    // let users_collection:&mut UserTicketCollection=simple_map::borrow_mut(&mut storage.users, &signer::address_of(user));
    // let user_tickets:&mut vector<Ticket> = &mut users_collection.ticketList;
    // users_collection.governanceTicket=users_collection.governanceTicket+25;
    // let price: u64 = artistCollection.price;
    // apt_transfer::ms_trans(user,artist_addr, price);
    // let ticket= vector::borrow_mut(artist_ticket,ticketId);
    // ticket.owner=signer::address_of(user);
    // let ticket2tranfer = vector::borrow_mut<Ticket>(&mut artistCollection.ticketList, ticketId);
    // vector::push_back(user_tickets,*ticket2tranfer);
    // simple_map::upsert(&mut storage.a2u,signer::address_of(user),*user_tickets);
    // simple_map::upsert(u2u,signer::address_of(user),*user_tickets);
    // vector::remove(&mut artistCollection.ticketList, ticketId);  

    let storage:&mut Storage = borrow_global_mut<Storage>(Creator_account);
    let artist:&mut Artist=simple_map::borrow_mut(&mut storage.artists, &artist_addr);
    let artistCollection: &mut ArtistTicketCollection = simple_map::borrow_mut(&mut storage.eventCollection, &eventName);
    assert!(artistCollection.maxTickets>0,105);
    artistCollection.maxTickets=artistCollection.maxTickets-1;
    let artist_ticktes=&mut artistCollection.ticketList;
    assert!(vector::length(artist_ticktes)>0,105);
    let ticketId = vector::length(artist_ticktes) - 1;
    let artist_ticket = &mut artistCollection.ticketList;
    let users_collection:&mut UserTicketCollection=simple_map::borrow_mut(&mut storage.users, &signer::address_of(user));
    let user_tickets:&mut vector<Ticket> = &mut users_collection.ticketList;
    let price: u64 = artistCollection.price;
    apt_transfer::ms_trans(user,artist_addr, price);
    let ticket: &mut Ticket= vector::borrow_mut(artist_ticket,ticketId);
    ticket.owner=signer::address_of(user);
    vector::push_back(user_tickets, *ticket);
    simple_map::upsert(&mut storage.users,signer::address_of(user),*users_collection);
    vector::remove(&mut artistCollection.ticketList, ticketId);
    }
     

// public fun setforsale(artist:&signer,artistCollection:String) acquires Storage{    
//     let storage:&mut Storage = borrow_global_mut<Storage>(Creator_account);
//     let artistt:&mut Artist=simple_map::borrow_mut(&mut storage.artists, &signer::address_of(artist));
//     let artistCollection = simple_map::borrow_mut(&mut artistt.name2collection, &artistCollection);
//     artistCollection.availableForSale=true;
//     }

// public entry fun u2u(kispe:&signer,kisse:address,price:u64,id:u64) acquires Storage{
//     let storage:&mut Storage=borrow_global_mut<Storage>(Creator_account);
//     let user_kispe = &mut storage.users;
//     let user: &mut UserTicketCollection= simple_map::borrow_mut(user_kispe,&signer::address_of(kispe));
//     let ticket_kispe_vector = &mut user.ticketList;
//     let u2u = &mut storage.u2u;
//     let kisse_Ticket_vector : &mut vector<Ticket> = simple_map::borrow_mut(u2u,&kisse);
//     let ticket_to_transfer = vector::borrow_mut<Ticket>(kisse_Ticket_vector,id);
//     let price2u = price*9/10;
//     apt_transfer::ms_trans(kispe,kisse, price2u);
//     ticket_to_transfer.owner=signer::address_of(kispe);
//     user.governanceTicket=user.governanceTicket+25;
//     vector::push_back(ticket_kispe_vector, *ticket_to_transfer);
//     simple_map::remove(u2u,&kisse);
//     remove_main_user(id,kisse);                                                                                                                                                                                                                                                                                                                                                                             
//     }


// public fun remove_main_user(id:u64,kisse:address) acquires Storage{
//     let storage:&mut Storage=borrow_global_mut<Storage>(Creator_account);
//     let user_kisse = &mut storage.users;
//     let user: &mut UserTicketCollection= simple_map::borrow_mut(user_kisse,&kisse);
//     let ticket_kisse_vector = &mut user.ticketList;
//     user.governanceTicket=user.governanceTicket-25;
//     vector::remove(ticket_kisse_vector,id);
//     }

// the owner can burn the ticket after start of the event, but before the end of the event
// it will receive 25 governance token for this action 
// public entry fun burn(user: &signer, eventName: String, ticketId: u64) acquires Storage { 

//     }

public entry fun transferMusic(artist: address, user: &signer, id: u64) acquires Storage {
    // this will add the music to the user's collection
    // and tranfer the price to the artist's wallet. it will not remove the music from the artist's collection
    let storage:&mut Storage = borrow_global_mut<Storage>(Creator_account);
    let artist_music = &mut storage.a2m;
    let users = &mut storage.users;
    let artist_music_vector = simple_map::borrow_mut(artist_music,&artist);
    let user_music_vector = simple_map::borrow_mut(users,&signer::address_of(user));
    let songList = &mut user_music_vector.songList;
    let music_to_transfer = vector::borrow_mut<Music>(artist_music_vector,id);
    let price = music_to_transfer.price;
    vector::push_back(songList, *music_to_transfer);
    apt_transfer::ms_trans(user,artist, price);
    }    
}
