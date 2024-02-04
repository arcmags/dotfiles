# north:
execute if entity @s[y_rotation=140..220] run fill ~16 ~16 ~ ~-16 ~-16 ~-16 sand replace dirt
execute if entity @s[y_rotation=140..220] run fill ~16 ~16 ~ ~-16 ~-16 ~-16 sand replace grass_block
execute if entity @s[y_rotation=140..220] run fill ~16 ~16 ~ ~-16 ~-16 ~-16 sand replace gravel
execute if entity @s[y_rotation=140..220] run fill ~16 ~16 ~ ~-16 ~-16 ~-16 sandstone replace stone
# east:
execute if entity @s[y_rotation=-130..-50] run fill ~ ~16 ~16 ~16 ~-16 ~-16 sand replace dirt
execute if entity @s[y_rotation=-130..-50] run fill ~ ~16 ~16 ~16 ~-16 ~-16 sand replace grass_block
execute if entity @s[y_rotation=-130..-50] run fill ~ ~16 ~16 ~16 ~-16 ~-16 sand replace gravel
execute if entity @s[y_rotation=-130..-50] run fill ~ ~16 ~16 ~16 ~-16 ~-16 sandstone replace stone
# south:
execute if entity @s[y_rotation=-40..40] run fill ~16 ~16 ~ ~-16 ~-16 ~16 sand replace dirt
execute if entity @s[y_rotation=-40..40] run fill ~16 ~16 ~ ~-16 ~-16 ~16 sand replace grass_block
execute if entity @s[y_rotation=-40..40] run fill ~16 ~16 ~ ~-16 ~-16 ~16 sand replace gravel
execute if entity @s[y_rotation=-40..40] run fill ~16 ~16 ~ ~-16 ~-16 ~16 sandstone replace stone
# west:
execute if entity @s[y_rotation=50..130] run fill ~ ~16 ~16 ~-16 ~-16 ~-16 sand replace dirt
execute if entity @s[y_rotation=50..130] run fill ~ ~16 ~16 ~-16 ~-16 ~-16 sand replace grass_block
execute if entity @s[y_rotation=50..130] run fill ~ ~16 ~16 ~-16 ~-16 ~-16 sand replace gravel
execute if entity @s[y_rotation=50..130] run fill ~ ~16 ~16 ~-16 ~-16 ~-16 sandstone replace stone
