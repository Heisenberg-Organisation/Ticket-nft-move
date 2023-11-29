
module ticket_addr::Artist_marketplace {

     use std::signer;
     use std::vector;


    struct ATicketCollection has key, store,drop {
        Price: u64,
        tickets: vector<u64>,
        open_to_sale:bool,
    }

    struct UCollection has key, store {
        tickets: vector<u64>,
        nft_collection:vector<u64>,
    }

    //

    public entry fun createCollection_artist(artist: &signer, price: u64,ticket_list:vector<u64>) {
        move_to<ATicketCollection>(artist,ATicketCollection{Price:price,tickets: ticket_list,open_to_sale:true})
    }
    public entry fun createCollection_user(user: &signer) {
        move_to<UCollection>(user,UCollection{tickets: vector::empty<u64>(),nft_collection:vector::empty<u64>()});
    }

    public entry fun user_ticket_and_nft(user: &signer,artist:address,ticket_id:u64) acquires ATicketCollection,UCollection {
        let a_t=borrow_global_mut<ATicketCollection>(artist);
        let u_t=borrow_global_mut<UCollection>(signer::address_of(user));
        if (a_t.open_to_sale==true){

            let user_Ticket : &u64 = vector::borrow(&mut a_t.tickets, ticket_id-1);
            vector::push_back(&mut u_t.tickets,*user_Ticket);
            vector::remove(&mut a_t.tickets, ticket_id-1);

        };
    
    }

    //public entry fun U_A(artist:&signer,user:address) acquires UNFTCollection{
     //   let artist_collection = move_from<UNFTCollection>(user);
     //   move_to<UNFTCollection>(artist, artist_collection);
    //}
   // public entry fun setOpenForSale(user: &signer, collection: &mut ATicketCollection) {
    //    assert!(signer::address_of(user) == signer::address_of(collection.artist), 108);
     //   collection.open_to_sale = true;
    //}

    #[test_only]
    use aptos_framework::account::create_account_for_test;




    #[test(creator = @0x123,user=@0x223)]
    public entry fun test_U_ticket_nft(creator: &signer,user:&signer) acquires ATicketCollection,UCollection{
    create_account_for_test(signer::address_of(creator));
    createCollection_artist(creator,100,vector<u64>[123,111,234,654,244,777]);
    createCollection_user(creator);
    user_ticket_and_nft(creator,@0xde00596286d7b25b5789061ed2e38818cf7ad133fcbda62b877abd5ce03dfa66,1);
    let utickets = borrow_global_mut<UCollection>(signer::address_of(user));
    let us :&u64 =vector::borrow_mut(&mut utickets.tickets,1);
    assert!(*us == 123, 1);

    
   
}}
























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
        let artist_collection = borrow_global<Artist_marketplace::ATicketCollection>(artist);


        // Create the user's NFT collection
        let user_nft_collection = UNFTCollection { nfts: vector::empty<u64>() };

        // Transfer ownership of the artist's collection to the user
        move_to<UNFTCollection>(user, user_nft_collection);

        // Return the artist's collection to maintain a copy
        move_to<Artist_marketplace::ATicketCollection>(artist, artist_collection);
    }

    struct UMintedCollection has key, store {
        tickets: vector<Ticket>,
    }

    struct U_A_minted has key, store {
        tickets: vector<Ticket>,
    }

    public fun createCollection_user(user: address,collection: &mut ATicketCollection) acquires ATicketCollection {
        move_to<UTicketCollection>(&user,collection.tickets);
        vector::clear(Ucollectn.tickets);
    }
public fun mintTickets(user:address,Ucollectn:UTicketCollection,UMintedCollectn: &mut UMintedCollection,ticket_ids: vector<u64>, ticket_prices: vector<u64>) acquires UTicketCollection {
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



















    