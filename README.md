# WaveletFM

Given I am not the best at keeping in touch by text with my distant friends, and I have recently moved. Maybe another way to keep in touch is to see how they are doing is through a daily music song. Further, as I had to wait for my thesis feedback, it was the perfect chance for a week long hackathon! Having approximately 0 hours previous experience in web development (HTML, CSS and JS) but quite some experience with erlang, Phoenix Liveview seemed liked the perfect start 😎 v0.1 is the end result.

## Official Instance and Self Hosting

My "official" instance of WaveletFM is hosted by [fly.io](https://fly.io/). Feel free to [join the community](https://waveletfm.fly.dev/)! Otherwise, this repository is open-sourced to allow self-hosting. All hosting related artifacts are not included. It will also be required to generate your own [Spotify WebAPI](https://developer.spotify.com/documentation/web-api) client credentials (and other credentials when they are implemented) and store them in your environment variables.

### Latency

Due to the expected low volume of traffic of the website. The hosted machines on fly.io are automatically started and shutdown, and there is currently only 1 machine. This may result in an initial latency as the machine starts. Should traffic increase, I will use the excellent scaling that fly.io provides!
