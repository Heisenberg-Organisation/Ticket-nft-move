module pool::funK {
    use std::signer;
    use std::string::String; 
    use pool::Pool;
    use pool::artist_marketplace;
    use std::vector;
    use pool::Music;


struct Stor has key,store{
    univ:vector<Pool::Storage>,
}


public entry fun init_pool(creator:&signer){
    Pool::init_pool(creator,signer::address_of(creator));
}


public entry fun upload_post (account:&signer,title:String,username:String,image:String,content:String){  
    Pool::upload_Post(signer::address_of(account),title,username,image,content) 
}


public entry fun upvote_post(account: &signer, user: address,postId:u64) {
    Pool::upvotePost(signer::address_of(account), user,postId)
}


public entry fun downvote_post(account: &signer,user: address, postId: u64)  {
    Pool::downvotePost(signer::address_of(account),user, postId)   
}


public entry fun create_artist(artist: &signer,artist_name:String)  {
    artist_marketplace::createArtist(artist ,artist_name)   
}


public entry fun artist_collection(artist: &signer, event_name: String, price: u64, num_tickets: u64, start_time: u64, end_time: u64,banner:String)  {
    artist_marketplace::createNewArtistCollection(artist, event_name, price, num_tickets, start_time, end_time,banner)  
}


public entry fun create_user(user: &signer)  {
    artist_marketplace::createCollection_user(user)   
}


public entry fun transfer_ticket_a2u(user: &signer, artist_addr: address, concert_name:String )  {
    artist_marketplace::TransferTicket(user, artist_addr, concert_name )   
}

public entry fun init_storage(creator:&signer){
    artist_marketplace::init_storage(creator)
}


public entry fun transfer_ticket_u2u(giver:address,taker:&signer,price:u64,ticket_id:u64){
    artist_marketplace::u2u(taker,giver,price,ticket_id)
}


public entry fun setforsale(artist:&signer,event:String){
    artist_marketplace::setforsale(artist,event);
}

public entry fun init_music_storage(owner:&signer){
    Music::init(owner)
}

public entry fun create_music_user(owner:&signer){
    Music::create_user(owner)
}

public entry fun add_music(owner:&signer , hash:String , price:u64){
    Music::add_music(owner,hash,price)
}

public entry fun music_tranfer_u2u(owner:&signer,to:address,id:u64){
    Music::Tranfer(owner,to,id)
}


        
}










































