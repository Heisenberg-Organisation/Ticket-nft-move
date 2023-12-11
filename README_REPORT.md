# Aptos Arkadia

## _An interoperable network of dApps build on Aptos, powered by snaps_

// deployed link
[![N|Solid](https://cldup.com/dTxpPi9lDf.thumb.png)](https://nodesource.com/products/nsolid)
In the dynamic transition from Web2 to Web3, Arkadia presents an interconnected network of apps, establishing an interoperable ecosystem that spans social, content, payments, and gaming domains for music artists and users, powered by the Aptos Snap. Built on the robust foundation of Aptos, our mission is to target the next 100 million users embracing Web3, breaking barriers, and providing cost-effective transactions at scale.

We have used **Aptos snaps** as the infrastructure provider and we have developed an ecosystem around **On-Chain radio** as a use case to our snaps

## Contents

1. Installation instructions
2. Getting Started (Login Steps)
3. Setting precedence
4. The Aptos snap
5. Features overview
6. Technical architecture

## Installation Instructions

These are the instructions for running the Arkadia locally:


## Getting Started (Login Steps)

## Setting Precedence

Most of the web2 traffic is composed of social media, content creation, gaming, and payments. These services have been built over the last 2 decades, using key “enablers” for developers. We can see the trends in no-code websites and AI integrations. Our team believes that reducing the barrier to web3 dapp development will provide a boost to the ecosystem. As we build for the next 100 million users on web3, it is key to provide these enablers to empower developers at every step. Aptos serves as a perfect base layer for bringing these web2 services to the decentralized web3 arena

## The Aptos Snap

We have created a fully functioning implementation of aptos snaps, that provides full aptos support in not just transactions but also by interacting with smart contracts. We have added support for the aptos sdk to run in the browser environment. We have used Aptos SDK, which provides modular code which is easy to implement and build upon. We follow responsible key management practices, we never store the user’s public or private key, these keys are always derived when needed.

![img](https://0x0.st/H3J1.jpg)

When the Dapp makes an RPC request to the snap, it derives the key pair from metamask and stores it using manage state in encrypted form. The snap then invokes a method to the Aptos SDK which triggers a method in a smart contract in the Aptos network

## Features overview

//artist user flowchart here


### Aptos Studio

A virtual studio for Indie artists where they can create and manage their music and schedule live concerts.
Artist can upload music which can be stored as a music NFT via IPFS protocol The artist can also create and schedule a live concert and our smart contract will then mint and sell Air tickets to the users. Clicking the create event button, the artist will get the stream key and server URL which can be used to stream using streaming software such as OBS.
Artist get real time revenue as user purchase their tickets.

//screen shot of aptos studio here

### Aptos Connect

Here post interaction acts as a community building exercise for artists and users alike. Every interaction such as likes and post creation are recorded on chain as transactions. Aptos connect lets users buy tickets for upcoming events.

### Aptos Live

You can enter the concerts using your purchased tickets. The concert arena has been built as a multiplayer environment enabling users to interact among themselves just like a real concert. Sponsored and social content in addition to the live stream will be showcased in the concert arena.

### Aptos Beats

Users can listen to the radio broadcast and purchase their favorite songs, tag them and save them in their private playlist.

### Community Governance

Aptos Arkadia is proud to present itself as a community-driven ecosystem wherein users get ARK governance tokens for every interaction, specifically users are rewarded for purchasing music on Aptos Beats, attending live events, and posting content on Aptos Connect. These tokens can then be used to vote for upcoming features and proposing changes in the protocol. For the current prototype of Aptos Beats, users can vote on their favourite genres. This will determine the time each genre gets on the radio. However this may lead to artists publishing their songs under popular genres even if they are not of those genres. To avoid these practices, artists are not allowed to tag their songs but it is the users who buy the songs, who get the option to vote for the genre based on which their genre is decided.

### Playlist curation

Users will have an option to listen to the songs being randomly played on the Radio. However they have no control over the songs being played on the Radio. If they want to listen to the songs they like, they have an option to buy the songs for a price, upon which a method in smart contract will be triggered which will add the song to your playlist. Users have complete control over the playback of the songs in their playlist (like fast forwarding, rewinding, volume control, pause/play, etc)

### Smart Contracts

The Metamask Snaps we have implemented invokes a method call to Aptos SDK which then triggers a method call in a smart contract. All the contracts deployed can be found in // move directory

We have used 4 different modules. One file is designated for the artist marketplace (artist.move), another for social media (pool.move), a third for aptos transactions (apt_transactions.move), and the last file (funK.move) serves as the orchestrator, calling functions from each module.

Detailed explanation of each function and structs can be found in // link readme of smart contract

## Technical Architecture

<img width="100%" alt="image" src="[https://gist.github.com/assets/59790120/c1744af7-0ceb-475a-b55a-89ed48f8a92a](https://gist.github.com/assets/59790120/c1744af7-0ceb-475a-b55a-89ed48f8a92a)">

### IPFS

We are storing various different types of content - music files, artist thumbnail, banner, and, post content and images. All of these are stored in IPFS (InterPlanetary File System) which is like a giant, distributed file system for the internet, connecting users directly to the content they're looking for. Instead of relying on a centralized server, IPFS uses a decentralized network, making it more resilient and efficient. IPFS stores content using a unique method called content-addressing. Instead of identifying files by their location on a server, each piece of content gets a unique hash based on its content. This hash is like a fingerprint, making retrieval efficient because you can directly ask the network for the content associated with a specific hash, no matter where it's stored in the decentralized network. This information is stored in the eventTickets and Music structs on the blockchain for access of the relevant files as and when required.

### Dealing with Scalpers and Maintaining Security

We only allow users to buy tickets directly from the artists with complete revenue being given to the artist directly without any intermediaries. Users are not allowed to transfer tickets among themselves. This ensures that users can not sell tickets to other users for a higher price with the artist getting no share of this extra profit.

Whenever Artist schedules an event, tickets are minted and made available for sale on the Aptos Connect page. The playbackURL for the live event is stored in the ticket itself in an encrypted format with decryption taking place in our Aptos Live environment itself. This ensures that the events can only be viewed on the platform itself. This discourages piracy and would allow only users with tickets to view the event.

### Aptos Live Environment

This has been developed using Unity Game engine with multiplayer support. The users have their characters spawned in the arena and they can move around interacting with other users. We have used the jslib for communication between the Unity (Arena) and React (Arkadia website). The users can only join the event from the Arkadia site itself. When they click on 'Join Event', users are redirected to the 3D arena, the playbackURL in the ticket is decrypted, and they can now enjoy the live stream and interact with other users for a more holistic experience.


### Streaming

We have implemented a server-side app that efficiently manages live streaming with AWS IVS. It initializes AWS IVS client, sets up an Express app for JSON requests, generates RSA keys for encryption, and handles CORS. API endpoints create, stop, and start streaming events, interacting seamlessly with AWS IVS via @aws-sdk/client-ivs. The app also integrates input from OBS (Open Broadcaster Software), a popular streaming tool. CORS headers aid cross-origin requests, and RSA encryption secures sensitive data like the playback URL. The app, on port 3000, provides clear instructions for event manipulation through API endpoints.

### Permissionless Streaming Protocol (beta)

We propose the integration of HTTP Live Streaming (HLS) and the InterPlanetary File System (IPFS) to create a robust and decentralized live streaming solution. This proposal outlines a comprehensive workflow that seamlessly combines these technologies, providing efficient content delivery and improved accessibility. The integration involves key processes, including sourcing the feed, HLS chunk creation, IPFS content addition, M3U8 file updates, and continuous publishing to maintain a dynamic and updated live stream.





By doing so, we intend to enhance the accessibility of content by leveraging IPFS for distributed storage, thereby diminishing reliance on centralized servers. Additionally, our goal includes implementing adaptive streaming capabilities through HLS, enabling clients to dynamically adjust playback in response to varying network conditions.

// ipfs streaming workflow

The live streaming workflow initiates by sourcing a feed from an RTMP server, serving as the initial hub for receiving the video feed. Following this, the process employs FFmpeg for the transcoding of the RTMP stream into HLS chunks. Concurrently, inotifywait is utilized to monitor changes in the directory where HLS chunks are stored, subsequently triggering actions in the streaming pipeline. Upon the generation of HLS chunks, the corresponding hash is added to the IPFS network, ensuring unique content identification. Subsequently, the M3U8 file, functioning as an HLS manifest, is updated to reflect the newly generated hash, guaranteeing accurate content retrieval. The updated M3U8 file is then published, potentially through a web server, CDN, or other distribution mechanisms, making it accessible to clients. This entire workflow is continuously repeated throughout the live streaming session to ensure the maintenance of an updated stream on IPFS.



The proposed integration seamlessly combines RTMP, HLS, and IPFS for efficient and decentralized content delivery. It begins with the RTMP server receiving live video streams from OBS (a popular streaming software) and concurrently utilizes an HLS server to push content to the RTMP server, enabling adaptive streaming. The RTMP server then publishes the stream through both HLS and IPFS streaming mechanisms. For HLS, it communicates with the HLS server to generate playlists, while for IPFS, an IPFS server leverages FFmpeg to transcode the live stream, creating video segments and an M3U8 playlist. A mirror or IPFS pinning service enhances distribution and availability by storing HLS content on IPFS for extended periods, increasing redundancy.


## Features

- Import a HTML file and watch it magically convert to Markdown
- Drag and drop images (requires your Dropbox account be linked)
- Import and save files from GitHub, Dropbox, Google Drive and One Drive
- Drag and drop markdown and HTML files into Dillinger
- Export documents as Markdown, HTML and PDF

Markdown is a lightweight markup language based on the formatting conventions
that people naturally use in email.
As [John Gruber] writes on the [Markdown site][df1]

> The overriding design goal for Markdown's
> formatting syntax is to make it as readable
> as possible. The idea is that a
> Markdown-formatted document should be
> publishable as-is, as plain text, without
> looking like it's been marked up with tags
> or formatting instructions.

This text you see here is *actually- written in Markdown! To get a feel
for Markdown's syntax, type some text into the left window and
watch the results in the right.

## Tech

Dillinger uses a number of open source projects to work properly:

- [AngularJS] - HTML enhanced for web apps!
- [Ace Editor] - awesome web-based text editor
- [markdown-it] - Markdown parser done right. Fast and easy to extend.
- [Twitter Bootstrap] - great UI boilerplate for modern web apps
- [node.js] - evented I/O for the backend
- [Express] - fast node.js network app framework [@tjholowaychuk]
- [Gulp] - the streaming build system
- [Breakdance]([https://breakdance.github.io/breakdance/](https://breakdance.github.io/breakdance/)) - HTML
  to Markdown converter
- [jQuery] - duh

And of course Dillinger itself is open source with a [public repository][dill]
 on GitHub.

## Installation

Dillinger requires [Node.js]([https://nodejs.org/](https://nodejs.org/)) v10+ to run.

Install the dependencies and devDependencies and start the server.

```sh
cd dillinger
npm i
node app
```

For production environments...

```sh
npm install --production
NODE_ENV=production node app
```

## Plugins

Dillinger is currently extended with the following plugins.
Instructions on how to use them in your own application are linked below.

| Plugin           | README                                    |
| ---------------- | ----------------------------------------- |
| Dropbox          | [plugins/dropbox/README.md][PlDb]         |
| GitHub           | [plugins/github/README.md][PlGh]          |
| Google Drive     | [plugins/googledrive/README.md][PlGd]     |
| OneDrive         | [plugins/onedrive/README.md][PlOd]        |
| Medium           | [plugins/medium/README.md][PlMe]          |
| Google Analytics | [plugins/googleanalytics/README.md][PlGa] |

## Development

Want to contribute? Great!

Dillinger uses Gulp + Webpack for fast developing.
Make a change in your file and instantaneously see your updates!

Open your favorite Terminal and run these commands.

First Tab:

```sh
node app
```

Second Tab:

```sh
gulp watch
```

(optional) Third:

```sh
karma test
```

#### Building for source

For production release:

```sh
gulp build --prod
```

Generating pre-built zip archives for distribution:

```sh
gulp build dist --prod
```

## Docker

Dillinger is very easy to install and deploy in a Docker container.

By default, the Docker will expose port 8080, so change this within the
Dockerfile if necessary. When ready, simply use the Dockerfile to
build the image.

```sh
cd dillinger
docker build -t <youruser>/dillinger:${package.json.version} .
```

This will create the dillinger image and pull in the necessary dependencies.
Be sure to swap out `${package.json.version}` with the actual
version of Dillinger.

Once done, run the Docker image and map the port to whatever you wish on
your host. In this example, we simply map port 8000 of the host to
port 8080 of the Docker (or whatever port was exposed in the Dockerfile):

```sh
docker run -d -p 8000:8080 --restart=always --cap-add=SYS_ADMIN --name=dillinger <youruser>/dillinger:${package.json.version}
```

> Note: `--capt-add=SYS-ADMIN` is required for PDF rendering.

Verify the deployment by navigating to your server address in
your preferred browser.

```sh
[127.0.0.1:8000](http://127.0.0.1:8000/)
```

## License

MIT

**Free Software, Hell Yeah!**

[//]: # (These are reference links used in the body of this note and get stripped out when the markdown processor does its job. There is no need to format nicely because it shouldn't be seen. Thanks SO - [http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax](http://stackoverflow.com/questions/4823468/store-comments-in-markdown-syntax))

   [dill]: [[https://github.com/joemccann/dillinger](https://github.com/joemccann/dillinger)](%5Bhttps://github.com/joemccann/dillinger%5D(https://github.com/joemccann/dillinger))
   [git-repo-url]: [[https://github.com/joemccann/dillinger.git](https://github.com/joemccann/dillinger.git)](%5Bhttps://github.com/joemccann/dillinger.git%5D(https://github.com/joemccann/dillinger.git))
   [john gruber]: [[http://daringfireball.net](http://daringfireball.net/)](%5Bhttp://daringfireball.net%5D(http://daringfireball.net/))
   [df1]: [[http://daringfireball.net/projects/markdown/](http://daringfireball.net/projects/markdown/)](%5Bhttp://daringfireball.net/projects/markdown/%5D(http://daringfireball.net/projects/markdown/))
   [markdown-it]: [[https://github.com/markdown-it/markdown-it](https://github.com/markdown-it/markdown-it)](%5Bhttps://github.com/markdown-it/markdown-it%5D(https://github.com/markdown-it/markdown-it))
   [Ace Editor]: [[http://ace.ajax.org](http://ace.ajax.org/)](%5Bhttp://ace.ajax.org%5D(http://ace.ajax.org/))
   [node.js]: [[http://nodejs.org](http://nodejs.org/)](%5Bhttp://nodejs.org%5D(http://nodejs.org/))
   [Twitter Bootstrap]: [[http://twitter.github.com/bootstrap/](http://twitter.github.com/bootstrap/)](%5Bhttp://twitter.github.com/bootstrap/%5D(http://twitter.github.com/bootstrap/))
   [jQuery]: [[http://jquery.com](http://jquery.com/)](%5Bhttp://jquery.com%5D(http://jquery.com/))
   [@tjholowaychuk]: [[http://twitter.com/tjholowaychuk](http://twitter.com/tjholowaychuk)](%5Bhttp://twitter.com/tjholowaychuk%5D(http://twitter.com/tjholowaychuk))
   [express]: [[http://expressjs.com](http://expressjs.com/)](%5Bhttp://expressjs.com%5D(http://expressjs.com/))
   [AngularJS]: [[http://angularjs.org](http://angularjs.org/)](%5Bhttp://angularjs.org%5D(http://angularjs.org/))
   [Gulp]: [[http://gulpjs.com](http://gulpjs.com/)](%5Bhttp://gulpjs.com%5D(http://gulpjs.com/))

   [PlDb]: [[https://github.com/joemccann/dillinger/tree/master/plugins/dropbox/README.md](https://github.com/joemccann/dillinger/tree/master/plugins/dropbox/README.md)](%5Bhttps://github.com/joemccann/dillinger/tree/master/plugins/dropbox/README.md%5D(https://github.com/joemccann/dillinger/tree/master/plugins/dropbox/README.md))
   [PlGh]: [[https://github.com/joemccann/dillinger/tree/master/plugins/github/README.md](https://github.com/joemccann/dillinger/tree/master/plugins/github/README.md)](%5Bhttps://github.com/joemccann/dillinger/tree/master/plugins/github/README.md%5D(https://github.com/joemccann/dillinger/tree/master/plugins/github/README.md))
   [PlGd]: [[https://github.com/joemccann/dillinger/tree/master/plugins/googledrive/README.md](https://github.com/joemccann/dillinger/tree/master/plugins/googledrive/README.md)](%5Bhttps://github.com/joemccann/dillinger/tree/master/plugins/googledrive/README.md%5D(https://github.com/joemccann/dillinger/tree/master/plugins/googledrive/README.md))
   [PlOd]: [[https://github.com/joemccann/dillinger/tree/master/plugins/onedrive/README.md](https://github.com/joemccann/dillinger/tree/master/plugins/onedrive/README.md)](%5Bhttps://github.com/joemccann/dillinger/tree/master/plugins/onedrive/README.md%5D(https://github.com/joemccann/dillinger/tree/master/plugins/onedrive/README.md))
   [PlMe]: [[https://github.com/joemccann/dillinger/tree/master/plugins/medium/README.md](https://github.com/joemccann/dillinger/tree/master/plugins/medium/README.md)](%5Bhttps://github.com/joemccann/dillinger/tree/master/plugins/medium/README.md%5D(https://github.com/joemccann/dillinger/tree/master/plugins/medium/README.md))
   [PlGa]: [[https://github.com/RahulHP/dillinger/blob/master/plugins/googleanalytics/README.md](https://github.com/RahulHP/dillinger/blob/master/plugins/googleanalytics/README.md)](%5Bhttps://github.com/RahulHP/dillinger/blob/master/plugins/googleanalytics/README.md%5D(https://github.com/RahulHP/dillinger/blob/master/plugins/googleanalytics/README.md))
