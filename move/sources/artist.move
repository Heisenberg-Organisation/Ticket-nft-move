
module ticket_addr::artist_marketplace {
    use std::signer;
    use std::vector;
    use std::string::String;
    use aptos_framework::timestamp;
    use aptos_std::simple_map::{Self, SimpleMap};

    struct Ticket has key, store {
        ticketID:vector<u8>,
        current_owner: signer::address,
        artist: signer::address,
        start_time: u64,
        end_time: u64,
    }

    struct ArtistTicketCollection has key, store, drop {
        event_name: String,
        Price: u64,
        max_no_tickets: u64,
        tickets: vector<u64>,
        start_time: u64,
        end_time: u64,
        available_for_sale:bool,
    }

    struct Artist has key, store {
        name: String,
        artist_addr: signer::address,
        artist_collection: vector<ArtistTicketCollection>,
        collection_mapping: SimpleMap<String, ArtistTicketCollection>,
    }

    struct UserTicketCollection has key, store {
        user_addr: signer::address,
        tickets: vector<Ticket>,
    }

    struct Storage has store {
        artists: SimpleMap<signer::address, Artist>,
        users: SimpleMap<signer::address, UserTicketCollection>,
    }

    // error codes
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

    const creator_account: address = @0x123;

    public fun init_storage(creator:&signer) : Storage {
        if (signer::address_of(creator) == creator_account && (!exists<Storage>(creator_account))) {
            let storage = Storage {
                artists: SimpleMap<signer::address, Artist>::new(),
                users: SimpleMap<signer::address, UserTicketCollection>::new(),
            };
            move_to<Storage>(creator, storage);
        }    
    }

    public fun generateTID(artist_name: String, event_name: String, seq_num: u64): vector<u8> {
        let artist_name_bytevector_addr:&vector<u8> = string::bytes(&artist_name);
        let event_name_bytevector_addr:&vector<u8> = string::bytes(&event_name);
        let seq_num_bytevector_addr:&vector<u8> = string::bytes(&seq_num);

        let artist_name_bytevector:vector<u8> = *artist_name_bytevector_addr;
        let event_name_bytevector:vector<u8> = *event_name_bytevector_addr;
        let seq_num_bytevector:vector<u8> = *seq_num_bytevector_addr;
        
        vector::append<u8>(&mut artist_name_bytevector, event_name_bytevector);
        vector::append<u8>(&mut artist_name_bytevector, seq_num_bytevector);
        return artist_name_bytevector
    }

    public entry fun createArtist(artist: &signer, name: String) acquires Storage{
        storage = borrow_global_mut<Storage>(signer::address_of(creator_account));
        assert!(simple_map::get<signer::address, Artist>(&storage.artists, signer::address_of(artist)) == none, ARTIST_ALREADY_EXISTS);
        let artist_obj = Artist {
            name: name,
            artist_addr: signer::address_of(artist),
            artist_collection: vector::empty<ArtistTicketCollection>(),
            collection_mapping: SimpleMap<String, ArtistTicketCollection>::new(),
        };
        simple_map::insert<signer::address, Artist>(&mut storage.artists, signer::address_of(artist_obj), artist_obj);
        move_to<Artist>(artist, artist_obj);
    }

    public entry fun createNewArtistCollection(artist: &signer, event_name: String, price: u64, num_tickets: u64, start_time: u64, end_time: u64) acquires Artist, ArtistTicketCollection {
        assert!(simple_map::get<signer::address, Artist>(&storage.artists, signer::address_of(artist)) != none, ARTIST_DOES_NOT_EXIST);
        assert!(simple_map::get<signer::address, Artist>(&storage.artists, signer::address_of(artist)).artist_collection == none, ARTIST_COLLECTION_ALREADY_EXISTS);
        let artist = borrow_global_mut<Artist>(signer::address_of(artist));
        let max_tickets = num_tickets;
        let ticket_list = vector::empty<u64>();
        while(num_tickets > 0){
            let ticket_id = generateTID(artist.name, event_name, num_tickets);
            vector::push_back<u64>(&mut ticket_list, ticket_id);
            num_tickets = num_tickets - 1;
        }
        let artist_collection = ArtistTicketCollection {
            event_name: event_name,
            Price: price,
            max_no_tickets: max_tickets,
            tickets: ticket_list,
            start_time: start_time,
            end_time: end_time,
            available_for_sale: true,
        };
        simple_map::insert<String, ArtistTicketCollection>(&mut artist.collection_mapping, event_name, artist_collection);
        vector::push_back<ArtistTicketCollection>(&mut artist.artist_collection, artist_collection);
        move_to<ArtistTicketCollection>(artist, artist_collection);
    }

