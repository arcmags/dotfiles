# north:
execute if entity @s[y_rotation=140..220] run fill ~16 ~16 ~ ~-16 ~-16 ~-16 dirt replace sand
execute if entity @s[y_rotation=140..220] run fill ~16 ~16 ~ ~-16 ~-16 ~-16 dirt replace gravel
execute if entity @s[y_rotation=140..220] run fill ~16 ~16 ~ ~-16 ~-16 ~-16 stone replace sandstone
# east:
execute if entity @s[y_rotation=-130..-50] run fill ~ ~16 ~16 ~16 ~-16 ~-16 dirt replace sand
execute if entity @s[y_rotation=-130..-50] run fill ~ ~16 ~16 ~16 ~-16 ~-16 dirt replace gravel
execute if entity @s[y_rotation=-130..-50] run fill ~ ~16 ~16 ~16 ~-16 ~-16 stone replace sandstone
# south:
execute if entity @s[y_rotation=-40..40] run fill ~16 ~16 ~ ~-16 ~-16 ~16 dirt replace sand
execute if entity @s[y_rotation=-40..40] run fill ~16 ~16 ~ ~-16 ~-16 ~16 dirt replace gravel
execute if entity @s[y_rotation=-40..40] run fill ~16 ~16 ~ ~-16 ~-16 ~16 stone replace sandstone
# west:
execute if entity @s[y_rotation=50..130] run fill ~ ~16 ~16 ~-16 ~-16 ~-16 dirt replace sand
execute if entity @s[y_rotation=50..130] run fill ~ ~16 ~16 ~-16 ~-16 ~-16 dirt replace gravel
execute if entity @s[y_rotation=50..130] run fill ~ ~16 ~16 ~-16 ~-16 ~-16 stone replace sandstone
