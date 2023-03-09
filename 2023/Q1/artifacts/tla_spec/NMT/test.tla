---- MODULE test ----
EXTENDS 
    Apalache,
    Variants

\* @typeAlias: drink =
\*     Water({ sparkling: Bool, strength: Int })
\*   | Beer({ malt: Str, strength: Int });
\*
\* @type: $drink => Int;
GetStrength(drink) == drink.strength
    
    


====