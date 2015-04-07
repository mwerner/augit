# Augit

Audit your git branches

## Installation

```shell
$ gem install augit
```

## Usage

Augit will inspect your repository and evaluate the age and diffs of all remote and local branches.

    cd /path/to/my/git/repo
    augit audit

![augit](http://i.imgur.com/73TrMeN.png)

It will display all the remote branches that have been merged into master and give you the option of removing all of them in one go.

Augit will then iterate through all unmerged branches one by one and give you the age, author and files changed. It will also print a link to a compare page on Github. This is useful when using iTerm to cmd+click the link to open a diff.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/augit/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
