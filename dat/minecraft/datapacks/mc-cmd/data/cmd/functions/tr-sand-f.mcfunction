# north:
execute if entity @s[y_rotation=140..220] run fill ~4 ~4 ~ ~-4 ~-4 ~-8 sand replace dirt
execute if entity @s[y_rotation=140..220] run fill ~4 ~4 ~ ~-4 ~-4 ~-8 sand replace grass_block
execute if entity @s[y_rotation=140..220] run fill ~4 ~4 ~ ~-4 ~-4 ~-8 sand replace gravel
execute if entity @s[y_rotation=140..220] run fill ~4 ~4 ~ ~-4 ~-4 ~-8 sandstone replace stone
# east:
execute if entity @s[y_rotation=-130..-50] run fill ~ ~4 ~4 ~8 ~-4 ~-4 sand replace dirt
execute if entity @s[y_rotation=-130..-50] run fill ~ ~4 ~4 ~8 ~-4 ~-4 sand replace grass_block
execute if entity @s[y_rotation=-130..-50] run fill ~ ~4 ~4 ~8 ~-4 ~-4 sand replace gravel
execute if entity @s[y_rotation=-130..-50] run fill ~ ~4 ~4 ~8 ~-4 ~-4 sandstone replace stone
# south:
execute if entity @s[y_rotation=-40..40] run fill ~4 ~4 ~ ~-4 ~-4 ~8 sand replace dirt
execute if entity @s[y_rotation=-40..40] run fill ~4 ~4 ~ ~-4 ~-4 ~8 sand replace grass_block
execute if entity @s[y_rotation=-40..40] run fill ~4 ~4 ~ ~-4 ~-4 ~8 sand replace gravel
execute if entity @s[y_rotation=-40..40] run fill ~4 ~4 ~ ~-4 ~-4 ~8 sandstone replace stone
# west:
execute if entity @s[y_rotation=50..130] run fill ~ ~4 ~4 ~-8 ~-4 ~-4 sand replace dirt
execute if entity @s[y_rotation=50..130] run fill ~ ~4 ~4 ~-8 ~-4 ~-4 sand replace grass_block
execute if entity @s[y_rotation=50..130] run fill ~ ~4 ~4 ~-8 ~-4 ~-4 sand replace gravel
execute if entity @s[y_rotation=50..130] run fill ~ ~4 ~4 ~-8 ~-4 ~-4 sandstone replace stone
