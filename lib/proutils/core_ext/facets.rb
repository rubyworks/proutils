# I know some people will be deterred by the dependency on Facets b/c they
# see it as a "heavy" dependency. But really that is far from true, consider
# the fact that the following libs are all that it uses. We're talking maybe
# two dozen small, but very helpful, methods.

#require 'facets/boolean'

require 'facets/filetest'
require 'facets/fileutils'
require 'facets/pathname'

require 'facets/array/not_empty'

# DEPRECATE: when new #glob is working.
require 'facets/dir/multiglob'

require 'facets/kernel/yes'               # pulls in #ask and #no? too.
require 'facets/kernel/silence'           # FIXME ???
require 'facets/kernel/disable_warnings'

require 'facets/module/basename'
require 'facets/module/alias_accessor'

require 'facets/string/unfold'


class String
  # DEPRECATE
  alias unfold_paragraphs unfold
end

