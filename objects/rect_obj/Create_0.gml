format = CASTER_FORMAT.PAIRS;
vertices = GetRectShadowVertices();
vertices_count = array_length(vertices);
global.pLightingManager.RegisterCaster(id, CASTER.STATIC);