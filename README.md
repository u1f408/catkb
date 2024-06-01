# CatKB

**Parts:**
- [API backend](https://github.com/u1f408/catkb) (you are here!)
- [Web frontend](https://github.com/u1f408/catkb-web)

## Development

```bash
cargo build --release
bundle install
bundle exec rackup
```

The core of CatKB, including the REST API, is written in Ruby.
However, there are some portions written in Rust, which are
compiled as native binaries and invoked from the Ruby application
when needed.
