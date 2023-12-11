# Smart Contracts

Move smart contract comprises four distinct files, each dedicated to a specific functionality. One file is designated for the artist marketplace (artist.move), another for social media (pool.move), a third for aptos transactions (apt_transactions.move), and the last file (funK.move) serves as the orchestrator, calling functions from each module.

## Compile and Publish Instructions

```shell
aptos move compile --named-addresses pool=<address>
aptos move publish --named-addresses pool=<address>
```
***

## Social Media (Pool.move)

The social media module unfolds as a comprehensive framework aimed at facilitating user interactions and content sharing. The module incorporates four pivotal data structures, each playing a distinct role in orchestrating the functionality:

#### Storage

It maintains two critical vectors: one for users and another for posts. These vectors collectively store individual user profiles and the metadata of their contributed posts. The Storage struct acts as a centralized repository, streamlining access to user and post information.

#### User

The User struct encapsulates key attributes characterizing a user's engagement within the social media platform such as upvotesTotal, downvotesTtal, postTotal, and governancepool. This struct serves as a holistic representation of a user's profile, capturing both quantitative and qualitative aspects of their participation.

#### Pool

It comprises three key components: addresses for user addresses, a vector of all posts, and universe for the corresponding storage of each user. This struct forms the backbone of the social media module, facilitating seamless interactions and data retrieval across the platform.

#### Post

The Post struct focuses on capturing the metadata associated with each post. This metadata encompasses essential details such as post ID, author, title, content, and user interactions like upvotes and downvotes.

#### init_pool()

The init_pool function stands as the initial step for users as they join the social media platform. Upon entering, users invoke this function, providing their unique address. The purpose of init_pool is to establish a connection between the user's address and their designated storage. Simultaneously, the user is added to the global pool, creating a dynamic and interconnected space for user-specific information.

#### upload_post()

On the other hand, the upload_Post function enables users to actively contribute content to the platform. When a user decides to share a post, they invoke this function, providing details such as the owner's address, post title, image, content, and username. The function orchestrates the addition of the post to the owner's storage, ensuring that the user's contribution is recorded. It awards the user with a governance token, a mechanism that recognizes and rewards active participation within the platform.

#### upvote_post() and downvote_post()

The upvote_Post function serves as the mechanism for users to express their approval of a particular post. Upon invocation, users provide the owner's address and the post ID.  The user is then added to the list of those who liked the post. On the flip side, the downvote_Post function complements the user interaction spectrum by providing a means to express disapproval of a post. The user is added to the list of those who disliked the post.

……………………………………………………………………………………………………………

## Artist Marketplace (Artist.move)

The Artist Marketplace module is a smart contract written in Move, facilitating the creation, management, and interaction with an artist marketplace. Users can buy tickets for events, transfer tickets, create artist collections, and engage with music.

#### Ticket

The `Ticket` struct represents an event ticket, containing essential details such as the event ID, ticket ID, owner's address, artist's address, start and end times of the event, and the streaming link. This struct encapsulates the core information associated with an event ticket.

#### ArtistTicketCollection

The `ArtistTicketCollection` struct encapsulates information about a collection of tickets for a specific artist's event. It includes details such as the event name, ticket price, maximum number of tickets, the list of tickets, availability status, start and end times, artist's address, banner image, artist name, stream key ID, and event ID. This struct serves as a comprehensive container for managing and organizing artist-specific event details.

#### Artist

The `Artist` struct represents an artist, holding details like the artist's name, a list of their collections, and their music key address. It acts as a central structure for managing and associating artist-related information within the marketplace.

#### UserTicketCollection

The `UserTicketCollection` struct represents a user's collection, including details such as the user's name, address, governance tokens, lists of owned tickets and songs, and a flag indicating if the user is also an artist. This struct serves as a user-centric container for organizing their interactions within the marketplace.

#### Music

The `Music` struct represents a piece of music, containing information like the music's unique ID, title, date of upload, thumbnail, album, genre list, duration, artist's address, artist's name, hash, price, and a flag indicating if the music has been voted for. This struct encapsulates the essential attributes of a music item within the marketplace.

#### VotingGenre

The `VotingGenre` struct is responsible for managing user votes on different music genres. It contains a list of genre votes and a mapping of genres to song buckets. This struct facilitates the process of determining user-preferred genres based on their votes.

#### Storage

The `Storage` struct is the main storage container, holding various mappings such as artists, users, event collections, artist-to-music mappings, a list of all music items, the number of registered artists, and the voting genre structure. It serves as the central repository for persisting and organizing data within the marketplace.

#### init_storage()

The `init_storage` function initializes the storage for the artist marketplace, creating the necessary data structures.

#### generateTID()

The `generateTID` function generates a unique identifier for a ticket using the artist's name and event name. This identifier is crucial for uniquely identifying and referencing tickets within the marketplace.

#### createArtist()

The `createArtist` function allows the creation of a new artist, updating user details accordingly. It ensures that the artist is registered as a user and updates the user's status to indicate that they are also an artist.

#### createNewArtistCollection()

The `createNewArtistCollection` function enables the creation of a new artist collection for a specific event. It manages the creation of tickets, the artist collection, and updates relevant data structures accordingly.

#### createCollection_user()

The `createCollection_user` function creates a user collection, initializing a user's storage structure with details such as their name, address, and other collection-related information.

#### TransferTicket()

The `TransferTicket` function facilitates the transfer of a ticket from one user to another, updating ownership details and handling the transfer of funds using the `apt_transfer` module.

#### burn()

The `burn` function burns a ticket, transferring governance tokens to the user. It involves removing the ticket from the user's collection, checking event status, and transferring governance tokens accordingly.

#### add_music()

The `add_music` function allows artists to add music to their collection. It updates both the artist's and general music collections with the new music item.

#### transfer_music()

The `transfer_music` function facilitates the transfer of a music item from an artist to a user. It involves updating the user's music collection, the artist's collection, and transferring funds using the `apt_transfer` module.

#### vote_genre()

The `vote_genre` function enables users to vote for a genre using their governance tokens. It updates the voting genre structure with the user's vote and adjusts their governance token balance accordingly.
