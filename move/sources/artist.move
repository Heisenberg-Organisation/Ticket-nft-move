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
    artistName: String,
    streamId: String,
    }

struct Artist has key, store,drop,copy{
    artistName: String,
    artistCollection: vector<String>,
    musicKey: address,
    }


struct UserTicketCollection has key, store,drop, copy{
    userName: String,
    user_addr: address,
    governanceTicket:u64,
    ticketList: vector<Ticket>,
    song_list: vector<Music>,
    }

struct Music has store, drop, key, copy {
    id: u64, 
    title: String,
    dateUploaded: u64,
    thumbnail: String,
    album: String,
    genre: vector<u64>,
    duration: u64,
    artist: address,
    artistName: String,
    hash: String,
    price: u64,
    isVoted: bool,
}


struct Storage has store ,key ,drop {
    artists: SimpleMap<address, Artist>,
    users: SimpleMap<address, UserTicketCollection>,
    eventCollection: SimpleMap<String, ArtistTicketCollection>,
    musicCollection: vector<Music>,
    a2m: SimpleMap<address, vector<Music>>,
    numArtists: u64,
    }

    const AUTHORIZATION_ERROR: u64 = 100;
    const ARTIST_ALREADY_EXISTS: u64 = 101;
    const ARTIST_DOES_NOT_EXIST: u64 = 102;
    const ARTIST_COLLECTION_DOES_NOT_EXIST: u64 = 103;
    const ARTIST_COLLECTION_ALREADY_EXISTS: u64 = 104;
    const ARTIST_COLLECTION_NOT_OPEN_FOR_SALE: u64 = 105;
    const ARTIST_COLLECTION_SOLD_OUT: u64 = 106;
    const EVENT_NOT_STARTED: u64 = 107;
    const EVENT_ENDED: u64 = 108;
    const TICKET_DOES_NOT_EXIST: u64 = 109;
    const USER_ALREADY_EXISTS: u64 = 110;
    const USER_ALREADY_VOTED_FOR_SONG:u64 = 111;
    const USER_ALREADY_HAS_SONG: u64 = 112;
    const INVALID_START_TIME: u64 = 113;
    const INVALID_END_TIME: u64 = 114;
    const INVALID_NUMBER_OF_TICKETS: u64 = 115;
    const TICKET_NOT_FOUND_IN_USER_COLLECTION: u64 = 116;
    const STORAGE_DOES_NOT_EXIST: u64 = 117;

const Creator_account: address = @pool;


