DPLACE2 = {};

DPLACE2.style = function (feature) {
    return {
        'color': '#000',
        'weight': 2,
        'opacity': 0.2,
        'fillOpacity': 0.1,
        'fillColor': '#fef'
    }
};

CLLD.LayerOptions.regions = {
    zoomToExtent: false,
    style: DPLACE2.style,
    onEachFeature: function (feature, layer) {
        layer.bindTooltip(feature.properties.REGION_NAM);
    }
};

CLLD.MapIcons.div = function (feature, size, url) {
    return L.divIcon({
        //html: '<div class="dplace-map-icon" style="background: ' + feature.properties.color + ';">☺</div>',
        html: '<div class="dplace-map-icon" style="background: ' + feature.properties.color + ';">&nbsp;</div>',
        className: 'clld-map-icon'
    });
};
