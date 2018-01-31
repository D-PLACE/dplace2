DPLACE2 = {};

DPLACE2.style = function(feature) {
    return {
            'color': '#000',
            'weight': 2,
            'opacity': 0.2,
            'fillOpacity': 0.1,
            'fillColor': '#fef'
    }
};

CLLD.LayerOptions.regions = {
    style: DPLACE2.style,
    onEachFeature: function(feature, layer) {
        layer.bindTooltip(feature.properties.REGION_NAM);
    }
};