public fun init_storage(creator:&signer) {
    // check whether the correct account is calling the function
    assert!(signer::address_of(creator) == Creator_account && (!exists<Storage>(Creator_account))==true,AUTHORIZATION_ERROR);
            let storage = Storage {
                artists: simple_map::create<address, Artist>(),
                users: simple_map::create<address, UserTicketCollection>(),
                eventCollection: simple_map::create<String, ArtistTicketCollection>(),
                a2m: simple_map::create<address, vector<Music>>(),
                musicCollection: vector::empty<Music>(),
                numArtists: 0,
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
    // check whether storage exists
    assert!(exists<Storage>(Creator_account)==true,STORAGE_DOES_NOT_EXIST);

    let storage:&mut Storage = borrow_global_mut<Storage>(Creator_account);
    // check whether the artist already exists
    let artist_exists = simple_map::contains_key(&storage.artists, &signer::address_of(artist));
    assert!(artist_exists == false, ARTIST_ALREADY_EXISTS);

    let artist_obj = Artist {
        artistName: artistName,
        artistCollection: vector::empty<String>(),
        musicKey: signer::address_of(artist),
    };
    simple_map::add(&mut storage.artists, signer::address_of(artist), artist_obj);
    let a2m=&mut storage.a2m;
    let num = &mut storage.numArtists;
    *num = *num + 1;
    let music_vector = vector::empty<Music>();
    simple_map::add(a2m,signer::address_of(artist),music_vector);
    }



public fun createNewArtistCollection(a_Creator: &signer, eventName: String, price: u64, num_tickets: u64, startTime: u64, endTime: u64,banner:String, link: String, streamId: String) acquires Storage{
    // check whether storage exists
    assert!(exists<Storage>(Creator_account)==true,STORAGE_DOES_NOT_EXIST);
    
    let storage:&mut Storage =borrow_global_mut<Storage>(Creator_account);
    
    // check whether the artist exists
    let artist_exists = simple_map::contains_key(&mut storage.artists, &signer::address_of(a_Creator));
    assert!(artist_exists == true, ARTIST_DOES_NOT_EXIST);
    
    let artist:&mut Artist=simple_map::borrow_mut(&mut storage.artists, &signer::address_of(a_Creator));
    let ticket_list = vector::empty<Ticket>();
    let uid = eventName;

    // check whether the artist collection already exists
    let event_exists = simple_map::contains_key(&storage.eventCollection, &uid);
    assert!(event_exists == false, ARTIST_COLLECTION_ALREADY_EXISTS);

    // check whether the start time is more than current time
    // let current_time = timestamp::now_seconds();
    // assert!(startTime > current_time, INVALID_START_TIME);

    // check whether the start time is less than end time
    // assert!(startTime < endTime, INVALID_END_TIME);

    // check whether the number of tickets is greater than 0
    assert!(num_tickets > 0, INVALID_NUMBER_OF_TICKETS);

    let max_tickets=num_tickets;

    // create tickets
    while (num_tickets > 0){
        let ticket:Ticket=Ticket{
            eventId: uid,
            ticketId:vector::length(&ticket_list),
            owner: signer::address_of(a_Creator),
            artist: signer::address_of(a_Creator),
            startTime: startTime,
            endTime: endTime,
            streamLink: link,
            };
        vector::push_back<Ticket>(&mut ticket_list, ticket);
        num_tickets = num_tickets - 1;
    };

    // create artist collection
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
        artistName: artist.artistName,
        streamId: streamId,
    };

    // add artist collection to the storage
    simple_map::add(&mut storage.eventCollection, uid, artistCollection);
    vector::push_back(&mut artist.artistCollection, eventName);
    }

public fun createCollection_user(user: &signer, user_name: String) acquires Storage{
    // check whether storage exists
     assert!(exists<Storage>(Creator_account)==true,STORAGE_DOES_NOT_EXIST);
    
    let storage:&mut Storage = borrow_global_mut<Storage>(Creator_account);
    // check whether the user already exists
    let user_exists = simple_map::contains_key(&storage.users, &signer::address_of(user));
    assert!(user_exists == false, USER_ALREADY_EXISTS);
    let utc:UserTicketCollection = UserTicketCollection{
        user_addr: signer::address_of(user),
        governanceTicket:0,
        ticketList: vector::empty<Ticket>(),
        song_list: vector::empty<Music>(),
        userName: user_name
    };
    simple_map::add(&mut storage.users, signer::address_of(user), utc);
    }

