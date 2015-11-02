# WordPress Core Contribution Kit

WordPress core development environment with PHP built-in web server + WP-CLI.

It is very easy to launch WordPress development environment from svn repository.

## Requires

* php 5.4 or later
* MySQL
* WP-CLI

## How to use

```
$ mkdir ~/Desktop/wordpress && cd $_
$ curl https://raw.githubusercontent.com/miya0001/wp-instant-setup/master/run.sh | bash
```

Or

```
$ mkdir ~/Desktop/wordpress && cd $_
$ curl https://raw.githubusercontent.com/miya0001/wp-instant-setup/master/run.sh | bash -s <db-user> <db-pass> <db-name>
```

## Defaults

### WordPress

* User: `admin`
* Password: `admin`

### MySQL

* db-user: `root`
* db-pass: (empty)
* db-name: `wptrunk`

## Advanced Tips

Add alias into your `~/.bash_profile` like following.

```
alias wpcore="curl https://raw.githubusercontent.com/miya0001/wp-core-contribution-kit/master/run.sh | bash -s <db-user> <db-pass>"
```

Then just run:

```
$ wpcore <db-name>
```
