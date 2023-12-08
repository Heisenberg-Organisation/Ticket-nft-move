module pool::funK {
    use std::signer;
    use std::string::String; 
    use pool::Pool;
    use pool::artist_marketplace;

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


public entry fun artist_collection(artist: &signer, event_name: String, price: u64, num_tickets: u64, start_time: u64, end_time: u64,banner:String, link:String, streamId: String)  {
    artist_marketplace::createNewArtistCollection(artist, event_name, price, num_tickets, start_time, end_time,banner, link, streamId)  
}


public entry fun create_user(user: &signer, user_name: String)  {
    artist_marketplace::createCollection_user(user, user_name)   
}


public entry fun transfer_ticket_a2u(user: &signer, artist_addr: address, concert_name:String )  {
    artist_marketplace::TransferTicket(user, artist_addr, concert_name )   
}

public entry fun init_storage(creator:&signer){
    artist_marketplace::init_storage(creator)
}

public entry fun addMusic(owner:&signer , title: String, thumbnail: String, album: String, duration: u64, dateUploaded: u64, hash: String, price: u64){
    artist_marketplace::add_music(owner, title, thumbnail, album, duration, dateUploaded, hash, price)
}

public entry fun transfer_music(user: &signer, artist_addr: address, music_id: u64, genre_id: u64){
    artist_marketplace::transfer_music(user, artist_addr, music_id, genre_id)
}


}







































