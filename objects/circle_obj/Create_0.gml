format = CASTER_FORMAT.PAIRS;
vertices = GetCircleShadowVertices(32);
vertices_count = array_length(vertices);
global.pLightingManager.RegisterCaster(id, CASTER.STATIC);