    public entry fun createCollection_user(user: &signer) acquires Storage{
        storage = borrow_global_mut<Storage>(signer::address_of(creator_account));
        assert!(simple_map::get<signer::address, UserTicketCollection>(&storage.users, signer::address_of(user)) == none, USER_ALREADY_EXISTS);
        let user = borrow_global_mut<Storage>(signer::address_of(user));
        let user_collection = UserTicketCollection {
            user_addr: signer::address_of(user),
            tickets: vector::empty<Ticket>(),
        };
        simple_map::insert<signer::address, UserTicketCollection>(&mut storage.users, signer::address_of(user_collection), user_collection);
        move_to<UserTicketCollection>(user, user_collection);
    }

    // take input as ticket id, user address, artist address, artist collection and transfer 1 ticket to user
    public entry fun TransferTicket(user: &signer, artist_addr: address, artist_collection: String , ticket_id: u64) acquires Storage {
        storage = borrow_global_mut<Storage>(signer::address_of(creator_account));
        // artist does not exist
        assert!(simple_map::get<signer::address, Artist>(&storage.artists, artist) != none, ARTIST_DOES_NOT_EXIST);
        // artist collection does not exist
        assert!(simple_map::get<signer::address, Artist>(&storage.artists, artist).collection_mapping[artist_collection] != none, ARTIST_COLLECTION_DOES_NOT_EXIST);
        // ticket sold out (available_for_sale = false)
        assert!(simple_map::get<signer::address, Artist>(&storage.artists, artist).collection_mapping[artist_collection].available_for_sale == true, ARTIST_COLLECTION_SOLD_OUT);
        // event ended
        assert!(simple_map::get<signer::address, Artist>(&storage.artists, artist).collection_mapping[artist_collection].end_time > timestamp::now(), EVENT_ENDED);

        let artist = borrow_global_mut<Artist>(signer::address_of(artist));
        let artist_collection = vector::borrow_mut(&mut artist.artist_collection, artist_collection);
        
        let user_collection = borrow_global_mut<UserTicketCollection>(signer::address_of(user));
        let price: u64 = artist_collection.Price;
        let ticket_id = vector::remove<u64>(&mut artist_collection.tickets, ticket_id);
        let ticket = Ticket {
            ticketID: ticket_id,
            current_owner: signer::address_of(user),
            artist: artist_addr,
            start_time: artist_collection.start_time,
            end_time: artist_collection.end_time,
        };

        // check if the user has enough balance to buy the ticket
        

        vector::push_back<Ticket>(&mut user_collection.tickets, ticket);
        move_to<Ticket>(user, ticket);
    }

    //public entry fun U_A(artist:&signer,user:address) acquires UNFTCollection{
     //   let artist_collection = move_from<UNFTCollection>(user);
     //   move_to<UNFTCollection>(artist, artist_collection);
    //}
   // public entry fun setOpenForSale(user: &signer, collection: &mut ArtistTicketCollection) {
    //    assert!(signer::address_of(user) == signer::address_of(collection.artist), 108);
     //   collection.available_for_sale = true;
    //}

    #[test_only]
    use aptos_framework::account::create_account_for_test;