public fun TransferTicket(user: &signer, artist_addr: address, eventName: String ) acquires Storage {
    // check whether storage exists
     assert!(exists<Storage>(Creator_account)==true,STORAGE_DOES_NOT_EXIST);
    
    let storage:&mut Storage = borrow_global_mut<Storage>(Creator_account);
    let artistCollection: &mut ArtistTicketCollection = simple_map::borrow_mut(&mut storage.eventCollection, &eventName);
    assert!(artistCollection.maxTickets>0,ARTIST_COLLECTION_SOLD_OUT);
    artistCollection.maxTickets=artistCollection.maxTickets-1;
    let artist_ticktes=&mut artistCollection.ticketList;
    assert!(vector::length(artist_ticktes)>0,ARTIST_COLLECTION_SOLD_OUT);
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
     
// the owner can burn the ticket after start of the event, but before the end of the event
// it will receive 25 governance token for this action 
public fun burn(user: &signer, eventName: String, ticketId: u64) acquires Storage {
    // check whether storage exists
     assert!(exists<Storage>(Creator_account)==true,STORAGE_DOES_NOT_EXIST);
    
    let storage:&mut Storage = borrow_global_mut<Storage>(Creator_account);
    // fetch the ticket from the user collection matching the ticketId and the eventName
    let user_collection: &mut UserTicketCollection = simple_map::borrow_mut(&mut storage.users, &signer::address_of(user));
    let user_tickets:&mut vector<Ticket> = &mut user_collection.ticketList;

    let i = 0;
    let found: bool = false;
    let len = vector::length(user_tickets);
    while (i < len) {
        let ticket = vector::borrow_mut(user_tickets, i);
        if (ticket.eventId == eventName && ticket.ticketId == ticketId) {
            // check whether the event has started
            let artistCollection: &mut ArtistTicketCollection = simple_map::borrow_mut(&mut storage.eventCollection, &eventName);
            let current_time = timestamp::now_seconds();
            assert!(current_time < artistCollection.startTime, EVENT_NOT_STARTED);
            // check whether the event has ended
            assert!(current_time > artistCollection.endTime, EVENT_ENDED);
            // burn the ticket
            vector::remove(user_tickets, i);
            // transfer 25 governance tokens to the user
            let governanceTicket = &mut user_collection.governanceTicket;
            *governanceTicket = *governanceTicket + 25;
            simple_map::upsert(&mut storage.users,signer::address_of(user),*user_collection);
            return
        };
        i = i + 1;
    };
    assert!(found == true, TICKET_NOT_FOUND_IN_USER_COLLECTION);
}


public fun add_music(creator:&signer , title:String, thumbnail:String , album:String , duration:u64 ,dateUploaded:u64, hash:String , price:u64) acquires Storage{
    // check whether storage exists
     assert!(exists<Storage>(Creator_account)==true,STORAGE_DOES_NOT_EXIST);

    let storage:&mut Storage=borrow_global_mut<Storage>(Creator_account);
    let a2m=&mut storage.a2m;
    let artist_addr = signer::address_of(creator);

    // check whether the artist already exists
    let artist_exists = simple_map::contains_key(&storage.artists, &artist_addr);
    assert!(artist_exists == true, ARTIST_DOES_NOT_EXIST);

    let musicList = &mut storage.musicCollection;
    let artist:&mut Artist=simple_map::borrow_mut(&mut storage.artists, &artist_addr);
    let music_vector=simple_map::borrow_mut(a2m,&signer::address_of(creator));
    let music_key= signer::address_of(creator);
    let id=vector::length(music_vector);
    let music:Music = Music{
        id:id,
        title:title,
        dateUploaded:dateUploaded,
        thumbnail:thumbnail,
        album:album,
        genre:vector<u64>[0,0,0,0],
        duration:duration,
        artistName: artist.artistName,
        artist:signer::address_of(creator),
        hash:hash,
        price:price,
        isVoted:false,
    };
    vector::push_back(music_vector,music);
    vector::push_back(musicList, music);
    simple_map::upsert(a2m,music_key,*music_vector);
}


public fun transfer_music(user:&signer,artist: address, music_id:u64,genre_id:u64) acquires Storage{
    // check whether storage exists
     assert!(exists<Storage>(Creator_account)==true,STORAGE_DOES_NOT_EXIST);
    
    let storage:&mut Storage=borrow_global_mut<Storage>(Creator_account);
    let a2m=&mut storage.a2m;
    let users = &mut storage.users;
    let user_music_vector= simple_map::borrow_mut(users,&signer::address_of(user));
    let song_list=&mut user_music_vector.song_list;
    let music_vector_artist = simple_map::borrow_mut(a2m,&artist);
    let music_addr_artist = vector::borrow_mut(music_vector_artist,music_id);
    // check whether the user already has the song in its collection
    let user_has_song = vector::contains(song_list, music_addr_artist);
    assert!(user_has_song == false, USER_ALREADY_HAS_SONG);

    let genre_vector = &mut music_addr_artist.genre;
    let genre = vector::borrow_mut(genre_vector,genre_id);
    *genre=*genre + 1;
    let music=music_addr_artist;    
    vector::push_back(song_list,*music);
    let num_user_songs = vector::length(song_list);
    let music_copy = vector::borrow_mut(song_list,num_user_songs-1);
    let isVoted = &mut music_copy.isVoted;
    *isVoted = true;
    apt_transfer::ms_trans(user,artist, music.price);
    }

}