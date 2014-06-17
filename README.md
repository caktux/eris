## Introduction

`Eris` is a platform on which decentralized applications may be built. At its core, what Eris seeks to do is to revisit the current state of how consumer applications are developed. Eris was designed as an attempt to provide a framework for development of applications which leverage web technologies, but *without servers*. This is the fundamental, driving design imperative of what Eris is seeking to achieve. We are building a framework which allows developers to build serverless integrated applications using technologies they are already familiar with.

Using Eris is just as easy as using a web application!

![Eris Screenshot](https://raw.githubusercontent.com/project-douglas/eris/master/docs/Sample-Screenshot.png)

### Huh?

Yes. We mean it.

### How?

We have taken a look at how modern web applications are designed and built. Traditionally these have utilized a MVC architecture where a database and language-specific wrapper for that database are used to provide the model component, a different set of language specific modules are used as the controller component, and then finally html, css, and javascript provide the view components. Indeed, most readers on this site will not need a lecture on MVC tech. However, what we asked is how would one design an application framework if one were purposefully trying to do away with central points of failure (which could be DDoS'ed or otherwise attacked, and require significant resources for application developers to maintain). Eris is what we came up with.

Eris operates using two primary components to provide the functionality traditionally found in the model and controller components of modern application, one of which these components operates on a blockchain; the other of which operates in clients which users run on their computers (or, preferably in virtual machines or docker images). The blockchain component is comprised of a series of databases (which provide a portion of the traditional model functionality) and actors (in Eris language these are called ByLaws and they provide a portion of the traditional controller functionality). The offchain component is comprised of a cache of peer-to-peer distributed file blobs (which provide a portion of the traditional model functionality) and actors (which are preformulated API calls that the view component can easily call). The view component is no different than any other view component of a modern web application.

### Why?

There are numerous benefits in attempting to provide a framework for application developers to build distributed applications. First, it is cheaper for application developers because the users will provide the content distribution network. In addition because Eris is built to run on localhost or in a docker image or vm on a user's computer (or on a self-owned cloud droplet) there are limited server costs. Servers, which provide a central point of failure provide difficulties not only for application developers which must harden against DDos attacks and innumerable other attack vectors, but also because users are increasingly skeptical of centralized data silos which retain innumerable pieces of information regarding the state of their affairs.

## Right, So How Does This Work

Fundamentally what is happening is that there is a set of smart contracts which are designed to run (currently at least) on an Ethereum blockchain. These contracts are split into two types. The first type of contracts are database contracts which predominantly store information much how a relational database does. The second type of contracts are ByLaw contracts which provide the blockchain controller functionality. The database contracts within the Eris platform are hardened against attacks by responding only to ByLaws and then only when ByLaws make structured API calls to the databases in particular ways. And then... only if the ByLaws or other requester has permission to take a certain action.

Off chain is a client (currently built in Ruby but easily portable to other languages) which provides the CDN component of the network. This component is called c3D for contract controlled content dissemination. It does what it says, it distributes and disseminates content based on the terms of the database contracts. Predominantly what it does is it wraps content blobs into files, throws them into a torrent client, and then submits the minimum required information to the Ethereum system of contracts. When other clients read the Ethereum blockchain and see additions to contracts which they are subscribed to, those clients will then decode the additional information. If that client does not have the file blobs of a contract which it subscribes to, then it will add those to the torrent client for retrieval.

Finally this package is wrapped up in a small API and view component. Together this allows us to build a Reddit without servers. Which is, as of this v 0.1 release what Eris fundamentally is.

## Cool. How Do I Play With It?

In the very near future, we hope to have this process greatly simplified, but for now it will require some work to get this system up and running.

As a precursor, you will need Ruby. On linux platforms, you can simply install ruby 2.0 from your friendly package manager. On OSX it comes preinstalled so there's nothing to install.

First you will need an ethereum client. Eris has been tested on the cpp client, but there is no reason to think that it will not work on the go client. These clients can be found:

* [Ethereum Go Client](https://github.com/ethereum/go-ethereum)
* [Ethereum CPP Client](https://github.com/ethereum/cpp-ethereum)

Second, you will need a torrent client. Eris has been tested using transmission-daemon and is known to work well. If you were to use another torrent client, you would need to modify the c3D component of Eris before using. Transmission daemon can be installed (depending on your platform) using:

* `sudo apt-get install transmission-daemon`
* `brew install transmission`

Third, you will need to clone this repo and run the install sequence:

* `git clone https://github.com/project-douglas/eris.git`
* `bundle install`

After that you are ready to go. Start the server with `foreman start` and you are ready to interact with your own DAO.

### But Wait, I Don't Have a DAO.

Funny you should say that, because we have that part also under control. Before starting the server with the above command, you will want to Deploy your very own DAO. Eris depends on the `EPM` gem (Ethereum Package Manager). EPM is built to provide a very simple interface for deploying series of contracts. So just type `bundle exec epm deploy ./contract/ERIS.package-definition` and your DOUG will deploy. If you run a headed client (which is advised -- just use a different port in your config file) then you can watch your very own DAO deploy before your eyes. **Note Aleth** does not work with JSON RPC which EPM relies upon to deploy so if you wish to use the CPP client then you will need to run both a headed and headless client. Just make sure to change in your `~/.epm/epm-rpc.json` and `~/.epm/c3d-config.json` config files the directory and peer ports which the headless server runs on.

Once you have a DAO, then run `foreman start`. After that in any web browser go to localhost:5000 and enjoy playing with your DAO!!!!

## Contributing

Fork.
Hack.
Pull Request.

## License

See `LICENSE.md`.

In other words, don't be a jerk.
