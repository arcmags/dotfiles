# north:
execute if entity @s[y_rotation=140..220] run fill ~8 ~2 ~-1 ~-8 ~-8 ~-2 stone keep
execute if entity @s[y_rotation=140..220] run fill ~8 ~2 ~-1 ~-8 ~-8 ~-2 stone replace water
# east:
execute if entity @s[y_rotation=-130..-50] run fill ~1 ~2 ~8 ~1 ~-8 ~-8 stone keep
execute if entity @s[y_rotation=-130..-50] run fill ~1 ~2 ~8 ~1 ~-8 ~-8 stone replace water
# south:
execute if entity @s[y_rotation=-40..40] run fill ~8 ~2 ~1 ~-8 ~-8 ~1 stone keep
execute if entity @s[y_rotation=-40..40] run fill ~8 ~2 ~1 ~-8 ~-8 ~1 stone replace water
# west:
execute if entity @s[y_rotation=50..130] run fill ~-1 ~2 ~8 ~-1 ~-8 ~-8 stone keep
execute if entity @s[y_rotation=50..130] run fill ~-1 ~2 ~8 ~-1 ~-8 ~-8 stone replace water
