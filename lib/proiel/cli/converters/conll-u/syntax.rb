module PROIEL
  module Converter
    class CoNLLU
      RELATION_MAPPING = {
        "adnom" => "dep",
        "adv" =>  [["advcl", lambda(&:clausal?) ],
                   ["advmod", lambda { |x| x.adverb? or x.preposition? } ],
                   ["advmod", lambda(&:adjectival?) ], # adjective for adverb
                   ["nmod", lambda(&:nominal?) ],
                   ["advmod", lambda { |x| true } ],
                  ],
        "ag" => "nmod", # add :agent" once defined
        "apos" => [["name", lambda { |x| x.proper_noun? and x.head and x.head.proper_noun? } ],
                   ["appos", lambda { |x| (x.nominal? or x.adjectival?) and x.head and x.head.nominal? } ],
                   ["acl", lambda { |x| x.clausal? and x.head and x.head.nominal? } ],  # add :relcl ?
                   # what to do about sentential appositions?
                   ["advcl", lambda(&:clausal?) ],
                   ["appos", lambda { |x| true } ],
                  ],
        "arg" => "dep",
        "atr" => [["nummod", lambda(&:cardinal?) ],
                  ["nmod", lambda(&:nominal?) ],
                  ["acl", lambda { |x| x.clausal? } ],  # add :relcl?
                  ["advmod", lambda { |x| x.head and x.head.clausal? } ],
                  ["det", lambda(&:determiner?) ],
                  ["amod", lambda { |x| true } ], #default
                 ],
        "aux" => [["det", lambda(&:determiner?) ],
                  ["auxpass", lambda { |x| x.clausal? and x.head.passive?  } ],  
                  ["aux", lambda(&:clausal?) ],
                  ["neg", lambda(&:negation?) ],
                  ["discourse", lambda { |x| x.particle? or x.interjection? } ],
                  ["advmod", lambda { |x| x.adjectival? or x.adverb? } ], # or subjunction (? why did I write this?)
                  ["cc", lambda(&:conjunction?) ],
                  ["foreign", lambda(&:foreign?) ],
                  # We need some more distinctions to get Gothic and Armenian. Introduce language in the treebank? (Read from xml)
                  ["mark", lambda { |x| ['Pk', 'R-'].include? x.part_of_speech  } ], #reflexive as valency reducer, 'R-' as infinitive marker in Gothic
                  ['amod', lambda { |x| x.preposition? } ], # Armenian DOM
                  ['mwe', lambda { |x| ['Px', 'Pr'].include? x.part_of_speech } ], # NB there are a lot of bogus annotations with 'Px'
                  
                  # MISANNOTATION  IF A NOUN or a 'Pi' or a 'Pp' or a 'Ps'
                 ],
        "comp" => [['csubjpass', lambda { |x| x.head and x.head.passive? } ],
                   ['csubj', lambda { |x| x.head and x.head.copula? } ],
                   ['ccomp', lambda { |x| true } ],
                  ],
        "expl" => "expl",
        "narg" => [['acl', lambda(&:clausal?) ],
                   ['nmod', lambda(&:nominal?) ],
                   ['nmod', lambda(&:adjectival?) ], # nominaliezed in this function
                   ['nmod', lambda { |x| true } ],
                  ],
        "nonsub" => "dep",
        "obj" => "dobj",
        "obl" => [["advmod", lambda { |x| x.adverb? or x.preposition? } ], # though normally a preposition will be subordinate to its noun
                  ["iobj", lambda(&:nominal?) ],# if nominal (NB check for presence of article!)
                  ["iobj", lambda(&:adjectival?) ], # OBL adjectives are nominalized 
                  ["advcl", lambda(&:clausal?) ], # this seems to happen with ad libros legendos etc. but check closer!
                  ["iobj", lambda { |x| true } ],
                 ],
        "parpred" => "parataxis",
        "part" => "nmod",
        "per" => "dep",
        "pid" => ["ERROR", lambda { |x| raise "Remaining pid edge!" } ],
        "pred" => [["root", lambda(&:root?) ],
                   ["ERROR", lambda { |x| raise "#{x.to_n} (head_id #{x.head_id}) is not a root!" }],
                  ],
        "rel" => "acl", # add :relcl?
        "sub" => [["nsubjpass", lambda { |x| x.head and x.head.passive? } ],
                  ["nsubj", lambda { |x| true }],
                 ],
        "voc" => "vocative",
        "xadv" => [["advcl", lambda(&:clausal?)], #add :contr ?
                   ["advmod", lambda { |x| true } ], # add :contr ?
                  ],
        "xobj" => "xcomp", # copula cases have already been taken care of
        "xsub" => "xsub",
      }
    end
  end
end
