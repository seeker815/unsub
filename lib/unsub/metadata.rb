module Unsub
  # Officially, it's "unsub"
  NAME     = 'unsub'

  # A quick summary for use in the command-line interface
  SUMMARY  = %q.Autoscaling "polyfill" for Sensu, Icinga & Chef.

  # Take credit for your work
  AUTHOR   = 'Sean Clemmer'

  # Take responsibility for your work
  EMAIL    = 'sczizzo@gmail.com'

  # Like the MIT license, but even simpler
  LICENSE  = 'ISC'

  # Where you should look first
  HOMEPAGE = 'https://github.com/sczizzo/unsub'

  # Project root
  ROOT = File.join File.dirname(__FILE__), '..', '..'

  # Pull the project version out of the VERSION file
  VERSION = File.read(File.join(ROOT, 'VERSION')).strip

  # Bundled extensions
  TRAVELING_RUBY_VERSION = '20150517-2.2.2'
  THIN_VERSION = '1.6.3'
  FFI_VERSION = '1.9.6'
  EM_VERSION = '1.0.4'

  # Big money
  ART = <<-'EOART'
                                                         ,---,
               ,--,      ,---,                     ,--,,---.'|
             ,'_ /|  ,-+-. /  | .--.--.          ,'_ /||   | :
        .--. |  | : ,--.'|'   |/  /    '    .--. |  | ::   : :
      ,'_ /| :  . ||   |  ,"' |  :  /`./  ,'_ /| :  . |:     |,-.
      |  ' | |  . .|   | /  | |  :  ;_    |  ' | |  . .|   : '  |
      |  | ' |  | ||   | |  | |\  \    `. |  | ' |  | ||   |  / :
      :  | : ;  ; ||   | |  |/  `----.   \:  | : ;  ; |'   : |: |
      '  :  `--'   \   | |--'  /  /`--'  /'  :  `--'   \   | '/ :
      :  ,      .-./   |/     '--'.     / :  ,      .-./   :    |
       `--`----'   '---'        `--'---'   `--`----'   /    \  /
                                                       `-'----'
  EOART
end