# meta

This shard is based on a duscussion I had with @asterite (the retired creator of
the Crystal programming language) in [this](https://forum.crystal-lang.org/t/print-out-the-instance-methods-defined-class-or-the-path-where-the-current-class-is/4771/2) forum thread.

Honestly, all the credit for this goes to him.

__NOTICE__: Not all helper methods will work in every situation, because I don't
fully understand the code myself, I just copied it and made a few tweaks, so, 
it might not work perfectly.

## Usage

### method 1

1. Add the dependency to your `shard.yml`:

```yaml
   dependencies:
     meta:
       github: crystal-china/meta
```

2. require it directly.

```crystal
require "meta"
```

There are many methods defined on Class/Object, check [spec](spec/meta_spec.cr) for usage.

### method 2 (preferred)

There is another more convenient way to use [meta.cr](src/meta.cr), you even don't need add
meta into `shard.yml` as dependency!

1. Copy file `meta.cr` to a local folder, e.g. `/home/foo/crystal/meta/meta.cr`

2. Add following code to the file where you want those meta helper methods.

```crystal
{{ read_file("/home/foo/crystal/meta/meta.cr").id }}
```

This use [read_file](https://crystal-lang.org/api/latest/Crystal/Macros.html#read_file(filename):StringLiteral-instance-method) macro to paste the content of meta.cr into the file where 
you want to use it.
   
### method 3

You can add the folder where `meta.cr` is located to CRYSTAL_PATH and require it.

## Contributing

1. Fork it (<https://github.com/crystal-china/meta/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- Ary Borenszweig
- Billy.Zheng <vil963@gmail.com>
