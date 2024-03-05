# WaveletFM

Given I am not the best at keeping in touch by text with my distant friends, and
I have recently moved, it was natural to try and build something to help with
that. Maybe another way to keep in touch is to see how they are
doing is through a daily music song. Further, as I had to wait for my thesis
feedback, it was the perfect chance for a week long hackathon! Having
approximately 0 hours previous experience in web development (HTML, CSS and JS)
but quite some experience with erlang, Phoenix Liveview seemed liked the perfect
start 😎 v0.1 is the end result.

## Official Instance and Self Hosting

My "official" instance of WaveletFM is hosted by [fly.io](https://fly.io/).
Feel free to [join the community](https://waveletfm.fly.dev/)! Otherwise, this
repository is open-sourced to allow self-hosting. All hosting related artifacts
are not included. It will also be required to generate your own
[Spotify WebAPI](https://developer.spotify.com/documentation/web-api) client
credentials (and other credentials when they are implemented) and store them in
your environment variables.

## Getting started
To get started it is required that you have Erlang/OTP and Elixir installed.
This project was developed with Erlang/OTP 26 and Elixir 1.16.1. I can recommend
the use of [asdf](https://asdf-vm.com/) for managing versions. Ensure that you
have liveview installed. Finally, you should then be able to start an instance
of the web-app on `localhost:4000` with the following commands:
```
mix deps.get
mix ecto.setup
mix phx.server
```

## Roadmap
There are a number of features and improvements on the roadmap.

### v0.1-release:

- [X] Enable Swoosh production API
- [X] Enable external uploading of profile pictures for scaling

### v-0.1-public:
- [ ] Add terms and privacy
- [ ] Enable search with Apple Music, YouTube Music, Soundcloud and Bandcamp API
- [ ] Enable search with a provided link to a track entity (from any implemented
    API)
- [ ] (Backend) Construct another web-app to serve and store uploaded profile
    pictures.
- [ ] Implement a popularity or ranking system for searching through FMs in the
    radio/explore page (currently just based on the most recent posts)

## Contributing
If you have any ideas for features and improvements please open an issue BEFORE
starting work to avoid wasting effort. Likewise for features on the roadmap,
please indicate that you have started work to avoid any double-effort.
