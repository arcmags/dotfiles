# north:
execute if entity @s[y_rotation=140..220] run fill ~4 ~2 ~-1 ~-4 ~-6 ~-2 stone keep
execute if entity @s[y_rotation=140..220] run fill ~4 ~2 ~-1 ~-4 ~-6 ~-2 stone replace water
# east:
execute if entity @s[y_rotation=-130..-50] run fill ~1 ~2 ~4 ~1 ~-6 ~-4 stone keep
execute if entity @s[y_rotation=-130..-50] run fill ~1 ~2 ~4 ~1 ~-6 ~-4 stone replace water
# south:
execute if entity @s[y_rotation=-40..40] run fill ~4 ~2 ~1 ~-4 ~-6 ~1 stone keep
execute if entity @s[y_rotation=-40..40] run fill ~4 ~2 ~1 ~-4 ~-6 ~1 stone replace water
# west:
execute if entity @s[y_rotation=50..130] run fill ~-1 ~2 ~4 ~-1 ~-6 ~-4 stone keep
execute if entity @s[y_rotation=50..130] run fill ~-1 ~2 ~4 ~-1 ~-6 ~-4 stone replace water
