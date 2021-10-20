profiler.Start();

global.pLightingManager.Render();

var l = surface_getpixel(global.pLightingManager.lighting_surfaces[LIGHTING_SURFACE.FINAL], 0, 0);

profiler.End();