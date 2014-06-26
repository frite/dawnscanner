# Codesake Dawn - roadmap

Codesake::Dawn is a static analysis security scanner for ruby written web applications.
It supports [Sinatra](http://www.sinatrarb.com),
[Padrino](http://www.padrinorb.com) and [Ruby on Rails](http://rubyonrails.org)
frameworks.

This is an ongoing roadmap for the Codesake::Dawn source code review tool.

_latest update: Thu Jun 26 07:46:55 CEST 2014_

## Version 1.2.0

* create a task to check for new CVE in NVD website
* SQLite3 integration for saving data. Each project will have its own SQLite
  database containing reviews, findings and all. A table with Codesake::Dawn version it
  created the database will be inserted as well
* add a language check. It will handle a ruby script as input and a
  ruby\_parser line as unsafe pattern. It will compile the ruby and look for
  the unsafe pattern
* Add preliminary Cross Site Scripting detection for Ruby on Rails.
* Issue #7: Improving HTML output and let the user the capability to provide a
  basic layout to customize report
* Add a ruby deprecation check, accordingly to
  https://bugs.ruby-lang.org/projects/ruby/wiki/ReleaseEngineering
* add source code metrics gathering (lines of code, lines of comments,
  cyclomatic complexity index, ...)

## Version 2.0.0

* Integrate a JS parser to detect DOM based XSS
* Add support for ERB for in detect\_views
* Add preliminary javascript support
* adding test for CVE-2011-4969  XSS in jquery < 1.6.2
* add support for pure Rack applications
* Cross Site Scripting detection: it must be done for all MVC frameworks
  (including Rack) and it must cover either reflected than stored attack
  patterns
* Add a --github option to Codesake::Dawn to clone a remote repository, perform
  a bundle install and do a code review.
* Add support for github hooks
* Add premilinary SQL injection detection for Ruby on Rails
* Add insecure direct object reference detection for all MVC frameworks (including Rack)
* SQL Injection detection: it must be done for all MVC frameworks (including Rack)

## Version 3.0.0

* Add automatic mitigation patch generation


# Spinoff projects

Codesake::Dawn is a security scanner for ruby code. Modern web applications
however are wrote in a plenty of great technologies deserving a good tool for
security scan.

Node.js and Go are very promising programming languages and a tool similiar to
Codesake::Dawn can be wrote also but in a spinoff project.

PHP has a good open source code scanners ecosystem, instead JAVA has not.
Players started open and eventually they turned in big commercial bloatware
GUIs that are useless from the security specialist perspective. A simple
bytecode analyzer, with some checks, can be a possible spinoff project.
