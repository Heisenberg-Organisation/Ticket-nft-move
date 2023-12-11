# Aptos Arkadia

<div id="top"></div>

<!-- PROJECT LOGO -->
<br />
<div align="center">

  <h3 align="center">Aptos Arkadia</h3>

  <p align="center">
    An interoperable network of dApps build on Aptos, powered by snaps
    
  </p>
</div>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <!-- <li>
      <a href="#contents">Contents</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
        <li><a href="#setting-debug-level">Setting DEBUG level</a></li>
      </ul>
    </li> -->
    <li><a href="#about-the-project">About The Project</a></li>
    <li><a href="#installation-instructions">Installation Instructions</a></li>
    <!-- <li><a href="#project-structure">Project Structure</a></li> -->
    <li><a href="#getting-started">Getting Started</a></li>
    <li><a href="#setting-context">Setting Context</a></li>
    <li><a href="#the-aptos-snap">The Aptos Snap</a></li>
    <li><a href="#features-overview">Features Overview</a></li>
    <li><a href="#technical-architecture">Technical Architecture</a></li>
    <!-- <li><a href="#usage">Usage</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li> -->
  </ol>
</details>

<!-- ABOUT THE PROJECT -->

## About The Project


In the dynamic transition from Web2 to Web3, Arkadia presents an interconnected network of apps, establishing an interoperable ecosystem that spans social, content, payments, and gaming domains for music artists and users, powered by the Aptos Snap. Built on the robust foundation of Aptos, our mission is to target the next 100 million users embracing Web3, breaking barriers, and providing cost-effective transactions at scale.

We have used **Aptos snaps** as the infrastructure provider and we have developed an ecosystem around **On-Chain radio** as a use case to our snaps

<p align="right">(<a href="#top">back to top</a>)</p>

## Installation Instructions

<!-- fill here -->

<p align="right">(<a href="#top">back to top</a>)</p>


## Getting Started 

Follow the steps in the given order
1. Click on "CONNECT WALLET" to connect wallet through Metamask.
2. Then a user needs to be registered to initiate post interaction, buy songs and concert tickets, and view live concerts.
3. Artist registerations to create concerts and sell their music.

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- GETTING STARTED -->

## Setting Context

Most of the web2 traffic is composed of social media, content creation, gaming, and payments. These services have been built over the last 2 decades, using key “enablers” for developers. We can see the trends in no-code websites and AI integrations. Our team believes that reducing the barrier to web3 dapp development will provide a boost to the ecosystem. As we build for the next 100 million users on web3, it is key to provide these enablers to empower developers at every step. Aptos serves as a perfect base layer for bringing these web2 services to the decentralized web3 arena

<p align="right">(<a href="#top">back to top</a>)</p>

## The Aptos Snap

We have created a fully functioning implementation of aptos snaps, that provides full aptos support in not just transactions but also by interacting with smart contracts. We have added support for the aptos sdk to run in the browser environment. We have used Aptos SDK, which provides modular code which is easy to implement and build upon. We follow responsible key management practices, we never store the user’s public or private key, these keys are always derived when needed.

