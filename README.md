# meta

This shard come from the discussion with the author of Crystal programming langauge
@asterite (retired) in [this](https://forum.crystal-lang.org/t/print-out-the-instance-methods-defined-class-or-the-path-where-the-current-class-is/4771/2) forum thread.

__NOTICE__: not all helper method works on all cases，because I am not familiar with 
this code, I simply copied and made slight modifications, so it may not work.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     meta:
       github: crystal-china/meta
   ```

## Usage

```crystal
require "meta"
```

There are many methods defined, check [spec](spec/meta_spec.cr) for usage.

## Development

TODO: Write development instructions here

## Contributing

1. Fork it (<https://github.com/crystal-china/meta/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- Ary Borenszweig
- Billy.Zheng <vil963@gmail.com>
