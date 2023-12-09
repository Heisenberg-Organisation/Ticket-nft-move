module pool::Pool{   

    use std::vector;
    use std::signer;
    use std::string::String;
    use aptos_std::simple_map::{Self, SimpleMap};
    
    struct User has store,drop,copy {
        upvotesTotal: u32,
        downvotesTotal: u32,
        postTotal: u64,
        index:u64, 
        governancePool:u64,
    }


    struct Post has store,drop,copy,key {
        upvotes: u32,
        downvotes: u32, 
        id: u64,
        username:String,
        title:String,
        image:String,
        content:String,
        author:address,
        liked:SimpleMap<address,bool>,
        disliked:SimpleMap<address,bool>,
    }


    struct Storage has key,drop,store,copy {
        user:vector<User>,
        post:vector<Post>,
    }


    struct Pool has key,copy{
        user_addr:vector<address>,
        universe:SimpleMap<address, Storage>,
        all_posts:vector<Post>,
    }


    const Creator_account: address = @pool;


    public fun init():Storage{   
        let usr:User=User{
            upvotesTotal: 0,
            downvotesTotal: 0,
            postTotal: 0,
            index:0,
            governancePool:0,
        };
        
        let storage=Storage{
                user:vector::singleton<User>(usr),
                post: vector::empty<Post>(),
        };
        storage 
    }


    public fun init_pool(creator:&signer,owner:address) acquires Pool{
        if ((signer::address_of(creator)==Creator_account) && (!exists<Pool>(Creator_account))  ) {
            move_to<Pool>(creator,init_resources());
        };
        let pool = borrow_global_mut<Pool>(Creator_account);
        let universe = &mut pool.universe;
        let user = &mut pool.user_addr;
        vector::push_back(user,owner);
        simple_map::add(universe, owner, init());
    }


    public fun init_resources():Pool{
        Pool{
            user_addr:vector::empty<address>(),
            universe:simple_map::create<address, Storage>(),
            all_posts:vector::empty<Post>(),
        }
    }


    public fun upload_Post(
        owner:address,
        title:String,
        image:String,
        content:String,
        username:String
        ) acquires Pool {
            let contract_add:address = Creator_account;
            let pool:&mut Pool =borrow_global_mut<Pool>(contract_add);
            let storage:&mut Storage=simple_map::borrow_mut(&mut pool.universe, &owner);
            let newPost: Post = Post {
                upvotes: 0,
                downvotes: 0,
                id:vector::length(&storage.post)+1,
                username:username,
                title: title,
                image:image,
                content:content,
                author:owner,
                liked:simple_map::create<address,bool>(),
                disliked:simple_map::create<address,bool>(),
            };
        vector::push_back(&mut storage.post,newPost);
        vector::push_back(&mut pool.all_posts,newPost);
        let x: &mut User =vector::borrow_mut(&mut storage.user, 0);
        x.governancePool=x.governancePool+1;
        x.postTotal = x.postTotal + 1;
        let borrowed_storage=*storage;
        simple_map::upsert(&mut pool.universe,owner,borrowed_storage); 
    }

    public fun upvotePost(owner:address, liked_addr:address,postId:u64) acquires Pool {
        let contract_add:address = Creator_account;
        let pool:&mut Pool =borrow_global_mut<Pool>(contract_add);
        let storage:&mut Storage=simple_map::borrow_mut(&mut pool.universe, &liked_addr);
        let x: &mut User =vector::borrow_mut(&mut storage.user, 0);
        let postIndex:u64 = postId;
        let required_post:&mut Post=vector::borrow_mut(&mut storage.post,postId);
        let isliked:&mut SimpleMap<address,bool> = &mut required_post.liked;
        let isdisliked:&mut SimpleMap<address,bool> = &mut required_post.disliked;
        if(simple_map::contains_key(isliked,&owner)==false){
        simple_map::add(isliked,owner,false);
        simple_map::add(isdisliked,owner,false);};

        if(*simple_map::borrow(isliked,&owner)==false){
            simple_map::upsert(isliked,owner,true);
            if (*simple_map::borrow(isdisliked,&owner)==true){
                simple_map::upsert(isdisliked,owner,false);
                if (postIndex <= vector::length(&storage.post)) {
                    let post: &mut Post = vector::borrow_mut(&mut storage.post, postIndex);
                    if (post.downvotes > 0) {
                        post.downvotes = post.downvotes - 1;
                        x.downvotesTotal = x.downvotesTotal - 1;
                    }
                }
            };
            if (postIndex <= vector::length(&storage.post)){
                let post: &mut Post = vector::borrow_mut(&mut storage.post, postIndex);
                post.upvotes = post.upvotes + 1;
                x.upvotesTotal = x.upvotesTotal + 1;
            }
        }
        else {
            if (*simple_map::borrow(isliked,&owner)==true){
                simple_map::upsert(isliked,owner,false);
                if (postIndex <= vector::length(&storage.post)) {
                    let post: &mut Post = vector::borrow_mut(&mut storage.post, postIndex);
                    if (post.upvotes > 0){
                        post.upvotes = post.upvotes - 1;
                        x.upvotesTotal = x.upvotesTotal - 1;
                    }
                }
            }
        };
        let borrowed_storage=*storage;
        simple_map::upsert(&mut pool.universe,liked_addr,borrowed_storage);
    }


    public fun downvotePost(owner:address,liked_addr:address, postId: u64) acquires Pool {
        let contract_add:address = Creator_account;
        let pool:&mut Pool =borrow_global_mut<Pool>(contract_add);
        let storage:&mut Storage=simple_map::borrow_mut(&mut pool.universe, &liked_addr);
        let x: &mut User =vector::borrow_mut(&mut storage.user, 0);
        let postIndex:u64 = postId;
        let required_post:&mut Post=vector::borrow_mut(&mut storage.post,postId);
        let isliked:&mut SimpleMap<address,bool> = &mut required_post.liked;
        let isdisliked:&mut SimpleMap<address,bool> = &mut required_post.disliked;

        if(simple_map::contains_key(isdisliked,&owner)==false){
        simple_map::add(isliked,owner,false);
        simple_map::add(isdisliked,owner,false);};

        if(*simple_map::borrow(isdisliked,&owner)==false ){
            simple_map::upsert(isdisliked,owner,true);
            if (*simple_map::borrow(isliked,&owner)==true){
                simple_map::upsert(isliked,owner,false);
                if (postIndex <= vector::length(&storage.post)) {
                    let post: &mut Post = vector::borrow_mut(&mut storage.post, postIndex);
                    if (post.upvotes > 0) {
                        post.upvotes=post.upvotes - 1 ;
                        x.upvotesTotal = x.upvotesTotal - 1;
                    }
                }
            };
            if (postIndex <= vector::length(&storage.post)) {
                let post: &mut Post = vector::borrow_mut(&mut storage.post, postIndex);
                post.downvotes = post.downvotes + 1;
                x.downvotesTotal = x.downvotesTotal + 1;
            }
        }
        else {
            if (*simple_map::borrow(isdisliked,&owner)==true){
                simple_map::upsert(isdisliked,owner,false);
                if (postIndex <= vector::length(&storage.post)) {
                    let post: &mut Post = vector::borrow_mut(&mut storage.post, postIndex);
                    if (post.downvotes > 0) {
                        post.downvotes = post.downvotes - 1;
                        x.downvotesTotal = x.downvotesTotal - 1;
                    }
                }
            }
        };
        let borrowed_storage=*storage;
        simple_map::upsert(&mut pool.universe,liked_addr,borrowed_storage);
    }
}