    #[test(creator = @0x123,user=@0x223)]
    public entry fun test_U_ticket_nft(creator: &signer,user:&signer) acquires ArtistTicketCollection,UserTicketCollection{
    create_account_for_test(signer::address_of(creator));
    createCollection_artist(creator,100,vector<u64>[123,111,234,654,244,777]);
    createCollection_user(creator);
    user_ticket_and_nft(creator,@0xde00596286d7b25b5789061ed2e38818cf7ad133fcbda62b877abd5ce03dfa66,1);
    let utickets = borrow_global_mut<UserTicketCollection>(signer::address_of(user));
    let us :&u64 =vector::borrow_mut(&mut utickets.tickets,1);
    assert!(*us == 123, 1);    
   }
}
























    // Function to purchase a ticket
    //public fun purchaseTicket(buyer: &signer, collection: &mut TicketCollection, ticket_id: u64) acquires vector<Ticket> {
        // Check that the collection is open for sale
      //  assert(collection.tickets[ticket_id].open_for_sale, 105);

        // Check that the buyer is not the artist
      //  assert(signer::address_of(buyer) != signer::address_of(&collection.artist), 106);

        // Get the ticket to be purchased
      //  let ticket = vector::remove(&mut collection.tickets, ticket_id);

        // Calculate the amount to transfer to the artist (10% of the ticket price)
     //   let artist_amount = ticket.price / 10;

        // Transfer 90% to the seller (artist)
      //  move_to(ticket.owner, ticket.price - artist_amount);

        // Transfer 10% to the artist
      //  move_to(signer::address_of(&collection.artist), artist_amount);

        // Change the owner of the ticket to the buyer
       // ticket.owner = signer::address_of(buyer);

        // Add the purchased ticket back to the collection
      //  vector::push_back(&mut collection.tickets, ticket);

       // collection.tickets
    //}

    // Function to get details of a ticket
    //public fun getTicketDetails(collection: &TicketCollection, ticket_id: u64): Ticket {
    //    assert(ticket_id < vector::length(&collection.tickets), 107);
     //   vector::borrow(&collection.tickets, ticket_id)
    
    

    








/*module ticket_addr::User_nft_collection{

use ticket_addr::Artist_marketplace;

 struct UNFTCollection has key, store {
        nfts: vector<u64>,
    }

 public fun takeArtistCollection(user: &signer, artist: address) acquires UNFTCollection {
        // Get the artist's collection
        let artist_collection = borrow_global<Artist_marketplace::ArtistTicketCollection>(artist);


        // Create the user's NFT collection
        let user_nft_collection = UNFTCollection { nfts: vector::empty<u64>() };

        // Transfer ownership of the artist's collection to the user
        move_to<UNFTCollection>(user, user_nft_collection);

        // Return the artist's collection to maintain a copy
        move_to<Artist_marketplace::ArtistTicketCollection>(artist, artist_collection);
    }

    struct UMintedCollection has key, store {
        tickets: vector<Ticket>,
    }

    struct U_A_minted has key, store {
        tickets: vector<Ticket>,
    }

    public fun createCollection_user(user: address,collection: &mut ArtistTicketCollection) acquires ArtistTicketCollection {
        move_to<UserTicketCollection>(&user,collection.tickets);
        vector::clear(Ucollectn.tickets);
    }
public fun mintTickets(user:address,Ucollectn:UserTicketCollection,UMintedCollectn: &mut UMintedCollection,ticket_ids: vector<u64>, ticket_prices: vector<u64>) acquires UserTicketCollection {
        // Check that the number of tickets and prices match
        assert!(vector::length(&ticket_ids) == vector::length(&ticket_prices), 101);

        // Check that the artist is not calling this function
        assert!(signer::address_of(&collection.artist) != signer::address_of(signer::get()), 102);

        // Check that the number of tickets is within the limit
        //let total_tickets = vector::length(&ticket_ids);
        //assert!(total_tickets + vector::length(&collection.tickets) <= collection.max_tickets, 103);

        // Create and mint new tickets
        let minted_tickets = vector::empty<Ticket>();
        let i=0;
        while (i < total_tickets) {
            let new_ticket = Ticket {
                price: *vector::borrow(&ticket_prices, i),
                open_for_sale: false,
            };
             vector::push_back(&mut minted_tickets, new_ticket);
             i=i+1;
        };
        vector::extend(&mut UMintedCollectn.tickets, minted_tickets);
        move_to<UMintedCollection>(&user,UMintedCollectn);

    }


*/



















    