![img](https://0x0.st/H3J1.jpg)

When the Dapp makes an RPC request to the snap, it derives the key pair from metamask and stores it using manage state in encrypted form. The snap then invokes a method to the Aptos SDK which triggers a method in a smart contract in the Aptos network
<p align="right">(<a href="#top">back to top</a>)</p>


## Features Overview

<img width="100%" alt="image" src="https://github.com/Heisenberg-Organisation/images/blob/main/User_Artist.png">


### Aptos Studio

A virtual studio for Indie artists where they can create and manage their music and schedule live concerts.
Artist can upload music which can be stored as a music NFT via IPFS protocol The artist can also create and schedule a live concert and our smart contract will then mint and sell Air tickets to the users. Clicking the create event button, the artist will get the stream key and server URL which can be used to stream using streaming software such as OBS.
Artist get real time revenue as user purchase their tickets.

<img width="100%" alt="image" src="https://github.com/Heisenberg-Organisation/images/blob/main/STUDIO.png">

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
<p align="right">(<a href="#top">back to top</a>)</p>


## Technical Architecture

<img width="100%" alt="image" src="https://github.com/Heisenberg-Organisation/images/blob/main/tech_archi.png">


### IPFS

We are storing various different types of content - music files, artist thumbnail, banner, and, post content and images. All of these are stored in IPFS (InterPlanetary File System) which is like a giant, distributed file system for the internet, connecting users directly to the content they're looking for. Instead of relying on a centralized server, IPFS uses a decentralized network, making it more resilient and efficient. IPFS stores content using a unique method called content-addressing. Instead of identifying files by their location on a server, each piece of content gets a unique hash based on its content. This hash is like a fingerprint, making retrieval efficient because you can directly ask the network for the content associated with a specific hash, no matter where it's stored in the decentralized network. This information is stored in the eventTickets and Music structs on the blockchain for access of the relevant files as and when required.

### Dealing with Scalpers and Maintaining Security

We only allow users to buy tickets directly from the artists with complete revenue being given to the artist directly without any intermediaries. Users are not allowed to transfer tickets among themselves. This ensures that users can not sell tickets to other users for a higher price with the artist getting no share of this extra profit.

Whenever Artist schedules an event, tickets are minted and made available for sale on the Aptos Connect page. The playbackURL for the live event is stored in the ticket itself in an encrypted format with decryption taking place in our Aptos Live environment itself. This ensures that the events can only be viewed on the platform itself. This discourages piracy and would allow only users with tickets to view the event.

### Aptos Live Environment

This has been developed using Unity Game engine with multiplayer support. The users have their characters spawned in the arena and they can move around interacting with other users. We have used the jslib for communication between the Unity (Arena) and React (Arkadia website). The users can only join the event from the Arkadia site itself. When they click on 'Join Event', users are redirected to the 3D arena, the playbackURL in the ticket is decrypted, and they can now enjoy the live stream and interact with other users for a more holistic experience.


### Streaming

We have implemented a server-side app that efficiently manages live streaming with AWS IVS. It initializes AWS IVS client, sets up an Express app for JSON requests, and generates RSA keys for encryption. API endpoints create, stop, and start streaming events, interacting seamlessly with AWS IVS via @aws-sdk/client-ivs. The app also integrates input from any streaming software (like OBS, etc), a popular streaming tool. RSA encryption secures sensitive data like the playback URL. The app, on port 3000, provides clear instructions for event manipulation through API endpoints.

### Permissionless Streaming Protocol (beta)

We propose the integration of HTTP Live Streaming (HLS) and the InterPlanetary File System (IPFS) to create a robust and decentralized live streaming solution. This proposal outlines a comprehensive workflow that seamlessly combines these technologies, providing efficient content delivery and improved accessibility. The integration involves key processes, including sourcing the feed, HLS chunk creation, IPFS content addition, M3U8 file updates, and continuous publishing to maintain a dynamic and updated live stream.





By doing so, we intend to enhance the accessibility of content by leveraging IPFS for distributed storage, thereby diminishing reliance on centralized servers. Additionally, our goal includes implementing adaptive streaming capabilities through HLS, enabling clients to dynamically adjust playback in response to varying network conditions.

<p align="center">
<img width="40%" alt="image" src="https://github.com/Heisenberg-Organisation/images/blob/main/IPFS.png">
</p>

The live streaming workflow initiates by sourcing a feed from an RTMP server, serving as the initial hub for receiving the video feed. Following this, the process employs FFmpeg for the transcoding of the RTMP stream into HLS chunks. Concurrently, inotifywait is utilized to monitor changes in the directory where HLS chunks are stored, subsequently triggering actions in the streaming pipeline. Upon the generation of HLS chunks, the corresponding hash is added to the IPFS network, ensuring unique content identification. Subsequently, the M3U8 file, functioning as an HLS manifest, is updated to reflect the newly generated hash, guaranteeing accurate content retrieval. The updated M3U8 file is then published, potentially through a web server, CDN, or other distribution mechanisms, making it accessible to clients. This entire workflow is continuously repeated throughout the live streaming session to ensure the maintenance of an updated stream on IPFS.



The proposed integration seamlessly combines RTMP, HLS, and IPFS for efficient and decentralized content delivery. It begins with the RTMP server receiving live video streams from OBS (a popular streaming software) and concurrently utilizes an HLS server to push content to the RTMP server, enabling adaptive streaming. The RTMP server then publishes the stream through both HLS and IPFS streaming mechanisms. For HLS, it communicates with the HLS server to generate playlists, while for IPFS, an IPFS server leverages FFmpeg to transcode the live stream, creating video segments and an M3U8 playlist. A mirror or IPFS pinning service enhances distribution and availability by storing HLS content on IPFS for extended periods, increasing redundancy.


<p align="right">(<a href="#top">back to top</a>)</p>

